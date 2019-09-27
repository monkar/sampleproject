<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.utils.*"%>
<%
    int intIdUsuario = Tool.parseInt(request.getParameter("usuario"));
    String strLogin = request.getParameter("login");
%>

<html>
<head>
    <title>Confirmación de Clave</title>
    <jsp:include page="../general/scripts.jsp" />
</head>
<BODY leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0">
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
    <form name="frmClave" method="post">   
        <input name="hndUsuario" type="hidden" value="<%=intIdUsuario%>">
        <input name="hndLogin" type="hidden" value="<%=strLogin%>">
        
        <fieldset class="row5 content_resumen">
        <legend></legend>
        <table cellspacing="2" cellpadding="2" border="0"  width="100%" align="center" class="form-table-controls">
            <tr>
                <td colspan="2" class="row1" align="right">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2" class="row1" align="left">
                    Por medidas de seguridad debe reingresar su usuario y password.
                    <br>Si tiene alguna consulta por favor comunicarse con nosotros:
                    <br><br>Lima 211-0-211 
                    <br>Prov 0800-1-0800 (Gratuito).
                </td>
            </tr>
            <tr>
                <td colspan="2" class="row1" align="right">&nbsp;</td>
            </tr>
            <tr>
                <td class="row1"  align="left">
                    <font color=#ff0000>* </font>Usuario :&nbsp;
                </td>
                <td class="row1" align="left">
                    <input class="TxtCombo input_text_sed" name=tctUsuario width="80%">
                </td>
            </tr>   
            <tr>
                <td class="row1"  align="left">
                    <font color=#ff0000>* </font>Password :&nbsp;
                </td>
                <td class="row1" align="left">
                    <input class="TxtCombo input_text_sed" name=tctClave1 width="80%" type=password>
                </td>
            </tr>
            <tr>
                <td class="row1"  align="left">
                    <font color=#ff0000>* </font>Confirmación Password :&nbsp;
                </td>
                <td class="row1" align="left">
                    <input class="TxtCombo input_text_sed" name=tctClave2 type=password width="80%">
                </td>
            </tr>
            <tr>
                <td class="row1" align="right" colspan="2">
                    <input size=10 type="button" class="row5 lq-btn lp-glyphicon lp-glyphicon-save-blanco" onclick="javascript:envia();" value="Grabar">
                </td>
            </tr>
            <iframe name="frmProceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>
        </table>
        </fieldset>
    </form>
</BODY>
</html>

<script type="text/javascript">

function envia()
{
    var frmVar = document.forms[0];
    
    var clave1 = frmVar.tctClave1.value;
    var clave2 = frmVar.tctClave2.value;
    var usuario = frmVar.tctUsuario.value;  

    if (usuario != frmVar.hndLogin.value)
    {
        alert("El usuario ingresado es incorrecto.");
        return;
    }
    
    
    if(clave1!= '' && usuario != '' && clave1==clave2)
    {
        frmVar.target = "frmProceso";
        frmVar.action = "../control/ProcesoAcceso?proceso=3"; 
        frmVar.submit(); 
    }
    else
    {
        alert("Las claves ingresadas no coinciden.");
    }
}

</script>