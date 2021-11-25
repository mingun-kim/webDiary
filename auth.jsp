<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.ResultSet"%>

<%-- db 검증 --%>
<%
    request.setCharacterEncoding("utf-8");
    boolean isLogin = false;
    int seq = 0;
    String seqString = null;

    //요청된 값을 받아 저장
    String idValue = request.getParameter("idValue");
    String pwValue = request.getParameter("pwValue");

    //db 검증
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    //db 연결
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/diarydata?useUnicode=true&characterEncoding=UTF-8" , "ubuntu", "1234");

    //db 명령 전달
    String sql = "SELECT * FROM user_login WHERE account=? and password=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, idValue);
    pstmt.setString(2, pwValue);
    rs = pstmt.executeQuery();

    while (rs.next()) {
        seq = rs.getInt("seq");
        isLogin = true;
    }
    seqString = Integer.toString(seq);

    session.setMaxInactiveInterval(60 * 60 * 24);
    String sessionId = session.getId();
    session.setAttribute(sessionId, seqString);
    String sessionValue = (String)session.getAttribute(sessionId);
%>

<%-- 페이지 이동 --%>
<script>
    if (<%=isLogin%> == true) {
        setCookie("account", "<%=sessionId%>", 1);
        // setCookie("value",  "<%=sessionValue%>", 1)
        // sessionStorage.setItem("seq", <%=seq%>);
        location.href = "main.jsp";
    } else if (<%=isLogin%> == false) {
        alert("로그인 정보가 일치하지 않습니다.");
        location.href = "index.jsp";
    }

    function setCookie(name, value, expireDay) {
        var expired = new Date();
        expired.setTime(expired.getTime() + expireDay * 24 * 60 * 60 * 1000);

        document.cookie = name + "=" + encodeURIComponent(value) + ";expires=" + expired.toUTCString() + ";path=/";
    }
</script>