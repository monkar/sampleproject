package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.GestorSolicitud;
import com.clinica.service.*;

import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Tool;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.StringTokenizer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;

public class ProcesoXML extends HttpServlet 
{
  
  private static final String CONTENT_TYPE = "text/html; charset=UTF8";
  //private HttpSession session; ======> Agregado
  //private Usuario objClinica = null;   ======> Agregado
  //private String strNroAutoriza = ""; ======> Agregado
  //private String strWebServer = ""; ======> Agregado
  
      //Instanciando el objeto que va acceder a los metodos Daos.
      //Atencion atencion = new Atencion(); ======> Agregado
      //GestorPolClinic gestorPolClinic = new GestorPolClinic(); ======> Agregado
      //GestorSolicitud gc = new GestorSolicitud(); ======> Agregado
          
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 10:56am
      //GestorCliente gestorCliente = new GestorCliente(); ======> Agregado
    
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:25pm
      //GestorClinica gestorClinica = new GestorClinica(); ======> Agregado
       
  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  //INI - REQ 2011-0389 BIT/FMG
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    doPost(request,response);
  }
  //FIN - REQ 2011-0389 BIT/FMG
  
  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {  
      Usuario objClinica = null;
      String strNroAutoriza = "";
      String strWebServer = "";
      Atencion atencion = new Atencion();
      GestorPolClinic gestorPolClinic = new GestorPolClinic();
      GestorSolicitud gc = new GestorSolicitud();
      GestorCliente gestorCliente = new GestorCliente();      
      GestorClinica gestorClinica = new GestorClinica();
      
      try
      {          
              HttpSession session = request.getSession(true);
              synchronized(session)
              {
                objClinica = (Usuario) session.getAttribute("USUARIO");
              }  
                  
              XML xml=new XML();
    
              if ("".equals(strWebServer) || strWebServer == null)
              {
                  strWebServer = objClinica.getStrWebServer();  
              }
              strNroAutoriza = Tool.getString(request.getParameter("pnautoriza"));              
              int intTransac = Tool.parseInt(request.getParameter("pntransac"));
    
              //PRT Se obtiene los datos asociados alsiniestro de solicitud, es decir
              //se obtiene la informaci?n del siniestro
              Bean objBean = atencion.getSiniestroLog(strNroAutoriza);
              //PRT Se obtienen los datos de la clinica
              String strWServer = objBean.getString("6");              
              String strNomClinica = gestorClinica.getClinica(strWebServer).getString("2");//NUEVO
              
              int intRamo = Tool.parseInt(objBean.getString("1")); // Agregado para proyecto Apple
              int intPoliza = Tool.parseInt(objBean.getString("2"));
              int intCertif = Tool.parseInt(objBean.getString("3"));
              String strCodCliente = objBean.getString("5");
              String strCobertura = objBean.getString("4");
                  
              int tipodesolicitud = Tool.parseInt(objBean.getString("18"));            
    
              //PRT Se obtienen los datos del cliente asociado a la solicitud de carta
              Cliente objCliente = new Cliente();      
            
              //Recojemos la sesion DatoCliente
            synchronized(session)
              {
                      session.setAttribute("DatoCliente",objCliente);
              } 
    
              /*
              *PRT Se obtiene los datos de la cobertura asociada a la solicitud de carta
              */
              Cobertura objCobertura = null;
              System.out.println("ProcesoXML :"+objCliente.getIntProducto());
              ArrayList lstCobertura = gestorPolClinic.getLstCobertura(objCliente.getIntProducto(), objCliente.getIntCodPlan(),//objCliente.getIntCodPlan(),
                                      objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                      objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWServer,//strWebServer,
                                      strCodCliente, objCliente.getIntCodEstado(),intRamo,0);
              
              for(int i=0; i<lstCobertura.size(); i++)
              {
                  objCobertura = (Cobertura)lstCobertura.get(i);
                  if (objCobertura.getIntCover() == Tool.parseInt(strCobertura))
                  break;                  
              }                
              
            
              objCobertura = gestorPolClinic.getCoberSin(objBean,intPoliza,intCertif,intRamo);
                  
                  
              if (objCobertura != null)   
              {    
                  synchronized(session)
                  {
                    session.setAttribute("CoberturaSel",objCobertura);
                  }  
              }

              Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer,intRamo);
                gestorCliente.setCliente(objAtencion,strCodCliente);
    
              BeanList bl=atencion.getClienteVT("", "",objCliente.getStrCodigo());
              int intSexo=0;
              String strDni="";
              String strRuc="";
              String strNombres="";
              String strApePat="";
              String strApeMat="";
              String strFecNac="";
              for(int i=0;i<bl.size();i++)
              {
                    intSexo = Tool.parseInt(bl.getBean(i).getString("5").trim());
                    strDni = bl.getBean(i).getString("8").trim();                       
                    strRuc = bl.getBean(i).getString("9").trim();                      
                    strNombres = bl.getBean(i).getString("34").trim();                      
                    strApePat = bl.getBean(i).getString("32").trim();                      
                    strApeMat = bl.getBean(i).getString("33").trim(); 
                    strFecNac=bl.getBean(i).getString("4").trim();
              }                
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
              }else{
                          objCliente.setStrIdeDocIdentidad("1");
              }                
              objCliente.setStrRuc(strRuc);
              objCliente.setStrApePat(strApePat);
              objCliente.setStrApeMat(strApeMat);
              objCliente.setStrNomb(strNombres);                
              objCliente.setStrFecNac(strFecNac);
              
              //mapeamos el parentesco con respecto al anexo 3 del AF2009-2010
              String codParentesco=atencion.getParentesco(objCliente.getIntCodParentesco());              
              objCliente.setStrCodParentesco(codParentesco);
              
              /*PRT
               * Se obtiene los datos del titular de acuerdo su codigo de asegurado en VisualTime*/
              BeanList blTit = atencion.getTitularVT("", "", objCliente.getStrCodTitular());                
              String strDniTit = "";
              String strRucTit = "";
              String strNombresTit = "";
              String strApePatTit = "";
              String strApeMatTit = "";                
              for(int i=0;i<blTit.size();i++){     
                  strDniTit=
                          blTit.getBean(i).getString("8").trim();
                  strRucTit =
                          blTit.getBean(i).getString("9").trim();
                  strNombresTit =
                          blTit.getBean(i).getString("34").trim();
                  strApePatTit =
                          blTit.getBean(i).getString("32").trim();
                  strApeMatTit =
                          blTit.getBean(i).getString("33").trim();
              }
              //Se setean los datos para el titular
              objCliente.setStrDniTitular(strDniTit);
              objCliente.setStrRucTitular(strRucTit);
              objCliente.setStrApePatTitular(strApePatTit);
              objCliente.setStrApeMatTitular(strApeMatTit);
              objCliente.setStrNombTitular(strNombresTit);
              /*si tiene valor le pongo 2*/
              if ((strDniTit != "") || (strDniTit != null)) {
                  objCliente.setStrIdeDocIdentidadTitular("2");
              } else {
                  /*si no tiene valor le pongo 1*/
                  objCliente.setStrIdeDocIdentidadTitular("1");
              }
    
              int intEstadoDeudaCliente = atencion.getEstadoCliente(intPoliza,intCertif,intRamo); //Se agrego el codigo "intRamo"
              objCliente.setIntEstadoDeuda(intEstadoDeudaCliente);
              
              synchronized(session)
              {
                session.setAttribute("DatoCliente",objCliente);                
              }  

              int intProducto= objCliente.getIntProducto();
              int intTariff=objCliente.getIntCodPlan();
              int intCurrency=objCliente.getIntCodMoneda();
              int intRelation=objCliente.getIntCodParentesco();
              String strSexo=objCliente.getStrCodExtSexo();
              String strClinica=strWServer;
              int intEstado=objCliente.getIntCodEstado();

              Solicitud objSolicitud = gc.getDatosSolicitud(strNroAutoriza);                
              Presupuesto objPresupuesto = null;                
              if (intTransac > 0){
                 objSolicitud.getObjSolhis().setNTRANSAC(intTransac);                   
              }
              
              if (objSolicitud.getObjSolhis().getNTRANSAC() > 0)
              { 
                  objPresupuesto = gc.getPresupuesto(objSolicitud.getNIDSOLICITUD(),objSolicitud.getObjSolhis().getNTRANSAC());
              }
              else
              {
                  objPresupuesto = gc.getPresupuesto(objSolicitud.getNIDSOLICITUD(),1);
              }
              objSolicitud.setObjPresupuesto(objPresupuesto);  
              
              //Se busca la ultima transaccion de registro en Insunix
              int intTransaccion = gc.validaTransaccion(objSolicitud.getObjSolhis().getNTRANSAC(),objSolicitud.getNIDSOLICITUD());
              
              synchronized(session)
              {
                session.setAttribute("SolicitudSel",objSolicitud);
              }  
              
              //PRT Inicio para seteo de ideTipoDocAdmision
              //tomado desde anexo1 del requerimiento 2009-1220
              int ideTipoDocAdmision=0;
              if(objSolicitud.getNIDTIPOSOLICITUD()==1)
              {//Si es Carta de Autorizacion
                ideTipoDocAdmision=6;//PRT  OTRO TIPO DE AUTORIZACION
              }
              else if(objSolicitud.getNIDTIPOSOLICITUD()==2)
              {//PRT si es Carta de Garantia
                ideTipoDocAdmision=3;
              }else
              {
                ideTipoDocAdmision=6;
              }
              //PRT Fin de seteo de ideTipoDocAdmision
              
              xml.setTip_doc_autorizacion(String.valueOf(ideTipoDocAdmision));
              xml.setCod_autorizacion(strNroAutoriza); //REQ 2011-0389 BIT/FMG      
              
              //PRT Inicia formato de fechas
              String fecAutorizacion = objSolicitud.getDFECHAREG();
              DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
              //INI - REQ 2011-0389 BIT/FMG
              if("".equals(fecAutorizacion))
              {                
                Bean objAten = atencion.getSiniestroLog(strNroAutoriza);
                fecAutorizacion = objAten.getString("19");                
              }
              //FIN - REQ 2011-0389 BIT/FMG
              long fechaAutorizacion = df.parse(fecAutorizacion).getTime();
              Date fecha = new Date(fechaAutorizacion);        
              SimpleDateFormat formatoFecAutoriz = new SimpleDateFormat("yyyyMMdd");
              xml.setFec_autorizacion(formatoFecAutoriz.format(fecha));
              //PRT Fin de formato de fechas
              
              xml.setDes_asegurado_codigo(objCliente.getStrCodigo());                
              xml.setDes_paterno_asegurado(objCliente.getStrApePat());
              xml.setDes_materno_asegurado(objCliente.getStrApeMat());
              xml.setDes_nombre_asegurado(objCliente.getStrNomb());
              xml.setIde_sexo(String.valueOf(objCliente.getIntCodSexo()));
              //PRT Inicia formato de fecha de nacimiento del asegurado                  
              DateFormat df1 = new SimpleDateFormat("dd/MM/yyyy");
              long fechaNacimiento = df1.parse(strFecNac).getTime();
              Date fechaNac = new Date(fechaNacimiento);        
              SimpleDateFormat formatoFecNac = new SimpleDateFormat("yyyyMMdd");                  
              xml.setFec_nacimiento_asegurado(formatoFecNac.format(fechaNac));
              //PRT Fin de formato de fecha de nacimiento del asegurado              
              xml.setIde_doc_identidad(objCliente.getStrIdeDocIdentidad());
              xml.setNum_doc_identidad_asegurado(objCliente.getStrDni());                
              xml.setIde_parentesco(objCliente.getStrCodParentesco());             
              xml.setDes_paterno_titular(objCliente.getStrApePatTitular());
              xml.setDes_materno_titular(objCliente.getStrApeMatTitular());
              xml.setDes_nombre_titular(objCliente.getStrNombTitular());                
              xml.setIde_doc_identidad_titular(objCliente.getStrIdeDocIdentidadTitular());
              xml.setNum_doc_identidad_titular(objCliente.getStrDniTitular());
              xml.setDes_razon_social_contratante(objCliente.getStrContratante());                
              xml.setNum_ruc_contratante(objCliente.getStrRucTitular());
              
              /*
               *PRT cobertura 
               * */                
              xml.setCod_beneficio(String.valueOf(objCobertura.getIntCover()));
              xml.setDes_beneficio(objCobertura.getStrNomCobertura());
              xml.setIde_moneda_ded(String.valueOf(objCliente.getIntCodMoneda()));                
              double flgIgvValorDed=objSolicitud.getDblFactorIgv();
              if(objSolicitud.getDblFactorIgv()!=0.00)
              {
                xml.setFlg_igv_valor_ded("1");
              }else
              {
                xml.setFlg_igv_valor_ded("0");
              }
              xml.setPor_coa(objCobertura.getStrCoaseguro());                
              
              /*
               *PRT exlusiones 
               * */          
              xml.setIde_tipo_codif_diag("1");
              xml.setRef_codif_diag(objSolicitud.getIntCodDiagnos());
              
              
              //PRT Inicio de Descripcion
              String strDescripcion="";  
              String strCodEnf = "";
              
                 /* YahirRivas 29FEB2012  esta llamando a un servlet podría haber conflicto
                  * , lo que se hizo fue crear un metodo dentro de este servlet */        
       //       ProcesoAtencion objRq = new ProcesoAtencion();
              BeanList blExcl = new BeanList();
             
              blExcl = getLstExclusion(objCliente.getIntPoliza(),objCliente.getIntCertificado(),objCliente.getStrCodigo(), atencion);
                          
              if(blExcl.size()>0)
              {
                  strDescripcion=(String)blExcl.getBean(blExcl.size()-1).getString("2").trim();
              }else
              {
                  strDescripcion="";
              }                
              //PRT Fin de Descripcion
              
              xml.setDes_exclusion(strDescripcion);
              //PRT creamos la sesion para obtener los datos desde el Bean XML
              synchronized(session)
              {
                session.setAttribute("XML", xml);                
              }  
              response.sendRedirect(request.getContextPath()+"/flujo/XMLSolicitud.jsp?pnautoriza=" + strNroAutoriza); //REQ 2011-0389 BIT/FMG
      }
      catch(Exception e){
              //PRT dirigimos a una pagina que muestre mensaje
                  response.sendRedirect(request.getContextPath()+"/flujo/Mensaje.jsp");
                  System.out.print("error" + e.getMessage());
      }
  }
  
   public BeanList getLstExclusion(int intPoliza, int intCertif, String strCodCliente, Atencion atencion)
  {
     int intRamo = 23;
      BeanList objLista = null;      
      BeanList objLstExcl = null;
      objLista = atencion.lstExclusion(intRamo, intPoliza, intCertif, strCodCliente, Tool.getDateIfx());
      if (objLista!=null){
          objLstExcl = new BeanList();
          Exclusion objExcl = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
            strTrama = objLista.getBean(i).getString("1");
            stkTrama = new StringTokenizer(strTrama, "|");
            objExcl = new Exclusion();
            if (stkTrama.hasMoreTokens())
              objExcl.setStrCodEnfermedad(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objExcl.setStrDescripcion(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objExcl.setStrMotivo(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objExcl.setStrFechaInicio(stkTrama.nextToken());
    
            objLstExcl.add(objExcl);    
            objExcl = null;
                    
          }
      }
    return objLstExcl;
  }
  
}