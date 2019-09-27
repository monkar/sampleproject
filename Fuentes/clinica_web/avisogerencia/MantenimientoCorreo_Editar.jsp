<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%   

      String strTitulo = "Configuración de Correo";
      String strSubTitulo = "Nuevo";
      int intSec =  (request.getParameter("idSec")!=null?Tool.parseInt(request.getParameter("idSec")):0);
      int intAlerta =  (request.getParameter("idAlerta")!=null?Tool.parseInt(request.getParameter("idAlerta")):0);
      int intZona =  (request.getParameter("idZona")!=null?Tool.parseInt(request.getParameter("idZona")):0);
      String sCargo =  (request.getParameter("sCargo")!=null?(request.getParameter("sCargo")).toString():"");
      String sApellido =  (request.getParameter("sApellido")!=null?(request.getParameter("sApellido")).toString():"");
      String sNombre =  (request.getParameter("sNombre")!=null?(request.getParameter("sNombre")).toString():"");
      String sEmail =  (request.getParameter("sEmail")!=null?(request.getParameter("sEmail")).toString():"");
      int intEstado =  (request.getParameter("idEstado")!=null?Tool.parseInt(request.getParameter("idEstado")):0);
      
      
      GestorUsuario gestorUsuario = new GestorUsuario();
      GestorAlerta gestorAlerta = new GestorAlerta();
      BeanList lstAlerta = gestorAlerta.getlstAlerta(); 
      BeanList lstZona = gestorUsuario.getlstZona(); 
      
      int intFlgEdit = 1;
      if(intSec>0)
      {
          intFlgEdit = 0;
          strSubTitulo = "Editar";     
      }
%>


<jsp:include page="../menu/Menu.jsp" />
<html>
  <head>
    <title>
      <%=strTitulo%>
    </title>
    <jsp:include page="../general/scripts.jsp" />  
    <LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
    <script type="text/javascript">

    function LoadBody() 
    { 
         var frm = document.forms[0]; 
         <%if(intFlgEdit==0){%>
              frm.chcEstado.disabled=false;
              frm.tctSec.disabled=true;
              frm.lscZona.disabled=true;
              frm.lscAlerta.disabled=true;
              
              frm.tctSec.value = <%=intSec%>;
              frm.lscZona.value = <%=intZona%>;
              frm.lscAlerta.value = <%=intAlerta%>;
              frm.tctCargo.value = '<%=sCargo%>';
              frm.tctApellidos.value = '<%=sApellido%>';
              frm.tctNombres.value = '<%=sNombre%>';
              frm.tctEmail.value = '<%=sEmail%>';
              
              if(<%=intEstado%>==1)
                  frm.chcEstado.checked=true;
         <%}else{%>
               LimpiaForm();
         <%}%>
    }
    
    function LimpiaForm()
    {
        var frm = document.forms[0];
        frm.tctSec.disabled=true;
        frm.lscZona.disabled = false;
        frm.lscAlerta.disabled = false;
        frm.tctSec.value = '0';
        frm.lscZona.value = '0';
        frm.lscAlerta.value = '0';
        frm.tctCargo.value = '';
        frm.tctApellidos.value = '';
        frm.tctNombres.value = '';
        frm.tctEmail.value = '';
        frm.chcEstado.checked=true;
        frm.chcEstado.disabled=true;
    }
    
    function Regresar()
    {
        var frm = document.forms[0]; 
        window.location.href = "../avisogerencia/MantenimientoCorreo.jsp"; 
    }
    
    function Grabar() 
    { 
        var frm = document.forms[0];
        var hctAcc = null;
        
        if (validaForm()==false)
            return;
        
        <%if(intFlgEdit==0){%>
              hctAcc = "edita";
         <%}else{%>
              hctAcc = "crea";
         <%}%>
         
        var nSec = frm.tctSec.value;
        var nZona = frm.lscZona.value;
        var nAlerta = frm.lscAlerta.value;
        var sCargo = frm.tctCargo.value;
        var sApellido = frm.tctApellidos.value;
        var sNombre = frm.tctNombres.value;
        var sEmail = frm.tctEmail.value;
        var nEstado = 0;
        if(frm.chcEstado.checked==true)
            nEstado=1;
       
        frm.target="proceso";
        frm.action="../servlet/ProcesoMant?proceso=9&hctAcc="+ hctAcc +"&nSec="+ nSec +"&nZona="+ nZona +"&nAlerta="+ nAlerta +"&sCargo="+ sCargo +"&sApellido="+ sApellido +"&sNombre="+ sNombre +"&sEmail="+ sEmail +"&nEstado="+ nEstado;
        frm.submit();
    }
    
    function validaForm()
    {    
        var frm = document.forms[0];
        if (!valida('lscZona','s'))      
            return false; 
        if (!valida('lscAlerta','s'))      
            return false; 
        if (!valida('tctCargo','t')) 
            return false; 
        if (!valida('tctApellidos','t')) 
            return false; 
        if (!valida('tctNombres','t')) 
            return false; 
        if (!valida('tctEmail','t')) 
            return false; 
        if (!validarEmail('tctEmail'))
            return false;
        return true; 
    } 
  
    function verAlerta(valor) 
    { 
        if (valor == -1)
            alert("Ocurrió un error técnico al grabar la configuración de uso de la cobertura");
        if (valor == -2)
            alert("No se actualizará ningún valor, no se realizaron cambios.");
            
        Regresar();
    }
    
