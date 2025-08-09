<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User, beans.Student, beans.Attendance, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance - Student Portal</title>
    <style>
        :root {
            --primary: #4a6fa5;
            --secondary: #166088;
            --accent: #4fc3f7;
            --light: #f8f9fa;
            --dark: #343a40;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
            color: #333;
        }
        
        .dashboard {
            display: grid;
            grid-template-columns: 250px 1fr;
            min-height: 100vh;
        }
        
        .sidebar {
            background: linear-gradient(180deg, var(--primary), var(--secondary));
            color: white;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar-header {
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 20px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 10px;
        }
        
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover {
            background-color: rgba(255,255,255,0.1);
        }
        
        .sidebar-menu a.active {
            background-color: rgba(255,255,255,0.2);
        }
        
        .main-content {
            padding: 30px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--accent);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .stat-number.success { color: var(--success); }
        .stat-number.warning { color: var(--warning); }
        .stat-number.danger { color: var(--danger); }
        
        .progress-ring {
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
        }
        
        .progress-ring circle {
            stroke-width: 8;
            fill: transparent;
            r: 52;
            cx: 60;
            cy: 60;
        }
        
        .progress-ring .background {
            stroke: #e9ecef;
        }
        
        .progress-ring .progress {
            stroke: var(--success);
            stroke-linecap: round;
            stroke-dasharray: 327;
            stroke-dashoffset: 327;
            transform: rotate(-90deg);
            transform-origin: 50% 50%;
            transition: stroke-dashoffset 1s ease-in-out;
        }
        
        .attendance-table {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .table th {
            background-color: var(--light);
            font-weight: 600;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-present {
            background-color: #d4edda;
            color: var(--success);
        }
        
        .status-absent {
            background-color: #f8d7da;
            color: var(--danger);
        }
        
        .logout-btn {
            background-color: var(--danger);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .logout-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>Student Portal</h2>
            </div>
            <ul class="sidebar-menu">
			    <li><a href="${pageContext.request.contextPath}/student/dashboard" class="active">Dashboard</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/attendance">Attendance</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/marks">Marks & Grades</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/subjects">Subjects</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/leaderboard">Ranking</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/profile">Resumebuilder</a></li>
			</ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Attendance Record</h1>
                <div class="user-profile">
                    <div class="user-avatar">
                        ${student.name.charAt(0)}
                    </div>
                    <span>${student.name}</span>
                    <form action="${pageContext.request.contextPath}/" method="post" style="margin-left: 20px;">
                        <input type="submit" class="logout-btn" value="Logout">
                    </form>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Overall Attendance</h3>
                    <svg class="progress-ring">
                        <circle class="background" />
                        <circle class="progress" style="stroke-dashoffset: ${327 - (327 * attendanceStats['Overall'] / 100)};" />
                    </svg>
                    <div class="stat-number success">
                        <fmt:formatNumber value="${attendanceStats['Overall']}" pattern="#0.0" />%
                    </div>
                    <p>This Semester</p>
                </div>
                
                <div class="stat-card">
                    <h3>Classes Attended</h3>
                    <div class="stat-number success">${attendanceStatistics['present']}</div>
                    <p>Total Present Days</p>
                </div>
                
                <div class="stat-card">
                    <h3>Classes Missed</h3>
                    <div class="stat-number danger">${attendanceStatistics['absent']}</div>
                    <p>Total Absent Days</p>
                </div>
                
                <div class="stat-card">
                    <h3>Total Classes</h3>
                    <div class="stat-number">${attendanceStatistics['total']}</div>
                    <p>This Semester</p>
                </div>
            </div>
            
            <!-- Subject-wise Attendance -->
            <div class="attendance-table">
                <h3>Subject-wise Attendance</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Attendance %</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="attendance" items="${attendanceStats}">
                            <c:if test="${attendance.key != 'Overall'}">
                                <tr>
                                    <td>${attendance.key}</td>
                                    <td><fmt:formatNumber value="${attendance.value}" pattern="#0.0" />%</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${attendance.value >= 75}">
                                                <span class="status-badge status-present">Good</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-absent">Low</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Detailed Attendance Record -->
            <div class="attendance-table" style="margin-top: 30px;">
                <h3>Detailed Attendance Record</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Subject</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="attendance" items="${attendanceList}">
                            <tr>
                                <td><fmt:formatDate value="${attendance.date}" pattern="MMM dd, yyyy" /></td>
                                <td>${attendance.subjectName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${attendance.status == 'Present'}">
                                            <span class="status-badge status-present">Present</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-absent">Absent</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>