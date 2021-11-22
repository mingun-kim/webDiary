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

    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/diarydata?useUnicode=true&characterEncoding=UTF-8" , "ubuntu", "1234");

    String sql = "SELECT * FROM diarycontent WHERE account=?";
    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
    pstmt.setString(1, "1");
    rs = pstmt.executeQuery();

    rs.last();
    int rsRow = rs.getRow();
    rs.beforeFirst();
    String content[][] = new String[rsRow][5];

    int i = 0;
    while (rs.next()) {
        content[i][0] = Integer.toString(rs.getInt("month"));
        content[i][1] = Integer.toString(rs.getInt("day"));
        content[i][2] = Integer.toString(rs.getInt("hour"));
        content[i][3] = Integer.toString(rs.getInt("min"));
        content[i][4] = rs.getString("content");
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
    <style>
        body {
            background-color: black;
            margin: 0;
            padding: 0;
            display: flex;
            width: 100vw;
            height: 100vh;
            overflow: hidden;
        }

        nav {
            background-color: #9A0000;
            width: 100px;
            height: 100vh;
            display: flex;
            flex-direction: column;
            position: fixed;
        }

        #editUserButtonDiv {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }

        #editUserButton {
            width: 100px;
            height: 64px;
            border: 0;
            background-color: #580000;
            color: white;
            font-size: 16px;
        }

        #editUserButton:hover {
            cursor: pointer;
        }

        header {
            width: 100vw;
            height: 80px;
            border-bottom: solid #580000 5px;
            display: flex;
            align-items: center;
            position: fixed;
            left: 100px;
        }

        .monthButton {
            width: 64px;
            height: 64px;
            background-color: black;
            color: #9A0000;
            border: solid #9A0000 3px;
            border-radius: 50%;
            font-size: 20px;
        }

        .monthButton:hover {
            cursor: pointer;
        }

        .monthButton:focus {
            background-color: #9A0000;
            color: white;
        }

        .LRButton {
            background-color: #00000000;
            border: 0;
        }

        .LRButton:hover {
            cursor: pointer;
        }

        .LRButtonImg {
            width: 20px;
            height: 32px;
            object-fit: cover;
        }

        #logoutButtonDiv {
            flex-grow: 1;
            display: flex;
            justify-content: flex-end;
        }

        #logoutButton {
            background-color: #00000000;
            border: 0;
        }

        #logoutButton:hover {
            cursor: pointer;
        }

        #logoutButtonImg {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

        #headerRight {
            width: 100px;
        }

        #plusmain {
            margin-top: 85px;
            margin-left: 100px;
            width: 100%;
            display: flex;
            flex-direction: column;
        }

        #plusSchedule {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            bottom: 100vw;
            z-index: 1;
            background-color: black;
        }

        #plusTime {
            width: 400px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: space-evenly;
        }

        #plusButton {
            background-color: #00000000;
            border: 0;
            position: fixed;
            top: 100px;
            right: 0px;
            z-index: 2;
        }

        #plusButton:hover {
            cursor: pointer;
        }

        #plusButtonImg {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

        #plusMonthDay {
            background-color: black;
            width: 150px;
            color: white;
            font-size: 32px;
        }

        .plusTimeDial {
            display: flex;
            flex-direction: column;
            border: 1px solid white;
            border-radius: 8px;
        }

        .plusDialUpDown {
            background-color: #00000000;
            border: 0;
        }

        .plusDialUpDown:hover {
            cursor: pointer;
        }

        .plusDialUpDownImg {
            width: 24px;
            height: 16px;
            object-fit: cover;
        }

        #plusDialHour {
            color: white;
            font-size: 24px;
            height: 24px;
            position: relative;
            bottom: 6px;
            text-align: center;
        }

        #plusColon {
            color: white;
            font-size: 32px;
        }

        #plusDialMin {
            color: white;
            font-size: 24px;
            height: 24px;
            position: relative;
            bottom: 6px;
            text-align: center;
        }

        #plusDialAmPm {
            color: white;
            font-size: 24px;
            height: 24px;
            position: relative;
            bottom: 6px;
            text-align: center;
        }

        #plusText {
            margin: 8px;
            align-self: stretch;
            flex-grow: 1;
            background-color: black;
            color: white;
            border: 1px solid white;
            font-size: 18px;
            border-radius: 8px;
        }

        #plusText:focus {
            border: 2px solid white;
            outline: 0;
        }

        #plusConfirm {
            width: 100px;
            height: 80px;
            align-self: flex-end;
            margin: 8px;
            background-color: #9A0000;
            color: white;
            border: 0;
            font-size: 20px;
            border-radius: 8px;
        }

        #plusConfirm:hover {
            cursor: pointer;
        }

        main {
            position: absolute;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            top: 85px;
            left: 100px;
            width: 100%;
        }

        .scheduleDiv {
            width: 100%;
            margin-left: 24px;
            display: none;
        }

        .schedule {
            background-color: black;
            color: white;
            border: 0;
            font-size: 24px;
            padding: 8px;
            margin-left: 16px;
        }

        .schedule:hover {
            cursor: pointer;
        }

        .scheduleContent {
            background-color: black;
            color: white;
            border: 1px solid #570000;
            flex-grow: 1;
            margin-right: 130px;
        }

        .scheduleTime {
            background-color: black;
            color: white;
            border: 1px solid #570000;
            padding-right: 16px;
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    
</head>
<body>
    <nav>
        <div id="editUserButtonDiv">
            <input type="button" value="회원관리" id="editUserButton" onclick=mvEditUser()>
        </div>
    </nav>
    <header>
        <button class="LRButton" id="leftButton">
            <img src="./src/images/arrowLeft.png" class="LRButtonImg">
        </button>
        <input type="button" value="1" class="monthButton">
        <input type="button" value="2" class="monthButton">
        <input type="button" value="3" class="monthButton">
        <input type="button" value="4" class="monthButton">
        <input type="button" value="5" class="monthButton">
        <input type="button" value="6" class="monthButton">
        <input type="button" value="7" class="monthButton">
        <input type="button" value="8" class="monthButton">
        <input type="button" value="9" class="monthButton">
        <input type="button" value="10" class="monthButton">
        <input type="button" value="11" class="monthButton">
        <input type="button" value="12" class="monthButton">
        <button class="LRButton">
            <img src="./src/images/arrowRight.png" class="LRButtonImg">
        </button>
        <div id="logoutButtonDiv">
            <button id="logoutButton">
                <img src="./src/images/logoutButton.png" id="logoutButtonImg">
            </button>
            <div id="headerRight"></div><!--margin으로 처리할 것-->
        </div>
    </header>
    <div id="plusmain">
        <button id="plusButton">
            <img src="./src/images/plus.png" id="plusButtonImg" onclick=plusSchedule()>
        </button>
        <div id="plusSchedule">
            <div id="plusTime">
                <input id="plusMonthDay">
                <div class="plusTimeDial">
                    <button class="plusDialUpDown" onclick=hourUp()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialHour"></span>
                    <button class="plusDialUpDown" onclick=hourDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <span id="plusColon">:</span>
                <div class="plusTimeDial">
                    <button class="plusDialUpDown" onclick=minUp()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialMin"></span>
                    <button class="plusDialUpDown" onclick=minDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <div class="plusTimeDial">
                    <button class="plusDialUpDown" onclick=amPmClick()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialAmPm"></span>
                    <button class="plusDialUpDown" onclick=amPmClick()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
            </div>
            <input type="text" id="plusText">
            <input type="button" value="확인" id="plusConfirm" onclick=plusConfirm()>
        </div>
    </div>
    <main id="main">
    </main>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        var plusDate;
        var plusMonth = 0;
        var plusDay = 0;
        var plusHour = 12;
        var plusMin = 0;
        var plusAmPm = "AM"//매개변수 처리

        flatpickr("#plusMonthDay", {
            dateFormat: "n월 j일",
            onChange: function(selectDates, dateStr, instance){
                plusDate = new Date(selectDates);
                plusMonth = plusDate.getMonth() + 1;
                plusDay = plusDate.getDate();
            }
        });

        updateTime();

        console.log("<%=rsRow%>");
        console.log("<%=content[0][0]%>");

        setSchedule();//window.onload

        function setSchedule() {
            var newSchedule = document.createElement("button");
            newSchedule.setAttribute("class", "schedule");
            newSchedule.setAttribute("onclick", "viewSchedule();");
            newSchedule.innerHTML = "1월 1일"
            document.getElementById("main").appendChild(newSchedule);

            var newScheduleDiv = document.createElement("div");
            newScheduleDiv.setAttribute("class", "scheduleDiv");
            newScheduleDiv.setAttribute("id", "scheduleDiv");
            document.getElementById("main").appendChild(newScheduleDiv);

            var newScheduleTime = document.createElement("div");
            newScheduleTime.setAttribute("class", "scheduleTime");
            newScheduleTime.innerHTML = "06:30 AM"
            document.getElementById("scheduleDiv").appendChild(newScheduleTime);

            var newScheduleContent = document.createElement("div");
            newScheduleContent.setAttribute("class", "scheduleContent");
            newScheduleContent.innerHTML = "기상"
            document.getElementById("scheduleDiv").appendChild(newScheduleContent);
        }

        function mvEditUser() {
            location.href = "editUser.jsp"
        }

        function plusSchedule() {
            if (document.getElementById("plusSchedule").style.bottom == "0px") {
                document.getElementById("plusSchedule").style.bottom = "100vw";
            } else {
                document.getElementById("plusSchedule").style.bottom = "0px";
            }
        }

        function updateTime() {
            document.getElementById("plusDialHour").innerHTML = plusHour;
            document.getElementById("plusDialMin").innerHTML = plusMin + "0";
            document.getElementById("plusDialAmPm").innerHTML = plusAmPm;
        }

        function changeAmPm() {
            if (plusAmPm == "AM") {
                plusAmPm = "PM";
            } else {
                plusAmPm = "AM";
            }
        }

        function hourUp() {
            if (plusHour == 12) {
                plusHour = 1;
            } else {
                plusHour++;
                if (plusHour == 12) {
                    changeAmPm();
                }
            }
            updateTime();
        }

        function hourDown() {
            if (plusHour == 1) {
                plusHour = 12;
            } else {
                plusHour--;
                if (plusHour == 11) {
                    changeAmPm();
                }
            }
            updateTime();
        }

        function minUp() {
            if (plusMin == 5) {
                plusMin = 0;
                hourUp();
            } else {
                plusMin++;
            }
            updateTime();
        }

        function minDown() {
            if (plusMin == 0) {
                plusMin = 5;
                hourDown();
            } else {
                plusMin--;
            }
            updateTime();
        }

        function amPmClick() {
            changeAmPm();
            updateTime();
        }

        function plusConfirm() {
            return 0;
        }

        function viewSchedule() {
            if (document.getElementById("scheduleDiv").style.display == "flex") {
                document.getElementById("scheduleDiv").style.display = "none";
            } else {
                document.getElementById("scheduleDiv").style.display = "flex";
            }
        }
    </script>
</body>
</html>