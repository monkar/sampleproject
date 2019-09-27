<%@ page contentType="application/pdf"%>
<%@ page import="java.io.*"%>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.awt.Color"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.controller.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.util.ArrayList"%>

<%

     /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:27am*/    
    Atencion atencion = new Atencion();
    /*Instanciando la clase GestorPolClinic,para acceder a los Datos yahirRivas 29FEB2012 11:27am*/    
    GestorPolClinic gestorPolClinic = new GestorPolClinic();
  
  //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 11:59am
  GestorCliente gestorCliente = new GestorCliente();
  
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:32pm
      GestorClinica gestorClinica = new GestorClinica();
      
    Usuario usuario = null;
    synchronized(session)
    {
       usuario = (Usuario)session.getAttribute("USUARIO"); 
    }   
    
    String strNroautoriza = Tool.getString(request.getParameter("pnautoriza"));
    //SSRS se obtiene la información del siniestro
    Bean objAten = atencion.getSiniestroLog(strNroautoriza);
    
    //SSRS Se obtienen los datos de la clinica
    String strWebServer = objAten.getString("6");
    
    String strNomClinica = gestorClinica.getClinica(strWebServer).getString("2");
    
    int intRamo = Tool.parseInt(objAten.getString("1"));
    int intPoliza = Tool.parseInt(objAten.getString("2"));
    int intCertif = Tool.parseInt(objAten.getString("3"));
    String strCodCliente = objAten.getString("5");
    String strCobertura = objAten.getString("4");
    
    String strFecha = objAten.getString("19");
    java.util.Date fechaReg = null;
    if(!strFecha.equals(""))
    {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    
        try 
        {
          fechaReg = dateFormat.parse(strFecha);
        } 
        catch (ParseException e) 
        {
           e.printStackTrace();
        }
    }
    
    //SSRS Se obtienen los datos del cliente asociado a la solicitud de carta
    Cliente objCliente = null;
    Bean objAtencion = atencion.getCliente_his(intPoliza, intCertif, strCodCliente,strWebServer,strNroautoriza,intRamo);
     atencion.getCliente_his(intPoliza, intCertif, strCodCliente,strWebServer, strNroautoriza,intRamo);
    objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);
    // AVM : variable para la continuidad es el campo continuity
    // con Continuidad = 'S'
    // sin Continuidad = 'N'    
    String strCodContin =  objCliente.getStrContinuidadInx().substring(0);
    int intFlgConti = 0;    
    
    //SSRS Flag que permite validar la continuidad de poliza .Si la fecha de ingreso empieza en 02 si hay continuidad de poliza
    if(strCodContin.equals("S")==true)
        intFlgConti = 1;        
        
   
    Cliente objTitular = gestorCliente.getCliente(objCliente.getStrCodTitular());
    
    Cliente objPaciente = gestorCliente.getCliente(objCliente.getStrCodigo());
      
    //SSRS Se obtiene la cobertura seleccionada para la solicitud
    Cobertura objCobertura = null;
    ArrayList lstCobertura = gestorPolClinic.getLstCobertura_his(objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                            objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                            objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                            strCodCliente, objCliente.getIntCodEstado(),strNroautoriza,intRamo);
                            
    for(int i=0; i<lstCobertura.size(); i++)
    {
        objCobertura = (Cobertura)lstCobertura.get(i);
        if (objCobertura.getIntCover() == Tool.parseInt(strCobertura))
        break;                  
    }
      


   
      
    String strCodEnf = "";  
    float borderWidth = 0.5f;
    
    if (objCliente.getIntIndExcl()==1){

      BeanList objLstExcl = new BeanList();
      objLstExcl = atencion.getLstExclusion(objCliente.getIntPoliza(),objCliente.getIntCertificado(),objCliente.getStrCodigo(),intRamo);
      Exclusion objExclusion = null;
        for(int i=0;i<objLstExcl.size();i++){
                objExclusion = new Exclusion();
                objExclusion = (Exclusion)objLstExcl.get(i);
                if (!"".equals(strCodEnf)) strCodEnf = strCodEnf + " ";
                strCodEnf = strCodEnf + objExclusion.getStrCodEnfermedad();
        }
    }

    DateDiff dateDiff = null;
    try
    {
        dateDiff = new DateDiff(Tool.getDate("dd/MM/yyyy"), objCliente.getStrFecNac());
        dateDiff.calculateDifference();
    }
    catch(Exception e)
    {
       e.printStackTrace(); 
    }   


  Image logo = Image.getInstance(Constante.getConst("LOGO"));          
  //Image logo = Image.getInstance("D:\\Oliver\\Web Clinica\\logoN.jpg");
  
  logo.scaleAbsolute(90,30f);
  logo.setAlignment(Image.ALIGN_LEFT);    
  
  Font tableFont = FontFactory.getFont("Arial", 11);
  Font  tableFontWhite = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.WHITE);
  Font commentFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    
  Document document = new Document();  
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  Paragraph pContent = null;
  PdfWriter writer = PdfWriter.getInstance (document,buffer);
  document.open();
  document.add(logo);  
  
  pContent = new Paragraph("Pag. 1/2",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_RIGHT);
  document.add(pContent);    
  
  pContent = new Paragraph("SOLICITUD DE BENEFICIO DENTAL" + "\n\n",FontFactory.getFont("Arial", 13, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_CENTER);
  document.add(pContent);

  /*Cabecera*/
  PdfPTable table = null;
  float[] columSize = {18F, 20F, 20F, 17F};
  table = new PdfPTable(columSize);
	table.setWidthPercentage(100f);	    
  Rectangle border = new Rectangle(5f, 5f);
  
  PdfPCell cell = null;  

    /* P 2012 - 0048 Codigo Barras */
    PdfContentByte cb = writer.getDirectContent();
    Image imgbarcode = ToolPdf.getBarCode(strNroautoriza).createImageWithBarcode(cb,Color.BLACK,Color.WHITE);
    imgbarcode.setAbsolutePosition(495f,690f);
    document.add(imgbarcode);
    /* P 2012 - 0048 Codigo Barras */

    cell = ToolPdf.makeCell("Nro de Autorización :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    if(intFlgConti==1){        
        cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11), tableFont.size() * 1.2f, 2f, border, true, true);  
        table.addCell(cell); 
        
        cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_RIGHT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
        cell.setColspan(2);
        table.addCell(cell);        
    }else{                  
        cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11), tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(3);
        table.addCell(cell);        
    }
    
    cell = ToolPdf.makeCell("Fecha :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    if(!strFecha.equals(""))
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy",fechaReg)   + "    válida al   " + Tool.addDate(6,"dd/MM/yyyy",fechaReg) , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
  
    }
    else
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy") + "    válida al   " + Tool.addDate(6,"dd/MM/yyyy"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }
    
    
    cell.setColspan(3);
    table.addCell(cell);

    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("Contratante:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }else{    
       cell = ToolPdf.makeCell("Clínica / Centro Médico:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }    
    
    
    table.addCell(cell);
    cell = ToolPdf.makeCell(strNomClinica, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
  
    document.add(table);
    table = null;
    border = null;
    cell = null;  
  
      
            /*-------------AGREGANOD LA LINEA-------------- */
    float[] columSize10 = {2F,2F,2F,2F};
    table = new PdfPTable(columSize10);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f, 0f, 0f);    
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);    
    cell.setBorderWidthBottom(1);
    table.addCell(cell);
    
    document.add(table);
    table = null;
    border = null;
    cell = null;
    /*---------------------------------------------- */  
    
    /*Contratante*/
  pContent = new Paragraph("Información del Contratante",FontFactory.getFont("Arial", 13, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_LEFT);
  document.add(pContent);
  document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
  float[] columSize1 = {32F, 20F, 20F, 20F, 20F, 18F};
  table = new PdfPTable(columSize1);
	table.setWidthPercentage(100f);	    
  tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Fin de Vigencia :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrFecFinVigencia(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Nombre / Razón Social :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrContratante(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(5);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Titular :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrNombreTitular(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(5);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Contrato :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntPoliza()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Certificado :", Element.ALIGN_TOP, Element.ALIGN_RIGHT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntCertificado()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Plan :", Element.ALIGN_TOP, Element.ALIGN_RIGHT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrPlan(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    document.add(table);
    table = null;
    border = null;
    cell = null;  

  /*Asegurado*/
  pContent = new Paragraph("Información del Paciente\n",FontFactory.getFont("Arial", 13, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_LEFT);
  document.add(pContent);
  document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
  float[] columSize2 = {20F, 20F, 20F, 20F};
  table = new PdfPTable(columSize2);
	table.setWidthPercentage(100f);	    
  tableFont = FontFactory.getFont("Arial",11, Font.NORMAL, Color.BLACK);

  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Apellidos y Nombres :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrNombreAseg(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Fecha de Nacimiento :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrFecNac(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Edad :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(dateDiff.getYear()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("Sexo :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrSexo(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Parentesco :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrParentesco() , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("Cobertura :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCobertura.getStrNomCobertura(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Deducible por Pieza :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }else{    
       cell = ToolPdf.makeCell(Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2) + " " + objCliente.getStrMoneda().toUpperCase(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }            
    
    table.addCell(cell);

    cell = ToolPdf.makeCell("Carencia :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Coaseguro :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }else{    
       cell = ToolPdf.makeCell(objCobertura.getStrCoaseguro() + " %", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }        
    
    table.addCell(cell);

    cell = ToolPdf.makeCell("Exclusiones :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strCodEnf, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Observaciones :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Saldo es de " + Tool.toDecimal(Tool.parseDouble(objCobertura.getStrBeneficioMax()) - Tool.parseDouble(objCobertura.getStrBeneficioCons()),2) + "  " + objCliente.getStrMoneda().toUpperCase(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;  
  
    logo =  null;
    logo = Image.getInstance(Constante.getConst("LOGO_ODON")); 
    //logo = Image.getInstance("D:\\Oliver\\Web Clinica\\odontograma.jpg");    

    logo.scaleAbsolute(350,120f);
    logo.setAlignment(Image.ALIGN_CENTER);
    document.add(logo);
    logo = null;
    
    float[] columSize7 = {25F, 10F, 10F, 15F, 10F, 30F};
    table = new PdfPTable(columSize7);
    table.setWidthPercentage(100f);	 
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);

    cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(6);
    table.addCell(cell);
    cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(6);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Tratamiento Realizado", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Cantidad", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Piezas", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Tarifa Unitaria", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);

    cell = ToolPdf.makeCell("Total", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Observaciones", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Exodoncia", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Amalgama", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Luz Halógena", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Profilaxis", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Rx.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Endodoncia", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
     cell = ToolPdf.makeCell("Otros Tt.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=5; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    for(int i=1; i<=12; i++)
    {
        cell = ToolPdf.makeCell("TTT", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFontWhite, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
       
    document.add(table);
    table = null;
    border = null;
    cell = null;  
    
    
    float[] columSize8 = {15F, 10F, 30F};
    table = new PdfPTable(columSize8);
    table.setWidthPercentage(55f);	 
    table.setHorizontalAlignment(Element.ALIGN_RIGHT);
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);
    
    cell = ToolPdf.makeCell("Sub Total", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("IGV", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Total", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Deducible", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Coaseguro", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell("Total", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
    table.addCell(cell);
    
    for(int i=1; i<=2; i++)
    {
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, borderWidth);      
        table.addCell(cell);
    }
    
    document.add(table);
    table = null;
    border = null;
    cell = null;  
    
    
  logo = Image.getInstance(Constante.getConst("LOGO"));              
  //logo = Image.getInstance("D:\\Oliver\\Web Clinica\\logoN.jpg");    
  
  logo.scaleAbsolute(90,30f);
  logo.setAlignment(Image.ALIGN_LEFT); 
  
  /*Font tableFont = FontFactory.getFont("Arial", 11);
  Font  tableFontWhite = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.WHITE);
    
  //Document document = new Document();  
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  Paragraph pContent = null;
  PdfWriter writer = PdfWriter.getInstance (document,buffer);
  document.open();*/
  
  document.newPage();
  document.add(logo);  
  
  pContent = new Paragraph("Pag. 2/2",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_RIGHT);
  document.add(pContent);    
  
  pContent = new Paragraph("SOLICITUD DE BENEFICIO DENTAL" + "\n\n",FontFactory.getFont("Arial", 13, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_CENTER);
  document.add(pContent);
  
  
/*Cabecera*/
   table = null;
  float[] columSize9 = {18F, 20F, 20F, 17F};
  table = new PdfPTable(columSize9);
	table.setWidthPercentage(100f);	    
  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Nro de Autorización :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    if(intFlgConti==1){      
        cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11), tableFont.size() * 1.2f, 2f, border, true, true);  
        table.addCell(cell);
        
        cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_RIGHT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
        cell.setColspan(2);
        table.addCell(cell);                
    }else{                  
        cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11), tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(3);
        table.addCell(cell);
    }        
    
    
    cell = ToolPdf.makeCell("Fecha :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    if(!strFecha.equals(""))
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy",fechaReg)   + "    válida al   " + Tool.addDate(6,"dd/MM/yyyy",fechaReg) , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
  
    }
    else
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy") + "    válida al   " + Tool.addDate(6,"dd/MM/yyyy"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }
    
    
    cell.setColspan(3);
    table.addCell(cell);

    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("Contratante:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }else{    
       cell = ToolPdf.makeCell("Clínica / Centro Médico:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    }    
    
    table.addCell(cell);
    cell = ToolPdf.makeCell(strNomClinica, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
  
    document.add(table);
    table = null;
    border = null;
    cell = null;    
  
            /*-------------AGREGANOD LA LINEA-------------- */
    float[] columSize11 = {2F,2F,2F,2F};
    table = new PdfPTable(columSize11);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f, 0f, 0f);    
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);    
    cell.setBorderWidthBottom(1);
    table.addCell(cell);
    
    document.add(table);
    table = null;
    border = null;
    cell = null;
    /*---------------------------------------------- */  
    
    float[] columSize5 = {50F, 50F};
    table = new PdfPTable(columSize5);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);  
  
    
    
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Certifico que todas las respuestas y declaraciones antes mencionadas, son verídicas y ajustadas a la realidad. Autorizo a la Clínica, así como a los Médicos tratantes, para que suministre a la Positiva Seguros y Reaseguros, cualquier información, datos del archivo médico, exámenes, etc. Dispensándolos del secreto profesional.", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    
    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("Firma y sello del médico tratante\nCPO:\nTeléfono:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Firma del paciente", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    cell.setBorderWidthBottom(1);
    table.addCell(cell);
    
    document.add(table);
    table = null;
    border = null;
    cell = null;
    

 /*Llenado por el médico*/
  pContent = new Paragraph("Para ser completado por el Médico Auditor\n",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
  pContent.setAlignment(Element.ALIGN_LEFT);
  document.add(pContent);
  document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
  float[] columSize6 = {50F, 50F};
  table = new PdfPTable(columSize6);
	table.setWidthPercentage(100f);	    
  tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
  border = new Rectangle(0f, 0f);
  
    cell = ToolPdf.makeCell("Aprobado   _______________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Observado  _______________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);

    cell = ToolPdf.makeCell("Fecha      _________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Firma y sello del médico auditor", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;
    
  
  if (usuario !=null){
    if (usuario.getIntIdRol() != Constante.NROPERFILBRK)
      writer.addJavaScript("this.print(true);", false);
  }
  else writer.addJavaScript("this.print(true);", false);
  
    document.close();

    DataOutput output = new DataOutputStream(response.getOutputStream());
    byte[] bytes = buffer.toByteArray();
    response.setContentLength(bytes.length);
    for(int i=0;i<bytes.length;i++){
      output.writeByte(bytes[i]);  
    }
 

%>


