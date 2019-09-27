<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%        
      /*Instanciando la clase GestorPolClinic , que accede a los metodos DAOS YahirRivas 29FEB2012 17:04pm*/
      GestorPolClinic gestorPolClinic = new GestorPolClinic();
      
      /*Instanciando la clase GestorPolClinic , que accede a los metodos DAOS 02MAR2012 12:36pm*/
      GestorCobertura gestorCobertura = new GestorCobertura();
      
      String strTitulo = "Configuraci�n de Control de Cobertura";
      
      String strSubTitulo = "Nuevo";
      int intPoliza = (request.getParameter("npolicy")!=null?Tool.parseInt(request.getParameter("npolicy")):0);
      int intCobertura = (request.getParameter("ncover")!=null?Tool.parseInt(request.getParameter("ncover")):0);
      int intCoberturaGen = (request.getParameter("ncovergen")!=null?Tool.parseInt(request.getParameter("ncovergen")):0);
     
      String strControl = "-1";
      int intProducto = 0;
      int intMoneda = 0;
      int intFlgEdit = 1;
      
      if(intCoberturaGen>0)
      {
          Poliza objPoliza = null;
          if(intPoliza>0)
          {
              /* aka llega null en el metodo getPoliza() , al parecer la consulta que viaja ala BD no trae ningun,
              dato...  YahirRivas 20MAR2012 15:49 PM*/
              objPoliza = gestorPolClinic.getPoliza(Constante.NRAMOASME, intPoliza,1);
              intProducto = objPoliza.getIntProduct();
              Bean auxBean = gestorPolClinic.getMonedaPoliza(intPoliza);
              intMoneda = Tool.parseInt(auxBean.getString("1"));
          }
              
          strControl = gestorCobertura.getControlCoberturaConfig(intPoliza,intCoberturaGen);
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
              frmCobertura.frmListado.lscCobertura.disabled = true;
              frm.tctPoliza.disabled = true;
              
              frm.tctCobertura.disabled = true;
             
              dtTipo.style.display='none';
              
              <%if(intPoliza>0){%>
                  configurarTipo(1);
              <%}else{%>
                  configurarTipo(2);
                  
              <%}%>
         <%}else{%>
               configurarTipo(1);
         <%}%>
    }
    
    
    function selObj(objeto) 
    { 
         var frm = document.forms[0]; 
         
         valor = objeto.value;
         
         arr = valor.split("|");
         var cobertura=arr[0];
         var coberturagen=arr[1];
         
         frm.hndCobertura.value = cobertura;
         frm.hndCoberturaGen.value = coberturagen; 
         
         buscarConfiguracion();
    }
    
    function Regresar()
    {
      
        var frm = document.forms[0]; 
        window.location.href = "../mantenimiento/MantenimientoControl.jsp?&npoliza=" + frm.tctPoliza.value; 
    }
    
    function Grabar() 
    { 
        var  res = frmControl.marcados();
        if(res==false)
        {
            alert('Debe seleccionar los controles a asignar.');
            return;
        }
        
        var frm = document.forms[0];

        if (validaForm()==false)
            return;
    
        frm.tctPoliza.disabled=false;
        frmCobertura.frmListado.lscCobertura.disabled = false;
        
        frm.tctCobertura.disabled = false;
        
        var tipo = frm.hndTipo.value;
        var poliza = 0;
        var cobertura = 0;
        var coberturagen = 0;
        
        
        if(tipo==1)
        { 
            poliza = frm.tctPoliza.value;
            cobertura = frm.hndCobertura.value;
            coberturagen = frm.hndCoberturaGen.value;
        }
        else
        {
            poliza = 0;
            cobertura = 0;
            coberturagen = frm.tctCobertura.value;
        }
        
        frmControl.Grabar(poliza,cobertura,coberturagen);
    }
  
    
    function ActualizaCobertura()
    {
        var frm = document.forms[0];
        var poliza = frm.tctPoliza.value;
        
        var producto = 0;
        var moneda = 0;
        
        url="../servlet/ProcesoValida?pntipoval=11&pnpoliza=" + poliza;
        var res = retValXml(url);      
        
        if (res!="-1")
        {
            arr = res.split("|");
            producto=arr[0];
            moneda=arr[1];
            
            frm.target="frmCobertura";
            accion = "../general/Lista.jsp?pstipo=cobertura&pnproducto=" + producto + "&pnmoneda=" + moneda;       
            frm.action= accion; 
            frm.submit(); 
            
            buscarConfiguracion();
        }
        else
        {
            alert("No se encontr� la p�liza");
            frm.target = "_self";
            frm.action = "MantenimientoControl_Editar.jsp";
            frm.submit();  
            
        }
    }
    
    function ActualizaControl(control)
    {
         var frm = document.forms[0];
         frm.target="frmControl";
         var accion = "ListaControl.jsp";
         if(control!=undefined)
         {
            accion = accion + "?scontrol=" + control;
         }
         frm.action= accion;
         frm.submit(); 
    }

    
    function verAlerta() 
    { 
         alert("Ocurrio un arror t�cnico al grabar la configuraci�n de control de la cobertura");
         Regresar();
    }
    
    function configurarTipo(tipo)
    {
        var frm = document.forms[0]; 
        frm.hndTipo.value = tipo;
        if(tipo==1)
        {
            dtPoliza.style.display='';
            dtGeneral.style.display='none';
        }
        else
        {
            dtPoliza.style.display='none';
            dtGeneral.style.display='';
        }
        
        <%if(intFlgEdit!=0){%>            
            LimpiaForm();
        <%}%>
        
    }
    
    function LimpiaForm()
    {
        var frm = document.forms[0];
        frm.tctPoliza.value='';
        frm.tctCobertura.value='';
        
        frm.target="frmCobertura";
        accion = "../general/Lista.jsp?pstipo=cobertura";       
        frm.action= accion; 
        frm.submit(); 
        
        frm.target="frmControl";
        frm.action= "ListaControl.jsp";
        frm.submit(); 
    }
    
    function validaForm()
    {    
        
        var frm = document.forms[0];
        var tipo = frm.hndTipo.value;
        
        if(tipo==1)
        {
            if (!valida('tctPoliza','t'))
            return false;
            
            var cobertura = frmCobertura.frmListado.lscCobertura.options[frmCobertura.frmListado.lscCobertura.selectedIndex].value;
            if(cobertura==0)
            {
                alert("Debe seleccionar una cobertura");
                return false;  
            }
        }
        else
        {
            if (!valida('tctCobertura','t'))
                return false;
                
            var cobertura = frm.tctCobertura.value;    
            url="../servlet/ProcesoValida?pntipoval=12&pncoberturagen=" + cobertura;
            var res = retValXml(url);
            
            if(res==0)
            {
                alert("C�digo de cobertura incorrecto.");
                return false;
            }
        }
        return true; 
    }
    
    function buscarConfiguracion()
    {
        var frm = document.forms[0];
        frm.tctPoliza.disabled=false;
        var tipo = frm.hndTipo.value;
        
        var poliza = 0;
        var coberturagen = 0;
       
        if(tipo==1)
        {
            poliza = frm.tctPoliza.value;
            coberturagen = frm.hndCoberturaGen.value;
        }
        else
        {
            coberturagen = frm.tctCobertura.value;
        }
        
        if( (tipo==1 && poliza>0 && coberturagen>0) || (tipo==2 && coberturagen>0 ))
        {
            url="../servlet/ProcesoValida?pntipoval=14&pnpoliza=" + poliza + "&pncoberturagen=" + coberturagen + "&pntipo=1";
            var res = retValXml(url);
            
            if(res!="|")
                ActualizaControl(res);
            else
                ActualizaControl('');          
            
        }    
    }
    
    function validaCobertura()
    {
          
        var frm = document.forms[0];
       
        var coberturagen = frm.tctCobertura.value;
        url="../servlet/ProcesoValida?pntipoval=12&pncoberturagen=" + coberturagen;
        var res = retValXml(url);
        
        if(res==0)
        {
            alert("Codigo de cobertura incorrecto");
            frm.tctCobertura.focus();
            return false;
        }
    }
