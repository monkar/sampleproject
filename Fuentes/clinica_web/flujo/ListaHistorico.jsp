<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%

    /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:27am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");
    }  
    int intIdUsuario = usuario.getIntIdUsuario();
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));
    int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
    String strNroAutoriza = Tool.getString(request.getParameter("tctAutoriza"));
    String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String strClinica = Tool.getString(request.getParameter("lscClinica"));
    int intIdEstado = Tool.parseInt(request.getParameter("lscEstado"));
    int intTipoSol = Tool.parseInt(request.getParameter("lscTipoSol"));
    int intCodOficina = Tool.parseInt(request.getParameter("lscOficina"));

    if ((usuario.getIntIdRol() == Constante.NROLOPE) && (usuario.getIntCodGrupo() != Constante.NCODGRUPOCESP)) {//Centro especializado
        if ((usuario.getIntIdRol() == Constante.NROLOPE) && (usuario.getIntCodGrupo() != Constante.NCODGRUPOPROT)) {//La protectora
              synchronized(session)
              {
                strClinica =  (String) session.getAttribute("STRWEBSERVER");
              }  
              if ("".equals(strClinica) || strClinica == null)
                strClinica = usuario.getStrWebServer();
              intIdRol = 0;
        }
    }

    if ((usuario.getIntIdRol() == Constante.NROLOPE) && (usuario.getIntCodGrupo() == Constante.NCODGRUPOCESP) || (usuario.getIntIdRol() == Constante.NROLOPE) && (usuario.getIntCodGrupo() == Constante.NCODGRUPOPROT)) {
        strClinica = usuario.getStrWebServer();
        intIdRol = 0;
    }

    int intNumReg = 0;
    BeanList objLstSolicitud = new BeanList();

    if (intFlgBuscar == 1 )
    objLstSolicitud = gestorSolicitud.getLstSolicitudHisSin(intTipoSol,strNroAutoriza,
                                                            strClinica,strAsegurado, intCodOficina, intIdUsuario);
%>
<BODY onload="javascript:LoadBody();" class=Bodyid1siteid0 leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
<form name="frmListaSolicitud" method="post">   
          <table width="100%"  class="2 table_principal gris_pares">
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <th width="10%" class="header" align="center">Nro. Sol.</th>                      
              <th width="45%" class="header" align="center">Paciente</th>
              <th width="15%" class="header" align="center">Tipo Solicitud</th>
              <th width="15%" class="header" align="center">Oficina</th>
              <th width="15%" class="header" align="center">Fecha Registro</th>
              <th width="15%" class="header" align="center">Estado</th>
              <th width="5%" class="header" align="center">Transacción</th>
              <th width="5%" class="header" align="center">Monto</th>
              <%if (usuario.getIntIdRol()==Constante.NROLADM){%>
                <th width="10%" class="header" align="center">Rol</th>
              <%}%>
            </tr>
            <%
            intNumReg = objLstSolicitud.size();
            String classLastRow = "";
            for(int i=0;i<intNumReg;i++){
              classLastRow = objLstSolicitud.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");         
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
              <td class="row1 <%=classLastRow %>" align="center">
                <a class="link_acciones" href="javascript:selecciona('<%=objLstSolicitud.getBean(i).getString("NIDSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("NIDTIPOSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>','<%=objLstSolicitud.getBean(i).getString("NTRANSAC")%>');">
                <%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>
                </a>
              </td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SASEGURADO")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("STIPOSOLICITUD")%></td>
               <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SNOMBOFICINA")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SFECHAREG")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SESTADO")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("STRANSACCION")%>&nbsp;</td>              
              <td class="row1 <%=classLastRow %>" align="right"><%=objLstSolicitud.getBean(i).getString("NMONTO")%>&nbsp;</td>              
              <%if (usuario.getIntIdRol()==Constante.NROLADM){%>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=objLstSolicitud.getBean(i).getString("SROLUSURESP")%></td>                         
              <%}%>
            </tr>
            <%
              }
            %>
            <tr>
              <td class="row1 tr-last-child tr-td-last-child" align="center" colspan=<%=(usuario.getIntIdRol()==Constante.NROLADM?7:10)%>&nbsp;</td>
            </tr>
          </table>
          
  <iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  <input type="hidden" name="hdnNroAutorizaS" value="">
</form>
<script type="text/javascript">
  function LoadBody()
  {
  }
  
  function selecciona(idSolicitud, tiposol, nroautoriza, ntransac){
    var frm = document.forms[0];
    //----
      frm.hdnNroAutorizaS.value = nroautoriza;
    //---  
      document.forms[0].target="procSolicitud";
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=5&pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza + "&pntransac=" + ntransac + "&pnflgconsul=1";
      document.forms[0].submit();
  }
  
  function verDetalle(poliza,certificado,cliente,clinica){
        var autoriza = document.forms[0].hdnNroAutorizaS.value;
        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?pnflgconsul=1&tcnPoliza=" + poliza + "&tcnCertif=" + certificado + "&tctCodCliente=" + cliente + "&strClinica="+clinica+"&pnautoriza="+autoriza;
        parent.dtSolicitud.style.display = '';
        parent.dtConsulta.style.display = 'none';     
  }
//  function verDetalle(){
//        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?pnflgconsul=1";
//        parent.dtSolicitud.style.display = '';
//        parent.dtConsulta.style.display = 'none';     
//  }

  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }  
</script>
</body>