<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Hello World - DevOps CI/CD</title>

<style>

/* =========================================================
   GLOBAL.Com
========================================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    width: 100%;
    height: 100%;
    overflow: hidden;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background:
        radial-gradient(circle at 50% 50%, #172554 0%, #080d1c 45%, #020617 100%);
    color: white;
}


/* =========================================================
   BACKGROUND
========================================================= */

.background {
    position: fixed;
    inset: 0;
    overflow: hidden;
    z-index: 0;
}

.grid {
    position: absolute;
    inset: 0;

    background-image:
        linear-gradient(rgba(59,130,246,.08) 1px, transparent 1px),
        linear-gradient(90deg, rgba(59,130,246,.08) 1px, transparent 1px);

    background-size: 50px 50px;

    animation: gridMove 15s linear infinite;
}

@keyframes gridMove {
    from {
        transform: translateY(0);
    }

    to {
        transform: translateY(50px);
    }
}


/* =========================================================
   FLOATING PARTICLES
========================================================= */

.particle {
    position: absolute;
    width: 4px;
    height: 4px;

    background: #60a5fa;
    border-radius: 50%;

    box-shadow:
        0 0 10px #60a5fa,
        0 0 20px #3b82f6;

    animation: float 8s infinite ease-in-out;
}

.p1 { left: 8%; top: 20%; animation-delay: 0s; }
.p2 { left: 20%; top: 75%; animation-delay: 2s; }
.p3 { left: 85%; top: 25%; animation-delay: 1s; }
.p4 { left: 92%; top: 70%; animation-delay: 3s; }
.p5 { left: 50%; top: 10%; animation-delay: 4s; }
.p6 { left: 35%; top: 90%; animation-delay: 1.5s; }

@keyframes float {

    0%, 100% {
        transform: translateY(0) scale(1);
        opacity: .3;
    }

    50% {
        transform: translateY(-80px) scale(1.8);
        opacity: 1;
    }
}


/* =========================================================
   HEADER
========================================================= */

.header {
    position: absolute;
    top: 25px;
    left: 0;
    width: 100%;

    text-align: center;
    z-index: 10;
}

.header h2 {
    font-size: 15px;
    letter-spacing: 6px;
    text-transform: uppercase;

    color: #93c5fd;

    text-shadow:
        0 0 10px #3b82f6;
}

.header p {
    margin-top: 8px;
    font-size: 12px;
    color: #64748b;
    letter-spacing: 2px;
}


/* =========================================================
   CENTER
========================================================= */

.center {
    position: absolute;

    left: 50%;
    top: 50%;

    transform: translate(-50%, -50%);

    width: 270px;
    height: 270px;

    border-radius: 50%;

    display: flex;
    align-items: center;
    justify-content: center;

    z-index: 20;
}


/* Outer rotating ring */

.center::before {
    content: "";

    position: absolute;

    inset: -20px;

    border-radius: 50%;

    border: 2px solid rgba(59,130,246,.3);

    border-top-color: #60a5fa;
    border-right-color: #2563eb;

    animation: rotate 8s linear infinite;
}


/* Second ring */

.center::after {
    content: "";

    position: absolute;

    inset: -35px;

    border-radius: 50%;

    border: 1px dashed rgba(96,165,250,.25);

    animation: rotateReverse 15s linear infinite;
}

@keyframes rotate {
    to {
        transform: rotate(360deg);
    }
}

@keyframes rotateReverse {
    to {
        transform: rotate(-360deg);
    }
}


/* =========================================================
   HELLO WORLD CARD
========================================================= */

.hello-card {

    width: 240px;
    height: 240px;

    border-radius: 50%;

    display: flex;
    flex-direction: column;

    align-items: center;
    justify-content: center;

    text-align: center;

    background:
        radial-gradient(circle at 30% 30%,
        rgba(59,130,246,.25),
        rgba(15,23,42,.98));

    border: 1px solid rgba(96,165,250,.5);

    box-shadow:
        0 0 30px rgba(37,99,235,.4),
        inset 0 0 40px rgba(37,99,235,.15);

    animation: pulse 3s infinite ease-in-out;
}

@keyframes pulse {

    0%, 100% {
        box-shadow:
            0 0 25px rgba(37,99,235,.35),
            inset 0 0 30px rgba(37,99,235,.1);
    }

    50% {
        box-shadow:
            0 0 60px rgba(37,99,235,.65),
            inset 0 0 50px rgba(37,99,235,.25);
    }
}

.hello-card h1 {

    font-size: 30px;

    background:
        linear-gradient(
            90deg,
            #60a5fa,
            #a78bfa,
            #22d3ee
        );

    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;

    animation: textGlow 2s infinite alternate;
}

