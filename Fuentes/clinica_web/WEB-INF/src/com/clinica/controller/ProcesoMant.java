package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.*;
import com.clinica.service.GestorUsuario;
import com.clinica.utils.*;
import java.io.*;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;


public class ProcesoMant extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html; charset=windows-1252";
  
  //private HttpSession session; ======> Agregado
  
  //private static int intRamo = Constante.NRAMOASME; ======> Linea ya comentada
  //private String strParametrosJS; ======> No se utiliza esta variable en el servlet
  //private Usuario objUsuario=null;
  
  //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 29FEB2012 14:49pm
  //GestorPolClinic gestorPolClinic = new GestorPolClinic();  ======> Agregado
  //GestorRol gestorRol = new GestorRol(); ======> Agregado
  //GestorUsuario gestorUsuario = new GestorUsuario(); ======> Agregado
  
  
  //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012:48am
  //GestorCobertura gestorCobertura = new GestorCobertura(); ======> Agregado
  
  //RQ2015-000750 INICIO
  //GestorZonaOficina gestorZonaOficina = new GestorZonaOficina(); ======> Agregado
  //GestorAlerta gestorAlerta = new GestorAlerta(); ======> Agregado
  //GestorCorreo gestorCorreo = new GestorCorreo(); ======> Agregado
  //RQ2015-000750 FIN
  
  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    doGet(request,response);
  }
  
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {

    Usuario objUsuario = null;

    GestorPolClinic gestorPolClinic = new GestorPolClinic();
    GestorRol gestorRol = new GestorRol();
    GestorUsuario gestorUsuario = new GestorUsuario();
    GestorCobertura gestorCobertura = new GestorCobertura();
    GestorZonaOficina gestorZonaOficina = new GestorZonaOficina();
    GestorAlerta gestorAlerta = new GestorAlerta();
    GestorCorreo gestorCorreo = new GestorCorreo();



    PrintWriter out = null;
    HttpSession session = request.getSession(true);
    response.setContentType(CONTENT_TYPE);
    synchronized(session)
    {
      objUsuario = (Usuario) session.getAttribute("USUARIO");
    }  

        int intProceso = Tool.parseInt(request.getParameter("proceso"));
        String sHtml = "";
        switch(intProceso)
        {
            
        case 1: // Mantenimiento de Coberturas y Proveedores de la Red
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("crea"))
                  //ret = RegistraCliRed(request, session, gestorPolClinic, objUsuario); OLD_13-05-2019
                  ret = RegistraCliRed(request, gestorPolClinic, objUsuario);
              if (strAcc.equals("borra"))
                  //ret = BorraCliRed(request, session, gestorPolClinic, objUsuario); OLD_13-05-2019
                  ret = BorraCliRed(request, gestorPolClinic, objUsuario);
              if (strAcc.equals("edita"))
                  //ret = EditaCliRed(request, session, gestorPolClinic, objUsuario); OLD_13-05-2019
                  ret = EditaCliRed(request, gestorPolClinic, objUsuario);
                  
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.loadForm(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;
          case 2: // Mantenimiento de Usuarios
          {
              String strAcc = Tool.getString(request.getParameter("accion"));
              int ret = -10;
              if (strAcc.equals("crear"))
                  //ret = GrabaUsuario(request,response, session, gestorUsuario); OLD_13-05-2019
                  ret = GrabaUsuario(request,response, gestorUsuario); 
              if (strAcc.equals("editar"))
                  //ret = ActualizaUsuario(request,response, session, gestorUsuario); OLD_13-05-2019
                  ret = ActualizaUsuario(request,response, gestorUsuario);
            
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
          break;
          case 3: // Mantenimiento de Modulo por Rol
          {
              //int intIdRol = ActualizaRolModulo(request, session, gestorRol);  OLD_13-05-2019
              int intIdRol = ActualizaRolModulo(request, gestorRol);
              response.sendRedirect("../mantenimiento/MantenimientoModuloRol.jsp?lscRol=" + intIdRol);
          }
          break;  
          case 4: // Ver Firma
          {
              openFirma(request,response, gestorUsuario);
          }
          break;
          case 5: // Mantenimiento de Uso de Cobertura
          {
              //int ret = GrabaUsoCobertura(request,response, session, gestorCobertura);  OLD_13-05-2019
              int ret = GrabaUsoCobertura(request,response, gestorCobertura);
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
          break;
          case 6: // Mantenimiento de Control por Cobertura
          {
              //int ret = GrabaControlCobertura(request,response, session, gestorCobertura); OLD_13-05-2019
              int ret = GrabaControlCobertura(request,response, gestorCobertura);
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
          break;  
          //RQ2015-000750 INICIO
          case 7: // Mantenimiento de Zona Oficina
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("crea"))
                  //ret = GrabaZonaOficina(request,response, session, gestorZonaOficina); OLD_13-05-2019
                  ret = GrabaZonaOficina(request,response, gestorZonaOficina);
              if (strAcc.equals("edita"))
                  //ret = EditaZonaOficina(request,response, session, gestorZonaOficina); OLD_13-05-2019
                  ret = EditaZonaOficina(request,response, gestorZonaOficina);
                  
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;
          case 8: // Mantenimiento de Alerta
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("crea"))
                  //ret = GrabaAlerta(request,response, session, gestorAlerta); OLD_13-05-2019
                  ret = GrabaAlerta(request,response, gestorAlerta);
              if (strAcc.equals("edita"))
                  //ret = EditaAlerta(request,response, session, gestorAlerta); OLD_13-05-2019
                  ret = EditaAlerta(request,response, gestorAlerta);
                  
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;            
          case 9: // Mantenimiento de Correo
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("crea"))
                  //ret = GrabaCorreo(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = GrabaCorreo(request,response, gestorCorreo);
              if (strAcc.equals("edita"))
                  //ret = EditaCorreo(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = EditaCorreo(request,response, gestorCorreo);
          
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
           
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;   
          case 10: // Mantenimiento de Correo CC
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("CREA"))
                  //ret = GrabaCorreoAvisoGerencia(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = GrabaCorreoAvisoGerencia(request,response, gestorCorreo);
              if (strAcc.equals("DEL"))
                  //ret = EliminaCorreoAvisoGerencia(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = EliminaCorreoAvisoGerencia(request,response, gestorCorreo);
            
              if (ret == 0)
                response.sendRedirect("../avisogerencia/MantenimientoCorreoAvisoGerencia.jsp");
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
            
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;  
          case 11: // Mantenimiento de Correo Asegurado
          {
              int ret = -10;
              //ret = ProcesarEmailAsegurado(request,response, session, gestorCorreo); OLD_13-05-2019
              ret = ProcesarEmailAsegurado(request,response, gestorCorreo);
            
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
            
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break; 
          //RQ2015-000750 FIN 
          //RQ2015-000604 INICIO
          case 12: // Mantenimiento de Correo CC
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("CREA"))
                  //ret = GrabaCopiaCorreoRechazo(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = GrabaCopiaCorreoRechazo(request,response, gestorCorreo);
              if (strAcc.equals("DEL"))
                  //ret = EliminaCopiaCorreoRechazo(request,response, session, gestorCorreo); OLD_13-05-2019
                  ret = EliminaCopiaCorreoRechazo(request,response, gestorCorreo);
            
              if (ret == 0)
                response.sendRedirect("../cartarechazo/CorreoAlertaRechazo.jsp");
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
            
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;
          case 13: // Mantenimiento de Alerta
          {
              String strAcc = Tool.getString(request.getParameter("hctAcc"));
              int ret = -10;
              if (strAcc.equals("crea"))
                  //ret = GrabaAlertaRechazo(request,response, session, gestorAlerta); OLD_13-05-2019
                  ret = GrabaAlertaRechazo(request,response, gestorAlerta);
              if (strAcc.equals("edita"))
                  //ret = EditaAlertaRechazo(request,response, session, gestorAlerta); OLD_13-05-2019
                  ret = EditaAlertaRechazo(request,response, gestorAlerta);
                  
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.Regresar(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(" + ret + "); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break; 
          
      }    
  }

  //public int RegistraCliRed(HttpServletRequest request, HttpSession session, GestorPolClinic gestorPolClinic, Usuario objUsuario) OLD_13-05-2019
  public int RegistraCliRed(HttpServletRequest request, GestorPolClinic gestorPolClinic, Usuario objUsuario)
  {
    int intRet = -10;
    Usuario usuario = null;
      HttpSession session = request.getSession(true);
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }  
    int intUserCode = Tool.parseInt(objUsuario.getStrWebServer())==0?Constante.NUSERCODE:Tool.parseInt(objUsuario.getStrWebServer());
    int intRamo = Tool.parseInt(request.getParameter("tcnRamo"));
    int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
    int intRed = Tool.parseInt(request.getParameter("tcnRed"));
    int intProducto = Tool.parseInt(request.getParameter("tcnProducto"));
    int intPlan = Tool.parseInt(request.getParameter("hcnPlan"));
    int intModalidad = Tool.parseInt(request.getParameter("lscModalidad"));
    int intCobertura = Tool.parseInt(request.getParameter("hcnCobertura"));
    int intConcepto = Tool.parseInt(request.getParameter("lscConcepto"));
    int intDeduCant = Tool.parseInt(request.getParameter("tcnDeduCant"));
    double dblDeduMonto = Tool.parseDouble(request.getParameter("tcnDeduMonto"));
    double dblDeduPorc = Tool.parseDouble(request.getParameter("tcnDeduPorc"));
    double dblCoaPorc = Tool.parseDouble(request.getParameter("tcnCoaPorc"));
    double dblBenemax = Tool.parseDouble(request.getParameter("tcnBenemax"));
    int intProveedor = Tool.parseInt(request.getParameter("tcnProveedor"));
    String strEfecto = Tool.getString(request.getParameter("tcdEfecto"));    

    Pol_Clinic objPolClinic = new Pol_Clinic();
    objPolClinic.setIntBranch(intRamo);
    objPolClinic.setIntPolicy(intPoliza);
    objPolClinic.setIntRed(intRed);
    objPolClinic.setIntTariff(intPlan);
    objPolClinic.setIntModalidad(intModalidad);
    objPolClinic.setIntCover(intCobertura);
    objPolClinic.setIntPay_concep(intConcepto);
    objPolClinic.setIntDed_quanti(intDeduCant);
    objPolClinic.setDblDed_amount(dblDeduMonto);
    objPolClinic.setDblDed_percen(dblDeduPorc);
    objPolClinic.setDblIndem_rate(dblCoaPorc);
    objPolClinic.setIntCodClinic(intProveedor);
    objPolClinic.setDEffecdate(strEfecto);
    objPolClinic.setDblLimit(dblBenemax);
    
    boolean dblRet = false;
    dblRet = gestorPolClinic.valDatePolclinic(intRamo,intPoliza,intCobertura,intModalidad,intPlan, 
                                      intRed, intProveedor, strEfecto);
    
    if (dblRet){
      dblRet = gestorPolClinic.valinsPolclinic(intRamo,intPoliza,intCobertura,intModalidad,intPlan, 
                                      intRed, intProveedor, strEfecto);
      
      if (dblRet){
        dblRet = gestorPolClinic.insPolclinic(objPolClinic, objUsuario.getIntIdUsuario(), intUserCode);
        intRet = (dblRet?0:-1); //No se registro correctamente
      }else
        intRet = (dblRet?0:-2); //Clinica ya existe en la red
    }else
      intRet = -5; //La fecha de efecto no es válida
    
    return intRet;    
  }
 
   //public int EditaCliRed(HttpServletRequest request, HttpSession session, GestorPolClinic gestorPolClinic, Usuario objUsuario) OLD_13-05-2019
    public int EditaCliRed(HttpServletRequest request, GestorPolClinic gestorPolClinic, Usuario objUsuario)
  {
    int intRet = -10;
    Usuario usuario = null;
    HttpSession session = request.getSession(true);
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }  
    int intUserCode = Tool.parseInt(objUsuario.getStrWebServer())==0?Constante.NUSERCODE:Tool.parseInt(objUsuario.getStrWebServer());
    int intRamo = Tool.parseInt(request.getParameter("tcnRamo"));
    int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
    int intRed = Tool.parseInt(request.getParameter("tcnRed"));
    int intProducto = Tool.parseInt(request.getParameter("tcnProducto"));
    int intPlan = Tool.parseInt(request.getParameter("hcnPlan"));
    int intModalidad = Tool.parseInt(request.getParameter("lscModalidad"));
    int intCobertura = Tool.parseInt(request.getParameter("hcnCobertura"));
    int intConcepto = Tool.parseInt(request.getParameter("lscConcepto"));
    int intDeduCant = Tool.parseInt(request.getParameter("tcnDeduCant"));
    double dblDeduMonto = Tool.parseDouble(request.getParameter("tcnDeduMonto"));
    double dblDeduPorc = Tool.parseDouble(request.getParameter("tcnDeduPorc"));
    double dblCoaPorc = Tool.parseDouble(request.getParameter("tcnCoaPorc"));
    double dblBenemax = Tool.parseDouble(request.getParameter("tcnBenemax"));
    int intProveedor = Tool.parseInt(request.getParameter("tcnProveedor"));
    String strEfecto = Tool.getString(request.getParameter("tcdEfecto"));    
    

    Pol_Clinic objPolClinic = new Pol_Clinic();
    objPolClinic.setIntBranch(intRamo);
    objPolClinic.setIntPolicy(intPoliza);
    objPolClinic.setIntRed(intRed);
    objPolClinic.setIntTariff(intPlan);
    objPolClinic.setIntModalidad(intModalidad);
    objPolClinic.setIntCover(intCobertura);
    objPolClinic.setIntPay_concep(intConcepto);
    objPolClinic.setIntDed_quanti(intDeduCant);
    objPolClinic.setDblDed_amount(dblDeduMonto);
    objPolClinic.setDblDed_percen(dblDeduPorc);
    objPolClinic.setDblIndem_rate(dblCoaPorc);
    objPolClinic.setIntCodClinic(intProveedor);
    objPolClinic.setDEffecdate(strEfecto);
    objPolClinic.setDblLimit(dblBenemax);
    
    boolean dblRet = false;    
    if (intRed!=1){
      dblRet = gestorPolClinic.valDatePolclinic(intRamo,intPoliza,intCobertura,intModalidad,intPlan, 
                                      intRed, intProveedor, strEfecto);
      
      if (dblRet){    
        dblRet = gestorPolClinic.updPolclinic(objPolClinic,objUsuario.getIntIdUsuario(),intUserCode);
        intRet = (dblRet?0:-1); //No se registro correctamente
      }else
        intRet = -5; //La fecha de efecto no es válida
    }else
      intRet = -4; //Red 1 no ser Modificado
      
    return intRet;    
  }
  
   //public int BorraCliRed(HttpServletRequest request, HttpSession session, GestorPolClinic gestorPolClinic, Usuario objUsuario) OLD_13-05-2019
    public int BorraCliRed(HttpServletRequest request, GestorPolClinic gestorPolClinic, Usuario objUsuario)
  {
    int intRet = -10;
    Usuario usuario = null;
    HttpSession session = request.getSession(true);
    synchronized(session)
    {
      usuario = (Usuario)session.getAttribute("USUARIO");     
    }  
    int intUserCode = Tool.parseInt(objUsuario.getStrWebServer())==0?Constante.NUSERCODE:Tool.parseInt(objUsuario.getStrWebServer());   
    int intRamo = Tool.parseInt(request.getParameter("tcnRamo"));
    int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
    int intRed = Tool.parseInt(request.getParameter("tcnRed"));
    int intPlan = Tool.parseInt(request.getParameter("hcnPlan"));
    int intModalidad = Tool.parseInt(request.getParameter("lscModalidad"));
    int intCobertura = Tool.parseInt(request.getParameter("hcnCobertura"));
    int intProveedor =0;// = Tool.parseInt(request.getParameter("tcnProveedor"));
    String strEfecto = Tool.getString(request.getParameter("tcdEfecto"));    
    String hctCodsCli = Tool.getString(request.getParameter("hctCodsCli"));
    StringTokenizer arrCodsCli = new StringTokenizer(hctCodsCli, "|");
    boolean dblRet = false;
    int intErr =0;
    StringTokenizer arrCli = null;
    String strCli ="";
    Pol_Clinic objPolClinic = null;
    while(arrCodsCli.hasMoreTokens()){
      strCli = arrCodsCli.nextToken();
      arrCli = new StringTokenizer(strCli, ",");
      intProveedor = Tool.parseInt(arrCli.nextToken());      
      intModalidad = Tool.parseInt(arrCli.nextToken());
      intCobertura = Tool.parseInt(arrCli.nextToken());
      intRed = Tool.parseInt(arrCli.nextToken());
      objPolClinic = new Pol_Clinic();
      objPolClinic.setIntBranch(intRamo);
      objPolClinic.setIntPolicy(intPoliza);
      objPolClinic.setIntRed(intRed);
      objPolClinic.setIntTariff(intPlan);
      objPolClinic.setIntModalidad(intModalidad);
      objPolClinic.setIntCover(intCobertura);
      objPolClinic.setIntCodClinic(intProveedor);
      objPolClinic.setDEffecdate(strEfecto);
      dblRet = gestorPolClinic.delPolclinic(objPolClinic, objUsuario.getIntIdUsuario(),intUserCode);
      arrCli = null;
      objPolClinic = null;
      if (intErr==0)      
        intErr = (dblRet?0:-3); //Algunos no fueron eliminado
    }
    intRet = intErr;    
    return intRet;    
  } 
  
  //public int GrabaUsuario(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorUsuario gestorUsuario) OLD_13-05-2019
    public int GrabaUsuario(HttpServletRequest request,  HttpServletResponse response, GestorUsuario gestorUsuario)
  {
    int resultado=-1;
    try
    {
        Usuario usuario = null;
        HttpSession session = request.getSession(true);
        synchronized(session)
        {
          usuario = (Usuario)session.getAttribute("USUARIO");     
        }  
        int intUserReg = usuario.getIntIdUsuario();   
        
        int intIdUser = Tool.parseInt(request.getParameter("IdUsuario"));
        int intCodClinica = (request.getParameter("CodClinica").equals("")!=true?Tool.parseInt(request.getParameter("CodClinica")):0);
        String strCodServer = null;
        if(intCodClinica!=0)
        {
            Bean auxClinica= Tabla.getProvedorIfxCode(intCodClinica);
            strCodServer = auxClinica.getString("1");
        }
        int intCodRol = Tool.parseInt(request.getParameter("Rol"));
        int intCodOficina = Tool.parseInt(request.getParameter("Oficina"));
        String strConfFirma = request.getParameter("ConfFirma");
        String strConfFirmaDel = request.getParameter("ConfFirmaDel");
        String strEmail = request.getParameter("tctEmail");
        int intCodBroker = (request.getParameter("CodBroker")!=null?Tool.parseInt(request.getParameter("CodBroker")):0);
        String strLogin = request.getParameter("login");
        int intFlgDeshabilitado = (request.getParameter("flgDeshabilitado")!=null?Tool.parseInt(request.getParameter("flgDeshabilitado")):0);
        
        byte[] firma=UploadFile(request,response);
        
        Usuario objUsuario = new Usuario();
        objUsuario.setIntIdUsuario(intIdUser);
        objUsuario.setStrWebServer(strCodServer);
        objUsuario.setIntIdRol(intCodRol);
        objUsuario.setIntCodOficina(intCodOficina);
        objUsuario.setStrEmail(strEmail);
        objUsuario.setIntCodBroker(intCodBroker);
        objUsuario.setStrLogin(strLogin);
        
        objUsuario.setFirma(firma);
        
        objUsuario.setIntFlgDeshabilitado(intFlgDeshabilitado); //REQ. 2014-0000561 Paradigmasoft GJB
        
        resultado = gestorUsuario.insUsuario(objUsuario,intUserReg, strConfFirma);
    }
    catch(Exception e)
    {
        System.out.println("GrabaUsuario:" + e);
        e.printStackTrace();
    }
    return resultado;    
  }
  
  //public int ActualizaUsuario(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorUsuario gestorUsuario)  OLD_13-05-2019
    public int ActualizaUsuario(HttpServletRequest request,  HttpServletResponse response, GestorUsuario gestorUsuario)
  {
      int resultado = -1;
      try
      {
          Usuario usuario = null;
           HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          
          int intIdUser = Tool.parseInt(request.getParameter("IdUsuario"));
          int intCodClinica = (request.getParameter("CodClinica").equals("")!=true?Tool.parseInt(request.getParameter("CodClinica")):0);
          String strCodServer = null;
          if(intCodClinica!=0)
          {
              Bean auxClinica= Tabla.getProvedorIfxCode(intCodClinica);
              strCodServer = auxClinica.getString("1");
          }
          int intCodRol = Tool.parseInt(request.getParameter("Rol"));
          int intCodOficina = Tool.parseInt(request.getParameter("Oficina"));
          String strConfFirma = request.getParameter("ConfFirma");
          String strConfFirmaDel = request.getParameter("ConfFirmaDel");
          int intFlgActivo = Tool.parseInt(request.getParameter("flgActivo"));
          int intFlgFirma = Tool.parseInt(request.getParameter("flgFirma"));
          String strEmail = request.getParameter("Email");
          int intFlgDeshabilitado = Tool.parseInt(request.getParameter("flgDeshabilitado")); //REQ. 2014-0000561 Paradigmasoft GJB
        
          byte[] firma=UploadFile(request,response);
        
          Usuario objUsuario = new Usuario();
          objUsuario.setIntIdUsuario(intIdUser);
          objUsuario.setStrWebServer(strCodServer);
          objUsuario.setIntIdRol(intCodRol);
          objUsuario.setIntCodOficina(intCodOficina);
          objUsuario.setIntFlgActivo(intFlgActivo);
          objUsuario.setIntFlgFirma(intFlgFirma);
          objUsuario.setFirma(firma);
          objUsuario.setStrEmail(strEmail);
          //Inicio - Req. 2014-000561 Paradigmasoft GJB
          objUsuario.setIntFlgDeshabilitado(intFlgDeshabilitado);
          //Fin - Req. 2014-000561 Paradigmasoft GJB
          
          resultado = gestorUsuario.updUsuario(objUsuario,strConfFirma,strConfFirmaDel);
        
       }
        catch(Exception e)
        {
            System.out.println("GrabaUsuario:" + e);
            e.printStackTrace();
        }
        return resultado;
  } 
  
  //public int ActualizaRolModulo(HttpServletRequest request, HttpSession session, GestorRol gestorRol) OLD_13-05-2019
  public int ActualizaRolModulo(HttpServletRequest request, GestorRol gestorRol)
  {
      Usuario usuario = null;
      HttpSession session = request.getSession(true);
      synchronized(session)
      {
        usuario = (Usuario)session.getAttribute("USUARIO");     
      }  
      int intUserReg = usuario.getIntIdUsuario();   
      
      String strModulos = request.getParameter("sModulos");
      int intIdRol = Tool.parseInt(request.getParameter("lscRol"));
        
      int resultado = gestorRol.updModuloRol(strModulos,intIdRol,intUserReg); 
      return intIdRol;    
  } 
 
  public byte[] UploadFile(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
  {
      try
      {
          
          DiskFileUpload fu = new DiskFileUpload();
          int x = 0x7d0900;
          fu.setSizeMax(x);
          fu.setSizeThreshold(10096);
          fu.setRepositoryPath("/tmp");
          List fileItems = fu.parseRequest(request);
          FileItem ac = null;
          Iterator i = fileItems.iterator();
          FileItem actual = null;
          String fileName = "";
          File fichero=null;
          InputStream tmpfile=null;
          //FileInputStream tmpfile=null;
          String cadena="";
          int tam=0;
          //for(; i.hasNext(); actual.write(fichero))
          while(i.hasNext())
          {
              actual = (FileItem)i.next();
              tmpfile =actual.getInputStream();                
              //System.out.println("--long2=" + tmpfile + " tamaño:" +  actual.getSize());
              /*fileName = actual.getName();
              fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
              fichero = new File(fileName);
              fichero = new File("C:\\upload\\" + fichero.getName());
              cadena = "C:\\upload\\" + fichero.getName();
              actual.write(fichero);*/
          }
              //System.out.println("archivo adjunto:" + fichero.getName() + " tamaño=" + tam);
              tam=(int)actual.getSize();
              
              byte[] buf = new byte[tam];
              //System.out.println("cadena=" + cadena);
              //tmpfile = new FileInputStream(cadena);                
              tmpfile.read(buf);
              //System.out.println("terminando=" + tam);
              tmpfile.close();


        return buf;
          
      }
      catch(Exception e)
      {
          e.printStackTrace();
          return null;
      }
  }
  
  public void  openFirma(HttpServletRequest request, HttpServletResponse response, GestorUsuario gestorUsuario) throws ServletException, IOException
  {
      int intIdUsuario = Tool.parseInt(request.getParameter("idusuario"));
   
      String CONTENT_TYPE="text/html;charset=windows-1252";
      byte[] archivo=null;
      archivo = gestorUsuario.getFileFirmaBin(intIdUsuario);
      response.setContentType(CONTENT_TYPE);
      if (!(archivo==null))
      {
          ServletOutputStream outs = response.getOutputStream();
          outs.write(archivo);
          outs.flush();
          outs.close();    
      }
  }
  
  //public int GrabaUsoCobertura(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCobertura gestorCobertura) OLD_13-05-2019
  public int GrabaUsoCobertura(HttpServletRequest request,  HttpServletResponse response, GestorCobertura gestorCobertura)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          
        
          int intPoliza = (request.getParameter("pnpoliza").equals("")!=true?Tool.parseInt(request.getParameter("pnpoliza")):0);
          int intCobertura = (request.getParameter("pncobertura").equals("")!=true?Tool.parseInt(request.getParameter("pncobertura")):0);
          int intCoberturaGen = (request.getParameter("pncoberturagen").equals("")!=true?Tool.parseInt(request.getParameter("pncoberturagen")):0);
          int intPeriodo = (request.getParameter("pnperiodo").equals("")!=true?Tool.parseInt(request.getParameter("pnperiodo")):0);
          int intFrecuencia = (request.getParameter("pnfrecuencia").equals("")!=true?Tool.parseInt(request.getParameter("pnfrecuencia")):0);
          int intConcepto = (request.getParameter("pnconcepto").equals("")!=true?Tool.parseInt(request.getParameter("pnconcepto")):0);
          int intEstado = (request.getParameter("pnestado").equals("")!=true?Tool.parseInt(request.getParameter("pnestado")):0);
          int intTipoFrec = (request.getParameter("pntipofrec").equals("")!=true?Tool.parseInt(request.getParameter("pntipofrec")):0);
          
          resultado = gestorCobertura.insUsoCoberturaConfig(intPoliza, intCobertura, intPeriodo, intFrecuencia, intConcepto,
                                                   intUserReg,intCoberturaGen, intEstado, intTipoFrec);
      }
      catch(Exception e)
      {
          System.out.println("GrabaUsoCobertura:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int GrabaControlCobertura(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCobertura gestorCobertura) OLD_13-05-2019
  public int GrabaControlCobertura(HttpServletRequest request,  HttpServletResponse response, GestorCobertura gestorCobertura)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          
          int intPoliza = (request.getParameter("pnpoliza").equals("")!=true?Tool.parseInt(request.getParameter("pnpoliza")):0);
          int intCobertura = (request.getParameter("pncobertura").equals("")!=true?Tool.parseInt(request.getParameter("pncobertura")):0);
          int intCoberturaGen = (request.getParameter("pncoberturagen").equals("")!=true?Tool.parseInt(request.getParameter("pncoberturagen")):0);
          
          String strParametrosArray[] = request.getParameterValues("chcControl");
        
          int intResult = -1;
        
          if (strParametrosArray !=null)
          {
              intResult = gestorCobertura.delControlCoberturaConfig(intPoliza,intCoberturaGen);
              
              for(int i = 0; i < strParametrosArray.length; i++)
              {
                  String strControl  = strParametrosArray[i];
                  intResult = gestorCobertura.insControlCoberturaConfig(intPoliza,intCobertura,intCoberturaGen,strControl,intUserReg);
              }
          }
          
          return intResult;
          
      }
      catch(Exception e)
      {
          System.out.println("GrabaUsoCobertura:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }

  //RQ2015-000750 INICIO
  //public int GrabaZonaOficina(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorZonaOficina gestorZonaOficina)  OLD_13-05-2019
  public int GrabaZonaOficina(HttpServletRequest request,  HttpServletResponse response, GestorZonaOficina gestorZonaOficina)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intZona = (request.getParameter("nZona").equals("")!=true?Tool.parseInt(request.getParameter("nZona")):0);
          int intOficina = (request.getParameter("nOficina").equals("")!=true?Tool.parseInt(request.getParameter("nOficina")):0);
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "INS";
          
          resultado = gestorZonaOficina.insZonaOficina(intZona, intOficina, intUserReg, intEstado, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaZonaOficina:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EditaZonaOficina(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorZonaOficina gestorZonaOficina)  OLD_13-05-2019
  public int EditaZonaOficina(HttpServletRequest request,  HttpServletResponse response, GestorZonaOficina gestorZonaOficina)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intZona = (request.getParameter("nZona").equals("")!=true?Tool.parseInt(request.getParameter("nZona")):0);
          int intOficina = (request.getParameter("nOficina").equals("")!=true?Tool.parseInt(request.getParameter("nOficina")):0);
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "ACT";
          
          resultado = gestorZonaOficina.insZonaOficina(intZona, intOficina, intUserReg, intEstado, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaZonaOficina:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int GrabaAlerta(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorAlerta gestorAlerta)  OLD_13-05-2019
  public int GrabaAlerta(HttpServletRequest request,  HttpServletResponse response, GestorAlerta gestorAlerta)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sDescripcion = (request.getParameter("sDesc").equals("")!=true?(request.getParameter("sDesc").toString()):"");
          double dblMontoMinimo = (request.getParameter("nMontoMin").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMin")):0);
          double dblMontoMaximo = (request.getParameter("nMontoMax").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMax")):0);
          
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "INS";
          
          resultado = gestorAlerta.insAlerta(intAlerta, sDescripcion, dblMontoMinimo, dblMontoMaximo, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaAlerta:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EditaAlerta(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorAlerta gestorAlerta)  OLD_13-05-2019
  public int EditaAlerta(HttpServletRequest request,  HttpServletResponse response, GestorAlerta gestorAlerta)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sDescripcion = (request.getParameter("sDesc").equals("")!=true?(request.getParameter("sDesc").toString()):"");
          double dblMontoMinimo = (request.getParameter("nMontoMin").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMin")):0);
          double dblMontoMaximo = (request.getParameter("nMontoMax").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMax")):0);
          
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "ACT";
          
          resultado = gestorAlerta.insAlerta(intAlerta, sDescripcion, dblMontoMinimo, dblMontoMaximo, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaAlerta:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int GrabaCorreo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int GrabaCorreo(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intSec = (request.getParameter("nSec").equals("")!=true?Tool.parseInt(request.getParameter("nSec")):0);
          int intZona = (request.getParameter("nZona").equals("")!=true?Tool.parseInt(request.getParameter("nZona")):0);
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sCargo = (request.getParameter("sCargo").equals("")!=true?(request.getParameter("sCargo").toString()):"");
          String sApellido = (request.getParameter("sApellido").equals("")!=true?(request.getParameter("sApellido").toString()):"");
          String sNombre = (request.getParameter("sNombre").equals("")!=true?(request.getParameter("sNombre").toString()):"");
          String sEmail = (request.getParameter("sEmail").equals("")!=true?(request.getParameter("sEmail").toString()):"");
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "INS";
          
          resultado = gestorCorreo.insCorreo(intSec, intZona, intAlerta, sCargo, sApellido, sNombre, sEmail, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaCorreo:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EditaCorreo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int EditaCorreo(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intSec = (request.getParameter("nSec").equals("")!=true?Tool.parseInt(request.getParameter("nSec")):0);
          int intZona = (request.getParameter("nZona").equals("")!=true?Tool.parseInt(request.getParameter("nZona")):0);
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sCargo = (request.getParameter("sCargo").equals("")!=true?(request.getParameter("sCargo").toString()):"");
          String sApellido = (request.getParameter("sApellido").equals("")!=true?(request.getParameter("sApellido").toString()):"");
          String sNombre = (request.getParameter("sNombre").equals("")!=true?(request.getParameter("sNombre").toString()):"");
          String sEmail = (request.getParameter("sEmail").equals("")!=true?(request.getParameter("sEmail").toString()):"");
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "ACT";
          
          resultado = gestorCorreo.insCorreo(intSec, intZona, intAlerta, sCargo, sApellido, sNombre, sEmail, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("EditaCorreo:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int GrabaCorreoAvisoGerencia(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int GrabaCorreoAvisoGerencia(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int nIdCorreo = (request.getParameter("idcorreo").equals("")!=true?Tool.parseInt(request.getParameter("idcorreo")):0);
          String sCorreo = (request.getParameter("correo").equals("")!=true?(request.getParameter("correo")).toString():"");
          String strAction = "CREA";
          
          resultado = gestorCorreo.GrabaCorreoAvisoGerencia(nIdCorreo, sCorreo, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("EditaCorreo:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EliminaCorreoAvisoGerencia(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int EliminaCorreoAvisoGerencia(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int nIdCorreo = (request.getParameter("idcorreo").equals("")!=true?Tool.parseInt(request.getParameter("idcorreo")):0);
          String sCorreo = (request.getParameter("correo").equals("")!=true?(request.getParameter("correo")).toString():"");
          String strAction = "DEL";
          
          resultado = gestorCorreo.GrabaCorreoAvisoGerencia(nIdCorreo, sCorreo, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("EliminaCorreoAvisoGerencia:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int ProcesarEmailAsegurado(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int ProcesarEmailAsegurado(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          String sClient = (request.getParameter("sClient").equals("")!=true?(request.getParameter("sClient")).toString():"");
          String sCorreo = (request.getParameter("sEmail").equals("")!=true?(request.getParameter("sEmail")).toString():"");
          
          resultado = gestorCorreo.ProcesarEmailAsegurado(sClient, sCorreo, intUserReg);
      }
      catch(Exception e)
      {
          System.out.println("ProcesarEmailAsegurado:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  //RQ2015-000750 FIN
  //RQ2015-000604
  
  //public int GrabaCopiaCorreoRechazo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)   OLD_13-05-2019
    public int GrabaCopiaCorreoRechazo(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int nIdCorreo = (request.getParameter("idcorreo").equals("")!=true?Tool.parseInt(request.getParameter("idcorreo")):0);
          String sCorreo = (request.getParameter("correo").equals("")!=true?(request.getParameter("correo")).toString():"");
          String strAction = "CREA";
          
          resultado = gestorCorreo.GrabaCopiaCorreoRechazo(nIdCorreo, sCorreo, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("EditaCorreo:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EliminaCopiaCorreoRechazo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorCorreo gestorCorreo)  OLD_13-05-2019
    public int EliminaCopiaCorreoRechazo(HttpServletRequest request,  HttpServletResponse response, GestorCorreo gestorCorreo)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int nIdCorreo = (request.getParameter("idcorreo").equals("")!=true?Tool.parseInt(request.getParameter("idcorreo")):0);
          String sCorreo = (request.getParameter("correo").equals("")!=true?(request.getParameter("correo")).toString():"");
          String strAction = "DEL";
          
          resultado = gestorCorreo.GrabaCopiaCorreoRechazo(nIdCorreo, sCorreo, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("EliminaCorreoAvisoGerencia:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int GrabaAlertaRechazo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorAlerta gestorAlerta)  OLD_13-05-2019
    public int GrabaAlertaRechazo(HttpServletRequest request,  HttpServletResponse response, GestorAlerta gestorAlerta)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sDescripcion = (request.getParameter("sDesc").equals("")!=true?(request.getParameter("sDesc").toString()):"");
          String sCargo = (request.getParameter("sCargo").equals("")!=true?(request.getParameter("sCargo").toString()):"");
          double dblMontoMinimo = (request.getParameter("nMontoMin").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMin")):0);
          double dblMontoMaximo = (request.getParameter("nMontoMax").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMax")):0);
          
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "INS";
          
          resultado = gestorAlerta.insAlertaRechazo(intAlerta, sDescripcion, sCargo ,dblMontoMinimo, dblMontoMaximo, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaAlerta:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }
  
  //public int EditaAlertaRechazo(HttpServletRequest request,  HttpServletResponse response, HttpSession session, GestorAlerta gestorAlerta)  OLD_13-05-2019
    public int EditaAlertaRechazo(HttpServletRequest request,  HttpServletResponse response, GestorAlerta gestorAlerta)
  {
      int resultado=-1;
      try
      {
          Usuario usuario = null;
          HttpSession session = request.getSession(true);
          synchronized(session)
          {
            usuario = (Usuario)session.getAttribute("USUARIO");     
          }  
          int intUserReg = usuario.getIntIdUsuario();   
          int intAlerta = (request.getParameter("nAlerta").equals("")!=true?Tool.parseInt(request.getParameter("nAlerta")):0);
          String sDescripcion = (request.getParameter("sDesc").equals("")!=true?(request.getParameter("sDesc").toString()):"");
          String sCargo = (request.getParameter("sCargo").equals("")!=true?(request.getParameter("sCargo").toString()):"");
          double dblMontoMinimo = (request.getParameter("nMontoMin").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMin")):0);
          double dblMontoMaximo = (request.getParameter("nMontoMax").equals("")!=true?Tool.parseDouble(request.getParameter("nMontoMax")):0);
          
          int intEstado = (request.getParameter("nEstado").equals("")!=true?Tool.parseInt(request.getParameter("nEstado")):0);
          String strAction = "ACT";
          
          resultado = gestorAlerta.insAlertaRechazo(intAlerta, sDescripcion,sCargo, dblMontoMinimo, dblMontoMaximo, intEstado, intUserReg, strAction);
      }
      catch(Exception e)
      {
          System.out.println("GrabaAlerta:" + e);
          e.printStackTrace();
      }
      return resultado;    
  }

}