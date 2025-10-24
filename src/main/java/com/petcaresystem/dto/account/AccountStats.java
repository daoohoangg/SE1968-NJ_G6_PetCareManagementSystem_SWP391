package com.petcaresystem.dto.account;

public class AccountStats {

    private final long total;
    private final long active;
    private final long admin;
    private final long staff;
    private final long customer;

    public AccountStats(long total, long active, long admin, long staff, long customer) {
        this.total = Math.max(total, 0);
        this.active = Math.max(active, 0);
        this.admin = Math.max(admin, 0);
        this.staff = Math.max(staff, 0);
        this.customer = Math.max(customer, 0);
    }

    public long getTotal() {
        return total;
    }

    public long getActive() {
        return active;
    }

    public long getLocked() {
        long locked = total - active;
        return locked < 0 ? 0 : locked;
    }

    public long getAdmin() {
        return admin;
    }

    public long getStaff() {
        return staff;
    }

    public long getCustomer() {
        return customer;
    }
}
