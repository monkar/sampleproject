<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%  
    /*Instanciando la clase Atencion,para acceder a los Datos  yahirRivas 29FEB2012 11:34am*/    
    Atencion atencion = new Atencion();
   
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:36pm
    GestorClinica gestorClinica = new GestorClinica();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");      
    }
    int intIdUsuario = usuario.getIntIdUsuario();
    
    String ff=Tool.getDate("dd/MM/yyyy");
    String fi=Tool.addDate(-180,"dd/MM/yyyy");    
    String strCodTipoSolictud=request.getParameter("CodTipoSolictud");        
    String strFechaInicio=(request.getParameter("sFechai")==null?fi:request.getParameter("sFechai"));
    String strFechaFin=(request.getParameter("sFechaf")==null?ff:request.getParameter("sFechaf"));
    String strNombrePaciente=request.getParameter("psnombre");    
    String strCodProveedor=request.getParameter("CodProveedor");    
    String strDesProveedor=request.getParameter("DesProveedor");    
    String strCodDiagnostico=request.getParameter("CodDiagnostico");
    String strDesDiagnostico=request.getParameter("DesDiagnostico");
    String strFlagPrimeraVez=request.getParameter("FlagPrimero");  
    
    if (strCodTipoSolictud ==null){
        strCodTipoSolictud="1";
    }    
    if (strDesDiagnostico ==null){
        strDesDiagnostico="";
    }
    if (strDesProveedor ==null){
        strDesProveedor="";
    }    
    if (strFlagPrimeraVez ==null){
        strFlagPrimeraVez="";
    }  
%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  <title>CONSULTA HIST&Oacute;RICA DEL PACIENTE :<%=strNombrePaciente%> – WEB CL&Iacute;NICAS</title>
    <jsp:include page="../general/scripts.jsp" />  
</head>

<script type="text/javascript">
	function onClickCargarPagina(){ 
     var frmVar = document.forms[0];       
     ActiveProceso(true);
     frmVar.action = "HistoricoPaciente.jsp?psnombre=" + frmVar.hcnNombrePaciente.value + "&CodTipoSolictud=" + frmVar.lscTipoSol.value  + "&CodProveedor=" + frmVar.lscClinica.value  + "&DesProveedor=" + frmVar.tctDesProveedor.value + "&CodDiagnostico=" + frmVar.lscDiagnsoticos.value + "&DesDiagnostico=" + frmVar.tctDesDiagnostico.value + "&sFechai=" + frmVar.tctFechaInicio.value + "&sFechaf=" + frmVar.tctFechaFin.value;
     frmVar.target = "_self";
	   frmVar.submit();                
	}
  function buscar(){  
     var frm = document.forms[0];        
     ActiveProceso(true);
     frm.target="frLstHistoricoPaciente";
     frm.action="../consulta/ListaHistoricoPaciente.jsp?psbuscar=1";
     frm.submit(); 
  }  
  function ActiveProceso(val){
    if (val == true){
      trDetalle.style.display='none';
      dtProceso.style.display = '';
    }else{
      trDetalle.style.display='';
      dtProceso.style.display = 'none';
    }    
  }
  
</script>

