package beans;

public class Leaderboard {
    private int leaderboardId;
    private int studentId;
    private double gpa;
    private int rank;
    private int semester;
    private int totalStudents; // Not in DB, used for percentage calculation
    
    public Leaderboard() {
    }

    public int getLeaderboardId() {
        return leaderboardId;
    }

    public void setLeaderboardId(int leaderboardId) {
        this.leaderboardId = leaderboardId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public double getGpa() {
        return gpa;
    }

    public void setGpa(double gpa) {
        this.gpa = gpa;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }
}