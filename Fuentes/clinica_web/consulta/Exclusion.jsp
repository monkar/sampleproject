<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>

<%
    int intNumReg = 0;

    BeanList objLstExcl = new BeanList();
    Exclusion objExclusion = null;
    synchronized(session)
    {
     if (session.getAttribute("ListaExclusion")!=null)
       objLstExcl = (BeanList)session.getAttribute("ListaExclusion");
    }
    String strNombreAseg = Tool.getString(request.getParameter("psnombre"));
%>
<html>
<head>
<title>SISTEMA DE ATENCION DE </title>
    <jsp:include page="../general/scripts.jsp" />  
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
<head>

</head>

<BODY leftMargin="0" rightMargin="0" topMargin="0" marginheight="0" marginwidth="0" class="Bodyid1siteid0" >
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
<form>
  <table cellSpacing="0" class="2 form-table-controls" border=0 width="100%" align="left" >
    <tr>
      <td>
        <table width="100%" cellspacing="0" cellpadding="0">
        <tr>
          <td class="row2" height="30" align=left>Exclusiones - <%=strNombreAseg%></td>
          <td class="row2" height="30" align=right>
          <a href="javascript:window.print();"><img align=right alt="Imprimir" src="../images/Iconos/14x14-color/Iconos-14x14-color-07.png" border="0"></a>
          </td>
        </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <fieldset class="row5 content_resumen">
        <legend class="titulo_campos_bold">
          Detalle
        </legend>  
          <table width="100%"  class="2 table_principal gris_pares">
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <th width="15%" class="header" align="center">Cod.Enfer</th>                      
              <th width="30%" class="header" align="center">Descripción</th>
              <th width="15%" class="header" align="center">Motivo de Exclusión</th>
              <th width="15%" class="header" align="center">Fecha Inicial Exclusión</th>
            </tr>
            <%
            intNumReg = objLstExcl.size();
            String classLastRow = "";            
            for(int i=0;i<objLstExcl.size();i++){
            
                classLastRow = objLstExcl.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");
                
                objExclusion = new Exclusion();
                objExclusion = (Exclusion)objLstExcl.get(i);
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objExclusion.getStrCodEnfermedad()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="left"><%=objExclusion.getStrDescripcion()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objExclusion.getStrMotivo()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=objExclusion.getStrFechaInicio()%>&nbsp;</td>
            </tr>
            <% 
              objExclusion = null;
            }%>
            <tr> 
              <td align="center" colspan=5 class="row4 tr-last-child tr-td-last-child">&nbsp;</td>
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
</body>
</html>
