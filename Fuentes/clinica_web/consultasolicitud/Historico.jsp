<%@ page contentType="text/html;charset=windows-1252"%>
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
    <table class="2" cellspacing="2 form-table-controls" cellpadding="3" border="0" width="100%" align="left">
      <tr>      
        <td class="header texto_general_black" width="90%">Hist&oacute;rico de la Solicitud</td>      
        <td width="10%">
          <a class="link_acciones" href="javascript:window.close();">
          Cerrar [X] 
          </a>         
      </tr>   
      <tr><td colspan="2">
        <fieldset class="row5 content_resumen">
        <legend></legend>
        <iframe name="frLstSolicitudHis" align=left width="100%" height="340" frameborder="0" scrolling="auto" src='../consultasolicitud/HistoricoSolicitud.jsp' ></iframe>
        </fieldset>
      </td></tr> 
    </table>  
  </body>
</html>