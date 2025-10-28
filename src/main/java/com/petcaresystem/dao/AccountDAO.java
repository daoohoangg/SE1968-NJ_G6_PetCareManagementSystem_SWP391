package com.petcaresystem.dao;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.*;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.hibernate.Transaction;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AccountDAO {
    public List<Account> getAccount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Query all concrete account types since Account is abstract with JOINED inheritance
            List<Account> accounts = new ArrayList<>();
            
            // Get Customer accounts
            List<Customer> customers = session.createQuery("from Customer c where c.isDeleted = false", Customer.class).list();
            accounts.addAll(customers);
            
            // Get Staff accounts
            List<Staff> staff = session.createQuery("from Staff s where s.isDeleted = false", Staff.class).list();
            accounts.addAll(staff);
            
            // Get Receptionist accounts
            List<Receptionist> receptionists = session.createQuery("from Receptionist r where r.isDeleted = false", Receptionist.class).list();
            accounts.addAll(receptionists);
            
            // Get Administration accounts
            List<Administration> admins = session.createQuery("from Administration a where a.isDeleted = false", Administration.class).list();
            accounts.addAll(admins);
            
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
            
            // Build WHERE clause for concrete classes
            StringBuilder where = new StringBuilder(" WHERE a.isDeleted = false");
            if (normalizedKeyword != null) {
                where.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (normalizedRole != null) {
                where.append(" AND a.role = :roleFilter");
            }

            // Query all concrete account types
            List<Account> allAccounts = new ArrayList<>();
            long totalCount = 0;

            // Get Customer accounts
            String customerCountHql = "SELECT COUNT(c.accountId) FROM Customer c" + where;
            String customerDataHql = "FROM Customer c" + where + " ORDER BY c.accountId DESC";
            
            Query<Long> customerCountQuery = session.createQuery(customerCountHql, Long.class);
            Query<Customer> customerDataQuery = session.createQuery(customerDataHql, Customer.class);

            if (normalizedKeyword != null) {
                String kw = "%" + normalizedKeyword + "%";
                customerCountQuery.setParameter("kw", kw);
                customerDataQuery.setParameter("kw", kw);
            }
            if (normalizedRole != null) {
                com.petcaresystem.enities.enu.AccountRoleEnum enumRole =
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole);
                customerCountQuery.setParameter("roleFilter", enumRole);
                customerDataQuery.setParameter("roleFilter", enumRole);
            }
            
            long customerCount = customerCountQuery.uniqueResultOptional().orElse(0L);
            List<Customer> customers = customerDataQuery.list();
            allAccounts.addAll(customers);
            totalCount += customerCount;

            // Get Staff accounts
            String staffCountHql = "SELECT COUNT(s.accountId) FROM Staff s" + where;
            String staffDataHql = "FROM Staff s" + where + " ORDER BY s.accountId DESC";
            
            Query<Long> staffCountQuery = session.createQuery(staffCountHql, Long.class);
            Query<Staff> staffDataQuery = session.createQuery(staffDataHql, Staff.class);
            
            if (normalizedKeyword != null) {
                String kw = "%" + normalizedKeyword + "%";
                staffCountQuery.setParameter("kw", kw);
                staffDataQuery.setParameter("kw", kw);
            }
            if (normalizedRole != null) {
                com.petcaresystem.enities.enu.AccountRoleEnum enumRole =
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole);
                staffCountQuery.setParameter("roleFilter", enumRole);
                staffDataQuery.setParameter("roleFilter", enumRole);
            }
            
            long staffCount = staffCountQuery.uniqueResultOptional().orElse(0L);
            List<Staff> staff = staffDataQuery.list();
            allAccounts.addAll(staff);
            totalCount += staffCount;

            // Get Receptionist accounts
            String receptionistCountHql = "SELECT COUNT(r.accountId) FROM Receptionist r" + where;
            String receptionistDataHql = "FROM Receptionist r" + where + " ORDER BY r.accountId DESC";
            
            Query<Long> receptionistCountQuery = session.createQuery(receptionistCountHql, Long.class);
            Query<Receptionist> receptionistDataQuery = session.createQuery(receptionistDataHql, Receptionist.class);
            
            if (normalizedKeyword != null) {
                String kw = "%" + normalizedKeyword + "%";
                receptionistCountQuery.setParameter("kw", kw);
                receptionistDataQuery.setParameter("kw", kw);
            }
            if (normalizedRole != null) {
                com.petcaresystem.enities.enu.AccountRoleEnum enumRole =
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole);
                receptionistCountQuery.setParameter("roleFilter", enumRole);
                receptionistDataQuery.setParameter("roleFilter", enumRole);
            }
            
            long receptionistCount = receptionistCountQuery.uniqueResultOptional().orElse(0L);
            List<Receptionist> receptionists = receptionistDataQuery.list();
            allAccounts.addAll(receptionists);
            totalCount += receptionistCount;

            // Get Administration accounts
            String adminCountHql = "SELECT COUNT(a.accountId) FROM Administration a" + where;
            String adminDataHql = "FROM Administration a" + where + " ORDER BY a.accountId DESC";
            
            Query<Long> adminCountQuery = session.createQuery(adminCountHql, Long.class);
            Query<Administration> adminDataQuery = session.createQuery(adminDataHql, Administration.class);
            
            if (normalizedKeyword != null) {
                String kw = "%" + normalizedKeyword + "%";
                adminCountQuery.setParameter("kw", kw);
                adminDataQuery.setParameter("kw", kw);
            }
            if (normalizedRole != null) {
                com.petcaresystem.enities.enu.AccountRoleEnum enumRole =
                        com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole);
                adminCountQuery.setParameter("roleFilter", enumRole);
                adminDataQuery.setParameter("roleFilter", enumRole);
            }
            
            long adminCount = adminCountQuery.uniqueResultOptional().orElse(0L);
            List<Administration> admins = adminDataQuery.list();
            allAccounts.addAll(admins);
            totalCount += adminCount;

            // Sort all accounts by accountId DESC
            allAccounts.sort((a, b) -> Long.compare(b.getAccountId(), a.getAccountId()));

            // Apply pagination
            int startIndex = (safePage - 1) * safeSize;
            int endIndex = Math.min(startIndex + safeSize, allAccounts.size());
            List<Account> pagedAccounts = allAccounts.subList(startIndex, endIndex);

            System.out.println("Total accounts found: " + totalCount);
            System.out.println("Paged accounts size: " + pagedAccounts.size());
            
            return new PagedResult<>(pagedAccounts, totalCount, safePage, safeSize);
        } catch (Exception e) {
            e.printStackTrace();
            return new PagedResult<>(Collections.emptyList(), 0L, safePage, safeSize);
        }
    }

    public AccountStats computeStats(String keyword, String role) {
        String normalizedKeyword = normalizeKeyword(keyword);
        String normalizedRole = normalizeRole(role);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Build WHERE clause for concrete classes
            StringBuilder where = new StringBuilder(" WHERE a.isDeleted = false");
            if (normalizedKeyword != null) {
                where.append(" AND (lower(a.fullName) like :kw OR lower(a.email) like :kw OR lower(a.username) like :kw)");
            }
            if (normalizedRole != null) {
                where.append(" AND a.role = :roleFilter");
            }

            long total = 0;
            long active = 0;
            long admin = 0;
            long staff = 0;
            long customer = 0;

            // Count Customer accounts
            String customerHql = "SELECT COUNT(c.accountId), SUM(CASE WHEN c.isActive = true THEN 1 ELSE 0 END) FROM Customer c" + where;
            Query<Object[]> customerQuery = session.createQuery(customerHql, Object[].class);
            if (normalizedKeyword != null) {
                customerQuery.setParameter("kw", "%" + normalizedKeyword + "%");
            }
            if (normalizedRole != null) {
                customerQuery.setParameter("roleFilter", com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole));
            }
            Object[] customerRow = customerQuery.uniqueResult();
            long customerCount = customerRow != null && customerRow[0] != null ? ((Number) customerRow[0]).longValue() : 0L;
            long customerActive = customerRow != null && customerRow[1] != null ? ((Number) customerRow[1]).longValue() : 0L;
            total += customerCount;
            active += customerActive;
            customer += customerCount;

            // Count Staff accounts
            String staffHql = "SELECT COUNT(s.accountId), SUM(CASE WHEN s.isActive = true THEN 1 ELSE 0 END) FROM Staff s" + where;
            Query<Object[]> staffQuery = session.createQuery(staffHql, Object[].class);
            if (normalizedKeyword != null) {
                staffQuery.setParameter("kw", "%" + normalizedKeyword + "%");
            }
            if (normalizedRole != null) {
                staffQuery.setParameter("roleFilter", com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole));
            }
            Object[] staffRow = staffQuery.uniqueResult();
            long staffCount = staffRow != null && staffRow[0] != null ? ((Number) staffRow[0]).longValue() : 0L;
            long staffActive = staffRow != null && staffRow[1] != null ? ((Number) staffRow[1]).longValue() : 0L;
            total += staffCount;
            active += staffActive;
            staff += staffCount;

            // Count Receptionist accounts
            String receptionistHql = "SELECT COUNT(r.accountId), SUM(CASE WHEN r.isActive = true THEN 1 ELSE 0 END) FROM Receptionist r" + where;
            Query<Object[]> receptionistQuery = session.createQuery(receptionistHql, Object[].class);
            if (normalizedKeyword != null) {
                receptionistQuery.setParameter("kw", "%" + normalizedKeyword + "%");
            }
            if (normalizedRole != null) {
                receptionistQuery.setParameter("roleFilter", com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole));
            }
            Object[] receptionistRow = receptionistQuery.uniqueResult();
            long receptionistCount = receptionistRow != null && receptionistRow[0] != null ? ((Number) receptionistRow[0]).longValue() : 0L;
            long receptionistActive = receptionistRow != null && receptionistRow[1] != null ? ((Number) receptionistRow[1]).longValue() : 0L;
            total += receptionistCount;
            active += receptionistActive;

            // Count Administration accounts
            String adminHql = "SELECT COUNT(a.accountId), SUM(CASE WHEN a.isActive = true THEN 1 ELSE 0 END) FROM Administration a" + where;
            Query<Object[]> adminQuery = session.createQuery(adminHql, Object[].class);
            if (normalizedKeyword != null) {
                adminQuery.setParameter("kw", "%" + normalizedKeyword + "%");
            }
            if (normalizedRole != null) {
                adminQuery.setParameter("roleFilter", com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(normalizedRole));
            }
            Object[] adminRow = adminQuery.uniqueResult();
            long adminCount = adminRow != null && adminRow[0] != null ? ((Number) adminRow[0]).longValue() : 0L;
            long adminActive = adminRow != null && adminRow[1] != null ? ((Number) adminRow[1]).longValue() : 0L;
            total += adminCount;
            active += adminActive;
            admin += adminCount;

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
