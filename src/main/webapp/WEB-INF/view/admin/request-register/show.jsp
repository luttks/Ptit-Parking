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
    <title>Quản Lý Yêu Cầu - Danh Sách Yêu Cầu</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản Lý Yêu Cầu</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Danh Sách Yêu Cầu</li>
                    </ol>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3>Danh Sách Yêu Cầu</h3>
                        <a href="${pageContext.request.contextPath}/admin/request/create" class="btn btn-primary">Tạo Đăng Ký Mới</a>
                    </div>
                    <div class="mb-3">
                        <form action="${pageContext.request.contextPath}/admin/request" method="get" class="d-flex align-items-center">
                            <label for="filter" class="me-2">Lọc theo trạng thái hạn:</label>
                            <select name="filter" id="filter" class="form-select w-auto me-2" onchange="this.form.submit()">
                                <option value="all" ${currentFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="active" ${currentFilter == 'active' ? 'selected' : ''}>Còn hạn</option>
                                <option value="expired" ${currentFilter == 'expired' ? 'selected' : ''}>Hết hạn</option>
                            </select>
                            <input type="hidden" name="page" value="0" />
                            <input type="hidden" name="size" value="${requestPage.size}" />
                            <input type="hidden" name="sortByStatus" value="${currentSort}" />
                        </form>
                    </div>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert">
                            <c:out value="${successMessage}" />
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            <c:out value="${errorMessage}" />
                        </div>
                    </c:if>
                    <c:choose>
                        <c:when test="${requestPage.totalElements == 0}">
                            <div class="alert alert-info">Không có yêu cầu nào.</div>
                        </c:when>
                        <c:otherwise>
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã Đăng Ký</th>
                                        <th>Mã Sinh Viên</th>
                                        <th>Biển Số Xe</th>
                                        <th>Ngày Đăng Ký</th>
                                        <th>Ngày Bắt Đầu</th>
                                        <th>Ngày Kết Thúc</th>
                                        <th>Giá (VNĐ)</th>
                                        <th>Trạng Thái</th>
                                        <th>Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="registration" items="${requestPage.content}">
                                        <tr>
                                            <td><c:out value="${registration.maDangKy.trim()}" /></td>
                                            <td><c:out value="${registration.bienSoXe.maSV != null ? registration.bienSoXe.maSV.maSV : 'N/A'}" /></td>
                                            <td><c:out value="${registration.bienSoXe.bienSoXe}" /></td>
                                            <td><fmt:formatDate value="${registration.ngayDangKyAsDate}" pattern="dd/MM/yyyy" /></td>
                                            <td><fmt:formatDate value="${registration.ngayBatDauAsDate}" pattern="dd/MM/yyyy" /></td>
                                            <td><fmt:formatDate value="${registration.ngayKetThucAsDate}" pattern="dd/MM/yyyy" /></td>
                                            <td><fmt:formatNumber value="${registration.gia != null ? registration.gia : 0}" pattern="#,###" /></td>
                                            <td><c:out value="${registration.trangThai}" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${registration.trangThai == 'Đã duyệt' || registration.trangThai == 'Từ chối'}">
                                                        <a href="${pageContext.request.contextPath}/admin/request/view/${registration.maDangKy.trim()}" class="btn btn-info btn-sm">Xem</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/admin/request/approve/${registration.maDangKy.trim()}" class="btn btn-success btn-sm">Duyệt</a>
                                                        <a href="#" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${registration.maDangKy.trim()}">Từ Chối</a>
                                                        <div class="modal fade" id="rejectModal${registration.maDangKy.trim()}" tabindex="-1" aria-labelledby="rejectModalLabel${registration.maDangKy.trim()}" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="rejectModalLabel${registration.maDangKy.trim()}">Từ Chối Yêu Cầu</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <form action="${pageContext.request.contextPath}/admin/request/reject" method="post">
                                                                            <sec:csrfInput />
                                                                            <input type="hidden" name="maDangKy" value="${registration.maDangKy.trim()}" />
                                                                            <div class="mb-3">
                                                                                <label for="ghiChu${registration.maDangKy.trim()}" class="form-label">Lý Do Từ Chối</label>
                                                                                <textarea class="form-control" id="ghiChu${registration.maDangKy.trim()}" name="ghiChu" rows="3" required></textarea>
                                                                                <div class="invalid-feedback">Vui lòng nhập lý do từ chối.</div>
                                                                            </div>
                                                                            <button type="submit" class="btn btn-danger">Xác Nhận Từ Chối</button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/admin/request/view/${registration.maDangKy.trim()}" class="btn btn-info btn-sm mx-1">Xem</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <nav>
                                <ul class="pagination justify-content-center">
                                    <c:if test="${!requestPage.first}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${requestPage.number - 1}&size=${requestPage.size}&sortByStatus=${currentSort}&filter=${currentFilter}">Trước</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="0" end="${requestPage.totalPages - 1}" var="i">
                                        <li class="page-item ${i == requestPage.number ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${requestPage.size}&sortByStatus=${currentSort}&filter=${currentFilter}">${i + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${!requestPage.last}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${requestPage.number + 1}&size=${requestPage.size}&sortByStatus=${currentSort}&filter=${currentFilter}">Sau</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        const table = document.querySelector('table');
        if (table) new simpleDatatables.DataTable(table);
    </script>
</body>
</html>