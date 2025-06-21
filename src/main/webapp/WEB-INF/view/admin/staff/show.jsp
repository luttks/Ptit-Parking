<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Staff List - Admin Dashboard</title>
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
                        <li class="breadcrumb-item active">Staff</li>
                    </ol>
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-table me-1"></i>
                            Danh sách nhân viên
                            <a href="/admin/staff/create" class="btn btn-primary float-end">Thêm nhân viên</a>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success" role="alert">
                                    ${successMessage}
                                </div>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                                </div>
                            </c:if>
                            <c:if test="${empty staffPage.content}">
                                <div class="alert alert-info" role="alert">
                                    Không có nhân viên nào trong danh sách. Vui lòng thêm nhân viên mới.
                                </div>
                            </c:if>
                            <c:if test="${not empty staffPage.content}">
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã NV</th>
                                            <th>Họ tên</th>
                                            <th>SĐT</th>
                                            <th>Email</th>
                                            <th>CCCD</th>
                                            <th>Chức vụ</th>
                                            <th>Ngày vào làm</th>
                                            <th>Avatar</th>
                                            <th>Tài khoản</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="staff" items="${staffPage.content}">
                                            <tr>
                                                <td>${staff.maNV}</td>
                                                <td>${staff.hoTen}</td>
                                                <td>${staff.sdt}</td>
                                                <td>${staff.email}</td>
                                                <td>${staff.cccd}</td>
                                                <td>${staff.chucVu}</td>
                                                <td>${staff.ngayVaoLam}</td>
                                                <td>
                                                    <c:if test="${not empty staff.avatar}">
                                                        <img src="/images/avatars/${staff.avatar}" alt="Avatar" width="50" />
                                                    </c:if>
                                                    <c:if test="${empty staff.avatar}">
                                                        No Avatar
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty staff.account}">
                                                            Có (<a href="/admin/account/update/${staff.maNV}">Cập nhật</a>)
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa có (<a href="/admin/account/create/${staff.maNV}">Tạo</a>)
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="/admin/staff/${staff.maNV}" class="btn btn-info btn-sm">Xem</a>
                                                    <a href="/admin/staff/update/${staff.maNV}" class="btn btn-warning btn-sm">Cập nhật</a>
                                                    <a href="/admin/staff/delete/confirm/${staff.maNV}" class="btn btn-danger btn-sm">Xóa</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${staffPage.hasPrevious()}">
                                            <li class="page-item">
                                                <a class="page-link" href="/admin/staff?page=${staffPage.number - 1}&size=${staffPage.size}">Trước</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${staffPage.totalPages > 0}">
                                            <c:forEach begin="0" end="${staffPage.totalPages - 1}" var="i">
                                                <li class="page-item ${i == staffPage.number ? 'active' : ''}">
                                                    <a class="page-link" href="/admin/staff?page=${i}&size=${staffPage.size}">${i + 1}</a>
                                                </li>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${staffPage.hasNext()}">
                                            <li class="page-item">
                                                <a class="page-link" href="/admin/staff?page=${staffPage.number + 1}&size=${staffPage.size}">Sau</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
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
</body>
</html>