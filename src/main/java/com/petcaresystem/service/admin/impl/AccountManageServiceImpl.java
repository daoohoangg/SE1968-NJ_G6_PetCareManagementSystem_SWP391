package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.dto.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.Account;
import com.petcaresystem.service.admin.IAccountManageService;

import java.util.ArrayList;
import java.util.List;

public class AccountManageServiceImpl implements IAccountManageService {

    private final AccountDAO accountDAO;

    public AccountManageServiceImpl() {
        this.accountDAO = new AccountDAO();
    }

    @Override
    public List<Account> getAllAccounts() {
        List<Account> accounts = accountDAO.getAccount();
        return accounts != null ? accounts : new ArrayList<>();
    }

    @Override
    public Account getAccountById(int accountId) {
        return accountDAO.findById(accountId);
    }

    @Override
    public List<Account> searchAccounts(String keyword, String role) {
        return accountDAO.searchAccounts(keyword, role);
    }

    @Override
    public PagedResult<Account> getAccountsPage(String keyword, String role, int page, int pageSize) {
        return accountDAO.findAccounts(keyword, role, page, pageSize);
    }

    @Override
    public AccountStats getAccountStats(String keyword, String role) {
        return accountDAO.computeStats(keyword, role);
    }

    @Override
    public com.petcaresystem.dto.OperationResult createAccount(Account a) {
        // basic validation
        if (a.getUsername() == null || a.getUsername().isBlank()) {
            return new com.petcaresystem.dto.OperationResult(false, "Username is required");
        }
        if (a.getEmail() == null || a.getEmail().isBlank()) {
            return new com.petcaresystem.dto.OperationResult(false, "Email is required");
        }
        Account byUsername = accountDAO.findByUsername(a.getUsername());
        if (byUsername != null) return new com.petcaresystem.dto.OperationResult(false, "Username already exists");
        Account byEmail = accountDAO.findByEmail(a.getEmail());
        if (byEmail != null) return new com.petcaresystem.dto.OperationResult(false, "Email already exists");

        boolean ok = accountDAO.register(a);
        return new com.petcaresystem.dto.OperationResult(ok, ok ? "Account created" : "Failed to create account");
    }

    @Override
    public com.petcaresystem.dto.OperationResult updateAccount(Account a) {
        if (a.getAccountId() == null) return new com.petcaresystem.dto.OperationResult(false, "Account id is required");
        // check username/email uniqueness excluding self
        Account byUsername = accountDAO.findByUsername(a.getUsername());
        if (byUsername != null && !byUsername.getAccountId().equals(a.getAccountId())) {
            return new com.petcaresystem.dto.OperationResult(false, "Username already in use");
        }
        Account byEmail = accountDAO.findByEmail(a.getEmail());
        if (byEmail != null && !byEmail.getAccountId().equals(a.getAccountId())) {
            return new com.petcaresystem.dto.OperationResult(false, "Email already in use");
        }
        boolean ok = accountDAO.updateAccount(a);
        return new com.petcaresystem.dto.OperationResult(ok, ok ? "Account updated" : "Failed to update account");
    }

    @Override
    public boolean lockAccount(int accountId) {
        Account a = accountDAO.findById(accountId);
        if (a == null) return false;
        a.setIsActive(false);
        return accountDAO.updateAccount(a);
    }

    @Override
    public boolean unlockAccount(int accountId) {
        Account a = accountDAO.findById(accountId);
        if (a == null) return false;
        a.setIsActive(true);
        return accountDAO.updateAccount(a);
    }

    @Override
    public boolean hardDeleteAccount(int accountId) {
        return accountDAO.deleteById(accountId);
    }
}
