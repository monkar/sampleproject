<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<jsp:include page="../menu/Menu.jsp"/>
<%
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:24pm
    GestorClinica gestorClinica = new GestorClinica();
        
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }
    
    int intIdUsuario = usuario.getIntIdUsuario();
    int intFlagValidaClinica=0;
    String strDesClinica=request.getParameter("DesClinica");        
    
    if (((usuario.getIntIdRol()==Constante.NROLOPE) && (usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP)) || ((usuario.getIntIdRol()==Constante.NROLOPE) && (usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT))  )
       intFlagValidaClinica=1;
    if (strDesClinica ==null){
        strDesClinica="";
    }
    //Req 2011-0849
    int intCodGrupo = usuario.getIntCodGrupo();
    if((usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR) && usuario.getIntIdRol()==Constante.NROLOPE)
    {
      intFlagValidaClinica=1;
    }
    
    if(usuario.getIntIdRol()== Constante.NROLEMISOR){
          intFlagValidaClinica = 1; //RQ2017-1848
    }
       
    //Fin Req 2011-0849
    //int intLevel = usuario.getIntLevel();    
%>

<!--Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11-->
<html>
<head>
<title>SISTEMA DE ATENCION EN CLINICAS</title>
    <jsp:include page="../general/scripts.jsp" />  
