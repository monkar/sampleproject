<%response.setContentType("application/msword");%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorSolicitud"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.Cliente"%>
<%@ page import="com.clinica.beans.Cobertura"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%  /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:38am*/    
       Atencion atencion = new Atencion();
     /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:25am*/ 
      GestorSolicitud gestorSolicitud = new GestorSolicitud();
     /*Instanciando,para acceder a los Datos  yahirRivas 05MAR2012 11:25am*/ 
      GestorFirma gestorFirma =  new GestorFirma();
      
       AvisoRechazo objRechazo = new AvisoRechazo(); 
      Date fecha=new Date();
      GestorCliente gestorCliente = new GestorCliente();
                 
    int intTipoSol=0;
    String strContinuidad = "";
    Cliente objCliente = null;
    Cobertura objCobertura = null;
    synchronized(session)
    {
      if (session.getAttribute("DatoCliente")!=null)
      {
        objCliente = (Cliente)session.getAttribute("DatoCliente");
        //session.removeAttribute("DatoCliente");
          // AVM : variable para la continuidad es el campo continuity
          // con Continuidad = 'S'
          // sin Continuidad = 'N'
          strContinuidad = (objCliente.getStrContinuidadInx().substring(0).equals("S")?"SI":"NO");
      }
    
      
      if (session.getAttribute("CoberturaSel")!=null)
        objCobertura = (Cobertura)session.getAttribute("CoberturaSel");
        //session.removeAttribute("CoberturaSel");
    }  
    String strNroautoriza = Tool.getString(request.getParameter("pnautoriza"));
    String strUserAprob = Tool.getString(request.getParameter("pnuseraprob"));
    
    objRechazo = gestorSolicitud.getDatosCartaRechazo(Tool.parseInt(strNroautoriza));            
    GestorPolClinic gestorPolClinic = new GestorPolClinic(); 
    Bean objAten2 = atencion.getSiniestroLog(strNroautoriza);
    int codRamo = Tool.parseInt(objAten2.getString("1")) ; // Apple
    Poliza objPoliza = gestorPolClinic.getPoliza(codRamo,objCliente.getIntPoliza(),0);
    Poliza objPolizaDate = gestorPolClinic.getDatePoli(objCliente.getIntPoliza(),objCliente.getIntCertificado());
    //GestorAlertaRechazo gestorFirma = new GestorAlertaRechazo();
    
    String strWebServer = "";
    Bean objAten = atencion.getSiniestroLog(strNroautoriza);
    strWebServer = objAten.getString("6");
    //String strNomClinica = Clinica.getClinica(strWebServer).getString("2");
    String strCodEnf = "";
    
    Solicitud objSolicitud = new Solicitud();
    synchronized(session)
    {
      if (session.getAttribute("SolicitudSel")!=null){
        objSolicitud = (Solicitud)session.getAttribute("SolicitudSel");
        intTipoSol = objSolicitud.getNIDTIPOSOLICITUD();
      }
    }

    Presupuesto objPresupuesto = null;
    objPresupuesto = objSolicitud.getObjPresupuesto();
    
    double dblTotalPresupuesto = 0;
    if(objPresupuesto!=null)
    {
       ArrayList detalle = objPresupuesto.getArrDetalle();
       for(int intIndice=0; intIndice<detalle.size(); intIndice++)
       {
          DetallePresupuesto objDetalle = ((DetallePresupuesto)detalle.get(intIndice));
          if(objDetalle.getDblMontoConcepto()>0)
             dblTotalPresupuesto += objDetalle.getDblMontoConcepto();
       }
    }
    dblTotalPresupuesto = Tool.redondear(dblTotalPresupuesto,2);
    
    double dblMontoIgv = Tool.redondear(dblTotalPresupuesto * (objSolicitud.getDblFactorIgv() - 1),2);
    double dblMontoTotal = Tool.redondear(dblTotalPresupuesto + dblMontoIgv,2);
        
    double dblAmount = 0;
    if (objSolicitud.getNFLGAMPLIACION()==1)
        dblAmount =  gestorSolicitud.getImporteAmpIfx(strNroautoriza, objSolicitud.getObjSolhis().getNTRANSAC());
    
        
    double dblMontoCarta = 0;
    if(objSolicitud.getDblImporteCarta() - dblTotalPresupuesto > 0.5 && objSolicitud.getDblFactorIgv() == 1.19)
    {
        dblMontoCarta = objSolicitud.getDblImporteCarta();
    }
    else
    {
        dblMontoCarta = objSolicitud.getDblImporteCarta() * objSolicitud.getDblFactorIgv();
        dblAmount = dblAmount * objSolicitud.getDblFactorIgv();
    }

  String strFecha="";
  String strDia = "";
  String strMes = "";
  String strAnio = "";
  float yBarCode = 0f; /* P 2012 - 0048 Codigo Barras */
  float xBarCode = 0f; /* P 2012 - 0048 Codigo Barras */
  
  //if  (objSolicitud.getNIDESTADO()== Constante.NESTAPR){
  //  strFecha = objSolicitud.getObjSolhis().getDFECHAREG();
  //  strDia = strFecha.substring(0,2);
  //  strMes = Tool.getDescMes(Tool.parseInt(strFecha.substring(3,5)));
  //  strAnio = strFecha.substring(6,10);       
  //}
    //strFecha = Tool.getDate("dd/MM/yyyy");
    
    //strFecha = fecha.getDate();
    //strDia = fecha.getDay();
    //strMes = fecha.getMonth();
    //strAnio = fecha.getYear();
    
    String strNroCartaRechazo = objRechazo.getSNumCartRech();    
    Cliente cliente = new Cliente();    
    cliente = gestorCliente.getClienteDir(objCliente.getStrCodigo());    
    String sProducto = Tool.getString(request.getParameter("tctProducto"));        
    
    //AvisoRechazo objDatosSolicitud = new AvisoRechazo();
    
    AvisoSolicitud objAvisoSolicitud = new AvisoSolicitud();
    GestorSolicitud gc = new GestorSolicitud();
    objAvisoSolicitud = gc.getDatosSolicitudInx(Tool.parseInt(strNroautoriza), objSolicitud.getObjSolhis().getNTRANSAC());
    
    String StrDesProduct = objPoliza.getStrDesProduct();
    int StrIntPoliza  =   objCliente.getIntPoliza();
    int StrIntCertificado = objCliente.getIntCertificado();
    int intRamo           = objPoliza.getIntBranch();
    //Transforma la fecha solicitud dd.mm.yyyy
     String DFechaRegistr  = objSolicitud.getDFECHAREG();          
     strDia = DFechaRegistr.substring(0,2);
     String strMesActu = Tool.getDescMes(Tool.parseInt(DFechaRegistr.substring(3,5)));
     strMes = DFechaRegistr.substring(3,5);
     strAnio = DFechaRegistr.substring(6,10);
     String DFRegisCon = strDia+"."+strMes+"."+strAnio;
     //Transforma la fecha ingreso dd.mm.yyyy
     String DFechaIngre    = objPolizaDate.getStrStarDate();
     String strDiaIng      = DFechaIngre.substring(0,2);
     String strMesIng      = DFechaIngre.substring(3,5);
     String strAnioIng        = DFechaIngre.substring(6,10);
     String DFIngreCon     = strDiaIng+"."+strMesIng+"."+strAnioIng;
     //---------------------------------------------//
     String strProveedor = objSolicitud.getStrProveedor();     
     String strClinica = strProveedor.trim();     
    Bean bMotivo = Tabla.reaTableQIfx(318,objRechazo.getNIdSubMotRe());  
    String strMotivo = "";
    strMotivo = bMotivo.getString("descript");    
    String sDiagnostico = objRechazo.getSDiagnos();
    //TRANSFORMA LA PRIMERA LETRA A MAYUSCULA
    int nroCanTcarac = sDiagnostico.length();
    String priLetra = sDiagnostico.substring(0,1);
    String resCarac = sDiagnostico.substring(1,nroCanTcarac).toLowerCase(); 
    String descDiagnos = priLetra+resCarac;
    
    String StrRamo="";
    
    if ( intRamo == 23)
    {
        StrRamo = "Asistencia Médica Familiar";
    }
    
    double strMontoRechazo = objRechazo.getNMontoRechazo() * 1.18;
    GestorAlertaRechazo gestorAlertaRechazo = new GestorAlertaRechazo();
    AvisoRechazo objFirmaRechazo = gestorAlertaRechazo.getDatosFirmaRechazo(strMontoRechazo);
    
    int sta1= objFirmaRechazo.getNIdSta1();
    int sta2= objFirmaRechazo.getNIdSta2();
    String encargado1= objFirmaRechazo.getSNombre1();    
    String cargo1= objFirmaRechazo.getSCargo1();
    String encargado2="";
    String cargo2="";
    
    if(sta2==1){
         encargado2= objFirmaRechazo.getSNombre2();
         cargo2= objFirmaRechazo.getSCargo2();    
    }
    
    

