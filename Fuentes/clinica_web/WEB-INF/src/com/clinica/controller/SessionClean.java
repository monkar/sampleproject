package com.clinica.controller;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;
import com.clinica.utils.*;

public class SessionClean extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

  public void init(ServletConfig config) throws ServletException
  {

  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    HttpSession session = request.getSession(true);
    PrintWriter out = null;
    out = response.getWriter(); 
    int intProceso =  Tool.parseInt(request.getParameter("proceso"));
    switch (intProceso){

    case 1: //Sale de Solicitud
      {    
        synchronized(session)
        {
          session.removeAttribute("SolicitudSel");
        }  
      }
      break;
    case 2: //Cambia de Menu
      {    
        synchronized(session)
        {
          session.removeAttribute("DatoCliente");
          session.removeAttribute("CoberturaSel");
          session.removeAttribute("CoberturaSel");
          session.removeAttribute("ListaCobertura");
          session.removeAttribute("ListaCliente");
          session.removeAttribute("SolicitudSel");
          session.removeAttribute("ListaExclusion");
        }
      }
      break;
    }    
          out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>1</Valor> \n" +
                      "</Valida>");          
          out.close();
    
  }

 public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      doGet(request, response);
  }  
}