<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<style>
    .footer {
        background: linear-gradient(135deg, #1a2d4e 0%, #3b5998 100%);
        color: #ffffff;
        padding: 1.5rem 0;
        font-family: 'Roboto', 'Arial', sans-serif;
        width: 100%;
        z-index: 1000;
    }
    .footer-title {
        font-size: 1.2rem;
        font-weight: 700;
        color: #e0e7ff;
        text-transform: uppercase;
        margin-bottom: 0.5rem;
    }
    .footer-subtitle {
        font-size: 1rem;
        font-weight: 600;
        color: #d1d7f5;
        margin-bottom: 0.5rem;
    }
    .footer-text {
        font-size: 0.85rem;
        color: #b8c2e8;
        margin-bottom: 0.5rem;
    }
    .footer-links li {
        font-size: 0.85rem;
        color: #b8c2e8;
        margin-bottom: 0.3rem;
        transition: color 0.3s ease;
    }
    .footer-links a {
        color: #b8c2e8;
        text-decoration: none;
        transition: color 0.3s ease, transform 0.3s ease;
    }
    .footer-links a:hover {
        color: #ffffff;
        transform: translateX(5px);
    }
    .social-links .social-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 30px;
        height: 30px;
        background-color: #e0e7ff;
        color: #1a2d4e;
        border-radius: 50%;
        margin-right: 0.5rem;
        text-decoration: none;
        transition: background-color 0.3s ease, transform 0.3s ease;
    }
    .social-links .social-icon:hover {
        background-color: #ffffff;
        transform: scale(1.1);
    }
    .footer-copyright {
        font-size: 0.8rem;
        color: #b8c2e8;
        margin-top: 1rem;
    }
    @media (max-width: 767px) {
        .footer {
            padding: 1rem 0;
        }
        .footer-title, .footer-subtitle {
            font-size: 1rem;
        }
        .footer-text, .footer-links li, .footer-copyright {
            font-size: 0.75rem;
        }
        .social-links .social-icon {
            width: 25px;
            height: 25px;
            margin-right: 0.3rem;
        }
    }
</style>
<footer class="footer">
    <div class="container">
        <div class="row gy-2">
            <div class="col-md-4 text-center text-md-start">
                <h4 class="footer-title">PTIT Parking System</h4>
                <p class="footer-text">Hệ thống quản lý bãi gửi xe thông minh.</p>
                <div class="social-links">
                    <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="col-md-4 text-center">
                <h5 class="footer-subtitle">Liên hệ</h5>
                <ul class="list-unstyled footer-links">
                    <li><i class="fas fa-university me-2"></i> Học Viện Công Nghệ Bưu Chính Viễn Thông</li>
                    <li><i class="fas fa-envelope me-2"></i> hvbcvthcm@ptithcm.edu.vn</li>
                    <li><i class="fas fa-phone me-2"></i> (028) 38.295.258</li>
                    <li><i class="fas fa-map-marker-alt me-2"></i> Số 11 Nguyễn Đình Chiểu, Quận 1, TP.HCM</li>
                </ul>
            </div>
            <div class="col-md-4 text-center text-md-end">
                <h5 class="footer-subtitle">Hỗ trợ</h5>
                <ul class="list-unstyled footer-links">
                    <li><a href="#">Hướng dẫn sử dụng</a></li>
                    <li><a href="#">Chính sách bảo mật</a></li>
                    <li><a href="#">Liên hệ hỗ trợ</a></li>
                </ul>
            </div>
        </div>
        <div class="row">
            <div class="col-12 text-center">
                <p class="footer-copyright mb-0">© 2025 PTIT Parking System. Designed by PTIT.</p>
            </div>
        </div>
    </div>
</footer>