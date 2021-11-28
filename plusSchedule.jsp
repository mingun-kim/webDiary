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

    String year = request.getParameter("innerPlusYear");
    String month = request.getParameter("innerPlusMonth");
    String day = request.getParameter("innerPlusDay");
    String hour = request.getParameter("innerPlusHour");
    String min = request.getParameter("innerPlusMin");
    String content = request.getParameter("plusContent");
    content = content.replaceAll("(\r\n|\r|\n|\n\r)", "<br/>&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;");

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
    boolean isTableExist = false;
    String sql = "SHOW TABLES";
    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        if (rs.getString("Tables_in_diarydata").equals(wantTable)) {
            isTableExist = true;
        }
    }

    if (isTableExist == false) {
        sql = "CREATE TABLE " + wantTable + "(month TINYINT, day TINYINT, hour TINYINT, min TINYINT, content TEXT)";
        pstmt = conn.prepareStatement(sql);
        pstmt.executeUpdate();
    }
    sql = "INSERT INTO " + wantTable + " VALUES(?, ?, ?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, month);
    pstmt.setString(2, day);
    pstmt.setString(3, hour);
    pstmt.setString(4, min);
    pstmt.setString(5, content);
    pstmt.executeUpdate();
%>

<script>
    location.href = "main.jsp";
</script>