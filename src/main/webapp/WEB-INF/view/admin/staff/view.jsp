<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>View Staff - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .avatar {
            max-width: 150px;
            border: 2px solid #ddd;
            border-radius: 8px;
            margin-top: 10px;
        }
        .field-label {
            font-weight: bold;
            color: #333;
        }
        .field-value {
            margin-bottom: 15px;
        }
    </style>
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
                        <li class="breadcrumb-item active">View</li>
                    </ol>
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-user me-1"></i>
                            Chi tiết nhân viên
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8 col-12 mx-auto">
                                    <div class="mb-3">
                                        <label class="field-label">Mã NV:</label>
                                        <div class="field-value">${staff.maNV}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Họ tên:</label>
                                        <div class="field-value">${staff.hoTen}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">SĐT:</label>
                                        <div class="field-value">${staff.sdt}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Email:</label>
                                        <div class="field-value">${staff.email}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">CCCD:</label>
                                        <div class="field-value">${staff.cccd}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Chức vụ:</label>
                                        <div class="field-value">${staff.chucVu}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Ngày vào làm:</label>
                                        <div class="field-value">
                                            <c:if test="${not empty staff.ngayVaoLam}">
                                                ${staff.ngayVaoLam}
                                            </c:if>
                                            <c:if test="${empty staff.ngayVaoLam}">
                                                Chưa có ngày vào làm
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Avatar:</label>
                                        <div class="field-value">
                                            <c:if test="${not empty staff.avatar}">
                                                <img src="/images/avatars/${staff.avatar}" alt="Avatar" class="avatar" />
                                            </c:if>
                                            <c:if test="${empty staff.avatar}">
                                                Chưa có avatar
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Tài khoản:</label>
                                        <div class="field-value">
                                            <c:choose>
                                                <c:when test="${not empty staff.account}">
                                                    Có tài khoản (<a href="/admin/account/update/${staff.maNV}">Cập nhật tài khoản</a> | 
                                                    <a href="/admin/account/delete/confirm/${staff.maNV}">Xóa tài khoản</a>)
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có tài khoản (<a href="/admin/account/create/${staff.maNV}">Tạo tài khoản</a>)
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <a href="/admin/staff" class="btn btn-secondary">Quay lại</a>
                                        <a href="/admin/staff/update/${staff.maNV}" class="btn btn-warning">Chỉnh sửa</a>
                                        <a href="/admin/staff/delete/confirm/${staff.maNV}" class="btn btn-danger">Xóa</a>
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
</body>
</html>