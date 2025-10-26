package com.petcaresystem.dao;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.*;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.hibernate.Transaction;
import java.util.Collections;
import java.util.List;

public class AccountDAO {
    public List<Account> getAccount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Account> accounts = session.createQuery("from Account a where a.isDeleted = false", Account.class).list();
            return accounts;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public Account login(String username, String password) { //login bằng username
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Account> query = session.createQuery(
                    "FROM Account WHERE username = :username AND isDeleted = false", Account.class);
            query.setParameter("username", username);
            Account account = query.uniqueResult();
            return account;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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
            String hql = "FROM Account WHERE (username = :input OR email = :input) AND isDeleted = false";
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
            String hql = "FROM Account WHERE username = :username AND isDeleted = false";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("username", username);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public Account findByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE email = :email AND isDeleted = false";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("email", email);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public PagedResult<Account> findAccounts(String keyword, String role, int page, int pageSize) {
        System.out.println("findAccounts called with keyword: " + keyword + ", role: " + role + ", page: " + page + ", size: " + pageSize);
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        String normalizedKeyword = normalizeKeyword(keyword);
        String normalizedRole = normalizeRole(role);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            System.out.println("Session opened successfully");
            StringBuilder where = new StringBuilder(" WHERE a.isDeleted = false");
            if (normalizedKeyword != null) {
                where.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (normalizedRole != null) {
                where.append(" AND a.role = :roleFilter");
            }

            String countHql = "SELECT COUNT(a.accountId) FROM Account a" + where;
            String dataHql = "FROM Account a" + where + " ORDER BY a.accountId DESC";
            System.out.println("Count HQL: " + countHql);
            System.out.println("Data HQL: " + dataHql);
            
            Query<Long> countQuery = session.createQuery(countHql, Long.class);
            Query<Account> dataQuery = session.createQuery(dataHql, Account.class);

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

            System.out.println("Executing count query...");
            long total = countQuery.uniqueResultOptional().orElse(0L);
            System.out.println("Count result: " + total);
            
            System.out.println("Executing data query...");
            List<Account> results = dataQuery.list();
            System.out.println("Data result size: " + results.size());
            
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
                            "FROM Account a WHERE a.isDeleted = false"
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
            StringBuilder hql = new StringBuilder("FROM Account a WHERE a.isDeleted = false ");
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
            String hql = "FROM Account WHERE verificationToken = :token AND isDeleted = false";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("token", token);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public Account findById(Long id) {
        System.out.println("AccountDAO.findById called with id: " + id);
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Account account = s.get(Account.class, id);
            System.out.println("Raw account from DB: " + (account != null ? account.getUsername() + ", isDeleted: " + account.getIsDeleted() : "null"));
            
            // Only return account if it's not deleted
            if (account != null && !account.getIsDeleted()) {
                System.out.println("Returning account (not deleted)");
                return account;
            } else if (account != null) {
                System.out.println("Account is deleted, returning null");
            } else {
                System.out.println("Account not found in DB");
            }
            return null;
        }
    }
    public Account findById(int id) {                // giữ tương thích cũ
        return findById((long) id);
    }

    // Method to find account including deleted ones (for admin purposes)
    public Account findByIdIncludingDeleted(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Account.class, id);
        }
    }

    public boolean updateAccount(Account account) {
        System.out.println("AccountDAO.updateAccount called for account: " + (account != null ? account.getUsername() : "null"));
        Transaction tx = null;
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();
            System.out.println("Session opened, transaction started");
            
            // Use HQL UPDATE to avoid unique constraint issues
            String hql = "UPDATE Account SET " +
                    "isActive = :isActive, " +
                    "isDeleted = :isDeleted, " +
                    "fullName = :fullName, " +
                    "email = :email, " +
                    "phone = :phone, " +
                    "role = :role, " +
                    "isVerified = :isVerified, " +
                    "verificationToken = :verificationToken, " +
                    "lastLogin = :lastLogin, " +
                    "updatedAt = :updatedAt " +
                    "WHERE accountId = :accountId";
            
            int updatedRows = s.createQuery(hql)
                    .setParameter("isActive", account.getIsActive())
                    .setParameter("isDeleted", account.getIsDeleted())
                    .setParameter("fullName", account.getFullName())
                    .setParameter("email", account.getEmail())
                    .setParameter("phone", account.getPhone())
                    .setParameter("role", account.getRole())
                    .setParameter("isVerified", account.getIsVerified())
                    .setParameter("verificationToken", account.getVerificationToken())
                    .setParameter("lastLogin", account.getLastLogin())
                    .setParameter("updatedAt", account.getUpdatedAt())
                    .setParameter("accountId", account.getAccountId())
                    .executeUpdate();
            
            System.out.println("Updated rows: " + updatedRows);
            
            tx.commit();
            System.out.println("Transaction committed successfully");
            return updatedRows > 0;
        } catch (Exception e) {
            System.err.println("Exception in updateAccount: " + e.getMessage());
            e.printStackTrace();
            
            if (tx != null) {
                try {
                    tx.rollback();
                    System.out.println("Transaction rolled back");
                } catch (Exception rollbackEx) {
                    System.err.println("Error during rollback: " + rollbackEx.getMessage());
                }
            }
            return false;
        } finally {
            if (s != null) {
                try {
                    s.close();
                    System.out.println("Session closed");
                } catch (Exception closeEx) {
                    System.err.println("Error closing session: " + closeEx.getMessage());
                }
            }
        }
    }

    public boolean deleteById(Long accountId) {
        System.out.println("AccountDAO.deleteById called with id: " + accountId);
        Transaction tx = null;
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();
            
            // Soft delete: just mark the account as deleted
            Account acc = s.get(Account.class, accountId);
            if (acc != null) {
                System.out.println("Soft deleting account: " + acc.getUsername());
                acc.setIsDeleted(true);
                s.merge(acc);
                tx.commit();
                System.out.println("Account soft deleted successfully");
                return true;
            } else {
                System.out.println("Account not found");
                tx.rollback();
                return false;
            }
        } catch (Exception e) {
            if (tx != null) {
                try {
                    tx.rollback();
                } catch (Exception rollbackEx) {
                    System.err.println("Error during rollback: " + rollbackEx.getMessage());
                }
            }
            System.out.println("Exception in deleteById: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (s != null) {
                try {
                    s.close();
                } catch (Exception closeEx) {
                    System.err.println("Error closing session: " + closeEx.getMessage());
                }
            }
        }
    }
    public boolean deleteById(int accountId) {       // giữ tương thích cũ
        return deleteById((long) accountId);
    }

    // Method to restore a soft-deleted account
    public boolean restoreAccount(Long accountId) {
        System.out.println("AccountDAO.restoreAccount called with id: " + accountId);
        Transaction tx = null;
        Session s = null;
        try {
            s = HibernateUtil.getSessionFactory().openSession();
            tx = s.beginTransaction();
            
            Account acc = s.get(Account.class, accountId);
            if (acc != null) {
                System.out.println("Restoring account: " + acc.getUsername());
                acc.setIsDeleted(false);
                s.merge(acc);
                tx.commit();
                System.out.println("Account restored successfully");
                return true;
            } else {
                System.out.println("Account not found");
                tx.rollback();
                return false;
            }
        } catch (Exception e) {
            if (tx != null) {
                try {
                    tx.rollback();
                } catch (Exception rollbackEx) {
                    System.err.println("Error during rollback: " + rollbackEx.getMessage());
                }
            }
            System.out.println("Exception in restoreAccount: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (s != null) {
                try {
                    s.close();
                } catch (Exception closeEx) {
                    System.err.println("Error closing session: " + closeEx.getMessage());
                }
            }
        }
    }

    // Method to get all accounts including deleted ones (for admin purposes)
    public List<Account> getAllAccountsIncludingDeleted() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Account> accounts = session.createQuery("from Account", Account.class).list();
            return accounts;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
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
