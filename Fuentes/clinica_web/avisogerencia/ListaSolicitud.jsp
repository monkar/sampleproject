<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%
  
    Atencion atencion = new Atencion();
    GestorSolicitud gestorSolicitud = new GestorSolicitud();
    GestorClinica gestorClinica = new GestorClinica();
      
    Usuario objUsuario = null;
    synchronized(session)
    {
      objUsuario = (Usuario)session.getAttribute("USUARIO");
    }  

    int intIdUsuario = objUsuario.getIntIdUsuario();
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));
    int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
    String strNroAutoriza = Tool.getString(request.getParameter("tctAutoriza"));
    String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String strClinica = Tool.getString(request.getParameter("lscClinica"));
    int intTipoSol = Tool.parseInt(request.getParameter("lscTipoSol"));
    int intCodOficina = Tool.parseInt(request.getParameter("lscOficina"));
    int intDefault = Tool.parseInt(request.getParameter("default"));
    
    int intTipo = 0;
    
    int intIdEstado = 0;
    String[] items = null;
    if(objUsuario.getIntIdRol() != Constante.NROLOPE && objUsuario.getIntIdRol() != Constante.NROLENF)
    {
      items = request.getParameterValues("lscEstado");
    }
    String strEstadosCon = "";
    if(items != null)
    {
      strEstadosCon = Tool.parStringList(items);
    }
    else
    {
      strEstadosCon = Tool.getString(request.getParameter("lscEstado"));
    }
    
    String[] items2 = request.getParameterValues("lscOficina");
    String strOficCon = "";
    if(items2 != null)
    {
      strOficCon = Tool.parStringList(items2);
    }
    else
    {
      strOficCon = "0";
    }
    
    int intAviso = Tool.parseInt(request.getParameter("lscAviso"));
    
    if ((objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() != Constante.NCODGRUPOCESP)) {//Centro especializado
        if ((objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() != Constante.NCODGRUPOPROT)) {//la protectora
              strClinica =  (String) session.getAttribute("STRWEBSERVER");
              if ("".equals(strClinica) || strClinica == null)
                strClinica = objUsuario.getStrWebServer();
              intIdRol = 0; // depende de lo seleccionado en el filtro de estado
        }
    }else
        if (objUsuario.getIntIdRol()!=Constante.NROLMED && objUsuario.getIntIdRol()!=Constante.NROLATEC)
            intTipo = 0; // depende de lo seleccionado en el filtro de estado
        else
            intTipo = 1; // Para filtrar las solicitudes pendientes, observadas, ampliadas

    if ((objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() == Constante.NCODGRUPOCESP) 
    || (objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() == Constante.NCODGRUPOPROT)) {
        strClinica = objUsuario.getStrWebServer();
        intIdRol = 0;
    }

    if (objUsuario.getIntIdRol() == Constante.NROLBRK)
        intIdRol = 0;

    int intNumReg = 0;
    int intPaginaActual = 0;
    int intNumRegPag = 0;
    BeanList objLstSolicitud = new BeanList();
    String tipBusBand = "";
    if (intFlgBuscar == 1 ){
      if(intDefault==1)
      {
        strEstadosCon = "0";//Constante.NESTPEN + "," + Constante.NESTLEVOBS + "," + Constante.NESTDER + "," + Constante.NESTAMP;
        strOficCon = "0";
        tipBusBand = "0";
        intAviso = Constante.NENVIOPENDIENTE; //POR DEFECTO LO QUE NO HAN SIDO ENVIADOS.
        out.println("<script> parent.setTipoBus(\"0\"); </script>");
      }
      else
      {
        tipBusBand = "1";
        out.println("<script> parent.setTipoBus(\"1\"); </script>");
      }
      synchronized(session)
      {
        session.setAttribute("tipBusBand",tipBusBand);
      }  
                                                            
      intPaginaActual = Tool.parseInt((request.getParameter("tcnpagina")!=null?request.getParameter("tcnpagina"):"1"));
      intNumRegPag = Tool.parseInt(Constante.getConstBD("REG_PAG"));
      
      objLstSolicitud = gestorSolicitud.getLstSolicitudPendPag(intIdRol, intTipoSol, strNroAutoriza, strAsegurado,
                                                              strClinica, objUsuario.getIntCodBroker(), intTipo, intIdUsuario, 
                                                              strEstadosCon, strOficCon, intAviso, intPaginaActual, intNumRegPag);
                                                           
      if(objLstSolicitud!=null && objLstSolicitud.size()>0)
      {
          intNumReg = Tool.parseInt(objLstSolicitud.getBean(0).getString("NTOTALREGIST"));
      }                                                        
    }
    
    BeanList listClinicas = gestorClinica.lstClinica(1);
    
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
    <TABLE class="2 form-table-controls" cellSpacing=0 width="100%" border=0 >    
        <%  
            if(objLstSolicitud!= null && objLstSolicitud.size()>0){
        %>
            <tr>
                  <td class="row5" width="60%" align=left>Nro.Reg. : <%=intNumReg%></td>
                  <td class="row5" width="40%" align=right >Pág.:
                    <select class="txtCombo lp-select-pag" name="lstPaginaActual" OnChange="javascript:CambiarPagina(this.value);">;
                     <% 
                       
                       int  NroPaginas=(intNumReg>intNumRegPag?(intNumReg%intNumRegPag>0?intNumReg/intNumRegPag+1:intNumReg/intNumRegPag):1);                              
                       if (NroPaginas<intPaginaActual)
                            intPaginaActual=1;
                       for(int i=1; i<=NroPaginas; i++)
                       { 
                          if(i==intPaginaActual)
                            out.println("<option selected value=" + i + ">" + i);
                          else
                            out.println("<option value=" + i + ">" + i);
                       }%>
                    </select>
                  </td>
            </tr>
            <tr>  
                <td class="row1" width="100%" align="left" colspan="2"> 
                  <table width="100%"  class="2 table_principal gris_pares table_pagination">
                      <tr>
                        <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
                        <th width="6%" class="header" align="center">Nro. Sol.</th>                      
                        <th width="5%" class="header" align="center">Fecha Registro</th>
                        <th width="6%" class="header" align="center">Tipo Solicitud</th>
                        <th width="10%" class="header" align="center">Proveedor</th>
                        <th width="10%" class="header" align="center">Diagn&#243;stico</th>
                        <th width="6%" class="header" align="center">Moneda Carta</th>
                        <th width="6%" class="header" align="center">Monto Carta</th>
                        <th width="8%" class="header" align="center">Oficina</th>
                        <th width="10%" class="header" align="center">Paciente</th>
                        <th width="5%" class="header" align="center">Cart. Amplia</th>
                        <th width="5%" class="header" align="center">Tiempo Transcurrido</th>
                        <th width="5%" class="header" align="center">Estado</th>
                        <th width="5%" class="header" align="center">A.G.</th>
                      
                      </tr>
                      <%
                      String sClinica = "";
                      String sDiagnostico = "";
                      
                      for(int i=0; i<=objLstSolicitud.size() -1; i++){
                        sClinica = atencion.getNombreClinica(listClinicas,objLstSolicitud.getBean(i).getString("SIDCLINICA"));
                        sDiagnostico = objLstSolicitud.getBean(i).getString("SDIAGNOSTICO");         
                      %>
                      <tr>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("ROW_NUMBER")%></td>
                        <td class="row1" align="center">
                          <a class="link_acciones" <%=Tool.parseInt(objLstSolicitud.getBean(i).getString("NFLGEXPIR"))==1?"style='COLOR:red !IMPORTANT'":""%>  
                           href="javascript:selecciona('<%=objLstSolicitud.getBean(i).getString("NIDSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("NIDTIPOSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>','<%=objLstSolicitud.getBean(i).getString("NESTADOENVIO")%>');">                  
                          <%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>
                          </a>
                        </td>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("SFECHAREG")%></td>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("STIPOSOLICITUD")%></td>
                        <td class="row1" align="left"><%=sClinica%></td>
                        <td class="row1" align="left"><%=sDiagnostico.trim()%></td>   
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("SMONEDA")%></td>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("NMONTOCARTA")%></td>
                        <td class="row1" align="left"><%=objLstSolicitud.getBean(i).getString("SNOMBOFICINA")%></td>
                        <td class="row1" align="left"><%=objLstSolicitud.getBean(i).getString("SASEGURADO")%></td>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("SAMPLIA")%>&nbsp;</td>
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("SHORATRANS")%></td>              
                        <td class="row1" align="center"><%=objLstSolicitud.getBean(i).getString("SESTADO")%></td>              
                        <td class="row1 tr-td-last-child" align="center"><%=objLstSolicitud.getBean(i).getString("SESTADOENVIO")%></td>              
                      </tr>
                      <%
                        }
                      %>
                      <tr>
                        
                        <td class="row1" align="center" colspan="14">&nbsp;</td>
                      </tr>
                    </table>
                </td>
          </tr> 
          <%
          } else if(intFlgBuscar==1)
          {%>              
            <tr> 
                <td class="row5" align="center" style="FONT-SIZE: 10pt;" colspan="2">
                    No se encontraron configuraciones en la búsqueda
                </td>
            </tr> 
          <%}%>   
    </TABLE>                        
  <iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  <input type="hidden" name="hdnNroAutorizaS" value="" />
</form>
<script type="text/javascript">
  
  function LoadBody()
  {
    
  }
  
  function selecciona(idSolicitud, tiposol, nroautoriza, nenvio){
    var frm = document.forms[0];
      frm.hdnNroAutorizaS.value = nroautoriza;
      document.forms[0].target="procSolicitud";
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=5&pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza + "&nenvio=" + nenvio;
      document.forms[0].submit();
  }
  
  function verDetalle(poliza,certificado,cliente,clinica,nenvio){
        var autoriza = document.forms[0].hdnNroAutorizaS.value;
        parent.procsolicitud.location.href = "../avisogerencia/Solicitud.jsp?frmBandeja=1&tcnPoliza=" + poliza + "&tcnCertif=" + certificado + "&tctCodCliente=" + cliente + "&strClinica=" + clinica + "&pnautoriza=" + autoriza + "&nenvio=" + nenvio;
        parent.dtSolicitud.style.display = '';
        parent.dtConsulta.style.display = 'none';
        
  }
  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }  
  
  function CambiarPagina(pagina)
  {
      parent.Buscar(pagina);
  }
</script>
</body>