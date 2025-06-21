<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Class List - Admin Dashboard</title>
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
                    <h1 class="mt-4">Quản lý lớp học</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Classes</li>
                    </ol>
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-table me-1"></i>
                            Danh sách lớp học
                            <a href="/admin/class/create" class="btn btn-primary float-end">Thêm lớp</a>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty classPage.content}">
                                <div class="alert alert-info" role="alert">
                                    Không có lớp nào trong danh sách. Vui lòng thêm lớp mới.
                                </div>
                            </c:if>
                            <c:if test="${not empty classPage.content}">
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã lớp</th>
                                            <th>Tên lớp</th>
                                            <th>Khóa học</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="classObj" items="${classPage.content}">
                                            <tr>
                                                <td>${classObj.maLop}</td>
                                                <td>${classObj.tenLop}</td>
                                                <td>${classObj.khoaHoc}</td>
                                                <td>
                                                    <a href="/admin/class/${classObj.maLop}" class="btn btn-info btn-sm">View</a>
                                                    <a href="/admin/class/update/${classObj.maLop}" class="btn btn-warning btn-sm">Edit</a>
                                                    <a href="/admin/class/delete/confirm/${classObj.maLop}" class="btn btn-danger btn-sm">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${classPage.hasPrevious()}">
                                            <li class="page-item">
                                                <a class="page-link" href="/admin/class?page=${classPage.number - 1}&size=${classPage.size}">Trước</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${classPage.totalPages > 0}">
                                            <c:forEach begin="0" end="${classPage.totalPages - 1}" var="i">
                                                <li class="page-item ${i == classPage.number ? 'active' : ''}">
                                                    <a class="page-link" href="/admin/class?page=${i}&size=${classPage.size}">${i + 1}</a>
                                                </li>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${classPage.hasNext()}">
                                            <li class="page-item">
                                                <a class="page-link" href="/admin/class?page=${classPage.number + 1}&size=${classPage.size}">Sau</a>
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