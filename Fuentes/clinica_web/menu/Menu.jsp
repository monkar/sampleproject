<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>

<!--    
Inicio
esta de mas de poner este page porque por defecto la session es true.  Yahir_Rivas  23FEB2012*/-->
<!--<%@ page session="true"%>-->
<!--  Fin --> 

<%
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 28FEB2012 14:49pm
    GestorUsuario gestorUsuario = new GestorUsuario();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");
    }  
      
    String strLogin = usuario.getStrLogin();
    int intIdUsuario = usuario.getIntIdUsuario();
    int intFlgPassword = 0;
    
    Bean objBean = gestorUsuario.getUsuarioGenerico(intIdUsuario);
    
    if(objBean!=null && (objBean.getString("PASSWORD").equals("") || objBean.getString("PASSWORD")==null))
    {
        intFlgPassword = 1;
        
    }if(usuario == null){      
      response.sendRedirect("../Mensaje.jsp");
    }
    String strNombre = usuario.getStrNombreExt();
    if(strNombre==null)strNombre="";
    
    String url=request.getContextPath();
    ParamNuevaMarcaService oNuevaMarcaService = new ParamNuevaMarcaService();
%>
<html>
<script type="text/javascript">
 function LoadBody()
 {
      window.moveTo(0,0);
      window.resizeTo(window.screen.availWidth,window.screen.availHeight);
      window.focus();
      
      <%if(intFlgPassword==1)
      {%>
      
          var frm = document.forms[0];
          var url="../general/Contrasena.jsp?usuario=<%=intIdUsuario%>&login=<%=strLogin%>";
          var contador = 1;
          var windowName = new String( contador );
          windowName = "v" + contador;
          
          window.showModalDialog(url ,"Seguridad","dialogWidth:400px; dialogHeight:320px; center:yes");
          
      <%}%>
 }
 </script>

<HEAD>
<TITLE>SISTEMA DE CLINICAS</title>
    <jsp:include page="../general/scripts.jsp" />
</HEAD>
<BODY onload="LoadBody();" leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<table width='100%' border='0' cellspacing='0' cellpadding='0'>
<tr>
    <td>
        <table width='100%' border='0' cellspacing='0' cellpadding='0' height='53'>
            <tr>
                <!-- DQ -->
                <td align="left" height='53' width='20%'><img style="padding-left:20px" src="<%=oNuevaMarcaService.getAndSetPathUrlLogo(url)%>" height="70" width="200"></td>
                <td align="center" height='53' width='60%'>
                  <div class="texto_general_bold" style="letter-spacing: 0.2px; font-size: 28px;">Consulta de Asegurados</div>
                </td>
                <td align="right" height='53' width='20%'><img src="../images/login_reflejado.jpg" border="0" style="vertical-align: bottom;"></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td>    
        <TABLE  border=0 BGCOLOR="#FF8839" WIDTH=100% class="bloque_cyan">
            <TR>
              <!-- DQ -->
                <TD height='35' width=70%><span style="padding-left:10px" class="content-regular">Bienvenido:</span>
                 <span class="content-bold"><%=strNombre%></span>
                </TD>   
                <TD align=right>&nbsp;</TD>
                <TD align=right>
                 <a href="javascript:TerminaSession();">CERRAR</a>
                </TD>
                <TD align=left>&nbsp;
                    <!-- HD 57926
                        <b><a href="javascript:window.print();"><img align=right alt="Imprimir" src="../images/btn_impresora.gif" border="0"></a></b>
                    -->
                </TD>
            </TR>
        </TABLE>        
    </td>
</tr>
<tr>
<td>
  <table width='100%' border='0' cellspacing='0' cellpadding='0' height='24' class="bloque_naranja">
  <tr>
  <td height='24'>
  
    <SCRIPT language=javascript src="../jscript/apymenu.js"></SCRIPT>
    <SCRIPT language=javascript src="../jscript/data6.js"></SCRIPT>
    
    <%
      synchronized(session)
      {
        System.out.println(session.getAttribute("MENU"));    
        out.println(Tool.getString((String) session.getAttribute("MENU")));
      }  
    %>
    
    <script type="text/javascript">
    
      function TerminaSession(){   
         if(confirm("Desea cerrar sesion?"))                                                                       
          window.location.href = "../Index.jsp";
      }
      
    </script> 
    
  </td> 
  </tr>
  </table>
</td>
</tr>
</table>

<TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
<TR>
<TD VALIGN="top"  ALIGN="LEFT" width="20%">
</TD>
<TD VALIGN="top"  width="80%">
<!--Inicio Desarrollo-->
<!--Fin Desarrollo-->
</TD>
<TR>
</TABLE>
</BODY>
</html>
