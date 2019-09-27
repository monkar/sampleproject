<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%   
      String strTitulo = "Configuración de Uso de Cobertura";
      String strSubTitulo = "Nuevo";
      int intPoliza = (request.getParameter("npolicy")!=null?Tool.parseInt(request.getParameter("npolicy")):0);
      int intCobertura = (request.getParameter("ncover")!=null?Tool.parseInt(request.getParameter("ncover")):0);
      int intCoberturaGen = (request.getParameter("ncovergen")!=null?Tool.parseInt(request.getParameter("ncovergen")):0);
      int intConceptoPago = (request.getParameter("npayconcep")!=null?Tool.parseInt(request.getParameter("npayconcep")):0);      
      
      /*Se instancio la clase GestorPolClinic yahirRivas 29FEB2012 11:00am*/
      GestorPolClinic gestorPolClinic = new GestorPolClinic();
            /*Se instancio la GestorCobertura yahirRivas 02MAR2012 12:35pm*/
      GestorCobertura gestorCobertura = new GestorCobertura();
      
      Bean objBean = null;
      int intProducto = 0;
      int intMoneda = 0;
      int intFlgEdit = 1;
      if(intCoberturaGen>0)
      {
          Poliza objPoliza = null;
          if(intPoliza>0)
          {
              objPoliza = gestorPolClinic.getPoliza(Constante.NRAMOASME, intPoliza,1);
              intProducto = objPoliza.getIntProduct();
              Bean auxBean = gestorPolClinic.getMonedaPoliza(intPoliza);
              intMoneda = Tool.parseInt(auxBean.getString("1"));
          }
              
          objBean = gestorCobertura.getUsoCoberturaConfig(intPoliza,intCoberturaGen,intConceptoPago);
          intFlgEdit = 0;
          strSubTitulo = "Editar";     
      }
      String  strConceptoPago =  (objBean!=null?objBean.getString("NCONCEPTOPAGO"):"");
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
              frmConcepto.frmListado.lscConceptoPago.value = <%=(objBean!=null?objBean.getString("NCONCEPTOPAGO"):"0")%>;
              frm.lscConceptoPago.value= <%=(objBean!=null?objBean.getString("NCONCEPTOPAGO"):"0")%>;
              
              var ntipofrec = <%=(objBean!=null?objBean.getString("NTIPOFREQ"):"0")%>;
              frm.lscTipoFrecuencia.value=ntipofrec;
              
              frmCobertura.frmListado.lscCobertura.disabled = true;
              frmConcepto.frmListado.lscConceptoPago.disabled = true;
              frm.tctPoliza.disabled = true;
              frm.tctCobertura.disabled = true;
              frm.lscConceptoPago.disabled = true;
              
              if(ntipofrec==2)
                  frm.tctPeriodo.disabled=true;
              else
                  frm.tctPeriodo.disabled=false;
              
              dtTipo.style.display='none';

              <%if(intPoliza>0){%>
                  configurarTipo(1);
              <%}else{%>
                  configurarTipo(2);
              <%}%>
              
              
         <%}else{%>
               dtEstado.style.display="none";
               configurarTipo(1);
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
        
        frm.target="frmConcepto";
        frm.action= "../general/Lista.jsp?pstipo=concepto";
        frm.submit(); 
        
        frm.lscConceptoPago.value=0;
        frm.tctPeriodo.value='';
        frm.tctFrecuencia.value='';
               
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
    
    function selObj(objeto) 
    { 
         var frm = document.forms[0]; 
         
         if(objeto.name=='lscCobertura')
         {
             valor = objeto.value;
             arr = valor.split("|");
             var cobertura=arr[0];
             var coberturagen=arr[1];
             
             frm.hndCobertura.value = cobertura;
             frm.hndCoberturaGen.value = coberturagen; 
             ActualizaConcepto(cobertura);
         }
         
         buscarConfiguracion();
         
    }
    
    function Regresar()
    {
      
        var frm = document.forms[0]; 
        window.location.href = "../mantenimiento/MantenimientoUso.jsp?&npoliza=" + frm.tctPoliza.value; 
    }
    
    function Grabar() 
    { 
        var frm = document.forms[0];

        if (validaForm()==false)
            return;
    
        frm.tctPoliza.disabled=false;
        frmCobertura.frmListado.lscCobertura.disabled = false;
        frmConcepto.frmListado.lscConceptoPago.disabled = false;
        
        frm.tctCobertura.disabled = false;
        frm.lscConceptoPago.disabled = false;
    
        var tipo = frm.hndTipo.value;
        var poliza = 0;
        var concepto = 0;
        var cobertura = 0;
        var coberturagen = 0;
        
        
        if(tipo==1)
        { 
            poliza = frm.tctPoliza.value;
            concepto = frmConcepto.frmListado.lscConceptoPago.options[frmConcepto.frmListado.lscConceptoPago.selectedIndex].value;
            cobertura = frm.hndCobertura.value;
            coberturagen = frm.hndCoberturaGen.value;
        }
        else
        {
            poliza = 0;
            concepto = frm.lscConceptoPago.value;
            cobertura = 0;
            coberturagen = frm.tctCobertura.value;
        }

        
        var periodo = frm.tctPeriodo.value;
        var frecuencia = frm.tctFrecuencia.value;
        var tipofrec = frm.lscTipoFrecuencia.value;
        var estado = 0;
        if(frm.chcEstado.checked==true)
            estado=1;
       
        
        frmConcepto.frmListado.action="../servlet/ProcesoMant?proceso=5&pnpoliza=" + poliza + "&pncobertura=" + cobertura 
                                      + "&pncoberturagen=" + coberturagen + "&pnperiodo=" + periodo + "&pnfrecuencia=" + frecuencia 
                                      + "&pnconcepto=" + concepto + "&pnestado=" + estado +  "&pntipofrec=" + tipofrec;
        frmConcepto.frmListado.submit();
     
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
            
            var concepto = frmConcepto.frmListado.lscConceptoPago.options[frmConcepto.frmListado.lscConceptoPago.selectedIndex].value;
            if(concepto==-1)
            {
                alert("Debe seleccionar un concepto de pago");
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
                alert("Código de cobertura incorrecto.");
                return false;
            }
            
            if (!valida('lscConceptoPago','s'))      
            return false; 
        }
        
        if (!valida('lscTipoFrecuencia','s'))      
            return false; 
        
        if (frm.lscTipoFrecuencia.value == 1)    
        {
            if (!valida('tctPeriodo','t'))
                return false; 
        }
         
        if (!valida('tctFrecuencia','t'))
            return false; 

        return true; 
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

            frm.target="frmConcepto";
            accion = "../general/Lista.jsp?pstipo=concepto";       
            frm.action= accion; 
            frm.submit();  
            
            buscarConfiguracion();

        }
        else
        {
            alert("No se encontró la póliza");
            frm.target = "_self";
            frm.action = "MantenimientoUso_Editar.jsp";
            frm.submit();  
            
        }
    }
    
    function ActualizaConcepto(cover)
    {        
        var frm = document.forms[0];
        frm.target="frmConcepto";
        accion = "../general/Lista.jsp?pstipo=concepto&pncobertura=" + cover;       
        frm.action= accion; 
        frm.submit();     
    }
  
    function verAlerta(valor) 
    { 
        if (valor == -1)
            alert("Ocurrió un error técnico al grabar la configuración de uso de la cobertura");
        if (valor == -2)
            alert("No se puede registrar la configuración. Existe una configuración para un concepto de pago.");   
        if (valor == -3)
            alert("No se puede registrar la configuración. Existe una configuración para todos los conceptos de pago.");
            
        Regresar();
    }
    
    function buscarConfiguracion()
    {
        var frm = document.forms[0];
        frm.tctPoliza.disabled=false;
        var tipo = frm.hndTipo.value;
        
        var poliza = 0;
        var coberturagen = 0;
        var conceptopago = 0;
        
        if(tipo==1)
        {
            poliza = frm.tctPoliza.value;
            coberturagen = frm.hndCoberturaGen.value;
            conceptopago = frmConcepto.frmListado.lscConceptoPago.options[frmConcepto.frmListado.lscConceptoPago.selectedIndex].value;
        }
        else
        {
            coberturagen = frm.tctCobertura.value;
            conceptopago = frm.lscConceptoPago.value;
        }
        
        if( (tipo==1 && poliza>0 && coberturagen>0 && conceptopago>0) ||
            (tipo==2 && coberturagen>0 && conceptopago>0) )
        {
            url="../servlet/ProcesoValida?pntipoval=13&pnpoliza=" + poliza + "&pncoberturagen=" + coberturagen + "&pnconceptopago=" + conceptopago;
            var res = retValXml(url);
            
            if(res!='-1')
            {
                arr = res.split("|");
                var periodo=arr[0];
                var frecuencia=arr[1];
                var estado=arr[2];
                var tipofrec=arr[3];
                
                frm.tctPeriodo.value=periodo;
                frm.tctFrecuencia.value=frecuencia;
                frm.lscTipoFrecuencia.value=tipofrec;
                
                if( (estado==0 && frm.chcEstado.checked==true) || (estado==1 && frm.chcEstado.checked==false) )
                    frm.chcEstado.click();
            }
            else
            {
                frm.tctPeriodo.value='';
                frm.tctFrecuencia.value='';
                frm.lscTipoFrecuencia.value=0;
            }
            
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
    
    function ActualizaFrecuencia(valor)
    {        
        var frm = document.forms[0];
        frm.tctPeriodo.value='';
        if(valor==2)
            frm.tctPeriodo.disabled=true;
        else
            frm.tctPeriodo.disabled=false;
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
<form name="frmMantUsoCobertura" method="post"> 
<input name="hndCobertura" type="hidden" value="<%=intCobertura%>">
<input name="hndCoberturaGen" type="hidden" value="<%=intCoberturaGen%>">
<input name="hndTipo" type="hidden" value="">

    <table width="100%" class="2 form-table-controls" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <fieldset class="row5 content_resumen" style="padding-top:10px; padding-bottom:10px">
                <legend></legend>  
                <table cellSpacing="1"  border=0 width="100%">
                    <tr>
                        <td colspan=2 class="row7 titulo_campos_bold" style="FONT-SIZE: 10pt" align="left">
                            <%=strSubTitulo%>&nbsp;-&nbsp;Configuraci&oacute;n&nbsp;de&nbsp;Uso
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
                            <input class="TxtCombo" name="rdTipo" type="radio" value="2" onclick="javascript:configurarTipo(2);" <%=((intCoberturaGen>0 && intPoliza==0)?"checked":"")%> >General
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="row1" colspan="2">
                            <div id="dtPoliza" >
                                <table cellSpacing="0"  border=0 width="100%">
                                      <tr>
                                          <td align=left class="header"  width="15%">Contrato&nbsp;:&nbsp;
                                          </td>
                                          <td align=left  class="row1" >
                                              <input class="row5 input_text_sed" name = "tctPoliza" type="text" maxlength="8" style="width:12%" value="<%=(intPoliza==0?"":Integer.toString(intPoliza))%>" onblur="javascript:ActualizaCobertura();" onKeyPress="javascript:onKeyPressNumero('this');">
                                          </td>          
                                      </tr>
                                      <tr>
                                          <td align=left class="header"  width="15%">Cobertura:&nbsp;</td>
                                          <td align=left class="row1" >
                                              <iframe name="frmCobertura" src="../general/Lista.jsp?pstipo=cobertura&pnproducto=<%=intProducto%>&pnmoneda=<%=intMoneda%>&pncobertura=<%=intCobertura%>"  width="33%" height="20" border=0 frameBorder=0 scrolling="no"></iframe>          
                                          </td>          
                                      </tr>              
                                      <tr> 
                                          <td class="header" width="15%">Concepto&nbsp;Pago&nbsp;:&nbsp;</td>
                                          <td class="row1" >
                                              <iframe name="frmConcepto" src="../general/Lista.jsp?pstipo=concepto&pncobertura=<%=intCobertura%>&pnconcepto=<%=strConceptoPago%>"  width="30%" height="20" border=0 frameBorder=0 scrolling="no"></iframe>          
                                          </td>
                                      </tr>
                                </table>
                            </div>
                            <div id="dtGeneral">
                                <table cellSpacing="0"  border=0 width="100%">
                                      <tr>
                                          <td align=left class="header"  width="15%">Cobertura:&nbsp;</td>
                                          <td align=left class="row1" >
                                              <input class="row5 input_text_sed" name = "tctCobertura" type="text" maxlength="4" style="width:12%" value="<%=(intCoberturaGen==0?"":Integer.toString(intCoberturaGen))%>" onKeyPress="javascript:onKeyPressNumero('this');"  onblur="javascript:buscarConfiguracion();validaCobertura();">
                                          </td>          
                                      </tr>              
                                      <tr> 
                                          <td class="header" width="15%">Concepto&nbsp;Pago&nbsp;:&nbsp;</td>
                                          <td class="row1">
                                              <%
                                                  BeanList lstConcPago = Tabla.lstConceptoPagoIfx(0); 
                                              %>
                                              <select class="TxtCombo lp-select" style="width:30%" name="lscConceptoPago" onchange="javascript:buscarConfiguracion();">
                                                  <option value="-1">--Seleccione--</option>
                                                  <option value="0">Todos</option>
                                                  <%
                                                      if(lstConcPago!= null && lstConcPago.size()>0)
                                                          out.println( Tool.listaComboSeleccionado(lstConcPago,"codigint","short_des",strConceptoPago));
                                                  %>
                                              </select>
                                          </td>
                                      </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr> 
                        <td class="header" width="10%">Tipo&nbsp;de&nbsp;Frecuencia:&nbsp;</td>
                        <td class="row1">
                            <select class="TxtCombo lp-select" style="width:30%" name="lscTipoFrecuencia" onchange="javascript:ActualizaFrecuencia(this.value);">
                                <option value="0">--Seleccione--</option>
                                <option value="1">Por Vigencia Actual</option>
                                <option value="2">Por Vigencia Original</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Periodo&nbsp;(meses)&nbsp;:&nbsp;
                        </td>
                        <td align=left  class="row1" >
                            <input class="row5 input_text_sed" name = "tctPeriodo" type="text"  maxlength="2" value="<%=(objBean!=null?objBean.getString("NPERIODO"):"")%>" style="width:4%" onKeyPress="javascript:onKeyPressNumero('this');">
                        </td>          
                    </tr>
                    <tr>
                        <td align=left class="header"  width="15%">Frecuencia&nbsp;:&nbsp;
                        </td>
                        <td align=left  class="row1" >
                            <input class="row5 input_text_sed" name = "tctFrecuencia" type="text" maxlength="2" value="<%=(objBean!=null?objBean.getString("NFRECUENCIA"):"")%>" style="width:4%" onKeyPress="javascript:onKeyPressNumero('this');">
                        </td>          
                    </tr>
                    <tr id="dtEstado">
                        <td align=left class="header"  width="15%">Activo&nbsp;:&nbsp;
                        </td>
                        <td align=left class="row1">
                            <INPUT type="checkbox" class="TxtCombo" name="chcEstado" <%=((objBean!=null && objBean.getString("NESTADO").equals("1"))?"checked":"")%>>
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
   
   
 
                                         
