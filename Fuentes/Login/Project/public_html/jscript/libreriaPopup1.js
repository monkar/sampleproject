<!--
  var w1 = null;
  var w2 = null;
  var w3 = 0;
  var codigocom = null;
  var w5 = "";

  function y2k(number)    { return (number < 1000) ? number + 1900 : number; }
  function padout(number) { return (number < 10) ? '0' + number : number; }

  var today = new Date();
  var day = today.getDate(), month = today.getMonth(), year = y2k(today.getYear()), whichOne = 0;

  function restart() {
      document.form1.elements['fecha' + whichOne].value = '' + padout(day) + '/' + padout(month - 0 + 1) + '/' + year;
      mywindow.close();
  }

  function newWindow(number) {
      whichOne = number;
      day = today.getDate(), month = today.getMonth(), year = y2k(today.getYear());
      mywindow=open('cal.htm','myname','resizable=no,width=270,height=200');
      mywindow.location.href = 'cal.htm';
      var_msg = mywindow.opener;
      if (mywindow.opener == null) mywindow.opener = self;
      //if (var_msg == "null" || var_msg == "undefined" ) mywindow.opener = self;
      mywindow.window.focus()
  }

  function popUp1(codcombox,nomcombox)
  {
	if (w1 != null)
		w1.close();
	// El comportamiento de scrollbars=yes varía según el navegador. En IE aparece siempre aunque hayan
	// pocos datos. En dicho caso la barra vertical está en color "gris desactivado".
	// w1 = window.open("popup1.html", "popUp1", "scrollbars=yes,height=225,width=250,left=250,top=200");
	w1 = null;
	w3 = document.form1.series.value.length;
	codigocom = document.form1.series.value;	
	if (w3 == 0) {
		alert("Debe elegir una provincia");
		document.form1.series.focus();
		}
	else
	  {
 	   //alert(codigocom);
       //w1 = window.open("distrito.asp?codpro="+w4, "popUp1", "fullscreen=yes height=225,width=250,left=100,top=100");
       //resizeTo(300,300);
       //w1.focus();
       w5 = "distrito.asp?codpro=" + codigocom + "&codcombox=" + codcombox+ "&nomcombox=" + nomcombox
       w1 = window.open(w5,"popUp1", "height=225,width=250,left=100,top=100");

	}
  }

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}

//-->
