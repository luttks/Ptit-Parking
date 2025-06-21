<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Delete Student - Student Management Dashboard">
    <meta name="author" content="">
    <title>Delete Student - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
                        <li class="breadcrumb-item active">Delete Student</li>
                    </ol>

                    <div class="container mt-4">
                        <h3>Xóa sinh viên với MÃ SV = ${maSV}</h3>
                        <div class="card">
                            <div class="card-body">
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" role="alert">
                                        ${errorMessage}
                                    </div>
                                </c:if>
                                <div class="alert alert-danger" role="alert">
                                    Bạn có chắc chắn muốn xóa sinh viên này? Hành động này không thể hoàn tác.
                                    <c:if test="${hasAccount}">
                                        <br><strong>Cảnh báo:</strong> Sinh viên này có tài khoản liên quan. Vui lòng xóa tài khoản trước.
                                        <br><a href="/admin/account/delete/confirm/${maSV}" class="btn btn-warning mt-2">Xóa tài khoản</a>
                                    </c:if>
                                </div>
                                <c:if test="${!hasAccount}">
                                    <a href="/admin/student/delete/${maSV}" class="btn btn-danger">Xác nhận xóa</a>
                                </c:if>
                                <a href="/admin/student" class="btn btn-secondary">Hủy</a>
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