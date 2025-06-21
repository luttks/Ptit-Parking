<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý tài khoản</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="/css/styles.css" rel="stylesheet" />
                <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

                <!-- Latest compiled JavaScript -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            </head>

            <body class="sb-nav-fixed">
                <jsp:include page="../layout/header.jsp" />
                <div id="layoutSidenav">
                    <jsp:include page="../layout/sidebar.jsp" />
                    <div id="layoutSidenav_content">
                        <main>
                            <div class="container-fluid px-4">
                                <h2 class="mt-4">Quản lý tài khoản</h2>
                                <div class="container mt-5">
                                    <div class="row">
                                        <div class="col-12 mx-auto">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h3>Danh sách tài khoản</h3>
                                                <div>
                                                    <a href="/admin/account/create" class="btn btn-primary ">Thêm
                                                        tài
                                                        khoản mới
                                                    </a>
                                                </div>
                                            </div>

                                            <hr />

                                            <c:if test="${not empty successMessage}">
                                                <div class="alert alert-success" role="alert">
                                                    ${successMessage}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty errorMessage}">
                                                <div class="alert alert-danger" role="alert">
                                                    ${errorMessage}
                                                </div>
                                            </c:if>

                                            <!-- Search Form for Username -->
                                            <form action="/admin/account" method="get" class="mb-4">
                                                <div class="row g-3 align-items-end">
                                                    <div class="col-md-4">
                                                        <label for="searchUsername" class="form-label">Tìm kiếm tên tài
                                                            khoản:</label>
                                                        <input type="text" class="form-control" id="searchUsername"
                                                            name="searchUsername" value="${searchUsername}">
                                                    </div>
                                                    <div class="col-md-auto">
                                                        <button type="submit" class="btn btn-info">Tìm kiếm</button>
                                                    </div>
                                                </div>
                                            </form>

                                            <!-- Filter Form for Role -->
                                            <form action="/admin/account" method="get" class="mb-4">
                                                <div class="row g-3 align-items-end">
                                                    <div class="col-md-4">
                                                        <label for="filterRoleId" class="form-label">Lọc theo vai
                                                            trò:</label>
                                                        <select class="form-select" id="filterRoleId"
                                                            name="filterRoleId">
                                                            <option value="">-- Chọn vai trò --</option>
                                                            <c:forEach var="role" items="${roles}">
                                                                <option value="${role.roleID}"
                                                                    ${role.roleID==filterRoleId ? 'selected' : '' }>
                                                                    ${role.roleName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-auto">
                                                        <button type="submit" class="btn btn-info">Lọc</button>
                                                    </div>
                                                </div>
                                            </form>

                                            <table class="table table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Tên tài khoản</th>
                                                        <th>Vai trò</th>
                                                        <th>Trạng thái</th>
                                                        <th>Người dùng liên kết</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="account" items="${accountPage.content}">
                                                        <tr>
                                                            <td>${account.username}</td>
                                                            <td>${account.role.roleName}</td>
                                                            <td>${account.enabled ? 'Kích hoạt' : 'Vô hiệu hóa'}</td>
                                                            <td>
                                                                <c:if test="${account.maNV != null}">
                                                                    ${account.maNV.maNV} - ${account.maNV.hoTen}
                                                                </c:if>
                                                                <c:if test="${account.maSV != null}">
                                                                    ${account.maSV.maSV} - ${account.maSV.hoTen}
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <a href="/admin/account/update/${account.username}"
                                                                    class="btn btn-warning mx-2">Cập nhật</a>
                                                                <a href="/admin/account/delete/confirm/${account.username}"
                                                                    class="btn btn-danger">Xóa</a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>

                                            <!-- PHÂN TRANG -->
                                            <nav>
                                                <ul class="pagination justify-content-center">
                                                    <c:if test="${!accountPage.first && accountPage.totalPages > 0}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${accountPage.number - 1}&size=${accountPage.size}&searchUsername=${searchUsername}&filterRoleId=${filterRoleId}">Trước</a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${accountPage.totalPages > 0}">
                                                        <c:forEach begin="0" end="${accountPage.totalPages - 1}"
                                                            var="i">
                                                            <li
                                                                class="page-item ${i == accountPage.number ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?page=${i}&size=${accountPage.size}&searchUsername=${searchUsername}&filterRoleId=${filterRoleId}">${i
                                                                    + 1}</a>
                                                            </li>
                                                        </c:forEach>
                                                    </c:if>
                                                    <c:if test="${!accountPage.last && accountPage.totalPages > 0}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${accountPage.number + 1}&size=${accountPage.size}&searchUsername=${searchUsername}&filterRoleId=${filterRoleId}">Sau</a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>

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