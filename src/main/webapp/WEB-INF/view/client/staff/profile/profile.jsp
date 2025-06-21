<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"/>
    <style>
        .profile-image {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #e0e7ff;
            transition: transform 0.3s ease;
        }
        .profile-image:hover {
            transform: scale(1.05);
        }
        .info-label {
            font-weight: 600;
            color: #1a2d4e;
        }
    </style>
</head>
<body>
    <jsp:include page="../../layout/header.jsp"/>
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body text-center">
                        <c:choose>
                            <c:when test="${not empty staff.avatar}">
                                <img src="/images/avatars/${staff.avatar}" alt="Staff Avatar" class="profile-image mb-3 rounded-circle">
                            </c:when>
                            <c:otherwise>
                                <img src="/images/default-avatar.png" alt="Staff Avatar" class="profile-image mb-3 rounded-circle">
                            </c:otherwise>
                        </c:choose>
                        <h5 class="my-3 fw-bold"><c:out value="${staff.hoTen}"/></h5>
                        <p class="text-muted mb-1">Giảng viên</p>
                        <div class="d-flex justify-content-center mb-2">
                            <a href="/staff/profile/edit" class="btn btn-primary me-2">
                                <i class="fas fa-edit me-2"></i> Chỉnh sửa thông tin
                            </a>
                            <a href="/staff/profile/change-password" class="btn btn-warning">
                                <i class="fas fa-key me-2"></i> Đổi mật khẩu
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body">
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <c:out value="${successMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <c:out value="${errorMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Mã nhân viên</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.maNV}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Họ và tên</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.hoTen}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Ngày vào làm</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${formattedNgayVaoLam}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Số điện thoại</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.sdt}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Email</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.email}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">CCCD</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.cccd}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Chức vụ</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${staff.chucVu}"/></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../../layout/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>