@keyframes textGlow {

    from {
        filter: drop-shadow(0 0 2px #3b82f6);
    }

    to {
        filter: drop-shadow(0 0 12px #60a5fa);
    }
}

.hello-card span {
    margin-top: 10px;

    font-size: 11px;

    color: #94a3b8;

    letter-spacing: 3px;
}


/* =========================================================
   PIPELINE
========================================================= */

.pipeline {

    position: absolute;

    left: 50%;
    top: 50%;

    transform: translate(-50%, -50%);

    width: min(1100px, 90vw);
    height: 650px;

    z-index: 5;
}


/* Connecting line */

.pipeline-line {

    position: absolute;

    left: 10%;
    right: 10%;
    top: 50%;

    height: 2px;

    background:
        linear-gradient(
            90deg,
            transparent,
            #2563eb,
            #06b6d4,
            #8b5cf6,
            #2563eb,
            transparent
        );

    box-shadow:
        0 0 10px #2563eb;

    opacity: .6;
}


/* =========================================================
   TOOL CARDS
========================================================= */

.tool {

    position: absolute;

    width: 130px;
    height: 110px;

    display: flex;
    flex-direction: column;

    align-items: center;
    justify-content: center;

    gap: 8px;

    border-radius: 18px;

    background:
        linear-gradient(
            145deg,
            rgba(15,23,42,.95),
            rgba(30,41,59,.75)
        );

    border: 1px solid rgba(96,165,250,.25);

    box-shadow:
        0 10px 30px rgba(0,0,0,.4),
        inset 0 0 20px rgba(59,130,246,.05);

    transition: .4s;

    animation: toolFloat 4s infinite ease-in-out;
}

.tool:hover {

    transform: translateY(-10px) scale(1.08);

    border-color: #60a5fa;

    box-shadow:
        0 0 30px rgba(59,130,246,.5),
        inset 0 0 20px rgba(59,130,246,.15);
}

@keyframes toolFloat {

    0%, 100% {
        margin-top: 0;
    }

    50% {
        margin-top: -8px;
    }
}


/* Icons */

.icon {

    width: 42px;
    height: 42px;

    border-radius: 12px;

    display: flex;

    align-items: center;
    justify-content: center;

    font-size: 23px;

    background:
        rgba(59,130,246,.12);

    border: 1px solid rgba(96,165,250,.2);

    box-shadow:
        0 0 15px rgba(59,130,246,.15);
}


/* Tool text */

.tool-name {

    font-size: 12px;

    font-weight: bold;

    letter-spacing: 1px;

    color: #e2e8f0;
}

.tool-type {

    font-size: 9px;

    color: #64748b;

    text-transform: uppercase;

    letter-spacing: 1px;
}


/* =========================================================
   TOOL POSITIONS
========================================================= */

/* Top row */

.git {
    left: 2%;
    top: 8%;
}

.github {
    left: 22%;
    top: 2%;
}

.jenkins {
    right: 22%;
    top: 2%;
}

.junit {
    right: 2%;
    top: 8%;
}


/* Bottom row */

.docker {
    left: 2%;
    bottom: 8%;
}

.ecr {
    left: 22%;
    bottom: 2%;
}

.kubernetes {
    right: 22%;
    bottom: 2%;
}

.production {
    right: 2%;
    bottom: 8%;
}


/* =========================================================
   PIPELINE DOTS
========================================================= */

.flow-dot {

    position: absolute;

    width: 9px;
    height: 9px;

    border-radius: 50%;

    background: #38bdf8;

    box-shadow:
        0 0 10px #38bdf8,
        0 0 25px #2563eb;

    animation: flow 4s linear infinite;
}

.dot1 {
    left: 15%;
    top: 50%;
}

.dot2 {
    left: 30%;
    top: 50%;
    animation-delay: .8s;
}

.dot3 {
    left: 45%;
    top: 50%;
    animation-delay: 1.6s;
}

.dot4 {
    left: 60%;
    top: 50%;
    animation-delay: 2.4s;
}

.dot5 {
    left: 75%;
    top: 50%;
    animation-delay: 3.2s;
}

@keyframes flow {

    0% {
        transform: scale(.5);
        opacity: 0;
    }

    20% {
        opacity: 1;
    }

    50% {
        transform: scale(1.4);
        opacity: 1;
    }

    100% {
        transform: scale(.5);
        opacity: 0;
    }
}


/* =========================================================
   STATUS
========================================================= */

.status {

    position: absolute;

    bottom: 25px;

    left: 50%;

    transform: translateX(-50%);

    z-index: 30;

    display: flex;

    align-items: center;

    gap: 10px;

    padding: 9px 18px;

    border-radius: 30px;

    background: rgba(15,23,42,.8);

    border: 1px solid rgba(34,197,94,.25);

    font-size: 10px;

    color: #94a3b8;

    letter-spacing: 2px;

    backdrop-filter: blur(10px);
}

.status-dot {

    width: 8px;
    height: 8px;

    border-radius: 50%;

    background: #22c55e;

    box-shadow:
        0 0 10px #22c55e;

    animation: statusPulse 1.5s infinite;
}

@keyframes statusPulse {

    50% {
        transform: scale(1.5);
        opacity: .5;
    }
}


/* =========================================================
   RESPONSIVE
========================================================= */

@media (max-width: 800px) {

    .pipeline {
        transform: translate(-50%, -50%) scale(.72);
    }

    .hello-card h1 {
        font-size: 25px;
    }
}

@media (max-width: 500px) {

    .pipeline {
        transform: translate(-50%, -50%) scale(.55);
    }

    .header h2 {
        font-size: 11px;
        letter-spacing: 3px;
    }
}

</style>
</head>


<body>


<!-- =====================================================
     BACKGROUND
===================================================== -->

<div class="background">

    <div class="grid"></div>

    <div class="particle p1"></div>
    <div class="particle p2"></div>
    <div class="particle p3"></div>
    <div class="particle p4"></div>
    <div class="particle p5"></div>
    <div class="particle p6"></div>

</div>


<!-- =====================================================
     HEADER
===================================================== -->

<div class="header">

    <h2>DevOps CI/CD Pipeline</h2>

    <p>
        AUTOMATED BUILD • TEST • CONTAINERIZE • DEPLOY
    </p>

</div>


<!-- =====================================================
     PIPELINE
===================================================== -->

<div class="pipeline">


    <!-- Connecting line -->

    <div class="pipeline-line"></div>


    <!-- Animated data packets -->

    <div class="flow-dot dot1"></div>
    <div class="flow-dot dot2"></div>
    <div class="flow-dot dot3"></div>
    <div class="flow-dot dot4"></div>
    <div class="flow-dot dot5"></div>


    <!-- =================================================
         GIT
    ================================================== -->

    <div class="tool git">

        <div class="icon">
            🌳
        </div>

        <div class="tool-name">
            Git
        </div>

        <div class="tool-type">
            Version Control
        </div>

    </div>


    <!-- =================================================
         GITHUB
    ================================================== -->

    <div class="tool github">

        <div class="icon">
            🐙
        </div>

        <div class="tool-name">
            GitHub
        </div>

        <div class="tool-type">
            Source Code
        </div>

    </div>


    <!-- =================================================
         JENKINS
    ================================================== -->

    <div class="tool jenkins">

        <div class="icon">
            ⚙️
        </div>

        <div class="tool-name">
            Jenkins
        </div>

        <div class="tool-type">
            CI / CD
        </div>

    </div>


    <!-- =================================================
         JUNIT
    ================================================== -->

    <div class="tool junit">

        <div class="icon">
            🧪
        </div>

        <div class="tool-name">
            JUnit
        </div>

        <div class="tool-type">
            Testing
        </div>

    </div>


    <!-- =================================================
         DOCKER
    ================================================== -->

    <div class="tool docker">

        <div class="icon">
            🐳
        </div>

        <div class="tool-name">
            Docker
        </div>

        <div class="tool-type">
            Container
        </div>

    </div>


    <!-- =================================================
         AMAZON ECR
    ================================================== -->

    <div class="tool ecr">

        <div class="icon">
            ☁️
        </div>

        <div class="tool-name">
            Amazon ECR
        </div>

        <div class="tool-type">
            Container Registry
        </div>

    </div>


    <!-- =================================================
         KUBERNETES
    ================================================== -->

    <div class="tool kubernetes">

        <div class="icon">
            ☸️
        </div>

        <div class="tool-name">
            Kubernetes
        </div>

        <div class="tool-type">
            Orchestration
        </div>

    </div>


    <!-- =================================================
         PRODUCTION
    ================================================== -->

    <div class="tool production">

        <div class="icon">
            🚀
        </div>

        <div class="tool-name">
            Production
        </div>

        <div class="tool-type">
            Deployment
        </div>

    </div>


</div>


<!-- =====================================================
     CENTER HELLO WORLD
===================================================== -->

<div class="center">

    <div class="hello-card">

        <h1>Hello, World!</h1>

        <span>JAVA • JSP</span>

    </div>

</div>


<!-- =====================================================
     STATUS
===================================================== -->

<div class="status">

    <div class="status-dot"></div>

    PIPELINE READY

</div>


</body>
</html>
