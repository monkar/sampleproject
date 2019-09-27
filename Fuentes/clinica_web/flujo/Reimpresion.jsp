<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<jsp:include page="../menu/Menu.jsp" />
<%
      
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:34pm
    GestorClinica gestorClinica = new GestorClinica();
   
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");      
    }  
    
    int intIdUsuario = usuario.getIntIdUsuario();
    
    //Req 2011-0849
    int intFlagValidaClinica=0;
    
    String strDesClinica=request.getParameter("DesClinica");        
    
    if (((usuario.getIntIdRol()==Constante.NROLOPE) && (usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP)) || ((usuario.getIntIdRol()==Constante.NROLOPE) && (usuario.getIntCodGrupo()==Constante.NCODGRUPOPROT))  )
       intFlagValidaClinica=1;
       
    if (strDesClinica ==null){
        strDesClinica="";
    }
    
    int intCodGrupo = usuario.getIntCodGrupo();
    
    if((usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR) && usuario.getIntIdRol()==Constante.NROLOPE)
    {
      intFlagValidaClinica=1;
    }
    //Fin Req 2011-0849
    
%>
<html>
<head>
<title>CARTA</title>
    <jsp:include page="../general/scripts.jsp" />  
<SCRIPT language="JavaScript">
<!--//
//PRT Funcion que abre un documento xml en base a la seleccion realizada con el radio button en la ventana hija del iframe.
//-->
function exportaxml(URL){
    var frm = document.frmExportaXML;    
    var strNroSolicitud = frm.strSolicitudElegida.value;
    if(strNroSolicitud==""){
        alert('Debe seleccionar un paciente.');
        return;
    }
    frm.action="../flujo/XMLReimpresion.jsp?pnautoriza="+strNroSolicitud;    
    frm.submit();
}
  function verParent(){
      dtSolicitud.style.display = 'none';
      dtConsulta.style.display = '';      
  }
</SCRIPT>
</head>

