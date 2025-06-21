<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - PTIT Parking System</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="/css/styles.css" rel="stylesheet" />
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1 0 auto;
            min-height: calc(100vh - 60px);
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .welcome-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            text-align: center;
            padding-top: 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        .welcome-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .welcome-title {
            font-size: 3.5rem;
            color: #1a2d4e;
            margin-bottom: 1.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            letter-spacing: -0.5px;
            line-height: 1.2;
        }
        .welcome-text {
            font-size: 1.25rem;
            color: #495057;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
            font-weight: 400;
        }
        .welcome-decoration {
            position: relative;
            margin: 1rem 0;
        }
        .welcome-decoration::before {
            content: "";
            display: block;
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #1a2d4e, #3b5998);
            margin: 0 auto;
            border-radius: 2px;
        }
        @media (max-width: 768px) {
            .welcome-section {
                padding-top: 1.5rem;
            }
            .welcome-title {
                font-size: 2.5rem;
            }
            .welcome-text {
                font-size: 1.1rem;
                padding: 0 15px;
            }
        }
        .footer {
            flex-shrink: 0;
            margin-top: auto;
        }
    </style>
</head>
<body>
    <jsp:include page="layout/header.jsp" />
    
    <div class="main-content">
        <div class="welcome-section">
            <div class="welcome-container">
                <h1 class="welcome-title">Welcome to PTIT Parking System</h1>
                <div class="welcome-decoration"></div>
                <p class="welcome-text">Manage your parking needs efficiently with our smart parking management system. Experience seamless parking solutions designed for modern convenience.</p>
            </div>
        </div>
    </div>
    
    <jsp:include page="layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>