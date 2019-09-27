<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.Cliente"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.util.ArrayList"%>
<%  
/*
Instanciando la clase GestorPolClinic , donde se accede alos datos yahirRivas 29FEB2012 11:36am
*/
    GestorPolClinic gestorPolClinic = new GestorPolClinic();
   
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:04pm
    GestorUsuario gestorUsuario = new GestorUsuario();
   
    /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:31am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();
          
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }
    int intIdUsuario = usuario.getIntIdUsuario();
    String strNroautoriza = Tool.getString(request.getParameter("pnautoriza"));
    int intTipoSol = Tool.parseInt(request.getParameter("pstiposol"));
    int intIdSol = Tool.parseInt(request.getParameter("pnidsol"));
    int intFlgConsul = Tool.parseInt(request.getParameter("pnflgconsul"));
    int intSelCover = Tool.parseInt(request.getParameter("pnselcover"));
    
    int intIdPresupuesto=0;
    String strContinuidad = "";
    Cliente objCliente = new Cliente();
    
    synchronized(session)
    {
      if (session.getAttribute("DatoCliente2")!=null)
      {
        objCliente = (Cliente)session.getAttribute("DatoCliente2");
        // AVM : variable para la continuidad es el campo continuity
        // con Continuidad = 'S'
        // sin Continuidad = 'N'
        strContinuidad = (objCliente.getStrContinuidadInx().substring(0).equals("S")?"CONTINUIDAD":"");
      }
    }
    int intFlgAtencion = 1;
    if (objCliente.getIntEstadoDeuda()==2)
        intFlgAtencion = 0;

    Cobertura objCobertura = null;
    synchronized(session)
    {
      if (session.getAttribute("CoberturaSel2")!=null)
        objCobertura = (Cobertura)session.getAttribute("CoberturaSel2");
    }    
      
    String strTipoCambio = "";
    Solicitud objSolicitud = new Solicitud();
    Presupuesto objPresupuesto = null;
    
    synchronized(session)
    {
      if (session.getAttribute("SolicitudSel2")!=null)
      {
          objSolicitud = (Solicitud)session.getAttribute("SolicitudSel2");
          intTipoSol = objSolicitud.getNIDTIPOSOLICITUD();
          strTipoCambio = String.valueOf(objSolicitud.getDblTipoCambio());
          objPresupuesto = objSolicitud.getObjPresupuesto();
      }else
      {
          strTipoCambio = Tool.getTipoCambio();
      }
    }
    String [] arrMontos =  new String[19];
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
    int intRamo = objCliente.getIntRamo();
    Bean bOficina = gestorSolicitud.getOficPol(objCliente.getIntPoliza(), intRamo);
    Bean bProveedor = null;
    if(objSolicitud.getNIDSOLICITUD()==0)
    {
        bProveedor = Tabla.getProvedorIfxServ(usuario.getStrWebServer());
    }
    
    boolean blnEditar = false;

    /*if (objSolicitud.getNIDESTADO()==Constante.NESTREG || 
        (objSolicitud.getNIDESTADO()==Constante.NESTAPR && objSolicitud.getNIDTIPOSOLICITUD()==Constante.NTSCARGAR &&
         usuario.getIntIdRol()==Constante.NROLOPE) ||
        objSolicitud.getNIDESTADO()==Constante.NESTOBS || 
        (objSolicitud.getNIDESTADO()==Constante.NESTRECH && objSolicitud.getNFLGAMPLIACION()==1)|| 
        objSolicitud.getNIDSOLICITUD()==0) 
        blnEditar = true;*/
        
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
            
   /* if (intFlgConsul==1) 
        blnEditar=false;*/
    
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

    gestorSolicitud.getTransactionInfo(objSolicitud);
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
      
                    <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>
                                <fieldset class="row5 content_resumen">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%">
                                    
                                        <tr>
                                            <td align=left class="row2" colspan=7 width="90%">
                                                <%=strTitulo%>
                                            </td>
                                            <td align="right">
                                                <a class="texto_general_bold" href="javascript:ventanaEmergente('../consultasolicitud/Historico2.jsp');">  
                                                Hist&oacute;rico
                                                </a> 
                                            </td>
                                             <td class="row2" width="10%"><a class="link_acciones" href="javascript:window.close();">Cerrar [X] </a></td> 
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
                                                <input class="row1 input_text_sed" type="text" readonly  style="width:91%" value="<%=Tabla.reaTableIfx(10,intRamo).getString("2")%>" size="40">
                                                <input type="hidden" name="hcnRamo" value="<%=intRamo%>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="12%">Poliza. :&nbsp;</td>
                                            <td align=left class="row1" colspan=3 width="35%">
                                                <input class="row1 input_text_sed" name= "tcnPoliza" type="text" size="15" readonly value="<%=objCliente.getIntPoliza()%>"/>
                                                <input class="row1 input_text_sed" type="text" style="width:67%" readonly value="<%=objCliente.getStrContratante()%>">
                                            </td>
                                           
                                            <td align=left class="row1" colspan=2 width="12%">Certificado. :&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td align=left class="row1" width="19%">
                                                <input class="row1 input_text_sed" style="width:40%" name= "tcnCertif" type="text" readonly  size="12" value="<%=objCliente.getIntCertificado()%>"/>            
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moneda :&nbsp;
                                            </td>
                                            <td align=left class="row1">
                                                <input class="row1 input_text_sed" type="text" readonly value="<%=objCliente.getStrMoneda()%>">
                                            </td>  
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="12%">Producto. :&nbsp;</td>
                                            <td align=left class="row1" colspan=7 width="35%">
                                                <input class="row1 input_text_sed" type="text" size="25" readonly value="<%=objPoliza.getStrDesProduct()%>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Titular&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=3 width="35%">
                                                <input class="row1 input_text_sed" name="tctTitular" type="text" readonly style="width:93%" value="<%=objCliente.getStrNombreTitular()%>">
                                            </td>
                                          
                                            <td align="left" class="row1" colspan=2 width="10%">Fecha Ingreso&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=2>
                                                <input class="row1 input_text_sed" type="text" size="12" readonly value="<%=objCliente.getStrFecIngreso()%>">
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <fieldset class="row5 content_resumen">
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
                                                <input class="row1 input_text_sed" name = "tctCobertura" type="text" readonly  size="34" value="<%=objCobertura.getStrNomCobertura()%>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Fecha Nac.&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan = "3" width="36%">
                                                 <input class="row1 input_text_sed" name = "tctCobertura" type="text" readonly  size="12" value="<%=objCliente.getStrFecNac()%>">
                                            </td>
                                            <td align="left" class="row1" colspan="4" style="color:#FF3300">
                                              <B><%=strContinuidad%></B>
                                            </td>
                                        </tr>
                                        <tr id="dtProveedor1">
                                            <td align=left class="row1" width="12%" >Proveedor :&nbsp;</td>
                                            <td align=left colspan=7 class="row1">
                                                <input name = "tcnProveedor" type="text" size=15 value="<%=objSolicitud.getIntCodProveedor()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                                <input name = "tctProveedor" type="text" size=43 onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" value="<%=objSolicitud.getStrProveedor()%>" maxlength="40" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
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
                                                <input name = "tcnDiagnos" type="text" size=15 onchange="javascript:limpiaAsociado(this);" onblur="javascript:buscarCodDiagnostico();"  onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" maxlength="5"  value="<%=objSolicitud.getIntCodDiagnos()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                                <input name = "tctDiagnos" type="text" size=43 onchange="javascript:limpiaAsociado(this);" onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" maxlength="40" value="<%=objSolicitud.getStrDiagnos()%>" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>  
                                            <td align=left class="row1" width="10%">M&eacute;dico Tratante :&nbsp;</td>
                                            <td align=left class="row1" colspan="3" width="19%">
                                                <input size=12  name = "tctCMPMedico" type="text" value="<%=objSolicitud.getSCMPMEDICO()%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" maxlength="8" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%> >&nbsp;     
                                                <input size=46  name = "tctNombreMedico" type="text" value="<%=objSolicitud.getSNOMBMEDICO()%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" maxlength="75" <%=(objSolicitud.getNIDTIPOSOLICITUD()==0?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%> >
                                            </td>
                                        </tr>
                                        <tr id="dtDiagnostico" style="display:none">
                                            <td align="left" class="row1" width="12%" >&nbsp;</td>
                                            <td align=left class="row1" colspan=7>
                                                <iframe name="frDiagnostico" src="../general/Lista.jsp" width="40%" height="55" border=0 frameBorder=0 scrolling="no"></iframe>          
                                            </td>    
                                        </tr>                              
                                        <tr>
                                            <td align="left" class="row1" width="12%" >Max. Facturar&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" name="tcnMaxFact" type="text" size="16" readonly style="text-align:right" value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrBeneficioMax()) - Tool.parseDouble(objCobertura.getStrBeneficioCons()),2)%>" maxlength="10">
                                            </td>
                                            <td align="left" class="row1" width="10%">Cap. Aseg&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" name="tcnCapAseg" type="text" size="16" readonly style="text-align:right" value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrBeneficioMax()),2)%>">
                                            </td>
                                            
                                            <td align="left" class="row1"  width="10%">Tipo de Cambio&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan="3" >
                                                <input class="row1 input_text_sed" name="tcnCambio" type="text" size="12" readonly value="<%=strTipoCambio%>">
                                            </td>          
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>    
                        </tr>    
                        <tr>
                            <td>
                                <fieldset class="row5 content_resumen">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <tr>
                                            <td align="left" class="row1" width="12%">Deducible&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" type="text" name="tcnDedu" style="width:25%" readonly value="<%=objCobertura.getStrDeducible()%>">% 
                                            </td>
                                            <td align="left" class="row1" width="10%">&nbsp;Monto :</td>
                                            <td align="left" class="row1" width="13%">
                                                <input class="row1 input_text_sed" type="text" name="tcnDedu" size="16" readonly value="<%=Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2)%>"/>
                                            </td>
                                            <td align="left" class="row1" width="10%">Por Cuarto&nbsp;:&nbsp;</td>
                                            
                                            <td align="left" class="row1" width="12%">
                                                <b><input class="row1 input_text_sed" type="text" name="tcnQDedu" style="width:50%" readonly value="<%=objCobertura.getStrCantidad()%>"/></b> dia(s)
                                            </td>
                                            
                                            <td align="left" class="row1" width="7%">Coas. a cargo aseg.&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="24%">
                                                <input class="row1 input_text_sed" type="text" name="tcnGasto" size="8" readonly value="<%=objCobertura.getStrCoaseguro()%>"> %
                                            </td>
                                        </tr>    
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
                                                <input class="row1 input_text_sed" maxlength="12" type="text" name="tcdFechaLim" onKeyPress="javascript:onKeyPressFecha(this);" size="12" readonly value="<%=(objSolicitud.getNIDSOLICITUD()==0?Tool.addDate(10,"dd/MM/yyyy"):objSolicitud.getStrFechaLimite())%>">
                                                <!--<img  ALT="Calendario" SRC="../images/calendar.gif"  BORDER="0"  onClick="OpenCalendar('tcdFechaLim','../')" style="cursor:hand;">-->
                                            </td>
                                            <td align="left" class="row1" colspan="2">
                                                <!--<input type="button" value="Exclusiones" onClick="javascript:verExclusion();" <%=(objCliente.getIntIndExcl() == 1?"class='TxtCombor'":" class='row5' disabled")%>>-->
                                                &nbsp;
                                            </td>
                                        </tr>       
                                        <tr id="dtSeccion1">
                                            <td align="left" class="row1" width="12%" >Motivo Rechazo&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" colspan=7>
                                                <%if (objSolicitud.getNIDESTADO()==Constante.NESTPEN  && usuario.getIntIdRol()!=Constante.NROLOPE){%>              
                                                    <select name="lscMotivo"  style="width:35%" onchange="javascript:selObj(this);" <%=(objSolicitud.getNIDESTADO()==Constante.NESTPEN  && usuario.getIntIdRol()!=Constante.NROLOPE?"class='TxtCombo lp-select'":"class='row1 lp-select' disabled")%>>
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
                            </td>
                        </tr>
                        <!--  Aca va el presupuesto  -->
                        <tr id="dtSeccionPresupuesto">
                            <td>
                                <fieldset class="row5 content_resumen">
                                    <legend class="titulo_campos_bold">Presupuesto</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls"> 
                                         <tr>
                                            <td align=left class="row1" width="50%" colspan="2">CLINICA</td>
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
                                            <td align=left class="row1" width="50%" colspan="2">HONORARIOS MEDICOS</td>
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
                                            <td align=left class="row1" width="50%" colspan="2">FARMACIA</td>
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
                                            <td align=left class="row1" width="10%" colspan="2">&nbsp;</td>  
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">Farmacia Sala Operaciones:&nbsp;</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoFarmaciaSala" size="16" type="text" value="<%=arrMontos[8]%>" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>
                                            <td align=left class="row1" width="8%">SUB TOTAL:&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnSubTotal" size="16"  value="<%=dblTotalPresupuesto%>" type="text" <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align=left class="row1" width="10%">OTROS</td>
                                            <td align=left class="row1" width="30%">&nbsp;</td>
                                            <td align=left class="row1" width="8%">
                                                IGV:&nbsp;
                                                <INPUT type="checkbox" class="TxtCombo" name="chcIGV" onclick="actualizaPresupuesto();" checked="checked" <%=(objSolicitud.getNIDSOLICITUD()>0?"DISABLED":"")%>>
                                            </td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnIGV" size="16"  value="<%=dblMontoIgv%>"  type="text" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>                                       
                                        </tr> 
                                        <tr>
                                            <td align=left class="row1" width="10%">Otros Consumos:</td>
                                            <td align=left class="row1" width="30%">
                                                <input name="tcnMontoOtros" size="16" type="text" value="<%=arrMontos[18]%>" onchange="javascript:limpiaAsociado(this);" onkeypress="onKeyPressMonto('this');" onblur="checkDecimals(this.value, this)" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>   
                                            <td align=left class="row1" width="8%">TOTAL:&nbsp;</td>
                                            <td align=left class="row1" width="35%">
                                                <input name="tcnTotal" size="16"   value="<%=dblMontoTotal%>"  type="text" <%=(blnEditar?"class='row5 input_text_sed'":"readonly class='row1 input_text_sed'")%>>
                                            </td>    
                                        </tr> 
                                        <tr>
                                            <td align=left class="row1" width="10%">Detalle Otros Consumos:&nbsp;</td>
                                            <td align=left class="row1" colspan="3">
                                                <textarea name="txcObservaOtros" style="width:64%;height:53px" 
                                                onkeydown="limitaText(this,250);" rows=3 cols=14  
                                                onkeypress="javascript:onKeyPressMayuscula.call(this, event);"  
                                                <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>><%=Tool.getString(strObsOtros)%></TEXTAREA>                
                                            </td>
                                        </tr>   
                                    </table>
                                </fieldset>
                            </td>
                        </tr>  
                        <!--  Observación Clínica  -->
                        <tr id="dtSeccion10">
                            <td>
                                <fieldset class="row5 content_resumen">
                                    <legend class="titulo_campos_bold">Recomendación</legend>  
                                    <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                                        <tr>
                                            <td align="left" class="row1"  width="12%">Observaci&oacute;n Clinica&nbsp;:&nbsp;</td>
                                            <td align="left" class="row1" width="85%">
                                                <textarea style="WIDTH:86%;height:53px" 
                                                onkeydown="limitaText(this,398);" name="txcObservaClinica" rows=3 cols=14 
                                                onkeypress="javascript:onKeyPressMayuscula.call(this, event);" 
                                                <%=(blnEditar?"class='row5 input_text_sed'":"disabled class='row1 input_text_sed'")%>><%=Tool.getString(objSolicitud.getSOBSERVACLI())%></TEXTAREA>
                                            </td>
                                        </tr>    
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <!--<tr>
                            <td>
                                <fieldset class="row5">
                                    <legend></legend>  
                                    <table cellSpacing="1"  border=0 width="100%">
                                        <%if (!"".equals(objSolicitud.getObjSolhis().getSARCHIVO1())){%>
                                            <tr>          
                                                <td align="left" class="row5" >Archivo Adjunto&nbsp;:
                                                    <a href="javascript:openArchivo('<%=Constante.pathFileUpload + objSolicitud.getObjSolhis().getSARCHIVO1()%>');">Abrir</a>
                                                </td>
                                            </tr>    
                                        <%}%>
                                        <tr id="dtUpload"  <%=(blnEditar?"":"style=\"display:none\"")%>>
                                            <td class="row1">
                                                <iframe name="fichero" src="UploadFichero.jsp" width="100%" height="30" border=0 frameBorder=0 scrolling="no"></iframe>                      
                                            </td>
                                        </tr>    
                                    </table>
                                </fieldset>
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <table cellSpacing="1"  border=0 width="100%">
                                    <tr id="dtProceso" style="display:none">
                                        <td  class="row5" colspan=3 align="center"><b>Procesando</b><br>
                                            <img  name="btnProceso" ALT="Procesando" SRC="../images/descarga.gif"  BORDER="0">
                                        </td>
                                    </tr>                        
                                    <tr id=dtEnviar>
                                        <td align="left" class="row5" width="5%">
                                           <input type="button" class='row5' value="Imprimir" disabled="disabled" onClick="javascript:imprimir('<%=objSolicitud.getSNROSINIESTRO()%>','<%=objSolicitud.getObjSolhis().getStrUSUAPROB()%>');" name="btnImprimir"/> 
                                        </td>
                            
                                        <td align="left" class="row5" width="5%">
                                           <input type="button" class="row5" value="Anular" onClick="javascript:registraSolicitud('anular');" name="btnAnular"/>
                                        </td>
                            
                                        <td align="left" class="row5" width="5%" colspan="2">
                                            &nbsp;
                                                 HD 57926
                                                <input type="button" class="row5" value="Grabar" onClick="javascript:registraSolicitud('grabar');" name="btnGrabar"/>
                                            
                                        </td>
                                        <td align="left" class="row5" width="20%">&nbsp;</td>
                                        <td align="left" class="row5" width="5%">
                                            <input type="button" class="row5" value="Aprobar" onClick="javascript:registraSolicitud('aprobar');" name="btnAprobar"/>
                                        </td>
                                        <td align="left" class="row5" width="5%">
                                            <input type="button" class="row5" value="Observar" onClick="javascript:registraSolicitud('observar');" name="btnObservar"/>
                                        </td>
                                        <td align="left" class="row5" width="5%">
                                            <input type="button" class="row5" value="Rechazar" onClick="javascript:registraSolicitud('rechazar');" name="btnRechazar"/>
                                        </td>
                                        <td align="left" class="row5" width="5%">
                                            <input type="button" class="row5" value="Ampliación" onClick="javascript:limpiaPresupuesto();" name="btnAmpliar"/>
                                        </td>
                                        <td align="left" class="row5" width="5%">
                                            <input type="button" class="row5" value="Enviar" onClick="javascript:registraSolicitud('enviar');" name="btnEnviar"/>
                                        </td>
                                    </tr>    
                                </table>
                            </td>
                        </tr> 
                        -->
                        <tr id="dtSeccion9">
                            <td>
                                <fieldset class="row5 content_resumen">
                                    <legend class="titulo_campos_bold">Auditor&iacute;a M&eacute;dica</legend>  
                                    <table cellSpacing="1" border=0 width="100%" class="form-table-controls">
                                       <tr id="dtSeccion0">
                                            <td align="left" class="row1" width="12%">Observaci&oacute;nes:&nbsp;</td>
                                            <td align="left" class="row1" width="85%">
                                                <textarea style="WIDTH:86%; height:53px" 
                                                name="txcObserva" rows=3 cols=14 onkeypress="javascript:onKeyPressMayuscula.call(this, event);" 
                                                onkeydown="limitaText(this,250);" 
                                                <%=(usuario.getIntIdRol()==Constante.NROLCME || usuario.getIntIdRol()==Constante.NROLMED?"":"class='row1 input_text_sed' disabled" )%>><%=Tool.getString(objSolicitud.getSOBSERVAMED())%></TEXTAREA>
                                            </td>         
                                        </tr>  
                                    </table>
                                </fieldset>
                            </td>
                        </tr> 
                        
                        <tr>
                          <td>
                            <input type="button" class='row5 btn_secundario lp-glyphicon lp-glyphicon-search-file-color' value="Ver Archivos Adjuntos" onClick="javascript:verArchivosAdjuntos();" name="btnArchivosAdjuntos"/>
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

//Req 2011-0975
  function verArchivosAdjuntos(){
      xx=550;
      yy=350;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x      
      var pnIdSolicitud = document.forms[0].hcnIdSolicitud.value;
      window.open("Ficheros.jsp?IdSolicitud=" + pnIdSolicitud,"adjuntos2",parametros);
  }
  function ventanaEmergente(URL)
  {
    window.open(URL+'?nidSolicitud='+document.forms[0].hcnIdSolicitud.value,'ventanahistorico2', 'height=430, top=100, left=200, width=1000, toolbar=no,directories=no, menubar=no scrollbars=no, resizable=yes');
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
        //COMENTADO POR ERROR DE JAVASCRIPT 
        //frm.btnAmpliar.disabled = true;
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
          if (acc == "grabar" || acc == "ampliar" || (<%=usuario.getIntIdRol()%>==<%=Constante.NROLOPE%> && acc == "enviar")) 
            loadFile();
          else
            GrabaFlujo(acc);
        }
    }
  }
  
  function GrabaSolicitud(file){
          var frm = document.forms[0];
          var acc = frm.hcnAcc.value;
          frm.hcnArchivo1.value = file;
          frm.tcnImpCarta.disabled=false;
          frm.txcObservaOtros.disabled=false;
          frm.tcnSubTotal.disabled=false;
          
          if (frm.chcIGV.checked == false)
              frm.hcnFactorIGV.value = '1';
          document.forms[0].target="proceso";
          document.forms[0].action="../servlet/ProcesoSolicitud?proceso=2&psacc=" + acc;
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
    
    if (acc=='grabar'){
           var arr = param.split("|")
           document.forms[0].hcnIdSolicitud.value=idsol;
           document.forms[0].tcnAutoriza.value=siniestro;  
           document.forms[0].tcdFecEmi.value= arr[0];
           //document.forms[0].tcdOcurrencia.value= arr[1];
           alert(msg);
           
           dtProceso.style.display="none";
           DeActive(true);
           dtEnviar.style.display="";
           parent.window.location.href = "../flujo/Bandeja.jsp";
    }else{
       alert(msg);
       parent.window.location.href = "../flujo/Bandeja.jsp";       
    }
       
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
  
  function buscarCodDiagnostico()
  {
       if(frm.hcnFlagError.value<=1)
       {
          if(document.forms[0].tcnDiagnos.value!="")
          {
              if(verificaExclusion()==0)
              {
                  ret = retValXml("../servlet/ProcesoValida?pntipoval=3&pndiagnos=" + document.forms[0].tcnDiagnos.value);
                  
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

  function onKey(obj)
  {    
      var frm = document.forms[0];
      if(event.keyCode==13)
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
      }
      else
      {
          if (obj.name == "tctDiagnos")
              document.forms[0].tcnDiagnos.value = "";
          if (obj.name == "tcnDiagnos")
              document.forms[0].tctDiagnos.value = "";
      }
  }  
  
  function limpiaAsociado(obj)
  {
       if (obj.name == "tctDiagnos")
              document.forms[0].tcnDiagnos.value = "";
       if (obj.name == "tcnDiagnos")
              document.forms[0].tctDiagnos.value = "";
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
     //frm.btnImprimir.disabled= val;
     frm.btnAprobar.disabled= val;
     frm.btnObservar.disabled= val;
     frm.btnDerivar.disabled= val;
     frm.btnEnviar.disabled= val;
     //COMENTADO POR ERROR DE JAVASCRIPT 
     //frm.btnAmpliar.disabled = val;
     frm.btnRechazar.disabled = val;
     
  }
  
  function imprimir(numero, user){
    
    window.open('../flujo/CartaPDF.jsp?pnautoriza=' + numero + '&pnuseraprob=' + user);
  } 

  function regresar()
  {
    parent.procsolicitud.location.href = "../blancos.html";
    parent.verParent();
  }
  
  function butonRol(rol)
  {
    var frm=document.forms[0];

      if (rol == <%= Constante.NROLOPE%>)
      {
        <%if (objSolicitud.getNIDESTADO()!= Constante.NESTRECH){%>
            dtSeccion1.style.display = 'none';
        <%}%>
        dtSeccion3.style.display = 'none';
        <%if (objSolicitud.getNIDESTADO()== Constante.NESTAPR){%>
              DeActive(true);
              //COMENTADO POR ERROR DE JAVASCRIPT 
              //frm.btnAmpliar.disabled = false;
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

     if (rol != <%= Constante.NROLOPE%> && rol!=<%=Constante.NROLASAD%>)
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
            if (objSolicitud.getNIDESTADO()==Constante.NESTPEN) {%>  
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
                        }
                    }
                    else
                    {
                        frm.btnAprobar.disabled= false;
                        frm.btnObservar.disabled= false;
                    }
                } 
            <%}else{%>
                dtEnviar.style.display='none';
                DeActive(true);
            <%}%>
        <%}%>
    }

    if ( (rol == <%=Constante.NROLADM%> || rol == <%=Constante.NROLENF%> || rol == <%=Constante.NROLOPE%> || rol == <%=Constante.NROLBRK%>)  && 
          <%=objSolicitud.getObjSolhis().getNESTADO()%>  == <%=Constante.NESTAPR%>) 
        frm.btnImprimir.disabled= false;
  
    
    <%if (intFlgConsul==1){%>
        //frm.btnGrabar.disabled= true;
        //frm.btnAnular.disabled= true;
        frm.btnAprobar.disabled= true;
        frm.btnObservar.disabled= true;
        frm.btnRechazar.disabled= true;
        //COMENTADO POR ERROR DE JAVASCRIPT 
        //frm.btnAmpliar.disabled= true;
        frm.btnEnviar.disabled= true;
    <%}%>
  }                
      
  function listaExclusion(){
      var frmp = document.forms[0];
      var poliza = <%=objCliente.getIntPoliza()%>;
      var certif = <%=objCliente.getIntCertificado()%>;
      var codCliente = '<%=objCliente.getStrCodigo()%>';
  
      document.forms[0].target="procdetalle";
      document.forms[0].action="../servlet/ProcesoAtencion?proceso=5&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente;
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
      xx=950;
      yy=600;
      x=(window.screen.availWidth-xx)/2;
      y=(window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x
      window.open("../consulta/HistoricoPaciente.jsp","exclusion",parametros);
  }  
  
  

function openArchivo(archivo)
{
  momentoActual = new Date();
  hora = momentoActual.getHours();
  minuto = momentoActual.getMinutes();
  segundo = momentoActual.getSeconds();

  window.open("../.." + archivo + "?" + hora + minuto + segundo);
}


function onKeyPressMonto()
{

 if( (event.keyCode>=48 && event.keyCode<=57) || (event.keyCode<=57) )
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
  
  if(monto ==0)
    return 3;
 
  if( (frm.tcnMontoOtros.value!= "") && (frm.txcObservaOtros.value == ""))
    return 2;
  else return 0;
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
  

}

function limpiaPresupuesto() {
  var frm = document.forms[0];
  
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
}
 
function verificaExclusion()
{
   var ret = -1;
   var frm = document.forms[0];
   if (frm.tcnDiagnos.value != "")
   {
      var ret = retValXml("../servlet/ProcesoValida?pntipoval=5&pnCodDiag=" + frm.tcnDiagnos.value);  
   }
   return ret;   
}

function validaForm(acc)
{
    if (acc == "grabar" || (<%=usuario.getIntIdRol()%>==<%=Constante.NROLOPE%> && acc == "enviar") || acc=="ampliar") 
    {
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
      
      if (!valida('tcnImpCarta','nc'))      
            return false;
      else
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

      if (frm.tcdFechaLim.value == "")
      { 
        alert("Ingrese la fecha límite");
        frm.tcdFechaLim.focus();
        return false;
      }
      
      if (!validaFecha('tcdFechaLim'))
            return false;

    }
    
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
    
     if (acc == "derivar"){    
      if (!valida('lscRolEnvia','s'))
            return false;
    }

    return true;

}

</script>

</html>
<%
System.out.println("2");
%>