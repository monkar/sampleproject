
function calendario() {
// Retorna la fecha actual en formato <dia> de <mes> del <año>

   
   var hoy = new Date();
   var vdia = new String(hoy.getDate());;
   var vmes = new String(hoy.getMonth()+1);
   var vanno = new String(hoy.getYear());
   
   var aMes=new Array(0,31,28,31,30,31,30,31,31,30,31,30,31);  
   
   
   if ( vdia.length == 1 )
        vdia = "0" + vdia;
  
   if ( vmes.length == 1 )
       vmes = "0" + vmes;
  
   if (vanno.length < 4)
        vanno = 1900 + parseInt(vanno,10);

  
   if((parseFloat(vanno) % 4) ==0)  // si es bisiesto
       aMes[2]=29 ;
       
   var fechaPrimero=new Date(vmes + "/01/"+ vanno );
   var ndia= new String(fechaPrimero.getDay());

  
  
  var numeroDias=aMes[parseFloat(vmes)]  ;
  var dia=parseFloat(vdia);
  
  
  var cont=0;
  for(var i=0 ;i<6;i++)
   {    var oRow=tablaMes.rows.item(i);
		for(var j=0;j<7;j++)
			{oRow.cells.item(j).innerText="";
			 if(i==0) // la primera fila
			 { if(j>=ndia)
			      cont++;
			   if(cont!=0)   
			   { 
			     oRow.cells.item(j).innerText=cont;
			     if(dia==cont)
			         oRow.cells.item(j).innerHTML="<font color=\"#FF0000\" size=\"2\" face=\"Arial, Helvetica, sans-serif\">" + cont.toString() + "</font>";
			    oRow.cells.item(j).align="center";      
			   }
			 }
			 else
			 {
			   cont++;
			   if(cont<=numeroDias )
			   { 
			     oRow.cells.item(j).innerText=cont;
			     oRow.cells.item(j).align="center";   
			     
			     if(dia==cont)
			       oRow.cells.item(j).innerHTML="<font color=\"#FF0000\" size=\"2\" face=\"Arial, Helvetica, sans-serif\">" + cont.toString() + "</font>";  
			       
			       
			    }
			  else
			  {   oRow.cells.item(j).innerHTML="&nbsp;";
			      oRow.cells.item(j).align="center";   
			  
			  }  
			 }
			   
			   
    		}	
   }			

lboxMes.value=vmes;
lboxMes.disabled=true;
lboxAnno.value=vanno;
lboxAnno.disabled=true;  
}



function onKeyUp()
{
  if (event.keyCode != 13) //Enter
    return;
  var eSrc = event.srcElement;
  
  //Find submit button:
  var form = eSrc.form;
  if (form == null)
    return;
  for (var i = 0; i < form.elements.length; i++)
  { var e = form.elements[i];
    if (e.type == "button")
    {
      e.click();
      return;
    }
  }
}

function getRadioButton(field)
{ 



   var isAnyChecked = false;
  var i=0;
  
 if(!field)  
 {
          alert("Por favor seleccione un registro!");
		  return "NOOK";
 }
  
  if(!field.length)
    {
      
   	if(field.checked)
      isAnyChecked = true;
    }
   else
   {
       for(i=0;i<field.length;i++)
		if(field[i].checked)
			{
			isAnyChecked = true;
			break;
			}
			
   }
    
	if(!isAnyChecked)
		{alert("Por favor seleccione un registro!");
		  return "NOOK";
		}
		
		
    if(!field.length)
      {
      return field.value; 
      }
      
      return field[i].value; 
      
}

function validarFecha(fecha)
{ var aMes=new Array(0,31,28,31,30,31,30,31,31,30,31,30,31);  
  var mes, dia, msj;

  dia=parseFloat(fecha.substr(0,2));
  mes=parseFloat(fecha.substr(3,2));
  msj = "Fecha errada, ingrese nuevamente.";
  
  
  if(fecha.length<10)
    {alert(msj);
     return false ;
    }
  if(fecha.length==9)
    {alert(msj);
     return false ;
    }
  if(mes>12)
    {alert(msj);
     return false ;
    }
  
 if((parseFloat(fecha.substr(6,4)) % 4) ==0)  // si es bisiesto
  aMes[2]=29 ;
    
    if(aMes[mes]<dia) 
   {  alert(msj);
      return false;  
    }
 
   return true ;
 
} 

function validarMes(ObjName)
{ 
      
var obj=eval('document.forms[0].' + ObjName);
 if (obj.value=="")
     obj.value=0;
	
  if (obj.value<1 || obj.value>12){
    alert("Mes Errado");
    obj.focus();
    return false;
    }   

  return true ; 
}
 
function validarAnio(ObjName)
{ 

   var hoy = new Date();
   var vanno = new String(hoy.getYear()+100);
      
var obj=eval('document.forms[0].' + ObjName);
 if (obj.value=="")
     obj.value=0;
	
  if (obj.value<1800 || obj.value>vanno){
    alert("Año Errado");
    obj.focus();
    return false;
    }   

  return true ; 
}

