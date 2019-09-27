package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.*;
import com.clinica.service.GestorSolicitud;
import com.clinica.utils.*;

import java.util.ArrayList;
import java.util.StringTokenizer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;

public class ProcesoAtencion extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html; charset=windows-1252";
  
  //private HttpSession session; ======> Agregado
  //private Usuario objUsuario = null; ======> Agregado
  //private String strWebServer = ""; ======> Agregado
  //private static int intRamo = 23; ======> No se utiliza
  
        //Instanciando el objeto que va acceder a los metodos Daos.
            //Atencion atencion = new Atencion(); ======> Agregado
            //GestorSolicitud gs = new GestorSolicitud(); ====> Agregado
         //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012 10:29am
           //GestorCliente gestorCliente = new GestorCliente(); ====> Agregado
         //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  16:23pm
          //GestorClinica gestorClinica = new GestorClinica(); ====> Agregado
        
  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      
    String strWebServer = "";
    Usuario objUsuario = null;  
    
    Atencion atencion = new Atencion();
    GestorSolicitud gs = new GestorSolicitud();
    GestorCliente gestorCliente = new GestorCliente();
    GestorClinica gestorClinica = new GestorClinica();              
    HttpSession session = request.getSession(true);
    
    
    PrintWriter out = null;
    response.setContentType(CONTENT_TYPE);
        
    synchronized(session)
    {
      objUsuario = (Usuario) session.getAttribute("USUARIO");
    }
    if (objUsuario == null)
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
          strWebServer = objUsuario.getStrWebServer();        
          
        int intProceso = Tool.parseInt(request.getParameter("proceso"));
        String sHtml = "";
        switch(intProceso)
        {
        case 1: // Obtiene Lista de los Clientes
          {
              
              int ret = ValidaCaso(request, gs);
              
              if (ret == 0)
              //ret = getLstCliente(request,objUsuario, session, atencion, strWebServer); OLD_13-05-2019
              ret = getLstCliente(request,objUsuario, atencion, strWebServer);
              
              System.out.println("ret :"+ret);
              if (ret == 0)
               //  request.getRequestDispatcher("../consulta/ListaCliente.jsp").forward(request,response);
               sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verListado(); </script>";
              else if (ret == -200)
               sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta("+ -7 +"); </script>";
              else if (ret == -100)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(); </script>";
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();

          }
            break;
        case 2: // Obtiene Datos del Cliente
          {
              int ret = -1;
              int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
              int intRamo = Tool.parseInt(request.getParameter("tctCodRamo"));
              int intCase = Tool.parseInt(request.getParameter("tctCase"));                                                    
              
              Caso objCaso=new Caso();              
              objCaso.setCaso(intCase);
              synchronized(session)
              {
                session.setAttribute("NumeroCaso",objCaso);
              }
              
              boolean  blPolCli = gestorClinica.getPolClinica(strWebServer,intPoliza,intRamo); // Agregado el parametro "intRamo" Apple                                                                                  
              
              if (blPolCli == true)
              {
                int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
                boolean blVigCert = gestorCliente.getCertifVig(intPoliza,intCertif,intRamo);// Agregado el parametro "intRamo" Apple
                if (blVigCert == true)
                    //ret = getDatoCliente(request, session, atencion, gestorCliente, strWebServer); OLD_13-05-2019
                    ret = getDatoCliente(request, atencion, gestorCliente, strWebServer);
                else
                    ret = -3; //Alerta de Certificado no vigente
              }
              else
                ret = -2; //Alerta de clinica no afiliada a la poliza

               if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verDetalle(); </script>";
               else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta('" + ret + "'); </script>"; //Alerta de lectura de datos
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;
        case 3: // Obtiene las Exclusiones del Cliente
          {
              //int ret = getLstExclusion(request, session, atencion); OLD_13-05-2019
              int ret = getLstExclusion(request, atencion);
              if (ret == 0)
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verExclusion(); </script>";
              else
                sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(); </script>";

              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            break;

        case 4: // Genera Autorizacion
        {
              
              //SSRS Se creo el método que maneje sincronización apra la generación de SB
              String  strNroAutoriza = GeneraAutorizacion(request, gs, strWebServer);
              int intGenCover = -1;
                                                                            
              if (!"".equals(strNroAutoriza) && !"-1".equals(strNroAutoriza))
              {                                                                  
                  //SSRS Se obtiene el codigo de siniestro generado y la cobertura generica para distinguir entre SB y SBO
                  StringTokenizer stkAutoriza =new StringTokenizer(strNroAutoriza, "|");
                  while (stkAutoriza.hasMoreTokens())
                  {
                      strNroAutoriza = stkAutoriza.nextToken();
                      intGenCover = Tool.parseInt(stkAutoriza.nextToken());
                  }
                  sHtml = "<SCRIPT LANGUAGE=\"JavaScript\">  parent.verAutoriza('" + strNroAutoriza + "','" + intGenCover  + "'); </script>";  
              }
              else if("-1".equals(strNroAutoriza))
              {
                  sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta(); </script>";
              }
                            
              out = response.getWriter();
              out.print(sHtml);
              out.close();
        }
        break;
        case 5: // Obtiene las Exclusiones del Cliente
          {
              //int ret = getLstExclusion(request, session, atencion); OLD_13-05-2019
              int ret = getLstExclusion(request, atencion);
          }
            break;
       case 6: // Ver Carta de Beneficio
          {
              String strNroAutoriza = request.getParameter("nSiniestro"); //Siniestro
              String strCobertura = request.getParameter("sCobertura");
              String strFecha = Tool.getString(request.getParameter("sFecha"));
              
              //getDatoCliente(request, session, atencion, gestorCliente, strWebServer); OLD_13-05-2019  
              getDatoCliente(request, atencion, gestorCliente, strWebServer);
              
              BeanList objLstCober = new BeanList();
              Cobertura objCobertura = null;
              synchronized(session)
              {
                if (session.getAttribute("ListaCobertura")!=null)
                  objLstCober = (BeanList)session.getAttribute("ListaCobertura");
              }
              for(int i=0; i<objLstCober.size(); i++)
              {
                  objCobertura = (Cobertura)objLstCober.get(i);
                  if (objCobertura.getIntCover() == Tool.parseInt(strCobertura))
                  break;                  
              }
                 
              int intGenCover = objCobertura.getIntCoverGen();
             
              synchronized(session)
              {
                session.setAttribute("CoberturaSel",objCobertura);
              }
              
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAutoriza('" + strNroAutoriza + "','" + intGenCover  + "','" + strFecha + "'); </script>";  
              out = response.getWriter();
              out.print(sHtml);
              out.close();
             
          }
          break;
          //RQ2015-000750 Inicio
        case 7: // Obtiene Datos del Cliente
          {
              int ret = -1;
              int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
              int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
              int intRamo = Tool.parseInt(request.getParameter("tctCodRamo"));
              
              boolean blVigCert = gestorCliente.getCertifVig(intPoliza,intCertif,intRamo); // Agregado el parametro "intRamo" Apple
              if (blVigCert == true)
                  //ret = getDatoCliente(request,session, atencion, gestorCliente, strWebServer);
                  ret = getDatoCliente(request, atencion, gestorCliente, strWebServer);
              else
                  ret = -3; //Alerta de Certificado no vigente

             if (ret == 0)
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verDetalle(); </script>";
             else
              sHtml = "<SCRIPT LANGUAGE=\"JavaScript\"> parent.verAlerta('" + ret + "'); </script>"; //Alerta de lectura de datos
                
              out = response.getWriter();
              out.print(sHtml);
              out.close();
          }
            //RQ2015-000750 Fin
            break;
        } 
    }   
  }

   /* Se agrego un parametro mas Usuario objUsuario yahirRivas 23FEB2012 */

   //private int getLstCliente(HttpServletRequest request,Usuario objUsuario, HttpSession session, Atencion atencion, String strWebServer)
   private int getLstCliente(HttpServletRequest request,Usuario objUsuario, Atencion atencion, String strWebServer)
  {
    
    int intCodBroker = objUsuario.getIntCodBroker();
    
    int intRet = -1;
              int intTipoBusq = Tool.parseInt(request.getParameter("opcTipBus"));
              BeanList objLista = new BeanList();     
              
    
    
    //Para el caso de que el usuario no tenga clinica asociada - Broker
    if(strWebServer==null || strWebServer.equals(""))
        strWebServer = request.getParameter("lscClinica");
   /*     
    //Req 2011-0849    
    if(objUsuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA)
    {
      //strWebServer = session.getAttribute("webServerTintaya").toString();
    }
    //Fin Req 2011-0849
    */
    if (intTipoBusq == 1)
    {
        int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
        int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));              
        objLista = atencion.lstCliente(intPoliza, intCertif,strWebServer, intCodBroker);
        
    }
    else if(intTipoBusq == 2)       //Nombre
    {
        String strNombre = request.getParameter("tctNombre");
        int intRamo = Tool.parseInt(request.getParameter("lscRamo"));        
        //System.out.println("msg2");
        objLista = atencion.lstCliente(strNombre + "*", strWebServer, intCodBroker);
    }    
    
    //INI
    //Se agrego parametros de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    else if(intTipoBusq == 3)
    {
       
        String strNombreApe = "";
        String strCodigo    = "";     
        String strTipo      = "D"; 
        String strDNI = request.getParameter("tcnDni");
        int intRamo = Tool.parseInt(request.getParameter("lscRamo3"));              
        objLista = atencion.lstClienteFiltro(strDNI,strNombreApe,strCodigo,strTipo,strWebServer, intCodBroker , intRamo );                        
    }    
    
    else if(intTipoBusq == 4)
    {
        String strDNI    = "";        
        String strCodigo = "";
        String strTipo   = "N";              
        String strNombreApe = request.getParameter("tctNomApe");    
        int intRamo = Tool.parseInt(request.getParameter("lscRamo4")); 
        objLista = atencion.lstClienteFiltro(strDNI,"*" + strNombreApe + "*", strCodigo,strTipo,strWebServer, intCodBroker,intRamo);        
        //objLista = Atencion.lstClienteFiltro(strDNI,strNombreApe,strCodigo,strTipo,strWebServer, intCodBroker);        
        
    }
    else if(intTipoBusq == 5)
    {
        String strDNI       = "";
        String strNombreApe = "";
        String strTipo      = "C";
        String strCodigo = request.getParameter("tctCliente");      
        int intRamo = Tool.parseInt(request.getParameter("lscRamo5"));
        objLista = atencion.lstClienteFiltro(strDNI,strNombreApe,strCodigo,strTipo,strWebServer, intCodBroker,intRamo);        
    }
    //FIN
    //Se agrego parametros de busqueda por DNI,Apellidos,Nombres y Codigo Cliente Asegurado_____Cambio QNET 28/12/11
    
    /*
    //Req 2011-0849 
    if(objUsuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA)
    {
      //strWebServer =  (String) session.getAttribute("STRWEBSERVER");
      if ("".equals(strWebServer) || strWebServer == null)
        strWebServer = objUsuario.getStrWebServer(); 
    }
    //Fin Req 2011-0849 
    */
    if (objLista!=null)
    {
        BeanList objLstCliente = new BeanList();
        Cliente objCliente = null;
        String strTrama = "";
        String strValor = "";
        StringTokenizer stkTrama = null;
        for (int i=0;i<objLista.size();i++)
        {
            strTrama = objLista.getBean(i).getString("1");
            stkTrama = new StringTokenizer(strTrama, "|");
            objCliente = new Cliente();
            if (stkTrama.hasMoreTokens())
              objCliente.setIntPoliza(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCliente.setIntCertificado(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCliente.setStrNombreAseg(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setStrCodigo(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setIntRamo(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCliente.setStrRamo(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setIntCase(Tool.parseInt(stkTrama.nextToken()));
            //-------------------------//
            if (stkTrama.hasMoreTokens())
              objCliente.setStrCausa(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setStrOcurr(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setStrClinic(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setStrContratante(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCliente.setStrIngres(stkTrama.nextToken());
    
            if (atencion.validaClienteVip(objCliente.getIntPoliza(),objCliente.getIntCertificado())==1)
                objCliente.setIntCategoria(Constante.CATEGORIAVIP);
            else
                objCliente.setIntCategoria(Constante.CATEGORIANORMAL);
  
                  
            objLstCliente.add(objCliente);  
            objCliente = null;
            stkTrama = null;
            
        }
        HttpSession session = request.getSession(true);
        synchronized(session)
        {
          session.setAttribute("ListaCliente",objLstCliente);
        }
        objLstCliente = null;
        intRet = 0;
      }
      return intRet;              
  }
  
  //private int getDatoCliente(HttpServletRequest request, HttpSession session, Atencion atencion, GestorCliente gestorCliente, String strWebServer)
  private int getDatoCliente(HttpServletRequest request, Atencion atencion, GestorCliente gestorCliente, String strWebServer)  
  {
    int intRet = -1;
              String strCodCliente = request.getParameter("tctCodCliente");
              int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
              int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
              int intRamo   = Tool.parseInt(request.getParameter("tctCodRamo"));
              //Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer); Apple
              Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer,intRamo);
              
              
//              int intEstadoDeudaCliente = atencion.getEstadoCliente(intPoliza,intCertif); Modificado para Apple
                int intEstadoDeudaCliente = atencion.getEstadoCliente(intPoliza,intCertif,intRamo);

              if (objAtencion!=null)
              {

                 Cliente objCliente =  gestorCliente.setCliente(objAtencion,strCodCliente);
                 
                  if (objCliente.getIntCodEstado()==1)
                      return -4; //Cliente Cesado
                  if (objCliente.getIntCodEstado()==3)
                  {
                      if(intEstadoDeudaCliente==2)
                          return intRet = -5; //Cliente Bloqueado
                          //return -5; //Cliente Bloqueado
                  }
  
                  objCliente.setIntEstadoDeuda(intEstadoDeudaCliente);
                  
                  HttpSession session = request.getSession(true);
                  synchronized(session)
                  {
                    session.setAttribute("DatoCliente",objCliente);
                  }
     
                  
                  Caso objCaso=new Caso();        
                  if (session.getAttribute("NumeroCaso")!=null){
                  objCaso = (Caso)session.getAttribute("NumeroCaso");
                  System.out.println("Numero de caso Proceso Atencion :"+objCaso.getCaso());
                  }
                  
                  /*getLstCobertura (objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                                  objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                  objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                                  //strCodCliente, objCliente.getIntCodEstado(),intRamo,objCaso.getCaso());
                                  strCodCliente, objCliente.getIntCodEstado(),intRamo,objCaso.getCaso(), session, atencion);*/
                  getLstCobertura (objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                                  objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                  objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                                  //strCodCliente, objCliente.getIntCodEstado(),intRamo,objCaso.getCaso());
                                                    strCodCliente, objCliente.getIntCodEstado(),intRamo,objCaso.getCaso(), request, atencion);
                  
                  objCliente = null;
                  intRet = 0;
              }  
              
    return intRet;
  }

  
  //public int getLstExclusion(HttpServletRequest request, HttpSession session, Atencion atencion)
    public int getLstExclusion(HttpServletRequest request, Atencion atencion)
  {
   int intRet = -1;
   
      int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
      int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
      int intRamo = Tool.parseInt(request.getParameter("tctRamo")); // Apple
      String strCodCliente = Tool.getString(request.getParameter("tctCodCliente"));
      BeanList objLstExcl = atencion.getLstExclusion(intPoliza,intCertif,strCodCliente,intRamo);
      if (objLstExcl!=null){
          
        HttpSession session = request.getSession(true);  
        synchronized(session)
        {
          session.setAttribute("ListaExclusion",objLstExcl);
        }
        objLstExcl = null;
        intRet = 0;
      }
      
      //BeanList objLista = null;      
      
      /*objLista = Atencion.lstExclusion(intRamo, intPoliza, intCertif, strCodCliente, Tool.getDateIfx());
      if (objLista!=null){
          BeanList objLstExcl = new BeanList();
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
          session.setAttribute("ListaExclusion",objLstExcl);
          objLstExcl = null;
          intRet = 0;
      }*/
    return intRet;
  }
  
  

  /*private int getLstCobertura(int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado,int intRamo,int intCaso, HttpSession session, Atencion atencion)*/
  private int getLstCobertura(int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                                 int intEstado,int intRamo,int intCaso, HttpServletRequest request, Atencion atencion)
    
  {
    int intRet = -1;
    
      BeanList objLista = null;
      objLista = atencion.lstCobertura(intProducto, intTariff, intCurrency, 
                                       intRelation, strSexo, intPoliza, 
                                       intCertif, strClinica, strCodCliente,
                                       intEstado,intRamo,intCaso);

      if (objLista!=null){
          BeanList objLstCober = new BeanList();
          Cobertura objCober = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
            strTrama = objLista.getBean(i).getString("1");
            stkTrama = new StringTokenizer(strTrama, "|");
            objCober = new Cobertura();
            if (stkTrama.hasMoreTokens())
              objCober.setStrNomCobertura(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrConceptoPago(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrTipoDeducible(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrImpDeducible(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrDeducible(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrCoaseguro(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrBeneficioMax(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setStrBeneficioCons(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setIntPeridoCarencia(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCober.setStrCantidad(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objCober.setIntTipoAtencion(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCober.setIntCoverGen(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCober.setIntCover(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCober.setIntConceptoPago(Tool.parseInt(stkTrama.nextToken()));
            if (stkTrama.hasMoreTokens())
              objCober.setIntPeriodoTrans(Tool.parseInt(stkTrama.nextToken()));
             if (stkTrama.hasMoreTokens())
              objCober.setStrCacalili(stkTrama.nextToken());
          System.out.print("Mensaje" + objCober.getStrNomCobertura() + ' ' + objCober.getStrConceptoPago() 
                           + ' ' + objCober.getStrTipoDeducible() + ' ' + objCober.getStrImpDeducible() + ' ' + 
                      objCober.getStrDeducible() + ' ' + objCober.getStrCoaseguro() + ' ' + objCober.getStrBeneficioMax() + ' ' + 
                      objCober.getStrBeneficioCons() + ' ' + objCober.getIntPeridoCarencia()  + ' ' +  objCober.getStrCantidad()  + ' ' +  
                      objCober.getIntTipoAtencion()  + ' ' +  objCober.getIntCoverGen()  + ' ' +   objCober.getIntCover()  + ' ' +  
                      objCober.getIntConceptoPago()  + ' ' +  objCober.getIntPeriodoTrans()  + ' ' +  objCober.getStrCacalili());
            if (objCober.getIntTipoAtencion()==1)
                objCober.setStrTipoAtencion("HOSP");
            if (objCober.getIntTipoAtencion()==2)
                objCober.setStrTipoAtencion("AMB");
                
            objLstCober.add(objCober);    
            objCober = null;
                    
          }
          HttpSession session = request.getSession(true);  
          synchronized(session)
          {
            session.setAttribute("ListaCobertura",objLstCober);
          }
          objLstCober = null;
          intRet = 0;
      }
    
    return intRet;
  }
 
  
  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    doGet(request,response);
  }
  
  public synchronized String GeneraAutorizacion(HttpServletRequest request, GestorSolicitud gs, String strWebServer)
  {
      int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
      int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
      String strCodCliente = Tool.getString(request.getParameter("tctCodCliente"));
      int intCover = Tool.parseInt(request.getParameter("pncover"));
      String strTipoaten = Tool.getString(request.getParameter("pstipoaten"));
      int intRamo = Tool.parseInt(request.getParameter("tctCodRamo")); // APple
      int intSelcover = Tool.parseInt(request.getParameter("pnselcover"));
      int intConceptoPago = Tool.parseInt(request.getParameter("pnconcepto"));
      
      String strUsuarioWebServer = Tool.getString(request.getParameter("pusuariowebserver"));            
        /*alert("tcnPoliza :"+ poliza + "tcnCertif :"+certif+"tctCodCliente :"+ codCliente + 
      "pnselcover :"+pnselcover+"pncover :"+pncover+"pstipoaten :" pnconcepto  pusuariowebserver
      );*/
      /*System.out.println("intPoliza :"+intPoliza+"intCertif :" +intCertif + "strCodCliente :"+strCodCliente +
                                     "intSelcover :"+intSelcover + "intCover :"+intCover+"strTipoaten :"+strTipoaten + "intConceptoPago :"+
                                     intConceptoPago + "strUsuarioWebServer :"+strUsuarioWebServer
                                     );    */ 
      //gs.strWebServerSol=strUsuarioWebServer;
      String strNroAutoriza = gs.generaSolicitudSyn(intPoliza, intCertif, strCodCliente, strWebServer,intCover,intConceptoPago,intSelcover,strUsuarioWebServer,intRamo);
      
      notify();
      return strNroAutoriza;
  }
  
  private int ValidaCaso(HttpServletRequest request, GestorSolicitud gs)
  {  
        int intPoliza = Tool.parseInt(request.getParameter("tcnPoliza"));
        int intCertif = Tool.parseInt(request.getParameter("tcnCertif"));
        String strNombre = request.getParameter("tctNombre");
        String strDNI = request.getParameter("tcnDni");
        String strNombreApe = request.getParameter("tctNomApe");
        String strCodigo = request.getParameter("tctCliente");
        
        int validarCaso = gs.ValidarCaso(intPoliza,intCertif,strNombre,strDNI,strNombreApe,strCodigo);
        
    return validarCaso;
  }
  

}