<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.service.GestorUsuario"%>
<%@ page import="com.clinica.beans.*"%>

<%     
     //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 01MAR2012 12:00pm
     GestorUsuario gestorUsuario = new GestorUsuario();
  
      int intIdUsuario = (request.getParameter("codUser")!=null?Tool.parseInt(request.getParameter("codUser")):0);
      BeanList listaFirma = new BeanList();
      String strFirmaReg="|";
      if(intIdUsuario!=-1)
      {
          listaFirma = gestorUsuario.getFirmaUsuario(intIdUsuario);
             
          for(int i=0; i<listaFirma.size();i++)
          {
             strFirmaReg =  strFirmaReg + listaFirma.getBean(i).getString("NIDTIPOSOLICITUD") + "|";
          }
      }    
      
      int intNumReg = 0;
%>
<html>
<head>
<title>Formulario</title>
    <jsp:include page="../general/scripts.jsp" />  
<script type="text/javascript">
    function insertaFila()
    {
        var frm = document.forms[0];
        
        if(frm.lscTipoSol.value==0)
        {
            alert("Seleccione un valor");
            return false;
        }
        
        if(frm.lscOrden.value==0)
        {
            alert("Seleccione un valor");
            return false;
        }
        
        if(validaConfiguracion()==true)
        {
            var frm = document.forms[0];
                    
            oRow = tblFirma.insertRow(tblFirma.rows.length);
            nfil=tblFirma.rows.length-2;
            f = new Array(nfil);
            for(var j=0;j<tblFirma.rows.length;j++)
              f[j]=tblFirma.rows.item(j).getAttribute("item");
            f.sort();
            if (f[nfil-1]>0)
                nfil=f[nfil-1];
            nfil = nfil+1;
            oRow.setAttribute("item",nfil);
        
        
            var oCell= oRow.insertCell();
                 oCell.className="row1";
                 oCell.align="left";
                 oCell.innerHTML="<input name='hcnIdTipoSol' type='hidden' value='" + frm.lscTipoSol.options[frm.lscTipoSol.selectedIndex].value + "'>" + frm.lscTipoSol.options[frm.lscTipoSol.selectedIndex].text;
            
            var oCell= oRow.insertCell();
                 oCell.className="row1";
                 oCell.align="center";
                 oCell.innerHTML="<input name='hcnIdOrden' type='hidden' value='" +  frm.lscOrden.options[frm.lscOrden.selectedIndex].value + "'>" +  frm.lscOrden.options[frm.lscOrden.selectedIndex].value;
               
            var oCell= oRow.insertCell();
                 oCell.className="row1";
                 oCell.align="center";
                 oCell.innerHTML="<a href='javascript:deleteFila(" + nfil + ");'><img alt='Eliminar Categoria' src='../images/Iconos/14x14-color/Iconos-14x14-color-45.png' border='0'><//a>";
            frm.hndCantFirma.value = (frm.hndCantFirma.value * 1) + 1;   
        }
        else
        {
            alert("El tipo de solicitud ya se encuentra registrado")
        }
    }
    
    function deleteFila(index) 
    {
       for(var j=1;j<tblFirma.rows.length;j++)
         {
             if (tblFirma.rows.item(j).getAttribute("item")==index){
                document.getElementById('tblFirma').deleteRow(j);
                break;
             }
         }
       var frm = document.forms[0];
       frm.hndCantFirma.value = (frm.hndCantFirma.value * 1) - 1;               
    }
    
    function deleteTabla() 
    {
        for(var j=1;j<tblFirma.rows.length;j++)
          document.getElementById('tblFirma').deleteRow(j);
        var frm = document.forms[0];
        frm.hndCantFirma.value = 0;
        
        frm.lscTipoSol.value=0;
        frm.lscOrden.value=0;
    }
    
    function deleteFilaReg(index,tiposol) 
    {
   
       var resp = confirm("Se va a borrar una configuración de firmas para la oficina asociada. ¿Está seguro de continuar?");
       if(resp)
       {
          for(var j=1;j<tblFirma.rows.length;j++)
          {
             if (tblFirma.rows.item(j).getAttribute("indice")==index)
             {
             
                document.getElementById('tblFirma').deleteRow(j);
                break;
             }
          }
          var frm = document.forms[0];
          frm.sFirmaRegDel.value = frm.sFirmaRegDel.value + "|" + tiposol;
          frm.hndCantFirmaDel.value = (frm.hndCantFirmaDel.value * 1) + 1;  
       }
       
    }
     
    function validaConfiguracion()
    {
        var frm = document.forms[0];

        var firmaReg = "" + frm.sFirmaReg.value;
        var firmaRegDel = "" + frm.sFirmaRegDel.value;
        
        var nCantFirma = frm.hndCantFirma.value;
       
        var nuevoTipoSol = frm.lscTipoSol.value;
     
        var encontrado = false;
        var encontrado1 = false;
        
        if(nCantFirma>1)
        {
            var tipoSolicitud=frm.hcnIdTipoSol;
            var contFirma = tipoSolicitud.length;   
            
            for(i=0;i<contFirma;i++)
            {
                var codTipoSol = tipoSolicitud[i].value;
                encontrado = false;
                if (codTipoSol == nuevoTipoSol)
                {
                    encontrado=true;
                    break;
                }
            }
            
            encontrado1 = false;
            var auxcadena = "|" + nuevoTipoSol + "|" 
            var indice = firmaReg.indexOf(auxcadena);
            var indice1 = firmaRegDel.indexOf(auxcadena);
            
            if (indice>=0 && indice1==-1)
            {
                encontrado1=true;
            }  
         }
         else  
         {
              if(nCantFirma==1)
              {
                  var tipoSolicitud=frm.hcnIdTipoSol;
                  codTipoSol = tipoSolicitud.value;
                  encontrado = false;
                  if (codTipoSol == nuevoTipoSol)
                  {
                      encontrado=true;
                  }
              }
              
              encontrado1 = false;
              var auxcadena = "|" + nuevoTipoSol + "|";
              var indice = firmaReg.indexOf(auxcadena);
              var indice1 = firmaRegDel.indexOf(auxcadena);
              
              if (indice>=0 && indice1==-1)
              {
                  encontrado1=true;
              }
         }

        if (encontrado==true || encontrado1==true)
            return false;
        return true;
    }
    
    
    function obtieneDatos() 
    {
    
      
      var frm = document.forms[0];
      var cadena="";
    
      var nCantFirma = (frm.hndCantFirma.value * 1);
    
    
      if(nCantFirma>1)
      {
         
          var tipoSolicitud=frm.hcnIdTipoSol;
          var orden=frm.hcnIdOrden;
        
          var contFirma = tipoSolicitud.length;   
        
          for(i=0;i<contFirma;i++)
          {
              var codTipoSol = tipoSolicitud[i].value;
              var codOrden = orden[i].value;
             
              cadena+= codTipoSol  + "|" + codOrden;
             
              if(i<contFirma-1)
                  cadena+= "-";
          }          
       }
       else if(nCantFirma==1) 
       {
           
            cadena+= frm.hcnIdTipoSol.value + "|" + frm.hcnIdOrden.value;
       }
       return cadena;
    }
    
    function obtieneDatosDel() 
    {
        var frm = document.forms[0];
        return frm.sFirmaRegDel.value;
    }
    
    function getCantFirma(tipo)
    {
        var frm = document.forms[0];
        
        if(tipo==1)
        {
            return frm.hndCantFirma.value;
        }
        else
        {
            return (frm.hndCantFirma.value * 1) + (frm.hndCantFirmaIni.value * 1) - (frm.hndCantFirmaDel.value * 1);
        }
    }
    
    