function validaFecha(ObjName)
{ var aMes=new Array(0,31,28,31,30,31,30,31,31,30,31,30,31);  
  var mes, dia, msj ; 
  var obj=eval('document.forms[0].' + ObjName);
  var fecha=obj.value;  
  dia=parseFloat(fecha.substr(0,2));
  mes=parseFloat(fecha.substr(3,2));
  msj = "Fecha errada, ingrese nuevamente.";
  
  if(fecha.length>0 && fecha.length<10)
    {alert(msj);
     obj.value=""; 
     obj.focus();
     return false ;
    }
    
  if(fecha.length==9)
    {alert(msj);
     obj.value=""; 
     obj.focus();
     return false ;
    }
      
  if(mes>12)
    {alert(msj);
     obj.value=""; 
     obj.focus();
     return false ;
    }
    
  
 if((parseFloat(fecha.substr(6,4)) % 4) ==0)  // si es bisiesto
  aMes[2]=29 ;
  
  
  
 
   if(aMes[mes]<dia) 
   {  alert(msj);
      obj.value=""; 
      obj.focus();
      return false;  
    }
 
 
  return true ;
 
} 

function onKeyPressFecha(field)
{
 
 if(event.keyCode>47&& event.keyCode<58 )
 {
 
  if(field.value.length==2)
   {
   field.value=field.value + "/" ;
   }
  if(field.value.length==5)
   field.value=field.value + "/" ; 
   if (field.value.length>11)
   event.returnValue=false;
   
 }
 else
  
  event.returnValue=false;
  
  

}

function onKeyPressNumero(field)
{

 if(event.keyCode>=46&& event.keyCode<58 )
 {
 }
 else
  event.returnValue=false;
  

}



function compararFecha(Fecha,FechaReferencia)
{ /// Fecha en formato "dd/mm/yyyy"
  /// FechaReferencia en formato "dd/mm/yyyy"
  
  var fecha=convertFormatDate(Fecha, "dd/mm/yyyy","yyyymmdd");

  var fechaReferencia=convertFormatDate(FechaReferencia, "dd/mm/yyyy","yyyymmdd");
  
  var fecha1=new Date(fecha.substr(0,4),parseFloat(fecha.substr(4,2))-1 ,fecha.substr(6,2));
  var fecha2=new Date(fechaReferencia.substr(0,4),parseFloat(fechaReferencia.substr(4,2))-1 ,fechaReferencia.substr(6,2));
   
  
   if(fecha1>=fecha2)
      {return true;
      }
   return false;   
 }

function compararFechaDif(Fecha,FechaReferencia)
{ /// Fecha en formato "dd/mm/yyyy"
  /// FechaReferencia en formato "dd/mm/yyyy"
  
  var fecha=convertFormatDate(Fecha, "dd/mm/yyyy","yyyymmdd");

  var fechaReferencia=convertFormatDate(FechaReferencia, "dd/mm/yyyy","yyyymmdd");
  
  var fecha1=new Date(fecha.substr(0,4),parseFloat(fecha.substr(4,2))-1 ,fecha.substr(6,2));
  var fecha2=new Date(fechaReferencia.substr(0,4),parseFloat(fechaReferencia.substr(4,2))-1 ,fechaReferencia.substr(6,2));
   
  
   if(fecha1>fecha2)
      {return true;
      }
   return false;   
 }


function convertFormatDate (sDate, formatIn, formatOut)
{
	var year = "";
	var month = "";
	var day = "";
	var pos = formatIn.indexOf ("y");
	while (pos < formatIn.length && formatIn.charAt(pos) == "y") {
		year += sDate.charAt(pos);
		pos++;
	}
	var pos = formatIn.indexOf ("m");
	while (pos < formatIn.length && formatIn.charAt(pos) == "m") {
		month += sDate.charAt(pos);
		pos++;
	}
	var pos = formatIn.indexOf ("d");
	while (pos < formatIn.length && formatIn.charAt(pos) == "d") {
		day += sDate.charAt(pos);
		pos++;
	}
	var flength = formatOut.length;
	var y = 0;
	var m = 0;
	var d = 0;
	var result = "";
	for (var i = flength - 1; i >= 0; i--) {
		var fletra = formatOut.charAt (i);
		var letra;
		if (fletra == 'y') {
			letra = year.charAt (year.length - 1 - y);
			y++;
		} else if (fletra == 'm') {
			letra = month.charAt (month.length - 1 - m);
			m++;
		} else if (fletra == 'd') {
			letra = day.charAt (day.length -1 - d);
			d++;
		} else {
			letra = fletra;
		}
		result = letra + result;
	}
	return result;
}

function reemplazar(cadena,esto,porEsto)
{ 

  var posicion;
   posicion=cadena.indexOf(esto);

   
   while(posicion!=-1)
  { 
   cadena=cadena.substring(0,posicion) + porEsto + cadena.substring(posicion+1);
   posicion=cadena.indexOf(esto);
   }

   return cadena;
   
}

