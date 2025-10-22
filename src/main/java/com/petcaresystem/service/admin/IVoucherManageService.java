package com.petcaresystem.service.admin;

import com.petcaresystem.dto.OperationResult;
import com.petcaresystem.enities.Voucher;

import java.util.List;

public interface IVoucherManageService {
    List<Voucher> getAllVouchers();
    Voucher getVoucherById(long voucherId);
    Voucher getVoucherByCode(String code);

    OperationResult createVoucher(Voucher voucher);
    OperationResult updateVoucher(Voucher voucher);
    OperationResult setVoucherActive(long voucherId, boolean active);
    OperationResult deleteVoucher(long voucherId);
}

