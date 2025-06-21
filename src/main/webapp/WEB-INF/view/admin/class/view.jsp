<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>View Class - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
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
                    <h1 class="mt-4">Quản lý lớp học</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/class">Classes</a></li>
                        <li class="breadcrumb-item active">View</li>
                    </ol>
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-info-circle me-1"></i>
                            Chi tiết lớp học
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 col-12 mx-auto">
                                    <div class="mb-3">
                                        <label class="field-label">Mã lớp:</label>
                                        <div class="field-value">${classObj.maLop}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Tên lớp:</label>
                                        <div class="field-value">${classObj.tenLop}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="field-label">Khóa học:</label>
                                        <div class="field-value">
                                            <c:if test="${not empty classObj.khoaHoc}">
                                                ${classObj.khoaHoc}
                                            </c:if>
                                            <c:if test="${empty classObj.khoaHoc}">
                                                Chưa có khóa học
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <a href="/admin/class" class="btn btn-secondary">Quay lại</a>
                                        <a href="/admin/class/update/${classObj.maLop}" class="btn btn-warning">Chỉnh sửa</a>
                                        <a href="/admin/class/delete/confirm/${classObj.maLop}" class="btn btn-danger">Xóa</a>
                                    </div>
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