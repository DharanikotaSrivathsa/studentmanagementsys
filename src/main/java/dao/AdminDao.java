package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import beans.Admins;
import beans.Student;
import beans.Teachers;
import util.DBConnection;

public class AdminDao {
    private Connection connection;
    
    public AdminDao() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public Admins getAdminByUserId(int userId) throws SQLException {
        Admins admin = null;
        String sql = "SELECT * FROM admins WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    admin = new Admins();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUserId(rs.getInt("user_id"));
                    admin.setName(rs.getString("name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                }
            }
        }
        
        return admin;
    }
    
    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.*, u.username FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Student student = new Student();
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
                
                students.add(student);
            }
        }
        
        return students;
    }
    
    public List<Teachers> getAllTeachers() throws SQLException {
        List<Teachers> teachers = new ArrayList<>();
        String sql = "SELECT t.*, u.username FROM teachers t " +
                     "JOIN users u ON t.user_id = u.user_id";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Teachers teacher = new Teachers();
                teacher.setTeacherId(rs.getInt("teacher_id"));
                teacher.setUserId(rs.getInt("user_id"));
                teacher.setName(rs.getString("name"));
                teacher.setEmail(rs.getString("email"));
                teacher.setPhone(rs.getString("phone"));
                teacher.setDepartment(rs.getString("department"));
                teacher.setQualification(rs.getString("qualification"));
                
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    public Map<String, Integer> getDepartmentStudentCounts() throws SQLException {
        Map<String, Integer> departmentCounts = new HashMap<>();
        String sql = "SELECT department, COUNT(*) as count FROM students GROUP BY department";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                departmentCounts.put(rs.getString("department"), rs.getInt("count"));
            }
        }
        
        return departmentCounts;
    }
    
    public Map<String, Integer> getDepartmentTeacherCounts() throws SQLException {
        Map<String, Integer> departmentCounts = new HashMap<>();
        String sql = "SELECT department, COUNT(*) as count FROM teachers GROUP BY department";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                departmentCounts.put(rs.getString("department"), rs.getInt("count"));
            }
        }
        
        return departmentCounts;
    }
    
    public Map<Integer, Integer> getSemesterStudentCounts() throws SQLException {
        Map<Integer, Integer> semesterCounts = new HashMap<>();
        String sql = "SELECT semester, COUNT(*) as count FROM students GROUP BY semester";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                semesterCounts.put(rs.getInt("semester"), rs.getInt("count"));
            }
        }
        
        return semesterCounts;
    }
    
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}