<head>
</head>
<BODY onload="LoadBody();" onunload="cleansession();" leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
<!--Tiempo que ha tardado la página en cargarse: <span id="tmp">Calculando...</span> segundos.-->
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
<LINK rel=Stylesheet TYPE="text/css" href="../styles/EstilosGenerales.css?v=1.0.0.1" type="text/css">
<LINK rel=Stylesheet TYPE="text/css" href="../styles/CambioMarca.css?v=1.0.0.1" type="text/css">
<script src="../jscript/library/jquery-1.9.1.min.js?v=1.0.0.1" type="text/javascript"/></script>
<SCRIPT src="../jscript/funciones.js?v=1.0.0.1" type=text/javascript></SCRIPT>
<script src="../jscript/funciones_generales.js?v=1.0.0.1" type=text/javascript></script>
<!--[if lt IE 9]>  
<link href="../styles/ie.css?v=1.0.0.1" rel="stylesheet" type="text/css" />    
<![endif]-->
<!--[if gte IE 9]>
<link href="../styles/ie9.css?v=1.0.0.1" rel="stylesheet" type="text/css" />  
<![endif]--> 
<TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
<TR >
<TD VALIGN="top"  align="left" width="100%" >
<form name="frmAtencion" method="post">
 <input type="hidden" name="hcnFlagValidaClinica" value="<%=intFlagValidaClinica%>"/>
 <input type="hidden" name="hcnGrupo" value="<%=intCodGrupo%>"/>
 <table cellSpacing="0" border=0 width="100%" align="left" >
 <tr id="dtConsulta">
 <td>
  <table cellSpacing="0" class="2 form-table-controls" border=0 width="100%" align="left" >
    <tr >
      <td>
        <table width="100%" cellspacing="0" cellpadding="0">
        <tr>
          <!--<td class="row2" width="25%" align=left><b>Consulta de Asegurados</b></td>-->
          <td width="75%">
            <div style="margin-left: 10px;margin-right: 10px;">
                     
            <fieldset class="row5 content_resumen_clinicas">
            <legend class="titulo_campos_bold">
              Búsqueda
            </legend>  
            
              <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
              
                 <%if ((usuario.getIntIdRol()==Constante.NROLASAD || usuario.getIntIdRol()==Constante.NROLADM || usuario.getIntIdRol()==Constante.NROLBRK || usuario.getIntIdRol()==Constante.NROPERFILBRK) || (intFlagValidaClinica==1))
                 {
                 %>
                    <tr>                      
                      <td align=left class="row5" width="2%" >Clínica :&nbsp;</td>
                      <td id="trBuscarClinica" align=left class="row5" width="21%">
                         <input class="row5 input_text_sed" maxlength="50" name = "tctDesClinica" type="text" value="<%=strDesClinica%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" >
                         &nbsp;&nbsp;<input type="button" class="TxtCombob lq-btn lp-glyphicon lp-glyphicon-search-blanco" value="Buscar Clínica    " onclick="javascript:onClickCargarPagina();"/>
                      </td>                                                                       
                      <td colspan=2 align=left class="row5" >                                            
                          <select name="lscClinica" class="TxtCombo lp-select" style="width:98%" onchange="javascript:selObj(this);">
                                 <option value=0>(Selecccione)</option>
                                  <%
                                    if (strDesClinica.length()==0){
                                        strDesClinica = "*:::*";
                                    }else{
                                        strDesClinica = "*" + strDesClinica + "*";
                                    } 
                                   
                                         BeanList lstClinica = gestorClinica.lstClinicaWeb(1,1,"S","1",strDesClinica);                                                      
                                    
                                         for (int i= 0; i < lstClinica.size(); i++ ){%>                                      
                                              <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3") + " (" + lstClinica.getBean(i).getString("6") + ")"%></option>
                                          <%}                                      
                                    
                                        out.print("<SCRIPT LANGUAGE=\"JavaScript\"> parent.ActiveProceso(false); </script>");                                      
                                    %>
                                  %>                                      
                            </select>                                             
                       </td>                       
                    </tr>
                  <%}%>                        
                  <tr>
                      <td align=left class="row5" width="1%">
                          <input  align=right class="TxtCombo" onclick="javascript:selObj(this);" type="radio" name="opcTipBus" value="1"/>
                      </td>
                      <td align=left class="row5" width="13%">
                           Por <BR>
                           Póliza/Certificado
                      </td>
                      <td align=left class="row5" width="1%">
                          <input align=right class="TxtCombo" onclick="javascript:selObj(this);" type="radio" checked name="opcTipBus" value="2"/>
                      </td>
                      <td align=left class="row5">
                          Por Apellidos
                      </td>
                      <!--INI-->
                      <!--Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11-->
                      <td align=left class="row5" width="1%">
                          <input align=right class="TxtCombo" onclick="javascript:selObj(this);" type="radio" name="opcTipBus" value="3"/>
                      </td>
                      <td align=left class="row5" width="15%">
                           Por DNI
                      </td>                        
                      <td align=left class="row5" width="1%">
                           <input align=right class="TxtCombo" onclick="javascript:selObj(this);" type="radio" name="opcTipBus" value="4"/>
                       </td>
                       <td align=left class="row5" width="20%">
                           Por Apellidos, Nombres
                       </td>                        
                       <td align=left class="row5" width="1%">
                           <input align=right class="TxtCombo" onclick="javascript:selObj(this);" type="radio" name="opcTipBus" value="5"/>
                       </td>
                       <td align=left class="row5" width="20%">
                           Por Código del Cliente/Asegurado
                       </td>             
                       <!--Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11-->
                       <!--FIN-->
                  </tr>
              </table>
            </fieldset>
            </div>
          </td>
        </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <div style="margin-left: 10px;margin-right: 10px;">
        <fieldset class="row5 content_resumen_clinicas">
        
          <table cellSpacing="1" border="0" width="100%" style="margin-top:5px">
            <tr id="trNombre">
              <td align="left" class="row1" width="20%" >Apellidos del Asegurado&nbsp;:&nbsp;</td>
              <td align="left" colspan=4 class="row4">
              <input class="row5 input_text_sed" name="tctNombre" type="text" style="width:100%" spellcheck="false" value="" autocomplete="off" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);"/></td>
              <td align="left" class="row1" width="20%">
                <input class="row5 TxtCombo lq-btn lp-glyphicon lp-glyphicon-search-blanco" type="button" value="Buscar" onclick="javascipt:buscarCliente();" name="btcBuscar1"/>
              </td>
            </tr>
            
            <tr id="trCodigo" style="display:none">
              <td>
                <table cellSpacing="1" border="0" width="100%">
                  <tr>
                    <td align="left" class="row1" width="20%" >Contrato</td>
                    <td align="left" class="row1" width="20%" >Certificado</td>
                    <td align="left" class="row1" width="20%" >Cod.Cliente</td>
                    <td align="left" class="row1" width="20%" >&nbsp;
                    <tr>                     
                      <td align="left" class="row1" width="20%">
                        <input class="row5 input_text_sed" name= "tcnPoliza" type="text" value="" onKeyPress="javascript:onKeyPressNumero('this');"/>
                      </td>
                      <td align="left" class="row1" width="20%">
                        <input class="row5 input_text_sed" name= "tcnCertif" type="text" value="" onKeyPress="javascript:onKeyPressNumero('this');onKey(this);"/>
                      </td>
                      <td align="left" class="row1" width="20%">
                        <input class="row1 input_text_sed" name= "tctCodCliente" type="text" readonly value="" onKeyPress="javascript:onKeyPressNumero('this');"/>
                      </td>
                      <td align="left" class="row1" width="20%">
                        <input class="row5 TxtCombo lq-btn lp-glyphicon lp-glyphicon-search-blanco" type="button" value="Buscar" onclick="javascipt:buscarCliente();" name="btcBuscar2"/>
                      </td>
                    </tr></td>
                  </tr>
                  <tr>
                    <td align="left" class="row1" width="20%" >
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
              <!--INI-->
              <!--Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11-->
                <tr id="trDni" style="display:none"> 
                    <td>
                    <table cellSpacing="1" border="0" width="100%">
                      <tr>
                      <td align="left" class="row1" width="20%" >DNI&nbsp;:&nbsp;</td>
                      <td align="left" class="row1" width="20%" >&nbsp;
                          <tr> 
                             <td align="left" class="row1" width="20%">
                                  <input class="row5 input_text_sed" name= "tcnDni" type="text" value="" onKeyUp="return maximaLongitud(this,8)" onKeyPress="javascript:onKeyPressNumero('this');"/>
                             </td>
                             <td align="left" class="row1" width="20%">
                                 <input class="row5 TxtCombo lq-btn lp-glyphicon lp-glyphicon-search-blanco" type="button" value="Buscar" onclick="javascript: buscarCliente();" name="btcBuscar3"/>
                             </td>                                     
                         </tr>  
                     </td>                  
                     </tr>
                     </table>
                    </td>
                  </tr>
                  
                  <tr id="trNomApe" style="display:none"> 
                  <td>
                  <table cellSpacing="1" border="0" width="100%">
                    <tr>
                       <td align="left" class="row1" width="20%" >Apellidos, Nombres Asegurado&nbsp;:&nbsp;</td>                                             
                       <td align="left" class="row1" width="20%">
                            <input class="row5 input_text_sed" name="tctNomApe" type="text" style="width:100%" value="" onKeyUp="return maximaLongitud(this,30)" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);"/>
                       </td>                     
                       <td align="left" class="row1" width="20%">
                           <input class="row5 TxtCombo lq-btn lp-glyphicon lp-glyphicon-search-blanco" type="button" value="Buscar" onclick="javascript:buscarCliente();" name="btcBuscar4"/>                                   
                       </td>
                     </tr>                    
                   </table>
                   </td>
                </tr>
                
                <tr id="trCliente" style="display:none"> 
                <td>
                  <table cellSpacing="1" border="0" width="100%">
                    <tr>
                    <td align="left" class="row1" width="20%" >C&oacute;digo del Cliente/asegurado &nbsp;:&nbsp;</td>
                    <td align="left" class="row1" width="20%" >&nbsp;
                    <tr>
                       <td align="left" class="row1" width="20%">
                            <input class="row5 input_text_sed" name= "tctCliente" type="text" value="" onKeyUp="return maximaLongitud(this,11)" onKeyPress="alfanumerico(this);javascript:onKeyPressMayuscula.call(this, event);"/>
                            <!--onKeyPress="javascript:onKeyPressMayuscula.call(this, event);"-->
                       </td>
                       <td align="left" class="row1" width="20%">
                           <input class="row5 TxtCombo lq-btn lp-glyphicon lp-glyphicon-search-blanco" type="button" value="Buscar" onclick="javascript:buscarCliente();" name="btcBuscar5"/>
                       </td>
                   </td>  
                   </tr>                 
                   </table>
                   </tr>
                </tr>
              <!--Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11-->
              <!--FIN-->
          </table>
        </fieldset>
        </div>
      </td>
    </tr>
    <tr id="trBusqueda">
      <td>
        <div style="margin-left: 10px;margin-right: 10px;">
        <fieldset class="row5 content_resumen" style="padding-top: 10px;">
        <legend class="titulo_campos_bold">
          Resultado de Búsqueda
        </legend>
          <div style="margin-left: 10px;margin-right: 10px;">
            <iframe name="frListaCliente" align=left width="100%" height="300" frameborder="0" scrolling="auto" src="../consulta/ListaCliente.jsp"></iframe>          
          </div>
          <!--Tiempo que ha tardado la página en cargarse: <span id="tmp">Calculando...</span> segundos.-->
        </fieldset>
        </div>
      </td>
    </tr>
    
    <tr id="trDetalle" style="display:none">
      <td>
        <div style="margin-left: 10px;margin-right: 10px;">
        <fieldset class="row5 content_resumen">
        <legend class="titulo_campos_bold">
          Detalle
        </legend>  
          <iframe name="frDetalleCliente" align=left width="100%" height="700" frameborder="0" scrolling="no"  src="../consulta/DetalleCliente.jsp"></iframe>
        </fieldset>
        </div>        
      </td>
    </tr>
    <tr>
      <td>
       <table width="100%" cellspacing="0" cellpadding="0" align="center">
          <tr id="dtProceso" style="display:none">
            <td class="row5" colspan=3 align="center"><br>
              <img name="btnProceso" ALT="Procesando" SRC="../images/loading_turquesa1.gif"  BORDER="0">
              <!--Tiempo que ha tardado la página en cargarse: <span id="tmp">Calculando...</span> segundos.-->
              <!--alert(<span id="tmp">Calculando...</span> segundos) ;-->
            </td>
          </tr>                        
        </table>         
      </td>
    </tr>
  </table>
 </td>
 </tr>
 
 <tr id="dtSolicitud"  style="display:none">
  <td>
  <table cellSpacing="0" class="2" border=0 width="100%" align="left" >
    <tr >
      <td>
        <div style="margin-left: 10px;margin-right: 10px;">
          <iframe name="procsolicitud" frameborder="0" height="1400px" width="100%"  src="../blancos.html"  style="overflow-y:hidden;"></iframe>  
        </div>
      </td>
    </tr>
  </table>
 </td>
 </tr>
 </table>
  <div style="margin-left: 10px;margin-right: 10px;">
    <iframe name="procatencion" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  </div>
