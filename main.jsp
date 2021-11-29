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
    int accountPower = 0;

    String innerDataUser = null;
    innerDataUser = request.getParameter("innerDataUser");
    String innerDataYear = null;
    innerDataYear = request.getParameter("innerDataYear");

    for (int i = 0; i < cookies.length; i++) {
        Cookie c = cookies[i];
        if (c.getName().equals("account")) {
                cValue = c.getValue();
        }
    }

    String sessionValue = (String)session.getAttribute(cValue);

    if (cValue != null && sessionValue != null) {
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
        if (Integer.toString(rs.getInt("seq")).equals(sessionValue)) {
            accountPower = rs.getInt("auth");
        }
        i++;
    }




    String account = null;
    if (innerDataUser != null) {
        account = innerDataUser;
    } else {
        account = sessionValue;
    }
    String year = null;
    if (innerDataYear != null) {
        year = innerDataYear;
    } else {
        year = "2021";
    }

    String wantTable = account + "_" + year;
    boolean isTableExist = false;
    sql = "SHOW TABLES";
    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        if (rs.getString("Tables_in_diarydata").equals(wantTable)) {
            isTableExist = true;
        }
    }
    int contentRow = 0;
    String[][] content = null;
    if (isTableExist) {
        sql = "SELECT * FROM " + wantTable + " ORDER BY month, day, hour, min";
        pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
        rs = pstmt.executeQuery();

        rs.last();
        contentRow = rs.getRow();
        rs.beforeFirst();
        content = new String[contentRow][5];

        i = 0;
        while (rs.next()) {
            content[i][0] = Integer.toString(rs.getInt("month"));
            content[i][1] = Integer.toString(rs.getInt("day"));
            content[i][2] = Integer.toString(rs.getInt("hour"));
            content[i][3] = Integer.toString(rs.getInt("min"));
            content[i][4] = rs.getString("content");
            i++;
        }
    }

%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=yes">    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
    <link rel="stylesheet" type="text/css" href="./common.css">
    <link rel="stylesheet" type="text/css" href="./main.css">
