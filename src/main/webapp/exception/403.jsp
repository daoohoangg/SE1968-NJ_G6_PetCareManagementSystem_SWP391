<%-- 
    Document   : 404
    Created on : Mar 20, 2025, 2:42:28 PM
    Author     : daoho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>404 Not Found</title>
        <style>
            /* Import font */
            @import url("https://fonts.googleapis.com/css?family=Barlow+Condensed:300,400,500,600,700,800,900|Barlow:300,400,500,600,700,800,900&display=swap");

            /* Định nghĩa biến CSS */
            :root {
                --font-01: "Barlow", sans-serif;
                --font-02: "Barlow Condensed", sans-serif;

                --m-01: #FB8A8A;
                --m-02: #FFEDC0;

                --bg-01: #695681;
                --bg-02: #36184F;
                --bg-03: #32243E;

                --g-01: linear-gradient(90deg, #FFEDC0 0%, #FF9D87 100%);
                --g-02: linear-gradient(90deg, #8077EA 13.7%, #EB73FF 94.65%);

                --cubic: cubic-bezier(0.4, 0.35, 0, 1.53);
                --cubic2: cubic-bezier(0.18, 0.89, 0.32, 1.15);

                --circleShadow: inset 5px 20px 40px rgba(54, 24, 79, 0.25),
                    inset 5px 0px 5px rgba(50, 36, 62, 0.3),
                    inset 5px 5px 20px rgba(50, 36, 62, 0.25),
                    2px 2px 5px rgba(255, 255, 255, 0.2);
            }

            /* Reset mặc định */
            body, h1, h2, h3, h4, h5, h6, p, ul, li, button, a, i, input {
                margin: 0;
                padding: 0;
                list-style: none;
                border: 0;
                -webkit-tap-highlight-color: transparent;
                text-decoration: none;
                color: inherit;
            }

            body {
                font-family: var(--font-01);
                background: var(--bg-01);
            }

            /* Nút About với social links */
            .about {
                position: fixed;
                z-index: 10;
                bottom: 10px;
                right: 10px;
                width: 40px;
                height: 40px;
                display: flex;
                justify-content: flex-end;
                align-items: flex-end;
                transition: all 0.2s ease;
            }

            .about .bg_links {
                width: 40px;
                height: 40px;
                border-radius: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(5px);
                position: absolute;
            }

            .about .logo {
                width: 40px;
                height: 40px;
                z-index: 9;
                background-image: url(https://rafaelavlucas.github.io/assets/codepen/logo_white.svg);
                background-size: 50%;
                background-repeat: no-repeat;
                background-position: 10px 7px;
                opacity: 0.9;
                transition: all 1s 0.2s ease;
            }

            .about:hover {
                width: 105px;
                height: 105px;
                transition: all 0.6s var(--cubic);
            }

            .about:hover .logo {
                opacity: 1;
                transition: all 0.6s ease;
            }

            .about .social {
                opacity: 0;
                position: absolute;
                bottom: 0;
                right: 0;
                transition: all 0.3s ease;
            }

            .about:hover .social {
                opacity: 1;
            }

            /* Menu Navigation */
            nav .menu {
                width: 100%;
                height: 80px;
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 5%;
                z-index: 3;
            }

            nav .menu .website_name {
                color: var(--bg-01);
                font-weight: 600;
                font-size: 20px;
                background: white;
                padding: 4px 8px;
                border-radius: 2px;
                opacity: 0.5;
                transition: all 0.4s ease;
                cursor: pointer;
            }

            nav .menu .website_name:hover {
                opacity: 1;
            }

            /* Hiệu ứng khi hover menu */
            nav .menu .menu_links .link {
                color: white;
                text-transform: uppercase;
                font-weight: 500;
                margin-right: 50px;
                letter-spacing: 2px;
                position: relative;
                transition: all 0.3s 0.2s ease;
            }

            nav .menu .menu_links .link:hover {
                color: var(--m-01);
            }

            nav .menu .menu_links .link:before {
                content: '';
                position: absolute;
                width: 0px;
                height: 4px;
                background: var(--g-01);
                bottom: -10px;
                border-radius: 4px;
                transition: all 0.4s cubic-bezier(0.82, 0.02, 0.13, 1.26);
                left: 100%;
            }

            nav .menu .menu_links .link:hover:before {
                width: 40px;
                left: 0;
            }

            /* 404 Page Styling */
            .wrapper {
                display: grid;
                place-items: center;
                height: 100vh;
                overflow-x: hidden;
            }

            /* Hiển thị số 404 lớn */
            .p404 {
                font-size: 200px;
                font-weight: 700;
                letter-spacing: 4px;
                color: white;
                position: absolute;
                z-index: 2;
                animation: anime404 0.6s cubic-bezier(0.3, 0.8, 1, 1.05) both;
                animation-delay: 1.2s;
            }

            .p404:nth-of-type(2) {
                color: var(--bg-02);
                z-index: 1;
                animation-delay: 1s;
                filter: blur(10px);
                opacity: 0.8;
            }

            /* Background Circle */
            .circle:before {
                content: '';
                position: absolute;
                width: 800px;
                height: 800px;
                background-color: rgba(54, 24, 79, 0.2);
                border-radius: 100%;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                box-shadow: var(--circleShadow);
                animation: circle 0.8s cubic-bezier(1, 0.06, 0.25, 1) backwards;
            }

            /* Keyframes */
            @keyframes anime404 {
                0% {
                    opacity: 0;
                    transform: scale(10) skew(20deg, 20deg);
                }
            }

            @keyframes circle {
                0% {
                    width: 0;
                    height: 0;
                }
            }

            /* Responsive */
            @media screen and (max-width: 799px) {
                nav .menu .menu_links {
                    display: none;
                }

                .p404 {
                    font-size: 100px;
                }

                .circle:before {
                    width: 400px;
                    height: 400px;
                }
            }

        </style>
    <script>
    // Parallax Code
    var scene = document.getElementById('scene');
    if (scene) {
        var parallax = new Parallax(scene);
    }
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/parallax/3.1.0/parallax.min.js"></script>

</head>
<body>
    <!-- about -->
    <div class="about">
        <a class="bg_links social portfolio" href="https://www.rafaelalucas.com" target="_blank">
            <span class="icon"></span>
        </a>
        <a class="bg_links social dribbble" href="https://dribbble.com/rafaelalucas" target="_blank">
            <span class="icon"></span>
        </a>
        <a class="bg_links social linkedin" href="https://www.linkedin.com/in/rafaelalucas/" target="_blank">
            <span class="icon"></span>
        </a>
        <a class="bg_links logo"></a>
    </div>
    <!-- end about -->

    <nav>
        <div class="menu">
            <p class="website_name">LOGO</p>
            <div class="menu_links">
                <a href="" class="link">about</a>
                <a href="" class="link">projects</a>
                <a href="" class="link">contacts</a>
            </div>
            <div class="menu_icon">
                <span class="icon"></span>
            </div>
        </div>
    </nav>

    <section class="wrapper">

        <div class="container">

            <div id="scene" class="scene" data-hover-only="false">


                <div class="circle" data-depth="1.2"></div>

                <div class="one" data-depth="0.9">
                    <div class="content">
                        <span class="piece"></span>
                        <span class="piece"></span>
                        <span class="piece"></span>
                    </div>
                </div>

                <div class="two" data-depth="0.60">
                    <div class="content">
                        <span class="piece"></span>
                        <span class="piece"></span>
                        <span class="piece"></span>
                    </div>
                </div>

                <div class="three" data-depth="0.40">
                    <div class="content">
                        <span class="piece"></span>
                        <span class="piece"></span>
                        <span class="piece"></span>
                    </div>
                </div>

                <p class="p404" data-depth="0.50">403</p>
                <p class="p404" data-depth="0.10">403</p>

            </div>

            <div class="text">
                <article>
                    <p>Uh oh! Looks like you do not have permission to access this page. <br>Go back to the homepage if you dare!</p>
                    <button>i dare!</button>
                </article>
            </div>

        </div>
    </section>
</body>
</html>
