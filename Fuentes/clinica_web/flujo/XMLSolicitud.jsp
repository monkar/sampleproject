<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page contentType="text/xml;charset=UTF8"%>
<jsp:useBean id="XML" class="com.clinica.beans.XML" scope="session"/>
<jsp:useBean id="CoberturaSel" class="com.clinica.beans.Cobertura" scope="session"/>
<%
  
//INI - REQ 0389-2011 BIT/FMG
String strNroAutoriza = Tool.getString(request.getParameter("pnautoriza"));      
response.setHeader("Content-Disposition", "attachment; filename=\"POS"+ strNroAutoriza + ".xml\"");
//FIN - REQ 0389-2011 BIT/FMG

/*PRT seteamos los campos para valor de deducciones de cobertura
*/
String deducibleDias=CoberturaSel.getStrCantidad();
String deducibleMonto=Tool.toDecimal(Tool.parseDouble(CoberturaSel.getStrImpDeducible()),2);
String deduciblePorcentaje=CoberturaSel.getStrDeducible();
//se tomara un solo valor de las tres y segun ese valor se seteara
/*
1 Unidad
2 Monto
3 Porcentaje
*/
String[] ValorDed={deducibleDias,deducibleMonto,deduciblePorcentaje};
/*si uno de ellos no es cero*/
//pintar el que no sea cero
        int i=0;// indice para que corra el while
        String impTipoValorDed="";
        //recorre el array, en busqeuda del valor existente
        String impValorDed="";
        while(i < ValorDed.length){
            //encuentra un valor existente
            //solo un valor de las tres puede ser cero            
            if((!(ValorDed[i].equalsIgnoreCase("0")))&&(!(ValorDed[i].equalsIgnoreCase("0.00")))){            
              //asigna el valor del array a ValorDed[i] para que pinte en blanco en caso no encuentre valores diferentes a cero
              impValorDed=ValorDed[i];
              break;
            }
            i++;//suma uno para recorrer el siguiente elemento del array
        }
        switch(i){
          //en caso de que sea en la posicion 0 del arreglo pinta Unidad
          case 0:impTipoValorDed="1";break;
          //en caso de que sea en la posicion 0 del arreglo pinta Monto
          case 1:impTipoValorDed="2";break;
          //en caso de que sea en la posicion 0 del arreglo pinta Porcentaje
          case 2:impTipoValorDed="3";break;
          default: // El default es para cuando no se ejecuto ninguna de las otras opciones
            impTipoValorDed="";break;          
        }
        //lo setamos en el Bean XML
        XML.setImp_tipo_valor_ded(impTipoValorDed);
        XML.setImp_valor_ded(impValorDed);
        request.setAttribute("objXml", XML);
%>
<jsp:include page="../flujo/XML.jsp" />