</script>
</head>
<body  onload="LoadBody();" leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0"> 
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
<form name="frmMantUsoCobertura" method="post"> 
<input name="hndCobertura" type="hidden" value="<%=intCobertura%>">
<input name="hndCoberturaGen" type="hidden" value="<%=intCoberturaGen%>">
<input name="hndTipo" type="hidden" value="">

    <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                <legend></legend>  
                <table cellSpacing="1"  border=0 width="100%" class="form-table-controls">
                    <tr>
                        <td colspan=2 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt" align="left">
                            <%=strSubTitulo%>&nbsp;-&nbsp;Configuraci&oacute;n&nbsp;de&nbsp;Control
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="row7">
                            <A href="javascript:Grabar()" class="lq-btn lp-glyphicon lp-glyphicon-save-blanco" style="margin-top:10px">&nbsp;Grabar</A>
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
                    <tr id="dtTipo">
                        <td align="left" class="row1" colspan="2">
                            <input class="TxtCombo" name="rdTipo" type="radio" value="1" onclick="javascript:configurarTipo(1);"  <%=((intCoberturaGen==0 || intPoliza>0)?"checked":"")%> >Por Poliza
                            <input class="TxtCombo" name="rdTipo" type="radio" value="2" onclick="javascript:configurarTipo(2);"  <%=((intCoberturaGen>0 && intPoliza==0)?"checked":"")%> >General
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="left" class="row1" colspan="2">
                            <div id="dtPoliza" >
                                <table cellSpacing="0"  border=0 width="100%" class="form-table-controls">
                                      <tr>
                                          <td align=left class="header"  width="15%">Contrato&nbsp;:&nbsp;
                                          </td>
                                          <td align=left  class="row1" >
                                              <input class="row5 input_text_sed" name = "tctPoliza" type="text" maxlength="8" style="width:12%" value="<%=(intPoliza==0?"":Integer.toString(intPoliza))%>" onblur="javascript:buscarConfiguracion();ActualizaCobertura();" onKeyPress="javascript:onKeyPressNumero('this');">
                                          </td>          
                                      </tr>
                                      <tr>
                                          <td align=left class="header"  width="15%">Cobertura:&nbsp;</td>
                                          <td align=left class="row1" >
                                              <iframe name="frmCobertura" src="../general/Lista.jsp?pstipo=cobertura&pnproducto=<%=intProducto%>&pnmoneda=<%=intMoneda%>&pncobertura=<%=intCobertura%>"  width="33%" height="20" border=0 frameBorder=0 scrolling="no"></iframe>          
                                          </td>          
                                      </tr>              
                                </table>
                            </div>
                            <div id="dtGeneral">
                                <table cellSpacing="0"  border=0 width="100%" class="form-table-controls">
                                      <tr>
                                          <td align=left class="header"  width="15%">Cobertura:&nbsp;</td>
                                          <td align=left class="row1" >
                                              <input class="row5 input_text_sed" name = "tctCobertura" type="text" maxlength="4" style="width:12%" value="<%=(intCoberturaGen==0?"":Integer.toString(intCoberturaGen))%>" onKeyPress="javascript:onKeyPressNumero('this');"  onblur="javascript:buscarConfiguracion();validaCobertura();">
                                          </td>          
                                      </tr>              
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align=left class="row1" colspan="2">
                            <iframe name="frmControl" src="ListaControl.jsp?scontrol=<%=strControl%>"  width="60%" height="150" border=0 frameBorder=0 scrolling="auto"></iframe>          
                        </td>          
                    </tr>  
                    
                </table>
                </fieldset>
            </td>
        </tr>
    </table>
</form>
</TD>
</TR>
</TABLE>
</div>
</BODY>
</HTML>
   
   
 
                                         
