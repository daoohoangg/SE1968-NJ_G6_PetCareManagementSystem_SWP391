package com.petcaresystem.dao;

import com.petcaresystem.dto.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.Account;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.hibernate.Transaction;
import java.util.Collections;
import java.util.List;

public class AccountDAO {
    public List<Account> getAccount() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Account> accounts = session.createQuery("from Account").list();
        return accounts;
    }

    public Account login(String username, String password) { //login bằng username
        Session session = HibernateUtil.getSessionFactory().openSession();
        Query<Account> query = session.createQuery(
                "FROM Account WHERE username = :username", Account.class);
        query.setParameter("username", username);
        Account account = query.uniqueResult();
        session.close();
        return account;
    }
    public Account loginWithEmail(String email, String password) { //login bằng email
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Account> query = session.createQuery(
                    "FROM Account WHERE email = :email", Account.class);
            query.setParameter("email", email);
            return query.uniqueResult();
        }
    }
    public boolean register(Account account) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(account);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
    public boolean changePassword(int accountId, String newPassword) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Account acc = session.get(Account.class, accountId);
            if (acc != null) {
                acc.setPassword(newPassword);
                session.merge(acc);
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
    public Account getAccountByEmailOrUsername(String input) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE username = :input OR email = :input";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("input", input);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Account findByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE username = :username";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public Account findByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE email = :email";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("email", email);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public PagedResult<Account> findAccounts(String keyword, String role, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        String normalizedKeyword = normalizeKeyword(keyword);
        String normalizedRole = normalizeRole(role);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder where = new StringBuilder(" WHERE 1=1");
            if (normalizedKeyword != null) {
                where.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (normalizedRole != null) {
                where.append(" AND a.role = :roleFilter");
            }

            Query<Long> countQuery = session.createQuery(
                    "SELECT COUNT(a.accountId) FROM Account a" + where,
                    Long.class
            );
            Query<Account> dataQuery = session.createQuery(
                    "FROM Account a" + where + " ORDER BY a.accountId DESC",
                    Account.class
            );

            if (normalizedKeyword != null) {
                String kw = "%" + normalizedKeyword + "%";
                countQuery.setParameter("kw", kw);
                dataQuery.setParameter("kw", kw);
            }
            if (normalizedRole != null) {
                com.petcaresystem.enities.enu.AccountRoleEnum enumRole =
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole);
                countQuery.setParameter("roleFilter", enumRole);
                dataQuery.setParameter("roleFilter", enumRole);
            }

            dataQuery.setFirstResult((safePage - 1) * safeSize);
            dataQuery.setMaxResults(safeSize);

            List<Account> results = dataQuery.list();
            long total = countQuery.uniqueResultOptional().orElse(0L);
            return new PagedResult<>(results, total, safePage, safeSize);
        } catch (Exception e) {
            e.printStackTrace();
            return new PagedResult<>(Collections.emptyList(), 0L, safePage, safeSize);
        }
    }

    public AccountStats computeStats(String keyword, String role) {
        String normalizedKeyword = normalizeKeyword(keyword);
        String normalizedRole = normalizeRole(role);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT " +
                            "COUNT(a.accountId), " +
                            "SUM(CASE WHEN a.isActive = true THEN 1 ELSE 0 END), " +
                            "SUM(CASE WHEN a.role = :adminRole THEN 1 ELSE 0 END), " +
                            "SUM(CASE WHEN a.role = :staffRole THEN 1 ELSE 0 END), " +
                            "SUM(CASE WHEN a.role = :customerRole THEN 1 ELSE 0 END) " +
                            "FROM Account a WHERE 1=1"
            );

            if (normalizedKeyword != null) {
                hql.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (normalizedRole != null) {
                hql.append(" AND a.role = :roleFilter");
            }

            Query<Object[]> query = session.createQuery(hql.toString(), Object[].class);

            if (normalizedKeyword != null) {
                query.setParameter("kw", "%" + normalizedKeyword + "%");
            }

            com.petcaresystem.enities.enu.AccountRoleEnum adminRole = com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN;
            com.petcaresystem.enities.enu.AccountRoleEnum staffRole = com.petcaresystem.enities.enu.AccountRoleEnum.STAFF;
            com.petcaresystem.enities.enu.AccountRoleEnum customerRole = com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER;
            query.setParameter("adminRole", adminRole);
            query.setParameter("staffRole", staffRole);
            query.setParameter("customerRole", customerRole);

            if (normalizedRole != null) {
                query.setParameter("roleFilter",
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole));
            }

            Object[] row = query.uniqueResult();
            long total = row != null && row[0] != null ? ((Number) row[0]).longValue() : 0L;
            long active = row != null && row[1] != null ? ((Number) row[1]).longValue() : 0L;
            long admin = row != null && row[2] != null ? ((Number) row[2]).longValue() : 0L;
            long staff = row != null && row[3] != null ? ((Number) row[3]).longValue() : 0L;
            long customer = row != null && row[4] != null ? ((Number) row[4]).longValue() : 0L;

            return new AccountStats(total, active, admin, staff, customer);
        } catch (Exception e) {
            e.printStackTrace();
            return new AccountStats(0, 0, 0, 0, 0);
        }
    }

    public List<Account> searchAccounts(String keyword, String role) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Account a WHERE 1=1 ");
            if (keyword != null && !keyword.isBlank()) {
                hql.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (role != null && !role.isBlank() && !role.equalsIgnoreCase("all")) {
                hql.append(" AND a.role = :role");
            }
            hql.append(" ORDER BY a.accountId DESC");

            Query<Account> query = session.createQuery(hql.toString(), Account.class);
            if (keyword != null && !keyword.isBlank()) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                query.setParameter("kw", kw);
            }
            if (role != null && !role.isBlank() && !role.equalsIgnoreCase("all")) {
                // role expected as enum name
                query.setParameter("role", com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(role.toUpperCase()));
            }
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }
    public Account findByVerificationToken(String token) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE verificationToken = :token";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("token", token);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public Account findById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Account.class, id);
        }
    }
    public Account findById(int id) {                // giữ tương thích cũ
        return findById((long) id);
    }

    public boolean updateAccount(Account account) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            s.merge(account);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteById(Long accountId) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Account acc = s.get(Account.class, Long.valueOf(accountId));
            if (acc != null) {
                s.remove(acc);
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
    public boolean deleteById(int accountId) {       // giữ tương thích cũ
        return deleteById((long) accountId);
    }


    private String normalizeKeyword(String keyword) {
        if (keyword == null) return null;
        String trimmed = keyword.trim().toLowerCase();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String normalizeRole(String role) {
        if (role == null) return null;
        String trimmed = role.trim();
        if (trimmed.isEmpty()) return null;
        if ("all".equalsIgnoreCase(trimmed)) return null;
        return trimmed.toUpperCase();
    }

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccount();
        accounts.forEach(System.out::println);
    }
}
