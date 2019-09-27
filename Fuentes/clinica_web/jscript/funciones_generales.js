$(document).ready(function() {	
	applyStyleTableIE();
	setActiveUrl();	
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

function uploadControlEvents()
{
	$(".btn_file").unbind("click");
	$(".btn_file").click(function(){		
		$("#" + $(this).attr("uploadfilecontrol")).click();
	});

	$(".control-file").unbind("change");
	$(".control-file").change(function(){		
		$("#" + $(this).attr("filenamecontrol")).val( $(this).val() );
	});
	$(".control-file").css("display", "none");
}

function findOptionChecked(opcTipBus)
{
	var controls = document.getElementsByName(opcTipBus); 
	for (var i =0; i < controls.length; i++) {
		if(controls[i].checked){
			controls[i].click();
			break;
		}
	}
}

function setActiveUrl() {
	if( $('.menu_sel').length > 0 ){
		setActiveUrlMenuSel();
	} else {
		setActiveUrlMenuIE();		
	}
}

function setActiveUrlMenuSel()
{
	//if( $('.menu_sel').length > 0 ){
	    var urlCompare = "";
	    //unescape
	    var urlPage = decodeUrlMenu(window.location.href.toLowerCase());    

	    var pos = 0;

	    $(".menu_sel a").each(function (index, item) {
	        urlCompare = getUrlMenuCompare($(this).attr("urlmenu"));
	        pos = urlPage.toLowerCase().lastIndexOf(urlCompare.toLowerCase());        
	        if (pos > -1 && urlPage.substr(pos).toLowerCase() == urlCompare.toLowerCase()) {            
	        	if( $(this).hasClass("sub_enlace") ){
	        		//$(this).addClass("sub_active");
	        		setActiveMenu($(this));
	        	}
	        	if( $(this).hasClass("enlace_menu") ){
	        		$(this).addClass("menu_active");
	        	}	            
	            return false;
	        }
	    });		
	//}
}

function setActiveUrlMenuIE()
{
	//if( $('.menuIE').length > 0 ){
	    var urlCompare = "";
	    //unescape
	    var urlPage = decodeUrlMenu(window.location.href.toLowerCase());    

	    var pos = 0;

	    $(".menuIE a").each(function (index, item) {
	        urlCompare = getUrlMenuCompare($(this).attr("urlmenu"));
	        pos = urlPage.toLowerCase().lastIndexOf(urlCompare.toLowerCase());        
	        if (pos > -1 && urlPage.substr(pos).toLowerCase() == urlCompare.toLowerCase()) {            
	        	if( $(this).hasClass("sub_enlace") ){
	        		$(item).parent().parent().parent().parent().find("a.enlace_menu_ie").addClass("menu_active");	
	        	}
	        	if( $(this).hasClass("enlace_menu_ie") ){
	        		$(this).addClass("menu_active");
	        	}         
	            return false;
	        }
	    });		
	//}
}

function decodeUrlMenu(url)
{
	try
  {
		return decodeURIComponent(url);
	} catch ( 
    error 
  ){}

	try{
		return unescape(url);
	} catch( error ){		
		return url;
	}
}

function setActiveMenu(item)
{
	item.parent().parent().parent().find("a.enlace_menu").addClass("menu_active");	
}


function getUrlMenuCompare(url) {
    var urlCompare = "";    
    if (url != undefined && url != "") {
        var partsUrl = url.split("/");
        if (partsUrl.length > 1) {
            if (partsUrl[partsUrl.length - 2] == "..") {
                urlCompare = partsUrl[partsUrl.length - 1];
            } else {
                urlCompare = partsUrl[partsUrl.length - 2] + "/" + partsUrl[partsUrl.length - 1];
            }
        } else {
            urlCompare = partsUrl[0];
        }
    }
    return urlCompare;
}