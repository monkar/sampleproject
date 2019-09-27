<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.util.Vector"%>
<jsp:include page="../menu/Menu.jsp" />
<%

    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:02pm
    GestorUsuario gestorUsuario = new GestorUsuario();

    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:34pm
    GestorClinica gestorClinica = new GestorClinica();

    Usuario usuario = null;
    synchronized(session)
    {
       usuario =(Usuario)session.getAttribute("USUARIO");     
    }   
    int intIdUsuario = usuario.getIntIdUsuario();
    
    //Req 2011-0849
    int intFlagValidaClinica=0;
    String strDesClinica=request.getParameter("DesClinica");        
    
    if((usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR) && usuario.getIntIdRol()==Constante.NROLOPE)
    {
      intFlagValidaClinica=1;
    }
    if (strDesClinica ==null){
        strDesClinica="";
    }
    
    //Fin Req 2011-0849    
    String ff=Tool.getDate("dd/MM/yyyy");
    String fi=Tool.addDate(-30,"dd/MM/yyyy");
    String strFechai=(request.getParameter("sFechai")==null?fi:request.getParameter("sFechai"));
    String strFechaf=(request.getParameter("sFechaf")==null?ff:request.getParameter("sFechaf"));
     
%>
<html>
<title>CARTA</title>
    <jsp:include page="../general/scripts.jsp" />  
<head>

</head>
<BODY leftMargin="0" onload="javascript:LoadBody();" onunload="cleansession();" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<form name="frmBandeja" method="post" >
      <input type="hidden" name="hcnFlagValidaClinica" value="<%=intFlagValidaClinica%>"/>
      <table id="tblCliBus" width="100%" class="2" cellspacing="0" cellpadding="0">
      <tr><td>
      
      <%if (intFlagValidaClinica==1)
       {
      %> 
              <table cellSpacing="1" border=0 width="100%">
                    <tr>                    
                       <td colspan=4>
                           <table cellSpacing="1" border=0 width="100%" class="form-table-controls">
                               <tr>
                                  <td align=right class="row5" width="2%" >Clínica :&nbsp;</td>
                                  <td align=left class="row5" width="21%">
                                        <table cellSpacing="1"  border=0 width="100%">                                  
                                          <tr id="trBuscarClinica" >
                                              <td>
                                                  <input class="row5 input_text_sed" maxlength="50" name = "tctDesClinica" type="text" value="<%=strDesClinica%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" >
                                                  <input type="button" class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-search-color" value="Buscar Clínica    " onclick="javascript:onClickCargarPagina();"/>                                              
                                              </td>
                                          </tr>
                                        </table>                                  
                                  </td>                                                                       
                                  <td colspan=2 align=left class="row5" >
                                        <input type="hidden" name="validaCombo" value="0"/>
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
                                                      
                                                          //out.print("<SCRIPT LANGUAGE=\"JavaScript\"> parent.ActiveProceso(false); </script>");                                      
                                                      %>
                                                    %>                                      
                                             </select> 
                                            
                                  </td>                     
                               </tr>  
                           </table>	
                       </td>
                    </tr>
              </table>
            
      <%}%>
      </td></tr>
      </table>
      
