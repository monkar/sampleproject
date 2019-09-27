<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.Cliente"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.util.ArrayList"%>
<%  
    
   /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:37am*/    
    Atencion atencion = new Atencion();
   /*Instanciando la clase GestorPolClinic,para acceder a los Datos  yahirRivas 29FEB2012 11:37am*/    
    GestorPolClinic gestorPolClinic = new GestorPolClinic(); 
    GestorRol gestorRol = new GestorRol();
   //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:05pm
    GestorUsuario gestorUsuario = new GestorUsuario();
   /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:30am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();
   /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 12:17am*/ 
    GestorCliente gestorCliente = new GestorCliente();
   
   //Apple
    Caso objCaso=new Caso();    
    if (session.getAttribute("NumeroCaso")!=null){
          objCaso = (Caso)session.getAttribute("NumeroCaso");
          System.out.println("Numero de caso Solicitud.jsp :"+objCaso.getCaso());
    }
   //Apple

    Usuario usuario = null;
    
    /*INICIO 2012-0078*/
    boolean blnRegistroCoaseguroCero = false;
    boolean blnExcedeMontoMaximo = false;
    int primerSiniestro = 0;
    double montoInicial = 0;
    /*FIN 2012-0078*/
    
    /*INICIO 2012-0078*/
    int secondClaim = 0; 
    boolean blnSecondClaim = false;
    /*FIN 2012-0078*/
    
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");
      
      /*INICIO 2012-0078*/
      
      if (request.getParameter("strSegundoSiniestro") ==null)
      {
        session.removeAttribute(Constante.SREGCOACERO);
        session.removeAttribute(Constante.SPRIMERSIN);
        session.removeAttribute(Constante.SMONTOINICIAL);
      }
      
      if (session.getAttribute(Constante.SREGCOACERO)!=null) 
        blnRegistroCoaseguroCero = Boolean.valueOf(String.valueOf(session.getAttribute(Constante.SREGCOACERO))).booleanValue();      
      
      if (session.getAttribute(Constante.SPRIMERSIN)!=null)
            primerSiniestro = Tool.parseInt(String.valueOf(session.getAttribute(Constante.SPRIMERSIN)));
      session.removeAttribute(Constante.SPRIMERSIN);
      
      if (session.getAttribute(Constante.SMONTOINICIAL)!=null)
            montoInicial = Tool.parseDouble(String.valueOf(session.getAttribute(Constante.SMONTOINICIAL)));
      session.removeAttribute(Constante.SMONTOINICIAL);
      /*FIN 2012-0078*/
      
    }
    int intIdUsuario = usuario.getIntIdUsuario();
    String strNroautoriza = Tool.getString(request.getParameter("pnautoriza"));
    int intTipoSol = Tool.parseInt(request.getParameter("pstiposol"));
    int intIdSol = Tool.parseInt(request.getParameter("pnidsol"));
    int intFlgConsul = Tool.parseInt(request.getParameter("pnflgconsul"));
    int intSelCover = Tool.parseInt(request.getParameter("pnselcover"));
    
    int intRamo = Tool.parseInt(request.getParameter("tctRamo"));
    
    if(intRamo==0){
      Bean objBean2 = atencion.getSiniestroLog(strNroautoriza);    
      intRamo = Tool.parseInt(objBean2.getString("1")); // Apple
    }
    
    int intFrmBandeja = 0;
    if(request.getParameter("frmBandeja") != null)
    {
      intFrmBandeja = Tool.parseInt(request.getParameter("frmBandeja"));
    }
    
    int intIdPresupuesto=0;
    String strContinuidad = "";
    Cliente objCliente = null;
    
    //CAMBIOS REALIZADOS EN PRODUCCIÓN 15 Y 16 DE 11/2011
    int poliza = Tool.parseInt(request.getParameter("tcnPoliza"));
    int certificado = Tool.parseInt(request.getParameter("tcnCertif"));
    String cliente = Tool.getString(request.getParameter("tctCodCliente"));
    String clinica = "";
    clinica = Tool.getString(request.getParameter("strClinica"));
    if(clinica.equals(""))
    {
      Bean objBean = atencion.getSiniestroLog(strNroautoriza);
      clinica = objBean.getString("6");  
    }
    Bean objAtencion = null ;
    if(clinica == "")
    {
      objAtencion = atencion.getCliente(poliza,certificado,cliente,null,intRamo);
     objCliente = gestorCliente.setCliente(objAtencion,cliente);
      
      if(objAtencion.size()==0 || objCliente.getIntCertificado()==-1)
      {
        objAtencion = atencion.getCliente_his(poliza,certificado,cliente,null,strNroautoriza,intRamo);
          objCliente = gestorCliente.setCliente(objAtencion,cliente);
      }
    }
    else
    {
      objAtencion = atencion.getCliente(poliza,certificado,cliente,clinica,intRamo); // Apple
      objCliente = gestorCliente.setCliente(objAtencion,cliente);
      if(objAtencion.size()==0 || objCliente.getIntCertificado()==-1)
      {
        objAtencion = atencion.getCliente_his(poliza,certificado,cliente,clinica,strNroautoriza,intRamo);
         objCliente =   gestorCliente.setCliente(objAtencion,cliente);
      }
    }
    
    int intEstadoDeudaCliente = atencion.getEstadoCliente(poliza,certificado,intRamo); //Se agrego el codigo "intRamo"
    objCliente.setIntEstadoDeuda(intEstadoDeudaCliente);
    
    String inpdate_cli =  gestorCliente.getClientInpDate(objCliente.getStrCodigo());/*SP ASOCIADO*/
    
    synchronized(session)
    {
      session.setAttribute("DatoCliente",objCliente);
    }
    
   // if (session.getAttribute("DatoCliente")!=null)
   // {
    //  objCliente = (Cliente)session.getAttribute("DatoCliente");
      // AVM : variable para la continuidad es el campo continuity
      // con Continuidad = 'S'
      // sin Continuidad = 'N'
      strContinuidad = (objCliente.getStrContinuidadInx().substring(0).equals("S")?"CONTINUIDAD":"");
  //  }
    //----FIN DE CAMBIOS REALIZADOS EN PRODUCCIÓN 15 Y 16 DE 11/2011
    int intFlgAtencion = 1;
    if (objCliente.getIntEstadoDeuda()==2)
        intFlgAtencion = 0;

    Cobertura objCobertura = null;
    synchronized(session)
    {
      if (session.getAttribute("CoberturaSel")!=null) {
        objCobertura = (Cobertura)session.getAttribute("CoberturaSel");
        /*INICIO 2012-0078*/
        if (strNroautoriza=="")
        {
          if (blnRegistroCoaseguroCero) {
            session.setAttribute("objCobertura#strCoaseguro", objCobertura.getStrCoaseguro());
            objCobertura.setStrCoaseguro(Constante.MONTOMINCOASEGURO);
          } else {
            String strDatosCoberturaAnterior = (String)session.getAttribute("strDatosCobertura");
            if (strDatosCoberturaAnterior == null) {
              String strDatosCobertura = String.valueOf(objCobertura.getIntCoverGen()) + "|" +
                  String.valueOf(objCobertura.getIntTipoAtencion()) + "|" +
                  objCobertura.getStrCoaseguro();
              session.setAttribute("strDatosCobertura", strDatosCobertura);
            } else {
              String[] datos = strDatosCoberturaAnterior.split("\\|");
              int intCoverGen = Integer.parseInt(datos[0]);
              int intTipoAtencion = Integer.parseInt(datos[1]);
              if (objCobertura.getIntCoverGen() == intCoverGen &&
                  objCobertura.getIntTipoAtencion() == intTipoAtencion) {
                  objCobertura.setStrCoaseguro(datos[2]);
                  session.removeAttribute("strDatosCobertura");
              }
            }
          }
          /*FIN 2012-0078*/
        }
      }
    }
    
    String strTipoCambio = "";
    Solicitud objSolicitud = new Solicitud();
    Presupuesto objPresupuesto = null;
    //RQ2016-000604
    AvisoRechazo objRechazo = new AvisoRechazo();  
   
    
    objCliente = gestorCliente.setCliente(objAtencion,cliente);
        //--Cambios por el problema de las sesiones
    synchronized(session)
    {   
    if (session.getAttribute("SolicitudSel")!=null && !blnRegistroCoaseguroCero)
    {
        objSolicitud = (Solicitud)session.getAttribute("SolicitudSel");        
        //objSolicitud = (Solicitud)session.getAttribute("SolicitudSel");
        int intclaim = Tool.parseInt(objSolicitud.getSNROSINIESTRO());
        objRechazo= gestorSolicitud.getDatosCartaRechazo(intclaim);
        intTipoSol = objSolicitud.getNIDTIPOSOLICITUD();
        strTipoCambio = String.valueOf(objSolicitud.getDblTipoCambio());
        objPresupuesto = objSolicitud.getObjPresupuesto();
    }else
    {
        strTipoCambio = Tool.getTipoCambio();
    }
    }
    
    String [] arrMontos =  new String[21]; //AF64
    for(int intIndice=0; intIndice<arrMontos.length;  intIndice++)
      arrMontos[intIndice]= "";
    
    String strObsOtros =  "";
    double dblTotalPresupuesto = 0;
    if(objPresupuesto!=null)
    {
       intIdPresupuesto = objPresupuesto.getNIDPRESUPUESTO();
       ArrayList detalle = objPresupuesto.getArrDetalle();
       for(int intIndice=0; intIndice<detalle.size(); intIndice++)
       {
          DetallePresupuesto objDetalle = ((DetallePresupuesto)detalle.get(intIndice));
          if(objDetalle.getDblMontoConcepto()>0)
          {
             dblTotalPresupuesto += objDetalle.getDblMontoConcepto();
             arrMontos[objDetalle.getIntIdConcepto()-1]= Double.toString(objDetalle.getDblMontoConcepto());
             if (objDetalle.getIntIdConcepto()==19)
                strObsOtros = objDetalle.getStrObservacion();
          }
       }
    }
    dblTotalPresupuesto = Tool.redondear(dblTotalPresupuesto,2);
    
    //Bean bOficina = gestorSolicitud.getOficPol(objCliente.getIntPoliza(), Constante.NRAMOASME);
    Bean bOficina = gestorSolicitud.getOficPol(objCliente.getIntPoliza(), intRamo);
    Bean bProveedor = null;
    Bean bProveedorSol = null;
    if(objSolicitud.getNIDSOLICITUD()==0)
    {
        bProveedor = Tabla.getProvedorIfxServ(usuario.getStrWebServer());
        synchronized(session)
        {
          bProveedorSol = Tabla.getProvedorIfxServ((String) session.getAttribute("STRWEBSERVER"));
        }
        objSolicitud.setStrProveedorSol(bProveedorSol.getString("4"));        
    }   
    
    boolean blnEditar = false;
    
    int intFlagValidaClinica = 0;
    
    if(usuario.getIntIdRol()== Constante.NROLEMISOR){
          intFlagValidaClinica = 1;
          bProveedor = Tabla.getProvedorIfxServ((String) session.getAttribute("STRWEBSERVER"));
        }

    if (objSolicitud.getNIDESTADO()==Constante.NESTREG || 
        (objSolicitud.getNIDESTADO()==Constante.NESTAPR && objSolicitud.getNIDTIPOSOLICITUD()==Constante.NTSCARGAR &&
         (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 )) ||
        objSolicitud.getNIDESTADO()==Constante.NESTOBS || 
        (objSolicitud.getNIDESTADO()==Constante.NESTRECH && objSolicitud.getNFLGAMPLIACION()==1)|| 
        objSolicitud.getNIDSOLICITUD()==0) 
        blnEditar = true;

        /*2012-0078*/
        String strResultado = gestorSolicitud.obtieneSegundoSiniestro(Tool.parseInt(objSolicitud.getSNROSINIESTRO()));  
        blnSecondClaim = strResultado.substring(0,1).equalsIgnoreCase("2") ? true : false;
        secondClaim = Tool.parseInt(strResultado.substring(2));
        /*2012-0078*/        
        
    String strTitulo="";      

        switch(intTipoSol)
        {
        case Constante.NTSCARAUT:
            strTitulo = "Solicitud de Carta de Autorización";
          break;
        case 2:
            if (objSolicitud.getNFLGAMPLIACION()==1)
              strTitulo = "Solicitud de Ampliación de Carta de Garantía";
            else            
              strTitulo = "Solicitud de Carta de Garantía";
          break;
        }
            
    if (intFlgConsul==1) 
        blnEditar=false;
    
    double dblMontoIgv = Tool.redondear(dblTotalPresupuesto * (objSolicitud.getDblFactorIgv() - 1),2);
    double dblMontoTotal = Tool.redondear(dblTotalPresupuesto + dblMontoIgv,2);
        
    double dblMontoCarta = 0;
    if(objSolicitud.getDblImporteCarta() - dblTotalPresupuesto > 0.5 && objSolicitud.getDblFactorIgv() == 1.19)
        dblMontoCarta = objSolicitud.getDblImporteCarta();
    else
        dblMontoCarta = objSolicitud.getDblImporteCarta() * objSolicitud.getDblFactorIgv();
    
    dblMontoCarta = Tool.redondear(dblMontoCarta,2);

    double dblIgv = Tool.reaIGV(2,"");
    
    Poliza objPoliza = gestorPolClinic.getPoliza(intRamo,objCliente.getIntPoliza(),0);
    //Poliza objPoliza = gestorPolClinic.getPoliza(Constante.NRAMOASME,objCliente.getIntPoliza(),0); Modificado para Apple
    gestorSolicitud.getTransactionInfo(objSolicitud);    
        
    int staRechazo =  Tool.parseInt(Constante.getConst("STA_RECHAZO"));                                
        
    int intCacalili=0;                 
    intCacalili = Tool.parseInt(objCobertura.getStrCacalili());
    //RQ2017-1848 -Agregado ramos
    if (intCacalili ==0 && (intRamo == 80 || intRamo == 81)){
    intCacalili = gestorSolicitud.getIDCapitalIlimitado(Tool.parseInt(strNroautoriza));                
    }
    
    
    int flagEps = 0 ;
    
    if (intRamo == 82 || intRamo ==83)
        flagEps = 1;
    
    String strBenefConsumido = gestorSolicitud.benefConsumidoCase(objCaso.getCaso(),Tool.parseInt(strNroautoriza));
    
    BeanList parametros = gestorSolicitud.getPermisosRol(usuario.getIntIdRol());
        
    int flagAudiMedi= 0;
    int flagImpresion= 0;    
      
    if(parametros.size() == 1){    
      flagAudiMedi    = Tool.parseInt(parametros.getBean(0).getString("NAUDIMEDIC"));
      flagImpresion   = Tool.parseInt(parametros.getBean(0).getString("NIMPRESION"));      
    };                
%>
<html>
<head>
<title>CARTA</title>
    <jsp:include page="../general/scripts.jsp" />  
</head>

