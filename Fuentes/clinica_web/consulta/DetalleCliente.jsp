<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.io.*"%>   <!--Cambio QNET 28/12/11-->

<%
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 11:18am
    GestorCliente gestorCliente = new GestorCliente();

    Caso objCaso=new Caso();        

    if (session.getAttribute("NumeroCaso")!=null){
          objCaso = (Caso)session.getAttribute("NumeroCaso");          
    }

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
    int intRamo = 0;
    String flagCodAutoriza = "";
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
    
   
    int intFlagValidaClinica = 0;
    
    if(usuario.getIntIdRol()== Constante.NROLEMISOR){
          intFlagValidaClinica = 1; //RQ2017-1848
        }                       
    
  synchronized(session)
  {
    if (session.getAttribute("DatoCliente")!=null)
    {
      codClienteFRM = Tool.getString(request.getParameter("codStrCliente"));
     // int intCase = Tool.parseInt(request.getParameter("tctCase"));
     //         System.out.println("Numero de caso :" + intCase);
      
      
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
        intRamo = 0;
        sruta           = request.getSession().getServletContext().getRealPath("/imgasegurados/"); 
        strContinuidad = (objCliente.getStrContinuidadInx().substring(0).equals("S")?"CONTINUIDAD":"");
        strCont = objCliente.getStrContinuidadInx().substring(0);        
        policy     = objCliente.getIntPoliza();
        certif     = objCliente.getIntCertificado();
        strCodAseg = objCliente.getStrCodigo();
        cliente    = objCliente.getStrCodigo();
        intRamo    = objCliente.getIntRamo(); //Agregado para Apple
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
<div style="height:720px;  overflow-y:auto">

<form name="frmDetalleCliente" method="post">  
<input type="hidden" name="hcnFlgAutoriza" value="0"/>
<input type="hidden" name="hcnContinuidad" value="<%=strCont%>"/>
<input type="hidden" name="hcnFlgVerImpresionSolBenef" value="0"/>
<input type="hidden" name="hcnRamo" value="<%=intRamo%>"/>
<!--//CAMBIO QNET - WILLY NAPA-->
<%if (intXtra == true){%>
<!--//FIN CAMBIO QNET - WILLY NAPA-->
  <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
    <tr>
      <td>
          <table cellSpacing="1" class="2" border="0" width="100%">
            <tr>
                  <td align="left" class="row1" width="20%" >Asegurado&nbsp;:&nbsp;</td>
                  <td align="left" class="row1" colspan=3 >
                  <input class="row5 input_text_sed" name="tctAsegurado" type="text" style="width:90%" readonly value="<%=objCliente.getStrNombreAseg()%>"/>
                  </td>
                  <!--Se incluyo esta funcionalidad para la llamada a CargaArchivo.jsp-->
                  <td rowspan=6 colspan = 3 align="center">                                                                                               
                  <!--//CAMBIO QNET - WILLY NAPA -->
                      <iframe name="frImagen" width="330" scrolling="no"  style="display:block" height="169" frameborder="0"  src="../consulta/CargaArchivo.jsp"></iframe>                           
                  <!--//FIN CAMBIO QNET - WILLY NAPA -->    
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
              <% //cambio por problemas de concurrencia
                 //<input class="row5" type="text" name="20" size="10" readonly value="<%=objCliente.getIntDiasCarencia()
                 %>
                <input class="row5 input_text_sed" type="text" name="20" size="10" readonly value="<%=strDiasCarencia%>">
              </td>                    
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Contratante&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3>
                <input class="row5 input_text_sed" type="text" style="width:90%" readonly value="<%=objCliente.getStrContratante()%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="20%">
                Fin de Vigencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="13" readonly value="<%=objCliente.getStrFecFinVigencia()%>">
              </td>
              <td align="left" class="row1 texto_general_black" width="15%"><%=strContinuidad%>&nbsp;</td>
              <td align="left" class="row1" width="20%">&nbsp;</td>
              <%if (usuario.getIntIdRol()==Constante.NROLOPE){%>
              <td align="left" class="row1" width="15%" >
                        
              </td>
              <td align="left" class="row1" width="15%">
                        <input class="row5 input_text_sed" name = "tctNroAutoriza" type="text" readonly>
                        </td>
                    <%}else{%>                 
                        <td align="left" class="row1" colspan="2">
                        <%-- RQ2016-1713 --%>
                        <%
                          flagCodAutoriza = TablaConfig.getTablaConfig("CODAUTORIZACION");                          
                        if (flagCodAutoriza.equals("0")){%>                          
                        <input type="button" name="btnGenCod" class="row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color" value="Codigo Autorización" onClick="javascript:obtenerAutoriza();"/>                        
                        <%}else{%>                                          
                        <input type="button"  name="btnGenCod" disabled class="row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color" value="Codigo Autorización" onClick="javascript:obtenerAutoriza();"/>                                                  
                        <%}%>
                        <%-- RQ2016-1713 --%>
              </td>
                    <%}%>
                    <td align="left" class="row1" width="20%">&nbsp;</td>
                    
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
              <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>  
                <input type="button" class='row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color' name="btnCartaA" value="Carta de Autorización" onClick="javascript:openSolicitud(<%=Constante.NTSCARAUT%>,0,<%=policy%>,<%=certif%>,'<%=cliente.trim()%>','<%=intRamo%>');" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV || usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT || usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"style='display:none'":"") %>>
              <%}else if(usuario.getIntIdRol()==Constante.NROLBRK){%>
                <input type="button" class='row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-see-color' name="btnCartas" value="Consultar Cartas" onClick="javascript:BuscaCarta('<%=objCliente.getStrNombreAseg()%>');">
              <%}%>
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
                  <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>                
                    <input type="button" class='row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color' name="btnCartaG" value="Carta de Garantía" onClick="javascript:openSolicitud(<%=Constante.NTSCARGAR%>,0,<%=policy%>,<%=certif%>,'<%=cliente.trim()%>','<%=intRamo%>');" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP || usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV || usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT || usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"style='display:none'":"") %> >
                  <%}%>
                  <td align="left" class="row1" width="15%">                
                    <input type="button" value="Exclusiones" onClick="javascript:listaExclusion();" <%=(objCliente.getIntIndExcl() == 1?"class='TxtCombor btn_secundario lp-glyphicon lp-glyphicon-remove-color'":" class='row5 btn_secundario lp-glyphicon lp-glyphicon-remove-color' disabled")%>>
                  </td>
                      </td>
                      <td align="left" class="row1" width="20%">&nbsp;</td>
            <tr>
      
          </table>
      </td>
    </tr>