<input type="hidden" name="hcnTipoSol" value=""/>
<table width="100%" class="2" cellspacing="0" cellpadding="0">
 <tr id="dtConsulta">
 <td>
  <table id="tabCSoli" width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
    <div id="divTab">
    <tr>
      <td>
        <fieldset class="row5 content_resumen">
        <legend></legend>        
        <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
        <tr>
            <td align=left class="row1"  width="15%">Nro. Solicitud :&nbsp;</td>
            <td align=left width="25%" class="row1">
              <input class="row5 input_text_sed" name = "tctAutoriza" type="text" value="" onKeyPress="javascript:onKeyPressNumero('this');">
            </td>
            <td align=left class="row1"  width="15%">Tipo Solicitud :&nbsp;</td>
            <td align=left width="25%" class="row1">
            <%
            //Req 2011-0849
            String queryTipoSolicitud = "";
            if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
            {
              queryTipoSolicitud = "SELECT NIDTIPOSOLICITUD, SNOMBRE FROM PTBLTIPO_SOLICITUD WHERE NFLGACTIVO=1";
            }
            else
            {
              queryTipoSolicitud = "SELECT NIDTIPOSOLICITUD, SNOMBRE FROM PTBLTIPO_SOLICITUD WHERE NFLGACTIVO=1 AND NFLGBANDEJA=1";
            }
            //Fin Req 2011-0849
            %>
                <select class="TxtCombo lp-select" style="width:180px" name="lscTipoSol">
                    <option value=0>(Todos)</option>
                    <%
                      BeanList objLista = new BeanList();
                      objLista = Tool.obtieneLista(queryTipoSolicitud,"");
                      out.println(Tool.listaCombo(objLista,"NIDTIPOSOLICITUD","SNOMBRE"));
                    %>
                </select>
            </td>
            <td align=left class="row1"  width="15%">
                <input type="button" class="TxtCombob lq-btn lp-glyphicon lp-glyphicon-search-blanco" value="Buscar" onclick="javascript:buscar();"/>
            </td>            
        </tr>
        <tr>
            <td align=left class="row1"  width="15%">Nombre Paciente :&nbsp;</td>
            <td align=left width="25%" class="row1">
              <input class="row5 input_text_sed" name = "tctAsegurado" type="text" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" maxlength="50" size="50">
            </td>         
            <td align=left class="row1"  width="15%">Estado :&nbsp;</td>
            <td align=left width="25%" class="row1" >
                <select class="TxtCombo lp-select" style="width:180px" name="lscEstado">
                    <option value=0>(Todos)</option>
                    <%
                      objLista = new BeanList();
                      objLista = Tool.obtieneLista("SELECT NIDESTADO, SNOMBRE FROM PTBLESTADO_SOLICITUD WHERE NFLGACTIVO=1","");
                      out.println(Tool.listaCombo(objLista,"NIDESTADO","SNOMBRE"));
                    %>
                </select>
            </td>
            <td align=left class="row1">&nbsp;</td>
        </tr>
        <tr>
            <td align=left class="row1"  width="15%">Rol :&nbsp;</td>
            <td align=left width="25%" class="row1">
                <select class="TxtCombo lp-select" style="width:180px" name="lscRol">
                    <option value=0>(Todos)</option>
                    <%
                      objLista = new BeanList();
                      objLista = Tool.obtieneLista("SELECT NIDROL, SNOMBRE FROM PTBLROL WHERE NFLGACTIVO = 1","");
                      out.println(Tool.listaCombo(objLista,"NIDROL","SNOMBRE"));
                    %>
                </select>
            </td>
            <td align=left class="row1"  width="15%">Oficina&nbsp;</td>            
            <td align=left width="25%" class="row1" colspan="2">
                <select class="TxtCombo lp-select" style="width:180px" name="lscOficina">
                    <option value=0>(Todos)</option>
                    <%
                      objLista = gestorUsuario.getlstOficina();
                      out.println(Tool.listaCombo(objLista,"CODOFICINA","DESCRIPCION"));
                    %>
                </select>
            </td>
        </tr>
            <td align=left class="row1"  width="15%">Fecha Inicio:&nbsp;</td>
            <td align=left width="25%" class="row1">
                <input class="row5 input_text_sed" maxlength="10" name = "tctFechaIni" type="text" value="<%=strFechai%>" onblur="validaFecha(this.name);" onKeyPress="javascript:onKeyPressFecha(this);">
            </td>
            <td align=left class="row1"  width="15%">Fecha Fin:&nbsp;</td>
            <td align=left width="25%" class="row1" colspan="2">
                <input class="row5 input_text_sed" maxlength="10" name = "tctFechaFin" type="text"  value="<%=strFechaf%>" onblur="validaFecha(this.name);" onKeyPress="javascript:onKeyPressFecha(this);">
            </td>
        </tr>
        <tr>  
           <td align=left class="row1">Clínica :&nbsp;</td>
           <%if (usuario.getIntIdRol()!=Constante.NROLENF && usuario.getIntIdRol()!=Constante.NROLOPE){%>
               <td align=left class="row1" colspan=3>
                   <select name="lscClinica" class="TxtCombo lp-select" style="width:40%">
                          <option value="">(Todos)</option>
                        <%
                          BeanList lstClinica = gestorClinica.lstClinica(intIdUsuario);
                          for (int i= 0; i < lstClinica.size(); i++ ){%>
                          <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3")%></option>
                          <%}%>
                        %>
                    </select>                            
               </td>
           <%}else{%>
              <td align=left class="row1" colspan=3>
                  <%=usuario.getStrNombreExt()%>
                  <input type="hidden" name="lscClinica" value="<%=(usuario.getIntIdRol()==Constante.NROLENF || usuario.getIntIdRol()==Constante.NROLOPE?usuario.getStrWebServer():"")%>"/>
              </td>
          <%}%>
           <td align="rigth" class="row1">
                 <INPUT type="checkbox" class="TxtCombo" name="chcExportar">Exportar consulta&nbsp;
           </td>
           
        </tr>
        <tr>
          <td align=left class="row1"  width="15%">Registros Encontrados:&nbsp;</td>
          <td align=left width="25%" class="row1" colspan="4">
                 <input class="row5 input_text_sed" name = "tctNumReg" type="text" size="5" value="" disabled="disabled">
                 &nbsp;&nbsp;Hora de Consulta:&nbsp;
                 <input class="row5 input_text_sed" name = "tctHoraCons" type="text" size="20" value="" disabled="disabled">
          </td>
        </tr>
        
        </table>
        </div>
        </fieldset>
      </td>
    </tr>
    <tr id="trBusqueda" style="display:none">
      <td>
        <fieldset class="row5 content_resumen">
        <legend></legend>  
          <iframe name="frLstSolicitud" align=left width="100%" height="700" frameborder="0" scrolling="auto" src="../consultasolicitud/ListaSolicitud.jsp"></iframe>
        </fieldset>
      </td>
    </tr>
    <tr id="trExcel" style="display=''">
      <td>
        <fieldset class="row5 content_resumen">
        <legend></legend>  
          <iframe name="frmLstSolicitud" align=left width="100%" height="600" frameborder="0" scrolling="auto" src="../consultasolicitud/ListaSolicitud.jsp"></iframe>
        </fieldset>
      </td>
    </tr>
    </div>
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
  function onClickCargarPagina(){ 
     var frmVar = document.forms[0];       
     //ActiveProceso(true);
     frmVar.action = "ConsultaSolicitud.jsp?DesClinica=" + frmVar.tctDesClinica.value;
     frmVar.target = "_self";
	   frmVar.submit();                
	} 
   
   function selObj(obj)
   {
    if (obj.name == 'lscClinica')
    {
        document.forms[0].target="procatencion";
        document.forms[0].action="../control/ProcesoAcceso?proceso=2&pswebserver=" + obj.value;
        document.forms[0].validaCombo.value = obj.value;
        document.forms[0].submit(); 
    }
  }
  function LoadBody(){
  }
  
  function verListado(){
      trBusqueda.style.display = '';
      frLstSolicitud.location.href = "../flujo/ListaSolicitud.jsp";    
  }
