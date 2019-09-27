<%@ page contentType="application/pdf; charset=UTF-8"%>
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
<%
  
     /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:38am*/    
       Atencion atencion = new Atencion();
     /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:25am*/ 
      GestorSolicitud gestorSolicitud = new GestorSolicitud();
     /*Instanciando,para acceder a los Datos  yahirRivas 05MAR2012 11:25am*/ 
      GestorFirma gestorFirma =  new GestorFirma();
     
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
            
  Image logo = Image.getInstance(Constante.getConst("PATH_IMAGE") + "logoEPS.jpg");

  Font tableFont = FontFactory.getFont("Helvetica", 8);

  Document document = new Document();  
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  Paragraph pContent = null;
  PdfWriter writer = PdfWriter.getInstance (document,buffer);
  document.open();
  document.add(logo);
  pContent = new Paragraph("" + "\n",FontFactory.getFont("Helvetica", 12, Font.BOLD, Color.BLACK)); 
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
  
  if  (objSolicitud.getNIDESTADO()== Constante.NESTAPR){
    strFecha = objSolicitud.getObjSolhis().getDFECHAREG();
    strDia = strFecha.substring(0,2);
    strMes = Tool.getDescMes(Tool.parseInt(strFecha.substring(3,5)));
    strAnio = strFecha.substring(6,10);
  }
    //strFecha = Tool.getDate("dd/MM/yyyy");
    

  
    cell = ToolPdf.makeCell((objSolicitud.getIntCodOficina()==23?"San Isidro":objSolicitud.getStrNombOficina()) +  ", " + strDia + " de " + strMes + " de " + strAnio , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);
    table.addCell(cell);
    cell = ToolPdf.makeCell("Carta Nro.:" + strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_RIGHT, FontFactory.getFont("Helvetica", 10), tableFont.size() * 1.2f, 2f, border, true, true);
    table.addCell(cell);
    yBarCode = 672f; /* P 2012 - 0048 Codigo Barras */
    
    /* P 2012 - 0048 Codigo Barras */
    if (strNroautoriza.length()==8)
       xBarCode = 480f; 
    else if (strNroautoriza.length()==9) 
       xBarCode = 468f;
    else xBarCode = 492f;
    /* P 2012 - 0048 Codigo Barras */
    
    if (objSolicitud.getNFLGAMPLIACION()==1 && objSolicitud.getObjSolhis().getNTRANSAC()>1){
      cell = ToolPdf.makeCell("CARTA AMPLIATORIA AL " + objSolicitud.getStrFechaLimite() + " TOTAL " + Tool.toDecimal(dblAmount,2) + " " + objSolicitud.getStrMonedaImpoCarta(), Element.ALIGN_TOP, Element.ALIGN_RIGHT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(2);
      table.addCell(cell);
      yBarCode = yBarCode-10f; /* P 2012 - 0048 Codigo Barras */
    }

    if (Constante.SATENAMB.equals(objCobertura.getStrTipoAtencion())){
      cell = ToolPdf.makeCell("VALIDO SOLO AMBULATORIO ", Element.ALIGN_TOP, Element.ALIGN_RIGHT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(2);
      table.addCell(cell);
      yBarCode = yBarCode-10f; /* P 2012 - 0048 Codigo Barras */
    }

    /* P 2012 - 0048 Codigo Barras */
    PdfContentByte cb = writer.getDirectContent();
    Image imgbarcode = ToolPdf.getBarCode(strNroautoriza).createImageWithBarcode(cb,Color.BLACK,Color.WHITE);
    //imgbarcode.setAbsolutePosition(480f,620f);
    imgbarcode.setAbsolutePosition(xBarCode, yBarCode);
    document.add(imgbarcode);
   /* P 2012 - 0048 Codigo Barras */
   
    /*
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
*/
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Se�ores :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell(objSolicitud.getStrProveedor(), Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Helvetica", 8, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Presente :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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
  tableFont = FontFactory.getFont("Helvetica", 8, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);

    cell = ToolPdf.makeCell("Ref.-", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    //cell = ToolPdf.makeCell("P�liza de A.M.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);   Apple
    cell = ToolPdf.makeCell("Contrato", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntPoliza()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Contratante", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrContratante(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Titular Asegurado", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrNombreTitular(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Fecha de Ingreso", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrFecIngreso(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Paciente", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrNombreAseg(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Parentesco", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrParentesco(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("C�digo de paciente", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntCertificado()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    //AVM -> Se agrego el campo de continuidad
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("SI", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;  

    pContent = new Paragraph("" + "\n",FontFactory.getFont("Helvetica", 8, Font.BOLD, Color.BLACK)); 
    pContent.setAlignment(Element.ALIGN_CENTER);
    document.add(pContent);

    float[] columSize2 = {30F, 5F, 65F};
    table = new PdfPTable(columSize2);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Helvetica", 8, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Estimados se�ores :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("A trav�s de la presente, garantizamos el pago de los gastos cubiertos en que incurre el asegurado en referencia, hasta los siguientes l�mites :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Diagn�stico Presuntivo", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objSolicitud.getStrDiagnos(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("CIE10", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objSolicitud.getIntCodDiagnos(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    String strCellLimite ="";
    String strCellDedu ="";
    if (intTipoSol==Constante.NTSCARGAR)
      if (Constante.SATENHOSP.equals(objCobertura.getStrTipoAtencion())){
        strCellLimite = "UNIPERSONAL";
        strCellDedu = (Tool.parseInt(objCobertura.getStrCantidad())==0?"-------":objCobertura.getStrCantidad() + " d�a(s) de cuarto");
      }else{
        strCellLimite = "-------";//objCobertura.getStrCantidad();
        strCellDedu = "-------";//Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible())*Tool.reaIGV(2,""),2) + " " + objCliente.getStrMoneda().toUpperCase();
      }
    else
      if (intTipoSol==Constante.NTSCARAUT){
        strCellLimite = "-------";
        strCellDedu = "-------";
      }
    
    
    cell = ToolPdf.makeCell("Limite por Cuarto Diario", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strCellLimite, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
      
    cell = ToolPdf.makeCell("Deducible", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strCellDedu, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("Coaseguro a cargo del asegurado", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCobertura.getStrCoaseguro() + " %", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    Bean b = Tabla.reaTableIfx(11,objSolicitud.getIntMonedaImpoCarta());
    String strMoneda = "";
    if (b!=null)
      strMoneda = b.getString("4");
    
    cell = ToolPdf.makeCell("Limite m�ximo total de facturaci�n ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(Tool.toDecimal(dblMontoCarta,2) + " " + strMoneda, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("Cobertura", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(":", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCobertura.getStrNomCobertura(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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
  tableFont = FontFactory.getFont("Helvetica", 8, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Los excesos a las limitaciones antes se�aladas deber�n ser canceladas por el asegurado al alta del paciente.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    //Inicio Req. 2014-000204 Paradigmasoft GJB
    String sMensajeGarantia = objSolicitud.getNIDTIPOSOLICITUD()==1?"Esta garant�a no incluye los gastos del acompa�ante, tel�fono, televisi�n, art�culos de tocados, " + 
                                                                    "pa�ales, term�metro, vitaminas, etc. o cualquier otro" + 
                                                                    " gasto con el tratamiento m�dico."
                                                                   :"Esta garant�a no incluye los gastos del acompa�ante, tel�fono, art�culos de tocador, pa�ales, " + 
                                                                    "term�metro, vitaminas, etc. o cualquier otro gasto " + 
                                                                    "y/o servicio sin relaci�n directa con el diagn�stico.";   
    
    cell = ToolPdf.makeCell(sMensajeGarantia, Element.ALIGN_TOP, Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    //Fin Req. 2014-000204 Paradigmasoft GJB
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("El asegurado deber� ser portador de la Declaraci�n de Accidente, con los datos requeridos firmada por �l y el contratante, la misma que tiene " + 
                            "que ser completada por el m�dico tratante y/o Cl�nica, y remitida con la factura correspondiente.", Element.ALIGN_TOP, Element.ALIGN_LEFT, 
                            tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Asi mismo, los honorarios m�dicos m�ximos, deben estar incluidos en la factura, tanto la cl�nica como los m�dicos " +
                            "no podr�n cobrar al Asegurado honorarios que excedan las tarifas pactadas, de lo contrario esta carta de garant�a quedar� sin " + 
                            "valor ni efecto alguno. Agradeceremos se sirva enviar las facturas a nombre de La Positiva S.A. Entidad Prestadora de Salud para su respectiva " + 
                            "cancelaci�n. La fecha m�xima para la presentaci�n de esta garant�a es hasta el " + objSolicitud.getStrFechaLimite(), Element.ALIGN_TOP, 
                            Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Muy Atentamente,", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;

  //Firmas
  //AC� VAN LOS CAMBIOS ASOCIADOS
  //--2011-0975
  if (objSolicitud.getObjSolhis().getNESTADO() == Constante.NESTAPR){
    float[] columSizef = {10, 25F, 25F, 25F, 15F};
    table = new PdfPTable(columSizef);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Helvetica", 7, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);
  
   // Inicio : RQ2018-1519
    Firma objFirma = gestorFirma.getFirmaBin(objSolicitud.getIntIdUsuFirma1(),objSolicitud.getIntIdUsuFirma2(),objCliente.getIntRamo());
   // Fin : RQ2018-1519
    byte[][] firmas = objFirma.getBFirmas();
    String[] strNombre = objFirma.getStrNombres();
    String[] strCargo = objFirma.getStrCargos();
    
    String sObservaciones = Tool.getString(objSolicitud.getSOBSERVAMED());
    sObservaciones = sObservaciones!=""?sObservaciones:" SIN OBSERVACIONES";
    
    if ((objFirma.getBFirmas()[0]!=null && objFirma.getBFirmas()[0].length > 0) && (objFirma.getBFirmas()[1]!=null && objFirma.getBFirmas()[1].length > 0)){
      System.out.println("Firma 1 :"+objFirma.getBFirmas()[0]);
      System.out.println("Firma 2 :"+objFirma.getBFirmas()[1]);
    Image imgFirma1 = Image.getInstance(objFirma.getBFirmas()[0]);  
    Image imgFirma2 = Image.getInstance(objFirma.getBFirmas()[1]);  
    
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA1
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setImage(imgFirma1);
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA2
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setImage(imgFirma2);
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE1
      cell = ToolPdf.makeCell(strNombre[0], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE2
      cell = ToolPdf.makeCell(strNombre[1], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------CARGO1
      cell = ToolPdf.makeCell(strCargo[0], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------CARGO2
      cell = ToolPdf.makeCell(strCargo[1], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      //Inicio Req. 2014-000204 Paradigmasoft GJB
      cell = ToolPdf.makeCell("\n\n\n\nOBSERVACIONES: " + sObservaciones, Element.ALIGN_MIDDLE, Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);                 
      cell.setColspan(9);
      table.addCell(cell); 
      //Fin Req. 2014-000204 Paradigmasoft GJB
      
      cell = ToolPdf.makeCell("\n\n\n\n\n\n" + (strUserAprob != null? "Aprobado por: " + strUserAprob:""), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(5);
      table.addCell(cell);      

   }
   //Inicio Req. 2014-000204 Paradigmasoft GJB
   /*else if(objFirma.getBFirmas()[0]!=null && objFirma.getBFirmas()[0].length > 0 && objFirma.getBFirmas()[1]==null) --Se coment� el d�a 18/11/2014*/
   else if(objFirma.getBFirmas()[0]!=null && objFirma.getBFirmas()[0].length > 0 && objFirma.getBFirmas()[1].length==0)
   //Fin Req. 2014-000204 Paradigmasoft GJB
   {
    Image imgFirma1 = Image.getInstance(objFirma.getBFirmas()[0]);  
    
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA1
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setImage(imgFirma1);
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA2
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE1
      cell = ToolPdf.makeCell(strNombre[0], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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
      cell = ToolPdf.makeCell(strCargo[0], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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
      
      //Inicio Req. 2014-000204 Paradigmasoft GJB
      cell = ToolPdf.makeCell("\n\n\n\nOBSERVACIONES: " + sObservaciones, Element.ALIGN_MIDDLE, Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);                 
      cell.setColspan(9);
      table.addCell(cell); 
      //Fin Req. 2014-000204 Paradigmasoft GJB
           
      cell = ToolPdf.makeCell("\n\n\n\n\n" + (strUserAprob != null? "Aprobado por: " + strUserAprob:""), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(5);
      table.addCell(cell);
   }
   else if(objFirma.getBFirmas()[0]==null && (objFirma.getBFirmas()[1]!=null && objFirma.getBFirmas()[1].length > 0))
   {
    
    Image imgFirma2 = Image.getInstance(objFirma.getBFirmas()[1]);  
    
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA1
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setImage(imgFirma2);
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------FIRMA2
      cell = ToolPdf.makeCell("", Element.ALIGN_BOTTOM, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //--------------
      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);

      cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      table.addCell(cell);
      //-------NOMBRE1
      cell = ToolPdf.makeCell(strNombre[1], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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
      cell = ToolPdf.makeCell(strCargo[1], Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
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

      //Inicio Req. 2014-000204 Paradigmasoft GJB
      cell = ToolPdf.makeCell("\n\n\n\nOBSERVACIONES: " + sObservaciones, Element.ALIGN_MIDDLE, Element.ALIGN_JUSTIFIED, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);                 
      cell.setColspan(9);
      table.addCell(cell); 
      //Fin Req. 2014-000204 Paradigmasoft GJB
      
      cell = ToolPdf.makeCell("\n\n\n\n\n\n" + (strUserAprob != null? "Aprobado por: " + strUserAprob:""), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
      cell.setColspan(5);
      table.addCell(cell);
   }
      document.add(table);
      table = null;
      border = null;
      cell = null;
  }
  
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

    /**Agregado**/
      response.setHeader("Expires", "0");
      response.setHeader("Cache-Control","must-revalidate, post-check=0, pre-check=0");
      response.setHeader("Pragma", "public");
      response.setContentType("application/pdf; charset=UTF-8");
      
      response.setCharacterEncoding("UTF-8");
      ///response.setContentLength(buffer.size());
      
      OutputStream os = response.getOutputStream();
      buffer.writeTo(os);
      os.flush();
      os.close();
      
      response.flushBuffer();
  /**Fin agregado**/
/*
  DataOutput output = new DataOutputStream(response.getOutputStream());
  byte[] bytes = buffer.toByteArray();
  response.setContentLength(bytes.length);
  for(int i=0;i<bytes.length;i++){
      output.writeByte(bytes[i]);  
  }*/
%>