</script>
  </head>
  <body onload="LoadBody()" leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0">
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
  <div style="margin-left: 10px;margin-right: 10px; margin-top:10px;">
  <TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
    <TR>
    <TD VALIGN="top"  align="left" width="100%" >
    <form name="frmMantCorreo" method="post"> 
        <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                    <legend></legend>  
                    <table cellSpacing="1"  border=0 width="100%">
                        <tr>
                            <td colspan=2 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt" align="left">
                                <b><%=strSubTitulo%>&nbsp;-&nbsp;Configuraci&oacute;n&nbsp;de&nbsp;Correo</b>
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2 class="row7">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="left" class="row7">
                                <A href="javascript:Grabar()"  class="lq-btn lp-glyphicon lp-glyphicon-save-blanco">&nbsp;Grabar</A>                               
                            </td>
                            <td align="right" class="row7">
                                <A href="javascript:Regresar()" class="btn_secundario lp-glyphicon lp-glyphicon-return-color">Regresar</A>                                  
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="row1" colspan="2">
                                &nbsp;
                            </td>
                        </tr>
                        <tr> 
                            <td class="header" width="10%">Item</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctSec" type="text" maxlength="30" style="width:5%">
                            </td>
                        </tr>
                        <tr> 
                            <td class="header" width="10%">Zona</td>
                            <td class="row1">
                                <select class="TxtCombo lp-select" style="width:20%" name="lscZona">
                                    <option value=0>(Seleccione)</option>
                                    <%=Tool.listaCombo(lstZona,"NIDZONA","SNOMBRE")%>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="header" width="10%">Alerta</td>
                            <td class="row1">
                                <select class="TxtCombo lp-select" style="width:20%" name="lscAlerta">
                                    <option value=0>(Seleccione)</option>
                                    <%=Tool.listaCombo(lstAlerta,"NIDALERTA","SDESCRIPCION")%>
                                </select>                                
                            </td>       
                        </tr>
                        <tr> 
                            <td class="header" width="10%">Cargo</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctCargo" type="text" maxlength="30" style="width:40%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);">
                            </td>
                        </tr>
                        <tr> 
                            <td class="header" width="10%">Apellidos</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctApellidos" type="text" maxlength="40" style="width:40%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);">
                            </td>
                        </tr>
                        <tr> 
                            <td class="header" width="10%">Nombres</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctNombres" type="text" maxlength="40" style="width:40%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);">
                            </td>
                        </tr>
                        <tr> 
                            <td class="header" width="10%">E-Mail</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctEmail" type="text" maxlength="50" style="width:40%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);">
                            </td>
                        </tr>
                        <tr id="dtEstado">
                            <td align=left class="header"  width="15%">Activo&nbsp;:&nbsp;
                            </td>
                            <td align=left class="row1">
                                <INPUT type="checkbox" class="TxtCombo" name="chcEstado" >
                            </td>          
                        </tr>
                    </table>
                    </fieldset>
                </td>
            </tr>
        </table>
        <iframe name="proceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
    </form>
    </TD>
    </TR>
    </TABLE> 
    </div>
  </body>
</html>
