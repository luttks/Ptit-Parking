<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            text-align: center;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(-20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        h1 {
            color: #e74c3c;
            font-size: 2.5em;
            margin-bottom: 20px;
        }

        p {
            color: #555;
            font-size: 1.2em;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: #3498db;
            color: #fff;
            text-decoration: none;
            border-radius: 25px;
            font-size: 1em;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background: #2980b9;
        }

        .btn-secondary {
            background: #7f8c8d;
            margin-left: 10px;
        }

        .btn-secondary:hover {
            background: #6c7a89;
        }

        .icon {
            font-size: 4em;
            color: #e74c3c;
            margin-bottom: 20px;
        }

        @media (max-width: 500px) {
            .container {
                padding: 20px;
            }
            h1 {
                font-size: 2em;
            }
            p {
                font-size: 1em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- <div class="icon">🚫</div> -->
        <h1>Access Denied</h1>
        <p>Sorry, you don't have permission to access this page. Please check your credentials or contact our support team for assistance.</p>
        <a href="/" class="btn">Go Back</a>
    </div>

    <script>
        // Optional: Add a slight animation on button click
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('click', () => {
                btn.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    btn.style.transform = 'scale(1)';
                }, 100);
            });
        });
    </script>
</body>
</html>