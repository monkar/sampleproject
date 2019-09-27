<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<jsp:include page="../menu/Menu.jsp" />
<%
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:02pm
    GestorUsuario gestorUsuario = new GestorUsuario();

    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:35pm
    GestorClinica gestorClinica = new GestorClinica();
      
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");      
    }  
    int intIdUsuario = usuario.getIntIdUsuario();
%>
<html>
<head>
<title>CARTA</title>
    <jsp:include page="../general/scripts.jsp" />  
</head>

<BODY leftMargin="0" onunload="cleansession();" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<form name="frmBandeja" method="post">
<input type="hidden" name="hcnTipoSol" value=""/>
<table width="100%" class="2" cellspacing="0" cellpadding="0">
 <tr id="dtConsulta">
 <td>
  <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <div style="margin-left: 10px;margin-right: 10px;margin-top: 8px;">
        <fieldset class="row5 content_resumen">
        <legend></legend>  
        <table cellSpacing="1"  border=0 width="100%">
        <tr>
            <td align=left class="row1"  width="15%">Nro. Siniestro :&nbsp;</td>
            <td align=left width="25%" class="row1">
              <input class="row5 input_text_sed" name = "tctAutoriza" type="text" value="" onKeyPress="javascript:onKeyPressNumero('this');">
            </td>
            <td align=left class="row1"  width="15%">Tipo Solicitud :&nbsp;</td>
            <td align=left width="25%" class="row1">
                <select class="TxtCombo lp-select" style="width:180px" name="lscTipoSol">
                    <option value=0>--Todos--</option>
                    <%
                      BeanList objLista = new BeanList();
                      objLista = Tool.obtieneLista("SELECT NIDTIPOSOLICITUD, SNOMBRE FROM PTBLTIPO_SOLICITUD WHERE NFLGACTIVO=1 AND NFLGBANDEJA=1","");
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
            <td align=left class="row1"  width="15%">Oficina:&nbsp;</td>
            <%if (usuario.getIntIdRol()==Constante.NROLADM){%>
                <td align=left width="25%" class="row1">
                    <select class="TxtCombo lp-select" style="width:180px" name="lscOficina">
                        <option value=0>(Todos)</option>
                        <%
                          objLista = gestorUsuario.getlstOficina();
                          out.println(Tool.listaCombo(objLista,"CODOFICINA","DESCRIPCION"));
                        %>
                    </select>
                </td>
            <%}else{%>
                <td align=left class="row1">
                    <%
                    BeanList objListaOficinas = gestorUsuario.getOficinasConfiguracionUsuario(intIdUsuario);
                    if (objListaOficinas.size() == 1) {%>
                        <%=gestorUsuario.getNombOficina(usuario.getIntCodOficina())%>
                        <input type="hidden" name="lscOficina" value="<%=usuario.getIntCodOficina()%>"/>
                    <%}else{%>
                        <select class="TxtCombo lp-select" style="width:180px" name="lscOficina">
                            <option value=0>(Todos)</option>
                            <%
                              out.println(Tool.listaCombo(objListaOficinas,"CODOFICINA","DESCRIPCION"));
                            %>
                        </select>
                    <%}%>
                </td>
            <%}%>        
            <td align=left class="row1">&nbsp;</td>
        </tr>
        <tr style='<%=(usuario.getIntIdRol()==Constante.NROLADM?"":"display=''none")%>'>
           <%if (usuario.getIntIdRol()==Constante.NROLADM){%>
            <td align=left class="row1">Clínica :&nbsp;</td>
            <td align=left class="row1" colspan=2>
                   <select name="lscClinica" class="TxtCombo lp-select" style="width:90%">
                        <option value="">--Todos--</option>
                        <%
                          BeanList lstClinica = gestorClinica.lstClinica(intIdUsuario);
                          for (int i= 0; i < lstClinica.size(); i++ ){%>
                          <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3")%></option>
                          <%}%>
                    </select>                            
            </td>            
            <td align=left class="row1" colspan=3>&nbsp;</td>
            <%}else{%>
            <td align=left class="row1" colspan=5>
            <input type="hidden" name="lscRol" value="<%=usuario.getIntIdRol()%>"/>            
            <input type="hidden" name="lscClinica" value="<%=(usuario.getIntIdRol()==Constante.NROLOPE?usuario.getStrWebServer():"")%>"/>
            </td>
            <%}%>        
        <tr>        
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
          <iframe name="frLstSolicitud" align=left width="100%" height="600" frameborder="0" scrolling="auto" src="../flujo/ListaHistorico.jsp"></iframe>
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
</form>
</TD>
</TR>
</TABLE>
</body>
<script type="text/javascript">
  function verListado(){
      trBusqueda.style.display = '';
      frLstSolicitud.location.href = "../flujo/ListaHistorico.jsp";    
  }

  function buscar(){
    var frm = document.forms[0];
        trBusqueda.style.display = '';
        frm.target="frLstSolicitud";
        frm.action="../flujo/ListaHistorico.jsp?psbuscar=1";        
        frm.submit(); 
  }

  function onKey(obj){
    if(event.keyCode==13)
        buscar();
  }  

  function verParent(){
      dtSolicitud.style.display = 'none';
      dtConsulta.style.display = '';      
  }

  function cleansession(){
    var ret = retValXml("../servlet/SessionClean?proceso=2");
  }
  
  
</script>

</html>
