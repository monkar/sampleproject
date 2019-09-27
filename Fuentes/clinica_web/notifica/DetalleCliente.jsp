<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.io.*"%>   <!--Cambio QNET 28/12/11-->

<%

 //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 11:18am
 GestorCliente gestorCliente = new GestorCliente();

 Usuario usuario = null;
  synchronized(session)
  {
     usuario = (Usuario)session.getAttribute("USUARIO");     
  }  
    
    Cliente objCliente = new Cliente();
    String strContinuidad = "";
    String strCont     = "";
    int    policy      = 0;
    int    certif      = 0;
    String cliente     = "";
    int    flagSession = 1;    
    String strCodAseg     = "";
    String codClienteFRM = "";
    //INI
    //**************** Cambio QNET 28/12/11
    String sruta           = "";
    //CAMBIO QNET - WILLY NAPA
    /*
    String scadena         = "";
    String scadena_sinimg  = ""; 
    */
    //FIN CAMBIO QNET - WILLY NAPA
    String stipo_archivo   = ".jpg";
    String sPolizax        = "00000";
    String sCertifx        = "00000";            
    String sFichero        = "";    
    String strDiasCarencia = "";
    String strProducto = "";
    String ret             = "N";
    boolean intXtra        = false; 
    //FIN
    //**************** Cambio QNET 28/12/11
  synchronized(session)
  {
    if (session.getAttribute("DatoCliente")!=null)
    {
      codClienteFRM = Tool.getString(request.getParameter("codStrCliente"));
      
      
      objCliente = (Cliente)session.getAttribute("DatoCliente");
      
      
        // AVM : variable para la continuidad es el campo continuity
        // con Continuidad = 'S'
        // sin Continuidad = 'N'        
        
        //INI
        //*****************Definir objetos de poliza,certificado______Cambio QNET 28/12/11
        //CAMBIO QNET - WILLY NAPA
        //scadena         = "";
        //FIN CAMBIO QNET - WILLY NAPA
        sruta           = ""; 
        policy          = 0;
        certif          = 0;  
        strCodAseg      = "";
        sruta           = request.getSession().getServletContext().getRealPath("/imgasegurados/"); 
        strContinuidad = (objCliente.getStrContinuidadInx().substring(0).equals("S")?"CONTINUIDAD":"");
        strCont = objCliente.getStrContinuidadInx().substring(0);
        
        policy     = objCliente.getIntPoliza();
        certif     = objCliente.getIntCertificado();
        strCodAseg = objCliente.getStrCodigo();
        cliente    = objCliente.getStrCodigo();
        //CAMBIO QNET - WILLY NAPA
        intXtra    = false;
        intXtra    = gestorCliente.getXstrata(policy); 
        //FIN CAMBIO QNET - WILLY NAPA
        //CAMBIO QNET - WILLY NAPA
        //scadena    = sruta + policy + "-" + certif + "-" + strCodAseg + stipo_archivo;                   
        //FIN CAMBIO QNET - WILLY NAPA
        
        ret = null;
        //CAMBIO QNET - WILLY NAPA
        if (intXtra ==true)
          {
           ret = "1";
           }
        else
          {
           ret = "2";
          }
        //FIN CAMBIO QNET - WILLY NAPA
        //FIN
        //*****************Definir objetos de poliza,certificado______Cambio QNET 28/12/11
        
       if(codClienteFRM.trim().equals(cliente.trim()))
        {
          flagSession = 1;
          strDiasCarencia = String.valueOf(objCliente.getIntDiasCarencia());
          strProducto = String.valueOf(objCliente.getIntProducto());
        }
        else
        {
          flagSession = 0;
          strDiasCarencia = "";
          strProducto = "";
          objCliente.setStrNombreAseg("");
          objCliente.setStrNombreTitular("");
          objCliente.setStrFecNac("");
          objCliente.setStrSexo("");
          objCliente.setStrParentesco("");
          objCliente.setStrFecFinCarencia("");
          objCliente.setStrContratante("");
          objCliente.setStrFecFinVigencia("");
          objCliente.setStrFecIngreso("");
          objCliente.setStrPlan("");
          objCliente.setStrEstado("");
          objCliente.setStrMoneda("");
        }
    }
  }      

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
<form name="frmDetalleCliente" method="post">  
<input type="hidden" name="hcnFlgAutoriza" value="0"/>
<input type="hidden" name="hcnContinuidad" value="<%=strCont%>"/>
<input type="hidden" name="hcnFlgVerImpresionSolBenef" value="0"/>
<!--//CAMBIO QNET - WILLY NAPA-->
<%if (intXtra == true){%>
<!--//FIN CAMBIO QNET - WILLY NAPA-->
  <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
    <tr>
      <td>
          <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
            <tr>
                    <td align="left" class="row1" width="20%" >Asegurado&nbsp;:&nbsp;</td>
                    <td align="left" class="row1" colspan=3 >
                    <input class="row5 input_text_sed" name="tctAsegurado" type="text" style="width:90%" readonly value="<%=objCliente.getStrNombreAseg()%>"/>
                    </td>
                    <!--Se incluyo esta funcionalidad para la llamada a CargaArchivo.jsp-->
                    <td rowspan=6 colspan = 3 align="center">                                                                                                   
                    </td>                          
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Titular&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3 width="20%">
                <input class="row5 input_text_sed" name="tctTitular" type="text" readonly style="width:90%" value="<%=objCliente.getStrNombreTitular()%>">
              </td>
                   
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Fec. Nacimiento&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" readonly  value="<%=objCliente.getStrFecNac()%>">
              </td>
              <td align="left" class="row1" width="20%">
                Parentesco&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" readonly  value="<%=objCliente.getStrParentesco()%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Sexo&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="15" readonly value="<%=objCliente.getStrSexo()%>">
              </td>
              <td align="left" class="row1" width="20%">
                Fecha Ingreso&nbsp;:&nbsp;
              </td>
                    
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" name="tctFechaIng" type="text" size="12" readonly value="<%=objCliente.getStrFecIngreso()%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Fec. Fin Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="12" readonly value="<%=objCliente.getStrFecFinCarencia()%>" name="hcdFinCarencia">
              </td>
              <td align="left" class="row1" width="20%">
                D&iacute;as Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" name="20" size="10" readonly value="<%=strDiasCarencia%>">
              </td>
              <td align="left" class="row1" width="20%">
                &nbsp;  
              </td>
              <td align="left" class="row1" width="20%">
                &nbsp;  
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Contratante&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3>
                <input class="row5 input_text_sed" type="text" style="width:90%" readonly value="<%=objCliente.getStrContratante()%>">
              </td>
              <td align="left" class="row1" width="15%" style="color:#FF3300">
                  &nbsp;
              </td>
              <td align="left" class="row1" width="15%">
                  &nbsp;
              </td>
            </tr>
            <tr>
                  <td align="left" class="row1" width="20%">
                    Fin de Vigencia&nbsp;:&nbsp;
                  </td>
                  <td align="left" class="row1" width="20%">
                    <input class="row5 input_text_sed" type="text" size="13" readonly value="<%=objCliente.getStrFecFinVigencia()%>">
                  </td>
              <!--//RQ2015-000750 INICIO//-->
              <td align="left" class="row1" width="20%">Correo&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="15%" colspan="2">
                <input type="hidden" name="hctCodCliente" value="<%=objCliente.getStrCodigo()%>"/>
                <input class="row5 input_text_sed" name = "tctemail" style="color:#FF3300;width:'88%';" type="text" size="20" maxlength="50" value="<%=objCliente.getStrEmail()%>">
              </td>
              <td align="left" class="row1" width="15%">              
                <A href="javascript:GrabarEmail()" class="btn_secundario lp-glyphicon lp-glyphicon-save-color">&nbspGrabar</A>                
              </td>
              <!--//RQ2015-000750 FIN//-->
            </tr>
            <tr>
                  <td align="left" class="row1" width="15%" >Plan&nbsp;:&nbsp;</td>              
                  <td align="left" class="row1" width="15%" >
                  <input class="row5 input_text_sed" name="tctPlan" readonly type="text" value="<%=objCliente.getStrPlan()%>"></td>
                  <td align="left" class="row1" width="15%">
                    Estado&nbsp;:&nbsp;
              </td>
                  <td align="left" class="row1" width="15%">
                    <input class="row5 input_text_sed" type="text" readonly value="<%=objCliente.getStrEstado()%>">
              </td>
              <td align="left" class="row1" width="20%">
              
              </td>
                  <td align="left" class="row1" width="20%">&nbsp;</td>
                  <td align="left" class="row1" width="20%">&nbsp;</td>
            </tr>
            <tr> 
                  <td align="left" class="row1" width="15%">
                      Moneda&nbsp;:&nbsp;
                  </td>
                  <td align="left" class="row1" width="15%">
                      <input class="row5 input_text_sed" type="text" readonly value="<%=objCliente.getStrMoneda()%>">
                  </td>                  
                  <td align="left" class="row1" width="15%">
                      Producto&nbsp;:&nbsp;
                  </td>
                  <td align="left" class="row1" width="15%">                    
                    <input class="row5 input_text_sed" type="text" readonly value="<%=strProducto%>">
                  </td>
              <td align="left" class="row1" width="15%">
              </td>
              <td align="left" class="row1" width="15%">
              </td>
                  </td>
                  <td align="left" class="row1" width="20%">&nbsp;</td>
            <tr>
      
          </table>
      </td>
    </tr>
    <td></td>
    <tr>
    </tr>
  </table>
<!--//CAMBIO QNET - WILLY NAPA-->
<!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!---->

<%}else{%> 
 <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
    <tr>
      <td>
          <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
            <tr>
              <td align="left" class="row1" width="20%" >Asegurado&nbsp;:&nbsp;</td>
              <td align="left" class="row1" colspan=3 >
              <input class="row5 input_text_sed" name="tctAsegurado" type="text" style="width:90%" readonly value="<%=objCliente.getStrNombreAseg()%>"/>
              </td>
              <td align="left" class="row1" width="15%" >Plan&nbsp;:&nbsp;</td>              
              <td align="left" class="row1" width="15%" >
              <input class="row5 input_text_sed" name="tctPlan" readonly type="text" value="<%=objCliente.getStrPlan()%>"></td>              
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Titular&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3 width="20%">
                <input class="row5 input_text_sed" name="tctTitular" type="text" readonly style="width:90%" value="<%=objCliente.getStrNombreTitular()%>">
              </td>
              <td align="left" class="row1" width="15%">
                Estado&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="15%">
                <input class="row5 input_text_sed" type="text" readonly value="<%=objCliente.getStrEstado()%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Fec. Nacimiento&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" readonly  value="<%=objCliente.getStrFecNac()%>">
              </td>
              <td align="left" class="row1" width="20%">
                Parentesco&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" readonly  value="<%=objCliente.getStrParentesco()%>">
              </td>
              <td align="left" class="row1" width="15%">
                Moneda&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="15%">
                <input class="row5 input_text_sed" type="text" readonly value="<%=objCliente.getStrMoneda()%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Sexo&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="15" readonly value="<%=objCliente.getStrSexo()%>">
              </td>
              <td align="left" class="row1" width="20%">
                Fecha Ingreso&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" name="tctFechaIng" type="text" size="12" readonly value="<%=objCliente.getStrFecIngreso()%>">
              </td>
              <td align="left" class="row1" width="15%">
                Producto&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="15%">
                <input class="row5 input_text_sed" type="text" readonly value="<%=strProducto%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Fec. Fin Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="12" readonly value="<%=objCliente.getStrFecFinCarencia()%>" name="hcdFinCarencia">
              </td>
              <td align="left" class="row1" width="20%">
                D&iacute;as Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" name="20" size="10" readonly value="<%=strDiasCarencia%>">
              </td>               
              <td align="left" class="row1" width="20%">
                &nbsp;  
              </td>
              <td align="left" class="row1" width="20%">
                &nbsp;  
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Contratante&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3>
                <input class="row5 input_text_sed" type="text" style="width:90%" readonly value="<%=objCliente.getStrContratante()%>">
              </td>
              <td align="left" class="row1" width="15%" style="color:#FF3300">
                  &nbsp;
              </td>
              <td align="left" class="row1" width="15%">
                  &nbsp;
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
               Fin de Vigencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="13" readonly value="<%=objCliente.getStrFecFinVigencia()%>">
              </td>
              <!--//RQ2015-000750 INICIO//-->
              <td align="left" class="row1" width="20%">Correo&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="15%" colspan="2">
                <input type="hidden" name="hctCodCliente" value="<%=objCliente.getStrCodigo()%>"/>
                <input class="row5 input_text_sed" name = "tctemail" style="color:#FF3300;width:'88%';" type="text" size="20" maxlength="50" value="<%=objCliente.getStrEmail()%>">
              </td>
              <td align="left" class="row1" width="15%">
                <A href="javascript:GrabarEmail()" class="btn_secundario lp-glyphicon lp-glyphicon-save-color">&nbsp;Grabar</A>                
              </td>
              <!--//RQ2015-000750 FIN//-->
            </tr>
            <tr>      
          </table>
      </td>
    </tr>
    <tr>
      <td></td>
    </tr>
  </table>
<%}%>
  <iframe name="procdetalle" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  <input type="hidden"  name="hcnClinica" value="<%= usuario.getStrWebServer() %>" />
