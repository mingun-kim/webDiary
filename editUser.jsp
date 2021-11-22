<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        body {
                width: 100vw;
                height: 100vh;
                margin: 0;
                padding: 0;
                background: linear-gradient( to bottom, #760000, black);
                display: flex;
                justify-content: center;
                align-items: center;
        }

        #editUserForm {
            width: 75%;
            height: 80%;
            background-color: black;
        }
        
        #editTable {
            width: 100%;
            height: 100%;
        }

        .editTr {
            width: 100%;
        }

        .editTd {
            width: 50%;
        }

        #createTable {
            width: 100%;
            height: 100%;
        }

        .editUserText {
            color: white;
            height: 100%;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .editUserInput {
            background-color: black;
            color: white;
            border: 0;
            border-bottom: solid white;
        }

        .editUserInput:focus {
            outline: 0;
            border-bottom: solid red;
        }

        #editUserAuthority {
            width: 70%;
            display: flex;
            justify-content: space-evenly;
        }

        .authorityButton {
            background-color: black;
            color: #9A0000;
            border: solid #9A0000 3px;
            font-size: 16px;
        }

        .authorityButton:hover {
            cursor: pointer;
        }

        .authorityButton:focus {
            background-color: #9A0000;
            color: white;
        }

        #deleteUserList {
            width: 60%;
            height: 75%;
            background-color: #9A0000;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .createDeleteButton {
            width: 100px;
            height: 50px;
            background-color: #9A0000;
            color: white;
            border: 0;
            font-size: 16px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .createDeleteButton:hover {
            cursor: pointer;
        }

        #logoutButton {
            background-color: #00000000;
            border: 0;
            position: absolute;
            top: 4px;
            right: 4px;
        }

        #logoutButton:hover {
            cursor: pointer;
        }

        #logoutButtonImg {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

        #backButton {
            background-color: #00000000;
            border: 0;
            position: absolute;
            top: 4px;
            left: 4px;
        }

        #backButton:hover {
            cursor: pointer;
        }

        #backButtonImg {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

    </style>
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