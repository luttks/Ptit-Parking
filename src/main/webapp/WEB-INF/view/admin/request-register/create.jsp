<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Tạo Đăng Ký Tháng Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
    <div class="container mt-4">
        <h1>Tạo Đăng Ký Tháng</h1>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/admin/request/create" method="post" class="needs-validation" novalidate>
            <sec:csrfInput />
            <div class="mb-3">
                <label for="bienSoXe" class="form-label">Biển Số Xe</label>
                <input type="text" class="form-control" id="bienSoXe" name="bienSoXe" required>
                <div class="invalid-feedback">Vui lòng nhập biển số xe.</div>
            </div>
            <div class="mb-3">
                <label for="soThang" class="form-label">Số Tháng</label>
                <select class="form-select" id="soThang" name="soThang" required>
                    <option value="" disabled selected>Chọn số tháng</option>
                    <option value="1">1 Tháng</option>
                    <option value="3">3 Tháng</option>
                    <option value="6">6 Tháng</option>
                </select>
                <div class="invalid-feedback">Vui lòng chọn số tháng.</div>
            </div>
            <div class="mb-3">
                <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                <input type="date" class="form-control" id="ngayBatDau" name="ngayBatDau" required
                       min="<%= java.time.LocalDate.now() %>">
                <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu.</div>
            </div>
            <div class="mb-3">
                <label for="ghiChu" class="form-label">Ghi Chú</label>
                <textarea class="form-control" id="ghiChu" name="ghiChu" rows="4"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Tạo Đăng Ký</button>
            <a href="${pageContext.request.contextPath}/admin/request" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</body>
</html>