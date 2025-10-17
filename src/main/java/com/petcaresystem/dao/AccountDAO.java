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
        query.setParameter("password", password);
        Account account = query.uniqueResult();
        session.close();
        return account;
    }
    public Account loginWithEmail(String email, String password) { //login bằng email
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Account> query = session.createQuery(
                    "FROM Account WHERE email = :email", Account.class);
            query.setParameter("email", email);
            query.setParameter("password", password);
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
    public Account findByVerificationToken(String token) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Account WHERE verificationToken = :token";
            Query<Account> query = session.createQuery(hql, Account.class);
            query.setParameter("token", token);
            return query.uniqueResultOptional().orElse(null);
        }
    }

    public Account findById(int id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Account.class, id);
        }
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


    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccount();
        accounts.forEach(System.out::println);
    }
}
