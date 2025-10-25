package com.petcaresystem.service.admin;

import com.petcaresystem.dto.pageable.OperationResult;
import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.Voucher;

import java.util.List;

public interface IVoucherManageService {
    List<Voucher> getAllVouchers();
    Voucher getVoucherById(long voucherId);
    Voucher getVoucherByCode(String code);

    PagedResult<Voucher> getVoucherPage(int page, int pageSize);

    OperationResult createVoucher(Voucher voucher);
    OperationResult updateVoucher(Voucher voucher);
    OperationResult setVoucherActive(long voucherId, boolean active);
    OperationResult deleteVoucher(long voucherId);
}

