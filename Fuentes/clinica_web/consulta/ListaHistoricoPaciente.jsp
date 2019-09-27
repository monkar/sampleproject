<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorSolicitud"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%
   
    /*Instanciando,para acceder a los Datos  yahirRivas 29FEB2012 11:34am*/    
    Atencion atencion = new Atencion();
       /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:26am*/    
   GestorSolicitud gestorSolicitud = new GestorSolicitud();

    Usuario usuario = null;
    synchronized(session)
    {
       usuario =(Usuario)session.getAttribute("USUARIO");             
    }   
       
    
    int intNumReg = 0;
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));
    String strFechaIniSol = request.getParameter("tctFechaInicio"); 
    String strFechaFinSol = request.getParameter("tctFechaFin");
    int intIdTipoSol = Tool.parseInt(request.getParameter("lscTipoSol"));
    String strIdClinica = Tool.getString(request.getParameter("lscClinica"));
    String strNomPaciente = Tool.getString(request.getParameter("hcnNombrePaciente"));
    String strCodDiagnostico = Tool.getString(request.getParameter("lscDiagnsoticos"));
    
    BeanList objLstSolicitud = new BeanList();
    BeanList objLstWebCliHist = new BeanList();    
    
    if (intFlgBuscar == 1 )
    objLstSolicitud = gestorSolicitud.getLstSolicitudHistoricoPaciente(strFechaIniSol,strFechaFinSol,intIdTipoSol,strIdClinica,strNomPaciente);
    
%>
<script type="text/javascript">    
  function selecciona(idSolicitud, tiposol, nroautoriza){
    var frm = document.forms[0];
      document.forms[0].target="procHistoricoPaciente";
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=7&pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
      document.forms[0].submit();
  }
  
  function verDetalle(){
      xx=950;
      yy=905;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=YES,resizable=NO,top=" + y + ",left=" + x
      window.open('../flujo/SolicitudHistoricoPaciente.jsp','',parametros);
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
  <form name="frmListaHistoricoPaciente" method="post">    
      <table width="100%" class="2 table_principal gris_pares">
      <tr>
          <th height=30 class="header" align="center">#</th>
          <th class="header" align="center">Nro. Sol.</th>                      
          <th class="header" align="center">Fecha Registro</th>
          <th class="header" align="center">Tipo Solicitud</th>
          <th class="header" align="center">Tipo<br/>Beneficio</th>              
          <th class="header" align="center">Producto</th>
          <th class="header" align="center">Proveedor</th>              
          <th class="header" align="center">Paciente</th>
          <th class="header" align="center">Diagnostico</th>
          <th class="header" align="center">Moneda</th>
          <th class="header" align="center">Importe(Sin<br/>IGV)</th>
          <th class="header" align="center">Cart.Amplia</th>
          <th class="header" align="center">Estado</th>
          <th class="header" align="center">Rol</th>
       </tr>                  

            <%
            
            intNumReg = objLstSolicitud.size();
            String classLastRow = "";                    
            
            for(int i=0;i<objLstSolicitud.size();i++){
            
                  classLastRow = objLstSolicitud.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");  
                  
                  Bean objBean;
                  objLstWebCliHist = atencion.getLstWebCliHist(Tool.parseInt(objLstSolicitud.getBean(i).getString("SNROSINIESTRO")),
                                                               Tool.parseInt(objLstSolicitud.getBean(i).getString("NTRANSAC")),
                                                               strCodDiagnostico);
            %>
                  <% if (objLstWebCliHist.size()>0){
                      objBean = objLstWebCliHist.getBean(0);
                  %>            
                
        <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
              <td class="row1 <%=classLastRow %>" align="right">
                <a class="link_acciones" <%=Tool.parseInt(objLstSolicitud.getBean(i).getString("NFLGEXPIR"))==1?"style='COLOR:red'":""%>  
                   href="javascript:selecciona('<%=objLstSolicitud.getBean(i).getString("NIDSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("NIDTIPOSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>');">                  
                   <%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%></a>
              </td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SFECHAREG")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("STIPOSOLICITUD")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objBean.getString("6")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objBean.getString("14")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objBean.getString("9")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SASEGURADO")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objBean.getString("16")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objBean.getString("18")%></td>
              <td class="row1 <%=classLastRow %>" align="right"><%=objLstSolicitud.getBean(i).getString("SUBTOTAL")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SAMPLIA")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SESTADO")%></td>              
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="left"><%=objLstSolicitud.getBean(i).getString("SROLUSURESP")%></td>
        </tr>

              <%}%>
               <%
                  }
                %>
      </table>  
       
      <iframe name="procHistoricoPaciente" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
      
      <%
          out.print("<SCRIPT LANGUAGE=\"JavaScript\"> parent.ActiveProceso(false); </script>");
      %>
      
  </form>
</body>