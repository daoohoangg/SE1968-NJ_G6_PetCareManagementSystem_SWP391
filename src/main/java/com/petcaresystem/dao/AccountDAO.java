package com.petcaresystem.dao;

import com.petcaresystem.enities.Account;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.hibernate.Transaction;
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


    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccount();
        accounts.forEach(System.out::println);
    }
}
