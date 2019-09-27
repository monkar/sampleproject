<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>

<% 
   /*Se instancio la clase GestorRol, que accede a los metodos DAOS YahirRivas 29FEB2012 10:58am */
    GestorRol gestorRol = new GestorRol();

    BeanList lstRoles = gestorRol.getLstRol(); 
    int intRol=(request.getParameter("lscRol")!=null?Tool.parseInt(request.getParameter("lscRol")):0);  
%>

<jsp:include page="../menu/Menu.jsp" />
<html>
<head>
<title>ADMINITRACION DE MODULOS POR ROL</title>
    <jsp:include page="../general/scripts.jsp" />         
<script type="text/javascript">

function LoadBody()
{
  window.focus();
  var frm=document.forms[0];  
  var idRol = <%=intRol%>;
  if(idRol!=0)
      frm.lscRol.value=idRol;
}

function selModulo(combo1,combo2)                               
{                                                                        
   
    move(combo1,combo2);                 
    
    for (i=0;i<combo1.options.length;i=i+1)                          
    {                                                            
       combo1.options[i].selected=false;   
    }         
}
                           
function selModuloAux(combo1,combo2)                               
{                                                                  
   
    move(combo1,combo2);                 
  
    for (i=0;i<combo1.options.length;i=i+1)                          
    {                                                            
        combo1.options[i].selected=false;
    }
}

function obtieneSeleccion()                               
{                                                                  
    var cadena = "";               
    var frm=document.forms[0];  
    for (i=0;i<frm.lscModuloAsig.options.length;i=i+1)                          
    {                                                            
        cadena = cadena + "|" + frm.lscModuloAsig.options[i].value;
    }
    return cadena;
}    


function mover(combo1,combo2)
{
  move(combo1,combo2);
  for (i=0;i<combo1.options.length;i=i+1)                          
  {                                                            
     combo1.options[i].selected=false;                             
  }

}


function validaForm()
{    
    var frm = document.forms[0];  
    if (!valida('lscRol','s'))
        return false; 

    return true; 
} 

function loadRol()                                                
{         
    var frm=document.forms[0];
    if (frm.lscRol.value!="-1")
    {
        frm.target="_self";
        frm.action="MantenimientoModuloRol.jsp";
        frm.submit();
    }
}     

function Grabar()                                                
{ 
    if(validaForm()==true)
    {
        var cadena =  obtieneSeleccion();
      
        frmMantModuloRol.action="../servlet/ProcesoMant?proceso=3&sModulos=" + cadena;
        frmMantModuloRol.submit();
    }    
}     

</script>
</head>
<BODY leftMargin="0" onload="javascript:LoadBody();" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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

<div style="margin-left: 10px;margin-right: 10px; margin-top:10px">
<TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
<TR>
<TD VALIGN="top"  width="100%">
<form name="frmMantModuloRol" method="post">
    <table cellSpacing="0" class="2 form-table-controls" bordercolor="#53709c" border=0 width="100%" align="left" id=TABLE1>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" class="2" border=0 bgcolor=#ffffff width="100%" align="center">
                    <tr>
                        <td colspan=6 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt">M&oacute;dulos&nbsp;Por&nbsp;Rol - Mantenimiento</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <fieldset class="row5 content_resumen">
                <legend class="titulo_campos_bold">MODULOS - ROL</legend>
                <table width="100%"  class="2" cellspacing="0" bgcolor=#ffffff cellpadding="0" border=0>
                    <tr>
                        <td colspan=3 class="row5" align="left">
                            <a href="javascript:Grabar()" class="lq-btn lp-glyphicon lp-glyphicon-save-blanco" style="margin-top:10px">&nbsp;Grabar</a>                           
                        </td>
                    </tr>
                    <tr>
                        <td class="row1" width="15%" align="right">
                            <font color=#FF0000>* </font>Rol&nbsp;:&nbsp;
                        </td>
                        <td class="row1" width="35%" align="left">
                            <select class="TxtCombo lp-select" style="width:180px" name="lscRol" onchange="javascript:loadRol();">
                                <option value="-1">--Seleccione--</option>
                                <%=Tool.listaCombo(lstRoles,"NIDROL","SNOMBRE")%>
                            </select>
                        </td>
                        <td class="row1" width="50%" align="right">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan=3 align="left">            
                            <table class=2 cellSpacing=0 cellPadding=0 width="100%">
                                <tr>
                                     <td class=row1 align=right height="18" width="15%">&nbsp;</TD>
                                     <td class=row1 align=left width="35%"><font color=#FF0000>* </font>M&oacute;dulos Asignados&nbsp;:&nbsp;</TD>
                                     <td class=row1 align=left width="10%">&nbsp;</TD>
                                     <td class=row1 align=left width="40%">M&oacute;dulos Disponibles &nbsp;:&nbsp;</TD>
                                </tr>
                                <tr>								 
                                    <td class=row1 align=right>&nbsp;
                                  
                                    </TD>
                                    <TD class=row1 align=left>
                                    
                                        <select multiple size="6" name="lscModuloAsig" class="TxtCombo lp-select-multiple" style="width:240px">
                                        <%if (intRol!=0){
                                            BeanList lstModuloAsig = gestorRol.getLstRolModulo(2,intRol);
                                          %>
                                            <%=Tool.listaCombo(lstModuloAsig,"NIDMODULO","SNOMBRE")%>
                                          <%}%>
                                        </select>                              
                                    </TD>
                                    <td class=row1 align=left>                                    
                                        <input class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-left-color"  style="HEIGHT: 30px;" type="button" onClick="javascript:selModulo(document.forms[0].lscModuloDisp,document.forms[0].lscModuloAsig);"    value="" id=button1 name=button1>
                                        <br/>
                                        <br/>
                                        <input class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-right-color" style="HEIGHT: 30px;" type="button" onClick="javascript:selModuloAux(document.forms[0].lscModuloAsig,document.forms[0].lscModuloDisp);" value="" id=button2 name=button2>                                    
                                    </TD>								 
                                    <TD class=row1 align=left>
                                        <select multiple size="6" name="lscModuloDisp" class="TxtCombo lp-select-multiple" style="width:240px">
                                         <%if (intRol!=0){
                                            BeanList lstModuloAsig = gestorRol.getLstRolModulo(1,intRol);
                                          %>
                                            <%=Tool.listaCombo(lstModuloAsig,"NIDMODULO","SNOMBRE")%>
                                          <%}%>
                                        </select>              							 
                                    </TD>
                                </TR>
                                
                            </table>            
                        </td>
                    </tr>            
                </table>
                </fieldset>
            </td>
        </tr>
        <tr>
            <td class="row4">&nbsp;</td>
        </tr>           
        <tr>
            <td class="row4">&nbsp;</td>
        </tr>           
    </table>
    </FORM>
</TD>
</TR>
</TABLE>
</div>
</BODY>
</html>
