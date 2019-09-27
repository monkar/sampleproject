<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%

     /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:28am*/ 
    GestorSolicitud gestorSolicitud = new GestorSolicitud();

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");           
          }  
    int intIdUsuario = usuario.getIntIdUsuario();
    int intFlgBuscar = Tool.parseInt(request.getParameter("psbuscar"));
    int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
    String strNroAutoriza = Tool.getString(request.getParameter("tctAutoriza"));
    String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String strClinica = Tool.getString(request.getParameter("lscClinica"));
    int intIdEstado = Tool.parseInt(request.getParameter("lscEstado"));
    int intGenCover = Tool.parseInt(request.getParameter("lscGenCover"));
    strClinica = request.getParameter("lscClinica");
    
    
    if(strClinica==null || strClinica.equals("")==true)
    {
        if (usuario.getIntIdRol() == Constante.NROLOPE) 
        {
            synchronized(session)
            {
              strClinica =  (String) session.getAttribute("STRWEBSERVER");
            }  
            if ("".equals(strClinica) || strClinica == null)
              strClinica = usuario.getStrWebServer();        
            intIdRol = 0;
        }
    }
    
    int intNumReg = 0;
    BeanList objLstSolicitud = new BeanList();
    
    if (usuario.getIntCodGrupo() != Constante.NCODGRUPOPROT){//La protectora
       objLstSolicitud = gestorSolicitud.getListaSolicitudBenIfx(intGenCover, strNroAutoriza,strAsegurado,strClinica,null,usuario.getIntCodGrupo());
    }
    
    
%>
<SCRIPT language="javascript">
<!--//PRT Funcion que permite seleccionar un registro.
//Parametros:
//obj nombre del objeto radio button
//gencover  codigo de cobertura
//obj.value numero de siniestro, value del radio button
//-->
function eligeSolicitud(obj,gencover){
    parent.document.frmExportaXML.strSolicitudElegida.value = obj.value;
    parent.document.frmExportaXML.pntransac.value = gencover;
}
</SCRIPT>
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
<form name="frmListaSolicitud" method="post">   
          <table width="100%"  class="2 table_principal gris_pares">
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <th width="10%" class="header" align="center">Nro. Sol.</th>                      
              <th width="45%" class="header" align="center">Paciente</th>
              <th width="15%" class="header" align="center">Tipo Solicitud</th>
              <th width="15%" class="header" align="center">Fecha Registro</th>             
            </tr>
            <%
            intNumReg = objLstSolicitud.size();
            String classLastRow = ""; 
            
            for(int i=0;i<intNumReg;i++){
            //objLstSolicitud.getBean(i).getString("SPOLIZA")
             classLastRow = objLstSolicitud.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="right">
              <!--//PRT INICIO DE TABLA//-->
                <table class="table_interior_opciones">
                  <tr>
                    <td class="row1">
                      <%=i+1%>
                    </td>
                    <!--//PRT elige un radio button y este valor es tomado por la ventana padre//-->
                    <td class="row1">
                      <input onclick="javascript:eligeSolicitud(this,'<%=objLstSolicitud.getBean(i).getString("sgencover")%>')" type='radio' name='rbtnSolicitud' value='<%=objLstSolicitud.getBean(i).getString("snrosiniestro")%>'>
                    </td>
                  </tr>
                </table>
              <!--//PRT FIN DE TABLA//-->
              </td>
              <td class="row1 <%=classLastRow %>" align="left">
                <!--<a href="javascript:selecciona('<%=objLstSolicitud.getBean(i).getString("snrosiniestro")%>','<%=objLstSolicitud.getBean(i).getString("scodcliente")%>',
                         '<%=objLstSolicitud.getBean(i).getString("spoliza")%>','<%=objLstSolicitud.getBean(i).getString("scertificado")%>','<%=objLstSolicitud.getBean(i).getString("scobertura")%>','<%=objLstSolicitud.getBean(i).getString("sfechareg")%>');">
                <%=objLstSolicitud.getBean(i).getString("snrosiniestro")%>
                </a>-->
                <a class="link_acciones" href="javascript:verAutoriza('<%=objLstSolicitud.getBean(i).getString("snrosiniestro")%>','<%=objLstSolicitud.getBean(i).getString("sgencover")%>','<%=objLstSolicitud.getBean(i).getString("spoliza")%>','<%=objLstSolicitud.getBean(i).getString("sdespago")%>',<%=usuario.getIntTipoUsuario()%>,<%=usuario.getIntIdRol()%>);">
                <%=objLstSolicitud.getBean(i).getString("snrosiniestro")%>
                </a>
              </td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objLstSolicitud.getBean(i).getString("sasegurado")%></td>
              <%
                  int intCoverG = Tool.parseInt(objLstSolicitud.getBean(i).getString("sgencover"));
                  String strTipo = null;
                  if(intCoverG==Constante.NGENCOVERODONT)
                      strTipo = Constante.SNOMCARODO;
                  else if(intCoverG==Constante.NGENCOVEREMEACC)
                      strTipo = Constante.SNOMCOVEMERACC;
                  else if(intCoverG==Constante.NGENCOVEREMEMED)
                      strTipo = Constante.SNOMCOVEMERMED;
                  else
                      strTipo = Constante.SNOMCARBEN;
              %>
              <td class="row1 <%=classLastRow %>" align="center"><%=strTipo%></td>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=objLstSolicitud.getBean(i).getString("sfechareg") + " " + objLstSolicitud.getBean(i).getString("shorareg")%></td>    
            </tr>
            <%
              }
            %>
            <tr>
              <td class="row1 tr-last-child tr-td-last-child" align="center" colspan=<%=(usuario.getIntIdRol()==Constante.NROLADM?7:6)%>&nbsp;</td>
            </tr>
          </table>
          
  <iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  

