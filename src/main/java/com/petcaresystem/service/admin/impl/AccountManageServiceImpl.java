package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.dto.pageable.OperationResult;
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
    public OperationResult createAccount(Account a) {
        // basic validation
        if (a.getUsername() == null || a.getUsername().isBlank()) {
            return new OperationResult(false, "Username is required");
        }
        if (a.getEmail() == null || a.getEmail().isBlank()) {
            return new OperationResult(false, "Email is required");
        }
        Account byUsername = accountDAO.findByUsername(a.getUsername());
        if (byUsername != null) return new OperationResult(false, "Username already exists");
        Account byEmail = accountDAO.findByEmail(a.getEmail());
        if (byEmail != null) return new OperationResult(false, "Email already exists");

        boolean ok = accountDAO.register(a);
        return new OperationResult(ok, ok ? "Account created" : "Failed to create account");
    }

    @Override
    public OperationResult updateAccount(Account a) {
        if (a.getAccountId() == null) return new OperationResult(false, "Account id is required");
        // check username/email uniqueness excluding self
        Account byUsername = accountDAO.findByUsername(a.getUsername());
        if (byUsername != null && !byUsername.getAccountId().equals(a.getAccountId())) {
            return new OperationResult(false, "Username already in use");
        }
        Account byEmail = accountDAO.findByEmail(a.getEmail());
        if (byEmail != null && !byEmail.getAccountId().equals(a.getAccountId())) {
            return new OperationResult(false, "Email already in use");
        }

        boolean ok = accountDAO.updateAccount(a);
        return new OperationResult(ok, ok ? "Account updated" : "Failed to update account");
    }

    @Override
    public boolean lockAccount(int accountId) {
        System.out.println("AccountManageServiceImpl.lockAccount called with id: " + accountId);
        
        // First try to find account normally
        Account a = accountDAO.findById(accountId);
        System.out.println("Found account (normal): " + (a != null ? a.getUsername() : "null"));
        
        // If not found, try including deleted ones
        if (a == null) {
            a = accountDAO.findByIdIncludingDeleted((long) accountId);
            System.out.println("Found account (including deleted): " + (a != null ? a.getUsername() + ", isDeleted: " + a.getIsDeleted() : "null"));
        }
        
        if (a == null) {
            System.out.println("Account not found, returning false");
            return false;
        }
        
        // Don't lock deleted accounts
        if (a.getIsDeleted()) {
            System.out.println("Cannot lock deleted account");
            return false;
        }
        
        System.out.println("Current isActive: " + a.getIsActive());
        a.setIsActive(false);
        System.out.println("Set isActive to false, calling updateAccount");
        
        boolean result = accountDAO.updateAccount(a);
        System.out.println("updateAccount result: " + result);
        return result;
    }

    @Override
    public boolean unlockAccount(int accountId) {
        System.out.println("AccountManageServiceImpl.unlockAccount called with id: " + accountId);
        
        // First try to find account normally
        Account a = accountDAO.findById(accountId);
        System.out.println("Found account (normal): " + (a != null ? a.getUsername() : "null"));
        
        // If not found, try including deleted ones
        if (a == null) {
            a = accountDAO.findByIdIncludingDeleted((long) accountId);
            System.out.println("Found account (including deleted): " + (a != null ? a.getUsername() + ", isDeleted: " + a.getIsDeleted() : "null"));
        }
        
        if (a == null) {
            System.out.println("Account not found, returning false");
            return false;
        }
        
        // Don't unlock deleted accounts
        if (a.getIsDeleted()) {
            System.out.println("Cannot unlock deleted account");
            return false;
        }
        
        System.out.println("Current isActive: " + a.getIsActive());
        a.setIsActive(true);
        System.out.println("Set isActive to true, calling updateAccount");
        
        boolean result = accountDAO.updateAccount(a);
        System.out.println("updateAccount result: " + result);
        return result;
    }

    @Override
    public boolean hardDeleteAccount(int accountId) {
        return accountDAO.deleteById(accountId);
    }

    @Override
    public boolean restoreAccount(int accountId) {
        return accountDAO.restoreAccount((long) accountId);
    }

    @Override
    public List<Account> getAllAccountsIncludingDeleted() {
        return accountDAO.getAllAccountsIncludingDeleted();
    }
}
