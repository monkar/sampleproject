<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<%
      
      /*Se instancio la clase GestorRol YahirRivas 29FEB2012 10:58am */
      GestorRol gestorRol = new GestorRol();
      
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:01pm
      GestorUsuario gestorUsuario = new GestorUsuario();
          
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:34pm
      GestorClinica gestorClinica = new GestorClinica();
          
      Usuario usuario = null;
      synchronized(session)
      {
        usuario = (Usuario)session.getAttribute("USUARIO");     
      }  
      int intIdUsuario = usuario.getIntIdUsuario();
      BeanList lstRoles = gestorRol.getLstRol(); 
      BeanList lstOficina = gestorUsuario.getlstOficina();
      BeanList lstClinica = gestorClinica.lstClinica(intIdUsuario);
%>
<jsp:include page="../menu/Menu.jsp" />
<html>
    <head>
    <title>MANTENIMIENTO DE USUARIO</title>
    <jsp:include page="../general/scripts.jsp" />  
    <script type="text/javascript">
        
        function Editar(codigo)
        {
           var frm = document.forms[0]; 
           frm.target = "_self";
           frm.action = "MantenimientoUsuario_Editar.jsp?sAccion=editar&nIdUsuario=" + codigo;
           frm.submit(); 
        }
        
        function Borrar()
        {
                                                        
        }
        
        function Buscar()
        {
            var frm = document.forms[0];
            trBusqueda.style.display = '';
            frm.target="frLstUsuario";
            var flgExportar = 0;
            if(frm.chcExportar.checked==true)
                flgExportar=1;
            frm.action="../mantenimiento/ListaUsuario.jsp?flgBuscar=1&flgExportar=" + flgExportar;        
            frm.submit(); 
                                                       
        }
        
        function Agregar()
        {
           var frm = document.forms[0];        
           frm.action = "MantenimientoUsuario_Editar.jsp?sAccion=crear";
           frm.target = "_self";
           frm.submit();                                                
        }
        
        function Exportar()
        { 
           var url="../mantenimiento/ToExcelUsuario.jsp";
           x=window.open(url);
           x.moveTo(0,0);
           x.resizeTo(window.screen.availWidth,window.screen.availHeight);
           x.focus();
        }
        
        
    </script>
    </head>
    <body leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0"> 
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
    <form name="frmMantUsuario" method="post">                      
        <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <div style="margin-left: 10px;margin-right: 10px;margin-top: 10px;">
                    <fieldset class="row5 content_resumen">
                        <legend></legend>  
                        <table cellSpacing="1" border=0 width="100%">
                            <tr>
                                <td colspan="4" class="row5" style="FONT-SIZE: 10pt" align="left">
                                   <label class="titulo_campos_bold">Usuario - Listado</label>
                                </td>
                            </tr>
                            <tr>
                                <td  width="6%" class="row5" align="left">
                                    Cl&iacute;nica:&nbsp;
                                </td>
                                <td  width="25%" class="row5" align="left" >
                                    <select name="lscClinica" class="TxtCombo lp-select" style="width:90%">
                                        <option value="">(Todos)</option>
                                        <%for (int i= 0; i < lstClinica.size(); i++ ){%>
                                            <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3")%></option>
                                        <%}%>
                                    </select>   
                                </td>
                                <td  width="6%" class="row5" align="left">
                                    Rol:&nbsp;
                                </td>
                                <td  width="25%" class="row5" align="left">
                                    <select name="lscRol" align="left" class="TxtCombo lp-select" style="width:60%">
                                        <option value=0>(Todos)</option>
                                        <%=Tool.listaCombo(lstRoles,"NIDROL","SNOMBRE")%>
                                    </select>
                                </td>
                                <td  width="25%" class="row5" align="left">
                                    <A href="javascript:Buscar()" class="lq-btn lp-glyphicon lp-glyphicon-search-blanco">Buscar</A>                                    
                                </td>
                            </tr>
                            <tr>
                                <td  width="6%" class="row5" align="left">
                                    Oficina:&nbsp;
                                </td>
                                <td  width="25%" class="row5" align="left" >                                   
                                    <select class="TxtCombo lp-select" style="width:60%" name="lscOficina">
                                        <option value=0>(Todos)</option>
                                        <%=Tool.listaCombo(lstOficina,"CODOFICINA","DESCRIPCION")%>
                                    </select>
                                </td>
                                <td  width="6%" class="row5" align="left">
                                    Usuario:&nbsp;
                                </td>
                                <td width="25%" class="row5"  align="left" colspan="2">
                                    <input type="text" class="row5 input_text_sed" size=20 name="tctLogin">
                                </td>
                            </tr>
                            <tr>
                                <td class="row5" width="8%" align="right" colspan="5">
                                    <INPUT type="checkbox" class="TxtCombo" name="chcExportar">Exportar consulta&nbsp;
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    </div>
                </td>               
            </tr>
            <tr>
                <td>
                    <div style="margin-left: 10px;margin-right: 10px;">
                    <fieldset class="row5 content_resumen">
                         <table cellSpacing="1"  border=0 width="100%">
                            <tr>
                                <td class="row5" width="8%" align="left">
                                    <A href="javascript:Agregar()" class="btn_secundario lp-glyphicon lp-glyphicon-add-color">Agregar</A>                                    
                                </td>
                                <td class="row5" width="70%" align="left" colspan="3">
                                    &nbsp;
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
                        <iframe name="frLstUsuario" align=left width="100%" height="700" frameborder="0" scrolling="auto" src="ListaUsuario.jsp"></iframe>
                    </fieldset>
                    </div>
                </td>
            </tr>
            <tr id="trExcel" style="display:none">
                <td>
                    <div style="margin-left: 10px;margin-right: 10px;">
                    <fieldset class="row5 content_resumen">
                    <legend></legend>  
                        <iframe name="frmLstUsuario" align=left width="100%" height="600" frameborder="0" scrolling="auto" src="ListaUsuario.jsp"></iframe>
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
