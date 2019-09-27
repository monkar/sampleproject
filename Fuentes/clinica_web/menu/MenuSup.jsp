<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<!--    
Inicio
esta de mas de poner este page porque por defecto la session es true.  Yahir_Rivas  23FEB2012*/-->
<%@ page session="true"%>
<!--  Fin --> 
<%
    
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }  
    if(usuario == null){      
      response.sendRedirect("../Mensaje.jsp");
    }
    String strNombre = usuario.getStrNombreExt();
    if(strNombre==null)strNombre="";

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
        <td align="left" height='53' width='20%'><img src="<%=oNuevaMarcaService.getAndSetPathUrlLogo(url)%>" height="70" width="200"><!--img src='../images/t_cabecera.jpg' border="0"--></td>
        <td align="center" height='53' width='60%' class="texto_general_bold" style="font-size: 21px">Consulta de Asegurados</td>
        <td align="right" height='53' width='20%'><img src="../images/login_reflejado.jpg" border="0"/></td>
    </tr>
  </table>  
</td>
</tr>
<tr>
<td>
   <table  border=0 BGCOLOR="#FF8839" WIDTH=100% class="bloque_cyan">
      <tr>          
          <td height='15' width=70%>&nbsp;<span class="content-regular">Bienvenido:</span>
              <span class="content-bold"><%=strNombre%></span>
          </td>          
          <td align=right>&nbsp;</td>
          <td align=right><a href="javascript:window.close();">CERRAR</a></td>
          <td align=left>&nbsp;</td>
      </tr>
   </table>    
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