</form>
<textarea id="textcopy" style="display:none;"></textarea>
<script type="text/javascript">
//FIN

  function LoadBody()
  {
    var frmAtencion = parent.document.forms[0];
    var codCliente = frmAtencion.tctCodCliente.value;
    parent.ActiveProceso(false);
  }
  
  function ClipBoard(valor)
  {
    textcopy.innerText= valor;
    Copied = textcopy.createTextRange();
    Copied.execCommand("Copy");
  }
  
  function limpiar(){
      var frm = document.forms[0];
      var frmp = parent.document.forms[0];
      frm.tctAsegurado.value = "";
  }

  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }
  
  function obtienePoliza()
  {
      var frmp = parent.document.forms[0];
      var poliza = frmp.tcnPoliza.value;
      return poliza;
  }
  
  function GrabarEmail() 
  { 
    var frm = document.forms[0];
    
    if (validaForm()==false)
        return;
    
    var sClient = frm.hctCodCliente.value;
    var sEmail = frm.tctemail.value;
    
    frm.target="procdetalle";
    frm.action="../servlet/ProcesoMant?proceso=11&sClient="+ sClient +"&sEmail=" + sEmail;
    frm.submit();
    
  }
  
  function validaForm()
  {    
      var frm = document.forms[0];
      
      if (frm.tctemail.value == "")
      {
        alert("Ingrese el correo electrónico del paciente.");
        return false;
      }
      if (!validarEmail('tctemail'))
        return false;           
        
      return true; 
  } 
  
</script>
</body>
  <%
      objCliente = null;
      //session.removeAttribute("DatoCliente");  
  %>