</form>
</TD>
</TR>
</TABLE>
</body>

<script type="text/javascript">
 function LoadBody()
 {
  window.moveTo(0,0);
  window.resizeTo(window.screen.availWidth,window.screen.availHeight);
  window.focus();
  
  <%/*if (intLevel ==1){*/%>        
  <%if (usuario.getIntIdRol()==Constante.NROLASAD){%>
        obj = document.forms[0].lscClinica;
        document.forms[0].target="procatencion";
        document.forms[0].action="../control/ProcesoAcceso?proceso=2&pswebserver=" + obj.value;
        document.forms[0].submit(); 
   
  <%}%>
  findOptionChecked("opcTipBus");
  }

  function ActiveProceso(val)
  {
    if (val == true){
      dtProceso.style.display = '';
      document.forms[0].btcBuscar1.disabled = true;
      document.forms[0].btcBuscar2.disabled = true;
      //INI
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      document.forms[0].btcBuscar3.disabled = true;
      document.forms[0].btcBuscar4.disabled = true;
      document.forms[0].btcBuscar5.disabled = true;   
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      //FIN
    }else{
      dtProceso.style.display = 'none';
      document.forms[0].btcBuscar1.disabled = false;
      document.forms[0].btcBuscar2.disabled = false;
      //INI
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      document.forms[0].btcBuscar3.disabled = false;
      document.forms[0].btcBuscar4.disabled = false;
      document.forms[0].btcBuscar5.disabled = false;         
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      //FIN
    }
    
    //findOptionChecked("opcTipBus");    
  }
 
  function buscarCliente(){ 
   
    //INI
    //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    //Se ordeno los objetos al buscar los datos seleccionados
    var frm = document.forms[0];
    
      ActivarFiltroClinica(true);   
      
      if (document.forms[0].hcnFlagValidaClinica.value==1){          
        if (!valida('lscClinica','s'))
            return;          
      }                       
      if (frm.opcTipBus[1].checked){      
        if (!valida('tctNombre','t'))    
            return;
       }              
       if (frm.opcTipBus[0].checked){
        if (!valida('tcnPoliza','t'))
            return;
        if (!valida('tcnCertif','t'))
            return;
       }       
       //DNI 
       if (frm.opcTipBus[2].checked){ 
           if (!valida('tcnDni','t'))
      
           return;
       }       
       //APELLIDOS,NOMBRES
       if (frm.opcTipBus[3].checked){  
           if (!valida('tctNomApe','t'))
           return;      
       }       
       //CODIGO-CLIENTE
       if (frm.opcTipBus[4].checked){ 
           if (!valida('tctCliente','t'))
            return;
      }
        
       //debugger;
       
        frDetalleCliente.limpiar();
        trDetalle.style.display='none';
        trBusqueda.style.display = 'none';
        ActiveProceso(true);
        document.forms[0].target="procatencion";
        document.forms[0].action="../servlet/ProcesoAtencion?proceso=1";
        document.forms[0].submit();         
        //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
        //FIN
  }


  function verListado(){
      trBusqueda.style.display = '';
      frListaCliente.location.href = "../consulta/ListaCliente.jsp";
  }

  function verAlerta(code){
    if (code == -2)
      alert("Clinica no afiliada al contrato");      
    else
    if (code == -3)
      alert("Certificado no está vigente");  
    else
    if (code == -4)
      alert("Asegurado Cesado");  
    else
    if (code == -5)
      alert("Cobertura suspendida, comunicarse  con el 211-0211");  
    else
    if (code == -6)
      alert("Contrato no está vigente");
    else
    if (code == -7)
      alert("El asegurado no cuenta con una declaración de accidente aperturada, por favor generarla en el SITEDS 10");
    else
      alert("Error Técnico, llamar al 211-0211");  
    
      ActiveProceso(false);
  }

  function verDetalle(){
      //INI
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      //Se agrego el tipo de opcion seleccionado por dni,apellidos,nombres y codigo cliente
      var frm = document.forms[0];      
      var codCliente = frm.tctCodCliente.value;
      frDetalleCliente.location.href = "../consulta/DetalleCliente.jsp?codStrCliente="+codCliente; 
      trBusqueda.style.display = 'none';
       //CAMBIO QNET - WILLY NAPA
      //trDetalle.style.display = '';
      setTimeout("trDetalle.style.display = '';     ;",1000);
      //FIN CAMBIO QNET - WILLY NAPA     
      
      if (frm.opcTipBus[0].checked) {      
      document.forms[0].opcTipBus[0].checked = true;      
      trCodigo.style.display = '';
      trNombre.style.display = 'none';
      trDni.style.display    = 'none';
      trNomApe.style.display = 'none';
      trCliente.style.display = 'none';          
      document.forms[0].tcnPoliza.focus();
  }
      if (frm.opcTipBus[1].checked){
         document.forms[0].opcTipBus[1].checked = true;                      
         trCodigo.style.display  = 'none';
         trDni.style.display     = 'none';
         trNomApe.style.display  = 'none';
         trCliente.style.display = 'none';
         trNombre.style.display  = '';              
         document.forms[0].tctNombre.focus(); 
      }   
      //DNI
      if (frm.opcTipBus[2].checked){
         document.forms[0].opcTipBus[2].checked = true;               
         trCodigo.style.display  = 'none';
         trNomApe.style.display  = 'none';
         trCliente.style.display = 'none';      
         trNombre.style.display  = 'none'; 
         trDni.style.display = '';               
         document.forms[0].tcnDni.focus();          
      }    
      //APELLIDOS,NOMBRES
      if (frm.opcTipBus[3].checked){
         document.forms[0].opcTipBus[3].checked = true;               
         trNomApe.style.display  = '';
         trCodigo.style.display  = 'none';         
         trCliente.style.display = 'none';      
         trNombre.style.display  = 'none'; 
         trDni.style.display     = 'none';               
         document.forms[0].tctNomApe.focus();          
      }                  
      //CODIGO-CLIENTE
      if (frm.opcTipBus[4].checked){
         document.forms[0].opcTipBus[4].checked = true;               
         trCliente.style.display = ''; 
         trNomApe.style.display  = 'none';
         trCodigo.style.display  = 'none';                       
         trNombre.style.display  = 'none'; 
         trDni.style.display     = 'none';               
         document.forms[0].tctCliente.focus();          
      }   
      //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
      //FIN
  }
  
  function selObj(obj){
    //INI
    //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    //Se incluyó la seleccion de objetos por dni,apellidos,nombres y codigo-cliente
    trDetalle.style.display = 'none';
    if (obj.value == 1){
        limpiar();
        trNombre.style.display = 'none';
        trDni.style.display     = 'none';
        trCliente.style.display = 'none';
        trNomApe.style.display  = 'none';
        trCodigo.style.display = '';
        document.forms[0].tcnPoliza.focus();
        trBusqueda.style.display = '';
        //verListado();
         ActivarFiltroClinica(true);
    }
    if (obj.value == 2){
        limpiar();
        trCodigo.style.display = 'none';
        trDni.style.display     = 'none';
        trCliente.style.display = 'none';
        trNomApe.style.display  = 'none';
        trNombre.style.display = '';
        document.forms[0].tctNombre.focus();
        trBusqueda.style.display = '';
        //verListado();        
        ActivarFiltroClinica(true);
    }
    //DNI
    if (obj.value == 3){                         
        limpiar();         
        trCodigo.style.display  = 'none';
        trNombre.style.display  = 'none';        
        trNomApe.style.display  = 'none';
        trCliente.style.display = 'none';        
        trDni.style.display = '';         //mostrar objeto
        document.forms[0].tcnDni.focus();        
        trBusqueda.style.display = '';
        //verListado();        
        ActivarFiltroClinica(true);
    }
    //APELLIDOS,NOMBRES
    if (obj.value == 4){
        limpiar();         
        trCodigo.style.display  = 'none';
        trNombre.style.display  = 'none';         
        trDni.style.display     = 'none';
        trCliente.style.display = 'none';
        trNomApe.style.display  = '';  //mostrar objeto
        document.forms[0].tctNomApe.focus();
        trBusqueda.style.display = '';
        //verListado();        
        ActivarFiltroClinica(true);        
    }
    //CODIGO-CLIENTE
     if (obj.value == 5){
        limpiar();         
        trCodigo.style.display  = 'none';
        trNombre.style.display  = 'none';         
        trDni.style.display     = 'none';
        trNomApe.style.display  = 'none'
        trCliente.style.display = ''  //mostrar objeto
        document.forms[0].tctCliente.focus();
        trBusqueda.style.display = '';
        //verListado();        
        ActivarFiltroClinica(true);        
    }
    //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    //FIN
    if (obj.name == 'lscClinica'){
        document.forms[0].target="procatencion";
        document.forms[0].action="../control/ProcesoAcceso?proceso=2&pswebserver=" + obj.value;
        document.forms[0].submit(); 
    }
  }

  function onKey(obj){
    if(event.keyCode==13)
        buscarCliente();
  }  
  
  function limpiar(){
    var frm = document.forms[0];
    frm.tcnPoliza.value ="";
    frm.tcnCertif.value ="";
    frm.tctCodCliente.value ="";
    frm.tctNombre.value ="";
    //INI
    //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    frm.tcnDni.value        ="";
    frm.tctNomApe.value     ="";
    frm.tctCliente.value    ="";
    //Se agrego la funcionalidad de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    //FIN
  }
  
  function verParent(){
      dtSolicitud.style.display = 'none';
      dtConsulta.style.display = '';      
  }
  function verParentAnul()
  {
    window.location.href = "../flujo/Bandeja.jsp";
  }
  
    function alfanumerico(obj){
    var tecla = window.event.keyCode;
    if(65<=tecla && tecla<=90 || 97<=tecla && tecla<=122 || 48<=tecla && tecla<=57){
    }
     else{
          window.event.keyCode=0;
        }
    }


  function maximaLongitud(texto,maxlong) {
  var tecla, in_value, out_value;  
  if (texto.value.length > maxlong) {
      in_value = texto.value;
      out_value = in_value.substring(0,maxlong);
      texto.value = out_value;
      return false;
  }
      return true;
  }
 
  function contar(){
  contar++;
  tempo = setTimeout("contar()", 1000);
  }
  
  function parar(){
  clearTimeout(tempo);
  alert("Has tardado "+contar+" segundos");
  }


  function TerminaSession(){
      window.location.href = "../Mensaje.jsp";
  }
  
  function cleansession(){
    var ret = retValXml("../servlet/SessionClean?proceso=2");
  }
  
  var inicio = new Date();
  inicio = inicio.getTime();
  function ini() {
    fin    = new Date();
    fin    = fin.getTime();
    tiempo = (fin-inicio)/1000; //Gracias por el consejo, Ferny
    document.getElementById('tmp').innerHTML=tiempo;
  }


	function onClickCargarPagina(){ 
     var frmVar = document.forms[0];       
     //ActiveProceso(true);
     frmVar.action = "Atencion.jsp?DesClinica=" + frmVar.tctDesClinica.value;
     frmVar.target = "_self";
	   frmVar.submit();                
	}  
  
	function ActivarFiltroClinica(value){    
      if (document.forms[0].hcnFlagValidaClinica.value==1){          
      
         var frmVar = document.forms[0];       
         var objLstClinica=document.forms[0].lscClinica;
         var obj=document.forms[0].lscClinica;
         
         
         if (value==true){
             objLstClinica.disabled=false;     
             trBuscarClinica.style.display = ''; 
         }else{
             objLstClinica.disabled=true;
              trBuscarClinica.style.display = 'none';
         }
         
      }   
	}      
  
 function permite(elEvento, permitidos) {
  // Variables que definen los caracteres permitidos
  var numeros = "0123456789";
  var caracteres = " abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ";
  var numeros_caracteres = numeros + caracteres;
  var teclas_especiales = [8, 37, 39, 46];
  // 8 = BackSpace, 46 = Supr, 37 = flecha izquierda, 39 = flecha derecha
  
  // Seleccionar los caracteres a partir del parámetro de la función
  switch(permitidos) {
    case 'num':
      permitidos = numeros;
      break;
    case 'car':
      permitidos = caracteres;
      break;
    case 'num_car':
      permitidos = numeros_caracteres;
      break;
  }
 
  // Obtener la tecla pulsada 
  var evento = elEvento || window.event;
  var codigoCaracter = evento.charCode || evento.keyCode;
  var caracter = String.fromCharCode(codigoCaracter);
 
  // Comprobar si la tecla pulsada es alguna de las teclas especiales
  // (teclas de borrado y flechas horizontales)
  var tecla_especial = false;
  for(var i in teclas_especiales) {
    if(codigoCaracter == teclas_especiales[i]) {
      tecla_especial = true;
      break;
    }
  }
 
  // Comprobar si la tecla pulsada se encuentra en los caracteres permitidos
  // o si es una tecla especial
  return permitidos.indexOf(caracter) != -1 || tecla_especial;
 }
 
 function isNumberOrLetter(evt) {

    var charCode = (evt.which) ? evt.which : event.keyCode;

    if ((charCode > 65 && charCode < 91) || (charCode > 97 && charCode < 123) || (charCode > 47 && charCode < 58) )

     return true;  

      return false;  }
  
</script>

</html>
<%
    //session.removeAttribute("ListaCobertura");
    //session.removeAttribute("DatoCliente");  
%>