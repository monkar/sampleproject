<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%

      /*Instanciando la clase GestorPolClinic,para acceder a los Datos yahirRivas 29FEB2012 11:29am*/    
    GestorPolClinic gestorPolClinic = new GestorPolClinic();
  
    Caso objCaso=new Caso();        

    if (session.getAttribute("NumeroCaso")!=null){
          objCaso = (Caso)session.getAttribute("NumeroCaso");
          System.out.println("Numero de caso Detalle Cliente :"+objCaso.getCaso());
    }

    Usuario usuario = null;
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }
    BeanList objLstCober = new BeanList();
    Cobertura objCobertura = null;
    double dblIgv = 0;
    
    String strContinuidad = Tool.getString(request.getParameter("scontinuidad"));
    
    int intRamo = Tool.parseInt(request.getParameter("hcnRamo"));
    
    String ramoSCTR = "N";
    
    if (intRamo == 80 || intRamo == 81)
        ramoSCTR = "S";    
        
    BeanList objLstClinicaCoberturaWebInx = new BeanList();
    Bean auxInx = null;
    String strClinica="";
    Bean bProveedor = null;
    int intCodCobertura=0;
    int intFlagValidaCoberturas=0;        
    int intNumReg = 0;
     
    synchronized(session)
    {
      if (session.getAttribute("ListaCobertura")!=null){
        objLstCober = (BeanList)session.getAttribute("ListaCobertura");
        dblIgv = Tool.reaIGV(2,"");
      }
    }    
    
    //Validamos si es un centro especializado
    if ((usuario.getIntIdRol() == Constante.NROLOPE) && (usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP)) {
        intFlagValidaCoberturas=1;
        strClinica = usuario.getStrWebServer();        
        bProveedor = Tabla.getProvedorIfxServ(strClinica);        
        //Recuperando coberturas, por clinicas
        objLstClinicaCoberturaWebInx = gestorPolClinic.getLstClinicaCoberturaWeb(Tool.parseInt(bProveedor.getString("2")),intCodCobertura,1,1,"1");        
    }    
    
    int intFlagValidaClinica = 0;
    
     if(usuario.getIntIdRol()== Constante.NROLEMISOR){
          intFlagValidaClinica = 1; //RQ2017-1848
        }
    
    
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
<form name="frmListaCliente" method="post">   
<input type="hidden" name="hcnCover" value=""/>
<input type="hidden" name="hctTipoaten" value="0"/>
<input type="hidden" name="hctCover" value="0"/>
<input type="hidden" name="hcnSelCover" value="0"/>
<input type="hidden" name="hcnGenCover" value="0"/>
<input type="hidden" name="hcnTipoAten" value="0"/>
<input type="hidden" name="hcnConceptoPago" value="0"/>
<input type="hidden" name="hcnTipoUsuario" value="0"/><!-- REQ 2011-xxxx BIT/FMG -->

          <%
            int cant = objLstCober.size();
            if (cant>0){
          %>
          <table cellSpacing="1" width="100%" class="2 table_principal">
            <tr style="border-bottom: 1px solid #FFFFFF"> 
              <th width="55.8858%" class="header" align="center"></th>      
              <th width="15.4255%" class="header" align="center">Deducible</th>
              <th width="26%" class="header" align="center"></th>        
            </tr>  
          </table>      
          <%}%>
          <table cellSpacing="1" width="100%"  class="2 table_principal gris_pares">
            <%
            int ncount = objLstCober.size();
            if (ncount>0){
            %>
            <tr>
              <th width="2%" height=30 class="header" align="center">&nbsp;#</th>
              <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>              
                  <th width="2%" class="header" align="center">&nbsp;</th>
              <%}%>
              <th width="25%" class="header" align="center">Cobertura</th>                      
              <th width="5%" class="header" align="center">Tipo Atención</th>
              <th width="10%" class="header" align="center">Concepto de Pago</th>
              <th width="10%" class="header" align="center">Tipo Deducible</th>
              <th width="5%" class="header" align="center">Dias</th>
              <th width="5%" class="header" align="center">Importe</th>
              <th width="5%" class="header" align="center">%</th>
              <th width="5%" class="header" align="center">%<BR/>Coaseguro</th>
              <th width="10%" class="header" align="center">Beneficio Máximo</th>
              <th width="5%" class="header" align="center">Beneficio Consumido</th>
              <th width="5%" class="header" align="center">Carencia (dias)</th>
            </tr>
            
            <%
              //Req 2011-0849
              boolean flagCobTintaya = true;
              int contador = 0;
              //Fin Req 2011-0849
              
              intNumReg = objLstCober.size();
              String classLastRow = "";
              
              for(int i=0;i<objLstCober.size();i++){
              
                classLastRow = objLstCober.getClassLastRow(i, intNumReg-1, "", "tr-nth-child-2n-1");  
                
                objCobertura = new Cobertura();
                objCobertura = (Cobertura)objLstCober.get(i);
                
                if (intFlagValidaCoberturas==1){
                    auxInx = gestorPolClinic.getClinicaCoberturaWeb(objLstClinicaCoberturaWebInx,objCobertura.getIntCoverGen());
                }

                if(((intFlagValidaCoberturas==0) && (objCobertura.getIntCover()!=-1) )  || ((intFlagValidaCoberturas==1) && (objCobertura.getIntCover()!=-1) && (auxInx!=null)))
                {
                //Req 2011-0849
                flagCobTintaya = true;
                if(usuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA || usuario.getIntCodGrupo()==Constante.NCODGRUPOJCOR)
                {
                  if(!objCobertura.getStrTipoAtencion().equals("AMB"))
                  {
                    flagCobTintaya = false;
                  }
                }
                if(flagCobTintaya)
                {
                //Fin Req 2011-0849
            %>
            <tr>
              <td class="row1 <%=classLastRow %>" align="center"><%=contador+1%></td>
              <%--<%if (usuario.getIntIdRol()==Constante.NROLOPE){%>
                  <%
                    //SSRS Se valida la condicion para la cobertura Chequeo Médico y para el concepto de pago Farmacia
                    //INI REQ 2011-xxxx BIT/FMG
                    if ((objCobertura.getIntConceptoPago() == 17 && usuario.getIntTipoUsuario() != 1) || objCobertura.getIntCoverGen()== 361){%>                    
                      <td class="row1" align="left">
                          &nbsp;
                      </td>
                  <%}else{%>
                      <td class="row1" align="left">                         
                         <input align=right class="TxtCombo" onclick="javascript:selCover(this,<%=i%>,<%=objCobertura.getIntCover()%>,'<%=objCobertura.getStrTipoAtencion()%>','<%=objCobertura.getIntCoverGen()%>','<%=objCobertura.getIntTipoAtencion()%>','<%=objCobertura.getIntConceptoPago()%>','<%=objCobertura.getIntPeridoCarencia()%>','<%=objCobertura.getIntPeriodoTrans()%>',<%=usuario.getIntTipoUsuario()%>);valBeneficioCons(<%=objCobertura.getStrBeneficioMax()%>,<%=objCobertura.getStrBeneficioCons()%>)" type="radio" name="opcCover" value="1"/>
                      </td>                    
                  <%}
                    //FIN REQ 2011-xxxx BIT/FMG
                 }
              %>--%>
              <%if (usuario.getIntIdRol()==Constante.NROLOPE || intFlagValidaClinica == 1 ){%>              
              <td class="row1 <%=classLastRow %>" align="center">                         
                  <input align=center class="TxtCombo" onclick="javascript:selCover(this,<%=i%>,<%=objCobertura.getIntCover()%>,'<%=objCobertura.getStrTipoAtencion()%>','<%=objCobertura.getIntCoverGen()%>','<%=objCobertura.getIntTipoAtencion()%>','<%=objCobertura.getIntConceptoPago()%>','<%=objCobertura.getIntPeridoCarencia()%>','<%=objCobertura.getIntPeriodoTrans()%>',<%=usuario.getIntTipoUsuario()%>);valBeneficioCons(<%=objCobertura.getStrBeneficioMax()%>,<%=objCobertura.getStrBeneficioCons()%>,<%=objCobertura.getStrCacalili()%>)" type="radio" name="opcCover" value="1"/>
              </td> 
              <%}%>
              <td class="row1 <%=classLastRow %>" align="left"><%=objCobertura.getStrNomCobertura()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCobertura.getStrTipoAtencion()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCobertura.getStrConceptoPago()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCobertura.getStrTipoDeducible()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="center"><%=objCobertura.getStrCantidad()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="right"><%=(objCobertura.getStrCacalili().equals("1")&& ramoSCTR.equals("S")?"0.00":Tool.toDecimal(Tool.parseDouble(objCobertura.getStrImpDeducible()),2))%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="right"><%=(objCobertura.getStrCacalili().equals("1")&& ramoSCTR.equals("S")?"0.00":objCobertura.getStrDeducible())%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="right"><%=(objCobertura.getStrCacalili().equals("1")&& ramoSCTR.equals("S")?"0.00":objCobertura.getStrCoaseguro())%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="right"><%=(objCobertura.getStrCacalili().equals("1")&& ramoSCTR.equals("S")?"Ilimitado":objCobertura.getStrBeneficioMax())%>&nbsp;</td>
              <td class="row1 <%=classLastRow %>" align="right"><%=objCobertura.getStrBeneficioCons()%>&nbsp;</td>
              <td class="row1 <%=classLastRow %> tr-td-last-child" align="center"><%=(strContinuidad.equals("S")?0:objCobertura.getIntPeridoCarencia())%>&nbsp;</td>                          
            </tr>
            <%
             contador++;
             }
              objCobertura = null;
                }   
            }%>
            <tr> 
              <td align="center" colspan=13 class="row4 tr-td-last-child">&nbsp;</td>
            </tr>               
            <%}else{%>
            <tr> 
              <td align="center" colspan=13 class="row1 tr-last-child tr-td-last-child"  style="font-family:arial;font-size:12px">No se encontró información de acuerdo a los parámetros ingresados</td>
            </tr>
            <%}%>
          </table>