</form>

<script type="text/javascript">

  function LoadBody()
  {
  
  }
  
  function selecciona(siniestro,codCliente,poliza,certificado, cobertura,fecha)
  {
          document.forms[0].target="procSolicitud";
          document.forms[0].action="../servlet/ProcesoAtencion?proceso=6&nSiniestro=" + siniestro + "&tctCodCliente=" + codCliente + "&tcnPoliza=" + poliza + "&tcnCertif=" + certificado + "&sCobertura=" + cobertura + "&sFecha=" + fecha;
          document.forms[0].submit();     
  }
 
  function verAlerta(code){
      parent.verAlerta(code);
  }  

  function TerminaSession(){
     parent.TerminaSession();
  }
  
  function verAutoriza(siniestro,gencover,poliza,despago,tipousuario, rolusuario)
  {    
        var flgVerImpresionSolBenef = 0;
        var posF = 0;
          
        url="../servlet/ProcesoValida?pntipoval=14&pnpoliza=" + poliza + "&pncoberturagen=" + gencover + "&pntipo=2";
        var res = retValXml(url);
                
        if(res!="|")
        {  
            if(res.indexOf("|BSS|")>-1){
               flgVerImpresionSolBenef=1;
            }else{
               flgVerImpresionSolBenef=0;                        
            }            
        }
        
        // INI - REQ 2011-xxxx BIT/FMG
        despago = despago.toUpperCase();
        posF = despago.indexOf("FARMACIA");
        
        if(posF > -1)
          flgVerImpresionSolBenef = 1;
        // FIN - REQ 2011-xxxx BIT/FMG
        
        if (flgVerImpresionSolBenef == 0){        
          if(rolusuario == <%=Constante.NROPERFILBRK %>){
              if(gencover==217)
                  window.open('../consulta/SolicitudBenefOdontPDF.jsp?pnautoriza=' + siniestro);
              else 
                  window.open('../consulta/SolicitudBeneficioPDF.jsp?pnautoriza=' + siniestro);
          }else{
                  var resp=confirm("Confirme si va imprimir la Solicitud de Beneficio"); 
                  if (resp)
                  {
                      if(gencover==217)
                          window.open('../consulta/SolicitudBenefOdontPDF.jsp?pnautoriza=' + siniestro);
                      else 
                          window.open('../consulta/SolicitudBeneficioPDF.jsp?pnautoriza=' + siniestro);
                  }       
           }
        }else{
             alert('No esta permitido la impresión de la Solicitud');
        }      
  }  
</script>
</body>
