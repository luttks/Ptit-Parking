<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create new price table</title>
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
                                        <div class="col-md-6 col-12 mx-auto">
                                            <h1>Thêm Bảng Giá</h1>
                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger" role="alert">
                                                    ${error}
                                                </div>
                                            </c:if>
                                            <form:form action="/admin/price/create" method="post"
                                                modelAttribute="newBangGia">
                                                <div class="mb-3">
                                                    <label class="form-label">Mã bảng giá:</label>
                                                    <form:input type="text" class="form-control" path="maBangGia" />
                                                    <form:errors path="maBangGia" cssClass="text-danger" />
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Loại xe:</label>
                                                    <form:select class="form-select" path="maLoaiXe">
                                                        <form:option value="" label="-- Chọn loại xe --" />
                                                        <form:options items="${vehicleTypes}" itemValue="maLoaiXe"
                                                            itemLabel="tenLoaiXe" />
                                                    </form:select>
                                                    <form:errors path="maLoaiXe" cssClass="text-danger" />
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Hình thức gửi:</label>
                                                    <form:select class="form-select" path="maHinhThuc">
                                                        <form:option value="" label="-- Chọn hình thức --" />
                                                        <form:options items="${parkingModes}" itemValue="maHinhThuc"
                                                            itemLabel="tenHinhThuc" />
                                                    </form:select>
                                                    <form:errors path="maHinhThuc" cssClass="text-danger" />
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Giá:</label>
                                                    <form:input type="number" class="form-control" path="gia" />
                                                    <form:errors path="gia" cssClass="text-danger" />
                                                </div>

                                                <button type="submit" class="btn btn-primary">Thêm mới</button>
                                                <a href="/admin/price" class="btn btn-secondary">Hủy</a>
                                            </form:form>

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
            </body>

            </html>