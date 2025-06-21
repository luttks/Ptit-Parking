<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Yêu Cầu - Xem Chi Tiết</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản Lý Yêu Cầu</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Xem Chi Tiết</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Chi tiết yêu cầu ${registration.maDangKy.trim()}</h3>
                                <hr />
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" role="alert">
                                        <c:out value="${errorMessage}"/>
                                    </div>
                                </c:if>
                                <table class="table table-bordered">
                                    <tbody>
                                        <tr>
                                            <th>Mã Đăng Ký:</th>
                                            <td><c:out value="${registration.maDangKy.trim()}"/></td>
                                        </tr>
                                        <tr>
                                            <th>Mã Sinh Viên:</th>
                                            <td><c:out value="${registration.bienSoXe.maSV != null ? registration.bienSoXe.maSV.maSV : 'N/A'}"/></td>
                                        </tr>
                                        <tr>
                                            <th>Biển Số Xe:</th>
                                            <td><c:out value="${registration.bienSoXe.bienSoXe}"/></td>
                                        </tr>
                                        <tr>
                                            <th>Giá Tiền (VNĐ):</th>
                                            <td><fmt:formatNumber value="${registration.bangGia.gia != null ? registration.bangGia.gia : 0}" pattern="#,###"/></td>
                                        </tr>
                                        <tr>
                                            <th>Ngày Đăng Ký:</th>
                                            <td><fmt:formatDate value="${registration.ngayDangKyAsDate}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                        <tr>
                                            <th>Ngày Bắt Đầu:</th>
                                            <td><fmt:formatDate value="${registration.ngayBatDauAsDate}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                        <tr>
                                            <th>Ngày Kết Thúc:</th>
                                            <td><fmt:formatDate value="${registration.ngayKetThucAsDate}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                        <tr>
                                            <th>Trạng Thái:</th>
                                            <td><c:out value="${registration.trangThai}"/></td>
                                        </tr>
                                        <c:if test="${not empty registration.maNV}">
                                            <tr>
                                                <th>Được Xử Lý Bởi:</th>
                                                <td><c:out value="${registration.maNV.maNV}"/></td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${not empty registration.ghiChu}">
                                            <tr>
                                                <th>Ghi Chú:</th>
                                                <td><c:out value="${registration.ghiChu}"/></td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <div class="d-grid gap-2 mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/request" class="btn btn-secondary">Quay Lại</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</body>
</html>