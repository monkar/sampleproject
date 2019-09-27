<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<jsp:include page="../menu/Menu.jsp" />
<%

  int intRedBase = 1;
  
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Mantenimiento de Cobertura y Proveedores</title>
    <jsp:include page="../general/scripts.jsp" />
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
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
  <form name="frmAtencion" method="post">
  <input type="hidden" name="hcnPlan" value=""/>
  <input type="hidden" name="hcnCobertura" value=""/>
  <input type="hidden" name="hctAcc" value=""/>
  <input type="hidden" name="hctCodsCli" value=""/>
  <input type="hidden" name="hcnMoneda" value=""/>
  <input type="hidden" name="hcnNumCli" value=""/>
  
   <table class="2 form-table-controls" cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
   <tr>
   <td>
    <br>
    <div style="margin-left: 10px;margin-right: 10px;margin-top: 10px;">
    <fieldset class="row5 content_resumen">
     <table class="2 form-table-controls" cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
     <tr>
       <td align="left" class="row2">
         Ramo&nbsp;:
       </td>
       <td align="left" class="row2" colspan=2>
         <input class='row5 input_text_sed' type="text" name="tcnRamo" maxlength="5" style="width:10%" readonly value="<%=Constante.NRAMOASME%>"/>
         <input class='row5 input_text_sed' type="text" name="tctRamo" maxlength="15" style="width:70%" value="<%=Tabla.reaTableIfx(10,Constante.NRAMOASME).getString("2")%>"/>
       </td>
       <td align="right" class="row2">
          Poliza&nbsp;:&nbsp;
       </td>
       <td align="left" class="row2" colspan=2>
         <!--<input class='row5' type="text" name="tcnPoliza" maxlength="8" style="width:17%" onkeypress="javascript:onKeyPressNumero(this);onKey(this);" onblur="javascript:selObj(this)"/>-->
         <input class='row5 input_text_sed' type="text" name="tcnPoliza" maxlength="8" style="width:17%" onkeypress="javascript:onKeyPressNumero(this);onKey(this);"/>
         <input class='row5 input_text_sed' type="text" name="tctPoliza" maxlength="8" style="width:73%"/>
       </td>
     </tr>
     <tr>
       <td align="left" class="row2">
         Producto :&nbsp;
       </td>
       <td align="left" class="row2" colspan=2>
         <input class='row5 input_text_sed' type="text" name="tcnProducto" maxlength="5" style="width:10%" readonly/>
         <input class='row5 input_text_sed' type="text" name="tctProducto" maxlength="5" style="width:80%" readonly/>
       </td>
       <td align="right" class="row2">
         Moneda&nbsp;:&nbsp;</td>
       <td align="left" class="row2">
         <input class="row2 input_text_sed" style="border:0" type="text" name="tctMoneda" readonly maxlength="10" size="12"/>
       </td>
       <td align="right" class="row2">&nbsp;</td>
     </tr>
     <tr>
       <td align="right" class="row2">
         <DIV align="left">
           Modalidad : 
         </DIV>
       </td>
       <td align="left" class="row2">
         <select size="1" name="lscModalidad" onchange="selObj(this);" class="lp-select">       
           <option value="0">(Seleccione)</option>
           <%
            BeanList lstLista = Tabla.lstTableQIfx(703);      
            for(int i=0;i<lstLista.size();i++){
              if ("CH".equals(lstLista.getBean(i).getString("codigext")) || "CA".equals(lstLista.getBean(i).getString("codigext")))
                out.print("<option value=" + lstLista.getBean(i).getString("codigint") + ">" + lstLista.getBean(i).getString("descript") + "</option>");
            }            
            
           %>
         </select>
       </td>
       <td align="right" class="row2">&nbsp;</td>
       
       <td align="right" class="row2">
         Plan&nbsp;:&nbsp;
       </td>
       <td align="left" class="row2">
          <iframe name="lstPlan" src="../general/Lista.jsp?pstipo=plan" width="100%" height="20" border=0 frameBorder=0 scrolling="no"></iframe>       
       </td>       
       <td align="right" class="row2">&nbsp;</td>
     </tr>
     <tr>
       <td align="left" class="row2">
           Concepto :
       </td>
       <td align="left" class="row2">
         <select size="1" name="lscConcepto" onchange="javascript:selObj(this)" class="lp-select">
           <option value="0">(Seleccione)</option>
           <%
            lstLista = Tabla.lstTableQIfx(700);           
            for(int i=0;i<lstLista.size();i++)
              if (Tool.parseInt(lstLista.getBean(i).getString("codigint"))==Constante.NCNCEPCU ||
                  Tool.parseInt(lstLista.getBean(i).getString("codigint"))==Constante.NCNCEPHM )
              out.print("<option value=" + lstLista.getBean(i).getString("codigint") + ">" + lstLista.getBean(i).getString("descript") + "</option>");
           %>         
         </select>
       </td>
       <td align="right" class="row2">&nbsp;</td>
       <td align="right" class="row2">
         Cobertura&nbsp;:&nbsp;
       </td>
       <td align="right" class="row2">
          <iframe name="lstCobertura" src="../general/Lista.jsp?pstipo=cobertura" width="100%" height="20" border=0 frameBorder=0 scrolling="no"></iframe>       
       </td>

       <td align="right" class="row2">&nbsp;</td>
     </tr>
     <tr>
       <td align="left" class="row2">
         Red &nbsp;:
       </td>
       <td align="left" class="row2">
         <input class='row5 input_text_sed' type="text" name="tcnRed" maxlength="2" size="5" onkeypress="javascript:onKeyPressNumero(this);" onchange="javascript:selObj(this)"/>
       </td>
       <td align="right" class="row2">&nbsp;</td>
       <td align="right" class="row2"> 
         Efecto&nbsp;:&nbsp;
       </td>
       <td align="left" class="row2">
         <input class="row5 input_text_sed" type="text" name="tcdEfecto" maxlength="10" size="12" onKeyPress="javascript:onKeyPressFecha(this);" onchange="javascript:selObj(this)"/>
       </td>
       <td align="right" class="row2">&nbsp;
       </td>
     </tr>
     </table>
   </td>
   </tr>
   <tr>
   <td>
    <div style="margin-left: 20px;margin-right: 10px;">
     <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" class="form-table-controls">
       <tr>
         <td align="left" width="15%">
           <input class="row5 btn_secundario lp-glyphicon lp-glyphicon-add-color" type="button" disabled onclick="javascipt:registrar();limpiar(2);" name="btcNuevo" value="Nueva Clinica"/>
         </td>
         <td align="left"  width="15%">
           <input class="row5 btn_secundario lp-glyphicon lp-glyphicon-remove-color" disabled type="button" onclick="javascipt:eliminar();" name="btcEliminar" value="Quitar Clinica"/>
         </td>
         <td align="left" width="15%">&nbsp;
         </td>
         <td align="left" width="15%">
           <input class="row5 btn_secundario lp-glyphicon lp-glyphicon-clean-color" type="button" onclick="javascipt:limpiar(1);" name="btcLimpiar" value="Limpiar"/>
         </td>
         <td align="left" width="15%">
           <input class="row5 btn_secundario lp-glyphicon lp-glyphicon-see-color" type="button" value="Consultar" onclick="javascipt:buscar();" name="btcConsultar"/>
         </td>
       </tr>
     </table>
     </div>
   </td>
   </tr>
   <tr id="dtDetalle" style="display:none">
   <td>
     <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" class="form-table-controls">
       <tr>
       <td align="left">
          <div style="margin-left: 20px;margin-right: 10px;">
            <input name="tctTitulo" type="text" class="input_text_sed" style="BORDER:0;FONT-WEIGHT: bolder; FONT-SIZE: 9pt; COLOR: #1a579c;" readonly>
          </div>
       </td>
       </tr>
       <tr>
       <td align="center" class="row2">       
         <div style="margin-left: 10px;margin-right: 10px;margin-top: 10px;">
         <fieldset class="row5 content_resumen">
         <legend class="titulo_campos_bold">Deducible</legend>  
         <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
           <tr>
             <td align="left" class="row1" width="17%">
               Cantidad&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="13%">
               <input class='row5 input_text_sed' type="text" name="tcnDeduCant" maxlength="2" size="5" onkeypress="javascript:onKeyPressNumero(this);onKey(this)" onblur="javascript:selObj(this);" value="0"/>
             </td>
             <td align="right" class="row1" width="14%">
               Monto&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="26%">
               <input class='row5 input_text_sed' type="text" name="tcnDeduMonto" maxlength="7" size="10" onkeypress="javascript:onKeyPressNumero(this);onKey(this)" onblur="javascript:selObj(this);" value="0"/>
             </td>
             <td align="right" class="row1" width="16%">
               Porcentaje&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="14%">
               <input class='row5 input_text_sed' type="text" name="tcnDeduPorc" maxlength="5" size="5" onkeypress="javascript:onKeyPressNumero(this);onKey(this)" onblur="javascript:selObj(this);" value="0"/>
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
         <legend class="titulo_campos_bold">Coaseguro</legend>  
         <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
           <tr>
             <td align="left" class="row1" width="16%">
               Porcentaje&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="14%">
               <input class='row5 input_text_sed' type="text" name="tcnCoaPorc" maxlength="5" size="5" value="0" onkeypress="javascript:onKeyPressNumero(this);"/>
             </td>
             <td align="right" class="row1" width="14%">
               B.M&aacute;ximo&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="56%">
               <input class='row5 input_text_sed' type="text" name="tcnBenemax" maxlength="7" size="10" readonly/>
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
         <legend class="titulo_campos_bold">Proveedor</legend>  
         <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
           <tr>
             <td align="left" class="row1" width="14%">
               C&oacute;digo&nbsp;:&nbsp;
             </td>
             <td align="left" class="row1" width="64%">
               <input class='row5 input_text_sed' type="text" name="tcnProveedor" maxlength="5" size="5" onkeypress="javascript:onKeyPressNumero(this);onKey(this);"/>
               <input class='row5 input_text_sed' type="text" name="tctProveedor" maxlength="20" style="width:90%" onkeypress="javascript:onKeyPressMayuscula.call(this, event);onKey(this);" onfocus="javascript:selObj(this)"/>
             </td>
             <td align="left" class="row1" width="10%">
               <input class='row5 lq-btn lp-glyphicon lp-glyphicon-save-blanco' type="button" onclick="javascipt:grabar();" name="btcGrabar" value="Grabar"/>
             </td>         
             <td align="left" class="row1" width="10%">&nbsp;
             </td>         
           </tr>
           <tr id="dtProveedor" style="display:none">
             <td align="left" class="row1">&nbsp;</td>
             <td align="left" class="row1">
                <iframe name="frProveedor" src="../general/Lista.jsp" width="350" height="55" border=0 frameBorder=0 scrolling="no"></iframe>          
             </td>
             <td align="left" class="row1" colspnan=2>&nbsp;</td>
           </tr>
         </table>
         </fieldset>
         </div>
       </td>
       </tr>
     </table>
   </td>
   </tr>
   <tr id="dtListado">
   <td>
     <div style="margin-left: 10px;margin-right: 10px;">
     <fieldset class="row5 content_resumen">
     <legend class="row2 titulo_campos_bold">Proveedores</legend>  
     <table cellspacing="0" cellpadding="0" border="0" width="100%" align="center">
       <tr>
         <td align="left" class="row2" width="16%">
          <iframe name="frGridProveedor" align=left width="100%" height="250" frameborder="0" scrolling="auto" src="../mantenimiento/ListaProveedor.jsp"></iframe>
         </td>
       </tr>
     </table>
     </fieldset>
     </div>
   </td>
   </tr>      
   </table>
   <iframe name="proceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  
  </form>
 </TD>
