<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorSolicitud"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.util.ArrayList"%>

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <title>Hist&oacute;rico de la Solicitud</title>
    <jsp:include page="../general/scripts.jsp" />  
  </head>
  <body class="Bodyid1siteid0">
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
    <table class="2 table_principal gris_pares" cellspacing="1" cellpadding="2" border="0" width="100%" align="left">
      <tr>
        <td class="header" align="center" width="3%">N°</td>
        <td class="header" align="center" width="10%">Fecha y Hora</td>
        <td class="header" align="center" width="10%">Area</td>
        <td class="header" align="center" width="8%">Acci&oacute;n</td>
        <td class="header" align="center" width="20%">Usuario</td>
        <td class="header" align="center" width="25%">Observaci&oacute;n</td>        
      </tr>    
      <%
      
      /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:22am*/ 
      int intNumReg = 0;
      
      GestorSolicitud gestorSolicitud = new GestorSolicitud();
      
      int nIdSolicitud = -1;
      
      Solicitud objSolicitud=new Solicitud();
      BeanList objLstSolicitudHis = new BeanList();
      
      nIdSolicitud = Integer.parseInt(request.getParameter("nidSolicitud"));

      objLstSolicitudHis = gestorSolicitud.getLstHistoricoSolicitud(nIdSolicitud);
      
      intNumReg = objLstSolicitudHis.size();
      String classLastRow = "";
      
      for(int i=0;i<objLstSolicitudHis.size();i++){
      
        classLastRow = objLstSolicitudHis.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");
        
        String sObservacion = "";
        if(!objLstSolicitudHis.getBean(i).getString("SOBSERVACIONCLI").trim().equals("")) 
          sObservacion = objLstSolicitudHis.getBean(i).getString("SOBSERVACIONCLI").trim();
        else
          if(!objLstSolicitudHis.getBean(i).getString("SOBSERVACIONMED").trim().equals("")) 
            sObservacion = objLstSolicitudHis.getBean(i).getString("SOBSERVACIONMED").trim();
          else
            sObservacion = objLstSolicitudHis.getBean(i).getString("SOBSERVA").trim();
      %>
      <tr>
        <td class="row1 <%=classLastRow %>" align="center" width="3%"><%=objLstSolicitudHis.size()-i%></td>
        <td class="row1 <%=classLastRow %>" align="center" width="10%"><%=objLstSolicitudHis.getBean(i).getString("SFECHAREG")%></td>
        <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitudHis.getBean(i).getString("SAREA")%></td>
        <td class="row1 <%=classLastRow %>" align="center" width="8%"><%=objLstSolicitudHis.getBean(i).getString("SESTADO")%></td>
        <td class="row1 <%=classLastRow %>" align="left" width="20%"><%=objLstSolicitudHis.getBean(i).getString("SUSUARIO")%></td>
        <td class="row1 <%=classLastRow %> tr-td-last-child" align="left" width="25%"><%=sObservacion%>&nbsp;</td>        
      </tr>
      <%
      }
      %>
    </table>

  </body>
</html>
