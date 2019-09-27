<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>

<%
  
   String strControl =  (request.getParameter("scontrol")!=null?request.getParameter("scontrol"):"");
   String strSelecc = "";
   
   int intNumReg = 0;
%>
<HTML>
<HEAD>
</HEAD>
<BODY leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
    <table width="100%"  class="2" cellspacing="1" bgcolor=#ffffff cellpadding="1" border=0 id="tablaVehiculo">
        <tr>
            <td width="50%">
                <table width="100%" border="0" class="2 table_principal gris_pares" id="tblAreaControl">
                    <tr>
                        <th width="3%" class="header" align="center">#</th>
                        <th width="3%" class="header" align="center"><input alt="Check"  onclick="MarcarTodosChecks('chcControl');" class="TxtCombo" type="checkbox"></th>
                        <th width="65%" class="header" align="center">Control</th>
                    </tr>
                    <% 
                        BeanList lstOpcion = Tabla.getListControl();
                        if(lstOpcion!= null && lstOpcion.size()>0)
                        { 
                            intNumReg = lstOpcion.size();
                            String classLastRow = "";
                            
                            for(int i=0;i<lstOpcion.size();i++)
                            {
                                classLastRow = lstOpcion.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1"); 
                                if(strControl.equals("")==false)
                                {
                                    int intIndice = strControl.indexOf("|" + lstOpcion.getBean(i).getString("SCODCONTROL") + "|");
                                    strSelecc = (intIndice>-1?"checked":"");
                                }
                    %>
                        <tr>
                            <td width="3%" class="row1 <%=classLastRow %>" align="middle"><%=i+1%></td>
                            <td width="2%" class="row1 <%=classLastRow %>" align="middle">
                                <input alt="Check"  class="TxtCombo" name="chcControl" type="checkbox" value="<%=lstOpcion.getBean(i).getString("SCODCONTROL")%>" <%=strSelecc%>>
                            </td>
                            <td width="13%" class="row1 <%=classLastRow %> tr-td-last-child" align="left"><%=lstOpcion.getBean(i).getString("SDESCRIPCION")%></td>                      
                        </tr>
                    <%       }
                      }%>
                </table>
            </td>
        </tr>
    </table>
     <iframe name="frmproceso" width="0" height="0" frameborder="0" scrolling="no" src="../blank.html"></iframe>
</form>
<!--Fin Desarrollo-->
<script type="text/javascript">

function Grabar(policy, cover, covergen)                                                
{                                                                  
   var frmVar = document.forms[0]; 
  
   frmListado.action="../servlet/ProcesoMant?proceso=6&pnpoliza=" + policy + "&pncobertura=" + cover + "&pncoberturagen=" + covergen;
   frmListado.submit();
                                              
}   

function loadWindow(ncode)                                                
{ 
  parent.Regresar();
} 

function marcados()
{
    var i; 
    var count=0;
    var frmVar = document.forms[0];    
    var ckVar=eval('document.forms[0].' + 'chcControl');
   
    if(ckVar.length>0)                                             
    {    for(i=0;!(i>ckVar.length-1);i++)                            
         { 
            if(ckVar[i].checked)  
            { 
                count++;
            }
         }
    }
    else
    { 
        if (ckVar.checked) 
            count++;
    }
    
    if(count>=1) 
        return true;
    else 
    {  
        return false;
    }
}

</script>

</BODY>

</HTML>
