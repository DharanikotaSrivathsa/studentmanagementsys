<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User, beans.Student, beans.Leaderboard, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Class Ranking</title>
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
        .ranking-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .rank-card {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 30px 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            position: relative;
            overflow: hidden;
        }
        
        .rank-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: rotate(45deg);
            animation: shine 3s infinite;
        }
        
        @keyframes shine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
        }
        
        .rank-number {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .rank-label {
            font-size: 16px;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .rank-detail {
            font-size: 14px;
            opacity: 0.8;
        }
        
        .gpa-card {
            background: linear-gradient(135deg, var(--success), #20c997);
            color: white;
            padding: 30px 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .percentile-card {
            background: linear-gradient(135deg, var(--warning), #fd7e14);
            color: white;
            padding: 30px 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .leaderboard-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .section-title::before {
            content: '🏆';
            margin-right: 10px;
            font-size: 28px;
        }
        
        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .leaderboard-table th,
        .leaderboard-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .leaderboard-table th {
            background: linear-gradient(135deg, var(--light), #e9ecef);
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid var(--primary);
        }
        
        .leaderboard-table tr {
            transition: all 0.3s ease;
        }
        
        .leaderboard-table tr:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
        
        .rank-position {
            font-weight: bold;
            font-size: 18px;
            color: var(--primary);
            min-width: 60px;
            text-align: center;
        }
        
        .rank-1 .rank-position {
            color: #ffd700;
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
        }
        
        .rank-2 .rank-position {
            color: #c0c0c0;
            text-shadow: 0 0 10px rgba(192, 192, 192, 0.5);
        }
        
        .rank-3 .rank-position {
            color: #cd7f32;
            text-shadow: 0 0 10px rgba(205, 127, 50, 0.5);
        }
        
        .rank-1::before {
            content: '👑';
            margin-right: 10px;
        }
        
        .student-name {
            font-weight: 600;
            color: var(--dark);
        }
        
        .student-info {
            color: #666;
            font-size: 14px;
            margin-top: 2px;
        }
        
        .gpa-display {
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 20px;
            color: white;
            font-size: 14px;
        }
        
        .gpa-excellent {
            background: linear-gradient(135deg, var(--success), #20c997);
        }
        
        .gpa-good {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .gpa-average {
            background: linear-gradient(135deg, var(--warning), #fd7e14);
        }
        
        .gpa-below {
            background: linear-gradient(135deg, var(--danger), #dc3545);
        }
        
        .current-student {
            background: linear-gradient(135deg, rgba(74, 111, 165, 0.1), rgba(79, 195, 247, 0.1));
            border-left: 4px solid var(--primary);
            font-weight: 600;
        }
        
        .achievement-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--accent), #4fc3f7);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .progress-indicator {
            margin-top: 20px;
            padding: 15px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            border-left: 4px solid var(--primary);
        }
        
        .progress-text {
            color: var(--dark);
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .progress-detail {
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
                <h1>Class Ranking</h1>
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
            
            <!-- Ranking Overview -->
            <div class="ranking-overview">
                <div class="rank-card">
                    <div class="rank-number">#${studentRank.rank}</div>
                    <div class="rank-label">Your Rank</div>
                    <div class="rank-detail">Semester ${studentRank.semester}</div>
                </div>
                
                <div class="gpa-card">
                    <div class="rank-number"><fmt:formatNumber value="${gpa}" pattern="#0.00" /></div>
                    <div class="rank-label">Your GPA</div>
                    <div class="rank-detail">Out of 4.00</div>
                </div>
                
                <div class="percentile-card">
                    <div class="rank-number"><fmt:formatNumber value="${percentile}" pattern="#0" />%</div>
                    <div class="rank-label">Percentile</div>
                    <div class="rank-detail">Better than <fmt:formatNumber value="${100 - percentile}" pattern="#0" />% students</div>
                </div>
            </div>
            
            <!-- Progress Indicator -->
            <div class="progress-indicator">
                <div class="progress-text">Performance Summary</div>
                <div class="progress-detail">
                    You are ranked <strong>#${studentRank.rank}</strong> out of <strong>${studentRank.totalStudents}</strong> students 
                    with a GPA of <strong><fmt:formatNumber value="${gpa}" pattern="#0.00" /></strong>. 
                    You're performing better than <strong><fmt:formatNumber value="${100 - percentile}" pattern="#0" />%</strong> of your classmates!
                </div>
            </div>
            
            <!-- Top Students Leaderboard -->
            <div class="leaderboard-section">
                <h2 class="section-title">Top Performers</h2>
                
                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Student</th>
                            <th>GPA</th>
                            <th>Semester</th>
                            <th>Achievement</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="leader" items="${topStudents}" varStatus="status">
                            <tr class="rank-${leader.rank} ${leader.studentId == student.studentId ? 'current-student' : ''}">
                                <td class="rank-position">${leader.rank}</td>
                                <td>
                                    <div class="student-name">
                                        <c:choose>
                                            <c:when test="${leader.studentId == student.studentId}">
                                                ${student.name} (You)
                                            </c:when>
                                            <c:otherwise>
                                                Student ${leader.studentId}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="student-info">
                                        <c:if test="${leader.studentId == student.studentId}">
                                            ${student.rollNumber} • ${student.department}
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <span class="gpa-display 
                                        <c:choose>
                                            <c:when test="${leader.gpa >= 3.7}">gpa-excellent</c:when>
                                            <c:when test="${leader.gpa >= 3.0}">gpa-good</c:when>
                                            <c:when test="${leader.gpa >= 2.0}">gpa-average</c:when>
                                            <c:otherwise>gpa-below</c:otherwise>
                                        </c:choose>">
                                        <fmt:formatNumber value="${leader.gpa}" pattern="#0.00" />
                                    </span>
                                </td>
                                <td>Semester ${leader.semester}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${leader.rank == 1}">
                                            <span class="achievement-badge" style="background: linear-gradient(135deg, #ffd700, #ffed4e);">🥇 Top Performer</span>
                                        </c:when>
                                        <c:when test="${leader.rank == 2}">
                                            <span class="achievement-badge" style="background: linear-gradient(135deg, #c0c0c0, #e8e8e8);">🥈 Excellence</span>
                                        </c:when>
                                        <c:when test="${leader.rank == 3}">
                                            <span class="achievement-badge" style="background: linear-gradient(135deg, #cd7f32, #daa520);">🥉 High Achiever</span>
                                        </c:when>
                                        <c:when test="${leader.gpa >= 3.5}">
                                            <span class="achievement-badge">⭐ Honor Roll</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="achievement-badge">📚 Scholar</span>
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