<BODY leftMargin="0" onload="LoadBody();" onunload="cleansession();" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<TD VALIGN="top"  align="left" width="100%">
<form name="frmBandeja" method="post">
<input type="hidden" name="hcnFlagValidaClinica" value="<%=intFlagValidaClinica%>"/>
<table width="100%" class="2" cellspacing="0" cellpadding="0">
 <tr id="dtConsulta">
 <td>
  <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <div style="margin-left: 10px;margin-right: 10px;margin-top:10px">
        <fieldset class="row5 content_resumen">
        <legend class="titulo_campos_bold">
          Búsqueda
        </legend>  
        <table cellSpacing="1"  border=0 width="100%" style="margin-right: 10px">
         <%
          //Req 2011-0849
          if ((usuario.getIntIdRol()==Constante.NROLASAD || usuario.getIntIdRol()==Constante.NROLADM || usuario.getIntIdRol()==Constante.NROLBRK || usuario.getIntIdRol()==Constante.NROPERFILBRK) || (intFlagValidaClinica==1))
          {
          %>              
            <td align=left class="row5" width="2%" >Clínica :&nbsp;</td>
            <td id="trBuscarClinica" align=left class="row5" width="21%">
              <input class="row5 input_text_sed" maxlength="50" name = "tctDesClinica" type="text" value="<%=strDesClinica%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" >
              &nbsp;&nbsp;<input type="button" class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-search-color" value="Buscar Clínica" onclick="javascript:onClickCargarPagina();"/> 
            </td>                                                                       
            <td colspan=2 align=left class="row5" >                      
                  <select name="lscClinica" class="TxtCombo lp-select" style="width:100%" onchange="javascript:selObj(this);">
                             <option value=0>(Selecccione)</option>
                              <%
                                if (strDesClinica.length()==0)
                                {
                                    strDesClinica = "*:::*";
                                }else{
                                    strDesClinica = "*" + strDesClinica + "*";
                                } 
                               
                                     BeanList lstClinica = gestorClinica.lstClinicaWeb(1,1,"S","1",strDesClinica);
                                
                                      for (int i= 0; i < lstClinica.size(); i++ ){%>                                      
                                          <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3") + " (" + lstClinica.getBean(i).getString("6") + ")"%></option>
                                      <%}                                      
                                
                                    //out.print("<SCRIPT LANGUAGE=\"JavaScript\"> parent.ActiveProceso(false); </script>");                                      
                                %>
                              %>                                      
                   </select>
            </td>    
          <%}
           //Fin Req 2011-0849
          %>  
        <tr>
            <td align=left class="row1"  width="15%">Nro. Siniestro :&nbsp;</td>
            <td align=left width="25%" class="row1">
              <input class="row5 input_text_sed" name = "tctAutoriza" type="text" value="" onKeyPress="javascript:onKeyPressNumero('this');">
            </td>
            <td align=left class="row1"  width="15%">Nombre Paciente :&nbsp;</td>
            <td align=left width="25%" class="row1">
            <!--//PRT Ubicacion de los controles de búsqueda//-->
                  <table><tr>
                  <td align=left class="row1"><input class="row5 input_text_sed" name = "tctAsegurado" type="text" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" maxlength="50" size="50"></td>
                  <td align=left class="row1"><!--<input type="button" class="TxtCombob" value="BUSCAR" onclick="javascript:buscar();"/>-->&nbsp;</td></tr>
                  </table>
            </td>
            <td align=left class="row1"  width="15%">
                <input type="button" class="TxtCombob lq-btn lp-glyphicon lp-glyphicon-search-blanco" value="Buscar" onclick="javascript:buscar();"/>
            </td>            
        </tr>
        
        <tr>
            <td align=left class="row1"  width="15%">Solicitud de Beneficio:&nbsp;</td>
            <td align=left width="25%" class="row1">
                <select class="TxtCombo lp-select" style="width:250px" name="lscGenCover">
                    <option value=-1>--Todos--</option>
                    <option value=217>Beneficio Odontológico</option>
                    <%
                    if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
                    {
                    %>
                    <option value=215>Beneficio Emergencia Accidental</option>
                    <option value=138>Beneficio Emergencia Médica</option>
                    <%
                    }
                    %>
                </select>
            </td>
            <%if (usuario.getIntIdRol()==Constante.NROLADM){%>
               <td align=left class="row1">Clínica :&nbsp;</td>
               <td align=left class="row1">
                     <select name="lscClinica" class="TxtCombo lp-select" style="width:100%">
                          <%
                            BeanList lstClinica = gestorClinica.lstClinica(intIdUsuario);
                            for (int i= 0; i < lstClinica.size(); i++ ){%>
                            <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3")%></option>
                            <%}%>
                          %>
                     </select>                            
               </td>  
               <%}else{%>
                    <td align=left class="row1"  width="15%">&nbsp;</td>
                    <td align=left width="25%" class="row1">&nbsp;</td>
               <%}%>
               <td align=left class="row1">&nbsp;</td>
        </tr>
        </form>
        <!--//PRT se añade un formulario para que viajen los valores
        //strSolicitudElegida : numero de siniestro
        //pntransac : codigo de la cobertura
        //-->        
        <form name="frmExportaXML" method="POST" target="_blank">
        <tr>
              <td align=left class="row1" width="100%" colspan="5">
                <input type="button" class="TxtCombo btn_secundario lp-glyphicon lp-glyphicon-export-color" onclick="javascript:exportaxml('<%=request.getContextPath()%>/flujo/XMLReimpresion.jsp');" value="Exportar a XML" <%=(usuario.getIntIdRol() == Constante.NROPERFILBRK)?"style=\"display:none\"":""%>>
                <input type="hidden" name="strSolicitudElegida"/>
                <input type="hidden" name="pntransac"/>
              </td>        
        </tr>
        </table>
        </fieldset>
        </div>
      </td>
    </tr>
    <tr id="trBusqueda" style="display:none">            
          <td>
            <div style="margin-left: 10px;margin-right: 10px;">
            <fieldset class="row5 content_resumen">
            <legend></legend>          
                 <iframe name="frLstSolicitud" align=left width="100%" height="900" frameborder="0" scrolling="auto" src="../flujo/ListaReimpresion.jsp"></iframe>
            </fieldset>
            </div>
          </td>             
    </tr>
  </table>
 </td>
 </tr>
 <tr>
 <td>
 <tr id="dtSolicitud"  style="display:none">
  <td>
  <table cellSpacing="0" class="2" border=0 width="100%" align="left" >
    <tr >
      <td> 
        <iframe name="procsolicitud" frameborder="0" height="800%" width="100%" scrolling="auto" src="../blancos.html"></iframe>  
      </td>
    </tr>
  </table>
 </td>
 </tr>
</table>
  <iframe name="proceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>
  <iframe name="procatencion" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
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
 }
  function verListado(){
      trBusqueda.style.display = '';      
      frLstSolicitud.location.href = "../flujo/ListaReimpresion.jsp";    
  }
  function onClickCargarPagina(){
     var frmVar = document.forms[0];       
     //ActiveProceso(true);
     frmVar.action = "Reimpresion.jsp?DesClinica=" + frmVar.tctDesClinica.value;
     frmVar.target = "_self";
	   frmVar.submit();                
	} 
  function selObj(obj){
    if (obj.name == 'lscClinica'){
        document.forms[0].target="procatencion";
        document.forms[0].action="../control/ProcesoAcceso?proceso=2&pswebserver=" + obj.value;
        document.forms[0].submit(); 
    }
  }
  function buscar(){

      //Req 2011-0849
      if (document.forms[0].hcnFlagValidaClinica.value==1){          
          if (!valida('lscClinica','s'))
              return;          
      }  
      //Fin Req 2011-0849
    //PRT limpia los datos que ya fueron procesados
    var frm = document.frmExportaXML;
    frm.strSolicitudElegida.value="";
    frm.pntransac.value="";
    //PRT comienza el proceso de busqueda        
    
    var frm = document.forms[0];
        trBusqueda.style.display = '';
        frm.target="frLstSolicitud";        
        frm.action="../flujo/ListaReimpresion.jsp?psbuscar=0";        
        
        frm.submit(); 
  }

  function onKey(obj){
    if(event.keyCode==13)
        buscar();
  }  



  function cleansession(){
    var ret = retValXml("../servlet/SessionClean?proceso=2");
  }
  
  
</script>

</html>