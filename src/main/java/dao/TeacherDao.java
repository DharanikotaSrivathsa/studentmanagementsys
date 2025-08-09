package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Mark;
import beans.Student;
import beans.Subject;
import beans.Teachers;
import util.DBConnection;

public class TeacherDao {
    private Connection connection;
    
    public TeacherDao() {
        try {
            this.connection = DBConnection.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error establishing database connection: " + e.getMessage());
        }
    }
    
    public Teachers getTeacherByUserId(int userId) {
        Teachers teacher = null;
        String query = "SELECT t.*, u.username FROM teachers t JOIN users u ON t.user_id = u.user_id WHERE t.user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                teacher = new Teachers();
                teacher.setTeacherId(rs.getInt("teacher_id"));
                teacher.setUserId(rs.getInt("user_id"));
                teacher.setName(rs.getString("name"));
                teacher.setEmail(rs.getString("email"));
                teacher.setPhone(rs.getString("phone"));
                teacher.setDepartment(rs.getString("department"));
                teacher.setQualification(rs.getString("qualification"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teacher;
    }

    public String getAttendanceStatus(int studentId, int subjectId, Date date) {
        String query = "SELECT status FROM attendance WHERE student_id = ? AND subject_id = ? AND date = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setDate(3, date);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // No attendance record found
    }
    
    public List<Mark> getStudentsMarksBySemester(int semester) {
        List<Mark> list = new ArrayList<>();
        String query = "SELECT m.id, s.id AS student_id, s.name, sub.name AS subject, m.marks, sub.id AS subject_id " +
                       "FROM marks m " +
                       "JOIN students s ON m.student_id = s.id " +
                       "JOIN subjects sub ON m.subject_id = sub.id " +
                       "WHERE s.semester = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, semester);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Mark mark = new Mark();
                mark.setMarkId(rs.getInt("id"));
                mark.setStudentId(rs.getInt("student_id"));
                mark.setStudentName(rs.getString("name"));  // Add setter in Mark.java
                mark.setSubjectName(rs.getString("subject"));
                mark.setMarksObtained(rs.getInt("marks"));
                mark.setSubjectId(rs.getInt("subject_id"));
                list.add(mark);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update marks
    public boolean updateMark(int markId, int newMarks) {
        String query = "UPDATE marks SET marks = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, newMarks);
            ps.setInt(2, markId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
    public List<Mark> getMarksWithDetailsBySemester(int semester) {
        List<Mark> marks = new ArrayList<>();
        String query = "SELECT m.mark_id, m.student_id, m.subject_id, m.exam_type, " +
                       "m.marks_obtained, m.total_marks, s.name as student_name, " +
                       "s.roll_number, sub.subject_name, sub.subject_code " +
                       "FROM marks m " +
                       "JOIN students s ON m.student_id = s.student_id " +
                       "JOIN subjects sub ON m.subject_id = sub.subject_id " +
                       "WHERE s.semester = ? " +
                       "ORDER BY s.roll_number, sub.subject_name, m.exam_type";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, semester);
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
                // Add these fields to Mark.java if not present
                mark.setStudentName(rs.getString("student_name"));
                mark.setRollNumber(rs.getString("roll_number"));
                mark.setSubjectCode(rs.getString("subject_code"));
                marks.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return marks;
    }

    // Get marks for a specific student
    public List<Mark> getMarksByStudentId(int studentId) {
        List<Mark> marks = new ArrayList<>();
        String query = "SELECT m.mark_id, m.student_id, m.subject_id, m.exam_type, " +
                       "m.marks_obtained, m.total_marks, sub.subject_name, sub.subject_code " +
                       "FROM marks m " +
                       "JOIN subjects sub ON m.subject_id = sub.subject_id " +
                       "WHERE m.student_id = ? " +
                       "ORDER BY sub.subject_name, m.exam_type";
        
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
                mark.setSubjectCode(rs.getString("subject_code"));
                marks.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return marks;
    }

    // Insert new marks
    public boolean insertMarks(int studentId, int subjectId, String examType, 
                              double marksObtained, double totalMarks) {
        String query = "INSERT INTO marks (student_id, subject_id, exam_type, marks_obtained, total_marks) " +
                       "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setString(3, examType);
            stmt.setDouble(4, marksObtained);
            stmt.setDouble(5, totalMarks);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing marks
    public boolean updateMarks(int markId, double marksObtained, double totalMarks) {
        String query = "UPDATE marks SET marks_obtained = ?, total_marks = ? WHERE mark_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDouble(1, marksObtained);
            stmt.setDouble(2, totalMarks);
            stmt.setInt(3, markId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete marks
    public boolean deleteMarks(int markId) {
        String query = "DELETE FROM marks WHERE mark_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, markId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get marks by semester and subject
    public List<Mark> getMarksBySemesterAndSubject(int semester, int subjectId) {
        List<Mark> marks = new ArrayList<>();
        String query = "SELECT m.mark_id, m.student_id, m.subject_id, m.exam_type, " +
                       "m.marks_obtained, m.total_marks, s.name as student_name, " +
                       "s.roll_number, sub.subject_name " +
                       "FROM marks m " +
                       "JOIN students s ON m.student_id = s.student_id " +
                       "JOIN subjects sub ON m.subject_id = sub.subject_id " +
                       "WHERE s.semester = ? AND m.subject_id = ? " +
                       "ORDER BY s.roll_number, m.exam_type";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, semester);
            stmt.setInt(2, subjectId);
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
                mark.setStudentName(rs.getString("student_name"));
                mark.setRollNumber(rs.getString("roll_number"));
                marks.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return marks;
    }
    
    
    public List<Student> getStudentsBySemester(int semester) {
        List<Student> students = new ArrayList<>();
        String query = "SELECT s.*, u.username FROM students s " +
                      "JOIN users u ON s.user_id = u.user_id " +
                      "WHERE s.semester = ? " +
                      "ORDER BY s.roll_number";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, semester);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }

    public List<Subject> getSubjectsBySemester(int semester) {
        List<Subject> subjects = new ArrayList<>();
        String query = "SELECT * FROM subjects WHERE semester = ? ORDER BY subject_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, semester);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectName(rs.getString("subject_name"));
                subject.setSubjectCode(rs.getString("subject_code"));
                subject.setCreditHours(rs.getInt("credit_hours"));
                subject.setSemester(rs.getInt("semester"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subjects;
    }
    
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT s.*, u.username FROM students s JOIN users u ON s.user_id = u.user_id";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                student.setUsername(rs.getString("username"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean updateAttendance(int studentId, int subjectId, Date date, String status) {
        String checkQuery = "SELECT attendance_id FROM attendance WHERE student_id = ? AND subject_id = ? AND date = ?";
        String insertQuery = "INSERT INTO attendance (student_id, subject_id, date, status) VALUES (?, ?, ?, ?)";
        String updateQuery = "UPDATE attendance SET status = ? WHERE student_id = ? AND subject_id = ? AND date = ?";
        
        try {
            // Check if attendance record exists
            try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, studentId);
                checkStmt.setInt(2, subjectId);
                checkStmt.setDate(3, date);
                
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    // Update existing record
                    try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                        updateStmt.setString(1, status);
                        updateStmt.setInt(2, studentId);
                        updateStmt.setInt(3, subjectId);
                        updateStmt.setDate(4, date);
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    // Insert new record
                    try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
                        insertStmt.setInt(1, studentId);
                        insertStmt.setInt(2, subjectId);
                        insertStmt.setDate(3, date);
                        insertStmt.setString(4, status);
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAttendanceBatch(List<AttendanceRecord> attendanceRecords) {
        String checkQuery = "SELECT attendance_id FROM attendance WHERE student_id = ? AND subject_id = ? AND date = ?";
        String insertQuery = "INSERT INTO attendance (student_id, subject_id, date, status) VALUES (?, ?, ?, ?)";
        String updateQuery = "UPDATE attendance SET status = ? WHERE student_id = ? AND subject_id = ? AND date = ?";
        
        try {
            connection.setAutoCommit(false); // Start transaction
            
            for (AttendanceRecord record : attendanceRecords) {
                // Check if attendance record exists
                try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
                    checkStmt.setInt(1, record.getStudentId());
                    checkStmt.setInt(2, record.getSubjectId());
                    checkStmt.setDate(3, record.getDate());
                    
                    ResultSet rs = checkStmt.executeQuery();
                    
                    if (rs.next()) {
                        // Update existing record
                        try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                            updateStmt.setString(1, record.getStatus());
                            updateStmt.setInt(2, record.getStudentId());
                            updateStmt.setInt(3, record.getSubjectId());
                            updateStmt.setDate(4, record.getDate());
                            updateStmt.executeUpdate();
                        }
                    } else {
                        // Insert new record
                        try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
                            insertStmt.setInt(1, record.getStudentId());
                            insertStmt.setInt(2, record.getSubjectId());
                            insertStmt.setDate(3, record.getDate());
                            insertStmt.setString(4, record.getStatus());
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }
            
            connection.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            try {
                connection.rollback(); // Rollback on error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true); // Reset auto-commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Create a simple AttendanceRecord class to use with batch updates
    public static class AttendanceRecord {
        private int studentId;
        private int subjectId;
        private Date date;
        private String status;
        
        public AttendanceRecord(int studentId, int subjectId, Date date, String status) {
            this.studentId = studentId;
            this.subjectId = subjectId;
            this.date = date;
            this.status = status;
        }
        
        // Getters
        public int getStudentId() { return studentId; }
        public int getSubjectId() { return subjectId; }
        public Date getDate() { return date; }
        public String getStatus() { return status; }
    }
    
    public List<Student> getAllStudentsForSubject(int subjectId) {
        List<Student> students = new ArrayList<>();
        String query = "SELECT * FROM students ORDER BY roll_number"; // Get all students, not filtered by subject
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }

    // Update getTeacherSubjects method to getAllSubjects
    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String query = "SELECT * FROM subjects ORDER BY subject_name"; // Get all subjects, not teacher-specific
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectName(rs.getString("subject_name"));
                subject.setSubjectCode(rs.getString("subject_code"));
                subject.setCreditHours(rs.getInt("credit_hours"));
                subject.setSemester(rs.getInt("semester"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subjects;
    }

    public boolean updateMarks(int studentId, int subjectId, String examType, double marksObtained, double totalMarks) {
        String query = "INSERT INTO marks (student_id, subject_id, exam_type, marks_obtained, total_marks) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setString(3, examType);
            stmt.setDouble(4, marksObtained);
            stmt.setDouble(5, totalMarks);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Subject> getTeacherSubjects(int teacherId) {
    	
    	return getAllSubjects();
    }

    public List<Student> getStudentsByDepartment(String department) {
        List<Student> students = new ArrayList<>();
        String query = "SELECT s.*, u.username FROM students s " +
                      "JOIN users u ON s.user_id = u.user_id " +
                      "WHERE s.department = ? " +
                      "ORDER BY s.name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, department);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setName(rs.getString("name"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDepartment(rs.getString("department"));
                student.setSemester(rs.getInt("semester"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
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