</head>
<body>
    <nav id="nav">
        <form id="mvUserDiv" action="main.jsp" method="post">
            <input id="innerDataUser" name="innerDataUser" type="text" class="innerData">
            <input id="innerDataYearInUser" name="innerDataYear" type="text" class="innerData">
        </form>
        <div id="editUserButtonDiv">
            <input type="button" value="회원관리" id="editUserButton" onclick=mvEditUser()>
        </div>
    </nav>
    <header id="header">
        <form id="yearForm" action="main.jsp" method="post">
            <button class="LRButton" onclick=mvYear(-1)>
                <img src="./src/images/arrowLeft.png" class="LRButtonImg">
            </button>
            <input id="yearDisplay" name="yearDisplay" readonly>
            <input id="innerDataUserInYear" name="innerDataUser" type="text" class="innerData">
            <input id="innerDataYear" name="innerDataYear" type="text" class="innerData">
            <button class="LRButton" onclick=mvYear(1)>
                <img src="./src/images/arrowRight.png" class="LRButtonImg">
            </button>
        </form>
        <div id="monthButtonDiv">
            <input type="button" value="1" class="monthButton" onclick=mvMonth(1)>
            <input type="button" value="2" class="monthButton" onclick=mvMonth(2)>
            <input type="button" value="3" class="monthButton" onclick=mvMonth(3)>
            <input type="button" value="4" class="monthButton" onclick=mvMonth(4)>
            <input type="button" value="5" class="monthButton" onclick=mvMonth(5)>
            <input type="button" value="6" class="monthButton" onclick=mvMonth(6)>
            <input type="button" value="7" class="monthButton" onclick=mvMonth(7)>
            <input type="button" value="8" class="monthButton" onclick=mvMonth(8)>
            <input type="button" value="9" class="monthButton" onclick=mvMonth(9)>
            <input type="button" value="10" class="monthButton" onclick=mvMonth(10)>
            <input type="button" value="11" class="monthButton" onclick=mvMonth(11)>
            <input type="button" value="12" class="monthButton" onclick=mvMonth(12)>
        </div>
        <div id="logoutButtonDiv">
            <button id="logoutButton" onclick=logout()>
                <img src="./src/images/logoutButton.png" id="logoutButtonImg">
            </button>
        </div>
    </header>
    <div id="plusElements">
        <button id="plusButton">
            <img src="./src/images/plus.png" id="plusButtonImg" onclick=plusSchedule()>
        </button>
        <form id="plusSchedule" action="plusSchedule.jsp" method="post">
            <input id="innerPlusYear" name="innerPlusYear" type="text" class="innerData">
            <input id="innerPlusMonth" name="innerPlusMonth" type="text" class="innerData">
            <input id="innerPlusDay" name="innerPlusDay" type="text" class="innerData">
            <input id="innerPlusHour" name="innerPlusHour" type="text" class="innerData">
            <input id="innerPlusMin" name="innerPlusMin" type="text" class="innerData">

            <div id="plusTime">
                <input id="plusMonthDay">
                <div class="plusTimeDial">
                    <button type="button" class="plusDialUpDown" onclick=hourUp()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialHour" class="plusDialText"></span>
                    <button type="button" class="plusDialUpDown" onclick=hourDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <span id="plusColon">:</span>
                <div class="plusTimeDial">
                    <button type="button" class="plusDialUpDown" onclick=minUp()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialMin" class="plusDialText"></span>
                    <button type="button" class="plusDialUpDown" onclick=minDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <div class="plusTimeDial" class="plusDialText">
                    <button type="button" class="plusDialUpDown" onclick=amPmClick()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialAmPm" class="plusDialText"></span>
                    <button type="button" class="plusDialUpDown" onclick=amPmClick()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
            </div>
            <textarea id="plusText" name="plusContent" cols="50" rows="10" wrap="hard"></textarea>
            <input type="button" value="확인" id="plusConfirm" onclick=confirmPlus()>
        </form>
    </div>
    <form id="main" action="delSchedule.jsp" method="post">
        <input id="innerDelYear" name="innerDelYear" type="text" class="innerData">
        <input id="innerDelMonth" name="innerDelMonth" type="text" class="innerData">
        <input id="innerDelDay" name="innerDelDay" type="text" class="innerData">

        <div id="monthDiv1" class="monthDiv"></div>
        <div id="monthDiv2" class="monthDiv"></div>
        <div id="monthDiv3" class="monthDiv"></div>
        <div id="monthDiv4" class="monthDiv"></div>
        <div id="monthDiv5" class="monthDiv"></div>
        <div id="monthDiv6" class="monthDiv"></div>
        <div id="monthDiv7" class="monthDiv"></div>
        <div id="monthDiv8" class="monthDiv"></div>
        <div id="monthDiv9" class="monthDiv"></div>
        <div id="monthDiv10" class="monthDiv"></div>
        <div id="monthDiv11" class="monthDiv"></div>
        <div id="monthDiv12" class="monthDiv"></div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        if (<%=isLogin%> == false) {
            alert("먼저 로그인 해주십시오.")
            location.href = "index.jsp";
        } else if (<%=isLogin%> == true) {
            window.onload = function() {
                var bodyWidth = document.body.offsetWidth;
                var bodyHeight = document.body.offsetHeight;
                bodyWidth -= 100;
                bodyHeight -= 85;
                document.getElementById("main").style.width = bodyWidth + "px";
                document.getElementById("main").style.height = bodyHeight + "px";

                flatpickr("#plusMonthDay", {
                    dateFormat: "Y.n.j",
                    onChange: function(selectDates, dateStr, instance){
                        var plusDate = new Date(selectDates);
                        document.getElementById("innerPlusYear").value = plusDate.getFullYear();
                        document.getElementById("innerPlusMonth").value = plusDate.getMonth() + 1;
                        document.getElementById("innerPlusDay").value = plusDate.getDate();
                    }
                });
            
                updateTime(12, 0);
                changeAmPm();
                document.getElementById("yearDisplay").value = "<%=year%>"

                console.log("<%=contentRow%>");
                console.log("<%=sql%>");
                console.log("<%=account%>");
                console.log(document.getElementById("yearDisplay").value);

                setSchedule();

                if (<%=accountPower%> > 0) {
                    <%for (int count = 0; count < userIdRow; count++) {%>
                        var newUserId = document.createElement("button");
                        newUserId.setAttribute("class", "mvUserButton");
                        newUserId.setAttribute("onclick", "mvUser(" + "<%=count + 1%>" + ")");
                        newUserId.innerHTML = "<%=userId[count]%>"
                        document.getElementById("mvUserDiv").appendChild(newUserId);
                        if (<%=count + 1%> == <%=account%>) {
                            newUserId.style.color = "white";
                            newUserId.style.fontWeight = "600";
                        }
                    <%}%>
                }
                if (<%=accountPower%> < 2) {
                    document.getElementById("editUserButton").style.display = "none";
                    if (<%=accountPower%> < 1) {
                        document.getElementById("nav").style.display = "none";
                        document.getElementById("header").style.left = "0px";
                        document.getElementById("logoutButton").style.marginRight = "0px";
                        document.getElementById("plusElements").style.marginLeft = "0px";
                        document.getElementById("main").style.left = "0px";
                    }
                }

                document.getElementById("monthButtonDiv").addEventListener("wheel", (evt) => {
                evt.preventDefault();
                document.getElementById("monthButtonDiv").scrollLeft += evt.deltaY;
                });
            }
        }

        function setSchedule() {
            //content불러올 때 rsRow 검사하고 0이면 불러오지 말기(없는데 불러오면 배열 벗어나는 에러남)
            //여기 jsp라이프사이클 때문에 테이블 자체가 없을 수도 있어서 jsp에서 for문 써야함

            <%for (int count = 0; count < contentRow; count++) {%>
                var month = "<%=content[count][0]%>"
                var day = "<%=content[count][1]%>"
                var hour = "<%=content[count][2]%>"
                var min = "<%=content[count][3]%>"
                var content = "<%=content[count][4]%>"
                var newDivId = "Month" + month + "Day" + day;

                if (document.getElementById("schedule" + newDivId) == null) {
                    var newScheduleDiv = document.createElement("div");
                    newScheduleDiv.setAttribute("class", "scheduleDiv");
                    newScheduleDiv.setAttribute("id", "schedule" + newDivId);
                    document.getElementById("monthDiv" + month).appendChild(newScheduleDiv);
                    
                    var newScheduleButton = document.createElement("button");
                    newScheduleButton.setAttribute("class", "scheduleButton");
                    newScheduleButton.setAttribute("onclick", "viewSchedule(" + month + ", " + day + ")");
                    newScheduleButton.setAttribute("type", "button");
                    newScheduleButton.innerHTML = month + "월 " + day + "일"
                    document.getElementById("schedule" + newDivId).appendChild(newScheduleButton);

                    if("<%=account%>" == "<%=sessionValue%>") {
                        var newDelButton = document.createElement("button");
                        newDelButton.setAttribute("class", "delButton");
                        newDelButton.setAttribute("id", "delButton" + newDivId);
                        newDelButton.setAttribute("onclick", "delSchedule(" + month + ", " + day + ")");
                        document.getElementById("schedule" + newDivId).appendChild(newDelButton);

                        var newDelButtonImg = document.createElement("img");
                        newDelButtonImg.setAttribute("class", "delButtonImg");
                        newDelButtonImg.src = "./src/images/bin.png";
                        document.getElementById("delButton" + newDivId).appendChild(newDelButtonImg);
                    }
                        
                    var newscheduleContentDiv = document.createElement("div");
                    newscheduleContentDiv.setAttribute("class", "scheduleContentDiv");
                    newscheduleContentDiv.setAttribute("id", "scheduleContentDiv" + newDivId);
                    document.getElementById("schedule" + newDivId).appendChild(newscheduleContentDiv);
                }
                var newScheduleContent = document.createElement("div");
                newScheduleContent.setAttribute("class", "scheduleContent");
                if (hour > 12) {
                    hour = hour * 1 - 12;
                    newScheduleContent.innerHTML = checkHour(hour) + ":" + checkMin(min) + " PM";
                } else if (hour == 0) {
                    newScheduleContent.innerHTML = "12:" + checkMin(min) + " AM";
                } else {
                    newScheduleContent.innerHTML = checkHour(hour) + ":" + checkMin(min) + " AM";
                }
                newScheduleContent.innerHTML += "&emsp;" + content;
                document.getElementById("scheduleContentDiv" + newDivId).appendChild(newScheduleContent);
                
            <%}%>
        }

        function checkHour (hour) {
            if (hour < 10) {
                return "0" + hour;
            } else {
                return hour;
            }
        }

        function checkMin (min) {
            if (min == 0) {
                return "00";
            } else {
                return min;
            }
        }

        function mvUser (userSeq) {
            document.getElementById("innerDataUser").value = userSeq;
            document.getElementById("innerDataYearInUser").value = document.getElementById("yearDisplay").value;
            document.getElementById("mvUserDiv").submit();
        }

        function mvEditUser() {
            location.href = "editUser.jsp"
        }

        function mvYear (direction) {
            var yearNow;
            yearNow = document.getElementById("yearDisplay").value;
            yearNow = yearNow * 1 + direction;
            document.getElementById("yearDisplay").value = yearNow;
            document.getElementById("innerDataYear").value = document.getElementById("yearDisplay").value;
            document.getElementById("innerDataUserInYear").value = "<%=account%>";
            document.getElementById("yearForm").submit();
        }

        function mvMonth(month) {
            var monthDivArr = document.getElementsByClassName("monthDiv");
            var monthBtnArr = document.getElementsByClassName("monthButton");

            for (var i = 0; i < 12; i++) {
                if (i == month - 1) {
                    monthDivArr[i].style.display = "flex";
                    monthBtnArr[i].style.backgroundColor = "#9A0000";
                    monthBtnArr[i].style.color = "white";
                } else {
                    monthDivArr[i].style.display = "none";
                    monthBtnArr[i].style.backgroundColor = "black";
                    monthBtnArr[i].style.color = "#9A0000";
                }
            }
        }

        function plusSchedule() {
            if (document.getElementById("plusSchedule").style.bottom == "0px") {
                document.getElementById("plusSchedule").style.bottom = "200vw";
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

        function confirmPlus() {
            if (document.getElementById("innerPlusYear").value == "" || document.getElementById("innerPlusMonth").value == "" || document.getElementById("innerPlusDay").value == "") {
                alert("날짜를 선택해 주십시오.");
            } else {
                if (document.getElementById("plusDialAmPm").innerHTML == "PM") {
                    document.getElementById("innerPlusHour").value = document.getElementById("plusDialHour").innerHTML * 1 + 12;
                } else {
                    document.getElementById("innerPlusHour").value = document.getElementById("plusDialHour").innerHTML;
                }

                if (document.getElementById("plusDialAmPm").innerHTML == "00") {
                    document.getElementById("innerPlusMin").value = "0";
                } else {
                    document.getElementById("innerPlusMin").value = document.getElementById("plusDialMin").innerHTML;
                }

                var submitText = document.getElementById("plusText").value;
                document.getElementById("plusText").value = submitText;

                document.getElementById("plusSchedule").submit();
            }
        }

        function viewSchedule(month, day) {
            var divId = "Month" + month + "Day" + day;
            if (document.getElementById("scheduleContentDiv" + divId).style.display == "flex") {
                document.getElementById("scheduleContentDiv" + divId).style.display = "none";
            } else {
                document.getElementById("scheduleContentDiv" + divId).style.display = "flex";
            }
        }

        function delSchedule(month, day) {
            document.getElementById("innerDelYear").value = document.getElementById("yearDisplay").value;
            document.getElementById("innerDelMonth").value = month;
            document.getElementById("innerDelDay").value = day;

            document.getElementById("main").submit();
        }

        function logout() {
            deleteCookie("account");
            location.href = "index.jsp";   
        }
        
        function deleteCookie(name) {
            document.cookie = name + "=; expires=Thu, 01 Jan 1999 00:00:10 GMT;";
        }
    </script>
</body>
</html>