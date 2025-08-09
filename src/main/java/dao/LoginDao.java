package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.User;
import util.DBConnection;

public class LoginDao {
    private Connection connection;
    
    public LoginDao() {
        try {
            this.connection = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error establishing database connection: " + e.getMessage());
        }
    }
    
    public User authenticate(String username, String password) {
        User user = null;
        String query = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password); // No hashing, direct password comparison
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
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