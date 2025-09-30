package com.petcaresystem.dao;

import com.petcaresystem.enities.Account;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class AccountDAO {
    public List<Account> getAccount() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Account> accounts = session.createQuery("from Account").list();
        return accounts;
    }

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccount();
        accounts.forEach(System.out::println);
    }
}