%>

<table width="100%"  class="2" cellspacing="0" bgcolor=#ffffff cellpadding="0" border=0 id="tablaVehiculo" style="FONT-SIZE: 10px; FONT-FAMILY: Calibri">
<tr>
<body lang="ES-PE" style="tab-interval:0pt">
<div class="WordSection1">

<div style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-fareast-language:EN-US"><o:p>&nbsp;</o:p></span></div>

<div align="right" style="text-align:right"><b style="mso-bidi-font-weight:
normal"><u><span lang="ES" style="font-size:10.0pt">SNTROS.RCH N° <%=strNroCartaRechazo%></span></u></b></div>

<div style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE">San Isidro, <%=strDia%> de <%=strMesActu%> de <%=strAnio%> <o:p></o:p></span></div>
<br>
<div style="text-align:left"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE">Señor(a):</span><span lang="ES" style="font-size:10.0pt"><o:p></o:p></span></div>

<div style="text-align:justify"><b style="mso-bidi-font-weight:
normal"><span lang="ES" style="font-size:10.0pt;mso-bidi-font-family:Calibri;
background:white"><%=objCliente.getStrNombreAseg()%></span></b><b style="mso-bidi-font-weight:
normal"><span style="font-size:10.0pt;mso-ansi-language:ES-PE"><o:p></o:p></span></b></div>
<div class="MsoNoSpacing" style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE"><%=cliente.getStrDireccion()%><b style="mso-bidi-font-weight:normal"><u></u> <u><o:p></o:p></u></b></span></div>
<br>
<div class="MsoNormal" style="text-align:left"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri">Ref.:<span style="mso-tab-count:1"></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Póliza N°
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span style="mso-tab-count:2"></span>:
<span class="SpellE"></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=StrDesProduct%>&nbsp;-&nbsp;<%=StrIntPoliza%>&nbsp;–&nbsp;<%=StrIntCertificado%>
<span class="SpellE"></span></div>