</form>

<script type="text/javascript">

function selecciona(obj){
  frmp = parent.document.forms[0];
  parent.selObj(obj.name,obj.value);
}

function valBeneficioCons(BeneficioMax,BeneficioCons,cacalili){ 

  if (cacalili!=1){ // Apple
  if (BeneficioCons>BeneficioMax){
    var frm = document.forms[0];
    var excedido = redondear(parseFloat(BeneficioMax - BeneficioCons));
    alert("La cobertura ha excedido el monto Max. en : " +  -excedido );
      for(i=0;i<frm.opcCover.length;i++){
        if (frm.opcCover[i].checked==true){
           document.frmListaCliente.opcCover[i].checked = false;
           frm.hcnCover.value = "";
        }
      }
  }
  }
}

function selCover(obj, item, cover,tipoaten,covergen,codtipoaten,payconcep, carencuan, countday, tipousuario)
{ 

  var frm = document.forms[0];
  var frmp = parent.document.forms[0];
  if (obj.value ==1)
  {
    frm.hcnCover.value = cover;
    frm.hctTipoaten.value = tipoaten;
    frm.hcnSelCover.value = item;
    frm.hcnGenCover.value = covergen;  
    frm.hcnTipoAten.value = codtipoaten;  
    frm.hcnConceptoPago.value = payconcep;
    frm.hcnTipoUsuario.value = tipousuario; // REQ 2011-xxxx BIT/FMG
    // AVM : variable para la continuidad es el campo continuity
    // con Continuidad = 'S'
    // sin Continuidad = 'N'
    var strCont = frmp.hcnContinuidad.value.substring(0,1);    
    //SSRS Verificacion del periodo de carencia
    /*
        Exclusiones 
        Cobertura Emergencia Accidental
        Cobertura Emergencia Medica
        Fecha de Ingreso con inicio 02
    */

    if( covergen != <%=Constante.NCOVEREMACC%> && covergen != <%=Constante.NCOVEREMMED%>   && carencuan !=0 &&  parseInt(countday) <= parseInt(carencuan) && strCont!="S")
    {
        alert("La cobertura se encuentra en periodo de carencia.")
        //frmp.btnGenCod.disabled=true; // RQ2016-1713
        frmp.btnCartaA.disabled=true;
        frmp.btnCartaG.disabled=true;
        return;
    }
    else
    {
        policy =  parent.obtienePoliza();
     
        url="../servlet/ProcesoValida?pntipoval=14&pnpoliza=" + policy + "&pncoberturagen=" + covergen + "&pntipo=2";
        var res = retValXml(url);
                
        //Validando además para el ministerio de vivienda y la protectora        
        if(res!="|")
        {          
            if(<%=usuario.getIntCodGrupo()%>!= <%=Constante.NCODGRUPOMINV%>){
                if(<%=usuario.getIntCodGrupo()%>!= <%=Constante.NCODGRUPOPROT%>){
                      // RQ2016-1713
                      //if(res.indexOf("|BSB|")>-1)            
                          //frmp.btnGenCod.disabled=false;
                      //else
                          //frmp.btnGenCod.disabled=true;           
                      // RQ2016-1713
                      if(res.indexOf("|BCG|")>-1)
                          frmp.btnCartaG.disabled=false;
                      else
                          frmp.btnCartaG.disabled=true;
                          
                      if(res.indexOf("|BCA|")>-1)            
                          frmp.btnCartaA.disabled=false;
                      else
                          frmp.btnCartaA.disabled=true;   
          
                      if(res.indexOf("|BSS|")>-1){
                        // frmp.btnGenCod.disabled=false; // RQ2016-1713
                         frmp.hcnFlgVerImpresionSolBenef.value=1;
                      }else{
                         frmp.hcnFlgVerImpresionSolBenef.value=0;                        
                      }
                }            
            }
        }
        else
        {           
            //frmp.btnGenCod.disabled=false; // RQ2016-1713
            frmp.btnCartaA.disabled=false;
            frmp.btnCartaG.disabled=false;
        }
    }
    
    // INI - REQ 2011-xxxx BIT/FMG
    if(payconcep == 17 && tipousuario == 1)
    {
      // frmp.btnGenCod.disabled=false; // RQ2016-1713
      frmp.hcnFlgVerImpresionSolBenef.value=1;      
    }
    // FIN - REQ 2011-xxxx BIT/FMG
  }
}

</script>
</body>