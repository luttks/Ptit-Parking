<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Cập nhật thông tin xe</title>
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
                                <div class=" container mt-5">
                                    <div class="row">
                                        <div class="col-md-6 col-12 mx-auto">
                                            <h3>Cập nhật thông tin xe</h3>
                                            <hr />

                                            <c:if test="${not empty errorMessage}">
                                                <div class="alert alert-danger" role="alert">
                                                    ${errorMessage}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty successMessage}">
                                                <div class="alert alert-success" role="alert">
                                                    ${successMessage}
                                                </div>
                                            </c:if>

                                            <form:form method="post" action="/admin/vehicle/update"
                                                modelAttribute="newVehicle">

                                                <div class="mb-3 ">
                                                    <label class="form-label">BIỂN SỐ XE:</label>
                                                    <form:input type="text" class="form-control" path="bienSoXe"
                                                        readonly="true" />
                                                </div>
                                                <div class="mb-3 ">
                                                    <label class="form-label">MÃ LOẠI XE:</label>
                                                    <form:select class="form-select" path="maLoaiXe.maLoaiXe">
                                                        <form:option value="" label="-- Chọn loại xe --" />
                                                        <c:forEach var="type" items="${vehicleTypes}">
                                                            <form:option value="${type.maLoaiXe}"
                                                                label="${type.maLoaiXe} - ${type.tenLoaiXe}" />
                                                        </c:forEach>
                                                    </form:select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">TÊN XE:</label>
                                                    <form:input type="text" class="form-control" path="tenXe" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">MÃ NV:</label>
                                                    <form:input type="text" class="form-control" path="maNV.maNV"
                                                        id="maNVInput" onkeyup="disableOther('maNV')" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Mã SV:</label>
                                                    <form:input type="text" class="form-control" path="maSV.maSV"
                                                        id="maSVInput" onkeyup="disableOther('maSV')" />
                                                </div>


                                                <button type="submit" class="btn btn-warning">Cập nhật</button>
                                                <a href="/admin/vehicle" class="btn btn-danger">Quay lại</a>

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
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                    crossorigin="anonymous"></script>
                <script>
                    function disableOther(currentField) {
                        var maNVInput = document.getElementById('maNVInput');
                        var maSVInput = document.getElementById('maSVInput');

                        if (currentField === 'maNV') {
                            if (maNVInput.value.trim() !== '') {
                                maSVInput.disabled = true;
                                maSVInput.value = ''; // Clear the other field if something is entered
                            } else {
                                maSVInput.disabled = false;
                            }
                        } else if (currentField === 'maSV') {
                            if (maSVInput.value.trim() !== '') {
                                maNVInput.disabled = true;
                                maNVInput.value = ''; // Clear the other field if something is entered
                            } else {
                                maNVInput.disabled = false;
                            }
                        }
                    }
                    // Initial check on page load if one of the fields already has a value
                    window.onload = function () {
                        var maNVInput = document.getElementById('maNVInput');
                        var maSVInput = document.getElementById('maSVInput');
                        if (maNVInput.value.trim() !== '') {
                            maSVInput.disabled = true;
                        } else if (maSVInput.value.trim() !== '') {
                            maNVInput.disabled = true;
                        }
                    };
                </script>
            </body>

            </html>