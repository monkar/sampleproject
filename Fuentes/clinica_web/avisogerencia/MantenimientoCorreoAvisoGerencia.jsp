<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<jsp:include page="../menu/Menu.jsp" />
<%
 
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

<BODY leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<form name="frmMantCorreoAvisoGerencia" method="post">
<table width="100%" class="2" cellspacing="0" cellpadding="0">
 <tr id="dtConsulta">
 <td>
  <table width="100%" class="2" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
        <legend class="titulo_campos_bold">Correos de Aviso de Gerencia</legend>  
        <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
        <tr>
            <td align=left class="row1"  width="15%">Correo CC :&nbsp;</td>
            <td align=left width="25%" class="row1">
              <input class="row5 input_text_sed" name = "tctEmail" id="tctEmail" type="text" value="" style="width:250px" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);">
              <A href="javascript:Grabar(document.forms[0].tctEmail,'CREA');">
                 <img alt=Adicionar height="16" width="16" src="../images/Iconos/14x14-color/Iconos-14x14-color-44.png" border=0/>                  
              </A>
            </td>
            <td align=left class="row1"  width="15%">
                
            </td>            
        </tr>
        <tr>
            <td align=left class="row1"  width="15%">&nbsp;</td>
                <td align=left width="25%" class="row1" >
                    <select class="TxtCombo lp-select" style="width:250px;height:200px;" name="lscCorreoCC" multiple>
                        <%BeanList objLista = new BeanList();
                          objLista = new BeanList();
                          objLista = Tool.obtieneLista("SELECT NIDSEC, SCORREO FROM PTBLCORREO_CONFIG WHERE NTYPE = 2 AND NESTADO=1","");
                          out.println(Tool.listaCombo(objLista,"NIDSEC","SCORREO"));
                        %>  
                    </select>
                    <A href="javascript:Grabar(document.forms[0].lscCorreoCC,'DEL');">
                       <img alt=Eliminar height="16" width="16" src="../images/Iconos/14x14-color/Iconos-14x14-color-58.png" border=0/>                  
                    </A>
                </td>
            <td align=left class="row1"  width="15%">
                
            </td>                  
        </tr>
        </table>
        </fieldset>
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
</div>
</body>
<script type="text/javascript">
  
function Grabar(control, option)                               
{                                                                          
    var idcorreo = 0;
    var correo = '';
    if (option == 'DEL')
    {
      for(var i=0; i<control.options.length; i++)                         
      {                                                                
        if(control.options[i].selected && control.options[i].value != "")  
        {
          idcorreo = control.options[i].value;
        }
      }
    }
    if (option == 'CREA')
    {
      if (validaForm()==false)
        return;
      
      correo = control.value;
    }
    
    if (idcorreo != 0 || correo != '')
    {
      frmMantCorreoAvisoGerencia.action="../servlet/ProcesoMant?proceso=10&hctAcc=" + option + "&idcorreo=" + idcorreo + "&correo=" + correo;
      frmMantCorreoAvisoGerencia.submit();       
    }
}

function validaForm()
    {    
        var frm = document.forms[0]; 
        if (!validarEmail('tctEmail'))
            return false;
        
       for(var i=0; i<frm.lscCorreoCC.options.length; i++)                         
        {              
          var correo = frm.lscCorreoCC.options[i].text;
          var correoadd = frm.tctEmail.value;
          if(trim(correo) == trim(correoadd))  
          {
            alert("El correo ingresado ya existe.");
            return false;
          }
        }
        return true; 
    } 

</script>

</html>
