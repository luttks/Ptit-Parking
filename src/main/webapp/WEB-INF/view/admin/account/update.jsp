<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Update Account - Admin Dashboard</title>
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
                    <h1 class="mt-4">Quản lý tài khoản</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Update Account</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Cập nhật tài khoản ${account.username}</h3>
                                <hr />
                                <form:form method="post" action="/admin/account/update" modelAttribute="account" id="updateAccountForm">
                                    <div class="mb-3">
                                        <label class="form-label">Tên đăng nhập:</label>
                                        <form:input type="text" class="form-control" path="username" readonly="true" />
                                        <form:errors path="username" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mật khẩu mới (để trống nếu không thay đổi):</label>
                                        <input type="password" class="form-control" name="newPassword" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Vai trò:</label>
                                        <select name="roleId" class="form-select" required>
                                            <option value="" disabled ${selectedRole == null ? 'selected' : ''}>Chọn vai trò</option>
                                            <c:forEach var="role" items="${roles}">
                                                <option value="${role.roleID}" ${role.roleID == selectedRole ? 'selected' : ''}>
                                                    ${role.roleName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <c:if test="${not empty errorMessage}">
                                            <div class="text-danger">${errorMessage}</div>
                                        </c:if>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Trạng thái:</label>
                                        <form:checkbox path="enabled" label="Kích hoạt" />
                                        <form:errors path="enabled" cssClass="text-danger" />
                                    </div>
                                    <button type="submit" class="btn btn-warning">Cập nhật</button>
                                    <a href="/admin" class="btn btn-secondary">Hủy</a>
                                </form:form>
                            </div>
                        </div>
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
        // Client-side validation to ensure roleId is selected
        document.getElementById('updateAccountForm').addEventListener('submit', function(event) {
            const roleSelect = document.querySelector('select[name="roleId"]');
            if (!roleSelect.value) {
                event.preventDefault();
                alert('Vui lòng chọn một vai trò.');
            }
        });
    </script>
</body>
</html>