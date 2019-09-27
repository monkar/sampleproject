<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%
    int staCaso =  Tool.parseInt(TablaConfig.getTablaConfig("STA_CASO"));
    
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:30pm
    GestorClinica gestorClinica = new GestorClinica();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");  
    }
    //
    BeanList objLstCliente = new BeanList();
    Cliente objCliente = null;
    int intMax = 50;
    int intNumReg = 0;
    int intReaNumReg = 0;
    int intFlgBuscar = 0;
    boolean flag = true;
    String strTenServTinta = "";
    synchronized(session)
    {
      if (session.getAttribute("ListaCliente")!=null){
        objLstCliente = (BeanList)session.getAttribute("ListaCliente");
        System.out.println("objLstCliente :"+objLstCliente.size());
        intFlgBuscar = 1;
      }
      else{
      System.out.println("llego null"); 
      }
    }      
%>
<BODY onload="javascript:LoadBody();" class=Bodyid1siteid0 leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
<form name="frmListaCliente" method="post">   
          <table width="100%"  class="2 table_principal gris_pares">
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <th width="5%" class="header" align="center">Ramo</th>
              <%if(staCaso==1){%>
              <th width="5%" class="header" align="center">Caso / Declaraci&oacute;n de Accidente</th>
              <%}%>
              <th width="12%" class="header" align="center">Nombre</th>                        
              <!--<th width="5%" class="header" align="center"><b>Cod.cliente</b></th>-->
              <th width="5%" class="header" align="center">Fecha Afiliaci&oacute;n</th>
              <th width="5%" class="header" align="center">Tipo Declaraci&oacute;n</th>
              <th width="10%" class="header" align="center">IPRESS</th>
              <th width="12%" class="header" align="center">Contratante</th>
              <th width="5%" class="header" align="center">Fecha Ocurrencia</th>
              <th width="5%" class="header" align="center">Contrato</th>
              <th width="5%" class="header" align="center">Certificado</th>
              <th width="5%" class="header" align="center">Categor&iacute;a</th>
            </tr>
            <%
            intNumReg = objLstCliente.size();
            if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA)
            {
              synchronized(session)
              {
                 strTenServTinta = session.getAttribute("webServerTintaya").toString();
              }    
              flag = false;
            }
            else
            {
              flag = true;
            }
            
            int flgSobrepasaMax = 0;
            
            String classLastRow = "";
            for(int i=0;i<intNumReg;i++){
                
                classLastRow = objLstCliente.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1"); 
                
                objCliente = new Cliente();
                objCliente = (Cliente)objLstCliente.get(i);
              if (i < intMax) {
              
//              if( flag || gestorClinica.getPolClinica(strTenServTinta,objCliente.getIntPoliza()) ) -- Modificado para proyecto Apple
              if( flag || gestorClinica.getPolClinica(strTenServTinta,objCliente.getIntPoliza(),objCliente.getIntRamo()))
              {
              
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=intReaNumReg+1%></td>              
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrRamo()%></td><%--Agregado para proyecto apple--%>
              <%if(staCaso==1){%>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getIntCase()%></td><%--Agregado para proyecto apple--%>
              <%}%>
              <td class="row1" align="left">
                <%--<a href="javascript:selecciona('<%=objCliente.getStrCodigo()%>','<%=objCliente.getIntPoliza()%>','<%=objCliente.getIntCertificado()%>');"><%=objCliente.getStrNombreAseg()%> Modificado para el proyecto Apple--%>
                <a class="link_acciones" href="javascript:selecciona('<%=objCliente.getStrCodigo()%>','<%=objCliente.getIntPoliza()%>','<%=objCliente.getIntCertificado()%>','<%=objCliente.getIntRamo()%>','<%=objCliente.getIntCase()%>');"><%=objCliente.getStrNombreAseg()%>
                </a>
              </td>
              <!--<td class="row1" align="center"><%=objCliente.getStrCodigo()%></td>-->
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrIngres()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrCausa()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrClinic()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrContratante()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getStrOcurr()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getIntPoliza()%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCliente.getIntCertificado()%></td>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=(objCliente.getIntCategoria()==Constante.CATEGORIAVIP?"VIP":"NORMAL")%></td>
            </tr>
            <%
              intReaNumReg = intReaNumReg + 1;
              }
              }
              else
                {
                  flgSobrepasaMax = 1;
                  break;
                }
              }
              objCliente = null;
              synchronized(session)
              {
                 session.removeAttribute("ListaCliente");
              }   
            %>
            <tr>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="left">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <%if(staCaso==1){%>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <%}%>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child" align="center">&nbsp;</td>
              <td class="row1 tr-last-child tr-td-last-child" align="center">&nbsp;</td>
            </tr>
          </table>
          
  <iframe name="proccliente" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  

</form>

<script type="text/javascript">
  function LoadBody()
  {
    //if (<%=intReaNumReg%> > <%=intMax%>) {
    <%
      if(flgSobrepasaMax == 1) {
      
    %>
        alert('Especifique más el criterio de búsqueda, solo se muestran las ' + <%=intMax%> + ' primeras coincidencias');
    <%
      }
    %>

    <%if (intFlgBuscar == 1 && intReaNumReg ==0){%>
      alert('No se encontraron registros, comunicarse al 211-0211 (Lima) ó 0800-1-0800 (línea gratuita desde provincias).');
    <%}%>
    
    parent.ActiveProceso(false);
  }
  
  function selecciona(codCliente, poliza, certif, codRamo,intCase){
    var frm = document.forms[0];
      parent.document.forms[0].tcnPoliza.value = poliza;
      parent.document.forms[0].tcnCertif.value = certif;
      parent.document.forms[0].tctCodCliente.value = codCliente;      
      parent.ActivarFiltroClinica(false);
      parent.ActiveProceso(true);
      document.forms[0].target="proccliente";
      
      //document.forms[0].action="../servlet/ProcesoAtencion?proceso=2&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente; Modificado para proyecto Apple
      document.forms[0].action="../servlet/ProcesoAtencion?proceso=2&tcnPoliza=" + poliza + "&tcnCertif=" + certif + "&tctCodCliente=" + codCliente + "&tctCodRamo=" + codRamo + "&tctCase=" + intCase;
      document.forms[0].submit();
  }

  function verDetalle(){
      parent.verDetalle();
  }

  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }  
</script>
</body>
<%
   synchronized(session)
   {
      session.removeAttribute("ListaCobertura");
      session.removeAttribute("DatoCliente");  
   }      
%>