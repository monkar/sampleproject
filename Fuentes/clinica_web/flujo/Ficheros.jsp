<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%

    /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:27am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();
 
    int intIdSolicitud = Tool.parseInt(request.getParameter("IdSolicitud"));
    
    int intNumReg = 0;
    
    String rutaFichero = Tool.getContextPath() + TablaConfig.getTablaConfig("RUTA_FICHERO") ;   
    BeanList objLstSolicitud = new BeanList();
    objLstSolicitud = gestorSolicitud.getLstFilesHistorico(intIdSolicitud);
    
%>
<script type="text/javascript">    

  function openArchivo(archivo)
  {
    momentoActual = new Date();
    hora = momentoActual.getHours();
    minuto = momentoActual.getMinutes();
    segundo = momentoActual.getSeconds();
   window.open("../.." + archivo + "?" + hora + minuto + segundo);
//    window.open("../..");
  }

</script>
<body class=Bodyid1siteid0 leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
  <form name="frmFicheros" method="post">
  
      <table class="2" BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >    
         <tr>      
             <td>
                <table class="2" BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
                   <tr>      
                       <td class="texto_general_black" style="padding-left: 3px" width="90%">Consulta de archivos adjuntos – Web Cl&iacute;nicas</td>              
                       <td width="10%">&nbsp;</td>          
                   </tr>
                </table>     
             </td>
         </tr>
       </table>    
  
      <table width="100%" class="2 table_principal gris_pares">                  
          <tr>
            <th height=30 class="header" align="center">&nbsp;#</th>
            <th class="header" align="center">Archivo</th>
            <th class="header" align="center">Fecha Registro</th>
            <th class="header" align="center">Descarga</th>
          </tr>                      
            <%
            intNumReg = objLstSolicitud.size();
            String classLastRow = ""; 
            for(int i=0;i<objLstSolicitud.size();i++){
            classLastRow = objLstSolicitud.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1"); 
            %>                    
                <tr>
                      <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
                      <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SARCHIVO1")%></td>                              
                      <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("DFECHAREG")%></td>                              
                      <td class="row1 <%=classLastRow %> tr-td-last-child" align="center">
                        <%--<a href="javascript:parent.openArchivo('<%=Constante.pathFileUpload + objLstSolicitud.getBean(i).getString("SARCHIVO1")%>');">Descargar</a>--%>
                        <a class="link_acciones" href="javascript:parent.openArchivo('<%=rutaFichero + objLstSolicitud.getBean(i).getString("SARCHIVO1")%>');">Descargar</a>
                      </td>
                </tr>
            <%
              }
            %>            
      </table>             
      
  </form>
</body>