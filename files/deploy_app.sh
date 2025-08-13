#!/bin/bash
# Copyright (c) HashiCorp, Inc.

# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

cat << EOM > /var/www/html/index.html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meow! - Modern Cat App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
            --text-dark: #2d3748;
            --text-light: #718096;
            --bg-light: #f7fafc;
            --white: #ffffff;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 20px rgba(0,0,0,0.15);
            --shadow-xl: 0 20px 40px rgba(0,0,0,0.2);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background shapes */
        .bg-shape {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 20s infinite ease-in-out;
        }

        .bg-shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }

        .bg-shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 70%;
            right: 10%;
            animation-delay: 3s;
        }

        .bg-shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 10%;
            left: 30%;
            animation-delay: 5s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            33% { transform: translateY(-20px) rotate(120deg); }
            66% { transform: translateY(20px) rotate(240deg); }
        }

        .container {
            max-width: 900px;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 40px;
            text-align: center;
            position: relative;
        }

        .header::after {
            content: '';
            position: absolute;
            bottom: -20px;
            left: 0;
            right: 0;
            height: 40px;
            background: white;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
        }

        .nav-dots {
            position: absolute;
            top: 20px;
            left: 30px;
            display: flex;
            gap: 8px;
        }

        .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
        }

        .dot:first-child { background: #ff5f56; }
        .dot:nth-child(2) { background: #ffbd2e; }
        .dot:nth-child(3) { background: #27c93f; }

        .content {
            padding: 60px 40px 40px;
            text-align: center;
        }

        .image-container {
            position: relative;
            display: inline-block;
            margin-bottom: 30px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .main-image {
            width: 100%;
            max-width: 400px;
            height: auto;
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .main-image:hover {
            transform: scale(1.05) rotate(2deg);
            box-shadow: var(--shadow-xl);
        }

        .image-decoration {
            position: absolute;
            width: 100%;
            height: 100%;
            border: 3px dashed var(--accent-color);
            border-radius: 20px;
            top: 10px;
            left: 10px;
            z-index: -1;
            opacity: 0.5;
        }

        h1 {
            font-size: 3em;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            animation: fadeInScale 0.8s ease-out 0.3s both;
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .subtitle {
            font-size: 1.3em;
            color: var(--text-light);
            margin-bottom: 30px;
            animation: fadeIn 0.8s ease-out 0.5s both;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .welcome-text {
            font-size: 1.1em;
            color: var(--text-dark);
            line-height: 1.6;
            max-width: 600px;
            margin: 0 auto 40px;
            padding: 25px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 15px;
            border-left: 4px solid var(--primary-color);
            animation: slideInLeft 0.8s ease-out 0.7s both;
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .feature-card {
            padding: 25px;
            background: white;
            border-radius: 15px;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out both;
        }

        .feature-card:nth-child(1) { animation-delay: 0.9s; }
        .feature-card:nth-child(2) { animation-delay: 1.1s; }
        .feature-card:nth-child(3) { animation-delay: 1.3s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .feature-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        .feature-title {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .feature-description {
            color: var(--text-light);
            line-height: 1.5;
        }

        .cta-button {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-md);
            margin-top: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .footer {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e2e8f0;
            color: var(--text-light);
            font-size: 0.9em;
        }

        .social-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .social-link {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .social-link:hover {
            transform: rotate(360deg) scale(1.1);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            h1 { font-size: 2em; }
            .subtitle { font-size: 1.1em; }
            .content { padding: 40px 20px; }
            .features { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Animated background shapes -->
    <div class="bg-shape"></div>
    <div class="bg-shape"></div>
    <div class="bg-shape"></div>

    <div class="container">
        <div class="header">
            <div class="nav-dots">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
        </div>

        <div class="content">
            <!-- Image Section -->
            <div class="image-container">
                <div class="image-decoration"></div>
                <img class="main-image" src="http://${PLACEHOLDER}/${WIDTH}/${HEIGHT}" alt="Meow App">
            </div>

            <!-- Title Section -->
            <h1>Meow World!</h1>
            <p class="subtitle">The Ultimate Cat Experience 🐱</p>

            <!-- Welcome Message -->
            <div class="welcome-text">
                Welcome to <strong>${PREFIX}'s</strong> amazing app.<br>
                <em>AJ Don't Stop</em> - Where cats meet innovation! 
            </div>

            <!-- Feature Cards -->
            <div class="features">
                <div class="feature-card">
                    <div class="feature-icon">🚀</div>
                    <div class="feature-title">Lightning Fast</div>
                    <div class="feature-description">Experience blazing fast performance with our optimized platform</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🎨</div>
                    <div class="feature-title">Beautiful Design</div>
                    <div class="feature-description">Enjoy a modern, clean interface that's a pleasure to use</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <div class="feature-title">Secure & Reliable</div>
                    <div class="feature-description">Your data is safe with enterprise-grade security</div>
                </div>
            </div>

            <!-- Call to Action -->
            <a href="#" class="cta-button">Get Started Today</a>

            <!-- Footer -->
            <div class="footer">
                <p>Made with ❤️ by ${PREFIX}</p>
                <div class="social-links">
                    <a href="#" class="social-link">📧</a>
                    <a href="#" class="social-link">🐦</a>
                    <a href="#" class="social-link">📱</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOM

echo "Script complete."
