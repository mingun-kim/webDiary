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

    if (request.getParameter("innerDelYear") == null) {
        response.sendRedirect("./index.jsp");
    } else {
            
        Cookie[] cookies = request.getCookies();
        String cValue = null;

        String year = request.getParameter("innerDelYear");
        String month = request.getParameter("innerDelMonth");
        String day = request.getParameter("innerDelDay");

        for (int i = 0; i < cookies.length; i++) {
            Cookie c = cookies[i];
            if (c.getName().equals("account")) {
                    cValue = c.getValue();
            }
        }

        String sessionValue = (String)session.getAttribute(cValue);
        
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/diarydata?useUnicode=true&characterEncoding=UTF-8" , "ubuntu", "1234");

        String wantTable = sessionValue + "_" + year;
        String sql = "DELETE FROM " + wantTable + " WHERE month=? AND day=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, month);
        pstmt.setString(2, day);
        pstmt.executeUpdate();
    }
%>

<script>
    location.href = "main.jsp";
</script>