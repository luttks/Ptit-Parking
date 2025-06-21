<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm Đăng Ký Tháng</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        .form-group { margin-bottom: 1.5rem; }
        #vehicleInfo { display: none; margin-top: 10px; }
        #searchResult { margin-top: 10px; }
        .invalid-feedback { display: none; color: #dc3545; }
        .was-validated .form-control:invalid ~ .invalid-feedback { display: block; }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h2 class="mt-4">Thêm Đăng Ký Tháng</h2>
                    <div class="row">
                        <div class="col-12 col-md-6 mx-auto">
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger">${errorMessage}</div>
                            </c:if>
                            <div class="mb-3">
                                <label for="searchBienSoXe" class="form-label">Tìm Biển Số Xe</label>
                                <div class="input-group">
                                    <input type="text" id="searchBienSoXe" class="form-control" placeholder="Nhập biển số xe..." />
                                    <button type="button" id="searchButton" class="btn btn-primary">Tìm</button>
                                </div>
                                <div id="searchResult"></div>
                                <div id="vehicleInfo" class="alert alert-info">
                                    <strong>Biển số xe:</strong> <span id="displayBienSoXe"></span><br/>
                                    <strong>Tên xe:</strong> <span id="displayTenXe"></span>
                                </div>
                            </div>
                            <!-- Form starts -->
                            <form:form action="/admin/registermonth/create" method="post" modelAttribute="registerMonthForm" class="needs-validation" novalidate>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <!-- Hidden input for bienSoXe -->
                                <div class="form-group">
                                    <input type="hidden" name="bienSoXe" id="bienSoXe" />
                                    <form:errors path="bienSoXe" cssClass="invalid-feedback"/>
                                </div>
                                <div class="form-group">
                                    <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                                    <form:input type="date" path="ngayBatDau" id="ngayBatDau" class="form-control" required="required" disabled="true"/>
                                    <form:errors path="ngayBatDau" cssClass="invalid-feedback"/>
                                </div>
                                <div class="form-group">
                                    <label for="soThang" class="form-label">Số Tháng</label>
                                    <form:select path="soThang" id="soThang" class="form-control" required="required" disabled="true">
                                        <option value="1">1 tháng</option>
                                        <option value="3">3 tháng</option>
                                        <option value="6">6 tháng</option>
                                    </form:select>
                                    <form:errors path="soThang" cssClass="invalid-feedback"/>
                                </div>
                                <div class="form-group">
                                    <label for="ghiChu" class="form-label">Ghi Chú</label>
                                    <form:textarea path="ghiChu" id="ghiChu" class="form-control" disabled="true"/>
                                    <form:errors path="ghiChu" cssClass="invalid-feedback"/>
                                </div>
                                <button type="submit" class="btn btn-primary" id="submitButton" disabled>Thêm</button>
                                <a href="<c:url value='/admin/registermonth'/>" class="btn btn-secondary">Hủy</a>
                            </form:form>
                            <!-- Form ends -->
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
    <script>
        $(document).ready(() => {
            const searchBtn = $("#searchButton");
            const searchInput = $("#searchBienSoXe");
            const vehicleInfo = $("#vehicleInfo");
            const searchResult = $("#searchResult");
            const bienSoXeInput = $("#bienSoXe");
            const formInputs = $("#ngayBatDau, #soThang, #ghiChu, #submitButton");
            const form = $(".needs-validation");

            // Get CSRF token
            const csrfToken = $("input[name='_csrf']").val();

            searchBtn.on("click", () => {
                const bienSo = searchInput.val().trim();
                if (!bienSo) {
                    searchResult.html("<div class='alert alert-danger'>Vui lòng nhập biển số xe!</div>");
                    vehicleInfo.hide();
                    formInputs.prop("disabled", true);
                    bienSoXeInput.val("");
                    return;
                }

                $.ajax({
                    url: "/admin/registermonth/search-vehicle",
                    type: "POST",
                    data: { bienSoXe: bienSo, _csrf: csrfToken },
                    success: function (response) {
                        if (response.found) {
                            searchResult.html("");
                            $("#displayBienSoXe").text(response.vehicle.bienSoXe);
                            $("#displayTenXe").text(response.vehicle.tenXe);
                            vehicleInfo.show();
                            bienSoXeInput.val(response.vehicle.bienSoXe);
                            formInputs.prop("disabled", false);
                        } else {
                            searchResult.html("<div class='alert alert-danger'>Không tìm thấy xe với biển số này!</div>");
                            vehicleInfo.hide();
                            formInputs.prop("disabled", true);
                            bienSoXeInput.val("");
                        }
                    },
                    error: function () {
                        searchResult.html("<div class='alert alert-danger'>Đã xảy ra lỗi khi tìm kiếm!</div>");
                        vehicleInfo.hide();
                        formInputs.prop("disabled", true);
                        bienSoXeInput.val("");
                    }
                });
            });

            // Set minimum date to tomorrow
            document.addEventListener('DOMContentLoaded', function() {
                const today = new Date();
                const tomorrow = new Date(today);
                tomorrow.setDate(today.getDate() + 1);
                const formattedDate = tomorrow.toISOString().split('T')[0];
                $("#ngayBatDau").attr("min", formattedDate);
            });

            // Form validation
            form.on("submit", function (event) {
                if (!this.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                $(this).addClass("was-validated");
            });
        });
    </script>
</body>
</html>