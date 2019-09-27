<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>

<% 

    GestorCorreo gestorCorreo = new GestorCorreo();
 
    int intFlgBuscar = Tool.parseInt(request.getParameter("flgBuscar"));
    int intZona =  (request.getParameter("lscZona")!=null?Tool.parseInt(request.getParameter("lscZona")):0);
    int intAlerta =  (request.getParameter("lscAlerta")!=null?Tool.parseInt(request.getParameter("lscAlerta")):0);
  
    int intNumReg = 0;
    int intPaginaActual = Tool.parseInt((request.getParameter("tcnpagina")!=null?request.getParameter("tcnpagina"):"1"));
    BeanList objList = null;
    
    objList = gestorCorreo.listCorreo(intZona, intAlerta);
    if(objList!=null && objList.size()>0)
    {
        intNumReg = objList.size();
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
  <form name="frmListaCorreo" method="post">   
    <TABLE class="2 form-table-controls" cellSpacing=0 width="100%" border=0 >    
        <%  
            if(objList!= null && objList.size()>0){
        %>
            <tr>
                  <td class="row5" width="60%" align=left>Nro.Reg. : <%=intNumReg%></td>
                  <td class="row5" width="40%" align=right >P�g.:
                    <select class="txtCombo lp-select-pag" name="lstPaginaActual" OnChange="javascript:CambiarPagina(this.value);">;
                     <% 
                       int intNumRegPag=Tool.parseInt(Constante.getConstBD("REG_PAG"));
                       int  NroPaginas=(intNumReg>intNumRegPag?(intNumReg%intNumRegPag>0?intNumReg/intNumRegPag+1:intNumReg/intNumRegPag):1);                              
                       if (NroPaginas<intPaginaActual)
                            intPaginaActual=1;
                       for(int i=1; i<=NroPaginas; i++)
                      { 
                          if(i==intPaginaActual)
                            out.println("<option selected value=" + i + ">" + i);
                          else
                            out.println("<option value=" + i + ">" + i);
                      }%>
                    </select>
                  </td>
            </tr>
            <tr>  
            <%
                int j = intPaginaActual * intNumRegPag - intNumRegPag;
            %>    
                <td class="row1" width="100%" align="left" colspan="2"> 
                    <table width="100%"  class="2 table_principal gris_pares table_pagination"> 
                        <tr>
                            <th class="header" align=center WIDTH=5%>#</th>
                            <!--<th class="header" align=center WIDTH=10%>Item</th>-->
                            <th class="header" align=center WIDTH=10%>Alerta</th>
                            <th class="header" align=center WIDTH=10%>Zona</th>
                            <th class="header" align=center WIDTH=15%>Cargo</th>
                            <th class="header" align=center WIDTH=15%>Apellidos y Nombres</th>
                            <th class="header" align=center WIDTH=15%>E-Mail</th>
                            <th class="header" align=center WIDTH=10%>Estado</th>
                            <th class="header" align=center WIDTH=5%>Editar</th>
                        <%    
                            for(int i=j;i<( (intPaginaActual * intNumRegPag)<=intNumReg?(intPaginaActual * intNumRegPag):intNumReg);i++){
                            Bean objBean = ((Bean)objList.get(i));
                        %>
                              <tr>
                                <td class="row1" align="center"><%=i+1%></td>
                                <!--<td class="row1" align="center"><%=objBean.getString("NIDSEC")%></td>-->
                                <td class="row1" align="center"><%=objBean.getString("ALERTADESC")%></td>
                                <td class="row1" align="center"><%=objBean.getString("ZONADESC")%></td>
                                <td class="row1" align="center"><%=objBean.getString("SCARGO")%></td>
                                <td class="row1" align="center"><%=objBean.getString("NOMBRES")%></td>
                                <td class="row1" align="center"><%=objBean.getString("SCORREO")%></td>
                                <td class="row1" align="center"><%=objBean.getString("ESTADO")%></td>
                                <td class="row1 tr-td-last-child" align="center">
                                    <A class="link_acciones" href="javascript:Editar('<%=objBean.getString("NIDSEC")%>','<%=objBean.getString("NIDALERTA")%>','<%=objBean.getString("NIDZONA")%>','<%=objBean.getString("SCARGO")%>','<%=objBean.getString("SAPELLIDO")%>','<%=objBean.getString("SNOMBRE")%>','<%=objBean.getString("SCORREO")%>','<%=objBean.getString("NESTADO")%>');">
                                         <IMG alt=Editar src="../images/Iconos/14x14-color/Iconos-14x14-color-12.png" border=0>
                                    </A>
                                </td>                                
                              </tr>
                        <%  
                            }
                        %>
                    </table>
                </td>
          </tr> 
          <%
          } else if(intFlgBuscar==1)
          {%>              
            <tr> 
                <td class="row5" align="center" style="FONT-SIZE: 10pt;" colspan="2">
                    No se encontraron configuraciones en la b�squeda
                </td>
            </tr> 
          <%}%>   
    </TABLE>    
               
  </form>
  
  <script type="text/javascript">
      function LoadBody()
      {
           var frmVar = document.forms[0]; 
           <%if(intNumReg>0){%>
              frmVar.lstPaginaActual.value = <%=intPaginaActual%>;
           <%}%>
      }
      
      function Editar(idsec, idalerta, idzona, scargo, sapellido, snombre, semail, idactivo)
      {
          parent.Editar(idsec, idalerta, idzona, scargo, sapellido, snombre, semail, idactivo); 
      }
      
      function CambiarPagina(pagina)
      {
          parent.Buscar(pagina);
      }
      
  </script>
  
  </body>
