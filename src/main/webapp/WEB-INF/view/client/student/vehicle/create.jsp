<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="vi">
<body>
    <%@ include file="/WEB-INF/view/client/layout/header.jsp" %>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-12">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-5">
                        <h3 class="card-title text-center mb-4 text-primary fw-bold">Đăng ký xe mới</h3>
                        <hr />
                        <form:form method="post" action="/student/vehicle/create" modelAttribute="newVehicle">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Biển số xe:</label>
                                <form:input type="text" class="form-control" path="bienSoXe" required="required" />
                                <form:errors path="bienSoXe" cssClass="text-danger" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Loại xe:</label>
                                <form:select class="form-select" path="maLoaiXe">
                                    <c:forEach var="type" items="${vehicleTypes}">
                                        <form:option value="${type}" label="${type.tenLoaiXe}" />
                                    </c:forEach>
                                </form:select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên xe:</label>
                                <form:input type="text" class="form-control" path="tenXe" required="required" />
                            </div>
                            <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i> Đăng ký
                                </button>
                                <a href="/student/vehicle/list" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i> Hủy đăng ký
                                </a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/view/client/layout/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>