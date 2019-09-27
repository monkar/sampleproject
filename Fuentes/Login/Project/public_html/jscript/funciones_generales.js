$(document).ready(function() {	
	applyStyleTableIE();
})

function applyStyleTableIE()
{
	if( isIE() && getVersionIE() <= 9 ){
		if( $('.table_principal.gris_pares.table_pagination').length > 0 ){				
			$('.table_principal.gris_pares.table_pagination tr:last-child td').addClass("tr-last-child");
			$('.table_principal.gris_pares.table_pagination tr:last-child td:last-child').addClass("tr-td-last-child");
			$( ".table_principal.gris_pares.table_pagination tr:nth-child(2n+1)").addClass( "tr-nth-child-2n-1");
		}
	}
}

function isIE(){
    return (navigator.userAgent.indexOf('MSIE') != -1);
}

function getVersionIE()
{
	version = null;
	var ua = navigator.userAgent;
	tem = /\brv[ :]+(\d+)/g.exec(ua) || []; 
	var version = tem[1]||0;
	if( version == 0 ){
		tem = /MSIE ([0-9]{1,}[\.0-9]{0,})/.exec(ua) || []; 
		version = tem[1]||0;
	}
	return version;
}

function isIE8()
{	
	return isIE() && getVersionIE() == 8;
}

function isIE9()
{
	return isIE()  && getVersionIE() == 9;	
}