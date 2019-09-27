<%@ page contentType="application/pdf"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.GestorSolicitud"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.Cliente"%>
<%@ page import="com.clinica.beans.Cobertura"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.awt.Color"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%
  
     /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:38am*/    
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
    Bean objAten2 = atencion.getSiniestroLog(strNroautoriza);
    int codRamo = Tool.parseInt(objAten2.getString("1")) ; // Apple
    GestorPolClinic gestorPolClinic = new GestorPolClinic();     
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
            
  //Image logo = Image.getInstance(Constante.getConst("PATH_IMAGE") + "logo.jpg");

  Font tableFont = FontFactory.getFont("Calibri", 8);

  Document document = new Document();  
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  Paragraph pContent = null;
  PdfWriter writer = PdfWriter.getInstance (document,buffer);
  
  
  
  document.open();
  //document.add(logo);
  pContent = new Paragraph("" + "\n",FontFactory.getFont("Calibri", 12, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_CENTER);
  document.add(pContent);

  /*Cabecera*/
  PdfPTable table = null;
  float[] columSize = {50F, 50F};
  table = new PdfPTable(columSize);
	table.setWidthPercentage(100f);	    
  Rectangle border = new Rectangle(5f, 5f);
  
  PdfPCell cell = null;  

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
    //cliente = gestorCliente.getCliente(objCliente.getStrCodigo());    
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
     

  
    cell = ToolPdf.makeCell("San Isidro, " + strDia + " de " + strMesActu + " de " + strAnio , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);
    table.addCell(cell);
    cell = ToolPdf.makeCell("SNTROS.RCH N°: " + strNroCartaRechazo, Element.ALIGN_TOP, Element.ALIGN_RIGHT, FontFactory.getFont("Calibri", 10,Font.UNDERLINE), tableFont.size() * 1.2f, 2f, border, true, true);
    table.addCell(cell);
    yBarCode = 672f; /* P 2012 - 0048 Codigo Barras */

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Señor(a) :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell(objCliente.getStrNombreAseg(), Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Calibri", 10, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell(cliente.getStrDireccion(), Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Calibri", 8, Font.NORMAL, Color.BLACK), tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);


    document.add(table);
    table = null;
    border = null;
    cell = null;  

  float[] columSize1 = {10F, 20F, 5F, 65F};
  table = new PdfPTable(columSize1);
	table.setWidthPercentage(100f);	    
  tableFont = FontFactory.getFont("Calibri", 10, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);

    cell = ToolPdf.makeCell("Ref.:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Contrato ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell( StrDesProduct + " - " + StrIntPoliza + " - " + StrIntCertificado, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    //cell = ToolPdf.makeCell(String.valueOf(objPoliza.getStrDesProduct() +' - '+ objCliente.getIntPoliza()+ ' - ' + objCliente.getIntCertificado()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell); 
  
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Ramo", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell( StrRamo , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Siniestro", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Fecha de Solicitud", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(DFRegisCon, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Fecha de Ingreso", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(DFIngreCon, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;  
    
    

    pContent = new Paragraph("" + "\n",FontFactory.getFont("Calibri", 8, Font.BOLD, Color.BLACK)); 
    pContent.setAlignment(Element.ALIGN_CENTER);
    document.add(pContent);

    float[] columSize2 = {50F, 50F};
    //float[] columSize2 = {5F,5F,10F};
    table = new PdfPTable(columSize2);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Calibri", 10, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("De nuestra consideración :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Por medio de la presente, damos respuesta a su solicitud de cobertura para el/la " + objRechazo.getSProcedimient().trim() + ", " + " generada a través del proveedor " + strClinica + " mediante su póliza en referencia. ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);          
    cell.setColspan(3);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);        
    
    cell = ToolPdf.makeCell("Al respecto, le informamos que su solicitud de cobertura para el diagnóstico " + objRechazo.getNIDDiagnos() + " " + descDiagnos + " " + strMotivo, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);    

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
    
    document.add(table);
    table = null;
    border = null;
    cell = null; 
    
    //float[] columSize2 = {30F, 5F, 65F};
    float[] columSize4 = {50F,50F};
    table = new PdfPTable(columSize4);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Calibri", 10, Font.ITALIC, Color.BLACK);
    border = new Rectangle(0f, 0f);

    cell = ToolPdf.makeCell(objRechazo.getSCond_poli().trim() + objRechazo.getSCond_polii().trim(), Element.ALIGN_JUSTIFIED, Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);       

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;  
  
  float[] columSize7 = {50F, 50F};
  table = new PdfPTable(columSize7);
	table.setWidthPercentage(100f);	    
  tableFont = FontFactory.getFont("Calibri", 10, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Es importante recordarle que de no estar conforme con la presente comunicación, tiene la posibilidad de presentar el reclamo respectivo ante La Positiva Seguros Generales, " +
                            "de manera escrita en cualquiera de nuestras oficinas a nivel nacional o a través de nuestra página web www.lapositiva.com.pe, o vía telefónica a  nuestra Línea Positiva 211-0-211 " +
                            "desde Lima o al 0800-1-0800 ó 74-9001 desde provincias.Asimismo precisar que, en caso de disconformidad con los fundamentos del rechazo del siniestro, usted podrá acudir a las vías " + 
                            "de solución de controversias, como son la Defensoría del Asegurado (www.defaseg.com.pe), el Instituto Nacional de Defensa de la Competencia y de la Protección de la Propiedad Intelectual – INDECOPI (www.indecopi.gob.pe) " +
                            "o el Poder Judicial o instancia arbitral, según se haya pactado.Para solicitar orientación, podrá comunicarse con la Plataforma de Atención al Usuario de la Superintendencia de Banca, Seguros y AFP al teléfono gratuito 0-800-10840.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);    

    cell = ToolPdf.makeCell("Atentamente,", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n\n\n\n\n\n\n\n\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;

  //Firmas
  //ACÁ VAN LOS CAMBIOS ASOCIADOS
    double strMontoRechazo = objRechazo.getNMontoRechazo() * 1.18;
    GestorAlertaRechazo gestorAlertaRechazo = new GestorAlertaRechazo();
    AvisoRechazo objFirmaRechazo = gestorAlertaRechazo.getDatosFirmaRechazo(strMontoRechazo);
    String encargado1= objFirmaRechazo.getSNombre1();
    String encargado2= objFirmaRechazo.getSNombre2();
    int sta1= objFirmaRechazo.getNIdSta1();
    String cargo1= objFirmaRechazo.getSCargo1();
    String cargo2= objFirmaRechazo.getSCargo2();
    int sta2= objFirmaRechazo.getNIdSta2();
  //--2011-0975
  if (encargado1 != null || encargado1 != "" || sta1 !=0 ){
    float[] columSizef = {10, 25F, 25F, 25F, 15F};
    table = new PdfPTable(columSizef);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Calibri", 10, Font.BOLD, Color.BLACK);
    border = new Rectangle(0f, 0f);      
  
  if (sta1==1 && sta2 ==1){
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE1
      cell = ToolPdf.makeCell(encargado1, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      
      //-------NOMBRE2
      cell = ToolPdf.makeCell(encargado2, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------CARGO1
      cell = ToolPdf.makeCell(cargo1, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
     
      //--------CARGO2
      cell = ToolPdf.makeCell(cargo2, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(3);
      table.addCell(cell);

      cell = ToolPdf.makeCell("\n\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(3);
      table.addCell(cell);    
    }else    
    if (sta1==1 && sta2 ==0){
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE1
      cell = ToolPdf.makeCell(encargado1, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      
      //-------NOMBRE2
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------CARGO1
      cell = ToolPdf.makeCell(cargo1, Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
     
      //--------CARGO2
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(3);
      table.addCell(cell);

      cell = ToolPdf.makeCell("\n\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(3);
      table.addCell(cell);    
      }
      document.add(table);
      table = null;
      border = null;
      cell = null;
  }
  
      float[] columSize8 = {30F};
      table = new PdfPTable(columSize8);
      table.setWidthPercentage(100f);	    
      tableFont = FontFactory.getFont("Calibri",10, Font.BOLD, Color.BLACK);
      border = new Rectangle(0f, 0f);
  
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      
      cell = ToolPdf.makeCell(objAvisoSolicitud.getSBroker(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(3);
      table.addCell(cell);
      
      document.add(table);
      table = null;
      border = null;
      cell = null;
  
  Usuario usuario = null;
  synchronized(session)
  {
      usuario = (Usuario)session.getAttribute("USUARIO");           
  }  
  if (usuario !=null){
    if (usuario.getIntIdRol() != Constante.NROPERFILBRK)
      writer.addJavaScript("this.print(true);", false);
  }
  else writer.addJavaScript("this.print(true);", false);
  
  document.close();
//  FileOutputStream
  DataOutput output = new DataOutputStream(response.getOutputStream());
  //FileOutputStream output = new FileOutputStream("tituloDocumento"+".docx");
  byte[] bytes = buffer.toByteArray();
  response.setContentLength(bytes.length);
  for(int i=0;i<bytes.length;i++){
      output.writeByte(bytes[i]);  
      //output.write(bytes[i]);  
  }
%>