<div class="MsoNormal" style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri"><span style="mso-tab-count:1"></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Ramo
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<span style="mso-tab-count:3"></span>
Asistencia Médica Familiar</span></div>

<div style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri"><span style="mso-tab-count:1"></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Siniestro&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
<span style="mso-tab-count:3"></span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strNroautoriza%></span></div>

<div class="MsoNormal" style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri"><span style="mso-tab-count:1"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha de Solicitud<span style="mso-tab-count:2"></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=DFRegisCon%>
</span></div>

<div class="MsoNormal" style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri"><span style="mso-tab-count:1"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha de Ingreso<span style="mso-tab-count:2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=DFIngreCon%> <o:p></o:p></span></div>
<br>
<div class="MsoNoSpacing" style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE">De </span><span lang="ES" style="font-size:10.0pt">nuestra consideración:<o:p></o:p></span></div>
<br>
<div class="MsoNoSpacing" style="text-align:justify"><span lang="ES" style="font-size:10.0pt">Por medio de la presente, damos respuesta a su
solicitud de cobertura para el/la <span class="SpellE"><b style="mso-bidi-font-weight:
normal"><%=objRechazo.getSProcedimient().trim()%></b></span><b style="mso-bidi-font-weight:normal"> <span class="SpellE"></span> </b> , generada a través del proveedor <b style="mso-bidi-font-weight:normal"><%=strClinica%><span style="color:blue"><span style="mso-spacerun:yes">&nbsp;</span></span></b>mediante
su póliza en referencia.<o:p></o:p></span></div>
<br>
<div class="MsoNoSpacing" style="text-align:justify"><span lang="ES" style="font-size:10.0pt">Al respecto, le informamos que su solicitud de
cobertura para el diagnóstico <b style="mso-bidi-font-weight:normal"><i style="mso-bidi-font-style:normal"><%=objRechazo.getNIDDiagnos()%> <%=descDiagnos%> <%=strMotivo%></i></b><u></u>: <o:p></o:p></span></div>
<br>
<div class="MsoNormal" style="margin-left:36.0pt;text-align:justify"><b style="mso-bidi-font-weight:normal"><i style="mso-bidi-font-style:normal"><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;"> <%=objRechazo.getSCond_poli().trim()%> <%=objRechazo.getSCond_polii().trim()%><o:p></o:p></span></i></b></div>

<div class="MsoNormal" style="text-align:justify;text-indent:36.0pt;background:
white"><span lang="ES" style="font-size:10.0pt;mso-bidi-font-size:10.0pt;
font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri;mso-bidi-font-style:
Calibri"><o:p>&nbsp;</o:p></span></div>

