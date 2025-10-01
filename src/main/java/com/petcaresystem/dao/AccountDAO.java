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

    public Account login(String username, String password) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Query<Account> query = session.createQuery(
                "FROM Account WHERE username = :username AND password = :password", Account.class);
        query.setParameter("username", username);
        query.setParameter("password", password);
        Account account = query.uniqueResult();
        session.close();
        return account;
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

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccount();
        accounts.forEach(System.out::println);
    }
}
