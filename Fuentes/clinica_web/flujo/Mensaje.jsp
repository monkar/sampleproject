<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%
  String url=request.getContextPath();
  ParamNuevaMarcaService oNuevaMarcaService = new ParamNuevaMarcaService();
%>
<SCRIPT src="../jscript/funciones.js?v=1.0.0.1" type=text/javascript></SCRIPT>
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
<LINK rel=Stylesheet TYPE="text/css" href="../styles/EstilosGenerales.css?v=1.0.0.1" type="text/css">
<LINK rel=Stylesheet TYPE="text/css" href="../styles/CambioMarca.css?v=1.0.0.1" type="text/css">
<script src="../jscript/library/jquery-1.9.1.min.js?v=1.0.0.1" type="text/javascript"/></script>
<script src="../jscript/funciones_generales.js?v=1.0.0.1" type=text/javascript></script>
<!--[if lt IE 9]>  
<link href="../styles/ie.css?v=1.0.0.1" rel="stylesheet" type="text/css" />    
<![endif]-->
<!--[if gte IE 9]>
<link href="../styles/ie9.css?v=1.0.0.1" rel="stylesheet" type="text/css" />  
<![endif]--> 

<table width='100%' border='0' cellspacing='0' cellpadding='0' BGCOLOR="#FFFFFF">
<tr>
<td>
  <table width='100%' border='0' cellspacing='0' cellpadding='0' height='53'>
    <tr>
        <td align="left" height='53' width='20%'><img src="<%=oNuevaMarcaService.getAndSetPathUrlLogo(url)%>" /><!--img src='../images/t_cabecera.jpg' border="0"--></td>
        <td align="center" height='53' width='60%' class="texto_general_bold" style="font-size: 21px">Consulta de Asegurados</td>
        <td align="right" height='53' width='20%'><img src="../images/login_reflejado.jpg" border="0"/></td>
    </tr>
  </table>  
</td>
</tr>
<tr>
<td>
   <TABLE  border=0 BGCOLOR="#FF8839" WIDTH=100% class="bloque_cyan">
      <TR>
          <TD height='15' width=70%>&nbsp;</TD>   
          <TD align=right>&nbsp;</TD>
          <TD align=right><a href="javascript:window.close();">CERRAR</a></TD>
          <TD align=left>&nbsp;</TD>
      </TR>
   </TABLE>    
</td>
</tr>
<tr>
<td>
  <table width='100%' border='0' cellspacing='0' cellpadding='0' height='24' BGCOLOR="#FFFFFF">
  <tr>
  <td height='24'>
   <SCRIPT language=javascript src="../jscript/apymenu.js"></SCRIPT>
  <SCRIPT language=javascript src="../jscript/data6.js"></SCRIPT>
  </td> 
  </tr>
  </table>
</td>
</tr>
</table>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <title>Sistemas</title>
    <jsp:include page="../general/scripts.jsp" />
  </head>
  <body>
    <p class="texto_general_bold">
    <center>Por favor comun&iacute;quese con el &aacuterea de Sistemas</center>
    </p>
    <P align="center">Al 211-0211</P>
    <p>
    <center>    </center>
    </p>        
    
  </body>  
</html>
