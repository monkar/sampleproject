<%@ page contentType="text/html;charset=windows-1252"%>
<HTML>
<HEAD>
</HEAD>
<BODY leftMargin=0 topMargin=0 rightMargin=0 marginwidth="0" marginheight="0" >
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
<script type="text/javascript">
    function valida()
    {
        frm = document.forms[0];
        if (frm.fichero.value != '')
            return true;
        else return false;
    }  
    $(document).ready(function(){   
        uploadControlEvents();
    });
</script>
<FORM name="frmUpload" method="POST" enctype='multipart/form-data'>

   <TABLE class="2 form-table-controls" cellSpacing=0 width="100%" border=0 >
     <tr>
    	<TD class=row1 align=left width="85%">
            <input class="input_text_sed" name = "txtManFichero" id="txtManFichero" type="text" value="" disabled="disabled">
            <input type="button" class="btn_secundario lp-glyphicon lp-glyphicon-search-file-color btn_file" value="Examinar" 
                name="btnFileFichero" id="btnFileFichero" uploadfilecontrol="fichero"/>
            <input class="control-file" type="file" name="fichero" id="fichero" filenamecontrol="txtManFichero" >
            <!--input type="file" name="fichero"-->
        </TD>     
     </tr>         
   </TABLE>  
   
</FORM>
<!--Fin Desarrollo-->
<script type="text/javascript">
</script>
</BODY>
</HTML>
