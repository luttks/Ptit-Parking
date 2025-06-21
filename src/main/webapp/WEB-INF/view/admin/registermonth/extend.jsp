<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Gia hạn đăng ký tháng</title>

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

                                <h2 class="mt-4">Thông tin đăng ký</h2>
                                <div class="mt-5">
                                    <div class="row">
                                        <div class="col-12 mx-auto">
                                            <p class="card-text">
                                                <strong>Mã đăng ký:</strong> ${registerMonth.maDangKy}<br>
                                                <strong>Biển số xe:</strong> ${registerMonth.bienSoXe.bienSoXe}<br>
                                                <strong>Ngày hết hạn hiện tại:</strong> ${registerMonth.tGianHetHan}
                                            </p>

                                            <form:form
                                                action="${pageContext.request.contextPath}/admin/registermonth/extend"
                                                method="post">
                                                <input type="hidden" name="maDangKy" value="${registerMonth.maDangKy}">

                                                <div class="form-group">
                                                    <label>Chọn thời gian gia hạn:</label>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="soThang"
                                                            id="1thang" value="1" checked>
                                                        <label class="form-check-label" for="1thang">1 tháng</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="soThang"
                                                            id="6thang" value="6">
                                                        <label class="form-check-label" for="6thang">6 tháng</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="soThang"
                                                            id="12thang" value="12">
                                                        <label class="form-check-label" for="12thang">12 tháng</label>
                                                    </div>
                                                </div>

                                                <button type="submit" class="btn btn-primary">Gia hạn</button>
                                                <a href="${pageContext.request.contextPath}/admin/registermonth"
                                                    class="btn btn-secondary">Quay lại</a>
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