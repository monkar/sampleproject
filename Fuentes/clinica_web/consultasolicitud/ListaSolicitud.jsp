<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorSolicitud"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
   
    /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:29am*/    
    Atencion atencion = new Atencion();
    
    /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:23am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();

    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:33pm
    GestorClinica gestorClinica = new GestorClinica();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");  
    }  
    int intIdUsuario = usuario.getIntIdUsuario();
    
    int intFlgBuscar = (request.getParameter("flgBuscar")==null?0:Tool.parseInt(request.getParameter("flgBuscar")));
    int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
    String strNroAutoriza = Tool.getString(request.getParameter("tctAutoriza"));
    String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String strClinica = Tool.getString(request.getParameter("lscClinica"));
    int intIdEstado = Tool.parseInt(request.getParameter("lscEstado"));
    int intTipoSol = Tool.parseInt(request.getParameter("lscTipoSol"));
    int intCodOficina = Tool.parseInt(request.getParameter("lscOficina"));
    String strFechaIni = request.getParameter("tctFechaIni");
    String strFechaFin = request.getParameter("tctFechaFin");
    int intFlgExportar  =  (request.getParameter("flgExportar")!=null?Tool.parseInt(request.getParameter("flgExportar")):0);
 
    int intNumReg = 0;
    BeanList objLstSolicitudOra = new BeanList();
    BeanList objLstSolicitudInx = new BeanList();
    //Req 2011-0849
    BeanList objLstSolBeneInx = new BeanList();
    //Fin Req 2011-0849
    
    if(intFlgBuscar==1)
    {

        //objLstSolicitudOra = gestorSolicitud.getLstSolicitudDet(intIdRol, intIdEstado,intTipoSol, strNroAutoriza,
                                                         //strAsegurado,strClinica,intCodOficina, strFechaIni, strFechaFin);
          objLstSolicitudOra = gestorSolicitud.getLstSolicitudDet(0, 4,intTipoSol, strNroAutoriza,
                                                         strAsegurado,strClinica,intCodOficina, "","");                                                         
                                                         
       // if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA)
       // {
       //   objLstSolicitudInx = atencion.getLstSiniestroLog(strFechaIni,strFechaFin,strNroAutoriza,usuario.getStrWebServer());
       // }
      //  else
       // {
          objLstSolicitudInx = atencion.getLstSiniestroLog(strFechaIni,strFechaFin,strNroAutoriza);
      //  }
        
        if(intTipoSol != 1 && intTipoSol != 2 && (usuario.getIntCodGrupo() == Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo() == Constante.NCODGRUPOJCOR))
        {
          objLstSolBeneInx = gestorSolicitud.getListaSolicitudBenIfx(-1,strNroAutoriza,strAsegurado,strClinica,usuario.getStrWebServer(),null,usuario.getIntCodGrupo(),strFechaIni, strFechaFin);
          if(objLstSolBeneInx.size()==0)
          {
            objLstSolBeneInx = null;
          }
        }
        else
        {
          objLstSolBeneInx = null;
        }
       
    }
    
    Bean auxOra = null;
    Bean auxInx = null;
    
    String strHtml = "<table width=\"100%\"  class=\"2 table_principal gris_pares\">" + 
              "<tr>" +
                "<th width=\"2%\" height=30 class=\"header\" align=\"center\">&nbsp;#</th>" +
                "<th width=\"10%\" class=\"header\" align=\"center\">Nro. Sol.</th>" +                      
                "<th width=\"10%\" class=\"header\" align=\"center\">Contrato</th>" +                       
                "<th width=\"15%\" class=\"header\" align=\"center\">Certificado</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Clínica</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Cobertura</th>" +
                "<th width=\"35%\" class=\"header\" align=\"center\">Fec Registro</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Tipo Solicitud</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Tipo Atención</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Oficina</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Paciente</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Carta Ampliación</th>" +
                "<th width=\"35%\" class=\"header\" align=\"center\">T. Transcurrido</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Estado</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Fec. Aprobación</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Rol</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Fec. Límite</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Observación</th>" + 
                "<th width=\"5%\" class=\"header\" align=\"center\">Movimiento</th>" + 
              "</tr>";
           
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String strHoraConsulta =  sdf.format(cal.getTime());
    
    int intNumRegInx = 0;
    int intNumRegOra = 0;
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

          <%if (intFlgBuscar==1 && (objLstSolicitudOra.size()>0 || (objLstSolBeneInx!=null && objLstSolBeneInx.size() > 0))){%>
            <table width="100%"  class="2 table_principal gris_pares"> 
              <!--
              <tr>
                  <td width="2%" height=30 class="row1" align="left" colspan="19">
                      N&uacute;mero de Registros: 
                      <input class="row5" name = "tctNumReg" type="text" size="5" value="" disabled="disabled">
                      &nbsp;&nbsp;&nbsp; (<%=strHoraConsulta%>)
                  </td>
              </tr>
              -->
              <tr>
                <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
                <th width="10%" class="header" align="center">Nro. Sol.</th>                      
                <th width="10%" class="header" align="center">Contrato</th>                      
                <th width="15%" class="header" align="center">Certificado</th>
                <th width="15%" class="header" align="center">Cl&iacute;nica</th>
                <th width="15%" class="header" align="center">Cobertura</th>
                <th width="35%" class="header" align="center">Fec Registro</th>
                <th width="5%" class="header" align="center">Tipo Solicitud</th>
                <th width="5%" class="header" align="center">Tipo Atenci&oacute;n</th>
                <th width="5%" class="header" align="center">Oficina</th>
                <th width="15%" class="header" align="center">Paciente</th>
                <th width="15%" class="header" align="center">Carta Ampliaci&oacute;n</th>
                <th width="35%" class="header" align="center">T. Transcurrido</th>
                <th width="5%" class="header" align="center">Estado</th>
                <th width="5%" class="header" align="center">Fec. Aprobaci&oacute;n</th>
                <th width="5%" class="header" align="center">Rol</th>
                <th width="5%" class="header" align="center">Fec. L&iacute;mite</th>
                <th width="5%" class="header" align="center">Observaci&oacute;n</th>
                <th width="5%" class="header" align="center">Movimiento</th>
              </tr>
              <%
              intNumReg = 0;
              //Req 2011-0849
              int listaConjunta = (objLstSolBeneInx==null)?objLstSolicitudOra.size():objLstSolBeneInx.size() + objLstSolicitudOra.size();
              //fin Req 2011-0849
              int i = 0;
              
              String sNroSiniestro = "";
              String sPoliza = "";
              String sCertificado = "";
              String sNomClinica = "";//obtener el valor x default
              String sCobertura = "";
              String sFecRegistro = "";
              String sTipoSolicitud = "";
              String sTipoAtencion = "";
              String sOficina = "";
              String sPaciente = "";
              String sCartaAmpliacion = "";
              String sTtranscurrido = "";
              String sEstado = "";
              String sFAprobacion = "";
              String sRol = "";
              String sFechaLimite = "";
              String sObserv = "";
              String sMovimi = "";
              
              String sGencover = "";
              String sDespago = "";
              
              boolean flagSoliBene = true;
              boolean quedaCarta = true;
              boolean polExclu = false;
              Bean solBene = null;
              
              String classLastRow = "";    
              for(int j=0;j<listaConjunta;j++){
                if(i >= objLstSolicitudOra.size())
                {
                  quedaCarta = false;
                }
                if(quedaCarta)
                {
                  auxOra = objLstSolicitudOra.getBean(i);
                  auxInx = gestorSolicitud.getSolicitudSin(objLstSolicitudInx,auxOra.getString("SNROSINIESTRO"));
                  
                  if(auxInx!=null)
                  {
                    int pol = Integer.parseInt(auxInx.getString("2"));
                    int ramo = Integer.parseInt(auxInx.getString("1")); // Agregado para Proyecto Apple
                    if(!gestorClinica.getPolClinica(usuario.getStrWebServer(),pol,ramo))
                    {
                      polExclu = true;
                      if(usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
                      {
                        polExclu = false;
                      }
                    }
                  }
                }
                  //Req 2011-0849
                  int siniestroOra = -1;
                  int siniestroInx = -1;
                  if(quedaCarta)
                  {
                    siniestroOra = Integer.parseInt(auxOra.getString("SNROSINIESTRO"));
                  }
                  //Fin Req 2011-0849
                 // if(auxInx!=null){
                  //Req 2011-0849
                  
                  if(objLstSolBeneInx!=null && objLstSolBeneInx.size()!=0)
                  {
                    solBene = objLstSolBeneInx.getBean(0);
                    siniestroInx = Integer.parseInt(solBene.getString("snrosiniestro"));
                  }
                  else
                  {
                    siniestroInx = -1;
                  }
                    //siniestroInx = Integer.parseInt(solBene.getString("SNROSINIESTRO"));
                    if(quedaCarta && (siniestroOra < siniestroInx || siniestroInx == -1))
                    {                    
                       intNumRegOra = objLstSolicitudOra.size();
                       classLastRow = objLstSolicitudOra.getClassLastRow(j, intNumRegOra-1, "", "tr-nth-child-2n-1");
                       
                    if(auxInx!=null && !polExclu)
                    {
                      sNroSiniestro = auxInx.getString("6");
                      sPoliza = auxInx.getString("2");
                      sCertificado = auxInx.getString("3");
                      sNomClinica = auxInx.getString("10");//obtener el valor x default para INX
                      sCobertura = auxInx.getString("4") + " " + auxInx.getString("5");
                      sFecRegistro = auxOra.getString("SFECHAREG");
                      sTipoSolicitud = auxOra.getString("STIPOSOLICITUD");
                      sTipoAtencion = auxInx.getString("7");
                      sOficina = auxOra.getString("SNOMBOFICINA");
                      sPaciente = auxOra.getString("SASEGURADO");
                      sCartaAmpliacion = auxOra.getString("SAMPLIA");
                      sTtranscurrido = auxOra.getString("SHORATRANS");
                      sEstado = auxOra.getString("SESTADO");
                      sFAprobacion = auxOra.getString("SFECAPROB");
                      sRol = auxOra.getString("SROLUSURESP");
                      sFechaLimite = auxInx.getString("11");
                      sObserv = auxInx.getString("12");
                      sMovimi = auxInx.getString("13");
                      
                      intNumReg++;
                      }
                      flagSoliBene = false;
                      
                      i++;
                    }
                    else
                    {
                      intNumRegInx = objLstSolBeneInx.size() + objLstSolicitudOra.size();                      
                      classLastRow = objLstSolBeneInx.getClassLastRow(j, intNumRegInx-1, "", "tr-nth-child-2n-1");
                      
                      sNroSiniestro = objLstSolBeneInx.getBean(0).getString("snrosiniestro");//
                      sPoliza = objLstSolBeneInx.getBean(0).getString("spoliza");//
                      sCertificado = objLstSolBeneInx.getBean(0).getString("scertificado");//
                      sNomClinica = objLstSolBeneInx.getBean(0).getString("sdesclinic");//
                      sCobertura = objLstSolBeneInx.getBean(0).getString("scobertura") + " " + objLstSolBeneInx.getBean(0).getString("sdescover");//
                      sFecRegistro = objLstSolBeneInx.getBean(0).getString("sfechareg") + " " + objLstSolBeneInx.getBean(0).getString("shorareg");//
                      sTipoSolicitud = "Solicitud de Beneficio";
                      sTipoAtencion = "";//BUSCAR COMO OBTENERLO
                      sOficina = "";//
                      sPaciente = objLstSolBeneInx.getBean(0).getString("sasegurado");//
                      sCartaAmpliacion = "";
                      sTtranscurrido = "";
                      sEstado = "";
                      sFAprobacion = "";
                      sRol = "";
                      sFechaLimite = "";
                      sObserv = "";
                      sMovimi = "";
                      
                      sGencover = objLstSolBeneInx.getBean(0).getString("sgencover");
                      sDespago = objLstSolBeneInx.getBean(0).getString("sdespago");
                      
                      flagSoliBene = true;
                      
                      objLstSolBeneInx.remove(0);
                      intNumReg++;
                    }
                    
                  

                  //Fin Req 2011-0849
                  
                  if(flagSoliBene || (!flagSoliBene && auxInx!=null && !polExclu))
                  {
              %>                                  
                  <tr>
                    <td class="row1 <%=classLastRow %>" align="center"><%=intNumReg%></td>
                    <%
                    if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
                    {
                      if(flagSoliBene)//
                      {
                      %>
                        <td class="row1 <%=classLastRow %>" align="left">
                          <a class="link_acciones" href="javascript:verAutoriza('<%=sNroSiniestro%>','<%=sGencover%>','<%=sPoliza%>','<%=sDespago%>');">
                            <%=sNroSiniestro%>
                          </a>
                        </td>
                        <%
                      }
                      else
                      {
                      %>
                      <td class="row1 <%=classLastRow %>" align="center">
                        <a class="link_acciones" href="javascript:selecciona('<%=auxOra.getString("NIDSOLICITUD")%>','<%=auxOra.getString("NIDTIPOSOLICITUD")%>','<%=auxInx.getString("6")%>');">
                          <%=auxInx.getString("6")%>
                        </a>
                      </td>
                      <% 
                      }
                    }
                    else {
                    %>
                    <td class="row1 <%=classLastRow %>" align="center"><%= auxInx.getString("6")%></td>
                    <%
                         }
                    %>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sPoliza%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sCertificado%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sNomClinica%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sCobertura%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sFecRegistro%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sTipoSolicitud%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sTipoAtencion%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sOficina%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sPaciente%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sCartaAmpliacion%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sTtranscurrido%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sEstado%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sFAprobacion%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sRol%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sFechaLimite%></td>
                    <td class="row1 <%=classLastRow %>" align="center"><%= sObserv%></td>
                    <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%= sMovimi%></td>
                  </tr>
              <%
                  String auxHtml = "";
                  if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
                  {
                      if(flagSoliBene)
                      {
                        auxHtml = "<td class=\"row1 classLastRow\" align=\"left\">" +
                          "<a href=\"javascript:verAutoriza('"+sNroSiniestro+"','"+sGencover+"','"+sPoliza+"','"+sDespago+"');\">" +
                            sNroSiniestro+
                          "</a>"+
                        "</td>";
                      }
                      else
                      {
                        auxHtml = "<td class=\"row1 classLastRow\" align=\"center\"><a class=\"link_acciones\" href=\"javascript:selecciona('" +
                                auxOra.getString("NIDSOLICITUD") +
                                "','" + auxOra.getString("NIDTIPOSOLICITUD") + "','" +
                                auxInx.getString("6") + "');\">" +
                                auxInx.getString("6") +
                                "</a></td>";
                     }
                  }
                  else
                  {
                    auxHtml = "<td class=\"row1 classLastRow\" align=\"center\">" + auxInx.getString("6") + "</td>";
                  }
                   strHtml =  strHtml + 
                            "<tr>" +   
                                "<td class=\"row1 classLastRow\" align=\"center\">" + intNumReg + "</td>" + 
                                auxHtml + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sPoliza + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sCertificado + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sNomClinica + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sCobertura + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sFecRegistro + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sTipoSolicitud + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sTipoAtencion + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sOficina + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sPaciente + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sCartaAmpliacion + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sTtranscurrido + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sEstado + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sFAprobacion + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sRol + "</td>" + 
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sFechaLimite + "</td>" +
                                "<td class=\"row1 classLastRow\" align=\"center\">" + sObserv + "</td>" + 
                                "<td class=\"row1 tr-td-last-child\" align=\"center\">" + sMovimi + "</td>" + 
                            "</tr>"; 
                }
                }
              %>
            </table>
            
          <%
               synchronized(session)
               {
                session.setAttribute("sTabla",strHtml);  
               } 
          }%>
  <iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>
  <iframe name="procatencion" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe> 
  <input name="hdnNroAutorizaS" value="" type="hidden" />
</form>
<script type="text/javascript">

  function LoadBody()
  {
     <%if (intFlgBuscar==1){%>
        parent.datosConsulta('<%=intNumReg%>','<%=strHoraConsulta%>');
        //frmListaSolicitud.tctNumReg.value=<%=intNumReg%>
     <%}%>
     <%
      if(intFlgBuscar==1 && intNumReg>0)
        if (intFlgExportar==1)  
        {   
     %>
        parent.Exportar();
     <% }else{%> 
          <% 
            synchronized(session)
            {
              session.removeAttribute("sTabla");
            }  
          %>
     <%
      }
     %>    
  }
  
  function TerminaSession(){
     parent.TerminaSession();
  }
  //function verDetalle(){
  function verDetalle(poliza,certificado,cliente,clinica){
        var autoriza = document.forms[0].hdnNroAutorizaS.value;
        //parent.procsolicitud.location.href = "../flujo/Solicitud.jsp";
        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?tcnPoliza=" + poliza + "&tcnCertif=" + certificado + "&tctCodCliente=" + cliente + "&strClinica="+clinica+"&pnautoriza="+autoriza;
        parent.dtSolicitud.style.display = '';
        parent.tabCSoli.style.display = 'none';
        parent.tblCliBus.style.display = 'none';
        
  }

  function selecciona(idSolicitud, tiposol, nroautoriza){
    var frm = document.forms[0];
      frm.hdnNroAutorizaS.value = nroautoriza;
      document.forms[0].target="procSolicitud";
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=5&pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
      document.forms[0].submit();
  }
  
  function verAutoriza(siniestro,gencover,poliza,despago)
  {   
  
        var flgVerImpresionSolBenef = 0;
        var posF = 0;
          
        url="../servlet/ProcesoValida?pntipoval=14&pnpoliza=" + poliza + "&pncoberturagen=" + gencover + "&pntipo=2";
        var res = retValXml(url);
                
        if(res!="|")
        {  
            if(res.indexOf("|BSS|")>-1){
               flgVerImpresionSolBenef=1;
            }else{
               flgVerImpresionSolBenef=0;                        
            }            
        }
        
        // INI - REQ 2011-xxxx BIT/FMG
        despago = despago.toUpperCase();
        posF = despago.indexOf("FARMACIA");
        
        if(posF > -1)
          flgVerImpresionSolBenef = 1;
        // FIN - REQ 2011-xxxx BIT/FMG
        
        if (flgVerImpresionSolBenef == 0){
              var resp=confirm("Confirme si va imprimir la Solicitud de Beneficio"); 
              if (resp)
              {
                  if(gencover==217)
                      window.open('../consulta/SolicitudBenefOdontPDF.jsp?pnautoriza=' + siniestro);
                  else 
                      window.open('../consulta/SolicitudBeneficioPDF.jsp?pnautoriza=' + siniestro);
              }       
        }else{
             alert('No esta permitido la impresión de la Solicitud');
        }
      
  }
  
  
</script>
</body>
