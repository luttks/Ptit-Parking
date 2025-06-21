<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
    body {
        padding-top: 80px;
        padding-bottom: 120px;
        background-color: #f5f7fa;
        font-family: 'Roboto', 'Arial', sans-serif;
    }
    .navbar {
        background: linear-gradient(135deg, #1a2d4e 0%, #3b5998 100%);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        padding: 0.8rem 2rem;
        transition: background 0.3s ease;
    }
    .navbar-brand {
        display: flex;
        align-items: center;
        font-size: 1.8rem;
        font-weight: 700;
        color: #ffffff !important;
        text-transform: uppercase;
        letter-spacing: 1.2px;
    }
    .navbar-brand i {
        margin-right: 0.5rem;
        font-size: 1.6rem;
        color: #e0e7ff;
    }
    .nav-link {
        color: #d1d7f5 !important;
        font-weight: 500;
        padding: 0.8rem 1.2rem;
        transition: all 0.3s ease;
        position: relative;
    }
    .nav-link:hover, .nav-link:focus {
        color: #ffffff !important;
        transform: translateY(-2px);
    }
    .nav-link::after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: -2px;
        left: 50%;
        background-color: #ffffff;
        transition: width 0.3s ease, transform 0.3s ease;
        transform: translateX(-50%);
    }
    .nav-link:hover::after {
        width: 100%;
    }
    .dropdown-menu {
        background-color: #ffffff;
        border: none;
        border-radius: 8px;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        padding: 0.8rem 0;
        margin-top: 0.5rem;
        animation: slideDown 0.3s ease-out;
        z-index: 1050;
    }
    .dropdown-item {
        color: #1a2d4e;
        font-weight: 500;
        padding: 0.8rem 1.6rem;
        border-radius: 4px;
        transition: all 0.2s ease;
    }
    .dropdown-item:hover {
        background-color: #e0e7ff;
        color: #3b5998;
        transform: translateX(5px);
    }
    .dropdown-divider {
        border-color: #e5e7eb;
    }
    .navbar-toggler {
        border: none;
        padding: 0.5rem;
    }
    .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba(255, 255, 255, 0.95)' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }
    .dropdown-submenu {
        position: relative;
    }
    .dropdown-submenu .dropdown-menu {
        top: 0;
        left: 100%;
        margin-top: -1px;
        border-radius: 8px;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        min-width: 200px;
    }
    .dropdown-submenu:hover > .dropdown-menu {
        display: block;
    }
    .dropdown-submenu > .dropdown-item::after {
        content: '\f054';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        float: right;
        margin-left: 10px;
        color: #1a2d4e;
    }
    .dropdown-submenu:hover > .dropdown-item::after {
        color: #3b5998;
    }
    @media (max-width: 768px) {
        .dropdown-submenu .dropdown-menu {
            left: 0;
            margin-left: 1.5rem;
            box-shadow: none;
            border: 1px solid #e5e7eb;
        }
        .dropdown-submenu > .dropdown-item::after {
            content: '\f078'; /* Chevron-down for mobile */
        }
    }
    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-parking"></i> PTIT Parking
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown me-3">
                    <a class="nav-link dropdown-toggle" href="#" id="chucNangDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-list me-2"></i> Chức năng
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="chucNangDropdown">
                        <c:choose>
                            <c:when test="${sessionScope.isStaff && sessionScope.chucVu == 'Giảng viên'}">
                                <!-- Staff (Giảng viên) Links -->
                                <li><a class="dropdown-item" href="/staff/profile"><i class="fas fa-user-circle me-2"></i> Quản lý thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="/staff/vehicle/list"><i class="fas fa-motorcycle me-2"></i> Thông tin xe</a></li>
                                <li><a class="dropdown-item" href="/staff/vehicle/history"><i class="fas fa-history me-2"></i> Lịch sử gửi xe</a></li>
                            </c:when>
                            <c:when test="${!sessionScope.isStaff}">
                                <!-- Student Links -->
                                <li><a class="dropdown-item" href="/student/profile"><i class="fas fa-user-circle me-2"></i> Quản lý thông tin cá nhân</a></li>
                                <li><a class="dropdown-item" href="/student/vehicle/list"><i class="fas fa-motorcycle me-2"></i> Quản lý xe</a></li>
                                 <li><a class="dropdown-item" href="/student/vehicle/history"><i class="fas fa-history me-2"></i> Lịch sử gửi xe</a></li>
                                <li class="dropdown-submenu">
                                    <a class="dropdown-item" href="/student/request-monthly-registration">
                                        <i class="fas fa-id-card-alt me-2"></i> Đăng ký vé tháng
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="/student/request-history"><i class="fas fa-history me-2"></i> Lịch sử yêu cầu</a></li>
                                    </ul>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <!-- Other Staff (e.g., Quản lý, Bảo vệ) - Limited or No Links -->
                                <li><a class="dropdown-item" href="/"><i class="fas fa-home me-2"></i> Trang chủ</a></li>
                            </c:otherwise>
                        </c:choose>
                        <sec:authorize access="hasRole('ADMIN')">
                            <li><a class="dropdown-item" href="/admin"><i class="fas fa-user-shield me-2"></i> Admin Panel</a></li>
                        </sec:authorize>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="userDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user fa-fw me-2"></i> <c:out value="${sessionScope.fullName}" default="User"/>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i> Cài đặt</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-history me-2"></i> Nhật ký hoạt động</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li>
                            <form method="post" action="<c:url value='/logout'/>">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="dropdown-item"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</button>
                            </form>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>