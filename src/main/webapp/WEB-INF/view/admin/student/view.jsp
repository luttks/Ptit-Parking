<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="View Student - Student Management Dashboard">
    <meta name="author" content="">
    <title>View Student - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .avatar-img {
            max-width: 100px;
            border-radius: 4px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp"/>
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp"/>
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Student Management</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/student">Students</a></li>
                        <li class="breadcrumb-item active">View Student</li>
                    </ol>
                    <div class="container mt-4">
                        <h3>Chi tiết sinh viên</h3>
                        <div class="card">
                            <div class="card-body">
                                <p><strong>Mã SV:</strong> ${student.maSV}</p>
                                <p><strong>Họ tên:</strong> ${student.hoTen}</p>
                                <p><strong>Địa chỉ:</strong> ${student.diaChi}</p>
                                <p><strong>Ngày sinh:</strong> 
                                    <c:if test="${not empty student.ngaySinh}">${student.ngaySinh}</c:if>
                                    <c:if test="${empty student.ngaySinh}">Chưa có ngày sinh</c:if>
                                </p>
                                <p><strong>Quê quán:</strong> ${student.queQuan}</p>
                                <p><strong>SĐT:</strong> ${student.sdt}</p>
                                <p><strong>Email:</strong> ${student.email}</p>
                                <p><strong>Lớp:</strong> 
                                    <c:if test="${not empty student.lop}">${student.lop.tenLop}</c:if>
                                    <c:if test="${empty student.lop}">Chưa có lớp</c:if>
                                </p>
                                <p><strong>Avatar:</strong>
                                    <c:if test="${not empty student.avatar}">
                                        <img src="/images/students/${student.avatar}" alt="Avatar" class="avatar-img" />
                                    </c:if>
                                    <c:if test="${empty student.avatar}">
                                        Chưa có avatar
                                    </c:if>
                                </p>
                                <p><strong>Tài khoản:</strong>
                                    <c:choose>
                                        <c:when test="${not empty student.account}">
                                            Có tài khoản (<a href="/admin/account/update/${student.maSV}">Cập nhật tài khoản</a> | 
                                            <a href="/admin/account/delete/confirm/${student.maSV}">Xóa tài khoản</a>)
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có tài khoản (<a href="/admin/account/create/${student.maSV}">Tạo tài khoản</a>)
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="d-flex justify-content-between">
                                    <a href="/admin/student" class="btn btn-primary">Quay lại</a>
                                    <div>
                                        <a href="/admin/student/update/${student.maSV}" class="btn btn-warning">Cập nhật</a>
                                        <a href="/admin/student/delete/confirm/${student.maSV}" class="btn btn-danger">Xóa</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="../layout/footer.jsp" />
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</body>
</html>