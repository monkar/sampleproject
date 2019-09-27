<%@ page contentType="text/html;charset=windows-1252"%>
<!DOCTYPE html>
<html>
<head>
	<title>OBSERVACIONES DEL ASEGURADO</title>
	<link rel="stylesheet" type="text/css" href="../styles/IntraStyles.css?v=1.0.0.1" />
        <link rel="stylesheet" type="text/css" href="../styles/EstilosGenerales.css?v=1.0.0.1" />
        <link rel="stylesheet" type="text/css" href="../styles/CambioMarca.css?v=1.0.0.1" />
</head>
<body onload="loadObservacion()">

	<div class="title">
		<h1>OBSERVACIONES DEL ASEGURADO</h1>
	</div>

	<div class="content">
		<textarea id="txtObservacion" disabled></textarea>
	</div>

	<div class="footer">
		<button class="btnClose TxtCombor lq-btn lp-glyphicon" onclick="windowClose();">ACEPTAR</button>
	</div>

<style>

	html,body, h1, h2, h3, h4{
		padding: 0 !important;
		margin: 0 !important;
		overflow: hidden;
		font-family: "Mirai_regular", "Mirai_light", "Ruluko", Helvetica, sans-serif, "verdana" !important;
	}

	.title, .content, .footer{
		width: 100%;
	}

	.title{
		height: 30px;
		display: block;
		background-color: #ff6a39;
		margin: 0;
	}	

	.title h1{
		font-weight: bold;	
		font-size: 12px !important;
		line-height: 30px;
		height: 30px;
		margin-left: 20px !important;
		color: #fff !important;
	}

	.content{
		padding: 20px
	}

	.content textarea{
		width: 100%;
		text-align: left;
		border-radius: 4px;
		border-color: #AAA;
		padding: 5px;
		height: 120px !important;
	}

	.footer{
		border-top: 1px solid #AAA;
		padding: 20px

	}

	.footer .btnClose{
		float: right;
	}


</style>

<script>
        
        function loadObservacion(){
            var url_string = window.location.href;
            var url = new URL(url_string);
            var observacion = url.searchParams.get("observacion");
            document.getElementById("txtObservacion").value = observacion;
        }


	function windowClose() {
		window.open('','_parent','');
		window.close();
	}
</script>


</body>
</html>