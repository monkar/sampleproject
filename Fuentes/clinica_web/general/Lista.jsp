<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%    
  //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 29FEB2012  15:30pm
  
  GestorUsuario gestorUsuario = new GestorUsuario();  
  //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:31pm
  
  GestorClinica gestorClinica = new GestorClinica();

  String strTipo =  Tool.getString(request.getParameter("pstipo"));
%>
<BODY class=Bodyid1siteid0 leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
<form name="frmListado" method="post">   
<input type="hidden" name="hctTipo" value = "<%=strTipo%>">
<TABLE class="2 form-table-controls" cellSpacing=0 width="100%" border=0 id=dtBroker >
<tr>
<td align="left" valign="top" class=row5>
        <%if ("diag".equals(strTipo)){
              String strDesc = Tool.getString(request.getParameter("psdesc"));
        %>
              <select class="TxtCombo lp-select"  multiple=3 style="width:100%;height:50px"  name="lscDiag" onchange="selecciona(this);">
              
              <%if (!"".equals(strDesc))
                  out.println(Tool.listaCombo(Tabla.lstDiagnosticoIfx(strDesc),"illness","descript"));
              %>
              
              </select>
        <%}%>
        <%if ("prov".equals(strTipo)){
              String strDesc = Tool.getString(request.getParameter("psdesc"));
              String strCampo = Tool.getString(request.getParameter("pscampo"));
              strCampo = ("".equals(strCampo)?"nombre":strCampo);
        %>
              <select class="TxtCombo lp-select"  multiple= 3 style="width:100%"  name="lscProv" onchange="selecciona(this);">
              <%if (!"".equals(strDesc))
                  out.println(Tool.listaCombo(Tabla.lstProveedorIfx(strDesc),"codigo",strCampo));
              %>
              </select>
        <%}%>
        <%if ("plan".equals(strTipo)){
              int intRamo = Tool.parseInt(request.getParameter("pnramo"));
              int intProducto = Tool.parseInt(request.getParameter("pnproducto"));
              int intMoneda = Tool.parseInt(request.getParameter("pnmoneda"));
        %>
              <select class="TxtCombo lp-select" style="width:100%" name="lscPlan" onchange="selecciona(this);">
              <option value=0>--Seleccione--</option>
              <%if (intRamo>0 && intProducto>0)
                out.println(Tool.listaCombo(Tabla.lstPlanIfx(intRamo, intProducto, intMoneda),"modulec","descript"));
              %>
              </select>
        <%}%>
        <%if ("cobertura".equals(strTipo)){
              int intRamo = (request.getParameter("pnramo")!=null?Tool.parseInt(request.getParameter("pnramo")):0);
              int intProducto = (request.getParameter("pnproducto")!=null?Tool.parseInt(request.getParameter("pnproducto")):0);
              int intPlan = (request.getParameter("pnplan")!=null?Tool.parseInt(request.getParameter("pnplan")):0);
              int intMoneda = (request.getParameter("pnmoneda")!=null?Tool.parseInt(request.getParameter("pnmoneda")):0);
              String strCobertura = (request.getParameter("pncobertura")!=null?request.getParameter("pncobertura"):"");
        %>
              <select class="TxtCombo lp-select" style="width:100%" name="lscCobertura" onchange="selecciona(this);">
              <option value="">--Seleccione--</option>
              <%if (intRamo>0 && intProducto>0 && intPlan>0)
              {
                  BeanList lstLista = Tabla.lstCoberturaIfx(intRamo, intProducto, intPlan, intMoneda);         
                  for(int i=0;i<lstLista.size();i++)
                  {
                    out.print("<option value=" + lstLista.getBean(i).getString("cover") + "|" + lstLista.getBean(i).getString("cacalfix") + ">" + lstLista.getBean(i).getString("descript") + "</option>");
                  }
              }
              else
              {
                  
                  GestorPolClinic gestorPolClinic = new GestorPolClinic();
              
                  BeanList lstLista =  gestorPolClinic.getCoberturaPoliza(intProducto,intMoneda);         
                  if(lstLista!= null && lstLista.size()>0)
                  {
                      for(int i=0;i<lstLista.size();i++)
                      {  
                         out.print("<option value=" + lstLista.getBean(i).getString("2") + "|" + lstLista.getBean(i).getString("1") +  (strCobertura.equals(lstLista.getBean(i).getString("2"))?" selected ":"")  + ">" + lstLista.getBean(i).getString("3") + "</option>");
                      }
                  }
              }
              %>
              </select>
        <%}%>
        <%if ("usuario".equals(strTipo))
        {
              String strLogin=request.getParameter("sLogin");
              BeanList lista = gestorUsuario.getLstUsuarioIntranet(strLogin); 
               if (lista.size()>0){
        %>  
                  <select class="TxtCombo lp-select" multiple="multiple" style="width:100%" name="lscUsuario" onchange="seleccionaUsuario();">
                      <%=Tool.listaCombo(lista,"USUARIO_ID","NOMBRE")%>
                  </select>
        <%    }else{%>
                  <script> parent.aviso(); </script>
        <%    }
        }%>
        <%if ("clinica".equals(strTipo)){
              String strDesc = Tool.getString(request.getParameter("psdesc"));
        %>
              <select class="TxtCombo lp-select"  multiple= 3 style="width:100%"  name="lscProv" onchange="selecciona(this);">
              <%if (!"".equals(strDesc))
                  out.println( Tool.listaCombo(gestorClinica.lstClinicaIfx(strDesc),"2","3"));
              %>
              </select>
        <%}%>
        <%if ("concepto".equals(strTipo)){
              int intCobertura = (request.getParameter("pncobertura")!=null?Tool.parseInt(request.getParameter("pncobertura")):0);
              String strConcepto = (request.getParameter("pnconcepto")!=null?request.getParameter("pnconcepto"):"");
              BeanList lstLista = Tabla.lstConceptoPagoIfx(intCobertura);
        %>
              <select class="TxtCombo lp-select" style="width:100%" name="lscConceptoPago" onchange="selecciona(this);" >
              <option value="-1">--Seleccione--</option>
              <option value="0">Todos</option>
              <%
                  if(lstLista!= null && lstLista.size()>0)
                      out.println( Tool.listaComboSeleccionado(lstLista,"codigint","short_des",strConcepto));
              %>
              </select>
        <%}%>
        
</td>
</form>
</table>

<script type="text/javascript">
function selecciona(obj){
  frmp = parent.document.forms[0];
  parent.selObj(obj);
}

function seleccionaUsuario(){
      frmp=parent.document.forms[0];
      frm=document.forms[0];
      i=frm.lscUsuario.selectedIndex;
      frmp.hndIdUsuario.value=frm.lscUsuario.options[i].value;
      frmp.tctUsuario.value=frm.lscUsuario.options[i].text;
      frmp.tctIdUsuario.disabled=false;
      frmp.tctIdUsuario.value=frm.lscUsuario.options[i].value;
      frmp.tctIdUsuario.disabled=true;
      parent.dtUsuario.style.display="none";       
}
</script>
</body>