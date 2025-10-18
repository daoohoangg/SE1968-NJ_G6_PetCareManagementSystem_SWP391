package com.petcaresystem.dao;

import com.petcaresystem.enities.ServiceCategory;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ServiceCategoryDAO {

    /** Lấy tất cả category, sắp xếp theo name */
    public List<ServiceCategory> getAll() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                    "FROM ServiceCategory c ORDER BY c.name",
                    ServiceCategory.class
            ).list();
        }
    }

    /** Lấy category theo id */
    public ServiceCategory getById(int id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(ServiceCategory.class, id);
        }
    }

    /** Lấy category theo name (unique) */
    public ServiceCategory getByName(String name) {
        if (name == null || name.isBlank()) return null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.createQuery(
                            "FROM ServiceCategory c WHERE LOWER(c.name) = :n",
                            ServiceCategory.class
                    ).setParameter("n", name.trim().toLowerCase())
                    .uniqueResult();
        }
    }

    /** Kiểm tra trùng tên (excludeId dùng cho update) */
    public boolean existsByName(String name, Integer excludeId) {
        if (name == null || name.isBlank()) return false;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(c.categoryId) FROM ServiceCategory c " +
                    "WHERE LOWER(c.name) = :n " +
                    (excludeId != null ? "AND c.categoryId <> :id" : "");
            Query<Long> q = s.createQuery(hql, Long.class)
                    .setParameter("n", name.trim().toLowerCase());
            if (excludeId != null) q.setParameter("id", excludeId);
            Long cnt = q.uniqueResult();
            return cnt != null && cnt > 0;
        }
    }

    /** Tìm kiếm theo keyword (name/description) */
    public List<ServiceCategory> search(String keyword) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM ServiceCategory c WHERE 1=1 ");
            if (keyword != null && !keyword.isBlank()) {
                hql.append("AND (LOWER(c.name) LIKE :kw OR LOWER(c.description) LIKE :kw) ");
            }
            hql.append("ORDER BY c.name");
            Query<ServiceCategory> q = s.createQuery(hql.toString(), ServiceCategory.class);
            if (keyword != null && !keyword.isBlank()) {
                q.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            return q.list();
        }
    }

    /** Tạo category mới (validate trùng tên tối thiểu ở tầng DAO) */
    public boolean create(ServiceCategory c) {
        if (c == null || c.getName() == null || c.getName().trim().isEmpty()) return false;
        if (existsByName(c.getName(), null)) return false;

        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.persist(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Cập nhật category (tránh trùng tên với bản ghi khác) */
    public boolean update(ServiceCategory c) {
        if (c == null || c.getCategoryId() <= 0) return false;
        if (c.getName() == null || c.getName().trim().isEmpty()) return false;
        if (existsByName(c.getName(), c.getCategoryId())) return false;

        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /**
     * Xoá an toàn: KHÔNG xoá nếu category đang có Service con.
     * Lưu ý: bạn đang để orphanRemoval=true trên @OneToMany ở ServiceCategory.
     * Nếu gọi remove() trực tiếp, tất cả Service con sẽ bị xoá theo — thường không mong muốn.
     */
    public boolean deleteSafely(int id) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            ServiceCategory c = s.get(ServiceCategory.class, id);
            if (c == null) {
                tx.rollback();
                return false;
            }
            // Kiểm tra có Service con không (đếm nhanh)
            Long countChild = s.createQuery(
                    "SELECT COUNT(s.serviceId) FROM Service s WHERE s.category.categoryId = :cid",
                    Long.class
            ).setParameter("cid", id).uniqueResult();

            if (countChild != null && countChild > 0) {
                tx.rollback(); // không xoá khi còn con
                return false;
            }

            s.remove(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** (Tuỳ chọn) Xoá thẳng tay: SẼ xoá luôn các Service con do orphanRemoval=true — cực kỳ thận trọng. */
    public boolean deleteCascade(int id) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            ServiceCategory c = s.get(ServiceCategory.class, id);
            if (c == null) {
                tx.rollback();
                return false;
            }
            s.remove(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }
}
