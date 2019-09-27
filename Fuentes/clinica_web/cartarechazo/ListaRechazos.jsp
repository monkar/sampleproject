<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%  
    /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:28am*/    
    Atencion atencion = new Atencion();
    /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:29am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();
      
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:33pm
    GestorClinica gestorClinica = new GestorClinica();
      
    Usuario objUsuario = null;
    synchronized(session)
    {
      objUsuario = (Usuario)session.getAttribute("USUARIO");
    }  

    int intIdUsuario = objUsuario.getIntIdUsuario();
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));
    //int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
    String strNroAutoriza = Tool.getString(request.getParameter("tctAutoriza"));
    String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String strClinica = Tool.getString(request.getParameter("lscClinica"));
    int intTipoSol = Tool.parseInt(request.getParameter("lscTipoSol"));
    int intCodOficina = Tool.parseInt(request.getParameter("lscOficina"));
    //0975
    int intDefault = Tool.parseInt(request.getParameter("default"));
    
    
    int intTipo = 0;
    
    
    int intIdEstado = 0;//Tool.parseInt(request.getParameter("lscEstado"));
    //int intIdEstado = Tool.parseInt(request.getParameter("lscEstado"));
    
    
    String strEstadosCon="0";
    
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
    
    int intIdRol=0;
//------------
    /*if ((objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() != Constante.NCODGRUPOCESP)) {//Centro especializado
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

    if ((objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() == Constante.NCODGRUPOCESP) || (objUsuario.getIntIdRol() == Constante.NROLOPE) && (objUsuario.getIntCodGrupo() == Constante.NCODGRUPOPROT)) {
        strClinica = objUsuario.getStrWebServer();
        intIdRol = 0;
    }

    if (objUsuario.getIntIdRol() == Constante.NROLBRK)
        intIdRol = 0;*/