<!--    <tr>
      <td align="center" class="header"><b>Coberturas&nbsp;</b></td>
    </tr>-->
    <tr>
     <%
       if(flagSession==1)
       {
     %>
      <td>
        <!--<fieldset class="row5">
        <legend>
          <STRONG>Cobertura</STRONG>
        </legend>  -->

          <iframe name="frListaCobertura" align=left width="100%" height="520" frameborder="0" scrolling="auto" src="../consulta/ListaCobertura.jsp?scontinuidad=<%=strCont%>&hcnRamo=<%=intRamo%>"></iframe>
        <!--</fieldset>-->
      </td>
      <%
          }
          else
          {
          %>
          <td align="center" colspan=12 class="row1"  style="font-family:arial;font-size:12px">Ha ocurrido un error de conectividad, por favor vuelva a buscar</td>
          <%
          }
          %>
    </tr>
  </table>
<!--//CAMBIO QNET - WILLY NAPA-->
<!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!---->

<%}else{%> 
 <table cellSpacing="1" class="2 form-table-controls" border="0" width="100%">
    <tr>
      <td>
          <table cellSpacing="1" class="2" border="0" width="100%">
            <tr>
              <td align="left" class="row1" width="15%" >Asegurado&nbsp;:&nbsp;</td>
              <td align="left" class="row1" colspan=3 >
              <input class="row5 input_text_sed" name="tctAsegurado" type="text" style="width:90%" readonly value="<%=objCliente.getStrNombreAseg()%>"/>
              </td>
              <td align="left" class="row1" width="15%" >Plan&nbsp;:&nbsp;</td>              
              <td align="left" class="row1" width="15%" >
              <input class="row5 input_text_sed" name="tctPlan" readonly type="text" value="<%=objCliente.getStrPlan()%>"></td>              
            </tr>
            <tr>
              <td align="left" class="row1" width="15%">
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
              <td align="left" class="row1" width="15%">
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
              <td align="left" class="row1" width="15%">
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
              <% //cambio por problemas de concurrencia
                 //input class="row5" type="text" readonly value="<%=objCliente.getIntProducto()
                 %>
                <input class="row5 input_text_sed" type="text" readonly value="<%=strProducto%>">
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="15%">
                Fec. Fin Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="12" readonly value="<%=objCliente.getStrFecFinCarencia()%>" name="hcdFinCarencia">
              </td>
              <td align="left" class="row1" width="20%">
                D&iacute;as Carencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
              <% //cambio por problemas de concurrencia
                 //<input class="row5" type="text" name="20" size="10" readonly value="<%=objCliente.getIntDiasCarencia()
                 %>
                <input class="row5 input_text_sed" type="text" name="20" size="10" readonly value="<%=strDiasCarencia%>">
              </td>
              <%if (usuario.getIntIdRol()==Constante.NROLOPE){%>
                  <td align="left" class="row1" width="15%" >  
                        <%-- RQ2016-1713 --%>
                        <%
                          flagCodAutoriza = TablaConfig.getTablaConfig("CODAUTORIZACION");                          
                        if (flagCodAutoriza.equals("0")){%>                          
                        <input type="button" name="btnGenCod" class="row5 btn_secundario lp-glyphicon lp-glyphicon-file-color" disabled value="Codigo Autorización" onClick=""/>
                        <%}else{%>                                          
                        <input type="button"  name="btnGenCod" disabled class="row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color" value="Codigo Autorización" onClick="javascript:obtenerAutoriza();"/>                                                  
                        <%}%>
                        <%-- RQ2016-1713 --%>
                  </td>
                  <td align="left" class="row1" width="15%">
                    <input class="row5 input_text_sed" name = "tctNroAutoriza" type="text" readonly>
                  </td>
              <%}else{%>                 
                  <td align="left" class="row1" colspan="2">
                    
                  </td>
              <%}%>
            </tr>
            <tr>
              <td align="left" class="row1" width="15%">
                Contratante&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" colspan=3>
                <input class="row5 input_text_sed" type="text" style="width:90%" readonly value="<%=objCliente.getStrContratante()%>">
              </td>
              <td align="left" class="row1 texto_general_black" width="15%"><%=strContinuidad%></td>
              <td align="left" class="row1" width="15%">
                  &nbsp;
              </td>
            </tr>
            <tr>
              <td align="left" class="row1" width="15%">
                Fin de Vigencia&nbsp;:&nbsp;
              </td>
              <td align="left" class="row1" width="20%">
                <input class="row5 input_text_sed" type="text" size="13" readonly value="<%=objCliente.getStrFecFinVigencia()%>">
              </td>
              <td align="left" class="row1" width="20%">&nbsp;</td>
              <td align="right" class="row1" width="15%" >
                <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>
                  <input type="button" class="row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color" name="btnCartaA" value="Carta de Autorización" onClick="javascript:openSolicitud(<%=Constante.NTSCARAUT%>,0,<%=policy%>,<%=certif%>,'<%=cliente.trim()%>','<%=intRamo%>');" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV || usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT || usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"style='display:none'":"") %>>
                <%}else if(usuario.getIntIdRol()==Constante.NROLBRK){%>
                  <input type="button" class='row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-see-color' name="btnCartas" value="Consultar Cartas" onClick="javascript:BuscaCarta('<%=objCliente.getStrNombreAseg()%>');">
                <%}%>
              </td>
              <td align="left" class="row1" width="30%" colspan="3">
                <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>   
                  <input type="button" class='row5 TxtCombo btn_secundario lp-glyphicon lp-glyphicon-file-color' name="btnCartaG" value="Carta de Garantía" onClick="javascript:openSolicitud(<%=Constante.NTSCARGAR%>,0,<%=policy%>,<%=certif%>,'<%=cliente.trim()%>','<%=intRamo%>');" <%=(usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP || usuario.getIntCodGrupo()==Constante.NCODGRUPOMINV || usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT || usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR?"style='display:none'":"") %> >
                <%}%>
                <!--</td>
                <td align="left" class="row1" width="15%">-->
                  <input type="button" value="Exclusiones"  
                      onClick="javascript:listaExclusion();" style="margin-left:15px;"
                      <%=(objCliente.getIntIndExcl() == 1?"class='TxtCombor btn_secundario lp-glyphicon lp-glyphicon-remove-color'":" class='row5 btn_secundario lp-glyphicon lp-glyphicon-remove-color' disabled")%>>
              </td>
            </tr>
            <tr>
      
          </table>
      </td>
    </tr>
