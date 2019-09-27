package com.clinica.controller;

import com.clinica.beans.*;
import com.clinica.service.*;

import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Constante;
import com.clinica.utils.Tabla;
import com.clinica.utils.Tool;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.io.IOException;

public class ProcesoValida extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html; charset=windows-1252";
  
       //private HttpSession session;

       //Instanciando el objeto que va acceder a los metodos Daos.yahirRivas 29FEB2012  14:48Pm
       //GestorRol gestorRol = new GestorRol();
       //GestorPolClinic gestorPolClinic = new GestorPolClinic();
       //Atencion atencion = new Atencion();
       //GestorCliente gestorClie = new GestorCliente();//BIT FLOPEZ RQ2013-000400

          //Instanciando el objeto que va acceder a los metodos Daos. yahirRivas 02MAR2012  10:51am
       //GestorCobertura gestorCobertura = new GestorCobertura();
 
  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    response.setContentType(CONTENT_TYPE);
    valida(request,response);
  }

  public void  valida(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
  {
      
      GestorRol gestorRol = new GestorRol();
      GestorPolClinic gestorPolClinic = new GestorPolClinic();
      Atencion atencion = new Atencion();
      GestorCliente gestorClie = new GestorCliente();
      
      GestorCobertura gestorCobertura = new GestorCobertura();
      
      HttpSession session;
      try{
    
          PrintWriter out = response.getWriter();  
          int tipoval = Tool.parseInt(request.getParameter("pntipoval"));
          
          switch(tipoval)
            {
             case 1: // Obtiene la fecha del sistema
             {  
                String strFecSytem = Tool.getDateIfx();

               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strFecSytem + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             case 2: // Valida Rango de Rol
             {  
                int intRol = Tool.parseInt(request.getParameter("pnidrol"));
                int intCodMoneda = Tool.parseInt(request.getParameter("pnidmoneda"));
                double bdlRangoMaxSol = gestorRol.getRangoRol(intRol);
                double dblTipoCambio = Tool.parseDouble(Tool.getTipoCambio());
                double dblImpCalc =0;
                if (intCodMoneda == Constante.NCODMONEDALOCAL)
                    dblImpCalc = bdlRangoMaxSol;
                else
                    dblImpCalc = bdlRangoMaxSol / dblTipoCambio;
        
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + dblImpCalc + "</Valor> \n" +
                      "</Valida>");
             }  
             break;

             case 3: // Obtiene Descripcion de Diagnostico
             {  
                String strCodDiagnos = Tool.getString(request.getParameter("pndiagnos"));
                String strDiagnos = Tool.getString(Tabla.getDiagnosticoIfx(strCodDiagnos));
        
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strDiagnos + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             case 4: // Convierte Moneda
             {  
                int intRol = Tool.parseInt(request.getParameter("pnidrol"));
                int intCodMoneda = Tool.parseInt(request.getParameter("pnidmoneda"));
                double bdlRangoMaxSol = gestorRol.getRangoRol(intRol);
                double dblTipoCambio = Tool.parseDouble(Tool.getTipoCambio());
                double dblImpCalc =0;
                if (intCodMoneda == Constante.NCODMONEDALOCAL)
                    dblImpCalc = bdlRangoMaxSol;
                else
                    dblImpCalc = bdlRangoMaxSol / dblTipoCambio;
        
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + dblImpCalc + "</Valor> \n" +
                      "</Valida>");
             }  
             break;             
             case 5: // Valida Exclusion
             {  
                String strCodDiagnostico =  request.getParameter("pnCodDiag").toString();
                session = request.getSession(true);
        
                Exclusion objExclusion = null;
                BeanList objLstExcl = new BeanList();
                synchronized(session)
                {
                  if (session.getAttribute("ListaExclusion")!=null)
                    objLstExcl = (BeanList)session.getAttribute("ListaExclusion");
                }    
                int intRes=0;
                int intIndice=0; 
                while (intIndice<objLstExcl.size() && intRes==0)
                {
                  objExclusion = (Exclusion)objLstExcl.get(intIndice);
                  String strCodExclusion = objExclusion.getStrCodEnfermedad().trim();
                  if (strCodExclusion.equals(strCodDiagnostico))
                    intRes=1;
                  intIndice++;
                }
                  
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + intRes + "</Valor> \n" +
                      "</Valida>");
             }  
             break; 
             case 6: // Obtiene Datos de la Pólzia
             {  
                int intPolicy = Tool.parseInt(request.getParameter("pnpoliza"));
                int intBranch = Tool.parseInt(request.getParameter("pnramo"));
                Poliza objPol = new Poliza();
                objPol = gestorPolClinic.getPoliza(intBranch, intPolicy,1);
                String strTrama = "";
                if (objPol.getIntPolicy()>0){
                  String strMoneda="";
                  Bean objTable = Tabla.reaTableIfx(11,objPol.getIntCurrrency());
                  if (objTable != null)
                     strMoneda =  objTable.getString("4");
                    
                  strTrama= objPol.getIntProduct() + "|" + objPol.getStrContrat() + "|" + 
                            objPol.getStrDesProduct() + "|" + objPol.getIntCurrrency() + "|" + 
                            strMoneda ;
                }
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strTrama + "</Valor> \n" +
                      "</Valida>");
             }  
             break;      

             case 7: // Obtiene Datos de la Red
             {  
                int intBranch = Tool.parseInt(request.getParameter("pnramo"));
                int intProducto = Tool.parseInt(request.getParameter("pnproducto"));
                int intPlan = Tool.parseInt(request.getParameter("pnplan"));
                int intModalidad = Tool.parseInt(request.getParameter("pnmodali"));
                int intCobertura = Tool.parseInt(request.getParameter("pncobertu"));
                int intConcepto = Tool.parseInt(request.getParameter("pnconcepto"));
                
                Bean objBean = Tabla.getRedIfx(intBranch, intProducto, intPlan, intCobertura,intModalidad, intConcepto);
                String strTrama = "";

                strTrama= objBean.getString("ded_quanti") + "|" + objBean.getString("ded_amount") + "|" + 
                            objBean.getString("ded_percen")  + "|" + objBean.getString("indem_rate");
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strTrama + "</Valor> \n" +
                      "</Valida>");
             }  
             break;         
             case 8: // Valida que clínica sea única
             {  
                int intBranch = Tool.parseInt(request.getParameter("pnramo"));
                int intModalidad = Tool.parseInt(request.getParameter("pnmodali"));
                int intCobertura = Tool.parseInt(request.getParameter("pncobertu"));
                int intPolicy = Tool.parseInt(request.getParameter("pnpolicy"));
                int intTariff = Tool.parseInt(request.getParameter("pntariff"));
                int intRed = Tool.parseInt(request.getParameter("pnred"));
                int intCodClinic = Tool.parseInt(request.getParameter("pncodclinic"));
                String strEfecto = Tool.getString(request.getParameter("tcdEfecto"));    
                
                int ret = (gestorPolClinic.valinsPolclinic(intBranch,intPolicy,intCobertura,intModalidad,intTariff, intRed, intCodClinic, strEfecto)==true?1:0);
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + ret + "</Valor> \n" +
                      "</Valida>");
             }  
             break;    
             case 9: // Obtiene Descripcion de Proveedor
             {  
                int intCodClinic = Tool.parseInt(request.getParameter("pncodclinic"));
                String strClinica = Tool.getString(Tabla.getProvedorIfx(intCodClinic,"descript"));
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strClinica + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
            
            case 10: // Verifica el número de veces que una cobertura ha sido utilizada
             {  
                session = request.getSession(true);
                
                int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));
                int intCertif = Tool.parseInt(request.getParameter("pncertif"));
                int intCobertura = Tool.parseInt(request.getParameter("pncobertura"));
                int intCoberturaGen = Tool.parseInt(request.getParameter("pncoberturagen"));
                int intConceptoPago = Tool.parseInt(request.getParameter("pnconcepto"));
                String strCodCliente = request.getParameter("pncliente");
                
                int intRes = -1;
                
                //Verifico que exista una configuración por poliza, cobertura y concepto de pago
                Bean objBean = gestorCobertura.getUsoCoberturaConfig(intPoliza,intCoberturaGen,intConceptoPago);
                if(objBean== null)
                     //Verifico que exista una configuración por poliza y cobertura para todos los conceptos de pago
                     objBean = gestorCobertura.getUsoCoberturaConfig(intPoliza,intCoberturaGen,0);
                if(objBean== null)
                    //Verifico que exista una configuración genérica para cobertura y concepto de pago
                    objBean = gestorCobertura.getUsoCoberturaConfig(0,intCoberturaGen,intConceptoPago);     
                if(objBean== null)
                    //Verifico que exista una configuración genérica para cobertura y todos los conceptos de pago
                    objBean = gestorCobertura.getUsoCoberturaConfig(0,intCoberturaGen,0);

                if(objBean!= null)
                {                    
                    int intEstado = Tool.parseInt(objBean.getString("NESTADO"));
                    if(intEstado==1)
                    {
                        int intFrecuencia = Tool.parseInt(objBean.getString("NFRECUENCIA"));
                        int intPeriodo = Tool.parseInt(objBean.getString("NPERIODO"));
                        int intTipoFreq = Tool.parseInt(objBean.getString("NTIPOFREQ")); 
                        
                        Cliente objCliente = new Cliente();
                        synchronized(session)
                        {
                          if(session.getAttribute("DatoCliente")!=null)
                              objCliente = (Cliente)session.getAttribute("DatoCliente");
                        }      
                                
                        int intVecesUso = atencion.getCantUsoCobertura(intPoliza,intCertif,intCobertura,intPeriodo,strCodCliente,intConceptoPago,intTipoFreq);
                        
                        if(intVecesUso<intFrecuencia)
                            intRes = 0;
                        else 
                            intRes = 1;
                    }
                    else
                    {
                        intRes = 2;
                    }
                }   
                out.print("<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                          "<Valida> \n" +
                          "<Valor>" + intRes + "</Valor> \n" +
                          "</Valida>");
             }  
             break;
             case 11: // Obtiene moneda y producto de la Poliza
             {  
                int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));
                int intProducto = 0;
                int intMoneda = 0;
                Poliza objPoliza = gestorPolClinic.getPoliza(Constante.NRAMOASME, intPoliza,1);
                
                String strTrama="";
                if(objPoliza!=null)
                {
                    intProducto = objPoliza.getIntProduct();   
              
                    Bean auxBean = gestorPolClinic.getMonedaPoliza(intPoliza);
                    intMoneda = Tool.parseInt(auxBean.getString("1"));
                    
                    strTrama = intProducto + "|" + intMoneda;
                }
                else
                {
                    strTrama = "-1";
                }
           
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strTrama + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             case 12: // Valida código de cobertura
             {  
                int intCoberturaGen = Tool.parseInt(request.getParameter("pncoberturagen"));
                
                String sql = "select count(*) as count from tab_gencov where usercomp = 1 and company = 1 and " + 
                             "effecdate <= today and (nulldate > today or nulldate is null) and cover = " + intCoberturaGen;
                             
                Bean objBean = Tool.executeQuery(sql);
                
                String strCantidad = objBean.getString("count");
                
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strCantidad + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             
             case 13: // Obtener configuracion de uso
             {  
                int intCoberturaGen = Tool.parseInt(request.getParameter("pncoberturagen"));
                int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));
                int intConceptoPago = Tool.parseInt(request.getParameter("pnconceptopago"));
                
                Bean objBean = gestorCobertura.getUsoCoberturaConfig(intPoliza,intCoberturaGen,intConceptoPago);
                String strTrama = "-1";
                if(objBean!= null)
                {                    
                    int intEstado = Tool.parseInt(objBean.getString("NESTADO"));
                    int intFrecuencia = Tool.parseInt(objBean.getString("NFRECUENCIA"));
                    int intPeriodo = Tool.parseInt(objBean.getString("NPERIODO"));
                    int intTipoFrec = Tool.parseInt(objBean.getString("NTIPOFREQ"));
                    
                    strTrama = intPeriodo + "|" + intFrecuencia + "|" + intEstado + "|" + intTipoFrec;
                    
                }
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strTrama + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             
             case 14: // Obtener configuracion de control por cobertura
             {  
                int intCoberturaGen = Tool.parseInt(request.getParameter("pncoberturagen"));
                int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));
                int intTipo = Tool.parseInt((request.getParameter("pntipo")));
                
                String strControl=null;
                
                strControl = gestorCobertura.getControlCoberturaConfig(intPoliza,intCoberturaGen);
                if(strControl.equals("|") && intTipo==2)
                    strControl = gestorCobertura.getControlCoberturaConfig(0,intCoberturaGen);
                
               
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strControl + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             
             //INICIO BIT FLOPEZ RQ2013-000400
             case 15: // Revisa si cliente es VIgente(<>'3') . (1=> NO VIGENTE , 0=> VIGENTE)
             {      
                String sReturn = "";
                int intncertif = Tool.parseInt(request.getParameter("pncertif"));
                int intPoliza = Tool.parseInt(request.getParameter("pnpoliza"));                              
                
                sReturn = gestorClie.getClienteVigente(1,1,"2",Constante.NRAMOASME,intPoliza,intncertif,null);                           
               
                out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + sReturn + "</Valor> \n" +
                      "</Valida>");
             }  
             break;
             //FIN BIT FLOPEZ RQ2013-000400
             case 16: // Obtiene Descripcion de Diagnostico
             {  
             
                int valor=1;
                String strCodMedico = Tool.getString(request.getParameter("pnMedico"));
                String strMedico = Tool.getString(Tabla.getMedicoIfx(strCodMedico,valor));
        
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strMedico + "</Valor> \n" +
                      "</Valida>");
             }
             break;
              case 17: // Valida Exclusion
             {  
                int valor=2;
                
                String strCodMedico = Tool.getString(request.getParameter("pnCodMed"));
                String strMedico = Tool.getString(Tabla.getMedicoIfx(strCodMedico,valor));
                  
               out.print(
                      "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?> \n" +
                      "<Valida> \n" +
                      "<Valor>" + strMedico + "</Valor> \n" +
                      "</Valida>");
             }  
             break; 
            
            }           
      out.close();
      }catch(Exception e){
            e.printStackTrace();
            System.out.println("valida:" + e);
      }
  }  

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
      doPost(request, response);
  }
}