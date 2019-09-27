<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>

<%

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");  
    }  
    int intIdUsuario = usuario.getIntIdUsuario();
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));

    int intRamo = Tool.parseInt(request.getParameter("pnramo"));
    int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));
    int intCobertura = Tool.parseInt(request.getParameter("pncobertu"));
    int intPlan = Tool.parseInt(request.getParameter("pnplan"));
    int intModalidad = Tool.parseInt(request.getParameter("pnmodali"));
    int intRed = Tool.parseInt(request.getParameter("pnred"));
    int intConcep = Tool.parseInt(request.getParameter("pconcep")); 
    String strEfecto = Tool.getString(request.getParameter("pdefecto"));
    
    int intNumReg = 0;
    BeanList objLstPolCli = new BeanList();
    Pol_Clinic objPolcli = new Pol_Clinic();
        
      /* Se agrego el metodo GestorPolClinic yahirRivas 29FEB2012 10:54am*/  
     GestorPolClinic gestorPolClinic = new GestorPolClinic();  
        
    if (intFlgBuscar == 1 ){
      objLstPolCli = gestorPolClinic.lstPol_Clinic(intRamo,intPoliza,intCobertura,intModalidad,intPlan, intRed, strEfecto, intConcep);
      intNumReg = objLstPolCli.size();
    }
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <title>Mantenimiento </title>
    <jsp:include page="../general/scripts.jsp" />
  </head>
<body class=Bodyid1siteid0 leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
<form name="frmListaProveedor" method="post">   
  <table width="100%"  class="2 table_principal gris_pares" >
   <%if (intFlgBuscar == 1 && intNumReg>0 && intRed<=1){%>
   <tr>    
    <td align="center" colspan=11 class="row1">Los valores de la Red 1 se obtinen del producto</td>
   </tr>
   <%}%>
   <tr>
    <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
    <th width="6%" height=30 class="header" align="center">
      <input alt="Check" OnClick="MarcarTodosChecks('ckcSel');" class="TxtCombo" name="chcDelAll" type="checkbox">    
    </th>
    <th width="30%" class="header" align="center">Clinica</th>
    <th width="8%" class="header" align="center">Mod</th>
    <th width="8%" class="header" align="center">Concepto</th>
    <th width="5%" class="header" align="center">T.Dedu</th>
    <th width="5%" class="header" align="center">Dias</th>
    <th width="5%" class="header" align="center">Importe</th>
    <th width="5%" class="header" align="center">%</th>
    <th width="5%" class="header" align="center">%Coa</th>
    <th width="2%" class="header" align="center">Red</th>
   </tr>
   <%
   String classLastRow = "";  
   if (intNumReg>0){
   for(int i=0;i<intNumReg;i++){
      classLastRow = objLstPolCli.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");  
      objPolcli =  (Pol_Clinic) objLstPolCli.get(i);
   %>
   <tr>
    <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>    
    <td class="row1 <%=classLastRow %>" align="center">
    <input type=checkbox alt="Check" name='ckcSel' class="TxtCombo" value="<%=objPolcli.getIntCodClinic() + "," + objPolcli.getIntModalidad() + "," + objPolcli.getIntCover()  + "," + objPolcli.getIntRed()%>"/>
    <a class="link_acciones" href="javascript:editar(<%=i%>,<%=objPolcli.getIntCodClinic()%>)"><IMG alt="Modificar Clínica" src="../images/Iconos/14x14-color/Iconos-14x14-color-12.png" border=0></a>
    </td>
    <td class="row1 <%=classLastRow %>" align="left"><div id="dvDesClinica"><%=Tool.getString(objPolcli.getStrClinica())%></div></td>
    <td class="row1 <%=classLastRow %>" align="center"><%=Tool.getString(objPolcli.getStrModalidad())%></td>
    <td class="row1 <%=classLastRow %>" align="center"><%=Tool.getString(objPolcli.getStrConcepto())%></td>
    <td class="row1 <%=classLastRow %>" align="center"><%=Tool.getString(objPolcli.getStrTipoDedu())%></td>
    <td class="row1 <%=classLastRow %>" align="center"><div id="dvDedCant"><%=objPolcli.getIntDed_quanti()%></div></td>
    <td class="row1 <%=classLastRow %>" align="right"><div id="dvDedMonto"><%=objPolcli.getDblDed_amount()%></div></td>
    <td class="row1 <%=classLastRow %>" align="center"><div id="dvDedPorc"><%=objPolcli.getDblDed_percen()%></div></td>
    <td class="row1 <%=classLastRow %>" align="center"><div id="dvCoaPorc"><%=objPolcli.getDblIndem_rate()%></div></td>
    <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><div id="dvRed"><%=objPolcli.getIntRed()%></div>
     <div style="display:none" id="dvCodcli"><%=objPolcli.getIntCodClinic()%></div>
     <div style="display:none" id="dvCover"><%=objPolcli.getIntCover()%></div>
     <div style="display:none" id="dvModa"><%=objPolcli.getIntModalidad()%></div>
     <div style="display:none" id="dvEfecto"><%=objPolcli.getDEffecdate()%></div>
     <div style="display:none" id="dvLimit"><%=objPolcli.getDblLimit()%></div>
     <div style="display:none" id="dvConcep"><%=objPolcli.getIntPay_concep()%></div>
    </td>
  <%}}else{
    if (intFlgBuscar == 1){%>
    <td align="center" colspan=11 class="row1 <%=classLastRow %> tr-td-last-child">No se encontró información de acuerdo a los parámetros ingresados</td>
  <%}}%>
  </tr>
  </table>
