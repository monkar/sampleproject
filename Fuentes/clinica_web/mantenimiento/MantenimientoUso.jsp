<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<% 
  String strPoliza = (request.getParameter("npoliza")!=null?request.getParameter("npoliza"):"");
%>
<jsp:include page="../menu/Menu.jsp" />
<html>
    <head>
    <title>MANTENIMIENTO DE USO DE COBERTURAS</title>
    <jsp:include page="../general/scripts.jsp" />  
    <script type="text/javascript">
        function Buscar(pagina)
        {        
            var frm = document.forms[0];
            var poliza = frm.tctPoliza.value;
            if (poliza=='')
                poliza = -1;
            trBusqueda.style.display = '';
            frm.target="frmLstConfUso";
            accion = "ListaConfUso.jsp?flgBuscar=1&tcnpoliza=" + poliza;        
            if (pagina != undefined)
                accion = accion + "&tcnpagina=" + pagina;        
            frm.action= accion; 
           
            frm.submit(); 
        } 
        
        function Editar(policy , cover, covergen, payconcep)
        { 
           var frm = document.forms[0]; 
           frm.target = "_self";
           frm.action = "MantenimientoUso_Editar.jsp?ncover=" + cover + "&npolicy=" + policy + "&ncovergen=" + covergen
                        + "&npayconcep=" + payconcep;
           
           frm.submit(); 
        }
        
        function Nuevo()
        { 
           var frm = document.forms[0]; 
           frm.target = "_self";
           frm.action = "MantenimientoUso_Editar.jsp";
           frm.submit(); 
        }
        
        function LoadBody()
        { 
           var frm = document.forms[0]; 
           if(frm.tctPoliza.value!='')
              Buscar();
        }
        
    </script>
    </head>
    <body leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" onload="LoadBody()"> 
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
    <form name="frmMantUso" method="post">                      
        <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
            <tr >
                <td>
                    <div style="margin-left: 10px;margin-right: 10px;margin-top: 5px;">
                    <fieldset class="row5 content_resumen">
                        <legend></legend>  
                        <table cellSpacing="1" border=0 width="100%">
                            <tr>
                                <td class="row5" style="FONT-SIZE: 10pt" align="left" colspan="4" >
                                    <label class="titulo_campos_bold">Configuraciones de Uso por Cobertura  - Listado</label> 
                                </td>
                            </tr>
                            
                            <tr>
                                <td  width="2%" class="row5" align="left">
                                    Contrato:&nbsp;
                                </td>
                                <td  width="4%" class="row5" align="left" >
                                    <input class="row5 input_text_sed" name = "tctPoliza" type="text" maxlength="8" style="width:100%" value="<%=strPoliza%>" onKeyPress="javascript:onKeyPressNumero('this');">
                                </td>
                                <td  width="25%" class="row5" align="left" colspan="2">
                                    <A href="javascript:Buscar()" class="lq-btn lp-glyphicon lp-glyphicon-search-blanco">Buscar</A>                                   
                                </td>
                            </tr>
                            
                            <tr>
                                <td  width="25%" class="row5" align="left" colspan="5">
                                    <A href="javascript:Nuevo()" class="btn_secundario lp-glyphicon lp-glyphicon-add-color">Agregar</A>                                 
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
                        <iframe name="frmLstConfUso" align=left width="100%" height="700" frameborder="0" scrolling="auto" src="ListaConfUso.jsp"></iframe>
                    </fieldset>
                    </div>
                </td>
            </tr>
        </table>      
    </form>
</TD>
</TR>
</TABLE>
</body>
</html>

