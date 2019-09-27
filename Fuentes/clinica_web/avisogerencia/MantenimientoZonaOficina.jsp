<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<% 
    GestorUsuario gestorUsuario = new GestorUsuario();
    BeanList lstOficina = gestorUsuario.getlstOficinaCore(); 
    BeanList lstZona = gestorUsuario.getlstZona(); 
    
%>
<jsp:include page="../menu/Menu.jsp" />
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <title>MANTENIMIENTO DE ZONA POR OFICINA</title>
    <jsp:include page="../general/scripts.jsp" />  
    <script type="text/javascript">
    
        function LoadBody()
        { 
           var frm = document.forms[0]; 
           if(frm.lscZona.value!='')
              Buscar();
        }
        
        function Buscar(pagina)
        {
            var frm = document.forms[0];
            trBusqueda.style.display = '';
            frm.target="frLstZonaOficina";
            accion = "ListaZonaOficina.jsp?flgBuscar=1";
            if (pagina != undefined)
                accion = accion + "&tcnpagina=" + pagina;        
            frm.action= accion;
            frm.submit();                                      
        }
        
        function Nuevo()
        { 
           var frm = document.forms[0]; 
           frm.target = "_self";
           frm.action = "MantenimientoZonaOficina_Editar.jsp";
           frm.submit(); 
        }
        
        function Editar(idzona, idoficina, idactivo)
        { 
           var frm = document.forms[0]; 
           frm.target = "_self";
           frm.action = "MantenimientoZonaOficina_Editar.jsp?nZona=" + idzona + "&nOficina=" + idoficina + "&nEstado=" + idactivo;
           frm.submit(); 
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
    <div style="margin-left: 10px;margin-right: 10px; margin-top:10px;">
    <TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
      <TR>
      <TD VALIGN="top"  align="left" width="100%" >
        <form name="frmMantZonaOficina" method="post">                      
            <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
                <tr >
                    <td>
                        <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                            <legend></legend>  
                            <table cellSpacing="1" border=0 width="100%">
                                <tr>
                                    <td class="row5" style="FONT-SIZE: 10pt" align="left" colspan="4" >
                                        <label class="titulo_campos_bold">Configuraci&oacute;n de Zona - Oficina</label> 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="row5" width="8%" align="right" colspan="4">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td  width="6%" class="row5" align="left">
                                        Zona:&nbsp;
                                    </td>
                                    <td width="25%" class="row5"  align="left" colspan="2">
                                        <select class="TxtCombo lp-select" style="width:60%" name="lscZona">
                                            <option value=0>(Todos)</option>
                                            <%=Tool.listaCombo(lstZona,"NIDZONA","SNOMBRE")%>
                                        </select>
                                    </td>
                                    <td  width="6%" class="row5" align="left">
                                        Oficina:&nbsp;
                                    </td>
                                    <td  width="25%" class="row5" align="left" >  
                                        <select class="TxtCombo lp-select" style="width:60%" name="lscOficina">
                                            <option value=0>(Todos)</option>
                                            <%=Tool.listaCombo(lstOficina,"1","2")%>
                                        </select>
                                    </td>
                                    <td  width="25%" class="row5" align="left" colspan="2">
                                        <A href="javascript:Buscar()" class="lq-btn lp-glyphicon lp-glyphicon-search-blanco">Buscar</A>                                      
                                    </td>
                                </tr>
                                <tr>
                                    <td class="row5" width="8%" align="right" colspan="5">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td  width="25%" class="row5" align="left" colspan="5">
                                        <A href="javascript:Nuevo()" class="btn_secundario lp-glyphicon lp-glyphicon-add-color">Agregar</A>                                       
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>               
                </tr>
                <tr id="trBusqueda" style="display:none">
                    <td>
                        <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                        <legend></legend>  
                            <iframe name="frLstZonaOficina" align=left width="100%" height="700" frameborder="0" scrolling="auto" src="ListaZonaOficina.jsp"></iframe>
                        </fieldset>
                    </td>
                </tr>
            </table>      
        </form>
    </TD>
    </TR>
  </TABLE>
  </div>
  </body>
</html>