</TR>
</TABLE> 
</body>
<script type="text/javascript">
 function LoadBody()
 {
  window.moveTo(0,0);
  window.resizeTo(window.screen.availWidth,window.screen.availHeight);
  window.focus();
 }

  function ActiveProceso(val)
  {
    var frm = document.forms[0]; 
   /* if (valor == 'true')
      val=true;
    else
      val=false;*/
    frm.tcnDeduCant.disabled = val;
    frm.tcnDeduMonto.disabled = val;
    frm.tcnDeduPorc.disabled = val;
    frm.tcnCoaPorc.disabled = val;   
  }
  
  function grabar(){
    var frm = document.forms[0];  
    var acc = frm.hctAcc.value;
    if (!valcontrol())      
       return;
    /*if (!valida('tcnDeduCant','t'))      
            return false;
    if (!valida('tcnDeduMonto','t'))      
            return false;
    if (!valida('tcnDeduPorc','t'))      
            return false;
    if (!valida('tcnCoaPorc','t'))      
            return false;*/
    if (!valida('tcdEfecto','t'))      
            return false;
    if (!validaFecha('tcdEfecto'))
            return false;
    if (!valida('tctProveedor','t'))      
            return false;
            
    var resp=confirm("Esta seguro de registrar los datos para la clínica"); 
    if (resp)  {  
      enviaDatos(acc)      
      //document.forms[0].hctAcc.value="";
    }

  }
  
  function enviaDatos(acc){
   var frm = document.forms[0];   
   frm.target="proceso";
   frm.action="../servlet/ProcesoMant?proceso=1";
   frm.submit(); 
   
  }
 
  function buscar(){
    var frm = document.forms[0];
    if (!valida('tcnPoliza','nc'))      
            return false;
    if (!valida('tcnProducto','nc'))          
            return false;
    if (!lstPlan.valida('lscPlan','s'))      
            return false;    
    if (!valida('tcdEfecto','t'))      
            return false;
    if (!validaFecha('tcdEfecto'))
            return false;
            
    verListado();
    dtDetalle.style.display="none";
    frm.btcNuevo.disabled=false;
  }

  function valcontrol()
  {
    if (!valida('tcnPoliza','nc'))      
            return false;
    if (!valida('tcnProducto','nc'))          
            return false;
    if (!lstPlan.valida('lscPlan','s'))      
            return false;
    if (!lstCobertura.valida('lscCobertura','s'))      
            return false;
    if (!valida('lscModalidad','s'))      
            return false;
    if (!valida('lscConcepto','s'))      
            return false;
    if (!valida('tcnRed','nc'))      
            return false;
    return true;
  }
  
  function verListado(){
    var frm = document.forms[0];
    var nramo = frm.tcnRamo.value;
    var npoliza = frm.tcnPoliza.value;
    var nplan = frm.hcnPlan.value;    
    var ncobertu = frm.hcnCobertura.value;  
    var nmodali = frm.lscModalidad.value;
    var nred = frm.tcnRed.value;  
    var efecto = frm.tcdEfecto.value;  
    var concep = frm.lscConcepto.value;  
      
    frGridProveedor.location.href = "../mantenimiento/ListaProveedor.jsp?psbuscar=1&pnramo=" + nramo + "&pnpoliza=" + npoliza + "&pnplan=" + nplan + "&pnmodali=" + nmodali + "&pnred=" + nred + "&pncobertu=" + ncobertu + "&pdefecto=" + efecto + "&pconcep=" + concep;
  }

   
  function selObj(obj, value){
  var frm = document.forms[0];
      if (obj.name=="tcnPoliza"){
        var nramo = frm.tcnRamo.value;
        getPoliza();
        var nproducto = frm.tcnProducto.value;
        var nmoneda = frm.hcnMoneda.value;        
        lstPlan.location.href ="../general/Lista.jsp?pstipo=plan&pnproducto=" + nproducto + "&pnramo=" + nramo  + "&pnmoneda=" + nmoneda;
        dtDetalle.style.display="none";
      }   

      if (obj.name=="lscPlan"){
        var nramo = frm.tcnRamo.value;
        var nproducto = frm.tcnProducto.value;        
        var nplan = obj.value;
        var nmoneda = frm.hcnMoneda.value;
        frm.hcnPlan.value = nplan;
        lstCobertura.location.href ="../general/Lista.jsp?pstipo=cobertura&pnproducto=" + nproducto + "&pnramo=" + nramo + "&pnplan=" + nplan + "&pnmoneda=" + nmoneda;
        dtDetalle.style.display="none";
      }   

      if (obj.name=="lscCobertura"){
        var scober = obj.value;

        if (scober!=''){
         arr = scober.split("|");
         frm.hcnCobertura.value = arr[0]; 
         frm.tcnBenemax.value = arr[1];
        }
        dtDetalle.style.display="none";
      }
      
      if (obj.name == "lscProv"){
        dtProveedor.style.display="none";
        i=obj.selectedIndex;
        frm.tcnProveedor.value=obj.options[i].value;
        frm.tctProveedor.value=obj.options[i].text;  
      }
      if (obj.name == "tctProveedor"){
          frm.tcnProveedor.value="";
          frm.tctProveedor.value=""; 
      }
      if (obj.name == "lscModalidad"){
          if (obj.value == <%=Constante.NATENHOSP%>){
           frm.lscConcepto.value=<%=Constante.NCNCEPCU%>;
           frm.tcnDeduCant.disabled = false;
          }
          if (obj.value == <%=Constante.NATENAMB%>){
           frm.lscConcepto.value=<%=Constante.NCNCEPHM%>;
           frm.tcnDeduCant.disabled = true;
          }
          dtDetalle.style.display="none";
      }
      
     if (obj.name == "tcnDeduCant"){
      
          if (obj.value== 0 || obj.value == ''){
              frm.tcnDeduMonto.disabled = false;
              frm.tcnDeduPorc.disabled = false;
          }else{
              frm.tcnDeduMonto.disabled = true;
              frm.tcnDeduPorc.disabled = true;
          }
      }
      
      if (obj.name == "tcnDeduMonto"){
      
          if (obj.value== 0 || obj.value == ''){
               frm.tcnDeduCant.disabled = false;
              frm.tcnDeduPorc.disabled = false;
          }else{
              frm.tcnDeduCant.disabled = true;
              frm.tcnDeduPorc.disabled = true;
          }
          if (frm.lscModalidad.value == <%=Constante.NATENAMB%>)
            frm.tcnDeduCant.disabled = true;
      }  

      if (obj.name == "tcnDeduPorc"){
      
          if (obj.value== 0 || obj.value == ''){
              frm.tcnDeduCant.disabled = false;
              frm.tcnDeduMonto.disabled = false;
          }else{
              frm.tcnDeduCant.disabled = true;
              frm.tcnDeduMonto.disabled = true;
          }
          if (frm.lscModalidad.value == <%=Constante.NATENAMB%>)
            frm.tcnDeduCant.disabled = true;

      }    
 
      if (obj.name == "tcdEfecto" || obj.name == "tcnRed" || obj.name == "lscConcepto"){
        dtDetalle.style.display="none";
      }
 
  }

  function onKey(obj){
  var frm = document.forms[0];
    if(event.keyCode==13){
      
      if (obj.name == "tcnDeduPorc" || obj.name == "tcnDeduMonto" || obj.name == "tcnDeduCant")
          selObj(obj, value);
      
      if (obj.name == "tcnPoliza"){
        //getPoliza();
        selObj(obj);
      }
      
      if (obj.name == "tctProveedor")
        buscarProveedor();
        
      if (obj.name == "tcnRed")
        getRed();      
        
      if (obj.name == "tcnProveedor"){
          ret = retValXml("../servlet/ProcesoValida?pntipoval=9&pncodclinic=" + obj.value);
          frm.tctProveedor.value = ret;
      }
    }
  }  
  
  function getPoliza()
  {
    var frm = document.forms[0];
    ret = retValXml("../servlet/ProcesoValida?pntipoval=6&pnpoliza=" + frm.tcnPoliza.value + "&pnramo=" + frm.tcnRamo.value);
    if (ret!=""){
      arr = ret.split("|");
      frm.tcnProducto.value=arr[0];
      frm.tctPoliza.value=arr[1];
      frm.tctProducto.value=arr[2];
      frm.hcnMoneda.value=arr[3];
      frm.tctMoneda.value=arr[4];
    }else{
      alert("El Contrato no existe o no está vigente");
      frm.tcnProducto.value="";
      frm.tctPoliza.value="";
      frm.tctProducto.value="";
      frm.hcnMoneda.value="";  
      frm.tctMoneda.value="";
    }
    
  }
 
   function getRed()
  {
    var frm = document.forms[0];
    var nramo = frm.tcnRamo.value;
    var nproducto = frm.tcnProducto.value;
    var nplan = frm.hcnPlan.value;    
    var nmodali = frm.lscModalidad.value;
    var ncobertu = frm.hcnCobertura.value;  
    var nconcepto = frm.lscConcepto.value;

    ret = retValXml("../servlet/ProcesoValida?pntipoval=7&pnramo=" + nramo + "&pnproducto=" + nproducto + "&pnplan=" + nplan + "&pnmodali=" + nmodali + "&pncobertu=" + ncobertu + "&pnconcepto=" + nconcepto);

    if (ret!=""){
      arr = ret.split("|");
      frm.tcnDeduCant.value=arr[0];
      frm.tcnDeduMonto.value=arr[1];
      frm.tcnDeduPorc.value=arr[2];
      frm.tcnCoaPorc.value=arr[3];
      if (<%=intRedBase%>==frm.tcnRed.value){        
          ActiveProceso(true);
      }else
          ActiveProceso(false);
    }    
  } 
  
  function buscarProveedor(){
    
    if (document.forms[0].tctProveedor.value==""){
        alert("Ingrese el nombre del Proveedor a buscar");
        document.forms[0].tctProveedor.focus();
        return;
    }else{
        dtProveedor.style.display="";
        frProveedor.document.forms[0].action="../general/Lista.jsp?nameframe=frProveedor&pstipo=prov&pscampo=descript&psdesc=" + document.forms[0].tctProveedor.value;
        frProveedor.document.forms[0].submit();
        
    }
  }
  
  function limpiar(tipo){
    var frm = document.forms[0];
    if (tipo == 1){
      frm.tcnPoliza.value ="";
      frm.tctPoliza.value ="";
      frm.tcnRed.value ="";
      frm.tcnProducto.value ="";
      frm.tctProducto.value ="";
      frm.tcdEfecto.value ="";
      frm.lscModalidad.value="0";
      frm.lscConcepto.value="0";      
      lstPlan.document.forms[0].lscPlan.value=0;
      lstCobertura.document.forms[0].lscCobertura.value="";
      frGridProveedor.location.href = "../mantenimiento/ListaProveedor.jsp";
      dtDetalle.style.display="none";
      tipo=2;
    }
    if (tipo == 2){
      frm.tcnProveedor.value ="";
      frm.tctProveedor.value ="";    
     if (frm.tcnRed.value != "<%=intRedBase%>"){ //Clnica Base
      frm.tcnDeduCant.value = "";
      frm.tcnDeduMonto.value = "";
      frm.tcnDeduPorc.value = "";
      frm.tcnCoaPorc.value = "";      

     }
    }
    
  }
  
 function loadForm(){
  alert("Los datos han sido procesados satisfactoriamente");
  verListado();
 }
 
 function verAlerta(coderror){
    if (coderror == -10)
      alert("La aplicación no se pudo registrar los datos. Consulte con el Administrador");
    else
    if (coderror == -1)
      alert("Error al registrar en tabla (Pol_Clinic). Consulte con el Administrador");
    else
    if (coderror == -2)
      alert("La clínica ha sido registrada anteriormente en la tabla (Pol_Clinic) para el Contrato. Elija otra clínica");
    else
    if (coderror == -3)
      alert("Error al quitar algunas clinicas de la tabla (Pol_Clinic). Consulte con el Administrador");
    else
    if (coderror == -4)
      alert("Los datos de la red no pueden ser modificados");
    else
    if (coderror == -5)
      alert("La fecha de efecto no es válida, existen registros con fecha posterior");
    else
      alert("Error inesperado. Consulte con el Administrador");
      

    //dtProceso.style.display="none";
    //dtEnviar.style.display="";
    
  }

  function editar(){
    dtDetalle.style.display="";
    document.forms[0].tctTitulo.value = "Modificando Clínica";
    document.forms[0].hctAcc.value="edita";
    if (<%=intRedBase%>==frm.tcnRed.value){        
          ActiveProceso(true);
    }else
          ActiveProceso(false);    
  }

  function registrar(){
  var frm = document.forms[0];
    if (!valcontrol())      
       return;
    dtDetalle.style.display="";
    document.forms[0].tctTitulo.value = "Nueva Clínica";
    getRed();
    verListado();
    frm.hctAcc.value="crea";
  }
  
  function eliminar(){
    
    if (!frGridProveedor.valida('ckcSel','chk'))
        return;  
    frGridProveedor.eliminar();    
    document.forms[0].hctAcc.value="borra";
    enviaDatos('borra');
    limpiar(2);
    dtDetalle.style.display="none";
  }
  

  
</script>
</html>
