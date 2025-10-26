package com.petcaresystem.dao;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.Voucher;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Voucher v ORDER BY v.createdAt DESC", Voucher.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public PagedResult<Voucher> findPage(int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> countQuery = session.createQuery("SELECT COUNT(v.voucherId) FROM Voucher v", Long.class);
            long total = countQuery.uniqueResultOptional().orElse(0L);
            if (total == 0) {
                return new PagedResult<>(Collections.emptyList(), 0, safePage, safeSize);
            }

            Query<Voucher> dataQuery = session.createQuery(
                    "FROM Voucher v ORDER BY v.createdAt DESC",
                    Voucher.class
            );
            dataQuery.setFirstResult((safePage - 1) * safeSize);
            dataQuery.setMaxResults(safeSize);
            List<Voucher> vouchers = dataQuery.list();
            return new PagedResult<>(vouchers, total, safePage, safeSize);
        } catch (Exception e) {
            e.printStackTrace();
            return new PagedResult<>(Collections.emptyList(), 0, safePage, safeSize);
        }
    }

    public Voucher findById(Long id) {
        if (id == null) return null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Voucher.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Voucher findByCode(String code) {
        if (code == null) return null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Voucher> query = session.createQuery(
                    "FROM Voucher v WHERE lower(v.code) = :code", Voucher.class);
            query.setParameter("code", code.trim().toLowerCase());
            return query.uniqueResultOptional().orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean save(Voucher voucher) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(voucher);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Voucher voucher) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(voucher);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(Long id) {
        if (id == null) return false;
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Voucher voucher = session.get(Voucher.class, id);
            if (voucher != null) {
                session.remove(voucher);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}

