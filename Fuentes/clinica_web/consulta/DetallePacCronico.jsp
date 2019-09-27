<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="java.io.*"%> 
<% 
  GestorClienteCronico clienteCronico = new GestorClienteCronico();
  Usuario usuario = null;
  
  synchronized(session)
  {
     usuario = (Usuario)session.getAttribute("USUARIO");     
  }  
   BeanList objLstPacCronico = new BeanList();
   EnfermedadCronica objEfermedadCronica = new EnfermedadCronica();
   String strClient = Tool.getString(request.getParameter("strClient"));
   
   System.out.println(strClient);
   objLstPacCronico = clienteCronico.lstEnfermedadCronica(strClient);
   System.out.println("size "+objLstPacCronico.size());
%>
<SCRIPT src="../jscript/funciones.js?v=1.0.0.1" type=text/javascript></SCRIPT>  
<LINK REL=Stylesheet TYPE="text/css" HREF="../styles/IntraStyles.css?v=1.0.0.1">
<BODY>
  <FORM>
  <div STYLE="height:200px;width:100%;overflow:auto;">
    <table height="200" width="500" border="0" class="2">
      <tr>
            <th width="2%" height=30 class="header" align="center"><b>&nbsp;#</b></th>
           <th width="25%" class="header" align="center"><b>Enfermedad</b></th>  
           <th width="25%" class="header" align="center"><b>Diagn&oacute;stico</b></th>
           <th width="10%" class="header" align="center"><b>Fec. Inscrip.</b></th>
      </tr>
      <% if (objLstPacCronico.size()>0){
            for (int i=0;i<objLstPacCronico.size();i++){
            objEfermedadCronica =  (EnfermedadCronica) objLstPacCronico.get(i); %>
          <tr>
              <td class="row1" align="center"><%=i+1%></td>
              <td class="row1" align="center"><%=objEfermedadCronica.getStrDescript()%></td>
              <td class="row1" align="center"><%=objEfermedadCronica.getStrState()%></td>
              <td class="row1" align="center"><%=((objEfermedadCronica.getFecEffecdate()==null)?"":""+objEfermedadCronica.getFecEffecdate())%></td>
          </tr>
         <!--<td class="row1" align="center"></td>-->
      <%  }
         }%>
       </table>
   </div>
  </FORM>
</BODY>
