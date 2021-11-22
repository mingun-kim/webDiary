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
    <style></style>
    <link rel="stylesheet" type="text/css" href="./main.css">
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
        var plusMonth = 0;
        var plusDay = 0;

        window.onload = function() {
            flatpickr("#plusMonthDay", {
                dateFormat: "n월 j일",
                onChange: function(selectDates, dateStr, instance){
                    var plusDate = new Date(selectDates);
                    plusMonth = plusDate.getMonth() + 1;
                    plusDay = plusDate.getDate();
                }
            });

            updateTime(12, 0);
            changeAmPm();

            console.log("<%=rsRow%>");
            console.log("<%=content[0][0]%>");

            setSchedule();
        }

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

        function updateTime(plusHour, plusMin) {
            document.getElementById("plusDialHour").innerHTML = plusHour;
            if (plusMin == 0) {
                document.getElementById("plusDialMin").innerHTML = "00";
            } else {
                document.getElementById("plusDialMin").innerHTML = plusMin;
            }
        }

        function changeAmPm() {
            if (document.getElementById("plusDialAmPm").innerHTML == "AM") {
                document.getElementById("plusDialAmPm").innerHTML = "PM";
            } else {
                document.getElementById("plusDialAmPm").innerHTML = "AM";
            }
        }

        function hourUp() {
            var plusHour =  document.getElementById("plusDialHour").innerHTML * 1;
            var plusMin = document.getElementById("plusDialMin").innerHTML * 1;
            if (plusHour == 12) {
                plusHour = 1;
            } else {
                plusHour++;
                if (plusHour == 12) {
                    changeAmPm();
                }
            }
            updateTime(plusHour, plusMin);
        }

        function hourDown() {
            var plusHour =  document.getElementById("plusDialHour").innerHTML * 1;
            var plusMin = document.getElementById("plusDialMin").innerHTML * 1;
            if (plusHour == 1) {
                plusHour = 12;
            } else {
                plusHour--;
                if (plusHour == 11) {
                    changeAmPm();
                }
            }
            updateTime(plusHour, plusMin);
        }

        function minUp() {
            var plusHour =  document.getElementById("plusDialHour").innerHTML * 1;
            var plusMin = document.getElementById("plusDialMin").innerHTML * 1;
            if (plusMin == 50) {
                plusMin = 0;
                hourUp();
            } else {
                plusMin += 10;
            }
            updateTime(plusHour, plusMin);
        }

        function minDown() {
            var plusHour =  document.getElementById("plusDialHour").innerHTML * 1;
            var plusMin = document.getElementById("plusDialMin").innerHTML * 1;
            if (plusMin == 0) {
                plusMin = 50;
                hourDown();
            } else {
                plusMin -= 10;
            }
            updateTime(plusHour, plusMin);
        }

        function amPmClick() {
            changeAmPm();
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