//-----------

    int intNumReg = 0;
    BeanList objLstSolicitud = new BeanList();
    String tipBusBand = "";
    if (intFlgBuscar == 1 ){
      if(intDefault==1)
      {
        strEstadosCon = Constante.NESTPEN + "," + Constante.NESTLEVOBS + "," + Constante.NESTDER + "," + Constante.NESTAMP;
        strOficCon = "0";
        tipBusBand = "0";
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
      objLstSolicitud = gestorSolicitud.getLstSolicitudRechazo(intIdRol, 4,intTipoSol,
                                                                   strNroAutoriza,strAsegurado,strClinica,intCodOficina, objUsuario.getIntCodBroker(),intTipo,intIdUsuario,"4",strOficCon);
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
          <table width="100%"  class="2 table_principal gris_pares">
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <th width="10%" class="header" align="center">Nro. Sol.</th>                      
              <th width="15%" class="header" align="center">Fecha Registro</th>
              <th width="15%" class="header" align="center">Tipo Solicitud</th>
              <!-- Req 2011-0975 -->
              <th width="25%" class="header" align="center">Proveedor</th>
              <!-- Fin Req 2011-0975 -->
              <!-- Inicio Req. 2014-0204--> 
              <th width="25%" class="header" align="center">Diagn&#243;stico</th>
              <th width="25%" class="header" align="center">Monto Carta</th>
              <!-- Fin Req. 2014-0204 -->
              <th width="15%" class="header" align="center">Oficina</th>
              <th width="35%" class="header" align="center">Paciente</th>
              <th width="5%" class="header" align="center">Cart.Amplia</th>
              <th width="5%" class="header" align="center">T.Transcurrido</th>
              <th width="5%" class="header" align="center">Estado</th>
              <%if (true || objUsuario.getIntIdRol()==Constante.NROLADM){%>
              <th width="10%" class="header" align="center">Rol</th>
              <%}%>
            
            </tr>
            <%
            String sClinica = "";
            String sDiagnostico = "";
            
            intNumReg = objLstSolicitud.size();
            String classLastRow = "";
            
            for(int i=0;i<intNumReg;i++){
            
             classLastRow = objLstSolicitud.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");  
             
             sClinica = atencion.getNombreClinica(listClinicas,objLstSolicitud.getBean(i).getString("SIDCLINICA"));
             sDiagnostico = objLstSolicitud.getBean(i).getString("SDIAGNOSTICO");         
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
              <td class="row1 <%=classLastRow %>" align="left">
                <a class="link_acciones" <%=Tool.parseInt(objLstSolicitud.getBean(i).getString("NFLGEXPIR"))==1?"style='COLOR:red'":""%>  
                 href="javascript:selecciona('<%=objLstSolicitud.getBean(i).getString("NIDSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("NIDTIPOSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>');">                  
                <%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>
                </a>
              </td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SFECHAREG")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("STIPOSOLICITUD")%></td>
              <!-- Req 2011-0975 -->
              <td class="row1 <%=classLastRow %>" align="left"><%=sClinica%></td>
              <!-- Fin Req 2011-0975 -->
              <!-- Inicio Req. 2014-000204--> 
              <td class="row1 <%=classLastRow %>" align="left"><%=sDiagnostico.trim()%></td>   
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("NMONTOCARTA")%></td>
              <!-- Fin Req. 2014-000204 -->
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SNOMBOFICINA")%></td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("SASEGURADO")%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SAMPLIA")%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SHORATRANS")%></td>              
              <%
              //PRT definicion de variable
              String strEstado=objLstSolicitud.getBean(i).getString("SESTADO");
              //PRT Si el estado es "Aprobado", entonces se muestra el enlace al documento XML
              //PRT INICIO DE IF-ELSE
              if(strEstado.equals("Aprobado")&& objUsuario.getIntIdRol() != Constante.NROPERFILBRK){
              %>
                   <%-- <td class="row1" align="center">              
                    <table>
                    <tr>
                    <td class="row1" align="center"><%=strEstado%></td>
                    <td>
                      <a href="javascript:abrirxml('<%=objLstSolicitud.getBean(i).getString("NIDSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("NIDTIPOSOLICITUD")%>','<%=objLstSolicitud.getBean(i).getString("SNROSINIESTRO")%>');">
                      
                      <img alt="Ver documento XML" src="../images/imagexml.jpg" border="0"/>
                    </a>                        
                    </td>
                    </tr>
                    </table>
                   </td> Modificado para Apple --%>
                   <td class="row1 <%=classLastRow %>" align="left">              
                    <%=strEstado%>
                   </td> 
              <%
              }else {%>
                    <td class="row1 <%=classLastRow %> tr-td-last-child" align="left">              
                    <%=strEstado%>
                    </td>    
              
              <%}
              //PRT FIN DE IF-ELSE
              %>
              <%if (true || objUsuario.getIntIdRol()==Constante.NROLADM){%>
              <td class="row1 <%=classLastRow %>" align="center"><%=objLstSolicitud.getBean(i).getString("SROLUSURESP")%></td>
              <%}else{%>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=objLstSolicitud.getBean(i).getString("SROLUSURESP")%></td>              
              <%}%>              
            </tr>
            <%
              }
            %>
            <tr>            
              <!-- <td class="row1" align="center" colspan=<%=(objUsuario.getIntIdRol()==Constante.NROLADM?9:8)%>&nbsp;</td> -->               
              <td class="row1 tr-last-child tr-td-last-child" align="center" colspan="13">&nbsp;</td>
            </tr>
          </table>
  <iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  <input type="hidden" name="hdnNroAutorizaS" value="" />
</form>
<script type="text/javascript">
<!--//PRT Funcion que se dirige hacia un servlet con la finalidad de cargar el documento XML.
//      Parametros:
//      idSolicitud : id de solicitud
//      tiposol : tipo de siniestro
//      nroautoriza : numero de siniestro
//-->

  function abrirxml(idSolicitud, tiposol, nroautoriza){
        var frm = document.forms[0];
        document.forms[0].target="_blank";
        document.forms[0].action="../servlet/ProcesoXML?pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
        document.forms[0].submit();
  }
  
  function LoadBody()
  {
    
  }
  
  function selecciona(idSolicitud, tiposol, nroautoriza){
    var frm = document.forms[0];
    //----
      frm.hdnNroAutorizaS.value = nroautoriza;
    //---  
      document.forms[0].target="procSolicitud";
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=5&pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
      document.forms[0].submit();
  }
  
//  function verDetalle(){
//        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp";
//        parent.dtSolicitud.style.display = '';
//        parent.dtConsulta.style.display = 'none';
        
//  }
    function verDetalle(poliza,certificado,cliente,clinica){
        var autoriza = document.forms[0].hdnNroAutorizaS.value;
        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?frmBandeja=1&tcnPoliza=" + poliza + "&tcnCertif=" + certificado + "&tctCodCliente=" + cliente + "&strClinica="+clinica+"&pnautoriza="+autoriza;
        parent.dtSolicitud.style.display = '';
        parent.dtConsulta.style.display = 'none';
        
  }
  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }  
</script>
</body>
