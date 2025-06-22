<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Danh sách Bảng Giá</title>
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

                                <div class="container mt-5">
                                    <div class="row">
                                        <div class=" col-12 mx-auto">
                                            <div class="d-flex justify-content-between">
                                                <h3>Bảng giá</h3>
                                                <!-- <a href="/admin/price/create" class="btn btn-primary">Thêm Bảng Giá</a>
                                                </a> -->
                                                <a href="/admin/parkingmode" class="btn btn-secondary">Hình thức gửi
                                                    xe</a>
                                            </div>

                                            <hr />
                                            <table class="table table-bordered table-hover">
                                                <thead>

                                                    <tr>
                                                        <th>MÃ BẢNG GIÁ</th>
                                                        <th>LOẠI XE</th>
                                                        <th>Hình Thức Gửi</th>
                                                        <th>Giá</th>
                                                        <th>Action</th>
                                                    </tr>

                                                </thead>
                                                <tbody>
                                                    <c:forEach var="bangGia" items="${bangGiaList}">
                                                        <tr>
                                                            <td>${bangGia.maBangGia}</td>
                                                            <td>${bangGia.maLoaiXe.tenLoaiXe}</td>
                                                            <td>${bangGia.maHinhThuc.tenHinhThuc}</td>
                                                            <td>${bangGia.gia} VNĐ</td>
                                                            <td>
                                                                <a href="/admin/price/update/${bangGia.maBangGia}"
                                                                    class="btn btn-warning mx-2">Update</a>
                                                                <!-- <a href="/admin/price/delete/${bangGia.maBangGia}"
                                                                    class="btn btn-danger">Delete</a> -->
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${ empty bangGiaList}">
                                                        <tr>
                                                            <td colspan="6">
                                                                Không có bảng giá nào được tạo
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                            <!-- PHÂN TRANG -->
                                            <c:if test="${ not empty bangGiaList}">


                                                <nav>
                                                    <ul class="pagination justify-content-center">
                                                        <c:if test="${!bangGiaPage.first}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                    href="?page=${bangGiaPage.number - 1}&size=${bangGiaPage.size}">Trước</a>
                                                            </li>
                                                        </c:if>
                                                        <c:forEach begin="0" end="${bangGiaPage.totalPages - 1}"
                                                            var="i">
                                                            <li
                                                                class="page-item ${i == bangGiaPage.number ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?page=${i}&size=${bangGiaPage.size}">${i +
                                                                    1}</a>
                                                            </li>
                                                        </c:forEach>
                                                        <c:if test="${!bangGiaPage.last}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                    href="?page=${bangGiaPage.number + 1}&size=${bangGiaPage.size}">Sau</a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </nav>
                                            </c:if>
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