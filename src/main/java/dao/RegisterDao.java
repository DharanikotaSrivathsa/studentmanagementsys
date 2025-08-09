package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import beans.Student;
import beans.Teachers;
import beans.User;
import util.DBConnection;

public class RegisterDao {
    private Connection connection;
    
    public RegisterDao() {
        try {
            this.connection = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error establishing database connection: " + e.getMessage());
        }
    }
    
    public boolean isUsernameAvailable(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                return count == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean registerNewStudent(User user, Student student) {
        try {
            connection.setAutoCommit(false); // Start transaction
            
            // First create the user
            int userId = registerUser(user);
            if (userId == -1) {
                connection.rollback();
                return false;
            }
            
            // Set the generated user_id to student object
            student.setUserId(userId);
            
            // Then register the student
            boolean studentRegistered = registerStudent(student);
            if (studentRegistered) {
                connection.commit();
                return true;
            } else {
                connection.rollback();
                return false;
            }
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean registerNewTeacher(User user, Teachers teacher) {
        try {
            connection.setAutoCommit(false); // Start transaction
            
            // First create the user
            int userId = registerUser(user);
            if (userId == -1) {
                connection.rollback();
                return false;
            }
            
            // Set the generated user_id to teacher object
            teacher.setUserId(userId);
            
            // Then register the teacher
            boolean teacherRegistered = registerTeacher(teacher);
            if (teacherRegistered) {
                connection.commit();
                return true;
            } else {
                connection.rollback();
                return false;
            }
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private int registerUser(User user) {
        String query = "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return the generated user_id
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public boolean registerStudent(Student student) {
        String query = "INSERT INTO students (user_id, name, roll_number, email, phone, date_of_birth, address, department, semester) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, student.getUserId());
            stmt.setString(2, student.getName());
            stmt.setString(3, student.getRollNumber());
            stmt.setString(4, student.getEmail());
            stmt.setString(5, student.getPhone());
            stmt.setDate(6, student.getDateOfBirth());
            stmt.setString(7, student.getAddress());
            stmt.setString(8, student.getDepartment());
            stmt.setInt(9, student.getSemester());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean registerTeacher(Teachers teacher) {

        
        String query = "INSERT INTO teachers (user_id, name, email, phone, department, qualification) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, teacher.getUserId());
            stmt.setString(2, teacher.getName());
            stmt.setString(3, teacher.getEmail());
            stmt.setString(4, teacher.getPhone());
            stmt.setString(5, teacher.getDepartment());
            stmt.setString(6, teacher.getQualification());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
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