<div class="MsoNormal" style="text-align:justify;background:white"><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">Es importante recordarle que de no estar
conforme con la presente comunicación, tiene la posibilidad de presentar el
reclamo respectivo ante La Positiva Seguros Generales, de manera escrita en
cualquiera de nuestras oficinas a nivel nacional o a través de nuestra página
web&nbsp;</span><span lang="ES"><a href="http://www.lapositiva.com.pe/" target="_blank"><span style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:Calibri;color:windowtext;mso-bidi-font-style:Calibri">www.lapositiva.com.pe</span></a></span><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">, o vía telefónica a&nbsp; nuestra Línea
Positiva 211-0-211 desde Lima o al 0800-1-0800 ó 74-9001 desde provincias.</span><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri"><o:p></o:p></span></div>

<div class="MsoNormal" style="text-align:justify;background:white"><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">Asimismo precisar que, en caso de
disconformidad con los fundamentos del rechazo del siniestro, usted podrá
acudir a las vías de solución de controversias, como son la Defensoría del
Asegurado (</span><span lang="ES"><a href="http://www.defaseg.com.pe/" target="_blank"><span style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:Calibri;color:windowtext;mso-bidi-font-style:Calibri">www.defaseg.com.pe</span></a></span><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">), el Instituto Nacional de Defensa de la
Competencia y de la Protección de la Propiedad Intelectual – INDECOPI (</span><span lang="ES"><a href="http://www.indecopi.gob.pe/" target="_blank"><span style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;color:windowtext;mso-bidi-font-style:Calibri">www.indecopi.gob.pe</span></a></span><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">) o el Poder Judicial o instancia arbitral,
según se haya pactado.<o:p></o:p></span></div>
<br>
<div class="MsoNormal" style="text-align:justify;background:white"><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri;mso-bidi-font-style:Calibri">Para solicitar orientación, podrá comunicarse
con la Plataforma de Atención al Usuario de la Superintendencia de Banca,
Seguros y AFP al teléfono gratuito 0-800-10840.</span><span lang="ES" style="font-size:10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:
Calibri"><o:p></o:p></span></div>
<br>
<div class="MsoNormal" style="text-align:justify"><span lang="ES" style="font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri">Atentamente,<o:p></o:p></span></div>
<br><br><br><br><br><br><br><br><br>
<div class="MsoNoSpacing" style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE"><o:p>&nbsp;</o:p></span></div>

<div class="MsoNoSpacing" style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE"><o:p>&nbsp;</o:p></span></div>

<div class="MsoNoSpacing" style="text-align:justify"><span style="font-size:10.0pt;
mso-ansi-language:ES-PE"><span style="mso-tab-count:1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><b style="mso-bidi-font-weight:normal"><span style="color:blue"><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="mso-tab-count:5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><o:p></o:p></span></b></span></div>

<div class="MsoNormal" style="text-align:justify;background:white"><b style="mso-bidi-font-weight:normal"><span lang="ES" style="font-size:10.0pt;
font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri;mso-bidi-font-style:
italic"><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><%=encargado1%><span style="mso-tab-count:5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><%=encargado2%><span style="mso-tab-count:1">&nbsp; </span><o:p></o:p></span></b></div>

<div class="MsoNormal" style="text-align:justify;background:white"><b style="mso-bidi-font-weight:normal"><span lang="ES" style="font-size:10.0pt;
font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-bidi-font-family:Calibri;mso-bidi-font-style:
italic"><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><%=cargo1%></span></b><b style="mso-bidi-font-weight:normal"><span style="font-size:10.0pt;font-family:
&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-ansi-language:ES-PE"><span style="mso-tab-count:
1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span> <span style="mso-tab-count:1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;</span><span style="mso-tab-count:2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span><span style="mso-spacerun:yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><%=cargo2%><o:p></o:p></span></b></div>

<div class="MsoNormal" style="text-align:justify;background:white"><b style="mso-bidi-font-weight:normal"><span style="font-size:8.0pt;mso-bidi-font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-ansi-language:ES-PE"><o:p>&nbsp;</o:p></span></b></div>

<div class="MsoNormal" style="text-align:justify;background:white"><b style="mso-bidi-font-weight:normal"><span style="font-size:8.0pt;mso-bidi-font-size:
10.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;mso-ansi-language:ES-PE"><o:p>&nbsp;</o:p></span></b></div>
<br>
<br>
<div class="MsoNoSpacing" style="text-align:justify"><b style="mso-bidi-font-weight:
normal"><span style="font-size:10.0pt;mso-ansi-language:ES-PE"><%=objAvisoSolicitud.getSBroker()%><span style="mso-tab-count:1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><o:p></o:p></span></b></div>

</div>




</body>                        
</table>