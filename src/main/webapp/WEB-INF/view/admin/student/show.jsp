<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Student Management Dashboard">
    <meta name="author" content="">
    <title>Student Management - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .avatar-img {
            max-width: 50px;
            border-radius: 5px;
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
                    <h1 class="mt-4">Quản lý sinh viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Students</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>Danh sách sinh viên</h3>
                            <a href="/admin/student/create" class="btn btn-primary">+ Thêm sinh viên</a>
                        </div>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success" role="alert">
                                ${successMessage}
                            </div>
                        </c:if>
                        <div class="mb-3">
                            <form action="/admin/student" method="get" class="d-flex align-items-center">
                                <label for="maLop" class="form-label me-2">Lọc theo lớp:</label>
                                <select id="maLop" name="maLop" class="form-control me-2" style="width: 200px;">
                                    <option value="">-- Tất cả lớp --</option>
                                    <c:forEach var="classObj" items="${classes}">
                                        <option value="${classObj.maLop}" ${classObj.maLop == selectedMaLop ? 'selected' : ''}>${classObj.maLop} - ${classObj.tenLop}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-primary">Lọc</button>
                            </form>
                        </div>
                        <c:choose>
                            <c:when test="${studentPage.totalElements == 0}">
                                <div class="alert alert-info">Không có sinh viên nào.</div>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>MÃ SV</th>
                                            <th>HỌ TÊN</th>
                                            <th>SDT</th>
                                            <th>EMAIL</th>
                                            <th>AVATAR</th>
                                            <th>MÃ LỚP</th>
                                            <th>TÀI KHOẢN</th>
                                            <th style="width: 200px;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="student" items="${studentPage.content}">
                                            <tr>
                                                <td>${student.maSV}</td>
                                                <td>${student.hoTen}</td>
                                                <td>${student.sdt}</td>
                                                <td>${student.email}</td>
                                                <td>
                                                    <c:if test="${not empty student.avatar}">
                                                        <img src="/images/students/${student.avatar}" alt="Avatar" class="avatar-img" />
                                                    </c:if>
                                                    <c:if test="${empty student.avatar}">
                                                        No Avatar
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty student.lop}">
                                                        ${student.lop.maLop}
                                                    </c:if>
                                                    <c:if test="${empty student.lop}">
                                                        Chưa có lớp
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty student.account}">
                                                            Có (<a href="/admin/account/update/${student.maSV}">Cập nhật</a>)
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa có (<a href="/admin/account/create/${student.maSV}">Tạo</a>)
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="/admin/student/${student.maSV}" class="btn btn-success btn-sm">Xem</a>
                                                    <a href="/admin/student/update/${student.maSV}" class="btn btn-warning btn-sm mx-1">Cập nhật</a>
                                                    <a href="/admin/student/delete/confirm/${student.maSV}" class="btn btn-danger btn-sm">Xóa</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${!studentPage.first}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${studentPage.number - 1}&size=${studentPage.size}&maLop=${selectedMaLop}">Trước</a>
                                            </li>
                                        </c:if>
                                        <c:forEach begin="0" end="${studentPage.totalPages - 1}" var="i">
                                            <li class="page-item ${i == studentPage.number ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${studentPage.size}&maLop=${selectedMaLop}">${i + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${!studentPage.last}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${studentPage.number + 1}&size=${studentPage.size}&maLop=${selectedMaLop}">Sau</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>
                <jsp:include page="../layout/footer.jsp" />
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            const table = document.querySelector('table');
            if (table) new simpleDatatables.DataTable(table);
        </script>
</body>
</html>