package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.*;
import com.clinica.service.GestorUsuario;
import com.clinica.utils.Menu;
import com.clinica.utils.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;

public class ProcesoAcceso extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

   
   //GestorUsuario gestorUsuario = new GestorUsuario(); 

  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      response.setContentType(CONTENT_TYPE);
      PrintWriter out = null;
      int intProceso =  Tool.parseInt(request.getParameter("proceso"));
   
      GestorUsuario gestorUsuario = new GestorUsuario(); 
      
      switch (intProceso)
      {
          case 1: //Valida Usuario
          {    
              out = response.getWriter();
              HttpSession session = request.getSession(true);
              String strLogin = Tool.getString(request.getParameter("tctUsuario"));
              String strClave = Tool.getString(request.getParameter("tctClave"));
      
              int intIdUsuario = (request.getParameter("tcnIdUsuario")!=null?Tool.parseInt(request.getParameter("tcnIdUsuario")):0);
              String strNombre = Tool.getString(request.getParameter("tctNombre"));
              
           
              Usuario objUsuario = new Usuario();
              
              //SSRS Si se entra por el login de la aplicación
              if (intIdUsuario == 0 && !"".equals(strLogin) && !"".equals(strClave))
              {
                  objUsuario = gestorUsuario.getUsuario(strLogin,strClave) ;
                  if (objUsuario!=null)
                      strNombre = objUsuario.getStrNombreExt();
              }
              else if(intIdUsuario == 0 && !"".equals(strLogin) && "".equals(strClave))
              {
                  objUsuario = gestorUsuario.getUsuarioShare(strLogin) ;
              }          
              //SSRS Si se entra por la intranet
              if (intIdUsuario>0)
              {
                  objUsuario = gestorUsuario.getUsuario(intIdUsuario);
              }
        
              if (objUsuario!=null && objUsuario.getIntIdUsuario()>0)
              {      
              
                  if (objUsuario.getStrNombreExt() == null || objUsuario.getStrNombreExt().equals(""))
                      objUsuario.setStrNombreExt(strNombre);
                  synchronized(session)
                  {
                    session.setAttribute("USUARIO",objUsuario);
                  }
                  System.out.println("webServerTintaya: " + objUsuario.getStrWebServer());
                  //Req 2011-0849
                  if(objUsuario.getIntCodGrupo()==Constante.NCODGRUPOTINTA)
                  {
                    synchronized(session)
                    {
                      session.setAttribute("webServerTintaya",objUsuario.getStrWebServer());
                      
                    }
                  }
                  //Fin Req 2011-0849
                  int codgrupo =objUsuario.getIntCodGrupo();
                 BeanList lstModulo =  gestorUsuario.lstModulo(String.valueOf(objUsuario.getIntIdRol()),codgrupo);
                  BeanList lstModuloRol =  gestorUsuario.lstModuloRol(String.valueOf(objUsuario.getIntIdRol()),codgrupo);
                  
                  Menu mnu = new Menu(lstModulo,lstModuloRol);

                  synchronized(session)
                  {
                    session.setAttribute("MENU", mnu.GenerarMenu());
                  }
                  //response.sendRedirect("http://srvjavaapptest.lapositiva.com.pe:7780/webclinic_eps_dev/");
                  response.sendRedirect("../menu/Menu.jsp");
              }else
              {
                out.println("<script> alert('El Usuario no tiene acceso'); window.close();</script>");
              }
              out.close();
          }
          break;
          case 2: //Cambia Clinica
          {    
              HttpSession session = request.getSession(true);
              String strWebServer = Tool.getString(request.getParameter("pswebserver"));
              System.out.println("CODIGO DE LA CLINICA: " + strWebServer );
              synchronized(session)
              {
                session.setAttribute("STRWEBSERVER",strWebServer);
              }
          }
          break;
          case 3: 
          {    
              actualizaPassword(request, response, gestorUsuario);
          }
          break;
      }
  }
  
  public void actualizaPassword(HttpServletRequest request, HttpServletResponse response, GestorUsuario gestorUsuario)
        throws IOException, ServletException
  {
       
        String strUsuario = request.getParameter("tctUsuario"); 
        String strClave = request.getParameter("tctClave1");
        
        int intIdUsuario = Tool.parseInt(request.getParameter("hndUsuario"));
        
        //GestorUsuario objGestorUsuario = new GestorUsuario();
        
        Usuario objUsuario = gestorUsuario.getUsuario(intIdUsuario);
        
        int intResult = 0;
        
        if(strUsuario.equals(objUsuario.getStrLogin()))
        {
            intResult = gestorUsuario.updUsuGenPassword(intIdUsuario,strClave);
        }
       
        PrintWriter out = response.getWriter();
        
        out.print("<SCRIPT LANGUAGE=\"JavaScript\">");                       
        out.print("window.close();");
        out.print(" </script>");                       
        
        out.close();
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      doGet(request, response);
  }
}