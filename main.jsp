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
    if (isTableExist) {
        sql = "SELECT * FROM " + wantTable;
        pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
        rs = pstmt.executeQuery();

        rs.last();
        contentRow = rs.getRow();
        rs.beforeFirst();
        String content[][] = new String[contentRow][5];

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
        <div id="logoutButtonDiv">
            <button id="logoutButton">
                <img src="./src/images/logoutButton.png" id="logoutButtonImg">
            </button>
        </div>
    </header>
    <div id="plusElements">
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
                    <span id="plusDialHour" class="plusDialText"></span>
                    <button class="plusDialUpDown" onclick=hourDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <span id="plusColon">:</span>
                <div class="plusTimeDial">
                    <button class="plusDialUpDown" onclick=minUp()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialMin" class="plusDialText"></span>
                    <button class="plusDialUpDown" onclick=minDown()>
                        <img src="./src/images/arrowDown.png" class="plusDialUpDownImg">
                    </button>
                </div>
                <div class="plusTimeDial" class="plusDialText">
                    <button class="plusDialUpDown" onclick=amPmClick()>
                        <img src="./src/images/arrowUp.png" class="plusDialUpDownImg">
                    </button>
                    <span id="plusDialAmPm" class="plusDialText"></span>
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
    </main>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        var plusMonth = 0;
        var plusDay = 0;

        if (<%=isLogin%> == false) {
            alert("<%=isLogin%>")
            alert("먼저 로그인 해주십시오.")
            location.href = "index.jsp";
        } else if (<%=isLogin%> == true) {
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
            }
        }

        function setSchedule() {
            //content불러올 때 rsRow 검사하고 0이면 불러오지 말기(없는데 불러오면 배열 벗어나는 에러남)
            setScheduleModule();
        }


        function setScheduleModule() {
            var newScheduleDiv = document.createElement("div");
            newScheduleDiv.setAttribute("class", "scheduleDiv");
            newScheduleDiv.setAttribute("id", "scheduleDiv");
            document.getElementById("main").appendChild(newScheduleDiv);
            
            var newSchedule = document.createElement("button");
            newSchedule.setAttribute("class", "scheduleButton");
            newSchedule.setAttribute("onclick", "viewSchedule()");
            newSchedule.innerHTML = "1월 1일"
            document.getElementById("scheduleDiv").appendChild(newSchedule);
            
            var newscheduleContentDiv = document.createElement("div");
            newscheduleContentDiv.setAttribute("class", "scheduleContentDiv");
            newscheduleContentDiv.setAttribute("id", "scheduleContentDiv");
            document.getElementById("scheduleDiv").appendChild(newscheduleContentDiv);

            var newScheduleTime = document.createElement("div");
            newScheduleTime.setAttribute("class", "scheduleTime");
            newScheduleTime.innerHTML = "06:30 AM"
            document.getElementById("scheduleContentDiv").appendChild(newScheduleTime);

            var newScheduleContent = document.createElement("div");
            newScheduleContent.setAttribute("class", "scheduleContent");
            newScheduleContent.innerHTML = "기상"
            document.getElementById("scheduleContentDiv").appendChild(newScheduleContent);
            
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
            document.getElementById("mvUserDiv").submit();
        }

        function mvMonth(month) {
            var monthDivArr = document.getElementsByClassName("monthDiv");

            for (var i = 0; i < 12; i++) {
                if (i == month - 1) {
                    monthDivArr[i].style.display = "flex";
                } else {
                    monthDivArr[i].style.display = "none";
                }
            }
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
            if (document.getElementById("scheduleContentDiv").style.display == "flex") {
                document.getElementById("scheduleContentDiv").style.display = "none";
            } else {
                document.getElementById("scheduleContentDiv").style.display = "flex";
            }
        }
    </script>
</body>
</html>