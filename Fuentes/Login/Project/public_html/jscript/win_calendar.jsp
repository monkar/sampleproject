<%@page contentType="text/html; charset=windows-1252"
        import = "java.util.*"        
%>
<%

      String wNombreForm = request.getParameter("wNombreForm");
      String wNombreField = request.getParameter("wNombreField");
      
      Calendar now = Calendar.getInstance();
      String funcionesJavaScript = null;
      String cuerpo = null;      
      int iMonth = request.getParameter("month")==null?(request.getParameter("mes")==null?(now.get(Calendar.MONTH)+1):Integer.valueOf(request.getParameter("mes")).intValue()):Integer.valueOf(request.getParameter("month")).intValue();
      int iYear = request.getParameter("year")==null?(request.getParameter("anio")==null?now.get(Calendar.YEAR):Integer.valueOf(request.getParameter("anio")).intValue()):Integer.valueOf(request.getParameter("year")).intValue();
      String sDias = iMonth!=(now.get(Calendar.MONTH)+1)?"":now.get(Calendar.DAY_OF_MONTH)+";";
      int Contador = 1;      
      String Tipo = request.getParameter("Tipo")==null?"P":request.getParameter("Tipo");
%>


<script language="JavaScript">
function CompletaCero(dato)
{
	calculo = dato * 2 //'aaaa
	if (parseInt(calculo) < "20")
		{
		dato = "0" + dato ;
		return dato;
		}
	else
		{return dato;}
}

function SelectDate(month,day,year)
{
day = CompletaCero(day);
month = CompletaCero(month);

  var fieldName = "<%=wNombreField%>";
  for (var i=0;i<opener.document.<%=wNombreForm%>.elements.length;i++)
    if (opener.document.<%=wNombreForm%>.elements[i].name==fieldName)
    {
     opener.document.<%=wNombreForm%>.elements[i].value=day+'/'+month+'/'+year;
//     opener.document.<%=wNombreForm%>.txtFh_Fin.value=day+'/'+month+'/'+year;
     opener.document.<%=wNombreForm%>.<%=wNombreField%>.focus() ;
      break;
    }
  window.close();
}
</script>

<HTML>
<HEAD>
  <META HTTP-EQUIV="Expires" CONTENT="0">
	<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.0">
</HEAD>


<SCRIPT LANGUAGE="JavaScript">
<!--

/* today's date */
var todayDate=new Date;
var todayYear;
if (String(todayDate.getFullYear)=="undefined")
{
  /* older versions of JavaScript return the year minus 1900 */
  todayYear=todayDate.getYear()+1900;
}
else
  todayYear=todayDate.getFullYear();
var todayMonth=todayDate.getMonth()+1;
var todayDay=todayDate.getDate();

/* the first year that appears in the select list */
var firstSelectYear=1950;

/* returns 1 if 'year' is a leap year */
function IsLeapYear(year)
{
  if ((year%400)==0) return (1);
  if (((year%4)==0) && ((year%100)!=0)) return (1);
  return (0);
}

/* returns number of leap years from (and including) year 0 to (but discluding) specified year */
function GetLeapYearsUntil(year)
{
  if (year<=0) return (0);
  year--;

  var total=Math.floor(year/400);
  total+=Math.floor(year/4);
  total-=Math.floor(year/100);

  return (total+1);
}

/* return number of days in specified month of year (month 1 is January) */
function GetDaysInMonth(month,year)
{
  if (month==1) return (31);
  if (month==2) return (28+IsLeapYear(year));
  if (month==3) return (31);
  if (month==4) return (30);
  if (month==5) return (31);
  if (month==6) return (30);
  if (month==7) return (31);
  if (month==8) return (31);
  if (month==9) return (30);
  if (month==10) return (31);
  if (month==11) return (30);
  if (month==12) return (31);
  return (0);
}

/* return day of week a peticular date lands on (0 is Sunday) */
function GetDayOfWeek(month,day,year)
{
  var totalDays=year*365+GetLeapYearsUntil(year);
  totalDays+=day-1;
  while (month>1)
  {
    month--;
    totalDays+=GetDaysInMonth(month,year);
  }
  return ((totalDays+6)%7);
}

