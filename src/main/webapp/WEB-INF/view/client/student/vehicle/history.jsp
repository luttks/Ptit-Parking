<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử gửi xe - PTIT Parking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1;
            padding: 2rem 0;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            background: #fff;
        }
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        .table td {
            vertical-align: middle;
            padding: 1rem;
        }
        .page-title {
            color: #1a2d4e;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        .pagination {
            justify-content: center;
            margin-top: 1.5rem;
        }
        .pagination .page-link {
            color: #1a2d4e;
            border-radius: 5px;
            margin: 0 3px;
        }
        .pagination .page-item.active .page-link {
            background-color: #3b5998;
            border-color: #3b5998;
            color: #fff;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
        }
        .sort-buttons {
            margin-bottom: 1rem;
            display: flex;
            gap: 1rem;
        }
        .sort-buttons .btn {
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/view/client/layout/header.jsp" %>
    
    <div class="content">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-12">
                    <h2 class="page-title">Lịch sử gửi xe của bạn</h2>
                    <div class="card">
                        <div class="card-body p-4">
                            <!-- Sort Buttons -->
                            <div class="sort-buttons">
                                <a href="?page=${currentPage}&size=${pageSize}&sortByTime=asc" 
                                   class="btn btn-outline-primary ${currentSort == 'asc' ? 'active' : ''}">
                                    <i class="fas fa-sort-up"></i> Sắp xếp tăng dần
                                </a>
                                <a href="?page=${currentPage}&size=${pageSize}&sortByTime=desc" 
                                   class="btn btn-outline-primary ${currentSort == 'desc' || empty currentSort ? 'active' : ''}">
                                    <i class="fas fa-sort-down"></i> Sắp xếp giảm dần
                                </a>
                            </div>
                            <!-- Table -->
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Mã bản ghi</th>
                                            <th>Biển số xe</th>
                                            <th>Tên xe</th>
                                            <th>Loại xe</th>
                                            <th>Thời gian vào</th>
                                            <th>Thời gian ra</th>
                                            <th>Hình thức gửi</th>
                                            <th>Giá (VNĐ)</th>
                                            <th>Nhân viên vào</th>
                                            <th>Nhân viên ra</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="entry" items="${entryExitPage.content}">
                                            <tr>
                                                <td>${entry.maCTVaoRa}</td>
                                                <td>${entry.bienSoXe.bienSoXe}</td>
                                                <td>${entry.bienSoXe.tenXe}</td>
                                                <td>${entry.bienSoXe.maLoaiXe.tenLoaiXe}</td>
                                                <td>${entry.tgVaoFormatted}</td>
                                                <td>${entry.tgRaFormatted}</td>
                                                <td>${entry.hinhThuc.tenHinhThuc}</td>
                                                <td><c:out value="${entry.gia != null ? entry.gia : 0}"/></td>
                                                <td><c:out value="${entry.nvVao != null ? entry.nvVao.hoTen : 'N/A'}"/></td>
                                                <td><c:out value="${entry.nvRa != null ? entry.nvRa.hoTen : 'N/A'}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Pagination -->
                            <c:if test="${entryExitPage.totalPages > 0}">
                                <nav aria-label="Phân trang">
                                    <ul class="pagination">
                                        <li class="page-item ${entryExitPage.hasPrevious() ? '' : 'disabled'}">
                                            <a class="page-link" href="?page=${entryExitPage.number - 1}&size=${pageSize}&sortByTime=${currentSort}" aria-label="Trước">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <c:forEach begin="0" end="${entryExitPage.totalPages - 1}" var="i">
                                            <li class="page-item ${entryExitPage.number == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${pageSize}&sortByTime=${currentSort}">${i + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${entryExitPage.hasNext() ? '' : 'disabled'}">
                                            <a class="page-link" href="?page=${entryExitPage.number + 1}&size=${pageSize}&sortByTime=${currentSort}" aria-label="Sau">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/view/client/layout/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
