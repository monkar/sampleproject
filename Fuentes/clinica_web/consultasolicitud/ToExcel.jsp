<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%
    response.setContentType("application/vnd.ms-excel");
    String strTabla = "";
    synchronized(session)
    {
      strTabla = session.getAttribute("sTabla").toString();
    }  
%>
<%=strTabla%>
<%
   synchronized(session)
   {
    session.removeAttribute("sTabla");
   } 
%>

