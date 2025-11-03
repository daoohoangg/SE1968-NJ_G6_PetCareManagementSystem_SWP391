package com.petcaresystem.payment;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VnPayConfig {
    // TODO: điền thông số thật
    public static final String vnp_TmnCode    = "YOUR_TMN_CODE";
    public static final String vnp_HashSecret = "YOUR_HASH_SECRET";
    public static final String vnp_PayUrl     = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String vnp_ReturnUrl  = "https://your-domain.com/payment/vnp_return";
    public static final String vnp_Version    = "2.1.0";
    public static final String vnp_Command    = "pay";

    public static String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public static String buildQuery(Map<String,String> params) {
        try {
            List<String> keys = new ArrayList<>(params.keySet());
            Collections.sort(keys);
            StringBuilder sb = new StringBuilder();
            for (String k : keys) {
                String v = params.get(k);
                if (v != null && !v.isEmpty()) {
                    if (sb.length() > 0) sb.append('&');
                    sb.append(URLEncoder.encode(k, "UTF-8"))
                            .append('=')
                            .append(URLEncoder.encode(v, "UTF-8"));
                }
            }
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    public static String nowYmdHis() {
        var fmt = java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return java.time.LocalDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).format(fmt);
    }
    public static String plusMinYmdHis(int min) {
        var fmt = java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return java.time.LocalDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).plusMinutes(min).format(fmt);
    }
}
