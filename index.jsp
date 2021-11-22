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

        #loginForm {
            background-color:black;
            width: 30%;
            height: 60%;
            color: white;
            font-size: 36px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-evenly;
        }

        .idPw {
            background-color: black;
            color: white;
            border: 0;
            border-bottom: solid white;
        }

        .idPw:focus {
            outline: 0;
            border-bottom: solid red;
        }

        #loginButton {
            width: 100px;
            height: 50px;
            font-size: 16px;
            border: 0;
            color: white;
            background-color: #760000;
        }

        #loginButton:hover {
            cursor: pointer;
        }

    </style>
</head>
<body>
    <form id="loginForm" action="auth.jsp" method="post">
        LOGIN
        <input type="text" name="idValue" class="idPw">
        <input type="password" name="pwValue" class="idPw">
        <input type="submit" value="로그인" id="loginButton">
    </form>
    <script>

    </script>
</body>
</html>