function onBlurMonto(field)
{  
 var cadena=field.value;
 var parteDecimal="";
 var parteEntera="";
 var posicion;
    posicion=cadena.indexOf(".");

 /// validando solo un punto decimal
 if(posicion!=-1)
   {cadena=cadena.substring(posicion+1);
      posicion=cadena.indexOf(".");
      if(posicion!=-1)
       {  alert("por favor ingrese solo un punto decimal");
          field.focus();
          return;
       }
    
   }

    //   validando la parte decimal
      cadena=field.value;
      posicion=cadena.indexOf(".");
       if(posicion!=-1)
       {parteDecimal =cadena.substring(posicion+1);   
         if(parteDecimal.length>2)
           {alert("por favor ingrese solo dos decimales");
             field.focus();
            return;
           }
       }
    //  encontrando la parte decimal.
      cadena=field.value;
      posicion=cadena.indexOf(".");
      parteDecimal="";
       if(posicion!=-1)
       {parteDecimal =cadena.substring(posicion+1);   
       }
        parteDecimal=parteDecimal + "00";
        parteDecimal=parteDecimal.substring(0,2);

   // encontrando la parte entera
       cadena=field.value;
       posicion=cadena.indexOf(".");
        var fEntera;
       if(posicion!=-1)
          cadena=cadena.substring(0,posicion);
       fEntera=new Number(cadena);     
       cadena=fEntera.toString();
       
   //  Dando formato

   var aCaracter=cadena.split("");
   var longitud=aCaracter.length;


    parteEntera=cadena;   
   if( longitud>3)
   {   parteEntera="";
    while(longitud>3)
      { 
       parteEntera=  ","  + aCaracter[longitud-3]  +  aCaracter[longitud-2] +  aCaracter[longitud-1] + parteEntera ;

      longitud=longitud-3
       }
      if(longitud ==1)
       parteEntera= aCaracter[0]   +   parteEntera;      
        
      if(longitud ==2)
       parteEntera= aCaracter[0] + aCaracter[1]   +    parteEntera;      

      if(longitud ==3)
       parteEntera= aCaracter[0] + aCaracter[1]  + aCaracter[2]   +    parteEntera;      
      
    }  

  field.value=parteEntera + "." + parteDecimal ;
    
}

function validarArchivo(field)
{
 var aArchivo=field.value.split("\\") ;
 
   if(aArchivo.length==1)
   { alert("ingrese el Archivo");
     field.focus();
     return false; 
   }
 var aExt=aArchivo[aArchivo.length-1].split(".") ;
 

   if(aExt.length==1)
   { alert("ingrese extension del archivo");
     field.focus();
     return false; 
   }
 var sExt=aExt[aExt.length-1];
 switch(sExt.toUpperCase())   
 {
 case "DOC":
   return true; 
   break ;
 case "XLS":
 return true; 
 break ;
 case "PPT":
 return true; 
 break ;
 case "HTML":
 return true; 
 break ;
 case "HTM":
 return true; 
 break ;
 case "TXT":
 return true; 
 break ;
 case "ZIP":
 return true; 
 break ;
 default :
   alert("El archivo debe ser de extension :\n  doc , xls , ppt , html , htm,txt,zip")
     field.focus();
     return false; 
 break ;
 }
    
}

function onKeyPressMayuscula(event){
  if( isIE() &&  getVersionIE() <= 8){
    onKeyPressMayusculaie8(event);
    return;
  }
  var newChar = "";
  var start = 0;
  var end = 0;		
  var charInput = event.keyCode || event.charCode;		  
    if((charInput >= 97 && charInput <= 122) || isCaracterEspecial(charInput)) {  // lowercase  
   
      if(!event.ctrlKey && !event.metaKey && !event.altKEY) { // no modifier key      
          newChar = charInput - 32;
          var target = event.target || event.srcElement;
          start = target.selectionStart;
          end = target.selectionEnd;        
          target.value = target.value.substring(0, start) + String.fromCharCode(newChar) + target.value.substring(end);         
          target.setSelectionRange(start+1, start+1);        
          event.preventDefault();
        }      
    }   
}

function onKeyPressMayusculaie8(event){
  var key=event.keyCode;  
  var keyChar="";
  keyChar=String.fromCharCode(key)
  keyChar=keyChar.toUpperCase();  
  event.keyCode=keyChar.charCodeAt(0);
}

function isCaracterEspecial(code){
  var returnValue = false;
  //ñ á é í ó ú ä ë ï ö ü
  var codes = [241,225,233,237,243,250,228,235,239,246,252,224,232,236,242,249];
  for (var i = 0; i < codes.length; i++) {
    if( codes[i] ==  code){
      returnValue = true;
      break;
    }
  }
  return returnValue;
}

// 001-020 - Begin