<body leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
  <form name="frmHistoricoPaciente" method="post">  
   <input type="hidden" name="hcnNombrePaciente" value="<%=strNombrePaciente%>"/>
    <table class="2" BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >    
       <tr>      
           <td>
              <table class="2" BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
                 <tr>      
                     <td class="header texto_general_black" width="90%">Consulta hist&oacute;rica del paciente : <%=strNombrePaciente%> – Web Cl&iacute;nicas</td>              
                     <td width="10%"><a class="link_acciones" href="javascript:window.close();">Cerrar [X] </a></td>          
                 </tr>
              </table>     
           </td>
       </tr>
       <tr>
           <td>           
              <fieldset class="row5 content_resumen">
              <legend></legend>          
              <table BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" CLASS="form-table-controls">
                 <tr> 
                       <td align=right class="row1" >Tipo Solicitud :</td>
                       <td align=left class="row1">
                            <select class="TxtCombo lp-select" style="width:180px" name="lscTipoSol">
                                <option value=0 selected >(Todos)</option>
                                  <%
                                    BeanList objLista = new BeanList();
                                    objLista = Tool.obtieneLista("SELECT NIDTIPOSOLICITUD,SNOMBRE FROM PTBLTIPO_SOLICITUD WHERE NFLGACTIVO=1 AND NFLGBANDEJA=1","");
                                    //Req 2011-0975
                                    out.println( Tool.listaComboSeleccionado(objLista,"NIDTIPOSOLICITUD","SNOMBRE",""));
                                    //DESCOMENTAR - out.println( Tool.listaComboSeleccionado(objLista,"NIDTIPOSOLICITUD","SNOMBRE",strCodTipoSolictud));
                                    //Fin Req 2011-0975
                                  %>
                            </select>
                       </td>
                       <td align=right class="row1" >Fecha Inicio :&nbsp;</td>
                       <td align=left class="row1"><input class="row5 input_text_sed" maxlength="10" name = "tctFechaInicio" type="text" value="<%=strFechaInicio%>" onblur="validaFecha(this.name);" onKeyPress="javascript:onKeyPressFecha(this);">
                                                   <img  ALT="Calendario" SRC="../images/Iconos/14x14-color/Iconos-14x14-color-99.png"  BORDER="0"  onClick="OpenCalendar('tctFechaInicio','../')" style="cursor:hand;"></td>         
                       <td align=right class="row1" >Fecha Fin :&nbsp;</td>
                       <td align=left class="row1"><input class="row5 input_text_sed" maxlength="10" name = "tctFechaFin" type="text" value="<%=strFechaFin%>" onblur="validaFecha(this.name);" onKeyPress="javascript:onKeyPressFecha(this);">
                                                   <img  ALT="Calendario" SRC="../images/Iconos/14x14-color/Iconos-14x14-color-99.png"  BORDER="0"  onClick="OpenCalendar('tctFechaFin','../')" style="cursor:hand;"></td>                                             
                       <td  align=right class="row1"><input type="button" class="TxtCombob lq-btn lp-glyphicon lp-glyphicon-search-blanco" value="Buscar" onclick="javascript:buscar();"/>&nbsp;&nbsp;&nbsp;&nbsp;</td>                                   
                 </tr>
                 <tr> 
                       <td align=right class="row1" >Proveedor :&nbsp;</td>
                       <td align=left colspan=2 class="row1"><input class="row5 input_text_sed" maxlength="50" name = "tctDesProveedor" type="text" value="<%=strDesProveedor%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" >
                                                   <input type="button" class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-search-color" value="Buscar Proveedor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" onclick="javascript:onClickCargarPagina();"/></td>         
                       <td colspan=4 align=left class="row1" >                                
                                <select name="lscClinica" class="TxtCombo lp-select" style="width:600px">
                                    <option value="">(Todos)</option>
                                    <%
                                      if ((strDesProveedor.length()==0)|| (strFlagPrimeraVez.length() >0)){
                                          strDesProveedor = "*:::*";
                                      }else{
                                          strDesProveedor = "*" + strDesProveedor + "*";
                                      } 
                                      BeanList lstClinica = gestorClinica.lstClinicaWeb(1,1,"S","1",strDesProveedor);
                                      
                                      
                                            for (int i= 0; i < lstClinica.size(); i++ ){%>                                      
                                                 <% if(strCodProveedor.equals(lstClinica.getBean(i).getString("1"))){ %>
                                                    <option value='<%=lstClinica.getBean(i).getString("1")%>' selected ><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3") + " (" + lstClinica.getBean(i).getString("6") + ")"%></option>
                                                 <%}   
                                                 else{
                                                 %>
                                                    <option value='<%=lstClinica.getBean(i).getString("1")%>'><%=lstClinica.getBean(i).getString("1") + " - " + lstClinica.getBean(i).getString("3") + " (" + lstClinica.getBean(i).getString("6") + ")"%></option>
                                                 <%}%>
                                            <%}                                      
                                      
                                          out.print("<SCRIPT LANGUAGE=\"JavaScript\"> ActiveProceso(false); </script>");                                      
                                      %>
                                    %>                                      
                                </select>                                  
                       </td>
                 </tr>                 
                 <tr>
                       <td align=right class="row1" >Diagnostico :&nbsp;</td>
                       <td align=left colspan=2 class="row1"><input class="row5 input_text_sed" maxlength="50" name = "tctDesDiagnostico" type="text" value="<%=strDesDiagnostico%>" onkeypress="javascript:onKeyPressMayuscula.call(this, event);" >
                       <input type="button" class="TxtCombob btn_secundario lp-glyphicon lp-glyphicon-search-color" value="Buscar Diagnósticos" onclick="javascript:onClickCargarPagina();"/></td>         
                       <td colspan=4 align=left class="row1" >
                                <select name="lscDiagnsoticos" class="TxtCombo lp-select" style="width:600px">
                                      <option value="">(Todos)</option>
                                    <%
                                      if ((strDesDiagnostico.length()==0)|| (strFlagPrimeraVez.length() >0)){
                                          strDesDiagnostico = "*:::*";
                                      }else{
                                          strDesDiagnostico = "*" + strDesDiagnostico + "*";
                                      }                                       
                                      BeanList lstDiagnosticos = atencion.lstMaestroDiagnosticos(1,1,null,strDesDiagnostico,"1");
                                      
                                            for (int i= 0; i < lstDiagnosticos.size(); i++ ){%>                                      
                                                 <% if(strCodDiagnostico.equals(lstDiagnosticos.getBean(i).getString("1"))){ %>
                                                    <option value='<%=lstDiagnosticos.getBean(i).getString("1")%>' selected ><%=lstDiagnosticos.getBean(i).getString("1") + " - " + lstDiagnosticos.getBean(i).getString("2")%></option>
                                                 <%}   
                                                 else{
                                                 %>
                                                    <option value='<%=lstDiagnosticos.getBean(i).getString("1")%>'><%=lstDiagnosticos.getBean(i).getString("1") + " - " + lstDiagnosticos.getBean(i).getString("2")%></option>
                                                 <%}%>
                                            <%}                                                                            
                                      
                                          out.print("<SCRIPT LANGUAGE=\"JavaScript\"> ActiveProceso(false); </script>");                                      
                                      %>
                                    %>                                      
                                </select>
                       </td>
                 </tr>                 
              </table>   
              
              </fieldset>
           </td>           
       </tr>
    </table>    
    <table WIDTH="100%" border="0" cellpadding="0" cellspacing="0" class="row5 form-table-controls">
        <tr id="trDetalle" style="display:none">
         <td valign="top">               
             <fieldset class="row5 content_resumen">
             <legend></legend>  
                  <iframe name="frLstHistoricoPaciente" align=left width="100%" height="500" frameborder="0"  src="../consulta/ListaHistoricoPaciente.jsp"></iframe>                                  
             </fieldset>
         </td>     
        </tr>
        <tr>
          <td>
            <table width="100%" cellspacing="0" cellpadding="0" align="center">
              <tr id="dtProceso" style="display:none">
                <td  class="row5" colspan=3 align="center"><br>
                  <img  name="btnProceso" ALT="Procesando" SRC="../images/loading_turquesa1.gif"  BORDER="0">
                </td>
              </tr>                        
            </table>            
          </td>
        </tr>                
    </table>
  </form>  
</body>
</html>