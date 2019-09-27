<!--Nuevo Objeto CargaArchivo.jsp para adicionar las fotografias_________Cambio QNET 28/12/11-->
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page language="java" import="javazoom.upload.*,java.util.*,java.io.*" %>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<% String stipo_archivo     = ""; %>
<% String snombre           = "Foto"; %>
<% int intPoliza            = 0; %>
<% int intCertificado       = 0; %>
<% String sPolizax          = "00000";%>
<% String sCertifx          = "00000";%>   
<% String strCodAseg        = ""; %>
<% boolean createsubfolders = true; %>
<% boolean allowresume      = true; %>
<% boolean allowoverwrite   = true; %>
<% String encoding          = "ISO-8859-1"; %>
<% boolean keepalive        = false; %>
<% double aleatorio          = 0; %>   
<% 

    Cliente objCliente = new Cliente();       
    if (session.getAttribute("DatoCliente")!=null)
    {       
       intPoliza      = 0;
       intCertificado = 0;   
       strCodAseg     = ""; 
       objCliente     = (Cliente)session.getAttribute("DatoCliente");       
       intPoliza      = objCliente.getIntPoliza();
       intCertificado = objCliente.getIntCertificado();
       strCodAseg     = objCliente.getStrCodigo();
       stipo_archivo  = ".jpg";         
   }
%>

<%
 String directory = request.getSession().getServletContext().getRealPath("/imgasegurados/");
   String tmpdirectory = request.getSession().getServletContext().getRealPath("/imgasegurados/tmp");         
   String sArchivo = request.getSession().getServletContext().getRealPath("/imgasegurados/"); 
   String scadena = objCliente.getStrRuta_Server_D().substring(0) + sPolizax + sCertifx + stipo_archivo;  
%>

<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
  <jsp:setProperty name="upBean" property="folderstore" value="<%= directory %>" />
  <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.CFUPARSER %>"/>
  <jsp:setProperty name="upBean" property="parsertmpdir" value="<%= tmpdirectory %>"/>  
  <jsp:setProperty name="upBean" property="overwrite" value="<%= allowoverwrite %>"/>
  <jsp:setProperty name="upBean" property="dump" value="true"/>  
</jsp:useBean>
<!--<script>reloadImg("fotoimg");</script>-->
<%
  //request.setCharacterEncoding(encoding);
  //response.setContentType("text/html; charset="+encoding);
  String method = request.getMethod();
  // Head processing to support resume and overwrite features.
  if (method.equalsIgnoreCase("head"))
  {
    String filename = request.getHeader("relativefilename");
    if (filename == null) filename = request.getHeader("filename");
    if (filename!=null)
    {
    	if (keepalive == false) response.setHeader("Connection","close");
    	String account = request.getHeader("account");
   	if (account == null) account="";
    	else if (!account.startsWith("/")) account = "/"+account;
    	//File fhead = new File(directory+account+"/"+filename);
      File fhead = new File(directory+account+"/"+filename);
    	if (fhead.exists())
    	{
    	   response.setHeader("size", String.valueOf(fhead.length()));
    	   String checksum = request.getHeader("checksum");
    	   if ((checksum != null) && (checksum.equalsIgnoreCase("crc")))
    	   {
		long crc = upBean.computeCRC32(fhead,-1);
		if (crc != -1) response.setHeader("checksum", String.valueOf(crc));
    	   }
    	   else if ((checksum != null) && (checksum.equalsIgnoreCase("md5")))
    	   {
		String md5 = upBean.hexDump(upBean.computeMD5(fhead,-1)).toLowerCase();
		if ((md5 != null) && (!md5.equals(""))) response.setHeader("checksum", md5);
    	   }
    	}
    	else response.sendError(HttpServletResponse.SC_NOT_FOUND);
       return;
    }
  }
%>
<html>
<head>

<script type="text/javascript">
  function validar(obj){
      missinginfo = "";
      if (obj.value == "") {
      missinginfo += "\n     -  Nombre";
      }
      if (missinginfo != "") {
      missinginfo ="Ingrese la ruta de la imagen a seleccionar!";
      alert(missinginfo);
      return false;
      }
      else return true;
      }         
      var flag=false;
      function cambio()
      {
          if(flag)
          {
              document.getElementById("dvi").style.display="none";
              flag=false;
          }
          else
          {
              document.getElementById("dvi").style.display="block";
              flag=true;
          }
      }
      
  function reloadImg(id) {
         var obj = document.getElementById(id);
         var src = obj.src;
         var pos = src.indexOf('?');
         if (pos >= 0) {
            src = src.substr(0, pos);
         }
         var date = new Date();
         obj.src = src + '?v=' + date.getTime();
         return false;
      }

      