function validaSeleccion() {  

var obj=document.forms[0].validaCombo;


  if (obj.value=='0' || obj.value==''){
    alert("Debe seleccionar por lo menos un elemento de la lista");
    var comb = document.forms[0].lscClinica;
    comb.focus();
    return false;
    }


    return true;  
}
  function buscar(){
    var frm = document.forms[0];
    
    if (frm.hcnFlagValidaClinica.value==1){          
      if (!validaSeleccion())
              return;          
    }   
   
        trBusqueda.style.display = '';
        frm.target="frLstSolicitud";
        if (validaFechas()==true)
        {
            var flgExportar = 0;
            if(frm.chcExportar.checked==true)
                flgExportar=1;
            frm.action="../consultasolicitud/ListaSolicitud.jsp?flgBuscar=1&flgExportar=" + flgExportar;        
            frm.submit(); 
        }
        else 
        {
           return 
        }
  }
  
  function validaFechas()
  {
      var frm = document.forms[0];
      if( valida('tctFechaIni','t') && valida('tctFechaFin','t'))
      {
            if (!compararFecha(frm.tctFechaFin.value,frm.tctFechaIni.value)){
                    alert('Intervalo de fechas incorrecto');
                    return false;
            }
            return true;
      }
      else
      {
        return false;
      }
  }

  function onKey(obj){
    if(event.keyCode==13)
        buscar();
  }  

  function verParent(){
      dtSolicitud.style.display = 'none';
      dtConsulta.style.display = '';
      parent.tabCSoli.style.display = '';
      parent.tblCliBus.style.display = '';
  }

  function cleansession(){
    var ret = retValXml("../servlet/SessionClean?proceso=2");
  }
  
  function Exportar(){ 
   var url="../consultasolicitud/ToExcel.jsp";
   x=window.open(url);
   x.moveTo(0,0);
   x.resizeTo(window.screen.availWidth,window.screen.availHeight);
   x.focus();
  }
  
  function datosConsulta(numReg, hora)
  { 
    var frm = document.forms[0];
    frm.tctNumReg.value=numReg;
    frm.tctHoraCons.value=hora;
  }

  
</script>

</html>

