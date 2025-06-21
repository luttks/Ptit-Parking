<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý xe</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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

                                <h2 class="mt-4"> Quản lý xe</h2>
                                <div class="container mt-5">
                                    <div class="row">
                                        <div class=" col-12 mx-auto">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h3>Danh sách xe </h3>
                                                <div>
                                                    <a href="/admin/vehicle/create" class="btn btn-primary">Thêm xe mới
                                                    </a>
                                                    <a href="/admin/vehicleType" class="btn btn-secondary">Xem loại
                                                        xe</a>
                                                </div>
                                            </div>

                                            <hr />

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
                                            <c:if test="${not empty searchMessage}">
                                                <div class="alert alert-info" role="alert">
                                                    ${searchMessage}
                                                </div>
                                            </c:if>

                                            <!-- Search Form for BienSoXe -->
                                            <form action="/admin/vehicle" method="get" class="mb-4">
                                                <div class="row g-3 align-items-end">
                                                    <div class="col-md-4">
                                                        <label for="searchBienSoXe" class="form-label">Tìm kiếm biển số
                                                            xe:</label>
                                                        <input type="text" class="form-control" id="searchBienSoXe"
                                                            name="searchBienSoXe" value="${searchBienSoXe}">
                                                    </div>
                                                    <div class="col-md-auto">
                                                        <button type="submit" class="btn btn-info">Tìm kiếm</button>
                                                    </div>
                                                </div>
                                            </form>

                                            <!-- Filter Forms Combined -->
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <form action="/admin/vehicle" method="get">
                                                        <div class="row g-3 align-items-end">
                                                            <div class="col">
                                                                <label for="filterType" class="form-label">Lọc theo Sinh
                                                                    Viên/ Nhân Viên:</label>
                                                                <select class="form-select" id="filterType"
                                                                    name="filterType">
                                                                    <option value="">-- Chọn loại --</option>
                                                                    <option value="NV" ${'NV'==filterType ? 'selected'
                                                                        : '' }>
                                                                        Nhân Viên</option>
                                                                    <option value="SV" ${'SV'==filterType ? 'selected'
                                                                        : '' }>
                                                                        Sinh Viên</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-auto">
                                                                <button type="submit" class="btn btn-info">Lọc</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="col-md-6">
                                                    <form action="/admin/vehicle" method="get">
                                                        <div class="row g-3 align-items-end">
                                                            <div class="col">
                                                                <label for="filterTenLoaiXe" class="form-label">Lọc theo
                                                                    Tên
                                                                    loại xe:</label>
                                                                <select class="form-select" id="filterTenLoaiXe"
                                                                    name="filterTenLoaiXe">
                                                                    <option value="">-- Chọn Tên loại xe --</option>
                                                                    <c:forEach var="type" items="${vehicleTypes}">
                                                                        <option value="${type.tenLoaiXe}"
                                                                            ${type.tenLoaiXe==filterTenLoaiXe
                                                                            ? 'selected' : '' }>${type.tenLoaiXe}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="col-auto">
                                                                <button type="submit" class="btn btn-info">Lọc theo tên
                                                                    loại
                                                                    xe</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <table class="table table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>BIỂN SỐ XE</th>
                                                        <th>MÃ LOẠI XE</th>
                                                        <th>TÊN LOAI XE</th>
                                                        <th>MÃ NV</th>
                                                        <th>MÃ SV</th>
                                                        <!-- <th>NGÀY TẠO</th> -->
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="vehicle" items="${vehiclePage.content}">
                                                        <tr>
                                                            <td>${vehicle.bienSoXe}</td>
                                                            <td>
                                                                <c:if test="${vehicle.maLoaiXe != null}">
                                                                    ${vehicle.maLoaiXe.maLoaiXe}
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:if test="${vehicle.maLoaiXe != null}">
                                                                    ${vehicle.maLoaiXe.tenLoaiXe}
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:if test="${vehicle.maNV != null}">
                                                                    ${vehicle.maNV.maNV} - ${vehicle.maNV.hoTen}
                                                                </c:if>
                                                            </td>

                                                            <td>
                                                                <c:if test="${vehicle.maSV != null}">
                                                                    ${vehicle.maSV.maSV} - ${vehicle.maSV.hoTen}
                                                                </c:if>
                                                            </td>
                                                            <!-- <td>${vehicle.createdDate}</td> -->
                                                            <td>
                                                                <a href="/admin/vehicle/update/${vehicle.bienSoXe}"
                                                                    class="btn btn-warning mx-2">Cập nhật </a>
                                                                <a href="/admin/vehicle/delete/${vehicle.bienSoXe}"
                                                                    class="btn btn-danger">Xóa</a>

                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                            <!-- PHÂN TRANG -->
                                            <nav>
                                                <ul class="pagination justify-content-center">

                                                    <c:if test="${!vehiclePage.first && vehiclePage.totalPages > 0}">

                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${vehiclePage.number - 1}&size=${vehiclePage.size}&filterType=${filterType}&filterTenLoaiXe=${filterTenLoaiXe}&searchBienSoXe=${searchBienSoXe}">Trước</a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${vehiclePage.totalPages > 0}">
                                                        <c:forEach begin="0" end="${vehiclePage.totalPages - 1}"
                                                            var="i">
                                                            <li
                                                                class="page-item ${i == vehiclePage.number ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?page=${i}&size=${vehiclePage.size}&filterType=${filterType}&filterTenLoaiXe=${filterTenLoaiXe}&searchBienSoXe=${searchBienSoXe}">${i
                                                                    + 1}</a>
                                                            </li>
                                                        </c:forEach>
                                                    </c:if>
                                                    <c:if test="${!vehiclePage.last && vehiclePage.totalPages > 0}">

                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${vehiclePage.number + 1}&size=${vehiclePage.size}&filterType=${filterType}&filterTenLoaiXe=${filterTenLoaiXe}&searchBienSoXe=${searchBienSoXe}">Sau</a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>

                                    </div>

                                </div>
                            </div>
                        </main>
                        <jsp:include page="../layout/footer.jsp" />
                    </div>
                </div>
                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                    crossorigin="anonymous"></script>

            </body>

            </html>