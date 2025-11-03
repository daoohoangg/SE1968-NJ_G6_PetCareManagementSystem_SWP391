package com.petcaresystem.controller.payment;

import com.petcaresystem.payment.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(urlPatterns = "/payment/vnp_return")
public class VnPayReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Map<String,String> f = new HashMap<>();
        for (var e : req.getParameterMap().entrySet()) f.put(e.getKey(), e.getValue()[0]);

        String recvHash = f.remove("vnp_SecureHash");
        f.remove("vnp_SecureHashType");

        String signData = VnPayConfig.buildQuery(f);
        String calcHash = VnPayConfig.hmacSHA512(VnPayConfig.vnp_HashSecret, signData);

        boolean ok = calcHash.equalsIgnoreCase(recvHash) && "00".equals(f.get("vnp_ResponseCode"));
        String msg = ok ? "Thanh toán thành công" : "Thanh toán thất bại hoặc không hợp lệ";

        req.setAttribute("paySuccess", ok);
        req.setAttribute("message", msg);
        req.setAttribute("amount", safeAmount(f.get("vnp_Amount")));
        req.setAttribute("txnRef", f.get("vnp_TxnRef"));
        req.getRequestDispatcher("/payment/result.jsp").forward(req, resp);
    }

    private Long safeAmount(String s){
        try { return s==null?null:Long.parseLong(s)/100; } catch(Exception e){ return null; }
    }
}
