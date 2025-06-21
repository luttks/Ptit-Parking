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
                                        <c:forEach var="entry" items="${entryExitList}">
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