function comprueba_extension(formulario, archivo) { 
   extensiones_permitidas = new Array(".jpg"); 
   mierror = ""; 
   if (!archivo) { 
      //Si no tengo archivo, es que no se ha seleccionado un archivo en el formulario 
       mierror = "No has seleccionado ningún archivo"; 
   }else{ 
      //recupero la extensión de este nombre de archivo 
      extension = (archivo.substring(archivo.lastIndexOf("."))).toLowerCase(); 
      //compruebo si la extensión está entre las permitidas 
      permitida = false; 
      for (var i = 0; i < extensiones_permitidas.length; i++) { 
         if (extensiones_permitidas[i] == extension) { 
         permitida = true; 
         break; 
         } 
      } 
      if (!permitida) { 
         mierror = "Comprueba la extensión del archivo a subir. \nSólo se pueden subir archivos con extensiones: " + extensiones_permitidas.join(); 
       }else{ 
         return true; 
       } 
   } 
   alert (mierror); 
   return false; 
} 
      
</script>

<title>Adjuntar Archivo</title>
    <jsp:include page="../general/scripts.jsp" />
<style TYPE="text/css">
.body
{
margin-top:0px;
padding-top:0px;
}
<!--
.style1 {
	font-size: 15px;
	font-family: Verdana;
}
-->

</style>
<meta http-equiv="Content-Type" content="text/html; charset=<%= encoding %>">
</head>
<body leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0">
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
<%
if (MultipartFormDataRequest.isMultipartFormData(request)) {  
   
    MultipartFormDataRequest mrequest = null;

    try {
        mrequest = new MultipartFormDataRequest(request,
            null,
            -1,
            MultipartFormDataRequest.CFUPARSER,
            encoding,
            allowresume);
            
            String todo   = null;
            if (mrequest != null) {
                todo = mrequest.getParameter("todo");
             }          
             if ((todo != null) && (todo.equalsIgnoreCase("upload"))) {
                    Hashtable files = mrequest.getFiles();
                    if ((files != null) && (!files.isEmpty())) {                   
                         String archivo = "";
                         //archivo = intPoliza + "-" + intCertificado + stipo_archivo;                                     
                         archivo = intPoliza + "-" + intCertificado + "-" + strCodAseg + stipo_archivo;                                     
                         String strRuta = directory + archivo;                            
                         ((UploadFile) mrequest.getFiles().get("uploadfile")).setFileName(archivo);                  
                         UploadFile file = (UploadFile) files.get("uploadfile");      
                         
                         if (file != null) {
                            //String msg = "El archivo: " + file.getFileName() + " se subio correctamente";                            
                         }       
                         upBean.store(mrequest, "uploadfile");                         
                         response.sendRedirect("../consulta/CargaArchivo.jsp");
                         } else {
                          out.println("Archivos no subidos");
                         }
                     } else {
                       out.println("<BR> todo=" + todo);
                     }
    }
    catch (Exception e) 
    {
            out.println("Archivos no ejecutado");
            e.printStackTrace();
            out.println(e.getMessage());
    }           
}  

   
   
   
   
    Usuario usuario = (Usuario)session.getAttribute("USUARIO");         
    String strCont    = "";    
    String strRuta    = "";
    String strRuta1   = "";    
    String strCodAsem = "";
    int intPolizam    = 0;
    int intCertifm    = 0;    
    
    if (session.getAttribute("DatoCliente")!=null)
    {
        objCliente = (Cliente)session.getAttribute("DatoCliente");
        strCont    = objCliente.getStrContinuidadInx().substring(0);                
        scadena    = "";  
        strRuta    = "";
        intPolizam = 0;
        intCertifm = 0;
        strCodAseg = "";           
        strRuta    = objCliente.getStrRuta_Server_D().substring(0);               
        intPolizam = objCliente.getIntPoliza();
        intCertifm = objCliente.getIntCertificado();                                
        strCodAsem = objCliente.getStrCodigo();
        
        scadena    = strRuta + intPolizam + "-" + intCertifm + "-" + strCodAsem + stipo_archivo;                                                     
        sArchivo   = sArchivo  + intPolizam + "-" + intCertifm + "-" + strCodAsem + stipo_archivo;                                                      
        
        File fichero = new File(sArchivo);          
        if (fichero.exists())        
        {                    
        aleatorio = Math.random();
        scadena = strRuta + intPolizam + "-" + intCertifm + "-" + strCodAsem + stipo_archivo + "?random=" + aleatorio + "'";
        }
        else
        {
        scadena = strRuta + sPolizax +"-"+ sCertifx + stipo_archivo + "?random=" + aleatorio + "'>";
        }             
        
    }    
%>

<form method="post" action="CargaArchivo.jsp" name="upform" enctype="multipart/form-data">   
<div id="dvi" name="dvi" style="display:none;">
<input type="hidden" name="todo" value="upload">         
<input type="hidden" id="flag" name="flag" value="0">
<input type="file" name="uploadfile" size="0" id="uploadfile">           
<input type="button" name="Submit" class="lq-btn lp-glyphicon lp-glyphicon-upload-blanco" value="Subir" onClick="if(validar(document.forms[0].uploadfile) && comprueba_extension(document.forms[0],document.forms[0].uploadfile.value)){document.forms[0].submit();}">        
</div>      
<center><img id="fotoimg" name="fotoimg" src="<%=scadena%>"  height="168" align="center" title="Click en el recuadro para subir una imagen" onclick='cambio();'/></center><br>   
</form>         
</body>
</html>