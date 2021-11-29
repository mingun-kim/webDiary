<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.ResultSet"%>

<%
    request.setCharacterEncoding("utf-8");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    Cookie[] cookies = request.getCookies();
    String cValue = null;

    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/diarydata?useUnicode=true&characterEncoding=UTF-8" , "ubuntu", "1234");

    String isDel = request.getParameter("isDel");
    if (isDel.equals("O")) {
        String account = request.getParameter("innerDelUser");
        String sql = "DELETE FROM user_login WHERE account=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, account);
        pstmt.executeUpdate();

    } else {
        String account = request.getParameter("userId");
        String password = request.getParameter("userPw");
        String power = request.getParameter("innerCreatePower");
    
        String sql = "INSERT INTO user_login(account, password, auth) VALUES(?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, account);
        pstmt.setString(2, password);
        pstmt.setString(3, power);
        pstmt.executeUpdate();
    }
%>

<script>
    location.href = "editUser.jsp";
</script>