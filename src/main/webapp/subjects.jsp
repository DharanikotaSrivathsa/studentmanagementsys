<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User, beans.Student, beans.Subject, beans.SubjectCredit, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subjects</title>
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
        
        .widgets {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .widget {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .widget:hover {
            transform: translateY(-5px);
        }
        
        .widget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .widget-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
        }
        
        .widget-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
        }
        
        .progress-container {
            margin-top: 15px;
        }
        
        .progress-bar {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress {
            height: 100%;
            background-color: var(--success);
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .data-table th {
            background-color: var(--light);
            font-weight: 600;
        }
        
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: #d4edda;
            color: var(--success);
        }
        
        .badge-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .badge-danger {
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

    <style>
        .subjects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .subject-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .subject-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        }
        
        .subject-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .subject-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
            margin: 0;
        }
        
        .subject-code {
            background-color: var(--primary);
            color: white;
            padding: 4px 8px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .subject-details {
            margin-bottom: 15px;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        
        .detail-label {
            color: #666;
            font-size: 14px;
        }
        
        .detail-value {
            font-weight: 600;
            color: var(--dark);
        }
        
        .credits-earned {
            background-color: var(--light);
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            margin-top: 10px;
        }
        
        .credits-number {
            font-size: 24px;
            font-weight: bold;
            color: var(--success);
        }
        
        .credits-label {
            font-size: 12px;
            color: #666;
        }
        
        .semester-badge {
            background-color: var(--accent);
            color: white;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .credit-hours {
            background-color: var(--warning);
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .summary-value {
            font-size: 32px;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 5px;
        }
        
        .summary-label {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="dashboard">
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
                <h1>My Subjects</h1>
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
            
            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-value">${subjects.size()}</div>
                    <div class="summary-label">Total Subjects</div>
                </div>
                <div class="summary-card">
                    <div class="summary-value">
                        <c:set var="totalCredits" value="0" />
                        <c:forEach var="credit" items="${credits}">
                            <c:set var="totalCredits" value="${totalCredits + credit.creditsEarned}" />
                        </c:forEach>
                        ${totalCredits}
                    </div>
                    <div class="summary-label">Credits Earned</div>
                </div>
                <div class="summary-card">
                    <div class="summary-value">
                        <c:set var="totalCreditHours" value="0" />
                        <c:forEach var="subject" items="${subjects}">
                            <c:set var="totalCreditHours" value="${totalCreditHours + subject.creditHours}" />
                        </c:forEach>
                        ${totalCreditHours}
                    </div>
                    <div class="summary-label">Total Credit Hours</div>
                </div>
                <div class="summary-card">
                    <div class="summary-value">${student.semester}</div>
                    <div class="summary-label">Current Semester</div>
                </div>
            </div>
            
            <!-- Subjects Grid -->
            <div class="subjects-grid">
                <c:forEach var="subject" items="${subjects}">
                    <div class="subject-card">
                        <div class="subject-header">
                            <h3 class="subject-title">${subject.subjectName}</h3>
                            <span class="subject-code">${subject.subjectCode}</span>
                        </div>
                        
                        <div class="subject-details">
                            <div class="detail-row">
                                <span class="detail-label">Semester:</span>
                                <span class="detail-value">
                                    <span class="semester-badge">Sem ${subject.semester}</span>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Credit Hours:</span>
                                <span class="detail-value">
                                    <span class="credit-hours">${subject.creditHours} hrs</span>
                                </span>
                            </div>
                        </div>
                        
                        <div class="credits-earned">
                            <c:set var="subjectCredit" value="0" />
                            <c:forEach var="credit" items="${credits}">
                                <c:if test="${credit.subjectId == subject.subjectId}">
                                    <c:set var="subjectCredit" value="${credit.creditsEarned}" />
                                </c:if>
                            </c:forEach>
                            <div class="credits-number">${subjectCredit}</div>
                            <div class="credits-label">Credits Earned</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>