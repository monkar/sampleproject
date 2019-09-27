 //Funcion que dibuja opciones de tabs

   function VerTabs(byval xTab,byval wCadena)
   dim i
   wArrTab=split(wCadena,",")
   	for i=0 to uBound(wArrTab)
		if i=cint(xTab) then
			document.Write "<td width='10'><img src='../images/L2_izq.gif'></td>"
			document.Write "<td width='73' class='Tab' align='center'><b class='textColumna'>" & wArrTab(i) & "</b></td>"
			document.write "<td width='10'><img src='../images/L2_der.gif'></td>"
		else
			document.Write "<td width='10'><img src='../images/L1_izq.gif'></td>"
			document.Write "<td width='73' background='../images/L1_back.gif' align='center'><a href='javascript: IrTab(" & i & ");'><b>" & wArrTab(i) & "</b></a></td>"
			document.Write "<td width='10'>	<img src='../images/L1_der.gif'></td>"
		end if
	next
    end function
//Funcion que valida numeros
    Sub Numero(ObjetoSiguiente)
	KeyAscii = window.event.keyCode
	window.event.keyCode = 0
	If Not (KeyAscii=44 or KeyAscii=46 or (KeyAscii >= 48 And KeyAscii<=57))Then
		If (KeyAscii = 13) And Not IsNull(ObjetoSiguiente) Then ObjetoSiguiente.focus()		
		window.event.returnValue = 0
	Else
		window.event.keycode = KeyAscii
	End if
    End Sub


Sub Mayuscula()
	KeyAscii = window.event.keyCode
	window.event.keyCode = 0	
	window.event.keycode = asc(ucase(chr(KeyAscii)))
End Sub

Sub FmtFecha(Objeto,ObjetoSiguiente)
	KeyAscii = window.event.keyCode
	window.event.keyCode = 0
	If Len(Objeto.value) = 1 Or Len(Objeto.value)=4 Then
		If KeyAscii<48 or KeyAscii>57 then
			window.event.Keycode = 0
		Else
			window.event.keyCode = asc("/")
			Objeto.value= Objeto.value+chr(KeyAscii)
		End If
	Else
		If KeyAscii<48 or KeyAscii>57 then 
			window.event.Keycode = 0	
			If keyascii=13 Then			
				If Not IsNull(ObjetoSiguiente) Then	ObjetoSiguiente.focus()
			End If			
		Else 
			window.event.Keycode = KeyAscii			
		End If
	End If
End Sub

function FmtEdad(ffecha)
fEdad=""
if isdate(ffecha) then
fEdad=0
	annio=datediff("yyyy",ffecha,Date)
	mes=datediff("m",dateadd("yyyy",annio,ffecha),Date)
	dia=datediff("d",dateadd("yyyy",annio,ffecha),Date)
	if 	annio>=0 then 
		if mes>=0 and dia>=0 then fEdad=annio
		if mes>=0 and dia<0 then fEdad=annio-1
		if mes<0 then fEdad=annio-1
	end if	
end if
FmtEdad=fEdad
End function
