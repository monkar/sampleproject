package com.clinica.controller;

import com.clinica.utils.*;
import java.io.File;
import java.util.Iterator;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;


public class ProcesoUpload extends HttpServlet 
{
  String strArchivos="";

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    String strFile = request.getParameter("psnombre");
    procesaFicheros(request, response, strFile, Constante.getConst("URL_UPLOAD"));  
  }

  public boolean procesaFicheros(HttpServletRequest req, HttpServletResponse response, 
                                   String strNomFichero, String strPathFichero)
    {
        try
        {
             DiskFileUpload fu = new DiskFileUpload();
            int x = 0x7d0900;
            fu.setSizeMax(x);
            fu.setSizeThreshold(10096);
            fu.setRepositoryPath("/tmp");
            List fileItems = fu.parseRequest(req);
            FileItem ac = null;
            Iterator i = fileItems.iterator();
            FileItem actual = null;
            String fileName = "";
            File fichero;
            int w=0;
            while (i.hasNext())
            {
                w++;
                actual = (FileItem)i.next();
                fileName=actual.getName();
                //System.out.println("archivo:" + w + " " + fileName);
                if ("".equals(fileName))
                  continue;
                fileName = fileName.substring(fileName.lastIndexOf("."));
                System.out.println("filename->"+fileName);
                String titulo = strNomFichero + fileName;
                //fichero = new File(fileName);
                fichero = new File(strPathFichero + titulo);
                actual.write(fichero);
                if (!"".equals(strArchivos)) strArchivos = strArchivos + "|";
                strArchivos = strArchivos + titulo;

            }
        return true;

        }
        catch(Exception e)
        {
            System.out.println("error:" + e.getMessage());
            return false;
        }
   }  


  public void setStrArchivos(String strArchivos)
  {
    this.strArchivos = strArchivos;
  }


  public String getStrArchivos()
  {
    return strArchivos;
  }
}