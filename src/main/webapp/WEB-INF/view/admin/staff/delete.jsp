<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Delete Staff - Staff Management Dashboard">
    <meta name="author" content="">
    <title>Delete Staff - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản lý nhân viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/staff">Staff</a></li>
                        <li class="breadcrumb-item active">Delete</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Xóa nhân viên với Mã NV = ${maNV}</h3>
                                <hr />
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" role="alert">
                                        <c:out value="${errorMessage}"/>
                                    </div>
                                </c:if>
                                <div class="alert alert-danger" role="alert">
                                    Bạn có chắc chắn muốn xóa nhân viên này? Hành động này không thể hoàn tác.
                                    <c:if test="${hasAccount}">
                                        <br><strong>Cảnh báo:</strong> Nhân viên này có tài khoản liên quan. Vui lòng xóa tài khoản trước.
                                        <br><a href="/admin/account/delete/confirm/${maNV}" class="btn btn-warning mt-2">Xóa tài khoản</a>
                                    </c:if>
                                    <c:if test="${vehicleRegistered}">
                                        <br><strong>Cảnh báo:</strong> Nhân viên này đã đăng ký xe. Vui lòng xóa xe trước khi xóa nhân viên.
                                    </c:if>
                                </div>
                                <c:if test="${!hasAccount && !vehicleRegistered}">
                                    <a href="/admin/staff/delete/${maNV}" class="btn btn-danger">Xóa</a>
                                </c:if>
                                <a href="/admin/staff" class="btn btn-secondary">Hủy</a>
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