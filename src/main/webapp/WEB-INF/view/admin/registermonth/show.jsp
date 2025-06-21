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
    <title>Quản Lý Đăng Ký Tháng</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .table-responsive {
            overflow-x: auto;
        }
        .status-pending { color: orange; font-weight: bold; }
        .status-approved { color: green; font-weight: bold; }
        .status-cancelled { color: red; font-weight: bold; }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h2 class="mt-4">Danh Sách Đăng Ký Tháng</h2>
                    <div class="mt-5">
                        <div class="row">
                            <div class="col-12 mx-auto">
                                <!-- Form tìm kiếm -->
                                <div class="row mb-3 align-items-center">
                                    <div class="col-lg-8 col-md-12 mb-2 mb-lg-0 d-flex align-items-center">
                                        <form action="<c:url value='/admin/registermonth/search'/>" method="get" class="d-flex flex-grow-1">
                                            <input type="text" name="tuKhoa" class="form-control me-2" placeholder="Nhập biển số xe..." value="${param.tuKhoa}">
                                            <button type="submit" class="btn btn-primary me-3 text-nowrap">Tìm kiếm</button>
                                        </form>
                                    </div>
                                    <div class="col-lg-4 col-md-12 text-lg-end text-md-start mt-2 mt-lg-0">
                                        <a href="<c:url value='/admin/registermonth/create'/>" class="btn btn-primary">Thêm mới</a>
                                    </div>
                                </div>

                                <!-- Thông báo kết quả tìm kiếm -->
                                <c:if test="${not empty param.tuKhoa}">
                                    <div class="alert alert-info">
                                        Kết quả tìm kiếm cho: <strong>${param.tuKhoa}</strong>
                                    </div>
                                </c:if>
                                <c:if test="${not empty filter && filter == 'active'}">
                                    <div class="alert alert-success">
                                        Đang hiển thị các đăng ký còn hiệu lực
                                    </div>
                                </c:if>
                                <c:if test="${not empty filter && filter == 'expired'}">
                                    <div class="alert alert-warning">
                                        Đang hiển thị các đăng ký đã hết hạn
                                    </div>
                                </c:if>

                                <!-- Hiển thị thông báo thành công/lỗi -->
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success">${successMessage}</div>
                                </c:if>
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger">${errorMessage}</div>
                                </c:if>

                                <!-- Dòng mới cho 4 nút lọc -->
                                <div class="row mb-3">
                                    <div class="col-12 text-center">
                                        <div class="btn-group" role="group">
                                            <a href="<c:url value='/admin/registermonth/active'/>" class="btn btn-success mx-1">Đăng ký còn hiệu lực</a>
                                            <a href="<c:url value='/admin/registermonth/expired'/>" class="btn btn-warning mx-1">Đăng ký đã hết hạn</a>
                                            <a href="<c:url value='/admin/registermonth/expiring-soon'/>" class="btn btn-info mx-1">Đăng ký sắp hết hạn</a>
                                            <a href="<c:url value='/admin/registermonth'/>" class="btn btn-secondary mx-1">Tất cả</a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Bảng danh sách -->
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Mã Đăng Ký</th>
                                                <th>Biển Số Xe</th>
                                                <th>Ngày Đăng Ký</th>
                                                <th>Ngày Bắt Đầu</th>
                                                <th>Ngày Kết Thúc</th>
                                                <th>Trạng Thái</th>
                                                <th>Nhân Viên Ghi Nhận</th>
                                                <th>Giá Tiền</th>
                                                <th>Ghi Chú</th>
                                                <th>Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${registerMonthList}" var="registerMonth">
                                                <tr>
                                                    <td><c:out value="${registerMonth.maDangKy}"/></td>
                                                    <td><c:out value="${registerMonth.bienSoXe.bienSoXe}"/></td>
                                                    <td><fmt:formatDate value="${registerMonth.ngayDangKyAsDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${registerMonth.ngayBatDauAsDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${registerMonth.ngayKetThucAsDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registerMonth.trangThai == 'Chờ duyệt'}">
                                                                <span class="status-pending"><c:out value="${registerMonth.trangThai}"/></span>
                                                            </c:when>
                                                            <c:when test="${registerMonth.trangThai == 'Đã duyệt'}">
                                                                <span class="status-approved"><c:out value="${registerMonth.trangThai}"/></span>
                                                            </c:when>
                                                            <c:when test="${registerMonth.trangThai == 'Từ chối'}">
                                                                <span class="status-cancelled"><c:out value="${registerMonth.trangThai}"/></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${registerMonth.trangThai}"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${registerMonth.maNV != null ? registerMonth.maNV.hoTen : 'N/A'}"/> - 
                                                        <c:out value="${registerMonth.maNV != null ? registerMonth.maNV.maNV : 'N/A'}"/></td>
                                                    <td><c:out value="${registerMonth.gia}"/></td>
                                                    <td><c:out value="${registerMonth.ghiChu != null ? registerMonth.ghiChu : 'N/A'}"/></td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="<c:url value='/admin/registermonth/update/${registerMonth.maDangKy}'/>" class="btn btn-warning btn-sm">Sửa</a>
                                                            <a href="<c:url value='/admin/registermonth/extend/${registerMonth.maDangKy}'/>" class="btn btn-info btn-sm">Gia hạn</a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty registerMonthList}">
                                                <tr>
                                                    <td colspan="10" class="text-center">Không tìm thấy đăng ký nào.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Phân trang -->
                                <c:if test="${registerMonthPage != null && registerMonthPage.totalPages > 0}">
                                    <nav>
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${!registerMonthPage.first}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${registerMonthPage.number - 1}&size=${registerMonthPage.size}">Trước</a>
                                                </li>
                                            </c:if>
                                            <c:forEach begin="0" end="${registerMonthPage.totalPages - 1}" var="i">
                                                <li class="page-item ${i == registerMonthPage.number ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${i}&size=${registerMonthPage.size}">${i + 1}</a>
                                                </li>
                                            </c:forEach>
                                            <c:if test="${!registerMonthPage.last}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${registerMonthPage.number + 1}&size=${registerMonthPage.size}">Sau</a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="../layout/footer.jsp" />
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            const table = document.querySelector('table');
            if (table) new simpleDatatables.DataTable(table, {
                labels: {
                    placeholder: "Tìm kiếm...",
                    perPage: "{select} bản ghi mỗi trang",
                    noRows: "Không tìm thấy dữ liệu",
                    info: "Hiển thị {start} đến {end} của {rows} bản ghi"
                }
            });
        </script>
</body>
</html>