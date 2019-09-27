<%@ page language="java" import="javazoom.upload.*,java.util.*" %>    <!--Cambio QNET 28/12/11-->
<%@ page contentType="application/pdf"%>
<%@ page import="java.io.*"%>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.awt.Color"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.controller.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.MalformedURLException"%>
<% boolean createsubfolders = true; %>                                <!--Cambio QNET 28/12/11-->
<% boolean allowresume      = true; %>                                <!--Cambio QNET 28/12/11-->
<% boolean allowoverwrite   = true; %>                                <!--Cambio QNET 28/12/11-->
<% String encoding          = "ISO-8859-1"; %>                        <!--Cambio QNET 28/12/11-->
<% boolean keepalive        = false; %>                               <!--Cambio QNET 28/12/11-->

<%

   //INI
   //***************** Direcciona carpeta_____Cambio QNET 28/12/11
   String directory = request.getSession().getServletContext().getRealPath("/imgasegurados/");
   String tmpdirectory = request.getSession().getServletContext().getRealPath("/imgasegurados/tmp");  
   //FIN
   //***************** Direcciona carpeta_____Cambio QNET 28/12/11   
%>


<%

    /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:26am*/    
    Atencion atencion = new Atencion();
    
    /*Instanciando la clase GestorPolClinic,para acceder a los Datos yahirRivas 29FEB2012 11:26am*/    
    GestorPolClinic gestorPolClinic = new GestorPolClinic();
    
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 11:25am
    GestorCliente gestorCliente = new GestorCliente();
    
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:31pm
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
    String strTextoCoaseguro= "(Serv. Adicionales)";
    int intLongExclusiones=98;
    int intLongDetDiagnostico=796;   
    String strCabeceraDiagnosticos = "";
    String strDetalleDiagnosticos = "";    

    //INI
    //************** Seteo de variables_________Cambio QNET 28/12/11
    String scadena_img   = "";
    String sfichero      = ""; 
    String stipo_archivo = ".jpg";
    boolean blFlag       = false;        
    int    intpolizax    = 0;
    int    intcertifx    = 0;
    String strCodAsex    = "";
    String spolizax      = "00000";
    String scertifx      = "00000";    
    //FIN
    //************** Seteo de variables_________Cambio QNET 28/12/11
    
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
    
    
    // REQ 2011-0490 BIT/FMG
       Bean objAtencion = atencion.getCliente_his(intPoliza, intCertif, strCodCliente,strWebServer, strNroautoriza,intRamo);
       
       Cliente objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);    
      
    //SSRS Se obtiene la cobertura seleccionada para la solicitud
    Cobertura objCobertura = null;
    // REQ 2011-0490 BIT/FMG
    ArrayList lstCobertura = gestorPolClinic.getLstCobertura_his(objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                            objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                            objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                            strCodCliente, objCliente.getIntCodEstado(), strNroautoriza,intRamo);
    
    for(int i=0; i<lstCobertura.size(); i++)
    {
        objCobertura = (Cobertura)lstCobertura.get(i);
        if (objCobertura.getIntCover() == Tool.parseInt(strCobertura))
        break;                  
    }

    
    
      
    String strCodEnf = "";  
    if (objCliente.getIntIndExcl()==1){
      //  ProcesoAtencion objRq = new ProcesoAtencion();

        BeanList objLstExcl = new BeanList();
        objLstExcl = atencion.getLstExclusion(objCliente.getIntPoliza(),objCliente.getIntCertificado(),objCliente.getStrCodigo(),intRamo);
        Exclusion objExclusion = null;
        for(int i=0;i<objLstExcl.size();i++){
            objExclusion = new Exclusion();
            objExclusion = (Exclusion)objLstExcl.get(i);
            if (!"".equals(strCodEnf)) strCodEnf = strCodEnf + ", ";
            strCodEnf = strCodEnf + objExclusion.getStrCodEnfermedad().trim() + " - " + objExclusion.getStrDescripcion().trim();
        }
    }        

    
    String strCabDiagnostico1 = "";
    String strDetDiagnostico1 = "";  
    String strCabDiagnostico2 = "";
    String strDetDiagnostico2 = "";  
    

    BeanList objLstCabDiagnostico1 = new BeanList();
    objLstCabDiagnostico1 = atencion.getLstDiagnosticosCabecera(1,1,1);
    DiagnosticoCabecera objDiagCab1 = null;
    for(int i=0;i<objLstCabDiagnostico1.size();i++){
        objDiagCab1 = new DiagnosticoCabecera();
        objDiagCab1 = (DiagnosticoCabecera)objLstCabDiagnostico1.get(i);
        strCabDiagnostico1 = strCabDiagnostico1 + objDiagCab1.getStrDescripcion().trim();
    }
    
    BeanList objLstDetDiagnostico1 = new BeanList();
    objLstDetDiagnostico1 = atencion.getLstDiagnosticosDetalle(1,1,1);
    DiagnosticoDetalle objDiagDet1 = null;
    for(int i=0;i<objLstDetDiagnostico1.size();i++){
        objDiagDet1 = new DiagnosticoDetalle();
        objDiagDet1 = (DiagnosticoDetalle)objLstDetDiagnostico1.get(i);
        if (!"".equals(strDetDiagnostico1)) strDetDiagnostico1 = strDetDiagnostico1 + " - ";
        strDetDiagnostico1 = strDetDiagnostico1 + objDiagDet1.getStrDescripcion().trim();
    }    
    
    
    BeanList objLstCabDiagnostico2 = new BeanList();
    objLstCabDiagnostico2 = atencion.getLstDiagnosticosCabecera(1,1,2);
    DiagnosticoCabecera objDiagCab2 = null;
    for(int i=0;i<objLstCabDiagnostico2.size();i++){
        objDiagCab2 = new DiagnosticoCabecera();
        objDiagCab2 = (DiagnosticoCabecera)objLstCabDiagnostico2.get(i);
        strCabDiagnostico2 = strCabDiagnostico2 + objDiagCab2.getStrDescripcion().trim();
    }
    
    BeanList objLstDetDiagnostico2 = new BeanList();
    objLstDetDiagnostico2 = atencion.getLstDiagnosticosDetalle(1,1,2);
    DiagnosticoDetalle objDiagDet2 = null;
    for(int i=0;i<objLstDetDiagnostico2.size();i++){
        objDiagDet2 = new DiagnosticoDetalle();
        objDiagDet2 = (DiagnosticoDetalle)objLstDetDiagnostico2.get(i);
        if (!"".equals(strDetDiagnostico2)) strDetDiagnostico2 = strDetDiagnostico2 + " - ";
        strDetDiagnostico2 = strDetDiagnostico2 + objDiagDet2.getStrDescripcion().trim();
    }        


    // AVM : variable para la continuidad es el campo continuity
    // con Continuidad = 'S'
    // sin Continuidad = 'N'    
    String strCodContin =  objCliente.getStrContinuidadInx().substring(0);
    int intFlgConti = 0;    

    
    //SSRS Flag que permite validar la continuidad de poliza .Si la fecha de ingreso empieza en 02 si hay continuidad de poliza
    if(strCodContin.equals("S")==true)
        intFlgConti = 1;    
    
    //SSRS Obtención del tiempo de carencia
    DateDiff dateDiffCarencia = null;
    try
    {
        dateDiffCarencia = new DateDiff(Tool.getDate("dd/MM/yyyy"),objCliente.getStrFecInicioVigencia());
        dateDiffCarencia.calculateDifference();
    }
    catch(Exception e)
    {
       e.printStackTrace(); 
    }
    
    int intMeses = Tool.parseInt(String.valueOf(dateDiffCarencia.getMonth()));    
    
    
    if (objCobertura.getIntCoverGen()==138){
        strCabeceraDiagnosticos = strCabDiagnostico2;
        strDetalleDiagnosticos = strDetDiagnostico2;
    }else{    
        if (intFlgConti==0 && intMeses<10 && objCliente.getIntFlgRenov()==0){
            strCabeceraDiagnosticos = strCabDiagnostico1;
            strDetalleDiagnosticos = strDetDiagnostico1;
        }    
    }    

   
      //strCodEnf="11";     
    
        /*strDetalleDiagnosticos="12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901" +
                                 "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123412345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234";    */
    

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

    
    
    Date dtFechaNac = null;
    try
    {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy"); 
        dtFechaNac = sdf.parse(objCliente.getStrFecNac());    
    }
    catch(Exception e1)
    {
        e1.printStackTrace();
    }
    
    Poliza objPoliza = gestorPolClinic.getPoliza(intRamo,objCliente.getIntPoliza(),0);

    

    
   
    Cobertura objCoberturaFarm = null;
    boolean blnFarmacia = false;
    int intContCover = 0;
    while(intContCover < lstCobertura.size() && blnFarmacia==false)
    {
        objCoberturaFarm = ((Cobertura)lstCobertura.get(intContCover));
        if(objCoberturaFarm.getIntConceptoPago() == 17 && objCobertura.getIntCoverGen() == objCoberturaFarm.getIntCoverGen())
            blnFarmacia = true;
            intContCover++; 
    }
    
    //Recuperamos la farmacia de la tabla: prod_am_bil 
    if(blnFarmacia==false){
       int intContConProd = 0;
       int intConceptoValor=17;
       ConceptoProducto objConProd = null;              
       ArrayList lstConProd = gestorPolClinic.getLstConceptoProducto(objPoliza.getIntBranch(),
                                                                     intPoliza,
                                                                     intConceptoValor,
                                                                     objCobertura.getIntTipoAtencion(),
                                                                     objCobertura.getIntCover(),
                                                                     objCliente.getIntCodPlan(),
                                                                     objCliente.getStrFecIngreso());    
    
       while(intContConProd < lstConProd.size() && blnFarmacia==false){
            objConProd = ((ConceptoProducto)lstConProd.get(intContConProd));
            if(objConProd.getDblRatio2()>0){            
               blnFarmacia = true;
            }
             intContConProd++; 
       }
       
       if (blnFarmacia==true){
           objCoberturaFarm.setStrCoaseguro(String.valueOf(objConProd.getDblRatio2()));
       }        
    }
    
    
    Image logo = Image.getInstance(Constante.getConst("LOGO"));    
    //Image logo = Image.getInstance("D:\\Oliver\\Web Clinica\\logo.jpg");
    //Image logo = Image.getInstance("Y:\\logoN.jpg");
    

    logo.scaleAbsolute(80,30f);
    logo.setAlignment(Image.ALIGN_LEFT);    
    
    Font tableFont = FontFactory.getFont("Arial", 11);
    Font tableFontBold = FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK);
    Font commentFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
  
    Document document = new Document();  
    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
    Paragraph pContent = null;
    PdfWriter writer = PdfWriter.getInstance (document,buffer);
    document.open();   
    
    document.add(logo);   
    
    ////////////////////////////////////////////////////NUEVA PAGINA////////////////////////////////////////////////////
    /*if((strCodEnf.length() > intLongExclusiones) || (strDetalleDiagnosticos.length() > intLongDetDiagnostico))
    { */ 
       pContent = new Paragraph("Pag. 1/2",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
       pContent.setAlignment(Element.ALIGN_RIGHT);       
       document.add(pContent);
       
    /*}*/
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    pContent = new Paragraph("SOLICITUD DE BENEFICIO" + "\n\n",FontFactory.getFont("Arial", 14, Font.BOLD, Color.BLACK));     
    pContent.setAlignment(Element.ALIGN_CENTER);    
    //pContent.ALIGN_TOP = 10;
    document.add(pContent);
  
    /*Cabecera*/
    PdfPTable table = null;
    //float[] columSize = {22F, 40F, 16F, 15F};
    float[] columSize = {20F, 20F, 10F, 10F};
    table = new PdfPTable(columSize);
    table.setWidthPercentage(100f);	    
    Rectangle border = new Rectangle(5f, 5f);
      
    PdfPCell cell = null;  
    
    /*
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    */
    /*
    cell = ToolPdf.makeCell("Nro de Autorización   : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);              
    
    cell = ToolPdf.makeCell("Fecha :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    if(!strFecha.equals(""))
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy",fechaReg)   + "    válida al :   " + Tool.addDate(6,"dd/MM/yyyy",fechaReg) , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);          
        cell.setColspan(7);
    }
    else
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy") + "    válida al : " + Tool.addDate(6,"dd/MM/yyyy"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(7);        
    }
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Cobertura                      : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);      
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCobertura.getStrNomCobertura(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);


    if(intFlgConti==1){
        cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);                          
        table.addCell(cell);    
        
        cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(7);
        table.addCell(cell);        
        }
    else
    {
        cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
       cell.setColspan(7);
        table.addCell(cell);
    }
        
    //Validando si es del minisetrio de vivienda    
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("Contratante:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);             
       table.addCell(cell);
    }else{    
       cell = ToolPdf.makeCell("Clínica / Centro Médico :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
       table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell(strNomClinica, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);
    */

    /* P 2012 - 0048 Codigo Barras */
    PdfContentByte cb = writer.getDirectContent();
    Image imgbarcode = ToolPdf.getBarCode(strNroautoriza).createImageWithBarcode(cb,Color.BLACK,Color.WHITE);
    imgbarcode.setAbsolutePosition(495f,690f);
    document.add(imgbarcode);
    /* P 2012 - 0048 Codigo Barras */

    cell = ToolPdf.makeCell("Nro de Autorización   : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);              
    
    cell = ToolPdf.makeCell("Fecha :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    if(!strFecha.equals(""))
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy",fechaReg)   + "    válida al :   " + Tool.addDate(6,"dd/MM/yyyy",fechaReg) , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);          
        cell.setColspan(7);
    }
    else
    {
        cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy") + "    válida al : " + Tool.addDate(6,"dd/MM/yyyy"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(7);        
    }
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Cobertura                      : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);      
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCobertura.getStrNomCobertura(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);


    if(intFlgConti==1){
        cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);                          
        table.addCell(cell);    
        
        cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
        cell.setColspan(7);
        table.addCell(cell);        
        }
    else
    {
        cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
       cell.setColspan(7);
        table.addCell(cell);
    }
        
    //Validando si es del minisetrio de vivienda    
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("Contratante:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);             
       table.addCell(cell);
    }else{    
       cell = ToolPdf.makeCell("Clínica / Centro Médico :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
       table.addCell(cell);
    }
    
    cell = ToolPdf.makeCell(strNomClinica, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
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
    
    //Req 2011-1044
    
    String codContrat = "";
    Bean objContratante = gestorPolClinic.getContratante(objCliente.getIntPoliza(), objCliente.getIntCertificado());
    
    codContrat = objContratante.getString("1").substring(0,1);
    String strContratante = "";
    if(codContrat.equals("E"))
    {
      strContratante = "Contratante:      " + objCliente.getStrContratante();
      pContent = new Paragraph(strContratante,FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK)); 
      pContent.setAlignment(Element.ALIGN_LEFT);
      document.add(pContent);
    }
    
    //Fin Req 2011-1044
    /*Contratante*/
    pContent = new Paragraph("Información del Titular",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
    pContent.setAlignment(Element.ALIGN_LEFT);
    document.add(pContent);
    document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
    float[] columSize1 = {40F, 10F, 10F, 10F, 20F, 15F, 15F, 15F};
    table = new PdfPTable(columSize1);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);
    
    cell = ToolPdf.makeCell("Apellidos y Nombres :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrNombreTitular(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Contrato :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntPoliza()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
    cell = ToolPdf.makeCell("Certificado :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(String.valueOf(objCliente.getIntCertificado()), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell("Plan :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrPlan(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Fecha de Ingreso a la póliza:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrFecIngreso(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
    cell = ToolPdf.makeCell("Producto :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objPoliza.getStrDesProduct(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(3);
    table.addCell(cell);
  
    document.add(table);
    table = null;
    border = null;
    cell = null;  
    //INI 
    //*************** Definir fichero de archivo ,importante para verificar la ubicacion del archivo_____Cambio QNET 28/12/11    
    intpolizax = objCliente.getIntPoliza();
    intcertifx = objCliente.getIntCertificado();
    strCodAsex = objCliente.getStrCodigo();
    
    //sfichero = directory + "/" + intpolizax  +"-"+ intcertifx + ".jpg";
    sfichero = directory + "/" + intpolizax  +"-"+ intcertifx + "-" + strCodAsex + ".jpg";
    File fichero = new File(sfichero);    
    //FIN
    //*************** Definir fichero de archivo ,importante para verificar la ubicacion del archivo_____Cambio QNET 28/12/11
  
    /*Asegurado*/
    pContent = new Paragraph("Información del Paciente\n",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
    pContent.setAlignment(Element.ALIGN_LEFT);
    document.add(pContent);
    document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
    float[] columSize2 = {35F, 20F, 20F, 10F, 15F, 20F, 20F, 15F};
    table = new PdfPTable(columSize2);
    table.setWidthPercentage(100f);
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f);

    cell = ToolPdf.makeCell("Apellidos y Nombres :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);            
    table.addCell(cell);
    cell = ToolPdf.makeCell((objCliente.getStrNombreAseg()!=null?objCliente.getStrNombreAseg().trim():"FALTA DATO"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);
    
    //INI 
    //*************** Definir existencia de fichero de archivo,ordenar para que 
    //*************** deje espacio para la imagen del asegurado 
    //*************** validacion de mostrar imagen por defecto_____Cambio QNET 28/12/11
    scadena_img = "";    
    if (fichero.exists())        
        {       
        //scadena_img = directory + "/" + intpolizax  +"-"+ intcertifx + ".jpg";        
        scadena_img = directory + "/" + intpolizax  +"-"+ intcertifx + "-" + strCodAsex + ".jpg";        
        blFlag = true;         
        }
    else
        {
        scadena_img = directory + "/" + spolizax  +"-"+ scertifx + ".jpg";        
        blFlag = false;         
        } 
        
    if (blFlag = true){             
        Image Asegurado = Image.getInstance(scadena_img);  
        Asegurado.scaleToFit((float) 100f, (float) 100f);    
        Asegurado.setAbsolutePosition(470f,460f);             
        Asegurado.setAlignment(Image.ALIGN_RIGHT);           
        document.add(Asegurado);    
    }   
    if (blFlag = false){             
        Image Asegurado = Image.getInstance(scadena_img);  
        Asegurado.scaleToFit((float) 100f, (float) 100f);    
        Asegurado.setAbsolutePosition(470f,460f);     
        Asegurado.setAlignment(Image.ALIGN_RIGHT);           
        document.add(Asegurado);    
    }
    
    cell = ToolPdf.makeCell("Fecha de Nacimiento :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell((dtFechaNac!=null?objCliente.getStrFecNac():"FALTA DATO"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);
    cell = ToolPdf.makeCell("Edad :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell((dateDiff!=null?String.valueOf(dateDiff.getYear()):"FALTA DATO"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);    
    cell = ToolPdf.makeCell("Sexo :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrSexo(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);
    
    
    cell = ToolPdf.makeCell("Parentesco :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(objCliente.getStrParentesco() , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);
    table.addCell(cell);    
  
    //FIN
    //*************** Definir existencia de fichero de archivo,ordenar para que 
    //*************** deje espacio para la imagen del asegurado 
    //*************** validacion de mostrar imagen por defecto_____Cambio QNET 28/12/11   
    
    String strDeducible = "0";
    
    if(blnFarmacia==true){    
        if(Tool.parseDouble(objAten.getString("12"))>0)
            strDeducible = Tool.toDecimal(Tool.parseDouble(objAten.getString("12")),2) + " " + objCliente.getStrMoneda().toUpperCase();
        else if (Tool.parseDouble(objAten.getString("13"))>0)
                strDeducible = Tool.toDecimal(Tool.parseDouble(objAten.getString("13")),2) + " %";        
    }else{         
        if(Tool.parseDouble(objAten.getString("12"))>0)
            strDeducible = Tool.toDecimal(Tool.parseDouble(objAten.getString("12")),2) + " " + objCliente.getStrMoneda().toUpperCase();
        else if (Tool.parseDouble(objAten.getString("13"))>0)
                strDeducible = Tool.toDecimal(Tool.parseDouble(objAten.getString("13")),2) + " %";    
    }
    
    
    cell = ToolPdf.makeCell("Deducible :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);    
    
    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);   
    }else{    
       cell = ToolPdf.makeCell(strDeducible, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);   
    }    
    
    cell.setColspan(7); 
    table.addCell(cell);
   
    cell = ToolPdf.makeCell("Coaseguro :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);

    //Validando si es del minisetrio de vivienda
    if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
       cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    }else{    
       cell = ToolPdf.makeCell(objAten.getString("14") + " %", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
    }    
    
       
    int[] widths = {22, 18, 15, 7, 10, 10, 10, 6};
    table.setWidths(widths);          

    table.addCell(cell);    
    
    
    if(blnFarmacia==true)
    {
        cell = ToolPdf.makeCell("Coaseguro Farmacia:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);          
        cell.setColspan(2);
        table.addCell(cell);
        
        //Validando si es del minisetrio de vivienda
        if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
           cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);           
        }else{    
           cell = ToolPdf.makeCell(objCoberturaFarm.getStrCoaseguro() + " %", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);           
        }    
        
        cell.setColspan(6);
        table.addCell(cell);
    }else{        
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);  
        table.addCell(cell);
        cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 2f, border, true, true);   
        cell.setColspan(5); 
        table.addCell(cell);        
    }        

    
    cell = ToolPdf.makeCell("Exclusiones :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    table.addCell(cell);
    cell = ToolPdf.makeCell(strCodEnf, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(7);     
    table.addCell(cell);

    
    
    document.add(table);
    table = null;
    border = null;
    cell = null;  
  
    /*Llenado por el médico*/
    pContent = new Paragraph("Para ser completado por el Médico Tratante\n",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
    pContent.setAlignment(Element.ALIGN_LEFT);
    document.add(pContent);
    document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
    float[] columSize4 = {25F,25F,25F,25F};
    table = new PdfPTable(columSize4);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f, 0f, 0f);
    
   
    
    cell = ToolPdf.makeCell("Síntomas y signos que presenta el paciente :  ________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("_____________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("_____________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
      
    cell = ToolPdf.makeCell("Tiempo de enfermedad   ______________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFontBold, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("F.U.R. (femenino)   _________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    document.add(table);
    table = null;
    border = null;
    cell = null;
  
    float[] columSize5 = {25F,25F,25F,25F};
    table = new PdfPTable(columSize5);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    
    border = new Rectangle(0f, 0f, 0f, 0f);
  
    cell = ToolPdf.makeCell("Diagnóstico(s) CIE10 :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 5f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("1) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("2) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("3) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    //cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    //cell.setColspan(4);
    //table.addCell(cell);
    
    
    cell = ToolPdf.makeCell("¿Ordenó exámenes médicos?  Si _______        No _______", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("¿Cuales? ____________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    //cell = ToolPdf.makeCell("_____________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    //cell.setColspan(4);
    //table.addCell(cell);
  
    cell = ToolPdf.makeCell("_____________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Tratamiento :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 5f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("1) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
  
    cell = ToolPdf.makeCell("2) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("3) __________________________________________________________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    
    cell = ToolPdf.makeCell("Nro Consultas atendidas   ____________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Fecha                     _________________________ ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Médico Tratante                ____________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Especialidad           _________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    /*
    cell = ToolPdf.makeCell("\n\n", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    */
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 6f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("       Firma y Sello del Médico Tratante", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Fecha : __________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);   
    /*
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    */
    cell = ToolPdf.makeCell("CMP : __________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Telef : __________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);   

    
    document.add(table);
    table = null;
    border = null;
    cell = null;
    
    
     ////////////////////////////////////////////////////NUEVA PAGINA////////////////////////////////////////////////////
      /*  if((strCodEnf.length() > intLongExclusiones))//Nueva página
        {    */
              document.newPage();
              
              document.add(logo);

              pContent = new Paragraph("Pag. 2/2",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK)); 
              pContent.setAlignment(Element.ALIGN_RIGHT);
              document.add(pContent);
              
              pContent = new Paragraph("SOLICITUD DE BENEFICIO" +  "\n\n",FontFactory.getFont("Arial", 14, Font.BOLD, Color.BLACK)); 
              pContent.setAlignment(Element.ALIGN_CENTER);
              document.add(pContent);               
              
              /*Cabecera*/
              float[] columSize8 = {22F, 40F, 16F, 15F};
              table = new PdfPTable(columSize8);
              table.setWidthPercentage(100f);	    
              border = new Rectangle(5f, 5f);
                            
              /*  
              cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              cell.setColspan(4);
              table.addCell(cell);              
              */
              
              /* P 2012 - 0048 Codigo Barras */
              document.add(imgbarcode);
              /* P 2012 - 0048 Codigo Barras */


              cell = ToolPdf.makeCell("Nro de Autorización   : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
              table.addCell(cell);
              cell = ToolPdf.makeCell(strNroautoriza, Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);  
              cell.setColspan(7);
              table.addCell(cell);              
              
              cell = ToolPdf.makeCell("Fecha :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              table.addCell(cell);
              if(!strFecha.equals(""))
              {
              cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy",fechaReg)   + "    válida al :   " + Tool.addDate(6,"dd/MM/yyyy",fechaReg) , Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);          
              cell.setColspan(7);
              }
              else
              {
              cell = ToolPdf.makeCell(Tool.getDate("dd/MM/yyyy") + "    válida al : " + Tool.addDate(6,"dd/MM/yyyy"), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              cell.setColspan(7);        
              }
              table.addCell(cell);
              
              cell = ToolPdf.makeCell("Cobertura                      : ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);      
              table.addCell(cell);
              cell = ToolPdf.makeCell(objCobertura.getStrNomCobertura(), Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              table.addCell(cell);
              
              
              if(intFlgConti==1){
              cell = ToolPdf.makeCell("Continuidad", Element.ALIGN_TOP, Element.ALIGN_LEFT, FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK), tableFont.size() * 1.2f, 3f, border, true, true);                          
              table.addCell(cell);    
              
              cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              cell.setColspan(7);
              table.addCell(cell);        
              }
              else
              {
              cell = ToolPdf.makeCell(" ", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              cell.setColspan(7);
              table.addCell(cell);
              }
              
              //Validando si es del minisetrio de vivienda    
              if (usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV){    
              cell = ToolPdf.makeCell("Contratante:", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);             
              table.addCell(cell);
              }else{    
              cell = ToolPdf.makeCell("Clínica / Centro Médico :", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              table.addCell(cell);
              }
              
              cell = ToolPdf.makeCell(strNomClinica, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
              cell.setColspan(7);
              table.addCell(cell);          
              
              
              document.add(table);
              table = null;
              border = null;
              cell = null;                          
        /*}*/
    
            /*-------------AGREGANOD LA LINEA-------------- */
    float[] columSize12 = {2F,2F,2F,2F};
    table = new PdfPTable(columSize12);
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
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////      
    
    float[] columSize9 = {25F,25F,25F,25F};
    table = new PdfPTable(columSize9);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    
    border = new Rectangle(0f, 0f, 0f, 0f);    
    
    
  
    cell = ToolPdf.makeCell("\n",Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Certifico que todas las respuestas y declaraciones antes mencionadas, son verídicas y ajustadas a la realidad.",
           Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Autorizo a la Clínica u Hospital, así como a los Médicos tratantes, enfermeras y proveedores que poseen la información concerniente al paciente para que suministre a la Positiva Seguros y Reaseguros, cualquier información, datos del archivo médico, exámenes de laboratorio, etc.",
           Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4); 
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("\n\n",Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);

    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2); 
    table.addCell(cell);

    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2); 
    table.addCell(cell);
          
    cell = ToolPdf.makeCell("           Firma del Paciente y/o Titular", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2); 
    table.addCell(cell);

    cell = ToolPdf.makeCell("\n",Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);

    document.add(table);
    table = null;
    border = null;
    cell = null;    
  
    /*---------------------------------------PINTA LOS DIAGNOSTICOS---------------------------------------*/  
     if ((strCabeceraDiagnosticos != "") && (strDetalleDiagnosticos != "")){
      
          float[] columSize7 = {50F, 50F};
          table = new PdfPTable(columSize7);
          table.setWidthPercentage(100f);	   
          table.getDefaultCell().setBorderWidth(10);
          table.getDefaultCell().setBorderColor(Color.BLACK);
          tableFont = FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK);
          border = new Rectangle(1f, 1f);
          cell = ToolPdf.makeCell(strCabeceraDiagnosticos, Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 5f, border, true, true, Color.BLACK, (float)0.5);  
          
          cell.setColspan(2);
          table.addCell(cell);
        
          cell = ToolPdf.makeCell(strDetalleDiagnosticos, Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true, Color.BLACK, (float)0.5);  
          cell.setColspan(2);
          table.addCell(cell);
          
          cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
          cell.setColspan(4); 
          table.addCell(cell);                                   
     
      
          document.add(table);
          table = null;
          border = null;
          cell = null;        
      
      }                            
    /*----------------------------------------------------------------------------------------------------*/ 
    
    
    float[] columSize11 = {2F,2F,2F,2F};
    table = new PdfPTable(columSize11);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f, 0f, 0f); 
    
    cell = ToolPdf.makeCell("Las facturas por crédito deberán ser enviadas a LA POSITIVA en un plazo no mayor a treinta días (30) después de la fecha de ocurrencia. De faltar alguna otra información sustentatoria, La Positiva se reserva el derecho de solicitar la misma por medio de una carta para la respectiva evaluación. La Solicitud de Beneficios debe de venir debidamente llenada y firmada por el médico tratante. Asimismo, consignar la firma del asegurado.\n", 
                              Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell); 
    
    cell = ToolPdf.makeCell("Para cualquier consulta sírvase llamar al 211-0-211 Línea Positiva Salud y en provincias al 0800-1-0800.\n", 
                              Element.ALIGN_TOP, Element.ALIGN_LEFT, commentFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);   
    
    document.add(table);
    table = null;
    border = null;
    cell = null;     
    
  
    /*Llenado por el médico auditor*/
    
    /*-------------AGREGANOD LA LINEA-------------- */
    float[] columSize09 = {2F,2F,2F,2F};
    table = new PdfPTable(columSize09);
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
  
    pContent = new Paragraph("Para ser completado por el Médico Auditor\n",FontFactory.getFont("Arial", 11, Font.BOLD, Color.BLACK));   
    pContent.setAlignment(Element.ALIGN_LEFT);
    document.add(pContent);
    document.add(new Paragraph("\n",FontFactory.getFont("Arial",11)));
    
    float[] columSize6 = {25F,25F,25F,25F};
    table = new PdfPTable(columSize6);
    table.setWidthPercentage(100f);	    
    tableFont = FontFactory.getFont("Arial", 11, Font.NORMAL, Color.BLACK);
    border = new Rectangle(0f, 0f, 0f, 0f);
  
    cell = ToolPdf.makeCell("Aprobado    _______________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("Observado  _______________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(4);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("Fecha         ________________________________", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 4f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("__________________________________", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
  
    cell = ToolPdf.makeCell("", Element.ALIGN_TOP, Element.ALIGN_LEFT, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
    
    cell = ToolPdf.makeCell("VºBº Firma y sello del médico auditor", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(2);
    table.addCell(cell);
      
    cell = ToolPdf.makeCell("\n", Element.ALIGN_TOP, Element.ALIGN_CENTER, tableFont, tableFont.size() * 1.2f, 2f, border, true, true);  
    cell.setColspan(4);
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
   // writer.addJavaScript("this.print(true);", false);
    document.close();
    
      response.setHeader("Expires", "0");
      response.setHeader("Cache-Control","must-revalidate, post-check=0, pre-check=0");
      response.setHeader("Pragma", "public");
      response.setContentType("application/pdf");
      response.setContentLength(buffer.size());
      OutputStream os = response.getOutputStream();
      buffer.writeTo(os);
      os.flush();
      os.close();
    
    //DataOutput output = new DataOutputStream(response.getOutputStream());
    //byte[] bytes = buffer.toByteArray();
    //response.setContentLength(bytes.length);
    
    //for(int i=0;i<bytes.length;i++)
    //{
    //    output.writeByte(bytes[i]);  
    //}
   

%>

