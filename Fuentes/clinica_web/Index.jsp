<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-- saved from url=(0838)http://intranet.lapositiva.com.pe:7777/sso/jsp/loginp.jsp?site2pstoretoken=v1.2~F87A991F~84419E193CFAF32B6C468A94CE66194DC68E02EEA94D9BAC7C6B3BDAF4203AC113326BA241C168E4E491E2D70FA81805C31A5F3D79E013F3DC7324F9E7556463DD9AEB5BB836E9A0A039AEEC19A2D09715A7905FA57ECE67CF3C28A52949519557CE9C675F0C35442B5A31C77214BDE7D1C0149A7570431CCB9E7B7C7A59EB66E90C04DC8CD77328C615B59FF3C130332C73F6975F67B0578FCA2AFF2AF2F26B4ADA5AB58045D0587757542E40BD9D74CEAC10F223417710BE16715A23B225115A67186B7F02A5FDD87CF069505CFBE3A74278BEDB4426C714DE4541A58498A5BD31A2265C4DF7902E82FCFF51119F328E10AB475D0C1BFF1847CC1D9B6D40F79010751DC9FC1D43A7D415CA757B08BFD461227A1A7CC0D4&p_error_code=&p_submit_url=http%3A%2F%2Fintranet.lapositiva.com.pe%3A7777%2Fsso%2Fauth&p_cancel_url=http%3A%2F%2Fintranet.lapositiva.com.pe%3A7778%2Fpls%2Fportal%2FPORTAL.home&ssousername= -->

<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.service.ParamNuevaMarcaService"%>
<%@ page import="com.clinica.utils.Tool"%>
<%
Tool.setContextPath(request.getContextPath());
/*
Inicio
- Esta Variable no está siendo utilizada  Yahir_Rivas  21FEB2012*/

String url;
url=request.getContextPath();
ParamNuevaMarcaService oNuevaMarcaService = new ParamNuevaMarcaService();

/*Fin*/

String mensaje="";
if (request.getParameter("mensaje")!=null)
    mensaje=request.getParameter("mensaje");
%>

<HTML><HEAD>
  <TITLE>:: LA POSITIVA :: INTRANET</title>
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
    
			document.forms[0].tctUsuario.select();
			document.forms[0].tctUsuario.focus();
      
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
	
	function enter()
	{
    if (event.keyCode == 13) 
      valida();
	}
</SCRIPT>

<META content="MSHTML 6.00.2800.1106" name=GENERATOR>
</HEAD>
<BODY language=javascript onkeypress=enter(); bgColor=#FFFFFF leftMargin=0 
  topMargin=0 onload="return window_onload()" marginheight="0" marginwidth="0" > 
<LINK rel=Stylesheet TYPE="text/css" href="styles/EstilosGenerales.css?v=1.0.0.1" type="text/css">
<LINK rel=Stylesheet TYPE="text/css" href="styles/CambioMarca.css?v=1.0.0.1" type="text/css">
<script src="jscript/library/jquery-1.9.1.min.js?v=1.0.0.1" type="text/javascript"/></script>
<script src="jscript/funciones_generales.js?v=1.0.0.1" type=text/javascript></script>  
<!--[if lt IE 9]>  
<link href="styles/ie.css?v=1.0.0.1" rel="stylesheet" type="text/css" />    
<![endif]-->
<!--[if gte IE 9]>
<link href="styles/ie9.css?v=1.0.0.1" rel="stylesheet" type="text/css" />  
<![endif]-->
 <div id="divCab">&nbsp;</div>
  <div class="login" id="divPrincipalLogin">
    <FORM method=post>
          <DIV align="center" >
          <table cellspacing=0 cellpadding=0 border=0>
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
                    para ingresar registre su Usuario y Contraseña<BR/> 
                    y pulse en <label class="texto_general_medium">Aceptar</label>       
                  </div>  
                  <div>   
                    <BR/> 
                    <label>Usuario :</label>
                    <INPUT size=15 name=tctUsuario value="" class="input_text_sed">
                    <BR/> 
                    <label>Contraseña :</label>
                    <INPUT type=password size=15 name=tctClave onKeyPress="enter();" value="" class="input_text_sed">       
                  </div>   
                  <div>
                    <BR/>      
                    <A id="btnAceptar" class="lq-btn" onclick="javascript:valida();">Aceptar</A>
                    <label class="login-alert"><%=mensaje%></label>
                  </div>   
                </div>
              </td>
            </tr>
          </table>
        </DIV>
      
      
                
    </FORM>
  </div>


</BODY>

<SCRIPT LANGUAGE=JAVASCRIPT>

 function ver_menu (page)
 {
    trNoValido.style.display = 'none';
    window.open(page,"_self",'menubar=no');
 }

 function ver_error()
 {
    trNoValido.style.display = '';
 }

 function valida()
 {    
    frm = document.forms[0];
    if (frm.tctUsuario.value=='' || frm.tctClave.value == '')
    {
        alert('Debe ingresar el login y el password.');
        return;
    }
    
    document.forms[0].target="_self";
    document.forms[0].action = "control/ProcesoAcceso?proceso=1";
    document.forms[0].submit();
    
 }

</SCRIPT>
</HTML>
