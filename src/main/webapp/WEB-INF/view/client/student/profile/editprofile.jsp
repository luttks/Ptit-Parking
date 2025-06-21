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
    <title>Chỉnh sửa thông tin cá nhân - PTIT Parking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="/css/styles.css" rel="stylesheet" />
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1 0 auto;
            padding-bottom: 150px; /* Adjust based on footer height */
        }
        .footer {
            flex-shrink: 0;
        }
        .profile-image {
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #e0e7ff;
            transition: transform 0.3s ease;
        }
        .profile-image:hover {
            transform: scale(1.05);
        }
        .form-label {
            font-weight: 600;
            color: #1a2d4e;
            margin-bottom: 0.5rem;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }
        .form-control, .form-select {
            border-radius: 8px;
            padding: 0.75rem;
            transition: border-color 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #3b5998;
            box-shadow: 0 0 0 0.2rem rgba(59, 89, 152, 0.25);
        }
        .card {
            border-radius: 12px;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <jsp:include page="../../layout/header.jsp"/>
    <div class="content">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-5">
                            <h3 class="card-title text-center mb-4 text-primary fw-bold">Chỉnh sửa thông tin cá nhân</h3>
                            
                            <form:form action="/student/profile/edit" method="post" modelAttribute="student" enctype="multipart/form-data">
                                <form:hidden path="maSV"/>
                                
                                <div class="text-center mb-4">
                                    <img src="${student.avatar != null ? '/images/students/'.concat(student.avatar) : '/images/default-avatar.png'}"
                                         alt="Student Avatar" class="profile-image mb-3 rounded-circle">
                                    <div class="mb-3">
                                        <label for="avatarFile" class="form-label">Thay đổi ảnh đại diện</label>
                                        <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*">
                                        <form:errors path="avatar" cssClass="error-message"/>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Mã sinh viên</label>
                                    <input type="text" class="form-control" value="${student.maSV}" disabled>
                                    <form:hidden path="maSV"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="text" class="form-control" value="${student.email}" disabled>
                                    <form:hidden path="email"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Lớp</label>
                                    <input type="text" class="form-control" value="${student.lop.maLop}" disabled>
                                    <form:hidden path="lop"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" value="${student.hoTen}" disabled>
                                    <form:hidden path="hoTen"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" value="${student.ngaySinh}" disabled>
                                    <form:hidden path="ngaySinh"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <form:input path="diaChi" class="form-control" required="required"/>
                                    <form:errors path="diaChi" cssClass="error-message"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Quê quán</label>
                                    <form:input path="queQuan" class="form-control" required="required"/>
                                    <form:errors path="queQuan" cssClass="error-message"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <form:input path="sdt" class="form-control" required="required"/>
                                    <form:errors path="sdt" cssClass="error-message"/>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                    <a href="/student/profile" class="btn btn-secondary me-2">
                                        <i class="fas fa-times me-2"></i>Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </form:form>
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