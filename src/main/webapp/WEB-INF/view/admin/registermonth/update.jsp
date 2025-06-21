<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Đăng Ký Tháng</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        .invalid-feedback { color: #dc3545; font-size: 0.875em; }
        .form-text { color: #6c757d; }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h2 class="mt-4">Cập Nhật Đăng Ký Tháng</h2>
                    <div class="mt-5">
                        <div class="row">
                            <div class="col-12 mx-auto">
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger">${errorMessage}</div>
                                </c:if>
                                <form:form action="/admin/registermonth/update" method="post" modelAttribute="newRegisterMonth" class="needs-validation" novalidate>
                                    <sec:csrfInput/>
                                    <form:hidden path="maDangKy"/>
                                    <div class="form-group mb-3">
                                        <label for="bienSoXe" class="form-label">Biển Số Xe</label>
                                        <form:select path="bienSoXe.bienSoXe" id="bienSoXe" class="form-control" required="true" onchange="updatePrice()">
                                            <option value="" disabled>Chọn xe</option>
                                            <c:forEach var="vehicle" items="${vehicles}">
                                                <option value="${vehicle.bienSoXe}" data-maLoaiXe="${vehicle.maLoaiXe.maLoaiXe}" ${vehicle.bienSoXe == newRegisterMonth.bienSoXe.bienSoXe ? 'selected' : ''}>
                                                    <c:out value="${vehicle.bienSoXe}"/>
                                                </option>
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="bienSoXe.bienSoXe" cssClass="invalid-feedback"/>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                                        <form:input type="date" path="ngayBatDau" id="ngayBatDau" class="form-control" required="true" onchange="updatePrice()"/>
                                        <form:errors path="ngayBatDau" cssClass="invalid-feedback"/>
                                        <small class="form-text">Thời gian không được trùng với các đăng ký khác.</small>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="ngayKetThuc" class="form-label">Ngày Kết Thúc</label>
                                        <form:input type="date" path="ngayKetThuc" id="ngayKetThuc" class="form-control" required="true" onchange="updatePrice()"/>
                                        <form:errors path="ngayKetThuc" cssClass="invalid-feedback"/>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="gia" class="form-label">Giá Tiền (VNĐ)</label>
                                        <form:input type="text" path="gia" id="gia" class="form-control" readonly="true"/>
                                        <form:errors path="gia" cssClass="invalid-feedback"/>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="trangThai" class="form-label">Trạng Thái</label>
                                        <form:select path="trangThai" id="trangThai" class="form-control" required="true">
                                            <option value="Chờ duyệt" ${newRegisterMonth.trangThai == 'Chờ duyệt' ? 'selected' : ''}>Chờ duyệt</option>
                                            <option value="Đã duyệt" ${newRegisterMonth.trangThai == 'Đã duyệt' ? 'selected' : ''}>Đã duyệt</option>
                                            <option value="Từ chối" ${newRegisterMonth.trangThai == 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                                        </form:select>
                                        <form:errors path="trangThai" cssClass="invalid-feedback"/>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="ghiChu" class="form-label">Ghi Chú</label>
                                        <form:textarea path="ghiChu" id="ghiChu" class="form-control" rows="4"/>
                                        <form:errors path="ghiChu" cssClass="invalid-feedback"/>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Cập Nhật</button>
                                    <a href="<c:url value='/admin/registermonth'/>" class="btn btn-secondary">Hủy</a>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            updatePrice(); // Load price on page load
        });

        function updatePrice() {
            const bienSoXeSelect = document.getElementById('bienSoXe');
            const selectedVehicle = bienSoXeSelect.options[bienSoXeSelect.selectedIndex];
            const ngayBatDau = document.getElementById('ngayBatDau').value;
            const ngayKetThuc = document.getElementById('ngayKetThuc').value;
            const giaInput = document.getElementById('gia');

            if (!selectedVehicle || !ngayBatDau || !ngayKetThuc) {
                giaInput.value = 'Đang tính...';
                return;
            }

            fetch(`/admin/registermonth/getPrice?bienSoXe=${selectedVehicle.value}`)
                .then(response => response.json())
                .then(price => {
                    const startDate = new Date(ngayBatDau);
                    const endDate = new Date(ngayKetThuc);
                    const months = (endDate.getFullYear() - startDate.getFullYear()) * 12 + endDate.getMonth() - startDate.getMonth();
                    if (months > 0) {
                        const totalPrice = price.gia * months;
                        giaInput.value = totalPrice.toLocaleString('vi-VN');
                    } else {
                        giaInput.value = 'Ngày không hợp lệ';
                    }
                })
                .catch(error => {
                    console.error('Error fetching price:', error);
                    giaInput.value = 'Lỗi tính giá';
                });
        }

        (function () {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>