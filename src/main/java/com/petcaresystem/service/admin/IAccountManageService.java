package com.petcaresystem.service.admin;

import com.petcaresystem.dto.OperationResult;
import com.petcaresystem.dto.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.Account;

import java.util.List;

public interface IAccountManageService {
    List<Account> getAllAccounts();
    Account getAccountById(int accountId);

    List<Account> searchAccounts(String keyword, String role);

    PagedResult<Account> getAccountsPage(String keyword, String role, int page, int pageSize);
    AccountStats getAccountStats(String keyword, String role);

    OperationResult createAccount(Account a);
    OperationResult updateAccount(Account a);
    boolean lockAccount(int accountId);
    boolean unlockAccount(int accountId);
    boolean hardDeleteAccount(int accountId);

}
