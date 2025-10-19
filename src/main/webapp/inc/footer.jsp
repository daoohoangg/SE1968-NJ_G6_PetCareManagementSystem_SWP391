<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
      integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
      crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
    .site-footer-dark {
        background-color: #222;
        color: #aaa;
        padding: 50px 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        font-size: 14px;
        line-height: 1.6;
    }
    .site-footer-dark h5 {
        color: #fff;
        font-size: 16px;
        font-weight: 700;
        text-transform: uppercase;
        margin-bottom: 25px;
        letter-spacing: 1px;
    }
    .site-footer-dark a {
        color: #aaa;
        text-decoration: none;
        transition: color 0.3s ease;
    }
    .site-footer-dark a:hover {
        color: #fff;
        text-decoration: none;
    }
    .footer-contact p {
        display: flex;
        align-items: flex-start;
        margin-bottom: 15px;
    }
    .footer-contact i {
        width: 28px;
        font-size: 16px;
        color: #fff;
        margin-top: 4px;
    }

    .footer-links ul {
        list-style: none;
        padding-left: 0;
    }
    .footer-links li {
        margin-bottom: 12px;
    }
    .footer-links li a::before {
        content: '\f105';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        margin-right: 8px;
        color: #fff;
    }

    .footer-social a {
        display: inline-block;
        width: 40px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        border-radius: 50%;
        background-color: #333;
        color: #fff;
        margin: 0 5px 5px 0;
        font-size: 16px;
        transition: background-color 0.3s ease;
    }
    .footer-social a.fb:hover { background-color: #1877F2; }
    .footer-social a.ig:hover { background-color: #E1306C; }

    .footer-bct img {
        height: 60px;
        margin-top: 15px;
    }

    .footer-copyright {
        border-top: 1px solid #444;
        padding-top: 25px;
        margin-top: 30px;
        text-align: center;
        font-size: 13px;
        color: #777;
    }
</style>
<footer class="site-footer-dark">
    <div class="container">
        <div class="row">

            <div class="col-lg-4 col-md-6 mb-4 footer-contact">
                <h5>PetCare</h5>
                <p>
                    <i class="fas fa-map-marker-alt"></i>
                    Address: FPT University, Hoa Lac Hi-Tech Park, Km29, Thang Long Avenue, Thach That, Hanoi.
                </p>
                <p>
                    <i class="fas fa-phone"></i>
                    Phone: 0914.430.472
                </p>
                <p>
                    <i class="fas fa-envelope"></i>
                    Email: hahshe186536@fpt.edu.vn
                </p>
                <p>
                    <i class="fas fa-clock"></i>
                    Opening Hours: 8:00 AM - 8:00 PM (All Days)
                </p>
            </div>

            <div class="col-lg-2 col-md-6 mb-4 footer-links">
                <h5>Quick Links</h5>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/inc/about.jsp">About Us</a></li>
                    <li><a href="#">Services</a></li>
                    <li><a href="<%= request.getContextPath() %>/inc/contact.jsp">Contact</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6 mb-4 footer-links">
                <h5>Policies & Terms</h5>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/inc/privacy-policy.jsp">Privacy Policy</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6 mb-4 footer-social">
                <h5>Connect With Us</h5>
                <div class="social-icons">
                    <a href="https://www.facebook.com/SonHa.0511" target="_blank" class="fb" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://www.instagram.com/tohs.ha/" target="_blank" class="ig" title="Instagram"><i class="fab fa-instagram"></i></a>
                </div>
            </div>

        </div>

        <div class="footer-copyright">©2025 Pet Care Management System
        </div>
    </div>
</footer>