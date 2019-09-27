<%@ page contentType="text/xml;charset=UTF8"%>
<jsp:useBean id="SolicitudSel" class="com.clinica.beans.Solicitud" scope="session"/>

<%@ page import="java.io.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.awt.Color"%>
<%@ page import="com.clinica.utils.*"%>
<%@ page import="com.clinica.service.*"%>
<%@ page import="com.clinica.beans.*"%>
<%@ page import="com.clinica.beans.Cliente"%>
<%@ page import="com.clinica.controller.*"%>
<%@ page import="com.clinica.controller.ProcesoAtencion"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.util.ArrayList"%>
<%
           
      //Instanciando el objeto que va acceder a los metodos Daos.
      Atencion atencion = new Atencion();
      GestorPolClinic gestorPolClinic = new GestorPolClinic();
      
      /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 09:32am*/ 
      GestorSolicitud gc = new GestorSolicitud();
      
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:25pm
      GestorClinica gestorClinica = new GestorClinica();
      
      /*Instanciando,para acceder a los Datos  yahirRivas 02MAR2012 12:23am*/ 
      GestorCliente gestorCliente = new GestorCliente();
      
      try{
             
                 
                  XML objXml=new XML();
                  String strNroautoriza = Tool.getString(request.getParameter("pnautoriza"));
                  /*PRT se obtiene la información del siniestro
                  * desde web_cli_log en base al numero de sienstro
                  */
                  Bean objAten = atencion.getSiniestroLog(strNroautoriza);
                  
                  int intRamo = Tool.parseInt(objAten.getString("1"));
                  int intPoliza = Tool.parseInt(objAten.getString("2"));
                  int intCertif = Tool.parseInt(objAten.getString("3"));
                  String strCobertura = objAten.getString("4");
                  String strCodCliente = objAten.getString("5");
                  //PRT Se obtienen los datos de la clinica
                  String strWebServer = objAten.getString("6");
                  String strFecha = objAten.getString("19");
                  //PRT recogemos el codigo y el nombre de la clinica 
                  String strNomClinica = gestorClinica.getClinica(strWebServer).getString("2");
                  
                  //PRT Se obtienen los datos del cliente asociado a la solicitud de carta
                  Cliente objCliente = new Cliente();
                  Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer,intRamo);
                  //PRT los setea
                  objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);
                              
                  BeanList bl=atencion.getClienteVT("", "",objCliente.getStrCodigo());
                  int intSexo=0;
                  String strDni="";
                  String strRuc="";
                  String strNombres="";
                  String strApePat="";
                  String strApeMat="";
                  String strFecNac="";
                  String strDniTit = "";
                  String strRucTit = "";
                  String strNombresTit = "";
                  String strApePatTit = "";
                  String strApeMatTit = "";  
                              
                  for(int i=0;i<bl.size();i++)
                  {  
                      intSexo = Tool.parseInt(bl.getBean(i).getString("5").trim());//PRT Recoge el campo SSEXCLIEN_TMP
                      strDni = bl.getBean(i).getString("8").trim(); //PRT Recoge el campo SDNI_TMP                      
                      strRuc =bl.getBean(i).getString("9").trim(); //PRT Recoge el campo SRUC_TMP                      
                      strNombres = bl.getBean(i).getString("34").trim(); //PRT Recoge el campo SFIRSTNAME_TMP                      
                      strApePat = bl.getBean(i).getString("32").trim(); //PRT Recoge el campo SLASTNAME_TMP
                      strApeMat = bl.getBean(i).getString("33").trim(); //PRT Recoge el campo SLASTNAME2_TMP
                      strFecNac=bl.getBean(i).getString("4").trim();//PRT Recoge el campo DBIRTHDAT_TMP
                  }
                  
                  //PRT seteo segun requerimiento
                  if (intSexo == 1)  
                  {
                    objCliente.setIntCodSexo(2);
                  }
                  if (intSexo == 2) 
                  {
                    objCliente.setIntCodSexo(3);
                  }
                  objCliente.setStrDni(strDni);
                  if((strDni!="")||(strDni!=null))
                  {                            
                      objCliente.setStrIdeDocIdentidad("2");
                  }else
                  {
                      objCliente.setStrIdeDocIdentidad("1");
                  }                
                  /*PRT
                  * Se obtiene los datos del titular de acuerdo su codigo de asegurado en VisualTime*/
                  BeanList blTit = atencion.getTitularVT("", "", objCliente.getStrCodTitular());                
                  
                  for(int i=0;i<blTit.size();i++)
                  {     
                    strDniTit = blTit.getBean(i).getString("8").trim(); //SDNI_TMP
                    strRucTit = blTit.getBean(i).getString("9").trim(); //SRUC_TMP
                    strNombresTit = blTit.getBean(i).getString("34").trim(); //SFIRSTNAME_TMP
                    strApePatTit = blTit.getBean(i).getString("32").trim(); //SLASTNAME_TMP
                    strApeMatTit =     blTit.getBean(i).getString("33").trim(); //SLASTNAME2_TMP
                  }
              
                    
                    
                  //PRT Se obtiene la cobertura seleccionada para la solicitud
                  Cobertura CoberturaSel = null;
                  CoberturaSel=new Cobertura();
                  ArrayList lstCobertura = gestorPolClinic.getLstCobertura(objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                                          objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                          objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                                          strCodCliente, objCliente.getIntCodEstado(),intRamo,0);    
                  
                  /*PRT Los resultados de este seteo son varios registros razon por la cual se prefirio poner los resulrados del seto dentro del ciclo FOR
                  */    
                  for(int i=0; i<lstCobertura.size(); i++)
                  {
                      CoberturaSel = (Cobertura)lstCobertura.get(i);
                      if((CoberturaSel.getStrImpDeducible().trim()).equals(objAten.getString("12").trim())){                
                              //PRT se obtiene un registro que contenga un importededu existente diferente de cero
                              //de esta forma este registro es setado como los datos para la cobertura
                              break;
                      }       
                  }
      
                  Solicitud objSolicitud = gc.getDatosSolicitud(objAten.getString("8").trim());
                  //PRT
                  //tomado desde anexo1 del requerimiento 2009-1220
                  String ideTipoDocAdmision=null;;
                  
                  if((objSolicitud.getNIDTIPOSOLICITUD()==0)){//Si es Carta de Autorizacion
                    ideTipoDocAdmision="1";//PRT  SOLICITUD DE BENEFICIOS
                  }else{
                    ideTipoDocAdmision="6";//TIPO DE AUTORIZACION: OTRO, segun ANEXO de requerimiento
                  }
      
                  //PRT Inicio de seteo de Valor deducible
                  String deducibleDias="";
                  String deducibleMonto="";
                  String deduciblePorcentaje="";
                  
                  if((objAten.getString("12").trim()).equalsIgnoreCase(CoberturaSel.getStrCantidad().trim())){
                    deducibleDias=objAten.getString("12").trim();
                    CoberturaSel.setStrCantidad(deducibleDias);
                    
                  }
                  if((objAten.getString("12").trim()).equalsIgnoreCase(CoberturaSel.getStrImpDeducible().trim())){
                    deducibleMonto=objAten.getString("12").trim();
                    CoberturaSel.setStrImpDeducible(deducibleMonto);
                    
                  }
                  if((objAten.getString("12").trim()).equalsIgnoreCase(CoberturaSel.getStrDeducible().trim())){
                    deduciblePorcentaje=objAten.getString("12").trim();
                    CoberturaSel.setStrDeducible(deducibleMonto);
                    
                  }
                  
                  //se tomara un solo valor de las tres y segun ese valor se seteara
                  /*
                  1 Unidad
                  2 Monto
                  3 Porcentaje
                  */
                  deducibleDias=CoberturaSel.getStrCantidad().trim();
                  deducibleMonto=CoberturaSel.getStrImpDeducible().trim();
                  deduciblePorcentaje=CoberturaSel.getStrDeducible().trim();
                  String[] ValorDed={deducibleDias,deducibleMonto,deduciblePorcentaje};
                  int j=0;// indice para que se ejecute el ciclo while
                  String ideTipoValorDed="";
                  //recorre el array, en busqeuda del valor existente
                  String impValorDed="";
                  while(j < ValorDed.length){
                      //encuentra un valor existente
                      //SOLO UN VALOR DE LAS TRES PUEDE SER DIFERENTE DE CERO                   
                      if((!(ValorDed[j].equalsIgnoreCase("0")))&&(!(ValorDed[j].equalsIgnoreCase("0.00")))){            
                        //asigna el valor del array a ValorDed[j] para que lo setee en blanco en caso no encuentre valores diferentes a cero
                        impValorDed=ValorDed[j];
                        break;
                      }
                      j++;//suma uno para recorrer el siguiente elemento del array
                  }        
                  switch(j){
                    //en caso de que sea en la posicion 0 del arreglo pinta Unidad
                    case 0:ideTipoValorDed="1";break;
                    //en caso de que sea en la posicion 0 del arreglo pinta Monto
                    case 1:ideTipoValorDed="2";break;
                    //en caso de que sea en la posicion 0 del arreglo pinta Porcentaje
                    case 2:ideTipoValorDed="3";break;
                    default: // El default es para cuando no se ejecuto ninguna de las otras opciones
                      ideTipoValorDed="";break;          
                  }
                  //lo setamos en el Bean XML
                  objXml.setImp_tipo_valor_ded(ideTipoValorDed);
                  objXml.setImp_valor_ded(impValorDed);   

                  //PRT Fin de seteo de Valor deducible        
                  String flgIgvValorDed=String.valueOf(SolicitudSel.getDblFactorIgv());
                  if((flgIgvValorDed!="")||(flgIgvValorDed!=null)){
                    SolicitudSel.setFlgIgvValorDed("1");
                  }else{
                    SolicitudSel.setFlgIgvValorDed("0");
                  }


        
                  //PRT mapeamos el parentesco con respecto al anexo 3 del AF2009-2010
                  String codParentesco=atencion.getParentesco(objCliente.getIntCodParentesco());                                       
                  /*si tiene valor le pongo 2*/
                  if ((strDniTit != "") || (strDniTit != null)) {
                    objCliente.setStrIdeDocIdentidadTitular("2");
                  } else {
                    /*si no tiene valor le pongo 1*/
                    objCliente.setStrIdeDocIdentidadTitular("1");
                  }                        
                  //Seteo de los datos en el Bean XML
                  objXml.setTip_doc_autorizacion(String.valueOf(ideTipoDocAdmision));
                  objXml.setCod_autorizacion(objAten.getString("8"));
                  //PRT Inicia formato de fechas
                  String fecAutorizacion = objAten.getString("19");
                  DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                  long fechaAutorizacion = df.parse(fecAutorizacion).getTime();
                  Date fecha = new Date(fechaAutorizacion);        
                  SimpleDateFormat formatoFecAutoriz = new SimpleDateFormat("yyyyMMdd");              
                  objXml.setFec_autorizacion(formatoFecAutoriz.format(fecha));
                  //PRT Fin de formato de fechas                               
                  objXml.setDes_asegurado_codigo(objCliente.getStrCodigo());                
                  objXml.setDes_paterno_asegurado(strApePat);
                  objXml.setDes_materno_asegurado(strApeMat);
                  objXml.setDes_nombre_asegurado(strNombres);
                  objXml.setIde_sexo(String.valueOf(objCliente.getIntCodSexo()));
                  //PRT Inicia formato de fecha de nacimiento del asegurado                  
                  DateFormat df1 = new SimpleDateFormat("dd/MM/yyyy");
                  long fechaNacimiento = df1.parse(strFecNac).getTime();
                  Date fechaNac = new Date(fechaNacimiento);        
                  SimpleDateFormat formatoFecNac = new SimpleDateFormat("yyyyMMdd");                  
                  objXml.setFec_nacimiento_asegurado(formatoFecNac.format(fechaNac));
                  //PRT Fin de formato de fecha de nacimiento del asegurado
                  
                  
                  objXml.setIde_doc_identidad(objCliente.getStrIdeDocIdentidad());
                  objXml.setNum_doc_identidad_asegurado(objCliente.getStrDni());                
                  objXml.setIde_parentesco(codParentesco);    
                  //Se setean los datos para el titular
                  objXml.setDes_paterno_titular(strApePatTit);
                  objXml.setDes_materno_titular(strApeMatTit);
                  objXml.setDes_nombre_titular(strNombresTit);
                  objXml.setIde_doc_identidad_titular(objCliente.getStrIdeDocIdentidadTitular());
                  objXml.setNum_doc_identidad_titular(strDniTit);
                  objXml.setDes_razon_social_contratante(objCliente.getStrContratante());                
                  objXml.setNum_ruc_contratante(strRucTit);
                  
                  /*
                   *PRT cobertura 
                   * */                
                  objXml.setCod_beneficio(String.valueOf(CoberturaSel.getIntCover()));
                  objXml.setDes_beneficio(CoberturaSel.getStrNomCobertura());
                  objXml.setIde_moneda_ded(String.valueOf(objCliente.getIntCodMoneda()));                                                                
                  objXml.setFlg_igv_valor_ded(SolicitudSel.getFlgIgvValorDed());
                  objXml.setPor_coa(objAten.getString("14"));                
                  
                  /*
                   *PRT exlusiones 
                   * */          
                  objXml.setIde_tipo_codif_diag("1");
                  objXml.setRef_codif_diag(objSolicitud.getIntCodDiagnos());
                  
                  
                  //PRT Inicio de Descripcion
                  String strDescripcion="";  
                  String strCodEnf = "";
                  
                  BeanList blExcl = new BeanList();
                 
                 
                  
                  blExcl = atencion.getLstExclusion(objCliente.getIntPoliza(),objCliente.getIntCertificado(),objCliente.getStrCodigo(),intRamo);
                              
                  if(blExcl.size()>0)
                  {
                      strDescripcion=(String)blExcl.getBean(blExcl.size()-1).getString("2").trim();
                  }else
                  {
                      strDescripcion="";
                  }                
                  //PRT Fin de Descripcion
                  
                  //PRT creamos el request para obtener los datos desde el Bean XML
                  request.setAttribute("objXml", objXml);
                  
%>

<jsp:include page="../flujo/XML.jsp" />

<%                  
              }catch(Exception  e)
              {
                  //PRT dirigimos a una pagina que muestre mensaje
                  response.sendRedirect(request.getContextPath()+"/flujo/Mensaje.jsp");
              }
%>