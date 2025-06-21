
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản lý vào/ra - Bảng điều khiển Admin</title>
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
                    <h1 class="mt-4">Quản lý vào/ra</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Bảng điều khiển</a></li>
                        <li class="breadcrumb-item active">Bản ghi vào/ra</li>
                    </ol>
                    <div class="container mt-4">
                        <!-- Thông báo thành công/lỗi -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <!-- Tình trạng bãi đỗ -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-parking me-1"></i>
                                Tình trạng bãi đỗ
                            </div>
                            <div class="card-body">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Tên bãi đỗ</th>
                                            <th>Loại xe</th>
                                            <th>Số chỗ trống</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="parkingLot" items="${parkingLotList}">
                                            <tr>
                                                <td>${parkingLot.parkingLotName}</td>
                                                <td>${parkingLot.vehicleType != null ? parkingLot.vehicleType.tenLoaiXe : 'N/A'}</td>
                                                <td>${parkingLot.availableSpaces}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Nút thêm bản ghi mới -->
                        <a href="/admin/entry-exit/add" class="btn btn-primary mb-3">
                            <i class="fas fa-plus"></i> Thêm bản ghi vào
                        </a>

                        <!-- Tùy chọn lọc và sắp xếp -->
                        <div class="mb-3">
                            <form id="filterForm" action="/admin/entry-exit" method="get" class="d-inline">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="showNotExitedOnly" name="showNotExitedOnly" value="true" ${showNotExitedOnly ? 'checked' : ''} onchange="this.form.submit()">
                                    <label class="form-check-label" for="showNotExitedOnly">Chỉ hiển thị xe chưa ra bãi</label>
                                </div>
                                <input type="hidden" name="page" value="0">
                                <input type="hidden" name="size" value="${entryPage.size}">
                                <input type="hidden" name="sortByTime" value="${currentSort}">
                            </form>
                            <a href="?showNotExitedOnly=${showNotExitedOnly}&sortByTime=asc" class="btn btn-secondary ${currentSort == 'asc' ? 'active' : ''}">
                                <i class="fas fa-sort-up"></i> Sắp xếp theo thời gian vào (Tăng dần)
                            </a>
                            <a href="?showNotExitedOnly=${showNotExitedOnly}&sortByTime=desc" class="btn btn-secondary ${currentSort == 'desc' || empty currentSort ? 'active' : ''}">
                                <i class="fas fa-sort-down"></i> Sắp xếp theo thời gian vào (Giảm dần)
                            </a>
                        </div>

                        <!-- Gỡ lỗi trường null -->
                        <c:if test="${not empty entryPage.content}">
                            <c:forEach var="entry" items="${entryPage.content}">
                                <c:if test="${entry.tgVao == null}">
                                    <div class="alert alert-warning">
                                        Cảnh báo: Phát hiện tgVao null cho MaCTVaoRa=${entry.maCTVaoRa}
                                    </div>
                                </c:if>
                                <c:if test="${entry.bienSoXe == null}">
                                    <div class="alert alert-warning">
                                        Cảnh báo: Phát hiện bienSoXe null cho MaCTVaoRa=${entry.maCTVaoRa}
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <!-- Bảng bản ghi vào/ra -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                Danh sách bản ghi vào/ra
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty entryPage || entryPage.content.isEmpty()}">
                                        <p class="text-center text-muted">Chưa có bản ghi vào/ra nào.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <table id="datatablesSimple" class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Mã bản ghi</th>
                                                    <th>Biển số xe</th>
                                                    <th>Thời gian vào</th>
                                                    <th>Thời gian ra</th>
                                                    <th>Nhân viên vào</th>
                                                    <th>Nhân viên ra</th>
                                                    <th>Hình thức gửi</th>
                                                    <th>Giá (VNĐ)</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="entry" items="${entryPage.content}">
                                                    <tr>
                                                        <td>${entry.maCTVaoRa}</td>
                                                        <td>${entry.bienSoXe != null ? entry.bienSoXe.bienSoXe : 'N/A'}</td>
                                                        <td>${entry.tgVaoFormatted}</td>
                                                        <td>${entry.tgRaFormatted}</td>
                                                        <td>${entry.nvVao != null ? entry.nvVao.hoTen : 'N/A'}</td>
                                                        <td>${entry.nvRa != null ? entry.nvRa.hoTen : 'N/A'}</td>
                                                        <td>${entry.hinhThuc != null ? entry.hinhThuc.tenHinhThuc : 'N/A'}</td>
                                                        <td><fmt:formatNumber value="${entry.gia != null ? entry.gia : 0}" pattern="#,###"/></td>
                                                        <td>
                                                            <c:if test="${entry.tgRa == null}">
                                                                <form action="<c:url value='/admin/entry-exit/exit' />" method="post" style="display:inline;">
                                                                    <input type="hidden" name="maCTVaoRa" value="${entry.maCTVaoRa}" />
                                                                    <security:csrfInput />
                                                                    <button type="submit" class="btn btn-warning btn-sm">
                                                                        <i class="fas fa-sign-out-alt"></i> Ghi nhận ra
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${entryPage != null && entryPage.totalPages > 0}">
                            <nav aria-label="Phân trang">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${entryPage.hasPrevious()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${entryPage.number - 1}&size=${entryPage.size}&sortByTime=${currentSort}&showNotExitedOnly=${showNotExitedOnly}">Trước</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="0" end="${entryPage.totalPages - 1}" var="i">
                                        <li class="page-item ${entryPage.number == i ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${entryPage.size}&sortByTime=${currentSort}&showNotExitedOnly=${showNotExitedOnly}">${i + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${entryPage.hasNext()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${entryPage.number + 1}&size=${entryPage.size}&sortByTime=${currentSort}&showNotExitedOnly=${showNotExitedOnly}">Sau</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
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
        window.addEventListener('DOMContentLoaded', event => {
            const datatablesSimple = document.getElementById('datatablesSimple');
            if (datatablesSimple) {
                new simpleDatatables.DataTable(datatablesSimple);
            }
        });
    </script>
</body>
</html>