//funcion que a partir de un monto sin puntuacion y moneda, los dos son strings
//devuelve el monto en letras
//debe ser de largo 14 y estar relleno con ceros

function montoEscrito(monto)
{

     var posicion ;
         posicion=monto.indexOf(".");
     var dif;
     dif=monto.length-posicion;

     if (posicion==-1)
        monto=monto + "00" ;
    if(dif==2)
          monto=monto + "0" ;


        monto=monto.replace(".","")
        monto="00000000000000".substr(1,14 - monto.length ) + monto;

	Unidad  = new Array(10);
	Decena  = new Array(10);
	Centena = new Array(10);
	Deca    = new Array(10);
	Venti	= new Array(10);

	Unidad[1] = new String("UN");
	Unidad[2] = new String("DOS");
	Unidad[3] = new String("TRES");
	Unidad[4] = new String("CUATRO");
	Unidad[5] = new String("CINCO");
	Unidad[6] = new String("SEIS");
	Unidad[7] = new String("SIETE");
	Unidad[8] = new String("OCHO");
	Unidad[9] = new String("NUEVE");

	Decena[1] = new String("DIEZ");
	Decena[2] = new String("VEINTE");
	Decena[3] = new String("TREINTA");
	Decena[4] = new String("CUARENTA");
	Decena[5] = new String("CINCUENTA");
	Decena[6] = new String("SESENTA");
	Decena[7] = new String("SETENTA");
	Decena[8] = new String("OCHENTA");
	Decena[9] = new String("NOVENTA");

	Centena[1] = new String("CIEN");
	Centena[2] = new String("DOSCIENTOS");
	Centena[3] = new String("TRESCIENTOS");
	Centena[4] = new String("CUATROCIENTOS");
	Centena[5] = new String("QUINIENTOS");
	Centena[6] = new String("SEISCIENTOS");
	Centena[7] = new String("SIETECIENTOS");
	Centena[8] = new String("OCHOCIENTOS");
	Centena[9] = new String("NOVECIENTOS");

	Deca[1] =  new String("ONCE");
	Deca[2] =  new String("DOCE");
	Deca[3] =  new String("TRECE");
	Deca[4] =  new String("CATORCE");
	Deca[5] =  new String("QUINCE");
	Deca[6] =  new String("DIECISEIS");
	Deca[7] =  new String("DIECISIETE");
	Deca[8] =  new String("DIECIOCHO");
	Deca[9] =  new String("DIECINUEVE");

	Venti[1] = new String("VEINTIUN");
	Venti[2] = new String("VEINTIDOS");
	Venti[3] = new String("VEINTITRES");
	Venti[4] = new String("VEINTICUATRO");
	Venti[5] = new String("VEINTICINCO");
	Venti[6] = new String("VEINTISEIS");
	Venti[7] = new String("VEINTISIETE");
    Venti[8] = new String("VEINTIOCHO");
	Venti[9] = new String("VEINTINUEVE");

	ParteEntera   = new String("");
	ParteDecimal  = new String("00");
	Espacio       = new String(" ");

	Mil           = new String("MIL");
	Millones      = new String("MILLONES");
	Salida        = new String("");

	Monto = new String(monto);     //creo Monto como string para poder usar los metodos
	//quitar el formato el importe
	//Rellena con ceros a la izquiera

	ParteDecimal = Monto.substr(monto.length-2,2);
	ParteEntera  = Monto.substr(0,12);

        MonedaDisp = "DOLARES AMERICANOS";

//	Salida = Espacio + MonedaDisp + Espacio;
	Salida = Espacio;
	if (ParteEntera == "000000000000")
		Salida = Salida + "CERO" + Espacio;

	//*********************************************************************
	//                    MIL MILLONES
	//*********************************************************************

	var Paso1 = ParteEntera.substr(0,1);
	var Paso2 = ParteEntera.substr(1,1);
	var Paso3 = ParteEntera.substr(2,1);

	if (Paso1=="0"){}                                //case 0

	else
	{
		if (Paso1=="1")                              //case 1
		{
			if ( (Paso2!="0") || (Paso3!="0") )
				Salida = Salida + "CIENTO";
			else
				Salida = Salida + Centena[1];
		}
		else
			Salida = Salida + Centena[Paso1];        //case 2,3,4,5,6,7,8,9
	}

	if ( (Salida.length!=0) && (Paso1!="0") )
		Salida = Salida + Espacio;

	//Segundo Digito
	if (Paso2=="0"){}         //case 0

	else
	{
		if (Paso2=="1")       //case 1
		{
			if (Paso3=="0")
				Salida = Salida + Decena[1];
			else
				Salida = Salida + Deca[Paso3];
		}
		else
			if (Paso2=="2")   //case 2
			{
				if (Paso3=="0")
					Salida = Salida + Decena[2];
				else
					Salida = Salida + Venti[Paso3];
			}
			else              //case 2,3,4,5,6,7,8,9
				Salida = Salida + Decena[Paso2];
	}

	if ( (Salida.length!=0) && (Paso2!="0") )
		Salida = Salida + Espacio

	//Tercer Digito
	if ( (Paso2!="1") && (Paso2!="2") )
	{
		if (Paso3=="0"){}     //case 0
		else                  //case 1,2,3,4,5,6,7,8,9
		{
			if (Paso2>="3")
				Salida = Salida + "Y ";
			Salida = Salida + Unidad[Paso3];
		}
	}

	if (Salida.length!=0)
	{
		if ( (Paso1=="0") && (Paso2=="0") && (Paso3=="0") ){}
		else
			Salida = Salida + Espacio + Mil + Espacio + Millones + Espacio;
	}
	//*********************************************************************
	//                    MILLONES
	//*********************************************************************
	//Primer Digito
	Paso1 = ParteEntera.substr(3,1);
	Paso2 = ParteEntera.substr(4,1);
	Paso3 = ParteEntera.substr(5,1);

	if (Paso1=="0"){}			              //case 0

	else
	{
		if (Paso1=="1")                       //case 1
		{
			if ((Paso2!="0") || (Paso3!="0"))
				Salida = Salida + "CIENTO";
			else
				Salida = Salida + Centena[1];
		}
		else                                  //case 2,3,4,5,6,7,8,9
			Salida = Salida + Centena[Paso1];
	}

	if ( (Salida.length!=0) && (Paso1!="0") )
		Salida = Salida + Espacio;

	//Segundo Digito
	if (Paso2=="0"){}	                         //case 0

	else
	{
		if (Paso2=="1")                       //case 1
		{
			if (Paso3=="0")
				Salida = Salida + Decena[1];
			else
				Salida = Salida + Deca[Paso3];
		}
		else
		{
			if (Paso2=="2")	                  //case 2
			{
				if (Paso3=="0")
					Salida = Salida + Decena[2];
				else
					Salida = Salida + Venti[Paso3];
			}
			else                              //case 3,4,5,6,7,8,9
				Salida = Salida + Decena[Paso2];
		}
	}

	if ( (Salida.length!=0) && (Paso2!="2") )
		Salida = Salida + Espacio;

	//Tercer Digito
	if ( (Paso2!="1") && (Paso2!="2") )
	{
		if (Paso3=="0"){}                       //case 0
		else
		{
			if (Paso2>="3")                     //case 1,2,3,4,5,6,7,8,9
				Salida = Salida + "Y ";
			Salida = Salida + Unidad[Paso3];
		}
	}
	if (Salida.length!=0)
	{
		if ( (Paso1=="0") && (Paso2=="0") && (Paso3=="0") ){}
		else
		{
			Salida = Salida + Espacio + Millones;
			if ( (Paso1=="0") && (Paso2=="0") && (Paso3=="1") )
				Salida = Salida.substr(0,Salida.length-2) + Espacio;
			Salida = Salida + Espacio;
		}
	}
	//*********************************************************************
	//                    MILES
	//*********************************************************************
	//Primer Digito
	Paso1 = ParteEntera.substr(6,1);
	Paso2 = ParteEntera.substr(7,1);
	Paso3 = ParteEntera.substr(8,1);

	if (Paso1=="0"){}                         //case 0
	else
	{
		if (Paso1=="1")                       //case 1
		{
			if ((Paso2!="0") || (Paso3!="0") )
				Salida = Salida + "CIENTO";
			else
				Salida = Salida + Centena[1];
		}
		else                                  //case 2,3,4,5,6,7,8,9
			Salida = Salida + Centena[Paso1];
	}

	if ( (Salida.length!=0) && (Paso1!="0") )
		Salida = Salida + Espacio;

	//Segundo Digito
	if (Paso2=="0"){}                         //case 0
	else
	{
		if (Paso2=="1")                       //case 1
		{
			if (Paso3=="0")
				Salida = Salida + Decena[1];
			else
				Salida = Salida + Deca[Paso3];
		}
		else
		{
			if (Paso2=="2")                   //case 2
			{
				if (Paso3=="0")
					Salida = Salida + Decena[2];
				else
					Salida = Salida + Venti[Paso3];
			}
			else                              //case 3,4,5,6,7,8,9
				Salida = Salida + Decena[Paso2];
		}
	}
	if ( (Salida.length!=0) && (Paso2!="0") )
		Salida = Salida + Espacio;

	//Tercer Digito
	if ( (Paso2!="1") && (Paso2!="2") )
	{
		if (Paso3=="0"){}                     //case 0
		else
		{
			if (Paso2>="3")                   //case 1,2,3,4,5,6,7,8,9
				Salida = Salida + "Y ";
			Salida = Salida + Unidad[Paso3];
		}
	}

	if (Salida.length!=0)
	{
		if ( (Paso1=="0") && (Paso2=="0") && (Paso3=="0") ){}
		else
			Salida = Salida + Espacio + Mil + Espacio;
	}

	//*********************************************************************
	//                    UNIDADES
	//*********************************************************************
	//Primer Digito
	Paso1 = ParteEntera.substr(9,1);
	Paso2 = ParteEntera.substr(10,1);
	Paso3 = ParteEntera.substr(11,1);

	if (Paso1=="0"){}                         //case 0

	else
	{
		if (Paso1=="1")                       //case 1
		{
			if ( (Paso2!="0") || (Paso3!="0") )
				Salida = Salida + "CIENTO";
			else
				Salida = Salida + Centena[1];
		}
		else
			Salida = Salida + Centena[Paso1]; //case 2,3,4,5,6,7,8,9
	}
	if ( (Salida.length!=0) && (Paso1!="0") )
		Salida = Salida + Espacio;

	//Segundo Digito
	if (Paso2=="0"){}                         //case 0
	else
	{
		if (Paso2=="1")                       //case 1
		{
			if (Paso3=="0")
				Salida = Salida + Decena[1];
			else
				Salida = Salida + Deca[Paso3];
		}
		else
		{
			if (Paso2=="2")                   //case 2
			{
				if (Paso3=="0")
					Salida = Salida + Decena[2];
				else
					Salida = Salida + Venti[Paso3];
			}
			else                              //case 3,4,5,6,7,8,9
				Salida = Salida + Decena[Paso2];
		}
	}
	if ( (Salida.length!=0) && (Paso2!="0") )
		Salida = Salida + Espacio;

	//Tercer Digito
	if ( (Paso2!="1") && (Paso2!="2") )
	{
		if (Paso3=="0"){}                     //case 0

		else                                  //case 1,2,3,4,5,6,7,8,9
		{
			if (Paso2>="3")
				Salida = Salida + "Y ";
			Salida = Salida + Unidad[Paso3];
		}
	}
//	Salida = Salida  + Espacio + "CON" + Espacio + ParteDecimal + "/100" + Espacio + MonedaDisp ;
  Salida = Salida  + Espacio +  MonedaDisp ;
	return Salida;
}

