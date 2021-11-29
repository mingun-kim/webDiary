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

    boolean isLogin = false;
    
    for (int i = 0; i < cookies.length; i++) {
        Cookie c = cookies[i];
        if (c.getName().equals("account")) {
                cValue = c.getValue();
        }
    }

    String sessionValue = (String)session.getAttribute(cValue);

    if (cValue != null && sessionValue.equals("1")) {
        isLogin = true;
    }

    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/diarydata?useUnicode=true&characterEncoding=UTF-8" , "ubuntu", "1234");

    String sql = "SELECT * FROM user_login";
    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
    rs = pstmt.executeQuery();
    
    rs.last();
    int userIdRow = rs.getRow();
    rs.beforeFirst();
    String userId[] = new String[userIdRow];
    
    int i = 0;
    while (rs.next()) {
        userId[i] = rs.getString("account");
        i++;
    }
%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="./common.css">
    <link rel="stylesheet" type="text/css" href="./editUser.css">
</head>
<body>
    <form id="editUserForm" action="createDelUser.jsp" method=post>
        <input type="text" id="innerCreatePower" name="innerCreatePower" class="innerData">
        <input type="text" id="isDel" name="isDel" class="innerData">
        <input type="text" id="innerDelUser" name="innerDelUser" class="innerData">
        <table id="editTable">
            <tr class="editTr">
                <td class="editTd">
                    <table id="createTable">
                        <tr>
                            <td class="editUserText">회원 아이디:</td>
                            <td><input type="text" class="editUserInput" id="userId" name="userId"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">회원 비밀번호:</td>
                            <td><input type="password" class="editUserInput" id="userPw" name="userPw"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">비밀번호 확인:</td>
                            <td><input type="password" class="editUserInput" id="userPwConfirm"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">회원 권한:</td>
                            <td>
                                <div id="editUserAuthority">
                                    <input type="button" value="일반" class="authorityButton" onclick=setPower(0)>
                                    <input type="button" value="파트장" class="authorityButton" onclick=setPower(1)>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td class="editTd"><div id="deleteUserList"></div></td>
            </tr>
            <tr class="editTr">
                <td class="editTd"><input type="button" value="회원 생성" class="createDeleteButton" onclick=createUser()></td>
                <td class="editTd"><input type="button" value="회원 삭제" class="createDeleteButton" onclick=delUser()></td>
            </tr>
        </table>
    </form>
    <button id="logoutButton" onclick=logout()>
        <img src="./src/images/logoutButton.png" id="logoutButtonImg">
    </button>
    <button id="backButton">
        <img src="./src/images/backArrow.png" id="backButtonImg" onclick=backToDiary()>
    </button>
    <script>
        window.onload = function() {
            if (<%=isLogin%>) {
                <%for (int count = 1; count < userIdRow; count++) {%>
                    var newUserId = document.createElement("button");
                    newUserId.setAttribute("class", "selectUser");
                    newUserId.setAttribute("onclick", "selectUser(" + "<%=count - 1%>" + ")");
                    newUserId.setAttribute("type", "button");
                    newUserId.innerHTML = "<%=userId[count]%>"
                    document.getElementById("deleteUserList").appendChild(newUserId);
                <%}%>

            } else {
                alert("로그인 상태를 확인해주십시오.");
                location.href="index.jsp"
            }
        }

        function setPower(power) {
            document.getElementById("innerCreatePower").value=power;

            var powerButton = document.getElementsByClassName("authorityButton");
            if (power == 0) {
                powerButton[0].style.backgroundColor = "#9A0000";
                powerButton[0].style.color = "white";
                powerButton[1].style.backgroundColor = "black";
                powerButton[1].style.color = "#9A0000";
            } else {
                powerButton[1].style.backgroundColor = "#9A0000";
                powerButton[1].style.color = "white";
                powerButton[0].style.backgroundColor = "black";
                powerButton[0].style.color = "#9A0000";
            }
        }

        function createUser() {
            document.getElementById("isDel").value = "";
            if (document.getElementById("userId").value == "") {
                alert("아이디를 입력해주세요.")
            } else if (document.getElementById("userPw").value == "") {
                alert("비밀번호를 입력해주세요.")
            } else if (document.getElementById("userPwConfirm").value != document.getElementById("userPw").value) {
                alert("비밀번호와 비밀번호 확인이 틀립니다.")
            } else if (document.getElementById("innerCreatePower").value == "") {
                alert("회원 권한을 선택해주세요.")
            } else {
                document.getElementById("editUserForm").submit();
            }
        }

        function delUser() {
            document.getElementById("isDel").value = "O";
            if (document.getElementById("innerDelUser").value == "") {
                alert("삭제할 회원을 선택해주세요.");
            } else {
                document.getElementById("editUserForm").submit();
            }
        }

        function logout() {
            deleteCookie("account");
            location.href = "index.jsp";   
        }
        
        function deleteCookie(name) {
            document.cookie = name + "=; expires=Thu, 01 Jan 1999 00:00:10 GMT;";
        }

        function backToDiary() {
            location.href = "main.jsp"
        }

        function selectUser(user) {
            var userArr = document.getElementsByClassName("selectUser");
            for (var i = 0; i < <%=userIdRow%> - 1; i++) {
                if (i == user) {
                    userArr[i].style.color = "white";
                    userArr[i].style.fontWeight = "700";
                    document.getElementById("innerDelUser").value = userArr[i].innerHTML;
                } else {
                    userArr[i].style.color = "black";
                    userArr[i].style.fontWeight = "600";
                }
            }
        }
    </script>
</body>
</html>