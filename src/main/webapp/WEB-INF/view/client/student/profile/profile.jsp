<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.net.URLDecoder"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
    <jsp:include page="../../layout/header.jsp"/>
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body text-center">
                        <img src="${student.avatar != null ? '/images/students/'.concat(student.avatar) : '/images/default-avatar.png'}"
                             alt="Student Avatar" class="profile-image mb-3 rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                        <h5 class="my-3 fw-bold"><c:out value="${student.hoTen}"/></h5>
                        <p class="text-muted mb-1">Sinh viên</p>
                        <p class="text-muted mb-4"><c:out value="${student.lop.tenLop}"/></p>
                        <div class="d-flex justify-content-center mb-2">
                            <a href="/student/profile/edit" class="btn btn-primary me-2">
                                <i class="fas fa-edit me-2"></i> Chỉnh sửa thông tin
                            </a>
                            <a href="/student/profile/change-password" class="btn btn-warning">
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
                                <p class="info-label mb-0 fw-bold">Mã sinh viên</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.maSV}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Họ và tên</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.hoTen}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Ngày sinh</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${formattedNgaySinh}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Địa chỉ</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.diaChi}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Quê quán</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.queQuan}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Số điện thoại</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.sdt}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Email</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.email}"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        <div class="row mb-3">
                            <div class="col-sm-3">
                                <p class="info-label mb-0 fw-bold">Lớp</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${student.lop.maLop}"/></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../../layout/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>