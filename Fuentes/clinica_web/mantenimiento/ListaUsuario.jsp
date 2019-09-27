<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>
<%  
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:00pm
    GestorUsuario gestorUsuario = new GestorUsuario();
   
    //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:34pm
    GestorClinica gestorClinica = new GestorClinica();
      
    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }  
    int intIdUsuario = usuario.getIntIdUsuario();
    
    int intFlgBuscar = (request.getParameter("flgBuscar")!=null?Tool.parseInt(request.getParameter("flgBuscar")):0);
    int intFlgExportar = (request.getParameter("flgExportar")!=null?Tool.parseInt(request.getParameter("flgExportar")):0);
    String strLogin = (request.getParameter("tctLogin")!=null?request.getParameter("tctLogin"):"");
    String strCodserver = (request.getParameter("lscClinica")!=null?request.getParameter("lscClinica"):"");
    int intCodOficina = (request.getParameter("lscOficina")!=null?Tool.parseInt(request.getParameter("lscOficina")):0);
    int intCodRol = (request.getParameter("lscRol")!=null?Tool.parseInt(request.getParameter("lscRol")):0);
    
    BeanList listUsuario = gestorUsuario.getLstUsuario(strLogin,strCodserver,intCodOficina,intCodRol);
    BeanList lstClinica = gestorClinica.lstClinica(intIdUsuario);
    int intNumReg=listUsuario.size();
  
    
    String strHtml = "<table width=\"100%\"  class=\"2 table_principal gris_pares\">" + 
              "<tr>" +
                "<th width=\"2%\" height=30 class=\"header\" align=\"center\">&nbsp;#</th>" +
                "<th width=\"10%\" class=\"header\" align=\"center\">Código</th>" +                      
                "<th width=\"10%\" class=\"header\" align=\"center\">Login</th>" +                       
                "<th width=\"15%\" class=\"header\" align=\"center\">Nombre</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Cod. Oficina</th>" +
                "<th width=\"15%\" class=\"header\" align=\"center\">Oficina</th>" +
                "<th width=\"35%\" class=\"header\" align=\"center\">Rol</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Server</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Cod. Server</th>" +
                "<th width=\"5%\" class=\"header\" align=\"center\">Desc. Server</th>" +
              "</tr>"; 
              
    Bean auxUsuario = null;
    String strCodClinica = "";
    String strDescClinica = "";
    
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
<form name="frmListaSolicitud" method="post">   
<TABLE class=2 cellSpacing=0 width="100%" border=0 >    
        <tr> 
            <%if (intFlgBuscar==1 && listUsuario.size()>0){%>
                <td class="row1" width="100%" align="center" > 
                    <table width="100%"  class="2 table_principal gris_pares"> 
                        <tr>
                            <th class="header" align=center WIDTH=2%>#</th>
                            <th class="header" align=center WIDTH=8%>Editar</th>
                            <th class="header" align=center WIDTH=8%>C&oacute;digo</th>
                            <th class="header" align="center" WIDTH=18%>Login</th>
                            <th class="header" align="center" >Nombre</th>
                            <th class="header" align="center" >Cod Oficina</th>
                            <th class="header" align="center" >Oficina</th>
                            <th class="header" align="center" >Rol</th>
                            <th class="header" align="center" >Server</th>
                            <th class="header" align="center" >Cod Server</th>
                            <th class="header" align="center" >Desc Server</th>
                        </tr>
                        <%
                            String classLastRow = "";                        
                            for(int i=0;i<listUsuario.size();i++)
                            {
                                classLastRow = listUsuario.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1"); 
                                
                                auxUsuario = listUsuario.getBean(i);
                                Bean auxClinica = null;
                                strCodClinica = "";
                                strDescClinica = "";

                                for(int j=0; j<lstClinica.size(); j++)
                                {
                                    auxClinica = lstClinica.getBean(j);
                                    if (auxClinica.getString("1").equals(auxUsuario.getString("SCODIGO")))
                                    {
                                        strCodClinica = auxClinica.getString("2");
                                        strDescClinica = auxClinica.getString("3");
                                        break;
                                    }
                                        
                                }
                                
                                
       
                        %>
                                            
                        <tr>
                          <td class="row1 <%=classLastRow %>" align="center"><%=i+1%></td>
                          <td class="row1 <%=classLastRow %>" align="center">
                              <A class="link_acciones" href="javascript:editarCliente('<%=auxUsuario.getString("NIDUSUARIO")%>');">
                                   <IMG alt=Editar src="../images/Iconos/14x14-color/Iconos-14x14-color-12.png" border=0>
                              </A>
                          </td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("NIDUSUARIO")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("SLOGIN")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("NOMBRE")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= (auxUsuario.getString("NCODOFICINA").equals("0")==false?auxUsuario.getString("NCODOFICINA"):"")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("DESCOFICINA")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("SROL")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%= auxUsuario.getString("SCODIGO")%></td>
                          <td class="row1 <%=classLastRow %>" align="center"><%=strCodClinica%></td>
                          <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=strDescClinica%></td>
                        </tr>
                        <%
                          strHtml = strHtml + 
                                    "<tr>" +   
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + (i+1) + "</td>" + 
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("NIDUSUARIO") + "</td>" + 
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("SLOGIN") + "</td>" +
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("NOMBRE") + "</td>" +
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + (auxUsuario.getString("NCODOFICINA").equals("0")==false?auxUsuario.getString("NCODOFICINA"):"") + "</td>" + 
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("DESCOFICINA") + "</td>" +
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("SROL") + "</td>" +
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + auxUsuario.getString("SCODIGO") + "</td>" + 
                                        "<td class=\"row1 classLastRow\" align=\"center\">" + strCodClinica + "</td>" + 
                                        "<td class=\"row1 classLastRow tr-td-last-child\" align=\"center\">" + strDescClinica + "</td>" + 
                                    "</tr>"; 
                          }
                          synchronized(session)
                          {
                            session.setAttribute("sTablaUsuario",strHtml);  
                          }  
                        %>
                    </table>
                </td>
            <%
              } else if(intFlgBuscar==1)
              {%>              
                <td class="row5" align="center" style="FONT-SIZE: 10pt;" colspan="12"><b>No se encontraron usuarios en la búsqueda</b></td>
               <%
              }%>
     </tr>   
</TABLE>    
  
<iframe name="procSolicitud" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>  

</form>
<script type="text/javascript">
  function LoadBody()
  {
     <%
     if(intFlgBuscar==1 && intNumReg>0)
        if (intFlgExportar==1)  
        {   
     %>
        parent.Exportar();
     <% }else{%> 
          <% 
            synchronized(session)
            {
              session.removeAttribute("sTablaUsuario");
            }  
          %>
     <%
      }
     %>    
  }
  
  function TerminaSession(){
     parent.TerminaSession();
  }
  
  function editarCliente(codigo)
  {
      parent.Editar(codigo);  
  }
  
</script>
</body>