<!--    <tr>
      <td align="center" class="header"><b>Coberturas&nbsp;</b></td>
    </tr>-->
    <tr>
     <%
       if(flagSession==1)
       {
     %>
      <td>
        <!--<fieldset class="row5">
        <legend>
          <STRONG>Cobertura</STRONG>
        </legend>  -->

          <iframe name="frListaCobertura" align=left width="100%" height="520" frameborder="0" scrolling="auto" src="../consulta/ListaCobertura.jsp?scontinuidad=<%=strCont%>&hcnRamo=<%=intRamo%>"></iframe>
        <!--</fieldset>-->
      </td>
      <%
          }
          else
          {
          %>
          <td align="center" colspan=12 class="row1"  style="font-family:arial;font-size:12px">Ha ocurrido un error de conectividad, por favor vuelva a buscar</td>
          <%
          }
          %>
    </tr>
  </table>
<%}%>
<!--//FIN CAMBIO QNET - WILLY NAPA-->
  <iframe name="procdetalle" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  <input type="hidden"  name="hcnClinica" value="<%= usuario.getStrWebServer() %>" />
</form>
</div>
<textarea id="textcopy" style="display:none;"></textarea>
<script type="text/javascript">

//FIN
//********************* Cambio QNET 28/12/11****************

  function LoadBody()
  {
    var frmAtencion = parent.document.forms[0];
    var codCliente = frmAtencion.tctCodCliente.value;    
   /* if( <%=cliente%> == codCliente)
    {
      alert('es correcto');
    }
    else
    {
      alert('no es correcto');
    }*/
    //parent.verListado();
    parent.ActiveProceso(false);
  }

  function listaExclusion(){
      var frmp = parent.document.forms[0];
      var poliza = frmp.tcnPoliza.value;
      var certif = frmp.tcnCertif.value;
      var codCliente = frmp.tctCodCliente.value;
      var ramo = <%=objCliente.getIntRamo()%>;
  
      document.forms[0].target="procdetalle";
      document.forms[0].action="../servlet/ProcesoAtencion?proceso=3&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente + "&tctRamo=" + ramo;
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
    //INI***********************************
    //*********Cambio QNET 28/12/11*********
    function verFotografia(){            
      xx = 450;
      yy = 200;       
      x  = (window.screen.availWidth-xx)/2;
      y  = (window.screen.availHeight-yy)/2
      parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=NO,top=" + y + ",left=" + x                 
      window.open("../consulta/CargaArchivo.jsp?","cargaarchivo",parametros);                      
    }
    //FIN***********************************
  
  function obtenerAutoriza(){
      if(<%=usuario.getIntFlgDeshabilitado()%> == 0){ //Esta condición IF se agregó por el REQ. 2014-000561 Paradigmasoft GJB
      var frm = document.forms[0];    
      var frmh = frListaCobertura.document.forms[0];
      var pncover = frmh.hcnCover.value;
      var pnTipoAtencion = frmh.hcnTipoAten.value;
      
      var flgVerImpresionSolBenef = frm.hcnFlgVerImpresionSolBenef.value;                  
      var psnroautoriza = frm.tctNroAutoriza.value;      
            
      if(<%=usuario.getIntCodGrupo()%>== <%=Constante.NCODGRUPOPROT%>){      
         flgVerImpresionSolBenef=1;
      }      
     
          if(pnTipoAtencion==1){
          alert("Debe seleccionar una cobertura con tipo de atención AMBULATORIA (AMB).");
          return;
      }
      
      var flgAutoriza = frm.hcnFlgAutoriza.value;
      
      if (pncover == ""){
          alert("Seleccione una cobertura");
          return;
      }

      if (pncover == <%=Constante.NCOVEREMACC%>){
        var strFinCarencia = frm.hcdFinCarencia.value; 
        url="../servlet/ProcesoValida?pntipoval=1";
        var strFecSystem = retValXml(url);      
        if (compararFecha(strFinCarencia,strFecSystem)){
          alert("El asegurado se encuentra en periodo de carencia");
          return;
        }
      }
          
      if (flgAutoriza == 1){
           if (flgVerImpresionSolBenef == 1){
               if (psnroautoriza==''){               
                  var resp=confirm("Confirme si esta seguro de generar otro Código de Autorización"); 
                  if (resp){
                      frm.tctNroAutoriza.value ="";
                      generaAutoriza();        
                  }                   
               }else{
                  alert('El Código de Autorización ya fue generado');
               }
           }else{
                var resp=confirm("Confirme si esta seguro de generar otro Código de Autorización"); 
                if (resp){
                    frm.tctNroAutoriza.value ="";
                    generaAutoriza();        
                }              
           }      
        
      } else{
       //paso
          generaAutoriza();
       }
  }
      else{ //REQ. 2014-000561 Paradigmasoft GJB
        alert("Debe utilizar SITEDS para generar esta solicitud");
      }      
  }
    //paso 2
  function generaAutoriza(){
      var frmp = parent.document.forms[0];
      var frmh = frListaCobertura.document.forms[0];
      var poliza = frmp.tcnPoliza.value;
      var certif = frmp.tcnCertif.value;
      var codCliente = frmp.tctCodCliente.value;
      var pncover = frmh.hcnCover.value;
      var pstipoaten = frmh.hctTipoaten.value;
      var pnselcover = frmh.hcnSelCover.value;
      var pnconceptopago = frmh.hcnConceptoPago.value;
      var pncovergen = frmh.hcnGenCover.value; 
      var pusuariowebserver='';       
      var ramo = <%=objCliente.getIntRamo()%>;

      if(<%=usuario.getIntCodGrupo()%>== <%=Constante.NCODGRUPOPROT%>){      
         pusuariowebserver = '<%=usuario.getStrWebServer()%>'; 
      }             
      
      
      url="../servlet/ProcesoValida?pntipoval=10&pnpoliza=" + poliza + "&pncertif=" + certif + "&pncobertura=" + pncover + 
          "&pncliente=" + codCliente +  "&pnconcepto=" + pnconceptopago +  "&pncoberturagen=" + pncovergen;
      var res = retValXml(url);      
      if (res==1)
      {
          alert("Se superó el número de veces que esta cobertura puede ser utilizada.");
          return;
      }
      
      document.forms[0].hcnFlgAutoriza.value = "1";
      document.forms[0].target="procdetalle";
      
      
      document.forms[0].action="../servlet/ProcesoAtencion?proceso=4&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente + "&pnselcover=" + pnselcover + "&pncover=" + pncover 
                               + "&pstipoaten=" + pstipoaten + "&pnconcepto=" + pnconceptopago + "&pusuariowebserver=" + pusuariowebserver + "&tctRamo=" + ramo;
                               
                               
      document.forms[0].submit();       
  }

  //INI - REQ 0389-2011 BIT/FMG
  function abrirxml(idSolicitud, nroautoriza){
        /*var frm = document.forms[0];
        document.forms[0].target="_blank";
        document.forms[0].action="../servlet/ProcesoXML?pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza;
        document.forms[0].submit();*/
        window.open("../servlet/ProcesoXML?pnidsol=" + idSolicitud + "&pnautoriza=" + nroautoriza,"_blank","");
  }
  //FIN - REQ 0389-2011 BIT/FMG
  
  function ClipBoard(valor)
  {
    textcopy.innerText= valor;
    Copied = textcopy.createTextRange();
    Copied.execCommand("Copy");
  }
  
  function verAutoriza(numero,gencover){
      var frm = document.forms[0];
      frm.tctNroAutoriza.value = numero;
      var frmh = frListaCobertura.document.forms[0];
      var pstipoaten = frmh.hctTipoaten.value;      
      var psTipoUsuario = frmh.hcnTipoUsuario.value;
      var psGenCover = frmh.hcnGenCover.value;
      var psCover = frmh.hcnCover.value;
      var psConceptoPago = frmh.hcnConceptoPago.value;
      
      var flgVerImpresionSolBenef = frm.hcnFlgVerImpresionSolBenef.value;                  
      
      //INI - REQ 0389-2011 BIT/FMG
      if (<%=usuario.getIntXMLActivo()%> == 1){
          abrirxml('1000',numero);
      }
      //FIN - REQ 0389-2011 BIT/FMG

      if(<%=usuario.getIntCodGrupo()%>== <%=Constante.NCODGRUPOPROT%>){      
         flgVerImpresionSolBenef=1;
         ClipBoard(numero);
      }            

      if (pstipoaten == '<%=Constante.SATENAMB%>') {
        if (flgVerImpresionSolBenef == 0){         
          var resp=confirm("Confirme si va imprimir la Solicitud de Beneficio Nº" + numero); 
          if (resp)
          {                  
            if(gencover==217)
              window.open('../consulta/SolicitudBenefOdontPDF.jsp?pnautoriza=' + numero);
            else  
              window.open('../consulta/SolicitudBeneficioPDF.jsp?pnautoriza=' + numero);
          }         
        }  
      }
  }
  
  function limpiar(){
      var frm = document.forms[0];
      var frmp = parent.document.forms[0];
      //frmp.tcnPoliza.value = "";
      //frmp.tcnCertif.value = "";
      //frmp.tctCodCliente.value = "";
      frm.tctAsegurado.value = "";
  }

  function verAlerta(){
      parent.verAlerta();
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }
  
  function openSolicitud(tipsol, ref, policy, certif, client,intRamo)
  {
      if (ref==0)
      {
        var frm = document.forms[0];  
        var frmp = parent.document.forms[0];
        var frmh = frListaCobertura.document.forms[0];
        var poliza = frmp.tcnPoliza.value;
        var certif = frmp.tcnCertif.value;
        var codCliente = frmp.tctCodCliente.value;
        var poliza = policy;
        var certif = certif;
        var codCliente = client;
        var codRamo = intRamo;
        var pncover = frmh.hcnCover.value;
        var pstipoaten = frmh.hctTipoaten.value;
        var pnselcover = frmh.hcnSelCover.value;
        var genCover = frmh.hcnGenCover.value;

        if (pncover == ""){
            alert("Seleccione una cobertura");
            return;
        }
        
        document.forms[0].target="procdetalle";
        document.forms[0].action="../servlet/ProcesoSolicitud?proceso=3&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente + "&pnselcover=" + pnselcover + "&pncover=" + pncover + "&pstipoaten=" + pstipoaten + "&pstiposol=" + tipsol + "&tctRamo=" + codRamo;
        document.forms[0].submit();
    }
    else
    {  
        //debugger;
      
        var frmh = frListaCobertura.document.forms[0];
        var pnselcover = frmh.hcnSelCover.value;
        var strClinica = document.forms[0].hcnClinica.value;
        var codRamo = intRamo; 
        //parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?pstiposol=" + tipsol + "&pnselcover=" + pnselcover;
        parent.procsolicitud.location.href = "../flujo/Solicitud.jsp?pstiposol=" + tipsol + "&pnselcover=" + pnselcover + "&tcnPoliza=" + policy + "&tcnCertif=" + certif + "&tctCodCliente=" + client + "&strClinica="+strClinica + "&tctRamo=" + codRamo; // Se agrego para Apple
      
        parent.dtSolicitud.style.display = '';
        parent.dtConsulta.style.display = 'none';
    }
  }
  
  function BuscaCarta(nomAseg)
  {       
        parent.procsolicitud.location.href = "../flujo/BandejaBrok.jsp?tctAsegurado=" + nomAseg;                
        parent.dtSolicitud.style.display = '';
        parent.dtConsulta.style.display = 'none';  
  }
  
  function obtienePoliza()
  {
      var frmp = parent.document.forms[0];
      var poliza = frmp.tcnPoliza.value;
      
      return poliza;
  }
  
</script>
</body>
  <%
      objCliente = null;      
      //session.removeAttribute("DatoCliente");  
  %>