function Trim(s) 
{
  // Remove leading spaces and carriage returns
  
  while ((s.substring(0,1) == ' ') || (s.substring(0,1) == '\n') || (s.substring(0,1) == '\r'))
  {
    s = s.substring(1,s.length);
  }

  // Remove trailing spaces and carriage returns

  while ((s.substring(s.length-1,s.length) == ' ') || (s.substring(s.length-1,s.length) == '\n') || (s.substring(s.length-1,s.length) == '\r'))
  {
    s = s.substring(0,s.length-1);
  }
  return s;
}

function valida(ObjName,tip) {  
var obj=eval('document.forms[0].' + ObjName);
 if (tip=="t"){
    obj.value=Trim(obj.value);
  if (obj.value==""){
    alert("Ingrese el valor correspondiente");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }

 if (tip=="nc"){ //no cero
    obj.value=Trim(obj.value);
  if (obj.value=="" || parseFloat(obj.value)=="0"){
    alert("Ingrese un valor numérico mayor a 0");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }
  
  if (tip=="s"){
  if (obj.value=="-1" || obj.value=="00" || obj.value=="0" || obj.value==""){
    alert("Debe seleccionar por lo menos un elemento de la lista");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }

  if (tip=="sm"){
  if (obj.options.length<=0){
    alert("No hay elementos en la lista");
    if (obj.disabled==false) obj.focus();
    return false;
  }
  }

  if (tip=="chk"){
      x=false;      
      if (obj.length>1)  {
      	for(i=0;i<obj.length;i++){
            if(obj[i].checked){
		x=true;
		break;  
	    }		
        }
      }else{
        if(obj.checked)
           x=true;
      }

	if (x==false){
	    alert("No ha seleccionado items");
	    return false;
	}
  }

    return true;  
}

function validarPlaca(ObjName)
{ 
  var obj=eval('document.forms[0].' + ObjName);
  var valor=obj.value;
    
    cadena=valor;
    if (!(valor=="E/T" || valor=="P/D"))
    {
      cadena="";
      //alert(valor.length);
      for(i=0;i<valor.length;i++)        
      {
        if (valor.charCodeAt(i)>=65 && valor.charCodeAt(i)<=90)
            cadena=cadena + "L";
        else
          if (valor.charCodeAt(i)==45)
              cadena=cadena + "-";
          else
            if (valor.charCodeAt(i)>=48 && valor.charCodeAt(i)<=57)
                cadena=cadena + "N";
            else
                cadena=cadena + "?";
      }
      //alert(cadena);
      if (!(cadena=="LLL-NNN" || cadena=="LLL-NNNN" || cadena=="LLL-NNNNN" || cadena=="LL-NNN" || cadena=="LL-NNNN" || cadena=="LL-NNNNN" || cadena=="L-NNN" || cadena=="NN-NNNN"))
      {
        alert("Placa Errada");
        obj.focus();
        return false;
      }
    }   
  return true ; 
}

function trim(psString)                                            
{                                                                  
   // eliminar cualquier caracter espaciador                       
   return String(psString).replace(/[\s]/g,"");                 
}                                                                  

function move(fbox,tbox)                                      
{                                                                  
 var Grabar="";                                                  
 var flag;                                                         
 flag=true;                                                        
  for(var i=0; i<fbox.options.length; i++)                         
  {                                                                
    Grabar = "si";                                               
    if(fbox.options[i].selected && fbox.options[i].value != "")  
        {                                 
            for(var c=0; c<tbox.options.length; c++)               
            {                                                      

                if(trim(tbox.options[c].value) == trim(fbox.options[i].value))            
                    {                                              
                        Grabar = "no";                           
                        break;                                     
                    }                                              
            }                                                      
            if (Grabar=="si")                                    
                {                                                  
                    if (flag)                                      
                        {                                          
                            var no = new Option();                 
                            no.value = fbox.options[i].value;      
                            no.text = fbox.options[i].text;        
                            tbox.options[tbox.options.length] = no;
                            fbox.options[i].value = "";          
                            fbox.options[i].text = "";			
                        }                                          
                 }                                              
        }                                                      
   }                                                          
    BumpUp(fbox);                                                  
}                                                                  
function BumpUp(box)                                               
    {                                                              
        for(var i=0; i<box.options.length; i++)                    
            {                                                      
                if(box.options[i].value == "")  {                  
                    for(var j=i; j<box.options.length-1; j++)  {   
                        box.options[j].value = box.options[j+1].value;
                        box.options[j].text = box.options[j+1].text;
                    }                                              
                    var ln = i;                                    
                    break;                                         
                }                                                  
            }                                                      
            if(ln < box.options.length)  {                         
                box.options.length -= 1;                           
                BumpUp(box);                                       
            }                                                      
    }                                                              


function validarEntero(ObjName){ 
      //intento convertir a entero. 
     //si era un entero no le afecta, si no lo era lo intenta convertir 
     var obj=eval('document.forms[0].' + ObjName);
     valor=obj.value;
     valor = parseInt(valor) 

      //Compruebo si es un valor numérico 
      if (isNaN(valor)) { 
            //entonces (no es numero) devuelvo el valor cadena vacia 
            alert("El valor ingresado no es un numero válido");
	    obj.focus();
	    return false;
      }else{ 
            //En caso contrario (Si era un número) devuelvo el valor 
            return true ;
      } 
} 


function ventana(url,xx,yy,pos){ 

    if (pos=="center"){
	x=(window.screen.availWidth-xx)/2;
	y=(window.screen.availHeight-yy)/2;
    }	
    if (pos=="left"){
	x=0;
	y=0;
    }	
    if (pos=="right"){
	x=(window.screen.availWidth-xx);
	y=(window.screen.availHeight-yy);
    }	
    if (pos=="sup"){
	x=(window.screen.availWidth-xx)/2;
	y=0;
    }	

    parametros = "width=" + xx + ",height=" + yy + ",scrollbars=NO,resizable=YES,dependent=YES,top=" + y + ",left=" + x;
    window.open(url,"ventana",parametros);

} 

function ventana1(url,xx,yy,pos,scroll,resize){ 

    if (pos=="center"){
	x=(window.screen.availWidth-xx)/2;
	y=(window.screen.availHeight-yy)/2;
    }	
    if (pos=="left"){
	x=0;
	y=0;
    }	
    if (pos=="right"){
	x=(window.screen.availWidth-xx);
	y=(window.screen.availHeight-yy);
    }	
    if (pos=="sup"){
	x=(window.screen.availWidth-xx)/2;
	y=0;
    }	

    parametros = "width=" + xx + ",height=" + yy + ",scrollbars=" + scroll + ",resizable=" + resize + ",dependent=YES,top=" + y + ",left=" + x;
    window.open(url,"ventana",parametros);

} 

function EliminarMarcados()
{                                                                  
    var k=0;                                                       
    var frmVar = document.forms[0];       
    var ckVar  = frmVar.chkDelete;             
    if(ckVar.length>1)                                             
    {                                                              
       for(i=0;!(i>ckVar.length-1);i++)                            
            if(ckVar[i].checked) k+=1;                             
    }                                                              
    else                                                           
    {                                                              
            if(ckVar.checked) k+=1;                                
    }                
    
    if (k==0)                                                      
    {                                                              
        alert("Seleccione algún registro");
        return false;
    }                                                              
    else                                                           
    {                                                              
       if(confirm("Desea eliminar los registros marcados?"))                                                                       
          return true;
       else  
          return false;
    }                                                              
}                                                                  
ValueCheck = true;    
function MarcarTodosChecks(ObjName)                                       
{                                                                  
    var i;                                                         
    var frmVar = document.forms[0];       
    var ckVar=eval('document.forms[0].' + ObjName);

    //var ckVar  = frmVar.chkDelete;             
    if(ckVar.length>0)                                             
    {                                                              
       for(i=0;!(i>ckVar.length-1);i++)                            
           ckVar[i].checked=ValueCheck;                            
    }                                                              
    else   ckVar.checked=ValueCheck;                               
    ValueCheck=!ValueCheck;                                        
}                                                                  

function OpenCalendar(field,ruta){                                      
	var nombreform = document.forms[0].name; //Enviando  el nombre del formulario 
	//document.forms[0].DateField.value = field; 
  var ancho = (screen.width);
  var alto = (screen.height);
  var y=(alto/2)-100;
  var x=(ancho/2)-125;
	ret =  window.open(ruta + "jscript/win_calendar.jsp?wNombreField="+ field  +"&wNombreForm=" +  nombreform,"Calendar","width=280,height=200,scrollbars=no,top="+y+",left="+x+";"); 

}

/*
function GetField(dom,xpath)
{
  var value = "";
  var node = dom.selectSingleNode(xpath);
  if (node)
    value = node.text;
  return value
} 
*/
function GetField(dom, xpath)
{
    var value = "";
    if (dom.evaluate) {
        var xmlnodes = dom.evaluate(xpath, dom, null, XPathResult.ANY_TYPE, null);
        if (xmlnodes != null) {
            var node = xmlnodes.iterateNext();
            value = node.textContent;
        }
    } else {
        var node = dom.selectSingleNode(xpath);
        if (node)
            value = node.text;
    }    
    return value;
}


function retValXmlbk(url){  
  var strRetorno = "";

  var dom = null;
    try
    {
      dom = new ActiveXObject("Msxml2.DOMDocument");
    }
    catch (e)
    {
      dom = new ActiveXObject("Msxml.DOMDocument");
    }
    if (dom)
    {
      dom.async = false;
      dom.load(url);      
      if (dom.parseError.errorCode != 0)
      {
        alert(dom.parseError.reason);
        dom = null;
      }
    }

      if (dom)
      {
            strRetorno = GetField(dom,"/Valida/Valor");
      }
      return strRetorno;
 }



 function retValXml(url){
    var strRetorno = "";
     if ( (isIE() && getVersionIE() <= 11)  ){
        strRetorno = retValXmlbk(url);
     }else{
        $.ajax({
            type: "GET",
            async: false,
            url: url,
            cache: false,
            dataType: "xml",
            success: function(xml) {
                strRetorno = GetField(xml,"/Valida/Valor");
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert(textStatus);            
            }
        });
     }    
    return strRetorno;
 }

 
 function dateDiff(strDate1,strDate2){

  var date1 = strDate1;
  var date2 = strDate2;
  date1 = date1.split("/");
  date2 = date2.split("/");

  var datDate1 = new Date(date1[2]+"/"+date1[1]+"/"+date1[0]);
  var datDate2 = new Date(date2[2]+"/"+date2[1]+"/"+date2[0]);

  //var daysApart = Math.abs(Math.round((datDate1-datDate2)/86400000));  
  var daysApart = Math.round((datDate1-datDate2)/86400000);  
  return daysApart;
}

function validaObj(obj,tip) {  
 if (tip=="t"){
    obj.value=Trim(obj.value);
  if (obj.value==""){
    alert("Ingrese el valor correspondiente");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }

 if (tip=="nc"){ //no cero
    obj.value=Trim(obj.value);
  if (obj.value=="" || parseFloat(obj.value)=="0"){
    alert("Ingrese un valor numérico mayor a 0");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }
  
  if (tip=="s"){
  if (obj.value=="-1" || obj.value=="00" || obj.value=="0" || obj.value==""){
    alert("Debe seleccionar por lo menos un elemento de la lista");
    if (obj.disabled==false) obj.focus();
    return false;
    }
  }

  if (tip=="sm"){
  if (obj.options.length<=0){
    alert("No hay elementos en la lista");
    if (obj.disabled==false) obj.focus();
    return false;
  }
  }

  if (tip=="chk"){
      x=false;      
      if (obj.length>1)  {
      	for(i=0;i<obj.length;i++){
            if(obj[i].checked){
		x=true;
		break;  
	    }		
        }
      }else{
        if(obj.checked)
           x=true;
      }

	if (x==false){
	    alert("No ha seleccionado items");
	    return false;
	}
  }

    return true;  
}

function redondear(cantidad, decimales) 
{
    var cantidad = parseFloat(cantidad);
    var decimales = parseFloat(decimales);
    decimales = (!decimales ? 2 : decimales);
    return Math.round(cantidad * Math.pow(10, decimales)) / Math.pow(10, decimales);
} 

// 001-020 - End
// RQ2015-000750 Inicio
function validarEmail(ObjName) {
  var expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  var obj=eval('document.forms[0].' + ObjName);
  obj.value=Trim(obj.value);
  if ( !expr.test(obj.value) ){
    alert("Error: La dirección de correo " + obj.value + " es incorrecta.");
    if (obj.disabled==false) obj.focus();
    return false;
  }
  return true;
}
// RQ2015-000750 Fin