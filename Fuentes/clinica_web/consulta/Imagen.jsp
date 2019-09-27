<!--Nuevo Objeto Imagen.jsp para mostrar las fotografias_________Cambio QNET 28/12/11-->
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%

   String directory = request.getSession().getServletContext().getRealPath("/imgasegurados/");   

    Usuario usuario = (Usuario)session.getAttribute("USUARIO");     
    
    Cliente objCliente = new Cliente();    
    String strCont = "";    
    String strRuta = "";
    String scadena = "";        
    String scadenasinfoto = "";        
    String stipo_archivo = ".jpg";  
    String snombre = "Foto";
    
    int intPolizam     = 0;
    int intCertifm     = 0; 
    String strCodAsegm = "";
    
    
    if (session.getAttribute("DatoCliente")!=null)
    {
        objCliente = (Cliente)session.getAttribute("DatoCliente");
        strCont    = objCliente.getStrContinuidadInx().substring(0);        
        
        scadena     = "";
        strRuta     = "";  
        strRuta     = objCliente.getStrRuta_Server_D().substring(0);        
        intPolizam  = objCliente.getIntPoliza();
        intCertifm  = objCliente.getIntCertificado();                       
        strCodAsegm = objCliente.getStrCodigo();
        scadena     = directory + intPolizam + "-" + intCertifm + "-" + strCodAsegm + stipo_archivo;           
        //scadena     = directory + intPolizam + "-" + intCertifm + stipo_archivo;           
    }    
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <title>untitled</title>
    <jsp:include page="../general/scripts.jsp" />    
  </head>  
  <body>     
  <form name="frMiImagen" method="post">  
  <img id="fotoimg" name="fotoimg" src="<%=scadena%>" width="150" height="189" align="center" onerror="this.onerror=''"/>      
  </form>
  </body>
  <script type="text/javascript">

  function inicio()
  {
    alert("inicio");
  }

  
</script>
</html>
