<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<%  
      
      /*Se instancio la clase GestorRol yahirRivas 29FEB2012 11:02am*/
      GestorRol gestorRol = new GestorRol();
      
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:00pm
      GestorUsuario gestorUsuario = new GestorUsuario();

      String strAccion=request.getParameter("sAccion");
      int intIdUsuario = (request.getParameter("nIdUsuario")!=null?Tool.parseInt(request.getParameter("nIdUsuario")):0);
      Usuario objUsuario = null;
   
      int intFlgFirma=0;
      String strFirmaReg="|";
      if(intIdUsuario>0)
      {
          objUsuario =  gestorUsuario.getUsuario(intIdUsuario);  
          intFlgFirma = objUsuario.getLstFirmas().size();
      }
      
      BeanList lstRoles = gestorRol.getLstRol(); 
      BeanList lstOficina = gestorUsuario.getlstOficina();
     
      String strTitulo = "";
      String strSubTitulo = "";
      if(strAccion.equals("crear")==true)
      {
          strTitulo = "REGISTRO DE USUARIO";
          strSubTitulo = "NUEVO";
      }
      else
      {
          strTitulo = "EDICION DE USUARIO";
          strSubTitulo = "EDITAR";
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
        <%if(objUsuario!=null)
        {
        %>
            frm.lscRol.value=<%=objUsuario.getIntIdRol()%>;
            frm.lscOficina.value=<%=objUsuario.getIntCodOficina()%>;
            
            var rol = <%=objUsuario.getIntIdRol()%>;
            if(rol==<%=Constante.NROLOPE%> || rol==<%=Constante.NROLENF%>)
                dtClinica.style.display="";
            else
                dtClinica.style.display="none";
            
            if(rol==<%=Constante.NROLBRK%>)
                dtBroker.style.display="";
        <%}%>
        
        frm.tctIdUsuario.disabled=true;
        frm.tctCodClinica.disabled=true;
        
        
    }
    
    function Regresar()
    {
        window.location.href = "../mantenimiento/MantenimientoUsuario.jsp?"; 
    }
    
    function BuscarUsuario()
    {
        if (document.forms[0].tctUsuario.value=="")
        {
            alert("Ingrese el login a buscar");
            document.forms[0].tctUsuario.focus();
            return;
        }else
        {
           
            dtUsuario.style.display="";
            frmUsuario.document.forms[0].action="../general/Lista.jsp?nameframe=frmUsuario&pstipo=usuario&sLogin=" + document.forms[0].tctUsuario.value;
            frmUsuario.document.forms[0].submit();
        }
    }
    
    function buscaClinica()
    {
        if(event.keyCode==13)
        {
            if (document.forms[0].tctDescClinica.value=="")
            {
                alert("Ingrese el nombre de la clínica a buscar");
                document.forms[0].tctDescClinica.focus();
                return;
            }else
            {
                dtBuscaClinica.style.display="";
                frmClinica.document.forms[0].action="../general/Lista.jsp?nameframe=frmClinica&pstipo=clinica&psdesc=" + document.forms[0].tctDescClinica.value;
                frmClinica.document.forms[0].submit();
            }
        }
    }
    
    function aviso()
    { 
      alert("No se encontro un usuario con el login ingresado");
    }
    
    function selObj(obj)
    {
        var frm = document.forms[0];
        dtBuscaClinica.style.display="none";
        i=obj.selectedIndex;
        frm.tctCodClinica.disabled=false;
        frm.tctCodClinica.value=obj.options[i].value;
        frm.tctDescClinica.value=obj.options[i].text;  
        frm.tctCodClinica.disabled=true;
        frm.tctDescClinica.focus();
    }
    
    function muestraFirma()
    {
        var frm = document.forms[0];
        
        if (frm.chcFirma.checked == true)
        {
            tdFirma.style.display = 'block';
            frm.action="ListaFirma.jsp?codUser=<%=(objUsuario!=null?Integer.toString(objUsuario.getIntIdUsuario()):"-1")%>";        
            frm.target="firma";
            frm.submit();
            
            frm.action="upload.jsp";        
            frm.target="upload";
            frm.submit();
        }    
        else
        {
            tdFirma.style.display = 'none'; 
        }
    }
    
    function verAlerta(error)
    {
        var frm = document.forms[0];
        if(frm.hndAccion.value=='crear')
        {
             var mensaje = "Error en el registro de usuario.";
             if(error = -2)
                mensaje = mensaje + " El código de broker ya se encuentra registrado";
             alert(mensaje);
        }
        else
             alert("Error en la modificación de usuario");
    }
    
    function Grabar()
    {
        var frm = document.forms[0];

        if (validaForm()==false)
            return;

        frm.tctCodClinica.disabled=false;
        frm.tctDescClinica.disabled=false; 

        var usuario = frm.tctIdUsuario.value;
        frm.tctCodClinica.disabled=false;
        var clinica = frm.tctCodClinica.value;
        var rol = frm.lscRol.options[frm.lscRol.selectedIndex].value;
        var oficina = frm.lscOficina.options[frm.lscOficina.selectedIndex].value;
        var accion = frm.hndAccion.value;
        var email =  frm.tctEmail.value;
        var codBroker = frm.tctCodBroker.value;
        var login = frm.tctUsuario.value;
        
        
        
        var flgFirma = 0;
        var cadena = "";
        var cadena1 = "";
        
        if (frm.chcFirma.checked == true)
        {
            flgFirma = 1;
            cadena =  firma.obtieneDatos();
           
            cadena1 =  firma.obtieneDatosDel();
        }
        
        var activo = -1;
        <%if(strAccion.equals("editar")==true){%>
            if (frm.chcActivo.checked == true)
                activo=1;
            else
                activo=0;
        <%}%>
        
        //Inicio - Req. 2014-000561 GJB Paradigmasoft 
        var ndeshabilitado = -1;
        if(frm.chcDeshabilitado.checked == true){
            ndeshabilitado = 1;            
        }
        else{
            ndeshabilitado = 0;
        }
        //Fin - Req. 2014-000561 GJB Paradigmasoft 
        
        upload.frmUpload.action="../servlet/ProcesoMant?proceso=2&IdUsuario=" + usuario + "&CodClinica=" + clinica + "&Rol=" + rol 
                                + "&Oficina=" + oficina + "&accion=" + accion + "&ConfFirma=" + cadena + "&flgActivo=" 
                                + activo + "&ConfFirmaDel=" + cadena1 + "&flgFirma=" + flgFirma + "&Email=" + email
                                + "&CodBroker=" + codBroker + "&login=" + login + "&flgDeshabilitado=" + ndeshabilitado;        
        upload.frmUpload.submit();
    }

    function validaForm()
    {    
        
        var frm = document.forms[0];
        
        if (!valida('tctUsuario','t'))
            return false;
        
        if (!valida('lscRol','s'))
            return false; 
        
        if (!valida('lscOficina','s'))
            return false;     
       
        var rol = frm.lscRol.options[frm.lscRol.selectedIndex].value;
       
        if(rol==<%=Constante.NROLOPE%> || rol==<%=Constante.NROLENF%>)
        {
          
            frm.tctCodClinica.disabled=false;
            if (frm.tctCodClinica.value=="")
            {
                
                alert("Debe seleccionar una clínica");
                frm.tctDescClinica.focus();
                frm.tctCodClinica.disabled=true;
                return false;
            }
            frm.tctCodClinica.disabled=true;
        }
        
        if (frm.chcFirma.checked == true)
        {
            var numFirma = 0;
            <%if(strAccion.equals("crear")==true){%>
                if (upload.valida()==false)
                {
                    alert("Debe seleccionar el archivo de firma");
                    return false;
                }
                numFirma = firma.getCantFirma(1) * 1;
            <%}else if(strAccion.equals("editar")==true){%>
                numFirma = firma.getCantFirma(2) * 1;
            <%}%>
            if (numFirma==0)
            {
                alert("Debe ingresar la configuración de firmas");
                return false;
            }
        }
        
        
        if(rol==<%=Constante.NROLBRK%> && frm.tctIdUsuario.value!="")
        {
            if (frm.tctCodBroker.value=="")
            {
                alert("Ingrese el código de broker");
                return false;
            }    
        }
        
        return true; 
    } 
    
    function seleccionaRol() 
    { 
    
        var frm = document.forms[0];   
        var rol = frm.lscRol.options[frm.lscRol.selectedIndex].value;
        
        //Si el rol no es operador o enfermera
        if(rol!=<%=Constante.NROLOPE%> && rol!=<%=Constante.NROLENF%>)
        {
          frm.tctCodClinica.disabled=false;
          frm.tctCodClinica.value="";
          frm.tctDescClinica.value="";  
          frm.tctCodClinica.disabled=true;
          frm.tctDescClinica.disabled=true;
          dtClinica.style.display="none";
        }
        else
        {
           frm.tctCodClinica.disabled=false;
           frm.tctDescClinica.disabled=false;
           frm.tctCodClinica.value="";
           frm.tctDescClinica.value="";  
           frm.tctCodClinica.disabled=true;
           dtClinica.style.display="";
        }
        
        if(rol==<%=Constante.NROLBRK%>)
            dtBroker.style.display="";
        else
            dtBroker.style.display="none";
    }
    
    function verFirma()
    {
      var frm = document.forms[0];
      var idusuario =frm.hndIdUsuario.value;    
      x=window.open("../servlet/ProcesoMant?proceso=4&idusuario=" + idusuario,"image");
      x.focus();
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
<TABLE  BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
<TR>
<TD VALIGN="top"  align="left" width="100%" >
<form name="frmMantUsuario" method="post"> 
<input name="hndCantFirma" type="hidden">
<input name="hndIdUsuario" type="hidden" value="<%=(objUsuario!=null?Integer.toString(objUsuario.getIntIdUsuario()):"")%>">
<input name="hndAccion" type="hidden" value="<%=strAccion%>">
<input name="sFirmaReg" type="hidden" value="<%=strFirmaReg%>">

    <table width="100%" class="2" cellspacing="0" cellpadding="0">
        <tr>
            <td>
            <div  style = "margin-left : 10px; margin-right:10px ; margin-top: 10px " >
                <fieldset class="row5 content_resumen" >
                <legend></legend>  
                <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                    <tr>
                        <td colspan=4 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt" align="left">Usuario - <%=strSubTitulo%></td>
                    </tr>
                    <tr>
                        <td align="left" class="row7" colspan="2">
                            <A href="javascript:Grabar()" class="lq-btn lp-glyphicon lp-glyphicon-save-blanco" style="margin-top:10px">&nbsp;Grabar</A>                           
                        </td>
                        <td align="right" class="row7" colspan="2">
                            <A href="javascript:Regresar()" class="btn_secundario lp-glyphicon lp-glyphicon-return-color">Regresar</A>                           
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="row1" colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Id :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                            <input class="row5 input_text_sed" name = "tctIdUsuario" type="text" value="<%=(objUsuario!=null?Integer.toString(objUsuario.getIntIdUsuario()):"")%>" style="width:16%">
                        </td>          
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Usuario :&nbsp;</td>
                        <td align=left class="row1" colspan="3">
                            <input class="row5 input_text_sed" name = "tctUsuario" type="text" value="<%=(objUsuario!=null?objUsuario.getStrLogin():"")%>" style="width:16%" onKeyPress="javascript:onKeyPressMayuscula.call(this, event);" <%=(strAccion.equals("editar")==true?"readonly":"")%> >
                            <%if(strAccion.equals("crear")){%>
                                <A href="javascript:BuscarUsuario()" class="btn_secundario lp-glyphicon lp-glyphicon-search-color">Buscar</A>                              
                            <%}else{%>
                                &nbsp;
                            <%}%>
                        </td>          
                    </tr>              
                    <tr id="dtUsuario" style="display:none"> 
                        <td class="header" width="15%">&nbsp;</td>
                        <td class="row1" colspan="3">
                            <iframe name="frmUsuario" src="../general/Lista.jsp?tipo=usuario" width="350" height="55" border=0 frameBorder=0 scrolling="no"></iframe>
                        </td>
                    </tr>
                    <%if (strAccion.equals("editar")==true){%>
                        <tr>
                            <td align=left class="header" width="15%" >Nombre:&nbsp;</td>
                            <td align=left colspan=3 class="row1">
                                <input name="tctNombre" type="text" size=60  maxlength="40" class="row5 input_text_sed" value="<%=(objUsuario!=null?objUsuario.getStrNombre():"")%>" readonly>
                            </td>
                        </tr>
                    <%}%>
                    <tr>
                        <td align=left class="header"  width="12%">Rol :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                            <select name="lscRol" align="left" class="TxtCombo lp-select" style="width:16%" onchange="seleccionaRol()">
                                <option value=0>--Seleccione--</option>
                                <%=Tool.listaCombo(lstRoles,"NIDROL","SNOMBRE")%>
                            </select>
                        </td>          
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Oficina :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                             <select class="TxtCombo lp-select" style="width:16%" name="lscOficina">
                                  <option value=0>--Seleccione--</option>
                                  <%=Tool.listaCombo(lstOficina,"CODOFICINA","DESCRIPCION")%>
                            </select>
                        </td>          
                    </tr>
                    <tr id="dtClinica" style="display:none">
                        <td align=left class="header" width="15%" >Cl&iacute;nica :&nbsp;</td>
                        <td align=left colspan=3 class="row1">
                            <input name = "tctCodClinica"  type="text" style="width:10%" value="<%=((objUsuario!=null && objUsuario.getIntCodClinica()!=0)?Integer.toString(objUsuario.getIntCodClinica()):"")%>" class="row5 input_text_sed">
                            <input name = "tctDescClinica" type="text" size=43 onkeypress="javascript:onKeyPressMayuscula.call(this, event);buscaClinica();"  maxlength="40" class="row5 input_text_sed"  value="<%=(objUsuario!=null?objUsuario.getStrNombreExt():"")%>">
                        </td>
                    </tr>
                    <tr id="dtBuscaClinica" style="display:none">
                        <td align="left" class="header" width="15%" >&nbsp;</td>
                        <td align=left class="row1" colspan=3>
                            <iframe name="frmClinica" src="../general/Lista.jsp" width="350" height="55" border=0 frameBorder=0 scrolling="auto"></iframe>          
                        </td>
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Email :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                             <input name="tctEmail" type="text" size=60  maxlength="40" class="row5 input_text_sed" value="<%=((objUsuario!=null && objUsuario.getStrEmail()!= null)?objUsuario.getStrEmail():"")%>" >
                        </td>          
                    </tr>

                    <tr id="dtBroker" style="display:none">

                        <td align=left class="header"  width="15%">Cod. Broker :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                             <input name="tctCodBroker" type="text" style="width:6%"  maxlength="5" class="row5 input_text_sed"  onkeypress="javascript:onKeyPressNumero(this);" value="<%=((objUsuario!=null && objUsuario.getIntCodBroker()!= 0)?Integer.toString(objUsuario.getIntCodBroker()):"")%>" <%=(strAccion.equals("editar")==true?"readonly":"")%>>
                        </td>          
                    </tr>
                    <%if(strAccion.equals("editar")==true){%>
                        <tr>
                            <td align=left class="header"  width="15%">Activo :&nbsp;
                            </td>
                            <td align=left  class="row1" colspan="3">
                                  <INPUT type="checkbox" class="TxtCombo"  name="chcActivo" <%=((objUsuario!=null && objUsuario.getIntFlgActivo()==1)?"checked":"")%> >
                            </td>          
                        </tr> 
                    <%}%>
                    <tr>
                        <td align=left class="header"  width="15%">Firma :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                              <INPUT type="checkbox" class="TxtCombo" onclick="muestraFirma();" name="chcFirma" <%=((objUsuario!=null && objUsuario.getLstFirmas().size()>0)?"checked":"")%> >
                        </td>          
                    </tr>    
                    <tr>
                        <td align=left class="header"  width="15%">Deshabilitar Sol. Beneficio (Cod. Autorización) :&nbsp;
                        </td>
                        <td align=left  class="row1" colspan="3">
                              <INPUT type="checkbox" class="TxtCombo"  name="chcDeshabilitado" <%=((objUsuario!=null && objUsuario.getIntFlgDeshabilitado()==1)?"checked":"")%> >
                        </td>          
                    </tr>  
                </table>
                </fieldset>
                </div>
            </td>
        </tr>
        <tr id="tdFirma" <%=(intFlgFirma>0?"":"style=\"display:none\"")%> >
            <td>
             <div  style = "margin-left : 10px; margin-right:10px" >
                <fieldset class="row5 content_resumen">
                <legend class="titulo_campos_bold">Configuración de Firmas</legend>  
                <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                    <tr>
                        <td class="header" width="15%">
                            Imagen Firma :&nbsp; 
                        </td>
                        <td colspan="3" class="row1">
                            <iframe align="left" name="upload" src="upload.jsp" width="100%" height="25" border=0 frameBorder=0 scrolling="no"></iframe>
                        </td>
                    </tr>
                     <tr>
                        <td class="header" width="15%">
                            &nbsp;
                        </td>
                        <td colspan="3" class="row1">
                             <a href="javascript:verFirma()" class="btn_secundario lp-glyphicon lp-glyphicon-search-file-color">Ver Firma</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="row1" width="15%">&nbsp;
                        </td>
                        <td class="row1" colspan="3">
                            <iframe align="left" name="firma" src="ListaFirma.jsp?codUser=<%=(objUsuario!=null?Integer.toString(objUsuario.getIntIdUsuario()):"-1")%>" width="100%" height="100" border=0 frameBorder=0 scrolling="no"></iframe>
                        </td>
                    </tr>
                </table>
                </fieldset>
                </div>
            </td>
        </tr>
    </table>
</form>
</TD>
</TR>
</TABLE>
</BODY>
</HTML>
   
   
 
                                         