</form> 
<script type="text/javascript">
  parent.document.forms[0].hcnNumCli.value = <%=intNumReg%>;
 if (<%=intNumReg%>>0){
  parent.document.forms[0].btcEliminar.disabled=false;  
  if (parent.document.forms[0].tcnRed.value!="" && parent.document.forms[0].tcnRed.value!=1)
      selecciona(1,'R');
  
 }else{
  parent.document.forms[0].btcEliminar.disabled=true;
 }

function selecciona(i,tipo)
 {
    var frmp = parent.document.forms[0];
    if (<%=intNumReg%>>1){    
    frmp.tcnDeduCant.value = dvDedCant[i].innerText;
    frmp.tcnDeduMonto.value = dvDedMonto[i].innerText;
    frmp.tcnDeduPorc.value = dvDedPorc[i].innerText;
    frmp.tcnCoaPorc.value = dvCoaPorc[i].innerText;
    frmp.tcnBenemax.value = dvLimit[i].innerText;
    if (tipo =='C'){
      frmp.lscModalidad.value = dvModa[i].innerText;
      frmp.lscConcepto.value = dvConcep[i].innerText;
      //frmp.tcdEfecto.value = dvEfecto[i].innerText;
      //parent.lstCobertura.document.forms[0].lscCobertura.value = dvCover[i].innerText;
      selOption(parent.lstCobertura.document.forms[0].lscCobertura,dvCover[i].innerText);
      frmp.tcnRed.value = dvRed[i].innerText;
      frmp.tcnProveedor.value = dvCodcli[i].innerText;
      frmp.tctProveedor.value = dvDesClinica[i].innerText
    }
    }else
      if (<%=intNumReg%>==1){
        frmp.tcnDeduCant.value = dvDedCant.innerText;
        frmp.tcnDeduMonto.value = dvDedMonto.innerText;
        frmp.tcnDeduPorc.value = dvDedPorc.innerText;
        frmp.tcnCoaPorc.value = dvCoaPorc.innerText;
        frmp.tcnBenemax.value = dvLimit.innerText;
        if (tipo =='C'){
          frmp.lscModalidad.value = dvModa.innerText;
          frmp.lscConcepto.value = dvConcep.innerText;
          //frmp.tcdEfecto.value = dvEfecto.innerText;
          //parent.lstCobertura.document.forms[0].lscCobertura.value = dvCover.innerText;
          selOption(parent.lstCobertura.document.forms[0].lscCobertura,dvCover.innerText);
          frmp.tcnRed.value = dvRed.innerText;
          frmp.tcnProveedor.value = dvCodcli.innerText;
          frmp.tctProveedor.value = dvDesClinica.innerText
         }
        }
 }
 
 function editar(i, code)
 {
    selecciona(i,'C')
    parent.editar();
 }

 function eliminar(){
  var frm = document.forms[0];
  var frmp = parent.document.forms[0];
  var obj=frm.ckcSel;  
  var cadcli ='';
  if (obj.length>1)  {
     	for(i=0;i<obj.length;i++){
            if(obj[i].checked){                    
             x=obj[i].value;
             if (cadcli!="") cadcli +="|";
                cadcli+=x;
            }
        }  
  }else{
   if(obj.checked)
     cadcli=obj.value;
  }
  
    frmp.hctCodsCli.value = cadcli;

 }
 
   function selOption(box,code){
    for(var i=0; i<box.options.length; i++)                    
    {                                                      
      a = box.options[i].value;
      arr = a.split("|");
      if(code == arr[0])  {
         box.options[i].selected = true;
         break;
      } 
    }
  }
</script> 
</body>
</html>
