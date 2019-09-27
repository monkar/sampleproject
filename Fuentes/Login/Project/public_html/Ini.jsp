<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.service.ParamNuevaMarcaService"%>
<%
String url;
url=request.getContextPath();
ParamNuevaMarcaService oNuevaMarcaService = new ParamNuevaMarcaService();
%>
<HTML>
<HEAD>
<TITLE>:: LA POSITIVA :: INTRANET</TITLE>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/> 
 <!-- <meta name="viewport" content="width=device-width, initial-scale=1"/> -->
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1"> 
<SCRIPT language=JavaScript>	

  var getBrowserInfo = function() {
    var ua= navigator.userAgent, tem, 
    M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
    if(/trident/i.test(M[1])){
        tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
        return 'IE '+(tem[1] || '');
    }
    if(M[1]=== 'Chrome'){
        tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
        if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
    }
    M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
    return M.join(' ');
};

	function window_onload() {
    

      
      var h = document.body.clientHeight;
      var divCab = 0;
      
      if(h>680){
        divCab = (h-680)/2;
        
        if(getBrowserInfo().indexOf("MSIE")){
          divCab = divCab-30;
        }
        
        document.getElementById("divCab").style.height = divCab +"px";
        document.getElementById("divLogin").style.paddingTop = divCab +"px";
        document.getElementById("divLoginLogo").style.top = (divCab+3) +"px";
      }
      var info= getBrowserInfo();
      if(info == "MSIE 7" || info == "MSIE 8"){
         var w = document.body.clientWidth;
         if(w <= 1024){
          document.getElementById("divLoginLogo").style.marginLeft = "-20px";
          document.getElementById("divPrincipalLogin").style.marginLeft ="0%";
         }else if(w < 1300){
          document.getElementById("divLoginLogo").style.marginLeft = "0%";
          document.getElementById("divPrincipalLogin").style.marginLeft = "5%";
         }
      }
      
	} 
	

</SCRIPT>


<META content="MSHTML 6.00.2800.1106" name=GENERATOR>
</HEAD>

<BODY language=javascript bgColor=#FFFFFF leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
<SCRIPT src="jscript/funciones.js?v=1.0.0.0" type=text/javascript></SCRIPT>  
<LINK rel=Stylesheet TYPE="text/css" href="styles/EstilosGenerales.css?v=1.0.0.0" type="text/css">
<LINK rel=Stylesheet TYPE="text/css" href="styles/CambioMarca.css?v=1.0.0.0" type="text/css">
<script src="jscript/library/jquery-1.9.1.min.js?v=1.0.0.0" type="text/javascript"/></script>
<script src="jscript/funciones_generales.js?v=1.0.0.0" type=text/javascript></script>
<!--[if lt IE 9]>  
<link href="styles/ie.css?v=1.0.0.0" rel="stylesheet" type="text/css" />    
<![endif]-->
<!--[if gte IE 9]>
<link href="styles/ie9.css?v=1.0.0.0" rel="stylesheet" type="text/css" />  
<![endif]--> 
<div id="divCab">&nbsp;</div>
<div class="login" id="divPrincipalLogin" >
<FORM method=post>

 <DIV align="center">
    <table border=0 cellspacing=0 cellpadding=0>
      <tr>
        <td style="width:50%;height:680px;">
          <div id="divLoginLogo" class="login-logo">
            <IMG src="<%=oNuevaMarcaService.getAndSetPathUrlLogo(url)%>" />
          </div>   
        </td>
        <td style="width:50%;height:680px;">
          <div id="divLogin" class="login-content" style="width:350px;">     
                  <div class="login-title" style="width:350px">
                    <p style="line-height:40px;">Sistema de </br> Información</p>                    
                  </div>
                  <div>
              <BR/>
               Bienvenido a nuestro Sistema de Información,<BR/> 
               para ingresar seleccione la IAFA a Ingresar<BR/> 
               y pulse en <label class="texto_general_medium">Aceptar</label>             
            </div>  
            <div>  
              <BR/>
              <!-- <table border=0 cellspacing=0 cellpadding=0>  
                <tr>
                  <td>--> 
                    <label>IAFA :</label>
                  <!-- </td> 
                  <td align="center">  -->
                    <select id="lscCompania" name="lscCompania" class="lp-select">
                      <option value="0" selected>--Seleccionar--</option>
                      <option value="LPG" >La Positiva Generales</option>
                      <option value="LPE" >La Positiva EPS</option>
                    </select>  
                  <!-- </td>
                </tr>
              </table> --> 
            </div>
            <div>
                    <BR/>      
                    <A id="btnAceptar" class="lq-btn">Aceptar</A>
            </div>    
          </div>
        </td>
      </tr>
    </table>
  </DIV>
 
</FORM>
</div>  
</BODY>  

<script type="text/javascript" src="jscript/jquery.js"></script>
<script type="text/javascript"> 
var links;
  $(document).ready(function(e){

     $.getJSON('config.json',function(data){
     // var posting = $.post("config.json");
     //posting.done(function(data){
     links = data;
      });

      /*VERTICAL ALIGN: CENTER*/
      var h = document.body.clientHeight;
      var divCab = 0;
      
      /*
      if(h>680){
        divCab = (h-680)/2;
        document.getElementById("divCab").style.height = divCab+"px";
        document.getElementById("divLogin").style.paddingTop = divCab+"px";
        document.getElementById("divLoginLogo").style.top = (divCab+3) +"px";
      }
      */
      
      //$("#lscCompania").on('change',function(e){
      $("#btnAceptar").on('click',function(e){
        var compania = $("#lscCompania").val();      
        if(compania == "LPG"){
          location.href = links.lpg;
        }else if(compania == "LPE")
        {
          location.href = links.lpe;
        }else
        {
         alert("Debe Seleccionar una IAFA");
        }
      });
  });
</script>

</html>
