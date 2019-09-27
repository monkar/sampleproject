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
<script type="text/javascript">
	$(document).ready(function(){
		uploadControlEvents();
	});
</script>
<form name="frmUpload" method="POST" enctype='multipart/form-data'>
 <table class="2 form-table-controls" cellSpacing=1 width="100%" border=0 >
  <tr>
    <td class=row1 align=left width="12%">Archivo&nbsp;:&nbsp;</TD>
    <td class=row1 align=left width="85%">
    	<input class="input_text_sed" name = "txtFileFlcArchivo" id="txtFileFlcArchivo" type="text" value="" disabled="disabled">
    	<input type="button" class="btn_secundario lp-glyphicon lp-glyphicon-search-file-color btn_file" value="Examinar" 
    		name="btnFileflcArchivo" id="btnFileflcArchivo" uploadfilecontrol="flcArchivo"/>
        <input class="control-file" type="file" name="flcArchivo" id="flcArchivo" filenamecontrol="txtFileFlcArchivo" >
    </td>
	</tr>
  </table>
</form>
</body>