<BODY onload="javascript:LoadBody();" onunload="cleansession();" leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
    <TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
        <TR>
            <TD VALIGN="top"  align="left" width="100%" >
                <form name="frmAtencion" method="post">
                    <input type="hidden" name="hcnTipoSol" value="<%=intTipoSol%>"/>
                    <input type="hidden" name="hctCodCliente" value="<%=objCliente.getStrCodigo()%>"/>
                    <input type="hidden" name="hcnIdSolicitud" value="<%=objSolicitud.getNIDSOLICITUD()%>"/>
                    <input type="hidden" name="hcnIdHistorico" value="<%=objSolicitud.getObjSolhis().getNIDHISTORICO()%>"/>
                    <input type="hidden" name="hcnArchivo1" value=""/>
                    <input type="hidden" name="hcnAcc" value=""/>
                    <input type="hidden" name="hcnFlgAmplia" value="<%=objSolicitud.getNFLGAMPLIACION()%>"/>
                    <input type="hidden" name="hcnTransac" value="<%=objSolicitud.getObjSolhis().getNTRANSAC()%>"/>
                    <input type="hidden" name="hcnIdPresupuesto" value="<%=intIdPresupuesto%>"/>
                    <input type="hidden" name="hcnFactorIGV" value="<%=dblIgv%>"/>
                    <input type="hidden" name="hcnFlagAmpliar" value="<%=0%>"/>
                    <input type="hidden" name="hcnFlagError" value="<%=0%>"/>
                    <input type="hidden" name="hcnFlagAtencion" value="<%=intFlgAtencion%>"/>      
                    <input type="hidden" name="hcnServer" value="<%= usuario.getStrWebServer()%>"/>
                    <input type="hidden" name="hcnSelCover" value="<%= intSelCover%>"/>
                    <input type="hidden" name="hcnEstadoHis" value="<%=objSolicitud.getNIDESTADO()%>"/><!-- REQ 2011-0305 BIT/FMG -->
                    <input type="hidden" name="hctCaso" value="<%=objCaso.getCaso()%>"/> <!-- REQ 2011-0305 BIT/FMG -->
                    <!-- 2012-0078-->
                    <input type="hidden" name="hcnRegistroCoaseguroCero" value="<%=blnRegistroCoaseguroCero%>"/>
                    <input type="hidden" name="hcnExcedeMontoMaximo" value="<%=blnExcedeMontoMaximo%>"/>
                    <input type="hidden" name="hcnMontoMaximoCoaseguro" value="<%=objPoliza.getDblMaxMontoCoaseguro()%>"/>
                    <input type="hidden" name="hcnMonedaSimbolo" value="<%=objPoliza.getStrCurrencySymbol()%>"/>
                    <input type="hidden" name="hcnMonedaCodigo" value="<%=objPoliza.getIntCurrrency()%>"/>
                    <input type="hidden" name="hcnPoliza" value="<%=poliza%>"/>
                    <input type="hidden" name="hcnCertificado" value="<%=certificado%>"/>
                    <input type="hidden" name="hcnCliente" value="<%=cliente%>"/>
                    <input type="hidden" name="hcnClinica" value="<%=clinica%>"/>                    
                    <input type="hidden" name="hcnMontoInicial" value="<%=montoInicial%>"/>
                    <input type="hidden" name="hcnPrimerSiniestro" value="<%=primerSiniestro%>"/>
                    <input type="hidden" name="hcnSegundoSiniestro" value="<%=secondClaim%>"/>
                    <input type="hidden" name="hcnblnSecondClaim" value="<%=blnSecondClaim%>"/>
                    <!--2012-0078-->                    
                    <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>
                             <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px;margin-top:10px">
                                    <!--<legend><label class="titulo_campos_bold"></label></legend>  -->
                                      <div style="width:35%; float:left;">
                                      <span class="titulo_campos_bold" style="padding-bottom:15px;"><%=strTitulo%></span>
                                      </div>
                                    <div style="width:30%; float:left;padding-left:10px">
                                       <%
                                              //Req 2011-0480
                                              int usercode = -1;
                                              int flg_button = 0;
                                              int state = -1;
                                              int nulcodec = -1;
                                              
                                              usercode = gestorUsuario.esHabilAnulacion(usuario.getIntIdUsuario());  
                                              if(usercode > 0 && intFrmBandeja == 1)
                                              {
                                                 if(!objSolicitud.getSNROSINIESTRO().equals(""))
                                                 {  
                                                    state = objSolicitud.getNIDESTADO();
                                                    
                                                    if( state == Constante.NIDESTADOSOLICI )
                                                    {
                                                       flg_button = 1;
                                                       nulcodec = gestorSolicitud.getMotivoAnulacion(Integer.parseInt(objSolicitud.getSNROSINIESTRO()));
                                                    }
                                                 } 
                                            %>
                                              <table align="right" width="100%">
                                                <tr>
                                                  <td class="row2" align="right" >
                                                     Causa de Anulación&nbsp;&nbsp;
                                                  </td>
                                                  <td width="100px">
                                                    <select name="lscAnulacion" id="lscAnulacion"  class="TxtCombo lp-select" style="width:90%;align:right;" <%=(flg_button == 0?"":" class='row5 lp-select' disabled")%> >
                                                      <option value="0" >(Ninguno) </option>
                                                      <%
                                                        BeanList lstAnulacion = Tabla.lstTableIfx(136);
                                                          for (int i= 0; i < lstAnulacion.size(); i++ )
                                                          {
                                                          %>
                                                            <option value=<%=lstAnulacion.getBean(i).getString("1")%> <%=(nulcodec == Integer.parseInt(lstAnulacion.getBean(i).getString("1"))?"selected":"")%> ><%=lstAnulacion.getBean(i).getString("4")%></option>
                                                          <%
                                                          }
                                                      %>
                                                    </select>
                                                  </td>
                                                  <td>
                                                    <input type="button" value="Anular" class="btn_secundario lp-glyphicon lp-glyphicon-remove-color" onClick="javascript:anularSiniestro();" <%=(flg_button == 0?"":" class='row5 btn_secundario lp-glyphicon lp-glyphicon-remove-color' disabled")%> >
                                                  </td>
                                                </tr>
                                              </table>
                                            <%
                                              }
                                              //Fin Req 2011-0480
                                            %> 
                                    </div>
                                    <div style="width:35%; float:right;padding-right:20px; text-align:right">
                                            <SCRIPT language="JavaScript">
                                                    //PRT funcion que abre una ventana emergente para visualizar el historico de una solicitud
                                                    function ventanaEmergente(URL){    
                                                        window.open(URL,'ventanahistorico', 'height=430, top=100, left=200, width=1000, toolbar=no,directories=no, menubar=no scrollbars=no, resizable=yes');
                                                    }
                                            </SCRIPT>     
                                            
                                       <a class="texto_general_bold" href="javascript:ventanaEmergente('../consultasolicitud/Historico.jsp');">Hist&oacute;rico</a>&nbsp; 
                                                <a href="javascript:regresar();" class="btn_secundario lp-glyphicon lp-glyphicon-return-color">Regresar</a>
                                    </div>
                                    <div style="clear:both"></div>
                                    
                                    <table cellSpacing="1"  border=0 width="100%">
                                        <tr style="display:none">
                                            <td align=left colspan=3>&nbsp;</td>
                                            <td class="row2" colspan=2 ></td>
                                            <td align=right class="row2" colspan=3>                                                                                     
                                              <!--//PRT INICIO DE TABLA//-->
                                              <table>
                                              <tr>
                                              <td>
                                                                                                                                              
                                              </td>
                                              <td>
                                              
                                              </td>
                                              </tr>
                                              </table>
                                              <!--//PRT FIN DE TABLA//-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align=left class="row1"  width="12%">Nro. Solict. :&nbsp;</td>
                                            <td align=left class="row1" width="35%" colspan=3>
                                                <input class="row1 input_text_sed" name = "tcnAutoriza" type="text" readonly size="25" value="<%=objSolicitud.getSNROSINIESTRO()%>">
                                            </td>
                                            <td align=left class="row1" width="10%" colspan=2 >Fec. Emisión. :&nbsp;</td>
                                            <td align=left class="row1" colspan="2">
                                                <input class="row1 input_text_sed" size=12 name = "tcdFecEmi" type="text" readonly value="<%=objSolicitud.getDFECHAREG()%>">
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="12%">Oficina. :&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="35%">
                                                <input class="row1 input_text_sed" name= "tctOficina" type="text" readonly  size="25" value="<%=gestorUsuario.getNombOficina(usuario.getIntCodOficina())%>"/>
                                                <input type="hidden" name="hcnOficina" value="<%=usuario.getIntCodOficina()%>"/>
                                            </td>
                                         
                                            <td align=left class="row1" colspan=2 width="10%">Ramo :&nbsp;</td>
                                            <td align=left class="row1" colspan=2>
                                                <input class="row1 input_text_sed" name= "tctRamo" type="text" readonly  style="width:91%" value="<%=Tabla.reaTableIfx(10,intRamo).getString("2")%>" size="40">
                                                <%--<input type="hidden" name="hcnRamo" value="<%=Constante.NRAMOASME%>"/> modificado por apple--%>
                                                <input type="hidden" name="hcnRamo" value="<%=objCliente.getIntRamo()%>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="12%">Contrato. :&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="35%">
                                                <input class="row1 input_text_sed" name= "tcnPoliza" type="text" size="15" readonly value="<%=objCliente.getIntPoliza()%>"/>
                                                <input class="row1 input_text_sed" type="text" style="width:67%" readonly value="<%=objCliente.getStrContratante()%>">
                                            </td>
                                           
                                            <td align=left class="row1" colspan=2 width="12%">Certificado. :&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td align=left class="row1" width="19%">
                                                <input class="row1 input_text_sed" style="width:40%;margin-right:70px" name= "tcnCertif" type="text" readonly  size="12" value="<%=objCliente.getIntCertificado()%>"/>            
                                                Moneda :&nbsp;
                                            </td>
                                            <td align=left class="row1">
                                                <input class="row1 input_text_sed" type="text" readonly value="<%=objCliente.getStrMoneda()%>">
                                            </td>  
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="12%">Producto. :&nbsp;</td>
                                            <td align=left class="row1" colspan=7 width="35%">
                                                <input class="row1 input_text_sed" name="tctProducto" type="text" size="25" readonly value="<%=objPoliza.getStrDesProduct()%>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Titular&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=3 width="35%">
                                                <input class="row1 input_text_sed" name="tctTitular" type="text" readonly style="width:93%" value="<%=objCliente.getStrNombreTitular()%>">
                                            </td>
                                          
                                            <td align="left" class="row1" colspan=2 width="10%">Fecha Ingreso&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1"  colspan=2>
                                                <input class="row1 input_text_sed" type="text" size="12" readonly value="<%=objCliente.getStrFecIngreso()%>">
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                             <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Paciente&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=3 width="36%">
                                                <input class="row1 input_text_sed" name="tctAsegurado" type="text" style="width:93%" readonly value="<%=objCliente.getStrNombreAseg()%>"/>
                                            </td>
                                            
                                            <td align=left class="row1" width="10%">Tipo de Atenci&oacute;n :&nbsp;</td>
                                            <td align=left class="row1" width="12%">
                                                <input class="row1 input_text_sed" size=12 name = "tctTipoAtencion" type="text"  readonly value="<%=objCobertura.getStrTipoAtencion()%>">  
                                            </td>
                                            <td align=left class="row1" width="7%">Cobertura :&nbsp;</td>
                                            <td align=left class="row1">
                                                <input class="row1 input_text_sed" name = "tctCobertura" type="text" readonly  size="20" value="<%=objCobertura.getStrNomCobertura()%>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" class="row1" width="10%" >Fecha Nac.&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="12%">
                                                 <input class="row1 input_text_sed" name = "tctCobertura" type="text" readonly  size="12" value="<%=objCliente.getStrFecNac()%>">
                                            </td>
                                            <!--//RQ2015-000750 INICIO//-->
                                            <td align="left" class="row1" width="10%" style="text-align: right">Correo&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="16%" style="text-align: left"> <!-- 50%     size="33"-->
                                                 <input class="row5 input_text_sed" name = "tctemail" style="color:#606363;width:83%;"  type="text" maxlength="50" value="<%=objCliente.getStrEmail()%>">
                                                 <input type="hidden" name="hcnValidaEmail" value="<%=Tool.parseInt(Constante.getConstBD("EMAIL_OBL"))%>"/>
                                            </td>
                                            <!--//RQ2015-000750 FIN//-->
                                            <td align=left class="row1" width="12%" >Tiempo de Enfermedad :&nbsp;</td>
                                            <td align="left" class="row1" colspan="3" >
                                              <%--<input name = "tcnTiempoEnfermedad" type="text" size=12  maxlength="8"  value="<%=objSolicitud.getIntTiempoEnfermedad()%>" onblur="validarEntero (this)" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5'":"readonly class='row1'")%> > --%>
                                              <input name = "tcnTiempoEnfermedad" type="text" size=12  maxlength="8"  value="<%=objSolicitud.getIntTiempoEnfermedad()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%> >
                                                día(s)
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <span class="texto_general_black">&nbsp;&nbsp;&nbsp;&nbsp;<%=strContinuidad%></span>
                                            </td>
                                        </tr> 
                                        <tr id="dtProveedor1">    
                                              <td align=left class="row1" width="12%" >Proveedor :&nbsp;</td>
                                              <td align=left colspan=3 class="row1" width="36%">
                                                  <input class="row1 input_text_sed" readonly name = "tcnProveedor" type="text" size=15 value="<%=objSolicitud.getIntCodProveedor()%>">
                                                  <input class="row1 input_text_sed" readonly name = "tctProveedor" type="text" size=50 value="<%=objSolicitud.getStrProveedor()%>" maxlength="40">
                                              </td>    
                                              <td align=left class="row1" width="10%">
                                                    <%if (objSolicitud.getStrProveedorSol().length()>0){%>
                                                       Clínica Solicitante :&nbsp;
                                                    <%}else{%>
                                                        &nbsp;
                                                    <%}%>            
                                              </td>
                                              <td align=left class="row1" colspan="3" width="19%">
                                                    <%if (objSolicitud.getStrProveedorSol().length()>0){%>
                                                       <input class="row1 input_text_sed" readonly size=50 name = "tctProveedorSol" type="text" value="<%=objSolicitud.getStrProveedorSol()%>" maxlength="75"  >
                                                    <%}else{%>
                                                        &nbsp;
                                                    <%}%>
                                              </td>                                              
                                        </tr>
                                        <tr id="dtProveedor" style="display:none">
                                            <td align="left" class="row1" width="12%" >&nbsp;</td>
                                            <td align=left class="row1" colspan=7>
                                                <iframe name="frProveedor" src="../general/Lista.jsp" width="350" height="55" border=0 frameBorder=0 scrolling="no"></iframe>          
                                            </td>
                                        </tr>                                        
                                       <tr>
                                            <td align=left class="row1" width="12%" >Diagnostico. :&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="36%">                                            
                                            <!--onBlur="javascript:buscarCodDiagnostico()"
                                            limpiaAsociado(this)-->
                                                <input 	name="tcnDiagnos" type="text" size=15 onchange="javascript:buscarLimpiarDiagnostico(this);"  onblur="javascript:buscarCodDiagnostico();"                                               
														onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this, event);" maxlength="5"  
														value="<%=objSolicitud.getIntCodDiagnos()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                                <input 	name="tctDiagnos" type="text" size=30 onchange="javascript:limpiaAsociado(this);" 
														onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this, event);" maxlength="40" 
														value="<%=objSolicitud.getStrDiagnos()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>           
                                            <td align=left class="row1" width="10%">M&eacute;dico Tratante :&nbsp;</td>
                                            <td align=left class="row1" colspan="3" width="5%">                                                
                                                <input size=12  name = "tctCMPMedico" type="text" onchange="javascript:limpiaAsociado(this);" onblur="javascript:buscarCodMedico();" value="<%=objSolicitud.getSCMPMEDICO()%>" onkeypress="onKeyPressNumero('this');" maxlength="8" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%> >&nbsp;                                                     
                                                <input size=30  name = "tctNombreMedico" type="text" onchange="javascript:limpiaAsociado(this);" value="<%=objSolicitud.getSNOMBMEDICO()%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" maxlength="75" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%> > &nbsp;
                                                <label style="color:#606363;">(Apellidos, Nombres)&nbsp;</label>
                                            </td> 
                                        </tr>
                                        <tr id="dtDiagnostico" style="display:none">
                                            <td align="left" class="row1" width="12%" >&nbsp;</td>
                                            <td align=left class="row1" colspan=7>
                                                <iframe name="frDiagnostico" src="../general/Lista.jsp" width="350" height="55" border=0 frameBorder=0 scrolling="no"></iframe>          
                                            </td>    
                                        </tr> 
                                       <tr>
                                            <%                                                                                    
                                            if(!((intCacalili==1 || flagEps == 1))){ %>                                            
                                            <td align="left" class="row1" width="12%" >Max. Facturar&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" name="tcnMaxFact" type="text" size="16" readonly style="text-align:right" value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrBeneficioMax()) - Tool.parseDouble(objCobertura.getStrBeneficioCons()),2)%>" maxlength="10">
                                            </td>
                                            <td align="left" class="row1" width="10%">Cap. Aseg&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" name="tcnCapAseg" type="text" size="16" readonly style="text-align:right" value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrBeneficioMax()),2)%>">
                                            </td>                                            
                                            <%}else {%>                                                                                        
                                            <td align=left class="row1" width="12%">Benef. Consumido&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" name="tcnMaxFact" type="text" size="16" readonly style="text-align:right" value="<%=Tool.toDecimal(Tool.parseDouble(strBenefConsumido),2)%>" maxlength="10">
                                            </td>
                                            <td align=left class="row1" width="10%">&nbsp;</td>
                                            <td align=left class="row1" width="13%">&nbsp;</td>
                                            <%}%>
                                            <td align="left" class="row1"  width="10%">Tipo de Cambio&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan="3" >
                                                <input class="row1 input_text_sed" name="tcnCambio" type="text" size="12" readonly value="<%=strTipoCambio%>">
                                            </td>          
                                        </tr>
                                    </table>
                                </fieldset>
                                </div>
                            </td>    
                        </tr>    
                        <tr>
                            <td>
                              <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <%                                                                                    
                                            if(!((intCacalili==1))){ %> 
                                        <tr>
                                            <td align="left" class="row1" width="12%">Deducible&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="10%">
                                                <%--<input class="row1" type="text" name="tcnDedu" style="width:25%" readonly value="<%=objCobertura.getStrDeducible()%>">% --%>
                                                <input class="row1 input_text_sed" type="text" name="tcnDedu" style="width:25%" readonly value="<%=objCobertura.getStrDeducible()%>">%                   
                                            </td>
                                            <td align="left" class="row1" width="10%">&nbsp;Monto :</td>
                                            <td align="left" class="row1" width="16%">
                                                <%--<input class="row1" type="text" name="tcnADedu" size="16" readonly value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2)%>"/>--%>
                                                <input class="row1 input_text_sed" type="text" name="tcnADedu" size="16" readonly value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2)%>"/>
                                            </td>
                                            <td align="left" class="row1" width="10%">Por Cuarto&nbsp;:&nbsp;</td>
                                            
                                            <td align="left" class="row1" width="12%">
                                                <b><input class="row1 input_text_sed" type="text" name="tcnQDedu" style="width:50%" readonly value="<%=objCobertura.getStrCantidad()%>"/></b> dia(s)
                                            </td>
                                            
                                            <td align="left" class="row1" width="9%">Coas. a cargo aseg.&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="24%">
                                                <%--<input class="row1" type="text" name="tcnGasto" size="8" readonly value="<%=objCobertura.getStrCoaseguro()%>"> % --%>
                                                <input class="row1 input_text_sed" type="text" name="tcnGasto" size="8" readonly value="<%=objCobertura.getStrCoaseguro()%>"> %                                                
                                            </td>
                                        </tr>
                                        <%}else {%>  
                                          <tr>
                                            <td align="left" class="row1" width="12%">Deducible&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="10%">
                                                <%--<input class="row1" type="text" name="tcnDedu" style="width:25%" readonly value="<%=objCobertura.getStrDeducible()%>">% --%>
                                                <input class="row1 input_text_sed" type="text" name="tcnDedu" style="width:25%" readonly value="<%=objCobertura.getStrDeducible()%>">%
                                                <!--<input class="row1" type="text" name="tcnDedu" style="width:25%" readonly value="0.00"> %    RQ2017-1848                         -->                                                                                                  
                                            </td>
                                            <td align="left" class="row1" width="10%">&nbsp;Monto :</td>
                                            <td align="left" class="row1" width="16%">
                                                <%--<input class="row1" type="text" name="tcnADedu" size="16" readonly value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2)%>"/>--%>
                                                <input class="row1 input_text_sed" type="text" name="tcnADedu" size="16" readonly value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2)%>"/>
                                                <!--<input class="row1" type="text" name="tcnADedu" size="16" readonly value="0.00"/>  RQ2017-1848 -->                                             
                                            </td>
                                            <td align="left" class="row1" width="10%">Por Cuarto&nbsp;:&nbsp;</td>
                                            
                                            <td align="left" class="row1" width="12%">
                                                <b><input class="row1 input_text_sed" type="text" name="tcnQDedu" style="width:50%" readonly value="<%=objCobertura.getStrCantidad()%>"/></b> dia(s)
                                            </td>
                                            
                                            <td align="left" class="row1" width="9%">Coas. a cargo aseg.&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="24%">
                                                <%--<input class="row1" type="text" name="tcnGasto" size="8" readonly value="<%=objCobertura.getStrCoaseguro()%>"> % --%>
                                                <input class="row1 input_text_sed" type="text" name="tcnGasto" size="8" readonly value="<%=objCobertura.getStrCoaseguro()%>"> %                                                    
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td align="left" class="row1" width="12%">Moneda Carta&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <%if (objSolicitud.getNIDSOLICITUD()==0){%>
                                                    <select name="lscMoneda"  class="TxtCombo lp-select" style="width:100%" onchange="javascript:selObj(this);">
                                                        <%
                                                            BeanList lstModena = Tabla.lstTableIfx(11);
                                                            for (int i= 0; i < lstModena.size(); i++ ){%>
                                                              <option value=<%=lstModena.getBean(i).getString("1")%>><%=lstModena.getBean(i).getString("4")%></option>
                                                        <%  }
                                                }else{
                                                    /*Bean bTemp = Tabla.reaTableIfx(11,objSolicitud.getIntMonedaImpoCarta());
                                                    String strMoneda="";
                                                    String strCodMoneda="";
                                                    if (bTemp!=null){
                                                      strCodMoneda = bTemp.getString("1");
                                                      strMoneda = bTemp.getString("4");
                                                    }*/
                                                    %>
                                                    <input class="row1" type="hidden" name="lscMoneda" size="10" readonly value="<%=objSolicitud.getIntMonedaImpoCarta()%>">
                                                    <input class="row1 input_text_sed" type="text" name="tctMoneda" size="15" readonly value="<%=objSolicitud.getStrMonedaImpoCarta()%>">
                                                <%}%>
                                                </select>                            
                                            </td>
                                            <td align="left" class="row1">Monto Carta&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1">
                                                <input type="text" name="tcnImpCarta" size="11" onKeyPress="javascript:onKeyPressNumero('this');" style="text-align:right" maxlength="10" value="<%=dblMontoCarta%>" <%=(blnEditar && !(objSolicitud.getNIDESTADO()==Constante.NESTOBS && objSolicitud.getNFLGAMPLIACION()==1)?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>/>
                                            </td>
                                            
                                            <td align="left" class="row1" width="10%" >Fecha Límite&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="6%">
                                                <!--Inicio Req. 2014-000204 Paradigmasoft GJB-->                                                  
                                                <input class="row1 input_text_sed" maxlength="12" type="text" name="tcdFechaLim" onKeyPress="javascript:onKeyPressFecha(this);" size="12" readonly value="<%=(objSolicitud.getNIDSOLICITUD()==0?Tool.addDate(30,"dd/MM/yyyy"):objSolicitud.getStrFechaLimite())%>">
                                                <!--Fin Req. 2014-000204 Paradigmasoft GJB-->
                                                <img  ALT="Calendario" SRC="../images/Iconos/14x14-color/Iconos-14x14-color-99.png"  BORDER="0"  onClick="OpenCalendar('tcdFechaLim','../')" style="cursor:hand;">
                                            </td>
                                            <td align="left" class="row1" colspan="2">
                                                <!--<input type="button" value="Exclusiones" onClick="javascript:verExclusion();" <%=(objCliente.getIntIndExcl() == 1?"class='TxtCombor'":" class='row5' disabled")%>> -->                                            
                                                <table>                                                
                                                  <tr>
                                                    <td><input type="button" value="Exclusiones del Asegurado" style="width:250px;text-align:left;"  onClick="javascript:verExclusion();" <%=(objCliente.getIntIndExcl() == 1?"class='TxtCombor btn_secundario lp-glyphicon lp-glyphicon-remove-color'":" class='row5 btn_secundario lp-glyphicon lp-glyphicon-remove-color' disabled")%>></td>
                                                  </tr>
                                                    <!--Req 2019-626 [EMV] - INI-->
                                                    <%if ( intRamo == 81 || intRamo == 82 || intRamo == 83 ){ %>
                                                    <tr>
                                                        <td>

                                                            <button type="button" class="TxtCombor lq-btn lp-glyphicon" style="width:250px;text-align:left;"
                                                                    onClick="javascript:abrirObservacionesAsegurado('<%= objCobertura.getStrObservAseg() %> ');"
                                                                    <%if ( objCobertura.getStrObservAseg()== null || "".equals(objCobertura.getStrObservAseg().trim()) ){%>
                                                                    disabled
                                                                    <%}%> >
                                                                Observaciones del Asegurado
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    <!--Req 2019-626 [EMV] - FIN-->
                                                  <tr>
                                                    <td><input type="button" value="Exclusiones Generales del Contrato" style="width:250px;" onClick="javascript:abrirExclusionesGenerales();" class='TxtCombor lq-btn lp-glyphicon lp-glyphicon-remove-blanco'></td>
                                                  </tr>
                                               </table>                                                
                                            </td> 
                                        </tr>
                                        <!--Inicio Req. 2014-000204 Paradigmasoft GJB-->
                                        <%if (objPoliza.getIntProduct() == Tool.parseInt(Constante.getConst("PROD"))){%>
                                          <tr>
                                            <td align="left" class="row1" colspan=6>
                                            <td align="left" class="row1" style="COLOR:red" colspan=2>Plan no incluye tratamiento oncol&#243;gico en LP&nbsp;</td> 
                                          </tr>
                                        <%}%>
                                        <!--Fin Req. 2014-000204 Paradigmasoft GJB-->
                                        <tr id="dtSeccion1">
                                            <td align="left" class="row1" width="12%" >Motivo Rechazo&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=7>
                                                <%if ((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE){%>              
                                                    <select name="lscMotivo"  style="width:35%" onchange="javascript:selObj(this);" <%=((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE?"class='TxtCombo lp-select'":"class='row1 lp-select' disabled")%>>
                                                        <option value=0>(Ninguno)</option>
                                                        <%BeanList lstMotivo = Tabla.lstTableQIfx(318);
                                                        for (int i= 0; i < lstMotivo.size(); i++ ){
                                                            int intcod = Tool.parseInt(lstMotivo.getBean(i).getString("codigint"));
                                                            %>
                                                            <option <%=(objSolicitud.getObjSolhis().getNCODMOTIVO()==intcod?"selected":"")%> value=<%=lstMotivo.getBean(i).getString("codigint")%>><%=lstMotivo.getBean(i).getString("descript")%></option>
                                                        <%}%>
                                                    </select>
                                                <%}else{
                                                    Bean bMotivo = Tabla.reaTableQIfx(318,objSolicitud.getObjSolhis().getNCODMOTIVO());                
                                                    String strMotivo = "";
                                                    if (bMotivo!=null)
                                                        strMotivo = bMotivo.getString("descript").toUpperCase();
                                                    %>
                                                    <input class="row1 input_text_sed" type="text" style="width:40%;COLOR:red" name="txtMotivo" readonly value="<%=strMotivo%>">
                                                <%}%>
                                            </td>
                                        </tr>    
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>
                        <!--Inicio RQ2015-000604 -->
                         
                         <%
                           int ncrol = usuario.getIntIdRol();
                           if ((ncrol == Constante.NROLAUDIMED || ncrol==Constante.NROLASIRECH || ncrol==Constante.NROLATEC || ncrol ==Constante.NROLMED) && staRechazo==1){
                         %>
                            <tr id="dtMedicoAuditor">
                            <td>
                             <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend></legend>  
                                        <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">                                        
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Motivo Rechazo SBS&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=7>
                                                <%if ((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE){%>              
                                                    <select name="lscMotivoSBS"  style="width:62%" onchange="javascript:selObj(this);" <%=((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE?"class='TxtCombo lp-select'":"class='row1 lp-select' disabled")%>>
                                                        <option value=0>(Ninguno)</option>
                                                        <%BeanList lstMotivo = Tabla.lstTableQIfx(604);
                                                        for (int i= 0; i < lstMotivo.size(); i++ ){
                                                            int intcod = Tool.parseInt(lstMotivo.getBean(i).getString("codigint"));
                                                            %>
                                                            <option <%=(objRechazo.getNIdMotReSBS()==intcod?"selected":"")%> value=<%=lstMotivo.getBean(i).getString("codigint")%>><%=lstMotivo.getBean(i).getString("descript")%></option>
                                                        <%}%>
                                                    </select>
                                                <%}else{
                                                    Bean bMotivo = Tabla.reaTableQIfx(318,objRechazo.getNIdMotReSBS());                
                                                    String strMotivoSBS = "";
                                                    if (bMotivo!=null)
                                                        strMotivoSBS = bMotivo.getString("descript").toUpperCase();
                                                    %>
                                                    <input class="row1 input_text_sed" type="text" style="width:62%;COLOR:red" name="txtMotivoSBS" readonly value="<%=strMotivoSBS%>">
                                                <%}%>
                                            </td>
                                        <td align=left class="row1" width="12%" >Diagnostico Médico :&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="36%">                                                                                            
                                                <input name = "tcnDiagnosM" type="text" size=15 onchange="javascript:limpiaAsociado(this);" onblur="javascript:buscarCodDiagnosticoMedico();"  onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this, event);" maxlength="5"  value="<%=objRechazo.getNIDDiagnos()%>" <%=(objSolicitud.getNIDESTADO()!=Constante.NESTRECH?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                                <input name = "tctDiagnosM" type="text" size=43 onchange="javascript:limpiaAsociado(this);" onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this, event);" maxlength="40" value="<%=objRechazo.getSDiagnos()%>" <%=(objSolicitud.getNIDESTADO()!=Constante.NESTRECH?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td> 
                                        </tr>
                                        <tr id="dtDiagnosticoMedico" style="display:none">
                                            <td align="left" class="row1" width="12%" >&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="36%">
                                                <iframe name="frDiagnosticoMedico" src="../general/Lista.jsp" width="350" height="55" border=0 frameBorder=0 scrolling="no"></iframe>          
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Sub Motivo Rechazo&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=7>
                                                <%if ((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE){%>              
                                                    <select name="lscSubMotivoSBS"  style="width:35%" onchange="javascript:selObj(this);" <%=((objSolicitud.getNIDESTADO()==Constante.NESTPEN || objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS || objSolicitud.getNIDESTADO()==Constante.NESTAMP || objSolicitud.getNIDESTADO()==Constante.NESTDER)  && usuario.getIntIdRol()!=Constante.NROLOPE?"class='TxtCombo lp-select'":"class='row1 lp-select' disabled")%>>
                                                        <option value=0>(Ninguno)</option>
                                                        <%BeanList lstMotivo2 = Tabla.lstTableQIfx(318);
                                                        for (int i= 0; i < lstMotivo2.size(); i++ ){
                                                            int intcod2 = Tool.parseInt(lstMotivo2.getBean(i).getString("codigint"));
                                                            %>
                                                            <option name="lscSubMotivo" <%=(objRechazo.getNIdSubMotRe()==intcod2?"selected":"")%> value=<%=lstMotivo2.getBean(i).getString("codigint")%>><%=lstMotivo2.getBean(i).getString("descript")%></option>
                                                        <%}%>
                                                    </select>
                                                <%}else{
                                                    Bean bMotivo2 = Tabla.reaTableQIfx(318,objRechazo.getNIdSubMotRe());                
                                                    String strSubMotivoSBS = "";
                                                    if (bMotivo2!=null)
                                                        strSubMotivoSBS = bMotivo2.getString("descript").toUpperCase();
                                                    %>
                                                    <input class="row1 input_text_sed" type="text" style="width:40%;COLOR:red" name="txtSubMotivoSBS" readonly value="<%=strSubMotivoSBS%>">
                                                <%}%>
                                            </td>
                                            <td align="left" class="row1" width="12%" >Proc/Hospi/Otros a rechazar&nbsp;:&nbsp;</td>
                                            <td align=left class="row1" colspan="3" width="36%">                                                                                                
                                                <input size=50 name=tctProcRecha type="text" value="<%=objRechazo.getSProcedimient()%>"  maxlength="200" <%=(objSolicitud.getNIDESTADO()!=Constante.NESTRECH?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>                                 
                         <%}%>                                                                                              
                        <!--Fin RQ2015-000604 -->
                        <!--  Aca va el presupuesto  -->
                        <tr id="dtSeccionPresupuesto">
                            <td>
                              <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:5px; padding-bottom:10px">
                                    <legend class="titulo_campos_bold">Presupuesto</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls"> 
                                         <tr>
                                            <td align=left class="row1 texto_general_black" width="50%" colspan="2">CLINICA</td>
                                            <td align=left class="row1" width="50%" colspan="2"></td>
                                         </tr>
                                         <tr>
                                            <td align=left class="row1" width="10%">Cuarto :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoCuarto"   type="text" size="16" value="<%=arrMontos[0]%>"  onkeypress="onKeyPressMonto();" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Uso de Equipos :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoUsoEquip" type="text" size="16" value="<%=arrMontos[9]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">Sala de Operaciones :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoSalaOpera" type="text" size="16" value="<%=arrMontos[1]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Consumo de Ox&iacute;geno :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoConsumoOxig" size="16" type="text" value="<%=arrMontos[10]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">Sala de Recuperaci&oacute;n :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoSalaRecup" type="text" size="16" value="<%=arrMontos[2]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Cardiolog&iacute;a :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoCardiologia" size="16" type="text" value="<%=arrMontos[11]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1 texto_general_black" width="50%" colspan="2">HONORARIOS MEDICOS</td>
                                            <td align=left class="row1" width="8%">Laboratorio :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoLaboratorio" size="16" type="text" value="<%=arrMontos[12]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>  
                                        </tr>
                                         <tr>
                                            <td align=left class="row1" width="10%">Cirujano :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoCirujano" type="text" size="16" value="<%=arrMontos[3]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Radiolog&iacute;a :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoRadiologia" size="16" type="text" value="<%=arrMontos[13]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                         <tr>
                                            <td align=left class="row1" width="10%">1er. Asistente :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoPrimerAsist" type="text" size="16" value="<%=arrMontos[4]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Ecograf&iacute;a :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoEcografia" size="16" type="text" value="<%=arrMontos[14]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                         <tr>
                                            <td align=left class="row1" width="10%">2do. Asistente :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoSegundoAsis" type="text" size="16" value="<%=arrMontos[5]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Equipos Especiales :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoEquiposEsp" size="16" type="text" value="<%=arrMontos[15]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">Anestesia :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoAnestesia" type="text" size="16" value="<%=arrMontos[6]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">Tomograf&iacute;a :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoTomografia" size="16" type="text" value="<%=arrMontos[16]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td align=left class="row1 texto_general_black" width="50%" colspan="2">FARMACIA</td>
                                            <td align=left class="row1" width="8%">Resonancia :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoResonancia" size="16" type="text" value="<%=arrMontos[17]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>  
                                        </tr>
                                        
                                        <tr>
                                            <td align=left class="row1" width="10%">Farmacia en piso :&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoFarmaciaPiso" type="text" size="16" value="<%=arrMontos[7]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="10%">Farmacia Sala Operaciones:&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoFarmaciaSala" size="16" type="text" value="<%=arrMontos[8]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                        </tr>                                      
                                        <tr>
                                            <td align=left class="row1 texto_general_black" width="10%">OTROS</td>
                                            <td align=left class="row1" width="30%">&nbsp;</td>
                                            <td align=left class="row1" width="8%">
                                               &nbsp;
                                            </td>
                                            <td align=left class="row1" width="35%">

                                                &nbsp;
                                            </td>                                       
                                        </tr> 
                                        <tr>
                                            <td align=left class="row1" width="8%">Material de Osteos&iacute;ntesis :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoOsteosintesis" size="16" type="text" value="<%=arrMontos[19]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td> 
                                            <td align=left class="row1" width="8%">Material de Pr&oacute;tesis :&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnMontoProtesis" size="16" type="text" value="<%=arrMontos[20]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>  
                                             
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">Otros Consumos:</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoOtros" size="16" type="text" value="<%=arrMontos[18]%>" onchange="javascript:limpiaAsociado(this);" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>   

                                            <td align=left class="row1" width="8%">&nbsp;</td>
                                            <td align=left class="row1" width="35%">

                                               &nbsp;
                                            </td>    
                                        </tr> 
                                        <tr>
                                            <td align=left class="row1" width="10%">Detalle Otros Consumos:&nbsp;</td>
                                            <td align=left class="row1" colspan="3">
                                                <textarea name="txcObservaOtros" 
                                                  style="width:61%;height:53px" 
                                                  onkeydown="limitaText(this,250);" 
                                                  rows=3 cols=14  
                                                  onkeypress="javascript:onKeyPressMayuscula.call(this, event);" 
                                                  <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>><%=Tool.getString(strObsOtros)%></TEXTAREA>                
                                            </td>
                                        </tr>   
                                         <tr>
                                            <td align=left class="row1" width="10%">&nbsp;</td>
                                            <td align=left class="row1" width="30%">  &nbsp;                                              
                                            </td>   
                                            <td align=left class="row1" width="8%">SUB TOTAL:&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnSubTotal" size="16"  value="<%=dblTotalPresupuesto%>" type="text" <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>>
                                                <input type="hidden" name="hcnSubTotal" value="<%=dblTotalPresupuesto%>"/>
                                            </td>   
                                        </tr> 
                                        <tr>
                                            <td align=left class="row1" width="10%">&nbsp;</td>
                                            <td align=left class="row1" width="30%">&nbsp;
                                               
                                            </td>   
                                            <td align=left class="row1" width="8%">
                                                IGV:&nbsp;
                                                <INPUT type="checkbox" class="TxtCombo" name="chcIGV" onclick="actualizaPresupuesto();" checked="checked" <%=(objSolicitud.getNIDSOLICITUD()>0?"DISABLED":"")%>>
                                            </td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnIGV" size="16"  value="<%=dblMontoIgv%>"  type="text" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>     
                                        </tr> 
                                         <tr>
                                            <td align=left class="row1" width="10%">&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                               &nbsp;
                                            </td>   
                                            <td align=left class="row1" width="8%">TOTAL:&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnTotal" size="16"   value="<%=dblMontoTotal%>"  type="text" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr>                                         
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>
                        <!-- RQ2015-000604 Condicionado de la Poliza -->
                        <%
                           int nrol = usuario.getIntIdRol();
                           if ((nrol == Constante.NROLAUDIMED || nrol==Constante.NROLASIRECH || nrol==Constante.NROLATEC) && staRechazo==1){
                        %>
                        <tr id="dtCondicionado">
                            <td>
                             <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend class="titulo_campos_bold">Condicionado del Contrato</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                       <tr id="dtCondi1">
                                            <td align="left" class="row1" width="12%">Condicionado:&nbsp;</td>                                            
                                            <td align="left" class="row1" width="75%">
                                                <textarea style="WIDTH:100%; height:53px" name="txcCondiPi" rows=3 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" onkeydown="limitaText(this,<%=Constante.getConst("MAX_CARACTERES_CP")%>);" <%=((usuario.getIntIdRol()!=Constante.NROLATEC || usuario.getIntIdRol()!=Constante.NROLASIRECH || usuario.getIntIdRol()!=Constante.NROLAUDIMED) && objRechazo.getNIdStaCartR()==Constante.NSTCRPEND?"":"class='row1 input_text_sed' disabled" )%>><%=Tool.getString(objRechazo.getSCond_poli())%></TEXTAREA>
                                                <textarea style="WIDTH:86%; display:none; height:53px" name="txcCondiPi" rows=3 cols=14>
                                                  <%=Tool.getString(objRechazo.getSCond_poli())%>
                                                </TEXTAREA>                                                
                                            </td>                                                     
                                            <td align="left" class="row1" width="12%" style="font-size:66%">M&#225ximo&nbsp;<%=Constante.getConst("MAX_CARACTERES_CP")%>&nbsp;caracteres&nbsp;</td>                                            
                                        </tr>
                                    </table>
                                    <table cellSpacing="1"  border=0 width="100%">
                                       <tr id="dtCondi2">
                                            <td align="left" class="row1" width="12%">Condicionado:&nbsp;</td>                                            
                                            <td align="left" class="row1" width="75%">
                                                <textarea style="WIDTH:100%; height:53px" name="txcCondiPii" rows=3 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" onkeydown="limitaText(this,<%=Constante.getConst("MAX_CARACTERES_CP")%>);" <%=((usuario.getIntIdRol()!=Constante.NROLATEC || usuario.getIntIdRol()!=Constante.NROLASIRECH || usuario.getIntIdRol()!=Constante.NROLAUDIMED) && objRechazo.getNIdStaCartR()==Constante.NSTCRPEND?"":"class='row1 input_text_sed' disabled" )%>><%=Tool.getString(objRechazo.getSCond_polii())%></TEXTAREA>
                                                <textarea style="WIDTH:86%; display:none; height:53px" name="txcCondiPii" rows=3 cols=14>
                                                  <%=Tool.getString(objRechazo.getSCond_polii())%>
                                                </TEXTAREA>                                                
                                            </td>                                                     
                                            <td align="left" class="row1" width="12%" style="font-size:66%">M&#225ximo&nbsp;<%=Constante.getConst("MAX_CARACTERES_CP")%>&nbsp;caracteres&nbsp;</td>                                            
                                        </tr>
                                    </table>
                                </fieldset>                                
                                <fieldset class="row5 content_resumen">
                                <legend class="titulo_campos_bold">Nro. Carta Rechazo</legend>
                                <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                 <tr>
                                     <td align="left" class="row1" colspan=3 width="100%">
                                          <input name="tctNumRecha" type="text" style="width:25%" value="<%=objRechazo.getSNumCartRech()%>" <%=objRechazo.getNIdStaCartR()==Constante.NSTCRTER?"":"class='row1 input_text_sed' readonly"%>>
                                     </td>
                                     <td align="left" class="row1" >                                        
                                        <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-edit-color' value="Editar" onClick="javascript:editarCR('<%=objSolicitud.getSNROSINIESTRO()%>','<%=objSolicitud.getObjSolhis().getStrUSUAPROB()%>');" name="btnEditarCarta" <%=objRechazo.getNIdStaCartR()!=Constante.NSTCRIMP?"disabled":""%>/>                                           
                                     </td>
                                     <td align="left" class="row1" >
                                        <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-print-color' value="Imprimir" onClick="javascript:imprimirCR('<%=objSolicitud.getSNROSINIESTRO()%>','<%=objSolicitud.getObjSolhis().getStrUSUAPROB()%>');" name="btnImprimirCarta"<%=objRechazo.getNIdStaCartR()!=Constante.NSTCRIMP?"disabled":""%>/>                                          
                                     </td>
                                     <td align="left" class="row1" >
                                        <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-save-color' value="Guardar" onClick="javascript:registraSolicitud('guardar');" name="btnGuardarConPoli" <%=objRechazo.getNIdStaCartR()==Constante.NSTCRIMP || objRechazo.getNIdStaCartR()==0?"disabled":""%> />                                           
                                     </td>
                                 </tr>
                                </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>                                                      
                        <%}%>
                        <!-- RQ2015-000604 -->
                        <!--  Observación Clínica  -->                                                                      
                        <tr id="dtSeccion10">                        
                            <td>
                              <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend class="titulo_campos_bold">Recomendación</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <tr>
                                            <td align="left" class="row1" width="12%">Observaci&oacute;n Clinica&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="85%">
                                                <textarea style="WIDTH:86%; height:53px" onkeydown="limitaText(this,398);" name="txcObservaClinica" 
                                                    rows=3 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" 
                                                    <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>><%=Tool.getString(objSolicitud.getSOBSERVACLI())%></TEXTAREA>
                                                <BR><textarea class="input_text_sed" style="WIDTH:86%; height:53px;display:none" name="txcObservaCliTemp" rows=3 cols=14><%=Tool.getString(objSolicitud.getSOBSERVACLI())%></TEXTAREA>
                                            </td>
                                        </tr>    
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                              <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <%if (!"".equals(objSolicitud.getObjSolhis().getSARCHIVO1())){%>
                                             <tr>                                            
                                                <td align="left" class="row5" >
                                                    <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-search-file-color' value="Ver Archivos Adjuntos" onClick="javascript:verArchivosAdjuntos();" name="btnArchivosAdjuntos"/>                                           
                                                </td>
                                             </tr>    
                                        <%}%>
                                        <tr id="dtUpload"  <%=(blnEditar?"":"style=\"display:none\"")%>>
                                            <td class="row1">
                                                <iframe name="fichero" src="UploadFichero.jsp" width="100%" height="30" border=0 frameBorder=0 scrolling="no"></iframe>                      
                                            </td>
                                        </tr>
                                    </table>
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">                                      
                                      <tr id="dtProceso" style="display:none">
                                          <td  class="row5" colspan=3 align="center"><br>
                                              <img  name="btnProceso" ALT="Procesando" SRC="../images/loading_turquesa1.gif"  BORDER="0">
                                          </td>
                                      </tr>                                       
                                      <tr id=dtEnviar>
                                          <%
                                            String strNoMostrar = "";
                                            String strNombreImprimir = "Imprimir"; //0510
                                            if(usuario.getIntIdRol() == Constante.NROPERFILBRK)
                                            {
                                              strNoMostrar = "style=\"display:none\"";
                                              strNombreImprimir = "Ver Documento"; //0510
                                            }else if(flagImpresion == 1)
                                            {
                                              strNombreImprimir = "Ver Documento";
                                            }
                                          %>
                                          <td align="left" class="row5" width="5%">
                                             <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-print-color' value="<%=strNombreImprimir %>" disabled="disabled" onClick="javascript:imprimir('<%=objSolicitud.getSNROSINIESTRO()%>','<%=objSolicitud.getObjSolhis().getStrUSUAPROB()%>');" name="btnImprimir"/>
                                          </td>
                                          <!--
                                          <td align="left" class="row5" width="5%">
                                             <input type="button" class="row5" value="Anular" onClick="javascript:registraSolicitud('anular');" name="btnAnular"/>
                                          </td>
                                          -->
                                          <td align="left" class="row5" width="5%" colspan="2">
                                              &nbsp;
                                              <!-- HD 57926
                                                  <input type="button" class="row5" value="Grabar" onClick="javascript:registraSolicitud('grabar');" name="btnGrabar"/>
                                              -->
                                          </td>
                                          <td align="left" class="row5" width="20%">&nbsp;</td>                                        
                                          <td align="left" class="row5" width="5%">
                                              <input type="button" class="row5 btn_secundario lp-glyphicon lp-glyphicon-ok-color" value="Aprobar" onClick="javascript:registraSolicitud('aprobar');" name="btnAprobar" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"class='TxtCombor'":" class='row5' disabled")%> <%=strNoMostrar %>/>
                                          </td>
                                          <td align="left" class="row5" width="5%">
                                              <input type="button" class="row5 btn_secundario lp-glyphicon lp-glyphicon-search-file-color" value="Observar" onClick="javascript:registraSolicitud('observar');" name="btnObservar" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"class='TxtCombor'":" class='row5' disabled")%> <%=strNoMostrar %> />
                                          </td>
                                          <td align="left" class="row5" width="5%">
                                              <input type="button" class="row5 btn_secundario lp-glyphicon lp-glyphicon-cancel-color" value="Rechazar" onClick="javascript:registraSolicitud('rechazar');" name="btnRechazar" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"class='TxtCombor'":" class='row5' disabled")%> <%=strNoMostrar %> />
                                          </td>
                                          <td align="left" class="row5" width="5%">
                                              <input type="button" class="row5 btn_secundario lp-glyphicon lp-glyphicon-add-color" value="Ampliación" onClick="javascript:limpiaPresupuesto();" name="btnAmpliar" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"class='TxtCombor'":" class='row5' disabled")%> <%=strNoMostrar %> />
                                          </td>
                                          <td align="left" class="row5" width="5%">
                                              <input type="button" class="row5 lq-btn lp-glyphicon lp-glyphicon-export-blanco" value="Enviar" onClick="javascript:registraSolicitud('enviar');" name="btnEnviar" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"class='TxtCombor'":" class='row5' disabled")%> <%=strNoMostrar %>/>
                                          </td>
                                      </tr>    
                                    </table>                                    
                                </fieldset>
                                </div>
                            </td>
                        </tr>               
                        <tr id="dtSeccion9">
                            <td>
                               <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend class="titulo_campos_bold">Auditor&iacute;a M&eacute;dica</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                       <tr id="dtSeccion0">
                                            <td align="left" class="row1" width="12%">Observaciones:&nbsp;</td>
                                            <!--<td align="left" class="row1" width="85%">-->
                                            <td align="left" class="row1" width="75%">
                                                <!--Inicio Código comentado el 20/11/2014 Req. 2014-000204-->
                                                <!--<textarea style="WIDTH:86%" name="txcObserva" rows=3 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" onkeydown="limitaText(this,250);" <%=(usuario.getIntIdRol()==Constante.NROLCME || usuario.getIntIdRol()==Constante.NROLMED?"":"class='row1' readonly" )%>><%=Tool.getString(objSolicitud.getSOBSERVAMED())%></TEXTAREA>-->
                                                <!--Fin Código comentado el 20/11/2014 Req. 2014-000204-->
                                                <!--Inicio Req. 2014-000204 Paradigmasoft GJB-->
                                                <textarea style="WIDTH:100%; height:53px" name="txcObserva" rows=3 cols=14 
                                                onkeypress="javascript:onKeyPressMayuscula.call(this, event);" 
                                                onkeydown="limitaText(this,<%=Constante.getConst("MAX_CARACTERES")%>);" 
                                                <%=(usuario.getIntIdRol()==Constante.NROLCME || usuario.getIntIdRol()==Constante.NROLMED || flagAudiMedi == 1?"":"class='row1 input_text_sed' disabled" )%>><%=Tool.getString(objSolicitud.getSOBSERVAMED())%></TEXTAREA><!--Fin Req. 2014-000204 Paradigmasoft GJB--><!-- INI - REQ 2011-0305 BIT/FMG -->
                                                <BR><BR>
                                                <textarea class="input_text_sed" style="WIDTH:100%; height:53px; display:none" name="txcObservaHis" rows=3 cols=14><%=Tool.getString(objSolicitud.getSOBSERVAMED())%></textarea>
                                                <!-- FIN - REQ 2011-0305 BIT/FMG -->
                                            </td>         
                                            <!--Inicio Req. 2014-000204 Paradigmasoft GJB-->
                                            <td align="left" class="row1" width="12%" style="font-size:66%">M&#225ximo&nbsp;<%=Constante.getConst("MAX_CARACTERES")%>&nbsp;caracteres&nbsp;</td>
                                            <!--Fin Req. 2014-000204 Paradigmasoft GJB-->
                                        </tr>  
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr>    
                        <tr id="dtSeccion3" <%=((objSolicitud.getNIDROLRESP()==Constante.NROLOPE || intFlagValidaClinica == 1) || usuario.getIntIdRol() ==Constante.NROLADM || usuario.getIntIdRol() ==Constante.NROPERFILBRK || intFlgConsul==1)?"style=\"display:none\"":""%>>
                            <td>
                              <div style="margin-rigth:20px;margin-left:10px;">
                                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                                    <legend class="titulo_campos_bold">Derivación</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <tr>
                                            <td align="left" class="row1" width="12%">Comentarios:</td>
                                            <td align="left" class="row1" width="85%" >
                                                <textarea style="WIDTH:86%; height:53px" name="txcComenta" rows=2 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" ><%=Tool.getString(objSolicitud.getObjSolhis().getSOBSERVA())%></TEXTAREA>                
                                            </td>
                                        </tr>    
                                        <tr>
                                            <td align="left" class="row1" width="12%">Enviar a &nbsp;:</td>
                                            <td align="left" class="row1" width="85%">
                                                <select class="TxtCombo lp-select"  style="width:30%"  name="lscRolEnvia">
                                                    <%BeanList lstRol = gestorRol.lstRolJer(usuario.getIntIdRol());
                                                    int intAten = 1;
                                                    if (usuario.getIntIdRol()==Constante.NROLOPE)
                                                          intAten = gestorRol.valHoraAten(usuario.getIntCodOficina());
                                                    //if (intTipoSol!= Constante.NTSCARAUT){
                                                    for(int i = 0; i < lstRol.size(); i++)
                                                    {
                                                        if (Tool.parseInt(lstRol.getBean(i).getString("NIDROL"))!= Constante.NROLOPE)
                                                        {
                                                            if (intAten == 0 && "P2".equals(lstRol.getBean(i).getString("STIPO")))
                                                            {
                                                                  out.print("<option value='" + lstRol.getBean(i).getString("NIDROL") + "'>");
                                                                  out.print(lstRol.getBean(i).getString("SNOMBRE"));
                                                                  out.println("</option>\n"); 
                                                            }
                                                            else
                                                            {
                                                                if (intAten == 1 && !"P2".equals(lstRol.getBean(i).getString("STIPO"))){
                                                                  out.print("<option value='" + lstRol.getBean(i).getString("NIDROL") + "'>");
                                                                  out.print(lstRol.getBean(i).getString("SNOMBRE"));
                                                                  out.println("</option>\n");
                                                                }
                                                            }
                                                        }
                                                    }
                                                    //}
                                                    %>
                                                </select>
                                                <input type="button" class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-export-color" value="Derivar" onClick="javascript:registraSolicitud('derivar');" name="btnDerivar"/>
                                            </td>
                                          </tr>    
                                    </table>
                                </fieldset>
                                </div>
                            </td>
                        </tr> 
                        
                      <tr>
                            <td>
                                <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                    <tr>
                                        <td align="left" class="row5" width="5%">
                                           <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-report-color' value="Histórico de Paciente" onClick="javascript:verHistoricoPaciente();" name="btnHistoricoPaciente"<%=(usuario.getIntIdRol() == Constante.NROPERFILBRK)?"style=\"display:none\"":""%>/>                                      
                                        </td>
                                    </tr>    
                                </table>
                            </td>
                        </tr>                           
                        
                    </table>
                    <iframe name="proceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
                    <iframe name="procdetalle" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
                </form>
            </TD>
        </TR>
    </TABLE>
    
</body>

<script type="text/javascript">

  //Req 2011-0480
  function anularSiniestro()
  {
  
    <%
    if(!objSolicitud.getSNROSINIESTRO().equals(""))
    {
    %>
    var cmbAnul = document.getElementById("lscAnulacion");
    var motivo = cmbAnul.value;
    
    if(motivo != "0")
    {
      <%
        int intStro = -1;
        
          intStro = gestorSolicitud.getStaclaim(Integer.parseInt( objSolicitud.getSNROSINIESTRO()));
        
        if( intStro == Constante.NSTATCLAIMPINF ||
            intStro == Constante.NSTATCLAIMTRAMI )
        {    
      %>  
          document.forms[0].target = "proceso";
          document.forms[0].action = "../servlet/ProcesoSolicitud?proceso=6&pclaim_anul="+<%=objSolicitud.getSNROSINIESTRO()%>+"&pmotivo_anul="+motivo+"&puser_anul="+<%=usercode%>;
          document.forms[0].submit();
      <%
        }else
        {
      %>
        alert("La carta no está hábil para anularse");
      <%
        }
        
      %>
    
    }
    else
    {
      alert("Debe seleccionar un motivo de anulación.");
    }
    <%
    }
    %>
  }
  
  function resultadoAnulacion(result)
  {
    <%
      if(!objSolicitud.getSNROSINIESTRO().equals(""))
      {
      
    %>
    if(result == 1)
    {
      alert("Se anuló satisfactoriamente la carta nro. "+<%=objSolicitud.getSNROSINIESTRO()%>);
      regresarAnul();
    }
    else
    {
      alert("No se pudo anular la carta nro. "+<%=objSolicitud.getSNROSINIESTRO()%>);
    }
    <%
     }
    %>
  }
  function regresarAnul()
  {
    parent.procsolicitud.location.href = "../blancos.html";
    parent.verParentAnul();
  }
  //Fin Req 2011-0480

// Req 2011-0975

  function abrirExclusionesGenerales()
  {
    window.open("../images/ExSCTR.pdf");
  }
  
//Fin Req 2011-0975

  function cleansession(){
  
   <%if (objSolicitud.getNIDSOLICITUD()==0){%> 
    var ret = retValXml("../servlet/SessionClean?proceso=1");
   <%}else{%>
    var ret = retValXml("../servlet/SessionClean?proceso=2");
   <%}%>
  }

  function LoadBody()
  {
    var frm = document.forms[0];
    frm.tcnImpCarta.disabled = true;
    //frm.tcnImpCarta.ReadOnly = true;
    frm.tcnSubTotal.disabled = true;
    frm.tcnTotal.disabled = true;
    frm.tcnIGV.disabled = true;
    
    <%if (objSolicitud.getNIDESTADO()==0){%>
        frm.txcObservaOtros.disabled=true;
    <%}%>
    
    butonRol(<%=usuario.getIntIdRol()%>);
    <%if (intTipoSol == Constante.NTSCARGAR && objSolicitud.getNIDESTADO()==0){%>
        dtProveedor1.style.display = 'none';
    <%}else{          
            if (objSolicitud.getNIDSOLICITUD()==0){%>  
            frm.tcnProveedor.value="<%=bProveedor.getString("2")%>";
            frm.tctProveedor.value="<%=bProveedor.getString("4")%>";
        <%}%>    
    <%}%>
    
    <%if (intTipoSol == Constante.NTSCARAUT){%>
        frm.btnAmpliar.disabled = true;
    <%}%>    
    
    <%if (objSolicitud.getIntMonedaImpoCarta()>0){%>
      frm.lscMoneda.value = <%=objSolicitud.getIntMonedaImpoCarta()%>;
    <%}%>
    
    <%if (objSolicitud.getDblFactorIgv()==1){%>
      frm.chcIGV.disabled=false;
      frm.chcIGV.click(); 
      frm.chcIGV.disabled=true;
    <%}%>
    
   
    listaExclusion();
  }

  function registraSolicitud(acc, transac, idpresup)
  {   
    actualizaPresupuesto();  

    var frm = document.forms[0];
    var msg ="";

    var flgAmpliar = frm.hcnFlagAmpliar.value;
    var flgCartaAmpliada = frm.hcnFlgAmplia.value;
    
    if(acc == 'enviar' && flgAmpliar==1)
    {
        acc = "ampliar";
    }
    else if(acc == 'enviar' && flgCartaAmpliada==1 && flgAmpliar!=2)
    {
        acc = "ampliar";
        flgAmpliar = 1;
        frm.hcnFlagAmpliar.value=1;
    }
    else if(acc == 'guardar') //2015-000604
    {
        acc = "guardar";
    }
    if(transac!= undefined && transac != 0)
    {
        frm.hcnTransac.value=transac; 
        frm.hcnFlgAmplia.value=1;
    }
    
    if(idpresup != undefined && idpresup != 0)
    {
        frm.hcnIdPresupuesto.value=idpresup;  
    }
    
    if(validaForm(acc)==true)
    {  
        if (acc == "anular")  
          msg="Esta seguro de anular la Solicitud";
        if (acc == "aprobar"){  
          msg="Esta seguro de aprobar la Solicitud";
        }
        if (acc == "observar")  
          msg="Esta seguro de observar la Solicitud";
        if (acc == "guardar")  //2015-000604
          msg="Esta seguro de guardar los cambios";
        if (acc == "rechazar"){
          msg="Esta seguro de rechazar la Solicitud";
        }
        if (acc == "enviar")  
          msg="Esta seguro de enviar la Solicitud";
        if (acc == "ampliar")
        {
          var intCodMonedacar = frm.lscMoneda.value;
           
          if(intCodMonedacar==1)          
              msg="Esta seguro de ampliar S/." + frm.tcnImpCarta.value + " monto adicional";
          else
              msg="Esta seguro de ampliar $" +  frm.tcnImpCarta.value + " monto adicional";
        }  
        if (acc == "derivar"){    
          msg="Esta seguro de derivar la Solicitud";
        }
       
        if (acc == "grabar"){    
          msg="Esta seguro de grabar la Solicitud";
        }
       
        var resp = false;
        if(acc == 'enviar' && flgAmpliar==2)
        {
            resp=true;
        }
        else
        {
            resp=confirm(msg); 
        }
        
        if (resp)  
        {  
          if(acc == 'ampliar' && flgAmpliar==1)
              frm.hcnFlagAmpliar.value=2;  
          dtProceso.style.display="";
          dtEnviar.style.display="none";
          document.forms[0].hcnAcc.value = acc;
          var idsol = frm.hcnIdSolicitud.value;
          if (acc == "grabar" || acc == "ampliar" || ((<%=usuario.getIntIdRol()%>==<%=Constante.NROLOPE%> || <%= intFlagValidaClinica %>==1 ) && acc == "enviar")) 
            loadFile();
          else
            GrabaFlujo(acc);
        }
    }
  }
  
  // INI - REQ 2011-0389 BIT/FMG
  function abrirxml(idSolicitud, nroautoriza){
        var frm = document.forms[0];
        document.forms[0].target="_blank";
        document.forms[0].action="../servlet/ProcesoXML?pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
        document.forms[0].submit();
  }
  // FIN - REQ 2011-0389 BIT/FMG
  
  function GrabaSolicitud(file){
          var frm = document.forms[0];
          var acc = frm.hcnAcc.value;
          frm.hcnArchivo1.value = file;
          frm.tcnImpCarta.disabled=false;
          frm.txcObservaOtros.disabled=false;
          frm.tcnSubTotal.disabled=false;
          var cacalili = 0;
          cacalili =<%=intCacalili%>; //Apple
          if (frm.chcIGV.checked == false)
              frm.hcnFactorIGV.value = '1';
          document.forms[0].target="proceso";
          document.forms[0].action="../servlet/ProcesoSolicitud?proceso=2&psacc=" + acc + "&strcacalili=" + cacalili;
          document.forms[0].submit(); 
  }

  function GrabaFlujo(acc){
      document.forms[0].target="proceso";          
      document.forms[0].action="../servlet/ProcesoSolicitud?proceso=4&psacc=" + acc;
      document.forms[0].submit(); 
  }
  
  function loadForm(idsol,idhist,siniestro,acc,param)
  {
    var frm = document.forms[0];
    var flgAmpliar = frm.hcnFlagAmpliar.value;
    
    var hcnacc = document.forms[0].hcnAcc.value;
      if (acc == "anular")  
        msg="La solicitud Nº " + siniestro + " ha sido anulada";
      if (acc == "aprobar")  
        msg="La solicitud Nº " + siniestro + " ha sido aprobada";
      if (acc == "observar")  
        msg="La solicitud Nº " + siniestro + " ha sido observada";
      if (acc == "rechazar")  
        msg="La solicitud Nº " + siniestro + " ha sido rechazada";
      if (acc == "derivar")  
        msg="La solicitud Nº " + siniestro + " ha sido derivada";
      if (acc == "enviar")  
        msg="La solicitud Nº " + siniestro + " ha sido enviada";
      if (acc == "ampliar" || (acc == "enviar" && flgAmpliar==2))  
        msg="La solicitud Nº " + siniestro + " ha sido ampliada";
      if (acc == "grabar")  
        msg="La solicitud Nº " + siniestro + " ha sido registrada";
      if (acc == "guardar")  
        msg="La solicitud Nº " + siniestro + " ha sido guardada";
    
    if (acc=='grabar'){
           
           var flgSnroSol;
           if (document.forms[0].hcnIdSolicitud.value == '')
           {
            flgSnroSol = 1;
           }
           else
           {
            flgSnroSol = 0;
           }
           var arr = param.split("|")
           document.forms[0].hcnIdSolicitud.value=idsol;
           document.forms[0].tcnAutoriza.value=siniestro;  
           document.forms[0].tcdFecEmi.value= arr[0];
           //document.forms[0].tcdOcurrencia.value= arr[1];
           alert(msg);
           
           dtProceso.style.display="none";
           DeActive(true);
           dtEnviar.style.display="";

            //parent.window.location.href = "../flujo/Bandeja.jsp";
            regresarAnul();

    }else{
       alert(msg);       
       // INI - REQ 2011-0389 BIT/FMG
       if (acc=='enviar' && <%=usuario.getIntXMLActivo()%> == 1){
        abrirxml(idsol, siniestro);
       }
       // FIN - REQ 2011-0389 BIT/FMG
       
       /*INICIO 2012-0078*/
       if (document.forms[0].hcnExcedeMontoMaximo.value == "true"){
        var tipsol = document.forms[0].hcnTipoSol.value;
        var pnselcover = document.forms[0].hcnSelCover.value;
        var policy = document.forms[0].hcnPoliza.value;
        var certif = document.forms[0].hcnCertificado.value;
        var client = document.forms[0].hcnCliente.value;
        var strClinica = document.forms[0].hcnClinica.value;                
        
        document.location.href = "../flujo/Solicitud.jsp?pstiposol=" + tipsol
               + "&pnselcover=" + pnselcover + "&tcnPoliza=" + policy + "&tcnCertif="
               + certif + "&tctCodCliente=" + client + "&strClinica=" + strClinica + "&strSegundoSiniestro=1";   
               
 
        
      if ((acc == "guardar"))
      {
        
                document.location.href = "../cartarechazo/BandejaRechazo.jsp";   
                
      }
      
      }
      else 
        regresarAnul();
    }
    /*FIN 2012-0078*/   
       
  }
  
  function loadFile(){
       fichero.frmUpload.action="../servlet/ProcesoSolicitud?proceso=1";
       fichero.frmUpload.submit();
  }
  
  function verAlerta(coderror){
    if (coderror == -2)
      alert("El número de solicitud no existe. Consulte con el Administrador");
    else
    if (coderror == -3)
      alert("La solicitud ha sido anulado anteriormente. Consulte con el Administrador");
    else
    if (coderror == -4)
      alert("La solicitud ha sido rechazado anteriormente. Consulte con el Administrador");
    else
      alert("La solicitud no ha sido procesada. Consulte con el Administrador");

    
    dtProceso.style.display="none";
    dtEnviar.style.display="";
    
  }
  
  function buscarProveedor(){
    
    if (document.forms[0].tctProveedor.value==""){
        alert("Ingrese el nombre del Prveedor a buscar");
        document.forms[0].tctProveedor.focus();
        return;
    }else{
        dtProveedor.style.display="";
        frProveedor.document.forms[0].action="../general/Lista.jsp?nameframe=frProveedor&pstipo=prov&psdesc=" + document.forms[0].tctProveedor.value;
        frProveedor.document.forms[0].submit();
        
    }
  }

  function buscarDiagnostico(){
    
    if (document.forms[0].tctDiagnos.value==""){
        alert("Ingrese el nombre del Diagnóstico a buscar");
        document.forms[0].tctDiagnos.focus();
        return;
    }else{
        dtDiagnostico.style.display="";
        frDiagnostico.document.forms[0].action="../general/Lista.jsp?nameframe=frDiagnostico&pstipo=diag&psdesc=" + document.forms[0].tctDiagnos.value;
        frDiagnostico.document.forms[0].submit();
        
    }
  }
  
    function buscarDiagnosticoMedico(){
    
    if (document.forms[0].tctDiagnosM.value==""){
        alert("Ingrese el nombre del Diagnóstico a buscar");
        document.forms[0].tctDiagnosM.focus();
        return;
    }else{
        dtDiagnosticoMedico.style.display="";
        frDiagnosticoMedico.document.forms[0].action="../general/Lista.jsp?nameframe=frDiagnosticoMedico&pstipo=diag&psdesc=" + document.forms[0].tctDiagnosM.value;
        frDiagnosticoMedico.document.forms[0].submit();
        
    }
  }
  
  function buscarLimpiarDiagnostico(obj){
    limpiaAsociado(obj);
   // buscarCodDiagnostico();
  }
  
  function buscarCodDiagnostico()
  {
       if(frm.hcnFlagError.value<=1)
       {
          if(document.forms[0].tcnDiagnos.value!="")
          {
              if(verificaExclusion()==0)
              {
                  var ret = retValXml("../servlet/ProcesoValida?pntipoval=3&pndiagnos=" + document.forms[0].tcnDiagnos.value);
                  
                  if(ret=="")
                  {
                      if(frm.hcnFlagError.value==1)
                          frm.hcnFlagError.value = 2;
                      alert("Código de diagnóstico incorrecto");
                      document.forms[0].tcnDiagnos.focus();
                  }
                  else
                  {
                      document.forms[0].tctDiagnos.value = ret;
                  }
              }
              else
              {
                alert("El diagnostico elegido esta excluido");
                document.forms[0].tctDiagnos.value = "";
                document.forms[0].tcnDiagnos.value = "";
                document.forms[0].tcnDiagnos.focus();
              }
          }
       }
       else
       {
            frm.hcnFlagError.value = 0;
       }
                   
  }
  
  /*function formatNomMedico()
  {
  
    var posi = document.forms[0].tctNombreMedico.value.indexOf(",");
    
    if(posi < 0)
    {
      alert("Ingresar coma en el Nombre Medico");
      document.forms[0].tctNombreMedico.focus();
    }
        
  }*/
  
  function buscarCodMedico()
  {
       if(frm.hcnFlagError.value<=1)
       {
          if(document.forms[0].tctCMPMedico.value!="")
          {
              if(verificaMedico()>0)
              {
                  ret = retValXml("../servlet/ProcesoValida?pntipoval=16&pnMedico=" + document.forms[0].tctCMPMedico.value);
                  
                  if(ret=="")
                  {
                      if(frm.hcnFlagError.value==1)
                          frm.hcnFlagError.value = 2;
                      alert("Codigo de Médico Incorrecto");
                      document.forms[0].tctCMPMedico.focus();
                  }
                  else
                  {
                      document.forms[0].tctNombreMedico.value = ret;
                  }
              }
              else
              {
                document.forms[0].tctNombreMedico.focus();
              }
          }
       }
       else
       {
            frm.hcnFlagError.value = 0;
       }            
                   
  }
  
   function buscarCodDiagnosticoMedico()
  {
  var frm = document.forms[0];
       if(frm.hcnFlagError.value<=1)
       {
          if(document.forms[0].tcnDiagnosM.value!="")
          {
              if(verificaExclusion()==0)
              {
                  ret = retValXml("../servlet/ProcesoValida?pntipoval=3&pndiagnos=" + document.forms[0].tcnDiagnosM.value);
                  
                  if(ret=="")
                  {
                      if(frm.hcnFlagError.value==1)
                          frm.hcnFlagError.value = 2;
                      alert("Código de diagnóstico incorrecto");
                      document.forms[0].tcnDiagnosM.focus();
                  }
                  else
                  {
                      document.forms[0].tctDiagnosM.value = ret;
                  }
              }
              else
              {
                alert("El diagnostico elegido esta excluido");
                document.forms[0].tctDiagnosM.value = "";
                document.forms[0].tcnDiagnosM.value = "";
                document.forms[0].tcnDiagnosM.focus();
              }
          }
       }
       else
       {
            frm.hcnFlagError.value = 0;
       }
  
  }

  function onKey(obj, e)
  {    
      var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
      var frm = document.forms[0];
      
      if(key==13)
      {
          if (obj.name == "tctProveedor")
              buscarProveedor();
          if (obj.name == "tctDiagnos")
              buscarDiagnostico();
          if (obj.name == "tcnDiagnos")
          {
              if (!valida('tcnDiagnos','t'))      
                  return;
              frm.hcnFlagError.value=1; 
              buscarCodDiagnostico();
          }
          /*if (obj.name == "tctDiagnosM")
              buscarDiagnosticoMedico();*/
//          if (obj.name == "tcnDiagnosM" && staRechazo==1)
          if (obj.name == "tcnDiagnosM")
          {
              if (!valida('tcnDiagnosM','t'))      
                  return;
              frm.hcnFlagError.value=1; 
              buscarCodDiagnosticoMedico();
          }
      }
      else
      {
          if (obj.name == "tctDiagnos")
              document.forms[0].tcnDiagnos.value = "";
          if (obj.name == "tcnDiagnos")
              document.forms[0].tctDiagnos.value = "";
          if (obj.name == "tctDiagnosM")
              document.forms[0].tcnDiagnosM.value = "";
          if (obj.name == "tcnDiagnosM")
              document.forms[0].tctDiagnosM.value = "";
      }
  }  
  
  function limpiaAsociado(obj)
  {
       if (obj.name == "tctDiagnos")
              document.forms[0].tcnDiagnos.value = "";
       if (obj.name == "tcnDiagnos")
              document.forms[0].tctDiagnos.value = "";
       if (obj.name == "tctDiagnosM")
              document.forms[0].tcnDiagnosM.value = "";
       if (obj.name == "tcnDiagnosM")
              document.forms[0].tctDiagnosM.value = "";              
       if (obj.name == "tcnMontoOtros")
       {
            if (document.forms[0].tcnMontoOtros.value == "")
            {
                document.forms[0].txcObservaOtros.value = "";
                document.forms[0].txcObservaOtros.disabled=true;
            }
            else
            {
                document.forms[0].txcObservaOtros.disabled=false;
                document.forms[0].tcnMontoOtros.focus();
                document.forms[0].txcObservaOtros.focus();
            }
       }        
  }
   
  function limitaText(field, maxlimit) 
  {
      if (field.value.length > maxlimit) 
          field.value = field.value.substring(0, maxlimit);
  }

  function selObj(obj){
  var frm = document.forms[0];
    if (obj.name == "lscProv"){
        dtProveedor.style.display="none";
        i=obj.selectedIndex;
        frm.tcnProveedor.value=obj.options[i].value;
        frm.tctProveedor.value=obj.options[i].text;  
    }
    if (obj.name == "lscDiag"){
        dtDiagnostico.style.display="none";
        i=obj.selectedIndex;
        frm.tcnDiagnos.value=obj.options[i].value;
        frm.tctDiagnos.value=obj.options[i].text;  
    }

  }

  function DeActive(val)
  {
     frm=document.forms[0];
     //frm.btnGrabar.disabled= val;
     //frm.btnAnular.disabled= val;
     frm.btnImprimir.disabled= val;
     frm.btnAprobar.disabled= val;
     frm.btnObservar.disabled= val;
     frm.btnDerivar.disabled= val;
     frm.btnEnviar.disabled= val;
     frm.btnAmpliar.disabled = val;
     frm.btnRechazar.disabled = val;
     frm.btnHistoricoPaciente.disabled = val;     
  }
  
  function imprimir(numero, user){
    
    window.open('../flujo/CartaPDF.jsp?pnautoriza=' + numero + '&pnuseraprob=' + user);
  }
  
  function imprimirCR(numero, user){
    
    window.open('../cartarechazo/CartaRechazoPDF.jsp?pnautoriza=' + numero + '&pnuseraprob=' + user);
  } 
  
  function editarCR(numero, user){
    
    window.open('../cartarechazo/CartaRechazoWord.jsp?pnautoriza=' + numero + '&pnuseraprob=' + user);
  }   

  function regresar()
  {
    
    parent.procsolicitud.location.href = "../blancos.html";
    parent.verParent();
  }
  function butonRol(rol)
  {
    var frm=document.forms[0];

      if (rol == <%= Constante.NROLOPE%> || <%= intFlagValidaClinica%> == 1)
      {
        <%if (objSolicitud.getNIDESTADO()!= Constante.NESTRECH){%>
            dtSeccion1.style.display = 'none';
        <%}%>
        dtSeccion3.style.display = 'none';
        <%if (objSolicitud.getNIDESTADO()== Constante.NESTAPR){%>
              DeActive(true);
              frm.btnAmpliar.disabled = false;
        <%}else{
          if (objSolicitud.getNIDSOLICITUD()==0){%>  
              DeActive(true);
              //frm.btnGrabar.disabled= false;
              frm.btnEnviar.disabled= false;
          <%}else{
             if (objSolicitud.getNIDESTADO()== Constante.NESTREG){%>
                DeActive(true);                
                //frm.btnAnular.disabled= false;
                frm.btnEnviar.disabled= false;
                <%if (objSolicitud.getNFLGAMPLIACION()==0){%>             
                    //frm.btnGrabar.disabled= false;
                <%}%>
             <%}else{%>
             <%if (objSolicitud.getNIDESTADO()== Constante.NESTOBS){%>
                DeActive(true);                
                frm.btnEnviar.disabled= false;
                //frm.btnGrabar.disabled= false;
             <%}else{%>
             <%if ((objSolicitud.getNIDESTADO()== Constante.NESTRECH || 
                    objSolicitud.getNIDESTADO()== Constante.NESTANU ) && 
                 objSolicitud.getNFLGAMPLIACION()==1){%>
                DeActive(true);
             <%}else{%>
              DeActive(true);
             <%}%>
             <%}%>
             <%}%>
          <%}%>
        <%}%>
      }        
      
     if (rol != <%= Constante.NROLOPE%> && <%=intFlagValidaClinica%> != 1 && rol!=<%=Constante.NROLASAD%>)
     {
         if (rol == <%= Constante.NROLENF%>)
         {
            dtSeccion3.style.display = 'none';
            <%if (objSolicitud.getNIDESTADO()!= Constante.NESTRECH){%>
                dtSeccion1.style.display = 'none';
            <%}%>
         } 
        <%if (objSolicitud.getNIDESTADO()== Constante.NESTAPR){%>
            if (rol == <%=Constante.NROLADM%> || rol == <%=Constante.NROLENF%> || rol == <%=Constante.NROLBRK%>)
            {
                DeActive(true);
            }
        <%}else
        {
            // REQ 2011-0305 BIT/FMG
            if (objSolicitud.getNIDESTADO()==Constante.NESTPEN || 
                objSolicitud.getNIDESTADO()==Constante.NESTLEVOBS ||
                objSolicitud.getNIDESTADO()==Constante.NESTAMP ||
                objSolicitud.getNIDESTADO()==Constante.NESTDER) {%>  
                DeActive(true);
                frm.btnDerivar.disabled= false;      
                
                if(rol!= <%=Constante.NROLBRK%>)
                {
                    if  (rol!= <%=Constante.NROLENF%> && <%=objSolicitud.getNFLGAMPLIACION()%>==0)  
                    {
                        frm.btnRechazar.disabled = false;
                    }
                    
                    if  (rol== <%=Constante.NROLENF%>)
                    {  
                        if (<%=objSolicitud.getNIDROLRESP()%>==<%=Constante.NROLMED%>)
                        {
                            frm.btnAprobar.disabled= false;
                            frm.btnHistoricoPaciente.disabled= false;
                            
                        }
                    }
                    else
                    {
                        frm.btnAprobar.disabled= false;
                        frm.btnHistoricoPaciente.disabled= false;
                        frm.btnObservar.disabled= false;
                    }
                } 
            <%}else{%>
                dtEnviar.style.display='none';
                DeActive(true);
            <%}%>
        <%}%>
    }

    if ( (rol == <%=Constante.NROLADM%> || 
          rol == <%=Constante.NROLENF%> || 
          rol == <%=Constante.NROLOPE%> || 
          rol == <%=Constante.NROLBRK%> || 
          rol == <%=Constante.NROPERFILBRK%> ||
            1 == <%=flagImpresion%>)&& 
         (<%=objSolicitud.getObjSolhis().getNESTADO()%> == <%=Constante.NESTAPR%> || 
          <%=objSolicitud.getObjSolhis().getNESTADO()%> == <%=Constante.NESTAVG%>) //DLCH 05072016
          ) 
        frm.btnImprimir.disabled= false;
  
    
    <%if (intFlgConsul==1){%>
        //frm.btnGrabar.disabled= true;
        //frm.btnAnular.disabled= true;
        frm.btnAprobar.disabled= true;
        frm.btnObservar.disabled= true;
        frm.btnRechazar.disabled= true;
        frm.btnAmpliar.disabled= true;
        frm.btnEnviar.disabled= true;        
        frm.btnHistoricoPaciente.disabled= true;
    <%}%>
  
  }              
  
  
  function listaExclusion(){
      var frmp = document.forms[0];
      var poliza = <%=objCliente.getIntPoliza()%>;
      var certif = <%=objCliente.getIntCertificado()%>;
      var codCliente = '<%=objCliente.getStrCodigo()%>';
      var ramo = <%=objCliente.getIntRamo()%>;
  
      document.forms[0].target="procdetalle";
      document.forms[0].action="../servlet/ProcesoAtencion?proceso=5&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente + "&tctRamo=" + ramo;
      document.forms[0].submit(); 
  }

  function verExclusion(){
      xx=750;
      yy=400;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x
      var psnombre = document.forms[0].tctAsegurado.value;
      window.open("../consulta/Exclusion.jsp?psnombre=" + psnombre,"exclusion",parametros);    
  }  
  
  function verHistoricoPaciente(){
      xx=1100;
      yy=600;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x
      var psnombre = document.forms[0].tctAsegurado.value;
      
      window.open("../consulta/HistoricoPaciente.jsp?psnombre=" + psnombre + "&FlagPrimero='1'&sFechai="+'<%=inpdate_cli%>',"historicoPaciente",parametros);
  }  
    
  function verArchivosAdjuntos(){
      xx=550;
      yy=350;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x      
      var pnIdSolicitud = document.forms[0].hcnIdSolicitud.value;
      window.open("Ficheros.jsp?IdSolicitud=" + pnIdSolicitud,"adjuntos",parametros);
  }         
  
  

function openArchivo(archivo)
{
  momentoActual = new Date();
  hora = momentoActual.getHours();
  minuto = momentoActual.getMinutes();
  segundo = momentoActual.getSeconds();
  window.open("../.." + archivo + "?" + hora + minuto + segundo);
//  window.open("../..");
}


function onKeyPressMonto()
{

 if( (event.keyCode>=48 && event.keyCode<=57) || (event.keyCode<=57) )
 {
    
 }
 else
    event.returnValue=false; 

}

function onKeyPressNumero()
{

 //if( (event.keyCode>=48 && event.keyCode<=57) || (event.keyCode<=57) )
 if( (event.keyCode>=48 && event.keyCode<=57))
 {
    
 }
 else
    event.returnValue=false; 

}

function checkDecimals(value, field) {
  <%if (blnEditar) {%>
      decallowed = 2;  // how many decimals are allowed?
      if (isNaN(value)) {
        alert("Eso no parece ser un número válido. Prueba de nuevo.");
        field.value="";
        field.focus();
      }
      else {
          if (value.indexOf('.') == -1) value += ".";
          dectext = value.substring(value.indexOf('.')+1, value.length);
        
          if (dectext.length > decallowed)
          {
            alert ("Por favor, entra un número con " + decallowed + " números decimales.");
            field.value="";
            field.focus();
          }
          
          actualizaPresupuesto();
      }
  <%}%>
}

function validarPresupuesto() {
  var frm = document.forms[0];
  /*Inicio 2012-0078*/
  var montoMaximoCoaseguro = frm.hcnMontoMaximoCoaseguro.value;
  var regCoaseguroCero = frm.hcnRegistroCoaseguroCero.value;
  var excedeMontoMaximo = frm.hcnExcedeMontoMaximo.value;
  var montoIncIGV = 0;
  var igv = 0;
  var montoCompararCoaseguro = 0;
  /*Fin 2012-0078*/
  monto = 0;
  
  if (frm.tcnMontoCuarto.value != "")
      monto = monto + parseFloat(frm.tcnMontoCuarto.value);
  if (frm.tcnMontoSalaOpera.value != "")
      monto = monto + parseFloat(frm.tcnMontoSalaOpera.value);
  if (frm.tcnMontoSalaRecup.value != "")
    monto = monto + parseFloat(frm.tcnMontoSalaRecup.value);
  if (frm.tcnMontoCirujano.value != "")
    monto = monto + parseFloat(frm.tcnMontoCirujano.value);
  if (frm.tcnMontoPrimerAsist.value != "")
    monto = monto + parseFloat(frm.tcnMontoPrimerAsist.value);
  if (frm.tcnMontoSegundoAsis.value != "")
    monto = monto + parseFloat(frm.tcnMontoSegundoAsis.value);
  if (frm.tcnMontoAnestesia.value != "")
    monto = monto + parseFloat(frm.tcnMontoAnestesia.value);
  if (frm.tcnMontoFarmaciaPiso.value != "")
    monto = monto + parseFloat(frm.tcnMontoFarmaciaPiso.value);
  if (frm.tcnMontoFarmaciaSala.value != "")
    monto = monto + parseFloat(frm.tcnMontoFarmaciaSala.value);
  if (frm.tcnMontoUsoEquip.value != "")
    monto = monto + parseFloat(frm.tcnMontoUsoEquip.value);
  if (frm.tcnMontoConsumoOxig.value != "")
    monto = monto + parseFloat(frm.tcnMontoConsumoOxig.value);
  if (frm.tcnMontoCardiologia.value != "")
    monto = monto + parseFloat(frm.tcnMontoCardiologia.value);
  if (frm.tcnMontoLaboratorio.value != "")
    monto = monto + parseFloat(frm.tcnMontoLaboratorio.value);
  if (frm.tcnMontoRadiologia.value != "")
    monto = monto + parseFloat(frm.tcnMontoRadiologia.value);
  if (frm.tcnMontoEcografia.value != "")
    monto = monto + parseFloat(frm.tcnMontoEcografia.value);
  if (frm.tcnMontoEquiposEsp.value != "")
    monto = monto + parseFloat(frm.tcnMontoEquiposEsp.value);
  if (frm.tcnMontoTomografia.value != "")
    monto = monto + parseFloat(frm.tcnMontoTomografia.value);
  if (frm.tcnMontoResonancia.value != "")
    monto = monto + parseFloat(frm.tcnMontoResonancia.value);
  if (frm.tcnMontoOtros.value != "")
    monto = monto + parseFloat(frm.tcnMontoOtros.value);
  
   /*AF64*/
    
    if (frm.tcnMontoOsteosintesis.value != "")
    monto = monto + parseFloat(frm.tcnMontoOsteosintesis.value);
    
    if (frm.tcnMontoProtesis.value != "")
    monto = monto + parseFloat(frm.tcnMontoProtesis.value);
  
    /*FIN AF64*/
  
  
  if(monto ==0)
    return 3;
 
 /*INICIO 2012-0078*/
 
 monto = redondear(monto,2);
  
  if (frm.chcIGV.checked == true)
  {
      igv = parseFloat('<%=dblIgv%>');
      var montoIncIGV =  monto * igv;
      montoIncIGV = redondear(montoIncIGV,2);
      montoCompararCoaseguro = montoIncIGV;
  }
  else
  {
      montoCompararCoaseguro = monto;
  }
  /*FIN 2012-0078*/
  
  if( (frm.tcnMontoOtros.value!= "") && (frm.txcObservaOtros.value == ""))
    return 2;
    
  /*INICIO 2012-0078*/
  if (regCoaseguroCero == "false" && montoMaximoCoaseguro > 0)
  {
    if (excedeMontoMaximo == "false")
    {
     /* 2012-0078 */
      if (montoCompararCoaseguro > montoMaximoCoaseguro && document.forms[0].hcnblnSecondClaim.value == "false")
      {
        document.forms[0].hcnExcedeMontoMaximo.value = "true";
        document.forms[0].hcnMontoInicial.value = montoCompararCoaseguro;
        return 4;
      }
      else return 0;
    }
    else
    {
      /* 2012-0078 */
      if (montoCompararCoaseguro != montoMaximoCoaseguro && document.forms[0].hcnblnSecondClaim.value == "false")
      {
        return 5;
      }
      else return 0;
    }
  }
  else return 0;
  /*FIN 2012-0078*/
}

function actualizaPresupuesto() {
  var frm = document.forms[0];
  monto = 0;
  
  if (frm.tcnMontoCuarto.value != "")
      monto = monto + parseFloat(frm.tcnMontoCuarto.value);
  if (frm.tcnMontoSalaOpera.value != "")
      monto = monto + parseFloat(frm.tcnMontoSalaOpera.value);
  if (frm.tcnMontoSalaRecup.value != "")
    monto = monto + parseFloat(frm.tcnMontoSalaRecup.value);
  if (frm.tcnMontoCirujano.value != "")
    monto = monto + parseFloat(frm.tcnMontoCirujano.value);
  if (frm.tcnMontoPrimerAsist.value != "")
    monto = monto + parseFloat(frm.tcnMontoPrimerAsist.value);
  if (frm.tcnMontoSegundoAsis.value != "")
    monto = monto + parseFloat(frm.tcnMontoSegundoAsis.value);
  if (frm.tcnMontoAnestesia.value != "")
    monto = monto + parseFloat(frm.tcnMontoAnestesia.value);
  if (frm.tcnMontoFarmaciaPiso.value != "")
    monto = monto + parseFloat(frm.tcnMontoFarmaciaPiso.value);
  if (frm.tcnMontoFarmaciaSala.value != "")
    monto = monto + parseFloat(frm.tcnMontoFarmaciaSala.value);
  if (frm.tcnMontoUsoEquip.value != "")
    monto = monto + parseFloat(frm.tcnMontoUsoEquip.value);
  if (frm.tcnMontoConsumoOxig.value != "")
    monto = monto + parseFloat(frm.tcnMontoConsumoOxig.value);
  if (frm.tcnMontoCardiologia.value != "")
    monto = monto + parseFloat(frm.tcnMontoCardiologia.value);
  if (frm.tcnMontoLaboratorio.value != "")
    monto = monto + parseFloat(frm.tcnMontoLaboratorio.value);
  if (frm.tcnMontoRadiologia.value != "")
    monto = monto + parseFloat(frm.tcnMontoRadiologia.value);
  if (frm.tcnMontoEcografia.value != "")
    monto = monto + parseFloat(frm.tcnMontoEcografia.value);
  if (frm.tcnMontoEquiposEsp.value != "")
    monto = monto + parseFloat(frm.tcnMontoEquiposEsp.value);
  if (frm.tcnMontoTomografia.value != "")
    monto = monto + parseFloat(frm.tcnMontoTomografia.value);
  if (frm.tcnMontoResonancia.value != "")
    monto = monto + parseFloat(frm.tcnMontoResonancia.value);
  if (frm.tcnMontoOtros.value != "")
    monto = monto + parseFloat(frm.tcnMontoOtros.value);
  
    /*AF64*/
    
    if (frm.tcnMontoOsteosintesis.value != "")
    monto = monto + parseFloat(frm.tcnMontoOsteosintesis.value);
    
    if (frm.tcnMontoProtesis.value != "")
    monto = monto + parseFloat(frm.tcnMontoProtesis.value);
  
    /*FIN AF64*/
  
  monto = redondear(monto,2);
  
  if (frm.chcIGV.checked == true)
  {
      igv = parseFloat('<%=dblIgv%>');
      var montoIncIGV =  monto * igv;
      montoIncIGV = redondear(montoIncIGV,2);
      var montoIGV = redondear(montoIncIGV - monto,2);
      frm.tcnIGV.value = montoIGV;
      frm.tcnImpCarta.value = montoIncIGV;
      frm.tcnTotal.value = montoIncIGV;
  }
  else
  {
     frm.tcnIGV.value ='';
     frm.tcnImpCarta.value = monto;
     frm.tcnTotal.value = monto;
  }
  frm.tcnSubTotal.value = monto;
  //RQ2015-000750 Inicio
  frm.hcnSubTotal.value = monto;
  //RQ2015-000750 Fin

}

function limpiaPresupuesto() {
  var frm = document.forms[0];
  
   /*2012-0078*/
  if(frm.hcnSegundoSiniestro.value == null || frm.hcnSegundoSiniestro.value == "" ||  frm.hcnSegundoSiniestro.value == 0)
  {
   /*2012-0078*/  
    if(frm.hcnFlagAtencion.value==1)
    {
        frm.tcnMontoCuarto.value = "";
        frm.tcnMontoSalaOpera.value = "";
        frm.tcnMontoSalaRecup.value = "";
        frm.tcnMontoCirujano.value = "";
        frm.tcnMontoPrimerAsist.value = "";
        frm.tcnMontoSegundoAsis.value = "";
        frm.tcnMontoAnestesia.value = "";
        frm.tcnMontoFarmaciaPiso.value = "";
        frm.tcnMontoFarmaciaSala.value = "";
        frm.tcnMontoUsoEquip.value = "";
        frm.tcnMontoConsumoOxig.value = "";
        frm.tcnMontoCardiologia.value = "";
        frm.tcnMontoLaboratorio.value = "";
        frm.tcnMontoRadiologia.value = "";
        frm.tcnMontoEcografia.value = "";
        frm.tcnMontoEquiposEsp.value = "";
        frm.tcnMontoTomografia.value = "";
        frm.tcnMontoResonancia.value = "";
        frm.tcnMontoOtros.value = "";
        frm.tcnImpCarta.value = "";
        frm.txcObservaOtros.value = "";
        
        /* AF64 */
        frm.tcnMontoOsteosintesis.value = "";
        frm.tcnMontoProtesis.value = "";
        /* AF64 */
        
        frm.tcnIGV.value ="";
        frm.tcnImpCarta.value = "";
        frm.tcnTotal.value = "";
        frm.tcnSubTotal.value = "";
        
        frm.hcnFlagAmpliar.value=1;
        frm.btnEnviar.disabled=false;
        alert("Indique el monto a ampliar");
        frm.tcnMontoOtros.focus();
    }
    else
    {
        alert("Cobertura suspendida, comunicarse con el 211-0211");
    }
  }else
  {
      /*2012-0078*/
      alert("El siniestro tiene el monto límite para el cobro de coaseguro, deberá ampliar el siniestro número " + frm.hcnSegundoSiniestro.value + ".");  
      /*2012-0078*/
  }
}
 
function verificaExclusion()
{
   var ret = -1;
   var frm = document.forms[0];
   if (frm.tcnDiagnos.value != "")
   {  
      ret = retValXml("../servlet/ProcesoValida?pntipoval=5&pnCodDiag=" + frm.tcnDiagnos.value);  
      
   }
   return ret;   
}

function verificaMedico()
{
   var ret = 0;
   var frm = document.forms[0];        
   if (frm.tctCMPMedico.value != "")
   {
      var ret = retValXml("../servlet/ProcesoValida?pntipoval=17&pnCodMed=" + frm.tctCMPMedico.value);  
   }
   return ret;   
}

function validaForm(acc)
{
   
    if (acc == "grabar" || (<%=usuario.getIntIdRol()%>==<%=Constante.NROLOPE%> && acc == "enviar") || acc=="ampliar") 
    {//inicio if
      resultado = validarPresupuesto(); 
    
      if (resultado==2)
      {
        alert("Ingrese descripción de otros gastos");
        return false;
      }
      
       if (resultado==3)
      {
        alert("Debe ingresar el detalle del presupuesto");
        return false;
      }
      
      /*INICIO 2012-0078*/
      if (resultado==4)
      {
        alert("Se ha excedido el monto máximo de carta que es: "+
                frm.hcnMonedaSimbolo.value +" "+ 
                frm.hcnMontoMaximoCoaseguro.value +" El excedente es de: "+
                frm.hcnMonedaSimbolo.value +
                redondear((frm.tcnTotal.value - frm.hcnMontoMaximoCoaseguro.value),2));
        return false;
      }
      
       if (resultado==5)
      {
        alert("El monto de carta no coincide con el límite establecido de: "+
                 frm.hcnMonedaSimbolo.value +" "+ 
                 frm.hcnMontoMaximoCoaseguro.value);
        return false;
      }
      /*FIN 2012-0078*/
      
      
      
      msg="Esta seguro de grabar la Solicitud";
     if (acc == "ampliar")
      {
        <% if (objSolicitud.getStrFechaEmi().equals(Tool.getDate("dd/MM/yyyy")) && 
                   objSolicitud.getNFLGAMPLIACION()==1 && 
                   (objSolicitud.getNIDESTADO()!= Constante.NESTRECH && 
                   objSolicitud.getNIDESTADO()!= Constante.NESTANU && objSolicitud.getNIDESTADO()!= Constante.NESTOBS ))
            {%>
                alert("Esta solicitando una ampliación el mismo día");
                return false;
            <%}%>
      }      

      if (<%=intTipoSol%>==<%=Constante.NTSCARAUT%> && 
         (frm.tcnProveedor.value == "0" || frm.tcnProveedor.value == "" 
         || frm.tctProveedor.value == ""))
      {  
        alert("Seleccione el Proveedor");
        frm.tctProveedor.focus();
        return false;
      }

      if (frm.tcnDiagnos.value == "0" || frm.tcnDiagnos.value == "" ||
          frm.tctDiagnos.value == "")
      {  
        alert("Seleccione el diágnostico");
        frm.tctDiagnos.focus();
        return false;
      }
      //RQ2015-000604
      /*if (frm.tcnDiagnosM.value == "0" || frm.tcnDiagnosM.value == "" ||
          frm.tctDiagnosM.value == "")
      {  
        alert("Seleccione el diágnostico Medico");
        frm.tctDiagnosM.focus();
        return false;
      }*/
     
      if (frm.tctCMPMedico.value == "")
      {  
        alert("Ingrese el CMP del médico tratante");
        frm.tctCMPMedico.focus();
        return false;
      }
      
       if (frm.tctNombreMedico.value == "")
      {  
        alert("Ingrese el nombre del médico tratante");
        frm.tctNombreMedico.focus();
        return false;
      }
      
      
       if (frm.tcnTiempoEnfermedad.value == "")
      {  
        alert("Ingrese el tiempo de enfermedad del paciente");
        frm.tcnTiempoEnfermedad.focus();
        return false;
      }   
      else
      {
        if (frm.tcnTiempoEnfermedad.value < 0)
        {
          alert("El tiempo de enfermedad no puede ser negativo.");
          frm.tcnTiempoEnfermedad.focus();
          return false;
        }
      }
      
      if (!valida('tcnImpCarta','nc'))      
            return false;
      else
      {
         //BIT CAMY RQ 2013-000361 23/09/2013
          if(<%=objSolicitud.getNIDESTADO()%>==6)
          {
            return true;
          }
        
          //Validacion para el proyecto apple, capital asegurado
          var cacalili = <%=intCacalili%>;

          if(cacalili == 2)
          {
            var a = parseFloat(frm.tcnImpCarta.value);
            var b = parseFloat(<%=objCobertura.getStrBeneficioMax()%>) - parseFloat(<%=objCobertura.getStrBeneficioCons()%>);
            var tc = parseFloat(frm.tcnCambio.value);
            intCodMonedapol = <%=objCliente.getIntCodMoneda()%>;
            intCodMonedacar = frm.lscMoneda.value;
            
            if (intCodMonedapol != intCodMonedacar)
            {
                if(intCodMonedacar==1)
                  a = a / tc;
                else
                  a = a * tc;
            }
    
            if (a > b)
            {
              
              if(intCodMonedapol==1)          
                  msg="El importe de la carta supera el valor maximo a facturar. El saldo disponible a facturar es S/." + b;
              else
                  msg="El importe de la carta supera el valor maximo a facturar. El saldo disponible a facturar es $" + b;
              
              alert(msg);
              return false;
            }            
          }                    
      }

      if (frm.tcdFechaLim.value == "")
      { 
        alert("Ingrese la fecha límite");
        frm.tcdFechaLim.focus();
        return false;
      }
      
      if (!validaFecha('tcdFechaLim')){
            return false;
      }
      //BIT flopez RQ2013-000400, sea agrega validacion sblockade <> '3'  
      var retAux = retValXml("../servlet/ProcesoValida?pntipoval=15&pncertif="+document.forms[0].hcnCertificado.value+"&pnpoliza="+document.forms[0].hcnPoliza.value);
       if(retAux == "1")//1=>bloqueo 3, 0=> no bloqueo 3
       {
          alert("El asegurado seleccionado está bloqueado por no ser un cliente no vigente.");
          return false;
       }
      //FIN flopez RQ2013-000400, sea agrega validacion sblockade <> '3'

    }//fin if
    
    if (acc == "aprobar"){  
      var ret = retValXml("../servlet/ProcesoValida?pntipoval=2&pnidrol=<%=usuario.getIntIdRol()%>&pnidmoneda=" + frm.lscMoneda.value);
      var a = parseFloat(frm.tcnImpCarta.value);      
      var b = parseFloat(ret);      
      if (a > b)
      {
       alert("El importe de la carta supera el valor maximo permitido para Ud.");
       return false;
      }
    }
    
    if (acc == "rechazar"){
      if (!valida('lscMotivo','s'))
            return false;
    }
    
    //RQ2015-000604
    
    
 <%if(staRechazo==1){%>     
    if (acc == "rechazar"){
      if (!valida('lscMotivoSBS','s') || !valida('lscSubMotivoSBS','s') ) 
            return false;
    }              
    if (acc == "rechazar"){
        if (frm.tcnDiagnosM.value == "0" || frm.tcnDiagnosM.value == "" ||
          frm.tctDiagnosM.value == "")
        {  
          alert("Seleccione el diágnostico Médico");
          frm.tcnDiagnosM.focus();
          return false;
        }
        if (frm.tctProcRecha.value == "")
        {  
          alert("Ingrese el Proc/Hospi/Otros a Rechazar");          
          return false;
        }
     }     
   <%}%> 
   
   
     if (acc == "derivar"){    
      if (!valida('lscRolEnvia','s'))
            return false;
    }
    //RQ2015-000750 Inicio
    if (acc == "enviar" || acc == "aprobar" || acc=="ampliar"){
      if (frm.hcnValidaEmail.value == "1"){
          if (frm.tctemail.value == "")
            alert("Ingrese el correo electrónico del paciente.");
            return false;
          if (!validarEmail('tctemail'))
            return false;
      }
      if (frm.hcnValidaEmail.value == "0"){
          if (frm.tctemail.value != ""){
            if (!validarEmail('tctemail'))
              return false;
          }
      }
    }
    //RQ2015-000750 Fin
    
     if (acc == "guardar"){
      if (<%=objRechazo.getNIdStaCartR()%>==2 ){
        if (frm.tctNumRecha.value == "")
        {  
          alert("Ingrese el numero de carta de rechazo"); 
          frm.tctNumRecha.focus();
          return false;
        }
        }
     }
    return true;

}


  //Req 2019-626 [EMV] - INI
  function abrirObservacionesAsegurado(textObservacion){
      var url = "ObservacionAsegurado.jsp?observacion="+textObservacion;
      popupWindow = window.open(url,'popUpWindow','height=240,width=500,left=100,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no, status=yes');
  }
  //Req 2019-626 [EMV] - FIN

</script>

</html>