/* return generated HTML source to calendar of specified month and year */
function GetCalendarHTML(month,year)
{
  var day=(-GetDayOfWeek(month,1,year))+1;
  var monthDays=GetDaysInMonth(month,year);
  var result=''; 
  
  result+='<STYLE TYPE="text/css">\n';
  result+='<!--\n';
  result+='.FUENTE { font-family:Arial; font-weight:bold; font-size:9pt }\n';
  result+='.FUENTE2 { color:#ff0000; font-weight:bold; font-family:Arial; font-size:9pt }\n';
  result+='#CALENDAR { font-family:Arial; text-decoration: underline }\n';
  result+='#CALENDAR { font-size:9pt; color:"#000000" }\n';
  result+='#CALENDAR:hover { color:#3C7ABF; text-decoration: none; font-weight:bold }\n';

  result+='#CALENDAR2 { font-family:Arial; text-decoration: underline }\n';
  result+='#CALENDAR2 { font-size:9pt; color:"red" }\n';
  result+='#CALENDAR2:hover { color:#000000; text-decoration: none; font-weight:bold }\n';
  
  result+='-->\n';
  result+='</STYLE>\n';
  result+='\n';
  result+='<BODY bgcolor=#6190BB topmargin=0 leftmargin=0 LINK="#000000" VLINK="#000000" ALINK="#000000">\n';
  result+='<CENTER>\n';
  result+='  <TABLE BORDER=0 CELLSPACING=1 CELLPADDING=1 class=2><TR><TD>\n';
  result+='    <TABLE BORDER=0 CELLSPACING=1 CELLPADDING=1 class=2>\n';
  result+='      <TR ALIGN=CENTER class="footer">\n';
  result+='        <TD CLASS=FUENTE2>D</TD>\n';
  result+='        <TD CLASS=FUENTE>L</TD>\n';
  result+='        <TD CLASS=FUENTE>M</TD>\n';
  result+='        <TD CLASS=FUENTE>M</TD>\n';
  result+='        <TD CLASS=FUENTE>J</TD>\n';
  result+='        <TD CLASS=FUENTE>V</TD>\n';
  result+='        <TD CLASS=FUENTE2>S</TD>\n';
  result+='      </TR>\n';
  result+='      <TR><TD HEIGHT=1></TD></TR>\n';

  for (var i=0; i<6 && day<=monthDays;i++)
  {
    result+='      <TR ALIGN=RIGHT>\n';
    sClass="calendario";
    for (var j=0;j<7;j++)
    {
      if (day>=1 && day<=monthDays)
      {
        if (month==todayMonth && year==todayYear && day==todayDay)
        {
	          result+='        <TD class="' + sClass + '" WIDTH=28><A HREF="javascript:SelectDate(' + month + ',' + day + ',' + year + ');"><B>'+day+'</B></A></TD>\n';
        }  
        else
	          result+='        <TD class="' + sClass + '" WIDTH=28><A HREF="javascript:SelectDate(' + month + ',' + day + ',' + year + ');">'+day+'</A></TD>\n';
      }
      else
        result+='        <TD class=row2>&nbsp;</TD>\n';
      day++;
    }
	result+='      </TR>\n';
  }
  result+='    </TABLE>\n';
  result+='  </TR></TD></TABLE>\n';
  result+='</CENTER>\n';
  result+='</BODY>\n';
document.write(result);
}
//-->
</SCRIPT>


<BODY topmargin="3" bgcolor=#FFFFFF>
<table border=0 cellpadding=0 cellspacing=0 class=1 width=100%>
<tr>
<td align=center>
  <FORM NAME="calendar_control" action="win_calendar.jsp">
	<input type="hidden" name="wNombreForm" value="<%=wNombreForm%>">
	<input type="hidden" name="wNombreField" value="<%=wNombreField%>">
    <SELECT NAME="month" ONCHANGE="javascript:document.calendar_control.submit();" class=pageinfo>
      <OPTION <%if (iMonth==1) {%>Selected<%}%> value=1>Enero</OPTION>
      <OPTION <%if (iMonth==2) {%>Selected<%}%> value=2>Febrero</OPTION>
      <OPTION <%if (iMonth==3) {%>Selected<%}%> value=3>Marzo</OPTION>
      <OPTION <%if (iMonth==4) {%>Selected<%}%> value=4>Abril</OPTION>
      <OPTION <%if (iMonth==5) {%>Selected<%}%> value=5>Mayo</OPTION>
      <OPTION <%if (iMonth==6) {%>Selected<%}%> value=6>Junio</OPTION>
      <OPTION <%if (iMonth==7) {%>Selected<%}%> value=7>Julio</OPTION>
      <OPTION <%if (iMonth==8) {%>Selected<%}%> value=8>Agosto</OPTION>
      <OPTION <%if (iMonth==9) {%>Selected<%}%> value=9>Setiembre</OPTION>
      <OPTION <%if (iMonth==10) {%>Selected<%}%> value=10>Octubre</OPTION>
      <OPTION <%if (iMonth==11) {%>Selected<%}%> value=11>Noviembre</OPTION>
      <OPTION <%if (iMonth==12) {%>Selected<%}%> value=12>Diciembre</OPTION>
    </SELECT>
    &nbsp;
    <SELECT NAME="year" ONCHANGE="javascript:document.calendar_control.submit();" class=pageinfo>
    <%
    for(int i=1950;i<2011;i++){%>
      <OPTION <%if (iYear==i) {%>Selected<%}%> value=<%=i%>><%=i%></Option>
    <%}%>  
    </SELECT>
    &nbsp;<INPUT TYPE=BUTTON ONCLICK="parent.close()" VALUE="Cancelar" class=pageinfo>
  </FORM>

</td>
</table>

<SCRIPT LANGUAGE="JavaScript">
<!--
GetCalendarHTML(<%=iMonth%>,<%=iYear%>);
-->
</SCRIPT>

</BODY>
</HTML>