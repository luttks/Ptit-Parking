<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Create New Student">
    <meta name="author" content="">
    <title>Create New Student - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        #avatarPreview {
            display: none;
            max-width: 150px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(() => {
            const avatarFile = $("#avatarFile");
            const avatarPreview = $("#avatarPreview");

            avatarFile.change(function (e) {
                const file = e.target.files[0];
                if (file && file.type.startsWith('image/')) {
                    const imgURL = URL.createObjectURL(file);
                    avatarPreview.attr("src", imgURL).css({ "display": "block" });
                    avatarPreview.on('load', () => {
                        URL.revokeObjectURL(imgURL);
                    });
                } else {
                    avatarPreview.css({ "display": "none" }).attr("src", "");
                    alert("Vui lòng chọn một file hình ảnh hợp lệ!");
                }
            });
        });
    </script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp"/>
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp"/>
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản lý sinh viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/student">Students</a></li>
                        <li class="breadcrumb-item active">Create</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Thêm sinh viên mới</h3>
                                <hr />
                                <form:form method="post" action="/admin/student/create" modelAttribute="student" enctype="multipart/form-data">
                                    <div class="mb-3">
                                        <label class="form-label">Mã SV:</label>
                                        <form:input type="text" class="form-control" path="maSV" />
                                        <form:errors path="maSV" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Họ tên:</label>
                                        <form:input type="text" class="form-control" path="hoTen" />
                                        <form:errors path="hoTen" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Địa chỉ:</label>
                                        <form:input type="text" class="form-control" path="diaChi" />
                                        <form:errors path="diaChi" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày sinh:</label>
                                        <form:input type="date" class="form-control" path="ngaySinh" />
                                        <form:errors path="ngaySinh" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Quê quán:</label>
                                        <form:input type="text" class="form-control" path="queQuan" />
                                        <form:errors path="queQuan" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">SĐT:</label>
                                        <form:input type="text" class="form-control" path="sdt" />
                                        <form:errors path="sdt" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email:</label>
                                        <form:input type="email" class="form-control" path="email" />
                                        <form:errors path="email" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Lớp:</label>
                                        <form:select path="lop.maLop" class="form-control">
                                            <form:option value="" label="-- Chọn lớp --" />
                                            <c:forEach var="classObj" items="${classes}">
                                                <form:option value="${classObj.maLop}" label="${classObj.tenLop}" />
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="lop.maLop" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Avatar:</label>
                                        <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*" />
                                        <img id="avatarPreview" alt="Avatar Preview" />
                                        <form:errors path="avatar" cssClass="text-danger" />
                                    </div>
                                    <button type="submit" class="btn btn-primary">Create</button>
                                    <a href="/admin/student" class="btn btn-secondary">Cancel</a>
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
</body>
</html>