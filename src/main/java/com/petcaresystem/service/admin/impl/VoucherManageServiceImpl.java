package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.VoucherDAO;
import com.petcaresystem.dto.OperationResult;
import com.petcaresystem.enities.Voucher;
import com.petcaresystem.service.admin.IVoucherManageService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public class VoucherManageServiceImpl implements IVoucherManageService {

    private static final Set<String> ALLOWED_TYPES = Set.of("PERCENTAGE", "FIXED", "FREE_SERVICE");

    private final VoucherDAO voucherDAO;

    public VoucherManageServiceImpl() {
        this(new VoucherDAO());
    }

    public VoucherManageServiceImpl(VoucherDAO voucherDAO) {
        this.voucherDAO = voucherDAO;
    }

    @Override
    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = voucherDAO.findAll();
        return vouchers != null ? vouchers : new ArrayList<>();
    }

    @Override
    public Voucher getVoucherById(long voucherId) {
        return voucherDAO.findById(voucherId);
    }

    @Override
    public Voucher getVoucherByCode(String code) {
        return voucherDAO.findByCode(code);
    }

    @Override
    public OperationResult createVoucher(Voucher voucher) {
        if (voucher == null) {
            return new OperationResult(false, "Voucher data is required");
        }
        String code = normalizeCode(voucher.getCode());
        if (code == null) {
            return new OperationResult(false, "Voucher code is required");
        }
        if (code.length() > 20) {
            return new OperationResult(false, "Voucher code must be 20 characters or less");
        }
        if (voucherDAO.findByCode(code) != null) {
            return new OperationResult(false, "Voucher code already exists");
        }

        String discountType = normalizeType(voucher.getDiscountType());
        if (discountType == null) {
            return new OperationResult(false, "Voucher type is invalid");
        }

        BigDecimal discountValue = voucher.getDiscountValue();
        OperationResult valueValidation = validateDiscountValue(discountType, discountValue);
        if (!valueValidation.isSuccess()) {
            return valueValidation;
        }

        voucher.setCode(code);
        voucher.setDiscountType(discountType);
        voucher.setDiscountValue(discountValue);
        voucher.setTimesUsed(voucher.getTimesUsed() != null ? voucher.getTimesUsed() : 0);
        voucher.setActive(true);

        boolean ok = voucherDAO.save(voucher);
        return new OperationResult(ok, ok ? "Voucher created successfully" : "Failed to create voucher");
    }

    @Override
    public OperationResult updateVoucher(Voucher voucher) {
        if (voucher == null || voucher.getVoucherId() == null) {
            return new OperationResult(false, "Voucher id is required");
        }
        Voucher existing = voucherDAO.findById(voucher.getVoucherId());
        if (existing == null) {
            return new OperationResult(false, "Voucher not found");
        }

        String code = normalizeCode(voucher.getCode());
        if (code == null) {
            return new OperationResult(false, "Voucher code is required");
        }
        if (code.length() > 20) {
            return new OperationResult(false, "Voucher code must be 20 characters or less");
        }
        Voucher byCode = voucherDAO.findByCode(code);
        if (byCode != null && !Objects.equals(byCode.getVoucherId(), existing.getVoucherId())) {
            return new OperationResult(false, "Voucher code already exists");
        }

        String discountType = normalizeType(voucher.getDiscountType());
        if (discountType == null) {
            return new OperationResult(false, "Voucher type is invalid");
        }

        OperationResult valueValidation = validateDiscountValue(discountType, voucher.getDiscountValue());
        if (!valueValidation.isSuccess()) {
            return valueValidation;
        }

        existing.setCode(code);
        existing.setDiscountType(discountType);
        existing.setDiscountValue(voucher.getDiscountValue());
        existing.setExpiryDate(voucher.getExpiryDate());
        existing.setMaxUses(voucher.getMaxUses());
        existing.setTimesUsed(voucher.getTimesUsed() != null ? voucher.getTimesUsed() : existing.getTimesUsed());
        existing.setActive(voucher.isActive());
        existing.setUpdatedAt(LocalDateTime.now());

        boolean ok = voucherDAO.update(existing);
        return new OperationResult(ok, ok ? "Voucher updated successfully" : "Failed to update voucher");
    }

    @Override
    public OperationResult setVoucherActive(long voucherId, boolean active) {
        Voucher existing = voucherDAO.findById(voucherId);
        if (existing == null) {
            return new OperationResult(false, "Voucher not found");
        }
        if (existing.isActive() == active) {
            return new OperationResult(true, active ? "Voucher already active" : "Voucher already inactive");
        }
        existing.setActive(active);
        existing.setUpdatedAt(LocalDateTime.now());
        boolean ok = voucherDAO.update(existing);
        return new OperationResult(ok, ok
                ? (active ? "Voucher activated" : "Voucher deactivated")
                : "Failed to update voucher status");
    }

    @Override
    public OperationResult deleteVoucher(long voucherId) {
        Voucher existing = voucherDAO.findById(voucherId);
        if (existing == null) {
            return new OperationResult(false, "Voucher not found");
        }
        boolean ok = voucherDAO.delete(existing.getVoucherId());
        return new OperationResult(ok, ok ? "Voucher deleted successfully" : "Failed to delete voucher");
    }

    private String normalizeCode(String rawCode) {
        if (rawCode == null) return null;
        String trimmed = rawCode.trim();
        return trimmed.isEmpty() ? null : trimmed.toUpperCase();
    }

    private String normalizeType(String rawType) {
        if (rawType == null) return null;
        String candidate = rawType.trim().toUpperCase().replace(' ', '_');
        if ("FIXED_AMOUNT".equals(candidate)) {
            candidate = "FIXED";
        }
        return ALLOWED_TYPES.contains(candidate) ? candidate : null;
    }

    private OperationResult validateDiscountValue(String discountType, BigDecimal discountValue) {
        if (discountValue == null) {
            return new OperationResult(false, "Discount value is required");
        }
        if (discountValue.compareTo(BigDecimal.ZERO) <= 0) {
            return new OperationResult(false, "Discount value must be greater than zero");
        }
        if ("PERCENTAGE".equals(discountType) && discountValue.compareTo(new BigDecimal("100")) > 0) {
            return new OperationResult(false, "Percentage discount cannot exceed 100");
        }
        return new OperationResult(true, "OK");
    }
}

