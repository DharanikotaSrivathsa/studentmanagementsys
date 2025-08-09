package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import beans.Student;
import beans.Subject;
import beans.Attendance;
import beans.Mark;
import beans.Leaderboard;
import beans.SubjectCredit;
import util.DBConnection;

public class StudentDao {
    private Connection connection;
    
    public StudentDao() {
        try {
            this.connection = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error establishing database connection: " + e.getMessage());
        }
    }
    
    public Student getStudentByUserId(int userId) {
        Student student = null;
        String query = "SELECT s.*, u.username FROM students s JOIN users u ON s.user_id = u.user_id WHERE s.user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDateOfBirth(rs.getDate("date_of_birth"));
                student.setAddress(rs.getString("address"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                student.setUsername(rs.getString("username"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    public Student getStudentById(int studentId) {
        Student student = null;
        String query = "SELECT s.*, u.username FROM students s JOIN users u ON s.user_id = u.user_id WHERE s.student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDateOfBirth(rs.getDate("date_of_birth"));
                student.setAddress(rs.getString("address"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                student.setUsername(rs.getString("username"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    public List<Attendance> getStudentAttendance(int studentId) {
        List<Attendance> attendanceList = new ArrayList<>();
        String query = "SELECT a.*, s.subject_name " +
                      "FROM attendance a " +
                      "JOIN subjects s ON a.subject_id = s.subject_id " +
                      "WHERE a.student_id = ? " +
                      "ORDER BY a.date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendance_id"));
                attendance.setStudentId(rs.getInt("student_id"));
                attendance.setSubjectId(rs.getInt("subject_id"));
                attendance.setDate(rs.getDate("date"));
                attendance.setStatus(rs.getString("status"));
                attendance.setSubjectName(rs.getString("subject_name"));
                attendanceList.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceList;
    }
    
    public Map<String, Double> getAttendancePercentage(int studentId) {
        Map<String, Double> attendanceStats = new HashMap<>();
        String query = "SELECT s.subject_name, " +
                     "COUNT(CASE WHEN a.status = 'Present' THEN 1 END) as present_count, " +
                     "COUNT(*) as total_count " +
                     "FROM attendance a " +
                     "JOIN subjects s ON a.subject_id = s.subject_id " +
                     "WHERE a.student_id = ? " +
                     "GROUP BY s.subject_id, s.subject_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            double totalPresent = 0;
            double totalClasses = 0;
            
            while (rs.next()) {
                String subjectName = rs.getString("subject_name");
                int presentCount = rs.getInt("present_count");
                int totalCount = rs.getInt("total_count");
                
                totalPresent += presentCount;
                totalClasses += totalCount;
                
                double percentage = (double) presentCount / totalCount * 100;
                attendanceStats.put(subjectName, percentage);
            }
            
            // Calculate overall attendance percentage
            if (totalClasses > 0) {
                double overallPercentage = totalPresent / totalClasses * 100;
                attendanceStats.put("Overall", overallPercentage);
            } else {
                attendanceStats.put("Overall", 0.0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceStats;
    }
    
    public List<Mark> getStudentMarks(int studentId) {
        List<Mark> marksList = new ArrayList<>();
        String query = "SELECT m.*, s.subject_name " +
                      "FROM marks m " +
                      "JOIN subjects s ON m.subject_id = s.subject_id " +
                      "WHERE m.student_id = ? " +
                      "ORDER BY s.subject_name, m.exam_type";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Mark mark = new Mark();
                mark.setMarkId(rs.getInt("mark_id"));
                mark.setStudentId(rs.getInt("student_id"));
                mark.setSubjectId(rs.getInt("subject_id"));
                mark.setExamType(rs.getString("exam_type"));
                mark.setMarksObtained(rs.getDouble("marks_obtained"));
                mark.setTotalMarks(rs.getDouble("total_marks"));
                mark.setSubjectName(rs.getString("subject_name"));
                marksList.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }
    
    public Map<String, String> getSubjectGrades(int studentId) {
        Map<String, String> subjectGrades = new HashMap<>();
        String query = "SELECT s.subject_name, " +
                     "SUM(m.marks_obtained) as total_obtained, " +
                     "SUM(m.total_marks) as total_possible " +
                     "FROM marks m " +
                     "JOIN subjects s ON m.subject_id = s.subject_id " +
                     "WHERE m.student_id = ? " +
                     "GROUP BY s.subject_id, s.subject_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String subjectName = rs.getString("subject_name");
                double totalObtained = rs.getDouble("total_obtained");
                double totalPossible = rs.getDouble("total_possible");
                
                double percentage = (totalObtained / totalPossible) * 100;
                String grade = calculateGrade(percentage);
                
                subjectGrades.put(subjectName, grade);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subjectGrades;
    }
    
    public double getGPA(int studentId) {
        Map<String, String> grades = getSubjectGrades(studentId);
        double totalPoints = 0;
        int totalSubjects = grades.size();
        
        for (String grade : grades.values()) {
            totalPoints += convertGradeToPoints(grade);
        }
        
        return totalSubjects > 0 ? totalPoints / totalSubjects : 0;
    }
    
    private double convertGradeToPoints(String grade) {
        switch (grade) {
            case "A+": return 4.0;
            case "A": return 4.0;
            case "A-": return 3.7;
            case "B+": return 3.3;
            case "B": return 3.0;
            case "B-": return 2.7;
            case "C+": return 2.3;
            case "C": return 2.0;
            case "C-": return 1.7;
            case "D+": return 1.3;
            case "D": return 1.0;
            default: return 0.0;
        }
    }
    
    private String calculateGrade(double percentage) {
        if (percentage >= 97) return "A+";
        if (percentage >= 93) return "A";
        if (percentage >= 90) return "A-";
        if (percentage >= 87) return "B+";
        if (percentage >= 83) return "B";
        if (percentage >= 80) return "B-";
        if (percentage >= 77) return "C+";
        if (percentage >= 73) return "C";
        if (percentage >= 70) return "C-";
        if (percentage >= 67) return "D+";
        if (percentage >= 60) return "D";
        return "F";
    }
    
    public List<Subject> getStudentSubjects(int studentId) {
        List<Subject> subjectList = new ArrayList<>();
        String query = "SELECT DISTINCT s.* " +
                      "FROM subjects s " +
                      "JOIN marks m ON s.subject_id = m.subject_id " +
                      "WHERE m.student_id = ? " +
                      "ORDER BY s.semester, s.subject_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectName(rs.getString("subject_name"));
                subject.setSubjectCode(rs.getString("subject_code"));
                subject.setCreditHours(rs.getInt("credit_hours"));
                subject.setSemester(rs.getInt("semester"));
                subjectList.add(subject);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subjectList;
    }
    
    public Leaderboard getStudentRank(int studentId) {
        Leaderboard leaderboard = null;
        String query = "SELECT * FROM leaderboard WHERE student_id = ? ORDER BY semester DESC LIMIT 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                leaderboard = new Leaderboard();
                leaderboard.setLeaderboardId(rs.getInt("leaderboard_id"));
                leaderboard.setStudentId(rs.getInt("student_id"));
                leaderboard.setGpa(rs.getDouble("gpa"));
                leaderboard.setRank(rs.getInt("rank"));
                leaderboard.setSemester(rs.getInt("semester"));
                
                // Get total number of students for percentage calculation
                String countQuery = "SELECT COUNT(*) as total FROM leaderboard WHERE semester = ?";
                try (PreparedStatement countStmt = connection.prepareStatement(countQuery)) {
                    countStmt.setInt(1, leaderboard.getSemester());
                    ResultSet countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        int totalStudents = countRs.getInt("total");
                        leaderboard.setTotalStudents(totalStudents);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaderboard;
    }
    
    public List<SubjectCredit> getStudentSubjectCredits(int studentId) {
        List<SubjectCredit> creditsList = new ArrayList<>();
        String query = "SELECT sc.*, s.subject_name " +
                      "FROM subjectcredits sc " +
                      "JOIN subjects s ON sc.subject_id = s.subject_id " +
                      "WHERE sc.student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SubjectCredit credit = new SubjectCredit();
                credit.setCreditId(rs.getInt("credit_id"));
                credit.setSubjectId(rs.getInt("subject_id"));
                credit.setStudentId(rs.getInt("student_id"));
                credit.setCreditsEarned(rs.getInt("credits_earned"));
                credit.setSubjectName(rs.getString("subject_name"));
                creditsList.add(credit);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return creditsList;
    }
    
 // Add these methods to your existing StudentDao.java class

    public List<Leaderboard> getTopRankedStudents(int limit) {
        List<Leaderboard> topStudents = new ArrayList<>();
        String query = "SELECT l.*, s.name, s.roll_number " +
                      "FROM leaderboard l " +
                      "JOIN students s ON l.student_id = s.student_id " +
                      "ORDER BY l.rank ASC " +
                      "LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Leaderboard leaderboard = new Leaderboard();
                leaderboard.setLeaderboardId(rs.getInt("leaderboard_id"));
                leaderboard.setStudentId(rs.getInt("student_id"));
                leaderboard.setGpa(rs.getDouble("gpa"));
                leaderboard.setRank(rs.getInt("rank"));
                leaderboard.setSemester(rs.getInt("semester"));
                
                // You'll need to add these fields to Leaderboard bean
                // leaderboard.setStudentName(rs.getString("name"));
                // leaderboard.setRollNumber(rs.getString("roll_number"));
                
                topStudents.add(leaderboard);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return topStudents;
    }

    public Map<String, Integer> getAttendanceStatistics(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        String query = "SELECT " +
                      "COUNT(CASE WHEN status = 'Present' THEN 1 END) as present, " +
                      "COUNT(CASE WHEN status = 'Absent' THEN 1 END) as absent, " +
                      "COUNT(*) as total " +
                      "FROM attendance WHERE student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                stats.put("present", rs.getInt("present"));
                stats.put("absent", rs.getInt("absent"));
                stats.put("total", rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }

    public List<Mark> getMarksByExamType(int studentId, String examType) {
        List<Mark> marksList = new ArrayList<>();
        String query = "SELECT m.*, s.subject_name " +
                      "FROM marks m " +
                      "JOIN subjects s ON m.subject_id = s.subject_id " +
                      "WHERE m.student_id = ? AND m.exam_type = ? " +
                      "ORDER BY s.subject_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setString(2, examType);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Mark mark = new Mark();
                mark.setMarkId(rs.getInt("mark_id"));
                mark.setStudentId(rs.getInt("student_id"));
                mark.setSubjectId(rs.getInt("subject_id"));
                mark.setExamType(rs.getString("exam_type"));
                mark.setMarksObtained(rs.getDouble("marks_obtained"));
                mark.setTotalMarks(rs.getDouble("total_marks"));
                mark.setSubjectName(rs.getString("subject_name"));
                marksList.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return marksList;
    }

    public List<String> getDistinctExamTypes(int studentId) {
        List<String> examTypes = new ArrayList<>();
        String query = "SELECT DISTINCT exam_type FROM marks WHERE student_id = ? ORDER BY exam_type";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                examTypes.add(rs.getString("exam_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return examTypes;
    }
    
    
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}