<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <form id="editUserForm">
        <table id="editTable">
            <tr class="editTr">
                <td class="editTd">
                    <table id="createTable">
                        <tr>
                            <td class="editUserText">회원 아이디:</td>
                            <td><input type="text" class="editUserInput"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">회원 비밀번호:</td>
                            <td><input type="password" class="editUserInput"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">비밀번호 확인:</td>
                            <td><input type="password" class="editUserInput"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">사원 이름:</td>
                            <td><input type="text" class="editUserInput"></td>
                        </tr>
                        <tr>
                            <td class="editUserText">회원 권한:</td>
                            <td><div id="editUserAuthority"><input type="button" value="일반" class="authorityButton"><input type="button" value="파트장" class="authorityButton"></div></td>
                        </tr>
                    </table>
                </td>
                <td class="editTd"><div id="deleteUserList"></div></td>
            </tr>
            <tr class="editTr">
                <td class="editTd"><input type="button" value="회원 생성" class="createDeleteButton"></td>
                <td class="editTd"><input type="button" value="회원 삭제" class="createDeleteButton"></td>
            </tr>
        </table>
    </form>
    <button id="logoutButton">
        <img src="./src/images/logoutButton.png" id="logoutButtonImg">
    </button>
    <button id="backButton">
        <img src="./src/images/backArrow.png" id="backButtonImg" onclick=backToDiary()>
    </button>
    <script>
        function backToDiary() {
            location.href = "main.jsp"
        }
    </script>
</body>
</html>