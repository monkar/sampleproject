package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.GestorSolicitud;
import com.clinica.service.*;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Constante;
import com.clinica.utils.Tabla;
import com.clinica.utils.TablaConfig;
import com.clinica.utils.Tool;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.StringTokenizer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;

public class ProcesoSolicitud extends HttpServlet 
{
    
      private static final String CONTENT_TYPE = "text/html; charset=windows-1252";
      
      //private int intIdSol = 0; ======> Agregado
      //private int intIdHis = 0; ======> Agregado
      //private int intTransacAmp = 0; ======> Agregado
      //private int intIdPresupAmp = 0; ======> Agregado

      //private String strNroAutoriza = ""; ======> Agregado
      //private String strParametrosJS; ======> Agregado
      //private String strWebServer = ""; ======> Agregado
      
      
      //private static int intRamo = Constante.NRAMOASME; ======> Linea ya comentada cuando se hizo el cambio
            
      //Instanciando el objeto que va acceder a los metodos Daos. 29FEB2012 FEB 12:20pm
      //Atencion atencion = new Atencion(); ======> Agregado
      //GestorPolClinic gestorPolClinic = new GestorPolClinic(); ======> Agregado
      //GestorEmail gestorEmail = new GestorEmail(); ======> Agregado
      //GestorSolicitud gc = new GestorSolicitud(); ======> Agregado
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 10:35am
      //GestorCliente gestorCliente  = new GestorCliente(); ======> Agregado
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:25pm
      //GestorClinica gestorClinica = new GestorClinica(); ======> Agregado
      //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 05MAR2012  11:15am    
      //GestorFirma gestorFirma = new GestorFirma(); ======> Agregado
          
          
  
  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }
  
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      String strWebServer = "";
      
      int intTransacAmp = 0;
      int intIdPresupAmp = 0;
      String strParametrosJS = "";
      
      int intIdSol = 0;
      int intIdHis = 0;              
      String strNroAutoriza = "";
                              
    Atencion atencion = new Atencion();
    GestorPolClinic gestorPolClinic = new GestorPolClinic();
    GestorEmail gestorEmail = new GestorEmail();
    GestorSolicitud gc = new GestorSolicitud();
    GestorCliente gestorCliente  = new GestorCliente();
    GestorClinica gestorClinica = new GestorClinica();
    GestorFirma gestorFirma = new GestorFirma();
    
      
    
    PrintWriter out = null;
    HttpSession session = request.getSession(true);
    Usuario objClinica = null;
    
    
    response.setContentType(CONTENT_TYPE);
        
    synchronized(session)
    {
      objClinica = (Usuario) session.getAttribute("USUARIO");
    }
    if (objClinica == null)
    {
             out = response.getWriter();
             out.print("<SCRIPT LANGUAGE=\"JavaScript\"> parent.TerminaSession(); </script>");
             out.close();          
    }else{
        
    synchronized(session)
    {
        strWebServer =  (String) session.getAttribute("STRWEBSERVER");
    }    
        if ("".equals(strWebServer) || strWebServer == null)
          strWebServer = objClinica.getStrWebServer();        
        
        int intProceso = Tool.parseInt(request.getParameter("proceso"));
         System.out.println("Proceso=" + intProceso);
        String sHtml = "";
        switch(intProceso)
        {
        case 1: //REVISADO Anthony Ramirez 06/03/2019
             {// Upload
                ProcesoUpload upload = new ProcesoUpload();
                java.util.Date date = new java.util.Date();
                String strFile = String.valueOf(date.getTime());//String.valueOf(Calendar.YEAR + "-" + Calendar.MONTH + "-" + Calendar.DAY_OF_MONTH + "-" + Calendar.HOUR + "-" + Calendar.MINUTE + "-" + Calendar.MILLISECOND); //request.getParameter("pscodigo");
                boolean x= upload.procesaFicheros(request, response, strFile, Constante.getConst("URL_UPLOAD"));
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> " + 
                        "parent.fichero.location.href = '../flujo/UploadFichero.jsp'; \n" + 
                        "parent.GrabaSolicitud('" + upload.getStrArchivos() + "'); </script>";              
                out = response.getWriter();
                out.print(sHtml);
                out.close();
             }
             break;
        
        case 2: // Registra Solicitud
             {
                            
              String strAcc = Tool.getString(request.getParameter("psacc"));              
              //int ret = RegistraSolicitud(request,objClinica, atencion, gestorPolClinic, gestorEmail, gc, gestorCliente, gestorClinica);
              
              //Inicio añadido Anthony Ramirez 06/03/2019
              Object[] registraSolicitudOUT = RegistraSolicitud(request,objClinica, atencion, gestorPolClinic, gestorEmail, gc, gestorCliente, gestorClinica, strWebServer, intTransacAmp, intIdPresupAmp, strParametrosJS);
              
              intIdSol = (Integer)registraSolicitudOUT[INTIDSOL];
              intIdHis = (Integer)registraSolicitudOUT[INTIDHIS];
              strWebServer = (String)registraSolicitudOUT[STRWEBSERVER];
              strNroAutoriza = (String)registraSolicitudOUT[STRNROAUTORIZA];
              intTransacAmp = (Integer)registraSolicitudOUT[INTTRANSACAMP];
              intIdPresupAmp = (Integer)registraSolicitudOUT[INTIDPRESUPAMP];
              strParametrosJS = (String)registraSolicitudOUT[STRPARAMETROSJS];
              Integer ret = (Integer)registraSolicitudOUT[7]; //Valor de respuesta del metodo
              System.out.println("La respuesta de la solicitud es: " + ret);
              System.out.println("El numero de autorizacion es: " + strNroAutoriza);
              //Fin añadido Anthony Ramirez 06/03/2019
                            
              if (ret == 0)
              {
                 if (Boolean.valueOf(request.getParameter("hcnRegistroCoaseguroCero")).booleanValue()){
                          session.removeAttribute(Constante.SREGCOACERO);
                          session.removeAttribute(Constante.SPRIMERSIN);                          
                 }
                 
                 if (Boolean.valueOf(request.getParameter("hcnRegistroCoaseguroCero")).booleanValue() == false &&
                          Boolean.valueOf(request.getParameter("hcnExcedeMontoMaximo")).booleanValue() == true ){
                         session.setAttribute(Constante.SREGCOACERO, Boolean.TRUE);
                         session.setAttribute(Constante.SPRIMERSIN, strNroAutoriza);
                 }
                    
                  // REQ 2011-0305 BIT/FMG
                  /*if (!("ampliar".equals(strAcc)))
                  {
                      sHtml = "<SCRIPT LANGUAGE=\"JavaScript\">" + 
                      " parent.registraSolicitud('" + "enviar" + "','" + intTransacAmp + "','" + 
                      intIdPresupAmp + "'); </script>";
                  }
                  else
                  {*/
                      sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.loadForm(" + intIdSol + "," + 
                      intIdHis + ",'" + strNroAutoriza + "','" + strAcc + "','" + 
                      strParametrosJS + "'); </script>";
                  //}
              }
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
             break;

        case 3: // Redirecciona a Solicitud
             {  
                                                        
              /*2012-0078*/
              session.removeAttribute(Constante.SREGCOACERO);
              session.removeAttribute(Constante.SPRIMERSIN);
              /*2012-0078*/  
                                          
              int intRamo = Tool.parseInt(request.getParameter("tctRamo"));              
              int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
              int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
              String strCodCliente = Tool.getString(request.getParameter("tctCodCliente"));
              int intCover = Tool.parseInt(request.getParameter("pncover"));
              String strTipoaten = Tool.getString(request.getParameter("pstipoaten"));
              strNroAutoriza = Tool.getString(request.getParameter("pnautoriza"));
              int intTipoSol = Tool.parseInt(request.getParameter("pstiposol"));              
             
              Cobertura objCobertura = null;

              if (request.getParameter("pnselcover")!=null){
                    
                int intSelcover = Tool.parseInt(request.getParameter("pnselcover"));
                BeanList objLstCober = new BeanList();
               synchronized(session)
               {
                if (session.getAttribute("ListaCobertura")!=null)
                  objLstCober = (BeanList)session.getAttribute("ListaCobertura");
              
                  objCobertura = (Cobertura)objLstCober.get(intSelcover);

                  //RQ2019-626-INICIO/
                   if(intRamo==Constante.NRAMOSCRIND || intRamo==Constante.NRAMOPLANREG || intRamo==Constante.NRAMOPOTEST ){
                       String observacionAseguradao;
                       try{
                           GestorCobertura gestorCobertura = new GestorCobertura();
                           observacionAseguradao = gestorCobertura.obtenerObservacionAsegurado(intRamo,
                                   intPoliza,
                                   intCertif,
                                   strCodCliente);
                       }catch (Exception e){
                           e.printStackTrace();
                           observacionAseguradao = "";
                       }
                       objCobertura.setStrObservAseg(observacionAseguradao);
                   }
                   //RQ2019-626-FIN


                  session.setAttribute("CoberturaSel",objCobertura);
               }    
              }
              
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.openSolicitud(" + intTipoSol + ",1,"+intPoliza +","+intCertif +",'"+strCodCliente +"','"+intRamo+"'); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }          
             break;

        case 4: // Actualiza Flujo de la Solicitud
             {                                          
              String strAcc = Tool.getString(request.getParameter("psacc"));                                                  
              //int ret = UpdFlujoSolicitud(request,session,objClinica, gestorEmail, gestorFirma); ===> Metodo reemplazado
              
              //Inicio añadido Anthony Ramirez 06/03/2019
              Object[] updFlujoSolicitudOUT = UpdFlujoSolicitud(request,session,objClinica, gestorEmail, gestorFirma);              
              strNroAutoriza = (String)updFlujoSolicitudOUT[2];
              intIdHis = (Integer)updFlujoSolicitudOUT[1];
              int ret = (Integer) updFlujoSolicitudOUT[0]; //La posicion '0' devuelve el resultado del metodo UpdFlujoSolicitud
              //Fin añadido Anthony Ramirez 06/03/2019
              
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.loadForm(" + intIdSol + "," + intIdHis + ",'" + strNroAutoriza + "','" + strAcc + "',''); </script>";                  
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }          
             break;
        
        case 5: // Detalle Solicitud
             {
                            
              strNroAutoriza = Tool.getString(request.getParameter("pnautoriza"));
              intIdSol = Tool.parseInt(request.getParameter("pnidsol"));
              int intTransac = Tool.parseInt(request.getParameter("pntransac"));
              int intEnvio = Tool.parseInt(request.getParameter("nenvio"));
              //---
              String cliente = "";
              String clinica ="";
             
              // String strFechaRegistro = Tool.getString(request.getParameter("pfecregistro"));    
              // strFechaRegistro = strFechaRegistro.substring(0,10);              

              //SSRS Se obtiene los datos asociados alsiniestro de solicitud   
              Bean objBean = atencion.getSiniestroLog(strNroAutoriza);
              String strWServer = objBean.getString("6");
              int intRamo = Tool.parseInt(objBean.getString("1")); // Agregado para proyecto Apple
              int intPoliza = Tool.parseInt(objBean.getString("2"));
              int intCertif = Tool.parseInt(objBean.getString("3"));
              String strCodCliente = objBean.getString("5");              
              //SSRS Se obtiene los datos de la cobertura asociada a la solicitud de carta
              Cobertura objCobertura = gestorPolClinic.getCoberSin(objBean,intPoliza,intCertif,intRamo);    
            
              if (objCobertura != null)   
              {   
                synchronized(session)
                {
					
				   //RQ2019-626-INICIO/
                   if(intRamo==Constante.NRAMOSCRIND || intRamo==Constante.NRAMOPLANREG || intRamo==Constante.NRAMOPOTEST ){
                       String observacionAseguradao;
                       try{
                           GestorCobertura gestorCobertura = new GestorCobertura();
                           observacionAseguradao = gestorCobertura.obtenerObservacionAsegurado(intRamo,
                                   intPoliza,
                                   intCertif,
                                   strCodCliente);
                       }catch (Exception e){
                           e.printStackTrace();
                           observacionAseguradao = "";
                       }
                       objCobertura.setStrObservAseg(observacionAseguradao);
                   }
                   //RQ2019-626-FIN
				   
                  session.setAttribute("CoberturaSel",objCobertura);
                }  
                  Bean objAtencion = atencion.getCliente_his(intPoliza, intCertif, strCodCliente, strWServer, strNroAutoriza,intRamo);
                  //Bean objAtencion = Atencion.getCliente_bit(intPoliza, intCertif, strCodCliente,strWServer,strFechaRegistro);
                  Cliente objCliente = null;     
                  if (objAtencion!=null)
                  {
                     objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);
                  }  
                /*
                *PRT Realiza la ejecucion del SP REAOVCLIENT desde una conexion a VisualTime
                *para obtener los valores referentes al asegurado y al titular
                */
                BeanList bl=atencion.getClienteVT("", "",objCliente.getStrCodigo());
                int intSexo=0;
                String strDni="";
                String strRuc="";
                String strNombres="";
                String strApePat="";
                String strApeMat="";
                String strFecNac="";
                  for(int i=0;i<bl.size();i++){                      
                      intSexo = Tool.parseInt(bl.getBean(i).getString("5").trim());
                      strDni = bl.getBean(i).getString("8").trim();                   
                      strRuc = bl.getBean(i).getString("9").trim();                     
                      strNombres = bl.getBean(i).getString("34").trim();                       
                      strApePat = bl.getBean(i).getString("32").trim();                       
                      strApeMat = bl.getBean(i).getString("33").trim(); 
                      strFecNac=bl.getBean(i).getString("4").trim();
                  }                
                if (intSexo == 1)  {
                    objCliente.setIntCodSexo(2);
                }
                if (intSexo == 2) {
                    objCliente.setIntCodSexo(3);
                }
                objCliente.setStrDni(strDni);
                if((strDni!="")||(strDni!=null)){                            
                            objCliente.setStrIdeDocIdentidad("2");
                }else{
                            objCliente.setStrIdeDocIdentidad("1");
                }                
                objCliente.setStrRuc(strRuc);
                objCliente.setStrApePat(strApePat);
                objCliente.setStrApeMat(strApeMat);
                objCliente.setStrNomb(strNombres);                
                objCliente.setStrFecNac(strFecNac);
                //PRT fin de seteo a objCliente
                
                  int intEstadoDeudaCliente = atencion.getEstadoCliente(intPoliza,intCertif,intRamo); //Se agrego el codigo "intRamo"
                  objCliente.setIntEstadoDeuda(intEstadoDeudaCliente);
                  //--
                  cliente =  objCliente.getStrCodigo();
                  if(objClinica.getStrWebServer() != null && objClinica.getStrWebServer() != "")
                  {
                    clinica = objClinica.getStrWebServer();
                  }
                  else
                  {
                    clinica = "";
                  }
                  synchronized(session)
                  {
                    session.setAttribute("DatoCliente",objCliente);                
                  }
                 Solicitud objSolicitud = gc.getSolicitud(intIdSol);
                  Presupuesto objPresupuesto = null;
                  if (intTransac > 0)
                      objSolicitud.getObjSolhis().setNTRANSAC(intTransac);                   
                
                  if (objSolicitud.getObjSolhis().getNTRANSAC() > 0)
                  { 
                      objPresupuesto = gc.getPresupuesto(intIdSol,objSolicitud.getObjSolhis().getNTRANSAC());   
                  }
                  else
                  {
                      objPresupuesto = gc.getPresupuesto(intIdSol,1);
                  }
                  objSolicitud.setObjPresupuesto(objPresupuesto);  
                
                  //Se busca la ultima transaccion de registro en Insunix
                  int intTransaccion = gc.validaTransaccion(objSolicitud.getObjSolhis().getNTRANSAC(),objSolicitud.getNIDSOLICITUD());
                
                  gc.getSolicitudIfx(objSolicitud, intTransaccion);
                  synchronized(session)
                  {
                    session.setAttribute("SolicitudSel",objSolicitud);                
                  }
              }
          
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verDetalle("+intPoliza+","+intCertif+",'"+cliente+"','"+clinica+"',"+intEnvio+"); </script>";  
                    
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
             break;
        
        //Req 2011-0480
        case 6: //SE ANULAN CARTAS DE CAGARNTÍA Y CARTAS DE AUTORIZACIÓN
             {
                  int pclaim_anul = Tool.parseInt(request.getParameter("pclaim_anul"));
                  int pmotivo_anul = Tool.parseInt(request.getParameter("pmotivo_anul"));
                  int puser_anul = Tool.parseInt(request.getParameter("puser_anul"));
                  int resultado = -1;
                  boolean anuladoIFX = false;
                  boolean anuladoORA = false;
                  
                  anuladoIFX = gc.anularCartaIFX(pclaim_anul,pmotivo_anul,puser_anul);
                  
                  if(anuladoIFX)
                  {
                    anuladoORA = gc.anularCartaORA(pclaim_anul);
                  }
                  
                  if(anuladoORA)
                    resultado = 1;
                  else
                   resultado = 0;
                   
                  sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.resultadoAnulacion("+resultado+"); </script>";  
                  out = response.getWriter();
                  out.print(sHtml);
                  out.close();
             }
             break;
        //Fin Req 2011-0480
        
        case 7: // Detalle Solicitud2
             {
              
              strNroAutoriza = Tool.getString(request.getParameter("pnautoriza"));
              intIdSol = Tool.parseInt(request.getParameter("pnidsol"));
              int intTransac = Tool.parseInt(request.getParameter("pntransac"));
              //---
              String cliente = "";
              String clinica ="";
             
             // String strFechaRegistro = Tool.getString(request.getParameter("pfecregistro"));    
             // strFechaRegistro = strFechaRegistro.substring(0,10);              

              //SSRS Se obtiene los datos asociados alsiniestro de solicitud   
              Bean objBean = atencion.getSiniestroLog(strNroAutoriza);
              String strWServer = objBean.getString("6");        
              int intRamo = Tool.parseInt(objBean.getString("1")); // Agregado para Apple
              int intPoliza = Tool.parseInt(objBean.getString("2"));
              int intCertif = Tool.parseInt(objBean.getString("3"));
              String strCodCliente = objBean.getString("5");
              //SSRS Se obtiene los datos de la cobertura asociada a la solicitud de carta
              Cobertura objCobertura = gestorPolClinic.getCoberSin(objBean,intPoliza,intCertif,intRamo);
            
            
              if (objCobertura != null)   
              {   
                synchronized(session)
                {
                  session.setAttribute("CoberturaSel2",objCobertura);
                }  
                  Bean objAtencion = atencion.getCliente_his(intPoliza, intCertif, strCodCliente, strWServer, strNroAutoriza,intRamo);
                  //Bean objAtencion = Atencion.getCliente_bit(intPoliza, intCertif, strCodCliente,strWServer,strFechaRegistro);
                  
                  Cliente objCliente = null;
                
                  if (objAtencion!=null)
                  {
                      objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);
                  }  
                /*
                *PRT Realiza la ejecucion del SP REAOVCLIENT desde una conexion a VisualTime
                *para obtener los valores referentes al asegurado y al titular
                */
                BeanList bl=atencion.getClienteVT("", "",objCliente.getStrCodigo());
                int intSexo=0;
                String strDni="";
                String strRuc="";
                String strNombres="";
                String strApePat="";
                String strApeMat="";
                String strFecNac="";
                  for(int i=0;i<bl.size();i++){                      
                      intSexo = Tool.parseInt(bl.getBean(i).getString("5").trim());
                      strDni = bl.getBean(i).getString("8").trim();                   
                      strRuc = bl.getBean(i).getString("9").trim();                     
                      strNombres = bl.getBean(i).getString("34").trim();                       
                      strApePat = bl.getBean(i).getString("32").trim();                       
                      strApeMat = bl.getBean(i).getString("33").trim(); 
                      strFecNac=bl.getBean(i).getString("4").trim();
                  }                
                if (intSexo == 1)  {
                    objCliente.setIntCodSexo(2);
                }
                if (intSexo == 2) {
                    objCliente.setIntCodSexo(3);
                }
                objCliente.setStrDni(strDni);
                if((strDni!="")||(strDni!=null)){                            
                            objCliente.setStrIdeDocIdentidad("2");
                }else{
                            objCliente.setStrIdeDocIdentidad("1");
                }                
                objCliente.setStrRuc(strRuc);
                objCliente.setStrApePat(strApePat);
                objCliente.setStrApeMat(strApeMat);
                objCliente.setStrNomb(strNombres);                
                objCliente.setStrFecNac(strFecNac);
                //PRT fin de seteo a objCliente
                
                  int intEstadoDeudaCliente = atencion.getEstadoCliente(intPoliza,intCertif,intRamo);//Se agrego el codigo "intRamo"
                  objCliente.setIntEstadoDeuda(intEstadoDeudaCliente);
                  //--
                  cliente =  objCliente.getStrCodigo();
                  if(objClinica.getStrWebServer() != null && objClinica.getStrWebServer() != "")
                  {
                    clinica = objClinica.getStrWebServer();
                  }
                  else
                  {
                    clinica = "";
                  }
                  synchronized(session)
                  {
                    session.setAttribute("DatoCliente2",objCliente);                
                  }
                  //GestorSolicitud gc = new GestorSolicitud();
                  Solicitud objSolicitud = gc.getSolicitud(intIdSol);
                  Presupuesto objPresupuesto = null;
                  if (intTransac > 0)
                      objSolicitud.getObjSolhis().setNTRANSAC(intTransac);                   
                
                  if (objSolicitud.getObjSolhis().getNTRANSAC() > 0)
                  { 
                      objPresupuesto = gc.getPresupuesto(intIdSol,objSolicitud.getObjSolhis().getNTRANSAC());   
                  }
                  else
                  {
                      objPresupuesto = gc.getPresupuesto(intIdSol,1);
                  }
                  objSolicitud.setObjPresupuesto(objPresupuesto);  
                
                  //Se busca la ultima transaccion de registro en Insunix
                  int intTransaccion = gc.validaTransaccion(objSolicitud.getObjSolhis().getNTRANSAC(),objSolicitud.getNIDSOLICITUD());
                
                  gc.getSolicitudIfx(objSolicitud, intTransaccion);
                  synchronized(session)
                  {
                    session.setAttribute("SolicitudSel2",objSolicitud);                
                  }
              }
          
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verDetalle("+intPoliza+","+intCertif+",'"+cliente+"','"+clinica+"'); </script>";  
                    
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
             break;
        
        case 8: // Envia Aviso de Gerencia
             {              
              String strAcc = Tool.getString(request.getParameter("psacc"));
              int ret = SendAvisoGerencia(request,session,objClinica, gc);
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.loadFormAviso('" + strAcc + "'); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
          
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
             break;
        }
        
    }   
    
  }
  
  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      doGet(request,response);
  }
  
  private final int INTIDSOL        = 0; 
  private final int INTIDHIS        = 1;
  private final int STRWEBSERVER    = 2;
  private final int STRNROAUTORIZA  = 3;   
  private final int INTTRANSACAMP   = 4;  
  private final int INTIDPRESUPAMP  = 5;  
  private final int STRPARAMETROSJS = 6;
    
    //public synchronized int RegistraSolicitud(HttpServletRequest request,Usuario usuario)
    public synchronized Object[] RegistraSolicitud(HttpServletRequest request,Usuario usuario, Atencion atencion, GestorPolClinic gestorPolClinic, GestorEmail gestorEmail, GestorSolicitud gc, GestorCliente gestorCliente, GestorClinica gestorClinica, String strWebServer, int intTransacAmp, int intIdPresupAmp, String strParametrosJS)
    {
        
        int intIdSol = Tool.parseInt(request.getParameter("hcnIdSolicitud"));    
        int intIdHis = Tool.parseInt(request.getParameter("hcnIdHistorico"));
        String strNroAutoriza = Tool.getString(request.getParameter("tcnAutoriza"));
        
        
        int intRet = -1;
        int intCacalili = Tool.parseInt(request.getParameter("strcacalili"));    // Agregado para Apple
        int intIdCodOficina = usuario.getIntCodOficina(); 
        int intTipoSolicitud = Tool.parseInt(request.getParameter("hcnTipoSol"));    
                        
        int intIdPresupuesto = Tool.parseInt(request.getParameter("hcnIdPresupuesto"));
        String strAcc = Tool.getString(request.getParameter("psacc"));           
        System.out.println("strAcc :"+strAcc);
            
        int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
        int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
        String strCodCliente = Tool.getString(request.getParameter("hctCodCliente"));    
        String strComenta = Tool.getString(request.getParameter("txcComenta"));           
        String strArchivo1 = Tool.getString(request.getParameter("hcnArchivo1"));           
        String strAsegurado = Tool.getString(request.getParameter("tctAsegurado"));    

        String strCodDiag = Tool.getString(request.getParameter("tcnDiagnos"));
        int intCodMoneda = Tool.parseInt(request.getParameter("lscMoneda"));
        int intCodMotivo = Tool.parseInt(request.getParameter("lscMotivo"));
        int intCodProv = Tool.parseInt(request.getParameter("tcnProveedor"));
        int intCodOficina = Tool.parseInt(request.getParameter("hcnOficina"));
        int intCodRamo = Tool.parseInt(request.getParameter("hcnRamo"));
        String strFechaLim = Tool.getString(request.getParameter("tcdFechaLim"));
        double dblImpCarta = Tool.parseDouble(request.getParameter("tcnSubTotal"));
        double dblTipoCambio = Tool.parseDouble(request.getParameter("tcnCambio"));
        String strObserva = Tool.getString(request.getParameter("txcObserva"));           
        int intIdRolResp = Tool.parseInt(request.getParameter("lscRolEnvia"));
        int intFlgAmplia = Tool.parseInt(request.getParameter("hcnFlgAmplia"));
            
        String strObservaCli = Tool.getString(request.getParameter("txcObservaClinica"));           
        //INI - REQ 2011-0305 BIT/FMG
        String strObservaCliTmp = Tool.getString(request.getParameter("txcObservaCliTemp"));               
        if (strObservaCliTmp.equals(strObservaCli))
            strObservaCli ="";
        //INI - REQ 2011-0305 BIT/FMG
            
        int staCaso =  Tool.parseInt(TablaConfig.getTablaConfig("STA_CASO"));
            
        int intCaso=1;
        if(staCaso==1){
          intCaso = Tool.parseInt(request.getParameter("hctCaso")); // Apple
        }       
                
        //RQ2015-000750 INICIO
        String strEmail = Tool.getString(request.getParameter("tctemail"));               
        //RQ2015-000750 FIN
                
        String strCMPMedico = Tool.getString(request.getParameter("tctCMPMedico"));           
        String strNombMedico = Tool.getString(request.getParameter("tctNombreMedico"));
            
        double dblFactorIgv = Tool.parseDouble(request.getParameter("hcnFactorIGV"));

        /*AF-64*/
        int intTiempoEnfermedad = Tool.parseInt(request.getParameter("tcnTiempoEnfermedad"));
        /*fin AF-64*/
            
        String strServer = request.getParameter("hcnServer");
        int intSelCover = Tool.parseInt(request.getParameter("hcnSelCover"));
        int intEstadoHis = Tool.parseInt(request.getParameter("hcnEstadoHis")); // REQ 2011-0305 BIT/FMG
            
        //Si el tipo de solicitud es una carta de garantía
        if (intTipoSolicitud == Constante.NTSCARGAR)
        {
           Bean bProv = Tabla.getProvedorIfxServ(strWebServer);
           if (bProv!=null)
              intCodProv = Tool.parseInt(bProv.getString("2"));
        }
            
        // Se obtiene el indicar si el siniestro tiene exceso sobre el valor máximo del coaseguro 2012-0078
        boolean blnRegistroCoaseguroCero = Boolean.valueOf(request.getParameter("hcnRegistroCoaseguroCero")).booleanValue();

                  
        double dblMontoMaximoCoaseguro = Double.parseDouble(request.getParameter("hcnMontoMaximoCoaseguro")) ;    //2012-0078
          
        //GestorSolicitud gs = new GestorSolicitud();
        Solicitud objSolicitud = new Solicitud();
            
        //Si se graba se setea el estado registrado y se obtiene el rol logueado 
        if ("grabar".equals(strAcc))
        {
            objSolicitud.setNIDESTADO(Constante.NESTREG);
            objSolicitud.setNIDROLRESP(usuario.getIntIdRol());
        }
        else
        //De lo contrario se setea pendiente y se saca el rol responsable
        { 
            // INI - REQ 2011-0305 BIT/FMG
            if("enviar".equals(strAcc) && intEstadoHis == Constante.NESTOBS)
                  objSolicitud.setNIDESTADO(Constante.NESTLEVOBS);
            else
            {
                if ("ampliar".equals(strAcc))
                   objSolicitud.setNIDESTADO(Constante.NESTAMP);
                else
                   objSolicitud.setNIDESTADO(Constante.NESTPEN);
            }
            objSolicitud.setNIDROLRESP(intIdRolResp);
            // FIN - REQ 2011-0305 BIT/FMG
        }
            
        objSolicitud.setNIDTIPOSOLICITUD(intTipoSolicitud);        
        objSolicitud.setNIDUSUARIO(usuario.getIntIdUsuario());
        objSolicitud.getObjSolhis().setSOBSERVA(strComenta);
        objSolicitud.getObjSolhis().setSARCHIVO1(strArchivo1);
        objSolicitud.setSASEGURADO(strAsegurado);
        objSolicitud.setSIDCLINICA(strWebServer);
            
        if (usuario.getIntCodGrupo()==Constante.NCODGRUPOCESP){
           objSolicitud.setSIDCLINICA(strServer);
           objSolicitud.setSIDCLINICASOL(strWebServer);
        }        
            
        objSolicitud.setDblImporteCarta(dblImpCarta);
        objSolicitud.setDblTipoCambio(dblTipoCambio);
        objSolicitud.setIntCodDiagnos(strCodDiag);
        objSolicitud.setIntCodProveedor(intCodProv);
        objSolicitud.setIntMonedaImpoCarta(intCodMoneda);
        objSolicitud.setIntOficina(intCodOficina);
        objSolicitud.setIntRamo(intCodRamo);
        objSolicitud.setStrFechaLimite(strFechaLim);
        objSolicitud.setNIDSOLICITUD(intIdSol);
        objSolicitud.getObjSolhis().setNIDHISTORICO(intIdHis);
            
        objSolicitud.setSOBSERVACLI(strObservaCli);
        objSolicitud.setSCMPMEDICO(strCMPMedico);
        objSolicitud.setSNOMBMEDICO(strNombMedico);
            
        /* AF-64 */    
        objSolicitud.setIntTiempoEnfermedad(intTiempoEnfermedad);    
        /* FIN AF-64*/
            
        //PRT
        objSolicitud.setSOBSERVAMED(strObserva);      
              
        objSolicitud.setIntCodOficina(intIdCodOficina);
        objSolicitud.setDblFactorIgv(dblFactorIgv);
         
        // SSRS Se obtienen los datos del cliente asociado a la solicitud de carta
        // Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer);
        Bean objAtencion = atencion.getClienteApple(intPoliza, intCertif, strCodCliente,strWebServer,intCodRamo);
           
        Cliente objCliente = gestorCliente.setCliente(objAtencion,strCodCliente);
          
        //RQ2015-000750 Inicio
        objCliente.setStrEmail(strEmail);
        objSolicitud.setSClient(strCodCliente);
        objSolicitud.setSCorreo(strEmail);
        //RQ2015-000750 Fin
            
        //SSRS Se obtiene la cobertura seleccionada para la solicitud
        Cobertura objCobertura = null;
        if (intIdSol==0)
        { 
            //SSRS Para solicitud nueva se obtiene lacobetura seleccionada del listado
            ArrayList lstCobertura = gestorPolClinic.getLstCobertura(objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                                        objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                        objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                                        strCodCliente, objCliente.getIntCodEstado(),intCodRamo,intCaso);
            
            objCobertura = (Cobertura)lstCobertura.get(intSelCover);
                
            /*INICIO 2012-0078*/
            if (blnRegistroCoaseguroCero)
            {
               objCobertura.setStrCoaseguro(Constante.MONTOMINCOASEGURO);
            }
            /*FIN 2012-0078*/
        }
        else
        {
            //SSRS Para solicitud antigua se obtiene el log de siniestros de solicitud
            Bean objBean = atencion.getSiniestroLog(strNroAutoriza);
            objCobertura = gestorPolClinic.getCoberSin(objBean,intPoliza, intCertif,intCodRamo);
        }
        
        // Agregado para Apple
            
        //Registro de solicitud nueva: CG y CA    
        if (intIdSol==0)
        {
           objSolicitud.setStrFechaOcurr(Tool.getDate("dd/MM/yyyy"));
           objSolicitud.setStrFechaEmi(Tool.getDate("dd/MM/yyyy"));

		   //INICIO RQ2019-691 - CPHQ
		   int IntCodBrokerInx = gc.getBroker("2",intCodRamo,intCertif,intPoliza);
		   objCliente.setIntCodBrokerInx(IntCodBrokerInx);
		   //FIN RQ2019-691 - CPHQ

           //Inserto al solicitud
           intRet = gc.insSolicitud(objSolicitud,objCliente,intCacalili);
           intIdSol = objSolicitud.getNIDSOLICITUD();
           intIdHis = objSolicitud.getObjSolhis().getNIDHISTORICO();

           if (intRet == 0)
           {
                  Presupuesto objPresupuesto = this.cargarPresupuesto(request);
                  objSolicitud.setObjPresupuesto(objPresupuesto);
                        
                  //SSRS Para solitud nueva se setea la solitud 1 por default
                  int intTransaccion = 1 ;
                  objSolicitud.getObjSolhis().setNTRANSAC(intTransaccion);
                        
                  if(usuario.getIntIdRol()== Constante.NROLEMISOR)
                     strServer = strWebServer;
                                                               
                  //Si el usuario es un centro especializado.    
                  if (usuario.getIntCodGrupo()== Constante.NCODGRUPOCESP)
                  {                    
                      //SSRS Se creó el método de registro de solicitud sincronizado
                      intRet = gc.registraSolicitud( objSolicitud,  objCobertura,  objCliente,  strWebServer,
                                                          //intPoliza,  intCertif,  intRamo, strCodCliente, intIdSol, strWebServer);      Modificado para Apple
                                                           intPoliza,  intCertif,  intCodRamo, strCodCliente, intIdSol, strWebServer,intCaso);
                  }
                  else
                  {                    
                      //SSRS Se creó el método de registro de solicitud sincronizado
                      intRet = gc.registraSolicitud( objSolicitud,  objCobertura,  objCliente,  strServer,
                                                           //intPoliza,  intCertif,  intRamo, strCodCliente, intIdSol, "");      Modificado para Apple                      
                                                           intPoliza,  intCertif,  intCodRamo, strCodCliente, intIdSol, "",intCaso);                         
                  }      
                    
           } 
        }
        else
        {
                  
           objSolicitud.setSNROSINIESTRO(strNroAutoriza);

           if ("grabar".equals(strAcc) || "enviar".equals(strAcc))
           {
              Presupuesto objPresupuesto = this.cargarPresupuesto(request);
              int intTransac = Tool.parseInt(request.getParameter("hcnTransac"));
              objPresupuesto.setNIDPRESUPUESTO(intIdPresupuesto);
              objSolicitud.getObjSolhis().setNTRANSAC(intTransac);
              objSolicitud.setObjPresupuesto(objPresupuesto);
              intRet = gc.updPresupuesto(objSolicitud);
                
              if (intFlgAmplia==0)
              {
                 if (intRet==0)
                 {
                    int intNewTransac = gc.updSolicitudIfx(objSolicitud,objCobertura,objCliente); 
                    if (intTransac != intNewTransac)
                       gc.actualizaTransac(objSolicitud.getNIDSOLICITUD(),intNewTransac,intTransac);
                 }
              }
              objSolicitud.getObjSolhis().setNTRANSAC(0);
           }
            
            if ("ampliar".equals(strAcc))
            {       
                      
               Presupuesto objPresupuesto = this.cargarPresupuesto(request);
               objSolicitud.setObjPresupuesto(objPresupuesto);
               //SSRS Se creó el método de ampliación de solitiud sincronizado
               int intRet2 = gc.ampliaSolicitudSyn(objSolicitud, objCobertura,objCliente);          
               intTransacAmp = objSolicitud.getObjSolhis().getNTRANSAC();   
               intIdPresupAmp = objSolicitud.getObjPresupuesto().getNIDPRESUPUESTO();
                                   
               if (objCliente.getIntEstadoDeuda()==Constante.CODDEUDAPERMIS)
               {
                  try 
                  {
                     Bean objContratante = gestorPolClinic.getContratante(intPoliza,intCertif);
                     String strNomClinica = gestorClinica.getClinica(strWebServer).getString("2");
                        
                     gestorEmail.enviaMailDeuda(objContratante,intPoliza,intCertif,objCliente,objSolicitud,strNomClinica);
                  }
                  catch(Exception e1)
                  {
                      e1.printStackTrace();
                  }
               }
               
               if (intRet2!=0)
               {          
                  intRet =  -1;
               }              
                    
            } 
            
            if ("enviar".equals(strAcc) || "ampliar".equals(strAcc))
            {
               if ("ampliar".equals(strAcc))
               {
                  // INI - REQ 2011-0305 BIT/FMG
                  objSolicitud.setNIDESTADO(Constante.NESTAMP); 
                  objSolicitud.setNIDROLRESP(Constante.NROLMED);
                  // FIN - REQ 2011-0305 BIT/FMG
               }
                  //PRT                            
                  int IdRolClinica = usuario.getIntIdRol();
                  intRet = gc.updFlujoSolicitud(objSolicitud, IdRolClinica);
                  if ("enviar".equals(strAcc))
                  {      
                     System.out.println("Enviar : ");
                     System.out.println("NIDROLRESP  : "+objSolicitud.getNIDROLRESP());
                     System.out.println("COD OFICINA  : "+objSolicitud.getIntCodOficina());
                     System.out.println("SNROSINIESTRO  : "+objSolicitud.getSNROSINIESTRO());
                     
                     gestorEmail.enviaEmailBandeja(1,objSolicitud.getNIDROLRESP(),objSolicitud.getIntCodOficina(),objSolicitud.getSNROSINIESTRO());
                  } 
                  intIdHis = objSolicitud.getObjSolhis().getNIDHISTORICO();
            }
                
            if (!"".equals(objSolicitud.getSOBSERVACLI()))
            {
               String sql = "UPDATE PTBLSOLICITUD SET " + 
                            //"SOBSERVACIONCLI = SOBSERVACIONCLI || CHR( 13 ) || CHR( 10 ) || '" + objSolicitud.getSOBSERVACLI() + "' " + 
                            "SOBSERVACIONCLI = '" + objSolicitud.getSOBSERVACLI().trim() + "' " + 
                            "WHERE NIDSOLICITUD = " + intIdSol;
               Tool.execute_sql(sql);
            }
          
            String sql = "UPDATE PTBLSOLICITUD_HIS SET SARCHIVO1 = '" + strArchivo1  +  "'" + 
                         (objSolicitud.getObjSolhis().getNTRANSAC()>0?", NTRANSAC = " + objSolicitud.getObjSolhis().getNTRANSAC():"") +
                         ("ampliar".equals(strAcc)?", NFLGAMPLIACION = 1":"") + 
                         " WHERE NIDHISTORICO = " + intIdHis;
                    
            Tool.execute_sql(sql);
                   
            if ("ampliar".equals(strAcc))
            {
               sql = "UPDATE PTBLSOLICITUD SET NFLGAMPLIACION = 1 WHERE NIDSOLICITUD = " + intIdSol;
               Tool.execute_sql(sql);
            }
        }
                    
        strParametrosJS =  objSolicitud.getStrFechaEmi() + "|" + objSolicitud.getStrFechaOcurr();
        strNroAutoriza = objSolicitud.getSNROSINIESTRO();    
              
        /*INICIO 2012-0078*/  
        if (intRet == 0 && Integer.parseInt(request.getParameter("hcnPrimerSiniestro"))== 0 &&
            Boolean.valueOf(request.getParameter("hcnExcedeMontoMaximo")).booleanValue() == true )
        {
           double dblMontoInicial = Double.parseDouble(request.getParameter("hcnMontoInicial"));    
           Poliza objPoliza = new Poliza();
           objPoliza.setDblMaxMontoCoaseguro(dblMontoMaximoCoaseguro);
           gc.registraHistoricoMaxCoaseguro(objCliente,objCobertura,objSolicitud,objPoliza,usuario,dblMontoInicial,strAcc,1);    
        }    
                  
        if (Integer.parseInt(request.getParameter("hcnPrimerSiniestro")) > 0 && 
            Boolean.valueOf(request.getParameter("hcnRegistroCoaseguroCero")).booleanValue())
        {
            int intIdfirstClaim = Integer.parseInt(request.getParameter("hcnPrimerSiniestro"));
            gc.actualizaHistoricoMaxCoaseguro(objSolicitud,intIdfirstClaim);
        }
        
        /*FIN 2012-0078*/  
        notify();
        
        Object[] valoresDeSalida = new Object[8];
        valoresDeSalida[INTIDSOL] = intIdSol;
        valoresDeSalida[INTIDHIS] = intIdHis ;
        valoresDeSalida[STRWEBSERVER] = strWebServer;
        valoresDeSalida[STRNROAUTORIZA] = strNroAutoriza;
        valoresDeSalida[INTTRANSACAMP] = intTransacAmp;
        valoresDeSalida[INTIDPRESUPAMP] = intIdPresupAmp;
        valoresDeSalida[STRPARAMETROSJS] = strParametrosJS;
        valoresDeSalida[7] = intRet; //Valor de respuesta del metodo
        
        //return intRet;
        return valoresDeSalida;
    
    }
    
 
  //public synchronized int UpdFlujoSolicitud(HttpServletRequest request,HttpSession session, Usuario usuario, GestorEmail gestorEmail, GestorFirma gestorFirma)
  public synchronized Object[] UpdFlujoSolicitud(HttpServletRequest request,HttpSession session, Usuario usuario, GestorEmail gestorEmail, GestorFirma gestorFirma)
  {   
    int intIdHis = 0;
    String strNroAutoriza = Tool.getString(request.getParameter("tcnAutoriza"));
    Object[] valoresDeSalida = new Object[3];
      
    int intRet=-100;
    
    int intTipoSolicitud = Tool.parseInt(request.getParameter("hcnTipoSol"));    
    int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
    int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
    String strCodCliente = Tool.getString(request.getParameter("hctCodCliente"));
    String strComenta = Tool.getString(request.getParameter("txcComenta"));                      
    int intIdSolicitud = Tool.parseInt(request.getParameter("hcnIdSolicitud"));
    
    int intIdRolResp = Tool.parseInt(request.getParameter("lscRolEnvia"));
    int intFlgAmplia = Tool.parseInt(request.getParameter("hcnFlgAmplia"));
    int intTransac = Tool.parseInt(request.getParameter("hcnTransac"));
    String strObserva = Tool.getString(request.getParameter("txcObserva"));
    String strObservaHis = Tool.getString(request.getParameter("txcObservaHis")); // REQ 2011-0305 BIT/FMG
    //PRT inicio de strObservaCli
    String strObservaCli = Tool.getString(request.getParameter("txcObservaClinica"));    
    
    //RQ2015-000750 Inicio
    String sClinica = Tool.getString(request.getParameter("tctProveedor"));
    String sRamo = Tool.getString(request.getParameter("tctRamo"));
    String sProducto = Tool.getString(request.getParameter("tctProducto"));
    String sOficina = Tool.getString(request.getParameter("tctOficina"));
    String sContratante = Tool.getString(request.getParameter("tctTitular"));
    String sAsegurado = Tool.getString(request.getParameter("tctAsegurado"));
    String sPaciente = Tool.getString(request.getParameter("tctAsegurado"));
    String sModalidad = Tool.getString(request.getParameter("tctTipoAtencion"));
    String strFechaEmision = (request.getParameter("tcdFecEmi")).toString(); 
    String sCobertura = Tool.getString(request.getParameter("tctCobertura"));
    String sDeducible = (sModalidad.equals(Constante.SATENAMB)?Tool.getString(request.getParameter("tcnADedu")):Tool.getString(request.getParameter("tcnQDedu")));
    double dblCoaseguro = Tool.parseDouble(request.getParameter("tcnGasto"));
    double dblSubTotalCarta = Tool.parseDouble(request.getParameter("hcnSubTotal"));
    int intMonedaCarta = Tool.parseInt(request.getParameter("lscMoneda"));
    
    String strSClient = Tool.getString(request.getParameter("hctCodCliente"));   
    String strSEmail = Tool.getString(request.getParameter("tctemail"));                   
    //RQ2015-000750 Fin        
    
    //INI - REQ 2011-0305 BIT/FMG
    if(strObservaHis.equals(strObserva))
        strObserva="";
    //FIN - REQ 2011-0305 BIT/FMG
   
    //PRT fin de strObservaCli
    int intSubMotivo = Tool.parseInt(request.getParameter("lscSubMotivoSBS"));    
    int intCodMotivoSBS = Tool.parseInt(request.getParameter("lscMotivoSBS"));
    String intCodDiagM = Tool.getString(request.getParameter("tcnDiagnosM"));
    String strDiagnosM = Tool.getString(request.getParameter("tctDiagnosM"));
    String strProcRecha  = Tool.getString(request.getParameter("tctProcRecha"));
    String strMotivoSBS  = Tool.getString(request.getParameter("MOTIVO SBS"));
    String strSubMotivo  = Tool.getString(request.getParameter("SUB MOTIVO SBS"));
    int intCodMotivo = Tool.parseInt(request.getParameter("lscMotivo"));
    String strConPoli = Tool.getString(request.getParameter("txcCondiPi"));
    String strConPolii = Tool.getString(request.getParameter("txcCondiPii"));
    String strNumRecha = Tool.getString(request.getParameter("tctNumRecha"));
    double dblMontotal= Tool.parseDouble(request.getParameter("tcnTotal"));
    
    int intCodOficina = -1;
    synchronized(session)
    {
      intCodOficina = ((Solicitud)session.getAttribute("SolicitudSel")).getIntCodOficina();
    }
    
    int intNuevaTransaccion = 0;
    Solicitud_his objSolicitudHis = new Solicitud_his();
    objSolicitudHis.setNTRANSAC(intNuevaTransaccion);
     
    String strAcc = Tool.getString(request.getParameter("psacc"));
    
    GestorSolicitud gc = new GestorSolicitud();
    
    int staRechazo =  Tool.parseInt(Constante.getConst("STA_RECHAZO"));
    
    Solicitud objSolicitud = new Solicitud();
    //RQ2015-000750 Inicio
    AvisoSolicitud objAvisoSolicitud = new AvisoSolicitud();
    int intResultadoIns = 0; // 0 Error, 1 Correcto  --RQ2015-000750
    //RQ2015-000750 Fin
    //RQ2015-000604 Inicio
    AvisoRechazo objAvisoRechazo = new AvisoRechazo();
    int intResultadoRIns = 0; // 0 Error, 1 Correcto  --RQ2015-000750
    
    //RQ2015-000604 Fin
    
    //INI - REQ 2011-0305 BIT/FMG
    if ("derivar".equals(strAcc))
      objSolicitud.setNIDESTADO(Constante.NESTDER);
    if ("enviar".equals(strAcc))
    //FIN - REQ 2011-0305 BIT/FMG
      objSolicitud.setNIDESTADO(Constante.NESTPEN);
      //PRT inicio campos que viajan
      objSolicitud.setSOBSERVACLI(strObservaCli);      
      objSolicitud.setSOBSERVAMED(strObserva);
      //PRT fin campos que viajan
    if ("anular".equals(strAcc))
    {         
      objSolicitud.setNIDESTADO(Constante.NESTANU);
      if (intFlgAmplia==1)
        intRet = gc.anulRechSolicitudAmpIfx(strNroAutoriza,Constante.NUSERCODE,intTransac,1,objSolicitudHis);
      else
        intRet = gc.anulRechSolicitudIfx(strNroAutoriza, 1, objSolicitudHis);
    }
    if ("aprobar".equals(strAcc))
    {
      
      int intResultadoAct = 0; // 0 Error, 1 Correcto  --Req. 2014-000204 ParadigmaSoft GJB
      
      objSolicitud.setNIDESTADO(Constante.NESTAPR);
      //PRT inicio campos que viajan
      objSolicitud.setSOBSERVACLI(strObservaCli);      
      objSolicitud.setSOBSERVAMED(strObserva);
      //PRT fin campos que viajan
      intIdRolResp = usuario.getIntIdRol();
      
      Firma objFirma = gestorFirma.getFirma(intTipoSolicitud,intCodOficina);
      
      objSolicitud.setIntIdUsuFirma1(objFirma.get_intIdUsuario()[0]);
      objSolicitud.setIntIdUsuFirma2(objFirma.get_intIdUsuario()[1]);
            
      //Inicio Req. 2014-0002004 ParadigmaSoft GJB
      intResultadoAct = gc.actualizarFechaLimiteSolicitud(strNroAutoriza,Tool.parseInt(Constante.getConst("DIAS")));           
      //Fin Req. 2014-0002004 ParadigmaSoft GJB
      
      //RQ2015-000750 Inicio
      objAvisoSolicitud = gc.getDatosSolicitudInx(Tool.parseInt(strNroAutoriza), intTransac);
      //Fecha Movimiento Insunix
      //Broker Insunix
      //Reserva Insunix
      //Participacion Insunix
      //Moneda Insunix
      //Tipo Cambio Insunix
      objAvisoSolicitud.setNSolicitud(intIdSolicitud);
      objAvisoSolicitud.setSClinica(sClinica);
      objAvisoSolicitud.setSRamo(sRamo);
      objAvisoSolicitud.setSProducto(sProducto);
      objAvisoSolicitud.setSOficina(sOficina);
      objAvisoSolicitud.setSAsegurado(sAsegurado);
      objAvisoSolicitud.setSContratante(sContratante);
      objAvisoSolicitud.setNPoliza(intPoliza);
      objAvisoSolicitud.setNCertif(intCertif);
      objAvisoSolicitud.setNClaim(Tool.parseInt(strNroAutoriza));
      objAvisoSolicitud.setSPaciente(sAsegurado);
      objAvisoSolicitud.setSModalidad(sModalidad);
      //objAvisoSolicitud.setStrFechaEmision(strFechaEmision);
      objAvisoSolicitud.setSCobertura(sCobertura);
      objAvisoSolicitud.setSDeducible(sDeducible);
      objAvisoSolicitud.setDblCoaseguro(dblCoaseguro);
      objAvisoSolicitud.setNOficina(intCodOficina);
      objAvisoSolicitud.setNUsuario(usuario.getIntIdUsuario());
      objAvisoSolicitud.setDblSubTotal(dblSubTotalCarta);
      objAvisoSolicitud.setNMonedaCarta(intMonedaCarta);
      objAvisoSolicitud.setSClient(strSClient);
      intResultadoIns = gc.procesarAvisoSolicitud(objAvisoSolicitud);  // metodo que inserta u actualiza el aviso
      
      objSolicitud.setSCorreo(strSEmail);
      objSolicitud.setSClient(strSClient);
      //RQ2015-000750 Fin
    }
    //RQ2015-000604 Inicio  
  if ("rechazar".equals(strAcc) && staRechazo==1)
    {            
      objAvisoRechazo = gc.getDatosRSolicitudInx(Tool.parseInt(strNroAutoriza), intTransac);

      //RQ2015-000604 INICIO
      objAvisoRechazo.setNIdMotReSBS(intCodMotivoSBS);
      objAvisoRechazo.setNIDDiagnos(intCodDiagM);
      objAvisoRechazo.setNIdSubMotRe(intSubMotivo);
      objAvisoRechazo.setSDiagnos(strDiagnosM);
      objAvisoRechazo.setSProcedimient(strProcRecha);
      objAvisoRechazo.setSMotSBS(strMotivoSBS);
      objAvisoRechazo.setSSubMotSBS(strSubMotivo);
      //RQ2015-000604 FIN
      objAvisoRechazo.setNSolicitud(intIdSolicitud);
      objAvisoRechazo.setSClinica(sClinica);
      objAvisoRechazo.setSRamo(sRamo);
      objAvisoRechazo.setSProducto(sProducto);
      objAvisoRechazo.setSOficina(sOficina);
      objAvisoRechazo.setSAsegurado(sAsegurado);
      objAvisoRechazo.setSContratante(sContratante);
      objAvisoRechazo.setNPoliza(intPoliza);
      objAvisoRechazo.setNCertif(intCertif);
      objAvisoRechazo.setNClaim(Tool.parseInt(strNroAutoriza));
      objAvisoRechazo.setSPaciente(sAsegurado);
      objAvisoRechazo.setSModalidad(sModalidad);
      objAvisoRechazo.setStrFechaEmision(strFechaEmision);
      objAvisoRechazo.setSCobertura(sCobertura);
      objAvisoRechazo.setSDeducible(sDeducible);
      objAvisoRechazo.setDblCoaseguro(dblCoaseguro);
      objAvisoRechazo.setNOficina(intCodOficina);
      objAvisoRechazo.setNUsuario(usuario.getIntIdUsuario());
      objAvisoRechazo.setDblSubTotal(dblSubTotalCarta);
      objAvisoRechazo.setNMonedaCarta(intMonedaCarta);
      objAvisoRechazo.setSClient(strSClient);
      objAvisoRechazo.setNMontoRechazo(dblSubTotalCarta);
      //intResultadoIns = gc.procesarAvisoSolicitud(objAvisoSolicitud);  // metodo que inserta u actualiza el aviso      
      
      intResultadoRIns = gc.procesarRechazo(objAvisoRechazo);
      
      objSolicitud.setSCorreo(strSEmail);
      objSolicitud.setSClient(strSClient);      
    }    
    //RQ2015-000604 Fin
  if ("observar".equals(strAcc))
  {
    objSolicitud.setNIDESTADO(Constante.NESTOBS);
    objSolicitud.setSOBSERVAMED(strObserva);
    //PRT
    objSolicitud.setSOBSERVACLI(strObservaCli);      
    intIdRolResp = usuario.getIntIdRol();
    
     if (intFlgAmplia==1)
        intRet = gc.anulRechSolicitudAmpIfx(strNroAutoriza,Constante.NUSERCODE,intTransac,1,objSolicitudHis);
  }
  
  if ("rechazar".equals(strAcc))
  {
    objSolicitud.getObjSolhis().setNCODMOTIVO(intCodMotivo);
    objSolicitud.setNIDESTADO(Constante.NESTRECH);
    objSolicitud.setSOBSERVAMED(strObserva);
    //PRT
    objSolicitud.setSOBSERVACLI(strObservaCli);      
    intIdRolResp = usuario.getIntIdRol();
    if (intFlgAmplia==1)
      intRet = gc.anulRechSolicitudAmpIfx(strNroAutoriza,Constante.NUSERCODE,intTransac,7,objSolicitudHis);
    else
      intRet = gc.anulRechSolicitudIfx(strNroAutoriza, 7, objSolicitudHis);
  }
  //2015-000604
  if ("ampliar".equals(strAcc))
  {    
    objSolicitud.setNIDESTADO(Constante.NESTREG);
    objSolicitud.setNIDROLRESP(Constante.NROLOPE);
  }

  objSolicitud.setNIDSOLICITUD(intIdSolicitud);
  objSolicitud.setNIDROLRESP(intIdRolResp);
  objSolicitud.setNIDUSUARIO(usuario.getIntIdUsuario());
  objSolicitud.getObjSolhis().setSOBSERVA(strComenta);
  if (intRet == 0 || intRet==-100)
  {
    objSolicitud.getObjSolhis().setNTRANSAC(objSolicitudHis.getNTRANSAC());
    //PRT              
    int IdRolClinica = usuario.getIntIdRol();  
      intRet = gc.updFlujoSolicitud(objSolicitud, IdRolClinica);

    //RQ2015-000750 Inicio
    if ("aprobar".equals(strAcc))
    {    
      ParamNuevaMarcaService paramNuevaMarca = new ParamNuevaMarcaService();
      objAvisoSolicitud.setUrlLogo(paramNuevaMarca.getAndSetPathUrlLogo(request.getContextPath()));  
      
      intResultadoIns = gc.procesarAvisoCliente(objAvisoSolicitud);  // metodo que inserta u actualiza el aviso
    }
    //RQ2015-000750 Fin
    //RQ2015-000604 Inicio
    if ("rechazar".equals(strAcc) && intResultadoRIns == 0 && staRechazo==1)    
    {
      intResultadoIns = gc.procesarAvisoRechazo(objAvisoRechazo);  // metodo que inserta u actualiza el aviso      
    }
    //RQ2015-000604 FIN
    if ("derivar".equals(strAcc) || "enviar".equals(strAcc))
        gestorEmail.enviaEmailBandeja(1,intIdRolResp,intCodOficina,strNroAutoriza);
    if ("guardar".equals(strAcc))
    { 
    objAvisoRechazo = gc.getDatosCartaRechazo(Tool.parseInt(strNroAutoriza));
    objAvisoRechazo.setNClaim(Tool.parseInt(strNroAutoriza));
    objAvisoRechazo.setSCond_poli(strConPoli);
    objAvisoRechazo.setSCond_polii(strConPolii);
    objAvisoRechazo.setSNumCartRech(strNumRecha);    
    intRet =  gc.actualizaRechazo(objAvisoRechazo);    
     //objSolicitud = gc.getSolicitud(54141);
    }
    if (intRet <0 && intRet!=-100) intRet = -5;
    
    intIdHis = objSolicitud.getObjSolhis().getNIDHISTORICO();    
  }

    valoresDeSalida[0] = intRet;//Valor de respuesta del metodo 'actualizaRechazo' perteneciente a la clase 'GestorSolicitud'
    valoresDeSalida[1] = intIdHis;//Codigo del historial
    valoresDeSalida[2] = strNroAutoriza;//Codigo del siniestro o tambien llamado numero de solicitud
    
    notify();    
            
    return valoresDeSalida;
    
  }
  
  
  public Presupuesto cargarPresupuesto(HttpServletRequest request)
  {
      double dblMontoCuarto = Tool.parseDouble(request.getParameter("tcnMontoCuarto"));
      double dblMontoSalaOpera =  Tool.parseDouble(request.getParameter("tcnMontoSalaOpera"));
      double dblMontoSalaRecupa =  Tool.parseDouble(request.getParameter("tcnMontoSalaRecup"));
      double dblMontoCirujano =  Tool.parseDouble(request.getParameter("tcnMontoCirujano"));
      double dblMontoPrimerAsist =  Tool.parseDouble(request.getParameter("tcnMontoPrimerAsist"));
      double dblMontoSegundoAsist =  Tool.parseDouble(request.getParameter("tcnMontoSegundoAsis"));
      double dblMontoAnestesia = Tool.parseDouble(request.getParameter("tcnMontoAnestesia"));
      double dblMontoFarmaciaPiso = Tool.parseDouble(request.getParameter("tcnMontoFarmaciaPiso"));
      double dblMontoFarmaciaSala = Tool.parseDouble(request.getParameter("tcnMontoFarmaciaSala"));
      double dblMontoUsoEquip = Tool.parseDouble(request.getParameter("tcnMontoUsoEquip"));
      double dblMontoOxigeno = Tool.parseDouble(request.getParameter("tcnMontoConsumoOxig"));
      double dblMontoCardiologia = Tool.parseDouble(request.getParameter("tcnMontoCardiologia"));
      double dblMontoLaboratorio = Tool.parseDouble(request.getParameter("tcnMontoLaboratorio"));
      double dblMontoRadiologia = Tool.parseDouble(request.getParameter("tcnMontoRadiologia"));
      double dblMontoEcografia = Tool.parseDouble(request.getParameter("tcnMontoEcografia"));
      double dblMontoEquiposEsp = Tool.parseDouble(request.getParameter("tcnMontoEquiposEsp"));
      double dblMontoTomografia = Tool.parseDouble(request.getParameter("tcnMontoTomografia"));
      double dblMontoResonancia = Tool.parseDouble(request.getParameter("tcnMontoResonancia"));
      double dblMontoOtros = Tool.parseDouble(request.getParameter("tcnMontoOtros"));
      
      // AF-64
      double dblMontoOsteosintesis = Tool.parseDouble(request.getParameter("tcnMontoOsteosintesis"));
      double dblMontoProtesis = Tool.parseDouble(request.getParameter("tcnMontoProtesis")); 
      // FIn AF-64
      
      String strObsOtros = request.getParameter("txcObservaOtros").toString();
      
      Presupuesto objPresupuesto = new Presupuesto();
      ArrayList arrDetalle = new ArrayList();
      this.agregarDetalle(arrDetalle, Constante.CODMONTOCUARTO,dblMontoCuarto,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOSALAOPERA,dblMontoSalaOpera,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOSALARECUP,dblMontoSalaRecupa,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOCIRUJANO,dblMontoCirujano,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOPRIMERASIS,dblMontoPrimerAsist,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOSEGUNDOASIS,dblMontoSegundoAsist,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOANESTESIA,dblMontoAnestesia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOFARMACIAPISO,dblMontoFarmaciaPiso,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOFARMACIASALA,dblMontoFarmaciaSala,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOUSOEQUIP,dblMontoUsoEquip,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOOXIGENO,dblMontoOxigeno,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOCARDIOLOGIA,dblMontoCardiologia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOLABORATORIO,dblMontoLaboratorio,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTORADIOLOGIA,dblMontoRadiologia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOECOGRAFIA,dblMontoEcografia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOEQUIPOSESP,dblMontoEquiposEsp,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOTOMOGRAFIA,dblMontoTomografia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTORESONANCIA,dblMontoResonancia,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOOTROS,dblMontoOtros,strObsOtros);
      
       /* AF-64 */
      this.agregarDetalle(arrDetalle, Constante.CODMONTOOSTEOSINTESIS,dblMontoOsteosintesis,"");
      this.agregarDetalle(arrDetalle, Constante.CODMONTOPROTESIS,dblMontoProtesis,"");
      /* FIN AF-64 */
      
      objPresupuesto.setArrDetalle(arrDetalle);                                                   
      
      return objPresupuesto;
  }
   
  
  public void agregarDetalle(ArrayList arrDetalle, int intCodConcepto, double dblMontoConcepto, String strObservacion)
  {
    DetallePresupuesto objDetalle = new DetallePresupuesto();
    objDetalle.setDblMontoConcepto(dblMontoConcepto);
    objDetalle.setIntIdConcepto(intCodConcepto);
    objDetalle.setStrObservacion(strObservacion);
    arrDetalle.add(objDetalle);
  }
  
  
  /*RQ2015-00750 INICIO*/
  public synchronized int SendAvisoGerencia(HttpServletRequest request,HttpSession session, Usuario usuario, GestorSolicitud gc)
  {
    int intRet=-100;

    int intIdSolicitud = Tool.parseInt(request.getParameter("hcnIdSolicitud"));
    String strObserva = Tool.getString(request.getParameter("tctObservacionAviso"));
    
    AvisoSolicitud objAvisoSolicitud = new AvisoSolicitud();
    objAvisoSolicitud.setNSolicitud(intIdSolicitud);
    objAvisoSolicitud.setSObservacion(strObserva);
    objAvisoSolicitud.setNUsuario(usuario.getIntIdUsuario());
    
    intRet = gc.SendAvisoGerencia(objAvisoSolicitud);

    return intRet;
  }
  
}