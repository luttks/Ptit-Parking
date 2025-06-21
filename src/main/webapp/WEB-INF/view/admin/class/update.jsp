<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Update Class - Admin Dashboard</title>
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
                        <li class="breadcrumb-item"><a href="/admin/class">Classes</a></li>
                        <li class="breadcrumb-item active">Update</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Cập nhật lớp học</h3>
                                <hr />
                                <form:form method="post" action="/admin/class/update" modelAttribute="newClass">
                                    <div class="mb-3">
                                        <label class="form-label">Mã lớp:</label>
                                        <form:input type="text" class="form-control" path="maLop" readonly="true" />
                                        <form:errors path="maLop" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Tên lớp:</label>
                                        <form:input type="text" class="form-control" path="tenLop" />
                                        <form:errors path="tenLop" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Khóa học:</label>
                                        <form:input type="text" class="form-control" path="khoaHoc" />
                                        <form:errors path="khoaHoc" cssClass="text-danger" />
                                    </div>
                                    <button type="submit" class="btn btn-warning">Update</button>
                                    <a href="/admin/class" class="btn btn-secondary">Cancel</a>
                                </form:form>
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