#!/bin/bash
# Copyright (c) HashiCorp, Inc.

# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

cat << EOM > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meow! - Developer Edition</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #00ff88;
            --secondary: #00d4ff;
            --accent: #ff0080;
            --warning: #ffaa00;
            --bg-main: #0a0e27;
            --bg-dark: #050814;
            --surface: #0d1117;
            --surface-light: #161b22;
            --border: rgba(48, 54, 61, 0.8);
            --text-primary: #e6edf3;
            --text-secondary: #8b949e;
            --text-dim: #484f58;
            --code-comment: #6e7681;
            --glow-primary: rgba(0, 255, 136, 0.4);
            --glow-secondary: rgba(0, 212, 255, 0.4);
        }

        body {
            font-family: 'JetBrains Mono', 'Fira Code', 'SF Mono', Monaco, monospace;
            background: var(--bg-dark);
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(0, 255, 136, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 50%, rgba(0, 212, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 50% 100%, rgba(255, 0, 128, 0.05) 0%, transparent 50%);
            min-height: 100vh;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                repeating-linear-gradient(
                    0deg,
                    transparent,
                    transparent 2px,
                    rgba(0, 255, 136, 0.03) 2px,
                    rgba(0, 255, 136, 0.03) 4px
                );
            pointer-events: none;
            z-index: 1;
        }

        .matrix-rain {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            pointer-events: none;
            z-index: 0;
            opacity: 0.02;
        }

        .container {
            max-width: 1000px;
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            position: relative;
            z-index: 10;
            box-shadow: 
                0 0 40px rgba(0, 0, 0, 0.5),
                0 0 80px rgba(0, 255, 136, 0.1),
                inset 0 0 1px rgba(0, 255, 136, 0.2);
            animation: containerGlow 4s ease-in-out infinite alternate;
        }

        @keyframes containerGlow {
            0% { box-shadow: 0 0 40px rgba(0, 0, 0, 0.5), 0 0 60px rgba(0, 255, 136, 0.1), inset 0 0 1px rgba(0, 255, 136, 0.2); }
            100% { box-shadow: 0 0 40px rgba(0, 0, 0, 0.5), 0 0 80px rgba(0, 212, 255, 0.1), inset 0 0 1px rgba(0, 212, 255, 0.2); }
        }

        .terminal-header {
            background: var(--bg-main);
            border-bottom: 1px solid var(--border);
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .terminal-controls {
            display: flex;
            gap: 8px;
        }

        .terminal-btn {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .terminal-btn:hover {
            transform: scale(1.1);
        }

        .terminal-btn.close { background: #ff5f57; }
        .terminal-btn.minimize { background: #ffbd2e; }
        .terminal-btn.maximize { background: #28ca42; }

        .terminal-title {
            color: var(--text-dim);
            font-size: 12px;
            font-weight: 500;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .terminal-path {
            color: var(--text-dim);
            font-size: 11px;
            margin-left: auto;
            padding: 2px 8px;
            background: var(--surface-light);
            border-radius: 4px;
        }

        .content {
            padding: 40px;
        }

        .ascii-art {
            color: var(--primary);
            font-size: 10px;
            line-height: 1.2;
            margin-bottom: 30px;
            text-align: center;
            font-family: monospace;
            letter-spacing: 2px;
            animation: flicker 3s infinite;
        }

        @keyframes flicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        .image-container {
            position: relative;
            display: inline-block;
            margin: 30px auto;
            display: block;
            text-align: center;
        }

        .code-frame {
            position: relative;
            display: inline-block;
            padding: 20px;
            background: var(--bg-main);
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .code-frame::before {
            content: '<!-- cat.component.tsx -->';
            position: absolute;
            top: -10px;
            left: 20px;
            background: var(--surface);
            padding: 0 10px;
            color: var(--code-comment);
            font-size: 11px;
        }

        .main-image {
            display: block;
            max-width: 400px;
            width: 100%;
            height: auto;
            border-radius: 4px;
            filter: brightness(0.9) contrast(1.1);
            border: 2px solid var(--primary);
            box-shadow: 
                0 0 30px rgba(0, 255, 136, 0.3),
                0 0 60px rgba(0, 255, 136, 0.1);
            transition: all 0.3s ease;
        }

        .main-image:hover {
            transform: scale(1.02);
            filter: brightness(1) contrast(1.2);
            box-shadow: 
                0 0 40px rgba(0, 255, 136, 0.4),
                0 0 80px rgba(0, 255, 136, 0.2);
        }

        h1 {
            font-size: 2.5em;
            font-weight: 700;
            margin: 30px 0 10px;
            text-align: center;
            background: linear-gradient(90deg, var(--primary), var(--secondary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
            text-transform: uppercase;
            letter-spacing: 3px;
            animation: glitch 2s infinite;
        }

        @keyframes glitch {
            0%, 100% { text-shadow: 2px 0 var(--primary), -2px 0 var(--secondary); }
            25% { text-shadow: -2px 0 var(--primary), 2px 0 var(--secondary); }
            50% { text-shadow: 2px 0 var(--secondary), -2px 0 var(--accent); }
            75% { text-shadow: -2px 0 var(--accent), 2px 0 var(--primary); }
        }

        .subtitle {
            text-align: center;
            color: var(--text-secondary);
            font-size: 14px;
            margin-bottom: 30px;
            font-family: monospace;
        }

        .subtitle::before { content: '// '; color: var(--code-comment); }
        .subtitle::after { content: ' */'; color: var(--code-comment); }

        .code-block {
            background: var(--bg-main);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 20px;
            margin: 30px 0;
            position: relative;
            font-size: 13px;
            line-height: 1.6;
            overflow-x: auto;
        }

        .code-block::before {
            content: 'main.ts';
            position: absolute;
            top: -1px;
            left: -1px;
            background: var(--surface-light);
            padding: 4px 12px;
            border-radius: 6px 0 6px 0;
            font-size: 11px;
            color: var(--text-secondary);
            border: 1px solid var(--border);
        }

        .code-line {
            display: block;
            padding: 2px 0;
        }

        .code-keyword { color: var(--accent); }
        .code-string { color: var(--primary); }
        .code-function { color: var(--secondary); }
        .code-comment { color: var(--code-comment); }
        .code-variable { color: var(--warning); }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .feature-card {
            background: var(--surface-light);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--primary), transparent);
            animation: scan 4s linear infinite;
        }

        @keyframes scan {
            to { left: 100%; }
        }

        .feature-card:hover {
            transform: translateY(-4px);
            border-color: var(--primary);
            background: var(--bg-main);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .feature-icon {
            color: var(--primary);
            font-size: 24px;
            margin-bottom: 10px;
        }

        .feature-title {
            color: var(--secondary);
            font-size: 16px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .feature-description {
            color: var(--text-secondary);
            font-size: 12px;
            line-height: 1.5;
        }

        .cta-section {
            text-align: center;
            margin: 40px 0;
        }

        .cta-button {
            display: inline-block;
            padding: 12px 30px;
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cta-button::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: var(--primary);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .cta-button:hover {
            color: var(--bg-dark);
            border-color: var(--primary);
            box-shadow: 0 0 20px rgba(0, 255, 136, 0.4);
        }

        .cta-button:hover::before {
            width: 300px;
            height: 300px;
        }

        .cta-button span {
            position: relative;
            z-index: 1;
        }

        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
            text-align: center;
            color: var(--text-dim);
            font-size: 12px;
        }

        .status-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 16px;
            background: var(--bg-main);
            border-top: 1px solid var(--border);
            font-size: 11px;
            color: var(--text-dim);
        }

        .status-left {
            display: flex;
            gap: 20px;
        }

        .status-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        @media (max-width: 768px) {
            .content { padding: 20px; }
            h1 { font-size: 1.8em; }
            .features { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="matrix-rain"></div>
    
    <div class="container">
        <div class="terminal-header">
            <div class="terminal-controls">
                <button class="terminal-btn close"></button>
                <button class="terminal-btn minimize"></button>
                <button class="terminal-btn maximize"></button>
            </div>
            <div class="terminal-title">meow-app@1.0.0</div>
            <div class="terminal-path">~/projects/meow-app</div>
        </div>

        <div class="content">
            <pre class="ascii-art">
    /\_/\  
   ( o.o ) 
    > ^ <  
            </pre>

            <div class="image-container">
                <div class="code-frame">
                    <img class="main-image" src="https://placekitten.com/400/300" alt="Cat Component">
                </div>
            </div>

            <h1>&lt;Meow.World /&gt;</h1>
            <p class="subtitle">Purr-fectly engineered for developers</p>

            <div class="code-block">
                <span class="code-line"><span class="code-keyword">import</span> { <span class="code-function">Cat</span> } <span class="code-keyword">from</span> <span class="code-string">'@meow/core'</span>;</span>
                <span class="code-line"></span>
                <span class="code-line"><span class="code-keyword">const</span> <span class="code-variable">app</span> = <span class="code-keyword">new</span> <span class="code-function">Cat</span>({</span>
                <span class="code-line">  <span class="code-variable">name</span>: <span class="code-string">'${PREFIX}'</span>,</span>
                <span class="code-line">  <span class="code-variable">mode</span>: <span class="code-string">'development'</span>,</span>
                <span class="code-line">  <span class="code-variable">debug</span>: <span class="code-keyword">true</span></span>
                <span class="code-line">});</span>
                <span class="code-line"></span>
                <span class="code-line"><span class="code-comment">// Initialize with purr engine v2.0</span></span>
                <span class="code-line"><span class="code-variable">app</span>.<span class="code-function">start</span>().<span class="code-function">then</span>(() => {</span>
                <span class="code-line">  <span class="code-variable">console</span>.<span class="code-function">log</span>(<span class="code-string">'🐱 Meow server running...'</span>);</span>
                <span class="code-line">});</span>
            </div>

            <div class="features">
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <div class="feature-title">Lightning Fast</div>
                    <div class="feature-description">Optimized performance with lazy loading and tree-shaking</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🛠</div>
                    <div class="feature-title">Developer First</div>
                    <div class="feature-description">Built-in debugging tools, hot reload, and TypeScript support</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <div class="feature-title">Secure by Default</div>
                    <div class="feature-description">Enterprise-grade security with automated vulnerability scanning</div>
                </div>
            </div>

            <div class="cta-section">
                <a href="#" class="cta-button">
                    <span>npm install @meow/core</span>
                </a>
            </div>

            <div class="footer">
                <p>Built with ❤️ by ${PREFIX} | MIT License | v1.0.0</p>
            </div>
        </div>

        <div class="status-bar">
            <div class="status-left">
                <div class="status-item">
                    <span class="status-dot"></span>
                    <span>Connected</span>
                </div>
                <div class="status-item">
                    <span>UTF-8</span>
                </div>
                <div class="status-item">
                    <span>TypeScript</span>
                </div>
            </div>
            <div class="status-right">
                <span>Ln 42, Col 7</span>
            </div>
        </div>
    </div>

    <script>
        // Matrix rain effect
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        document.querySelector('.matrix-rain').appendChild(canvas);

        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        const matrix = "MEOW01";
        const matrixArray = matrix.split("");
        const fontSize = 10;
        const columns = canvas.width / fontSize;
        const drops = [];

        for(let x = 0; x < columns; x++) {
            drops[x] = Math.random() * canvas.height;
        }

        function draw() {
            ctx.fillStyle = 'rgba(10, 14, 39, 0.04)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            ctx.fillStyle = '#00ff88';
            ctx.font = fontSize + 'px monospace';
            
            for(let i = 0; i < drops.length; i++) {
                const text = matrixArray[Math.floor(Math.random() * matrixArray.length)];
                ctx.fillText(text, i * fontSize, drops[i] * fontSize);
                
                if(drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                    drops[i] = 0;
                }
                drops[i]++;
            }
        }

        setInterval(draw, 35);

        window.addEventListener('resize', () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        });
    </script>
</body>
</html>
EOM

echo "Script complete."
