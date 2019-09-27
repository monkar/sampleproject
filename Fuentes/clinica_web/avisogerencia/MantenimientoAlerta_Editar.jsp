<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%   

      String strTitulo = "Configuración de Montos Alerta";
      String strSubTitulo = "Nuevo";
      int intAlerta =  (request.getParameter("nAlerta")!=null?Tool.parseInt(request.getParameter("nAlerta")):0);
      String sDescripcion = (request.getParameter("sDescripcion")!=null?(request.getParameter("sDescripcion").toString()):"");
      double dblMontoMinimo =  (request.getParameter("nMontoMin")!=null?Tool.parseDouble(request.getParameter("nMontoMin")):0);
      double dblMontoMaximo =  (request.getParameter("nMontoMax")!=null?Tool.parseDouble(request.getParameter("nMontoMax")):0);
      int intEstado =  (request.getParameter("nEstado")!=null?Tool.parseInt(request.getParameter("nEstado")):0);
      
      int intFlgEdit = 1;
      if(intAlerta>0)
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
    <script type="text/javascript">

    function LoadBody() 
    { 
         var frm = document.forms[0]; 
         <%if(intFlgEdit==0){%>
              
              frm.chcEstado.disabled=false;
              frm.tctAlerta.disabled=true;
              frm.tctAlerta.value=<%=intAlerta%>;
              frm.tctDescripcion.value= '<%=sDescripcion%>';
              frm.tctMontoMinimo.value=<%=dblMontoMinimo%>;
              frm.tctMontoMaximo.value=<%=dblMontoMaximo%>;
              if(<%=intEstado%>==1)
                  frm.chcEstado.checked=true;
                  frm.tctAlerta.disabled=true;
         <%}else{%>
               LimpiaForm();
         <%}%>
    }
    
    function LimpiaForm()
    {
        var frm = document.forms[0];
        frm.tctAlerta.value='0';
        frm.tctAlerta.disabled=true;
        frm.tctDescripcion.value='';
        frm.tctMontoMinimo.value='0.00';
        frm.tctMontoMaximo.value='0.00';
        frm.chcEstado.checked=true;
        frm.chcEstado.disabled=true;
    }
    
    function Regresar()
    {
        var frm = document.forms[0]; 
        window.location.href = "../avisogerencia/MantenimientoAlerta.jsp"; 
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
        
        var nAlerta = frm.tctAlerta.value;
        var sDescripcion = frm.tctDescripcion.value.replace("'", "");
        var nMontoMinimo = frm.tctMontoMinimo.value;
        var nMontoMaximo = frm.tctMontoMaximo.value;
        
        var nEstado = 0;
        if(frm.chcEstado.checked==true)
            nEstado=1;
        
        frm.target="proceso";
        frm.action="../servlet/ProcesoMant?proceso=8&hctAcc="+ hctAcc +"&nAlerta=" + nAlerta + "&sDesc=" + sDescripcion + "&nMontoMax=" + nMontoMaximo + "&nMontoMin=" + nMontoMinimo + "&nEstado=" + nEstado;
        frm.submit();
     
    }
    
    function validaForm()
    {    
        var frm = document.forms[0];
        if (!valida('tctDescripcion','t')) 
            return false; 
        if (!valida('tctMontoMinimo','nc'))      
            return false;             
        if (!valida('tctMontoMaximo','nc'))      
            return false;             
        return true; 
    } 
  
    function verAlerta(valor) 
    { 
        if (valor == -1)
            alert("Ocurrió un error técnico al grabar la configuración de uso de la cobertura");
        if (valor == -2)
            alert("No se puede registrar la configuración. Existe una Alerta configurada para dichos rangos.");   
        if (valor == -3)
            alert("No se actualizará ningún valor, no se realizaron cambios.");
        if (valor == -4)
            alert("No se puede desactivar la alerta, debido a que tiene correos configurados.");
            
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
    <form name="frmMantAlerta" method="post"> 
        <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                    <legend></legend>  
                    <table cellSpacing="1"  border=0 width="100%">
                        <tr>
                            <td colspan=2 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt" align="left">
                                <%=strSubTitulo%>&nbsp;-&nbsp;Configuraci&oacute;n&nbsp;de&nbsp;Montos&nbsp;Alerta
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2 class="row7">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="left" class="row7">
                                <A href="javascript:Grabar()" class="lq-btn lp-glyphicon lp-glyphicon-save-blanco">&nbsp;Grabar</A>                               
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
                            <td class="header" width="10%">Alerta</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctAlerta" type="text" maxlength="10" style="width:50%" >
                            </td>
                        </tr>                        
                        <tr> 
                            <td class="header" width="10%">Descripción</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctDescripcion" type="text" maxlength="30" style="width:70%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);">
                            </td>
                        </tr>
                        <tr>
                            <td align=left class="header" width="15%">Monto M&iacute;nimo:&nbsp;</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctMontoMinimo" type="text" maxlength="10" style="width:50%" onKeyPress="javascript:onKeyPressNumero('this');">
                            </td>       
                        </tr>
                        <tr>
                            <td align=left class="header" width="15%">Monto M&aacute;ximo:&nbsp;</td>
                            <td class="row1">
                                <input class="row5 input_text_sed" name = "tctMontoMaximo" type="text" maxlength="10" style="width:50%" onKeyPress="javascript:onKeyPressNumero('this');">
                            </td>       
                        </tr>
                        <tr id="dtEstado">
                            <td align=left class="header" width="15%">Activo&nbsp;:&nbsp;
                            </td>
                            <td align=left class="row1">
                                <INPUT type="checkbox" class="TxtCombo" name="chcEstado">
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