</script>
</head>
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
<input name="hndCantFirma" type="hidden" value="0">
<input name="sFirmaReg" type="hidden" value="<%=strFirmaReg%>">
<input name="sFirmaRegDel" type="hidden" value="">
<input name="hndCantFirmaDel" type="hidden" value="0">
<input name="hndCantFirmaIni" value="<%=listaFirma.size()%>"  type="hidden">

<TABLE class="2" cellSpacing=0 width="100%" border=0 >   
    <tr>
          <td>
              <fieldset class="row5 content_resumen">
              <table cellSpacing="1"  border=0 class="form-table-controls">
                  <tr>
                      <td class="row1" width="13%">
                          Tipo Solicitud :&nbsp;
                      </td>
                      <td class="row1" width="16%">
                          <select class="TxtCombo lp-select" style="width:88%" name="lscTipoSol">
                              <option value=0>--Seleccione--</option>
                              <%
                                BeanList objLista = new BeanList();
                                objLista = Tool.obtieneLista("SELECT NIDTIPOSOLICITUD, SNOMBRE FROM PTBLTIPO_SOLICITUD WHERE NFLGACTIVO=1 AND NFLGBANDEJA=1","");
                                out.println(Tool.listaCombo(objLista,"NIDTIPOSOLICITUD","SNOMBRE"));
                              %>
                          </select> 
                      </td>
                      <td class="row1" width="5%">
                          Orden :&nbsp;  
                      </td>
                      <td class="row1">
                          <select class="TxtCombo lp-select" style="width:20%" name="lscOrden">
                              <option value=0>--Selecione--</option>
                              <option value=1>1</option>
                              <option value=2>2</option>
                          </select>
                          &nbsp;&nbsp;
                          <a href='javascript:insertaFila();'><img alt='' src='../images/Iconos/14x14-color/Iconos-14x14-color-44.png' border='0'></a>                          
                      </td>
                  </tr>
                  <tr>
                      <td class="row1" width="13%">&nbsp;</td>
                      <td class="row1" colspan="3">
                          <table id="tblFirma" class="2 table_principal gris_pares" cellspacing="1" bgcolor=#ffffff cellpadding="1" border=0 style="FONT-SIZE: 12px; FONT-FAMILY: arial">
                              <tr>
                                  <th class="header" align="center" >Tipo Solicitud</th>
                                  <th class="header" align="center" >Orden</th>
                                  <th class="header" align="center" ></th> 
                              </tr>
                              <%  
                                  intNumReg = listaFirma.size();
                                  String classLastRow = "";
                                  
                                  for(int i=0; i<listaFirma.size(); i++)
                                  { 
                                      classLastRow = listaFirma.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1"); 
                                      
                                      Bean aux = listaFirma.getBean(i);
                              %>
                                  <tr id="tbFila" indice=<%=i+1%>>
                                      <td class="row1 <%=classLastRow %>" align="left">
                                          <%=aux.getString("SNOMBRE")%>
                                      </td>
                                      <td class="row1 <%=classLastRow %>" align="center">
                                          <%=aux.getString("NORDEN")%>
                                      </td>
                                      <td class="row1 <%=classLastRow %> tr-td-last-child" align="center">&nbsp;
                                          <a class="link_acciones" href='javascript:deleteFilaReg(<%=i+1%>,<%=aux.getString("NIDTIPOSOLICITUD")%>);'><img alt='Eliminar Categoria' src='../images/Iconos/14x14-color/Iconos-14x14-color-45.png' border='0'></a>
                                      </td>
                                  </tr>
                              <%    
                                  }
                              %>
                          </table>
                      </td>
                  </tr>
              </table>
          </td>
      </tr>  
</TABLE>
</form>
<script type="text/javascript">
