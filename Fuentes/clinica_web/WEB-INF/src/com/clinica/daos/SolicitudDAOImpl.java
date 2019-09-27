package com.clinica.daos;

import com.clinica.service.*;
import com.clinica.utils.coneccion.*;
import com.clinica.utils.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;
import com.clinica.beans.Cliente;
import com.clinica.beans.Cobertura;
import com.clinica.beans.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SolicitudDAOImpl implements SolicitudDAO
{

  public String strWebServerSol="";
  
  /*Instanciando las clases  Atencion, GestorPolClinic,GestorEmail,
   * dichas objetos se encuentran en el paquete Service.
   * 
   * yahirRivas 29FEB2012 11:15am*/
          //Atencion atencion = new Atencion();
         //GestorPolClinic gestorPolClinic = new GestorPolClinic();
        // GestorEmail gestorEmail = new GestorEmail();
         
         
  public int getMotivoAnulacion(int pclaim)
  {
      int motivo = -1;
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_getMotivoAnul(?)}");            
                objCstmt.setInt(1, pclaim); 
                objRs = objCstmt.executeQuery();
                if ( objRs.next() )
                {
                  motivo = Integer.parseInt(objRs.getString(1));
                }

                return motivo;
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce sp_getMotivoAnul:" + se);
                return -1;
      }
      catch(Exception e)
      {
                System.out.println("Excep sp_getMotivoAnul:" + e);
                return -1;
                
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
                return -1;
            }
      }
  }
  public int getStaclaim(int pclaim)
  {
      int staclaim = 0;
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_staclaim(?)}");            
                objCstmt.setInt(1, pclaim); 
                objRs = objCstmt.executeQuery();
                if ( objRs.next() )
                {
                  staclaim = Integer.parseInt(objRs.getString(1));
                }

                return staclaim;
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce sp_staclaim:" + se);
                return 0;
      }
      catch(Exception e)
      {
                System.out.println("Excep sp_staclaim:" + e);
                return 0;
                
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
                return 0;
            }
      }
  }
  public boolean anularCartaIFX(int pclaim, int pmotivo, int pusercode)
  {
      int retorno = -1;
      String msgError = "";
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_anula_carta(?,?,?)}");            
                objCstmt.setInt(1, pclaim);
                objCstmt.setInt(2, pmotivo);
                objCstmt.setInt(3, pusercode);
                objRs = objCstmt.executeQuery();
                if ( objRs.next() )
                {
                  retorno = objRs.getInt(1);
                  msgError = objRs.getString(2).trim();
                }

                return (retorno==1?true:false);
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce sp_anula_carta:" + se);
                return false;
      }
      catch(Exception e)
      {
                System.out.println("Excep sp_anula_carta:" + e);
                return false;
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
                return false;
            }
      }
  }
  
  public boolean anularCartaORA(int pclaim)
  {
      int retorno = -1;
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      
      try
      {
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call P_PTBLSOLICITUD_ANUL(?,?)}");
          objCstmt.registerOutParameter(1,OracleTypes.INTEGER);
          objCstmt.setInt(2, pclaim);
          objCstmt.execute();
          retorno = ((OracleCallableStatement)objCstmt).getInt(1);
          
          return (retorno==1?true:false);
      }
      catch(SQLException se)
      {
          se.printStackTrace();
          System.out.println("SQLExce P_PTBLSOLICITUD_ANUL:" + se);
          return false;
      }
      catch(Exception e)
      {
          System.out.println("Excep P_PTBLSOLICITUD_ANUL:" + e);
          return false;
      }
      finally
      {
          try
          {
              if(objRs != null)
                  objRs.close();
              if(objCstmt != null)
                  objCstmt.close();
              if(objCnn != null)
                  objCnn.close();
          }
          catch(SQLException sqlexception)
          {
            return false;
          }
      }
  }
  
  //Fin Req 2011-0480
  public int insSolicitud(Solicitud objSolicitud, Cliente objCliente,int intCacalili)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         Solicitud_his objSolhis = new Solicitud_his();
         objSolhis = objSolicitud.getObjSolhis();
          
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_PTBLSOLICITUD_INS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");    /*AF64*/    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.registerOutParameter(2, 4);
            wCstmt.setInt(3, objSolicitud.getNIDROLRESP());
            wCstmt.setInt(4, objSolicitud.getNIDESTADO());           
            wCstmt.setInt(5, objSolicitud.getNIDTIPOSOLICITUD());
            wCstmt.setInt(6, objSolicitud.getNIDUSUARIO());            
            wCstmt.setString(7, objSolicitud.getSNROSINIESTRO());
            wCstmt.setString(8, objSolicitud.getObjSolhis().getSOBSERVA());                        
            wCstmt.setString(9, objSolicitud.getObjSolhis().getSARCHIVO1());
            wCstmt.setString(10, objSolicitud.getSASEGURADO());
            wCstmt.setString(11, objSolicitud.getSIDCLINICA());
            wCstmt.setString(12, objSolicitud.getSOBSERVACLI());
            wCstmt.setString(13, objSolicitud.getSCMPMEDICO());
            wCstmt.setString(14, objSolicitud.getSNOMBMEDICO());
            wCstmt.setInt(15, objSolicitud.getIntCodOficina());
            wCstmt.setDouble(16, objSolicitud.getDblFactorIgv());
            wCstmt.setInt(17, objCliente.getIntCodBrokerInx());
            wCstmt.setString(18, objSolicitud.getSIDCLINICASOL());   
            
            // AF-64
            wCstmt.setInt(19, objSolicitud.getIntTiempoEnfermedad());  
            // Fin AF-64
            
            //RQ2015-000750 Inicio
            wCstmt.setString(20, objCliente.getStrCodigo());  
            wCstmt.setString(21, objCliente.getStrEmail());  
            wCstmt.setInt(22, intCacalili); // Apple             
            //RQ2015-000750 Inicio
            
            wCstmt.execute();
            objSolicitud.setNIDSOLICITUD(wCstmt.getInt(1));
            objSolhis.setNIDSOLICITUD(wCstmt.getInt(1));
            objSolhis.setNIDHISTORICO(wCstmt.getInt(1));
            objSolicitud.setObjSolhis(objSolhis);
            resultado = wCstmt.getInt(2);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
//PRT método que permite ver la tabla historico
//INICIO DE METODO
      public BeanList getLstHistoricoSolicitud(int nIdSolicitud)       
      { 
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
          BeanList lista = new BeanList();
          try
          {
              try
              {
                  wCon = ConexionOracle.getConnectionOracle();
                  wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_HIS_LISTA(?,?)}");
                  wCstmt.registerOutParameter(1, -10);
                  wCstmt.setInt(2, nIdSolicitud);                  
                  wCstmt.execute();
                  wRs = ((OracleCallableStatement)wCstmt).getCursor(1);                  
                  while (wRs.next()){
                    lista.add(Tool.llenarRegistroCall(wRs));                    
                  }
                  return lista;
              }
              catch(SQLException se)
              {
                  se.printStackTrace();
                  System.out.println("SQLExce getLstSolicitudPend:" + se);
                  BeanList beanlist1 = null;
                  return lista;
              }
              catch(Exception e)
              {
                  System.out.println("Excep getLstSolicitudPend:" + e);
              }

              return lista;
          }
          finally
          {
              try
              {
                  if(wCstmt != null)
                      wCstmt.close();
                  if(wRs != null)
                      wRs.close();
                  if(wCon != null)
                      wCon.close();
              }
              catch(SQLException sqlexception)
              {
                  return lista;
              }
          }
      }    
//FIN DE METODO




//PRT
//Metodo que permite observar el ultimo registro de comentarios para compararlo con el actual en una lista y que no se inserte por que ya existe
    public BeanList getUltimoComentario(int nIdSolicitud)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_HIS_SOBSERVA(?,?)}");                                
                wCstmt.setInt(1, nIdSolicitud);
                wCstmt.registerOutParameter(2, -10);
                wCstmt.execute();
                int i=0;
                for(wRs = ((OracleCallableStatement)wCstmt).getCursor(2); wRs.next(); lista.add(Tool.llenarRegistroCall(wRs)));
                BeanList beanlist = lista;
                return beanlist;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getComentarioUltimo:" + se);
                BeanList beanlist1 = null;
                return beanlist1;
            }
            catch(Exception e)
            {
                System.out.println("Excep getComentarioUltimo:" + e);
            }
            BeanList beanlist2 = null;
            return beanlist2;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                BeanList beanlist3 = null;
                return beanlist3;
            }
        }
    } 



//PRT
  public int updFlujoSolicitud(Solicitud objSolicitud, int IdRolClinica)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         Solicitud_his objSolhis = new Solicitud_his();
         objSolhis = objSolicitud.getObjSolhis();
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_PTBLSOLICITUD_FLUJO_UPD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.registerOutParameter(2, 4);
            wCstmt.setInt(3, objSolicitud.getNIDSOLICITUD());
            wCstmt.setInt(4, objSolicitud.getNIDROLRESP());
            wCstmt.setInt(5, objSolicitud.getNIDESTADO());           
            wCstmt.setInt(6, objSolicitud.getNIDUSUARIO());     
            int intIdSolicitud = objSolicitud.getNIDSOLICITUD();
            String ultimoComentario=getUltimoComentario(intIdSolicitud).toString();            
            String comentario = ultimoComentario.substring(11, ultimoComentario.length()-2);            
            if((objSolhis.getSOBSERVA().trim()).equals(comentario)){              
              wCstmt.setString(7, "");              
            }else{
            wCstmt.setString(7, objSolhis.getSOBSERVA()); 
            }
            wCstmt.setString(8, (IdRolClinica==1)?"":objSolicitud.getSOBSERVAMED()); 
            wCstmt.setString(9, (IdRolClinica==1)?objSolicitud.getSOBSERVACLI():""); 
            wCstmt.setInt(10, objSolhis.getNCODMOTIVO()); 
            wCstmt.setInt(11, objSolicitud.getIntIdUsuFirma1());           
            wCstmt.setInt(12, objSolicitud.getIntIdUsuFirma2());
            wCstmt.setInt(13, objSolicitud.getObjSolhis().getNTRANSAC());
            //RQ2015-000750 Inicio
            wCstmt.setString(14, objSolicitud.getSClient());
            wCstmt.setString(15, objSolicitud.getSCorreo());
            //RQ2015-000750 Fin
            
            wCstmt.execute();            
            objSolhis.setNIDHISTORICO(wCstmt.getInt(1));
            
            objSolicitud.setObjSolhis(objSolhis);
            resultado = wCstmt.getInt(2);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }

  

/*PRT
 * Método que llama al StoteProcedure 
 * para obtener los datos de la solicitud por medio de su numero.
 * */
    public Solicitud getDatosSolicitud(String strNumSol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Solicitud objSolicitud = new Solicitud();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_GET_DATA(?,?)}");                
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setString(2, strNumSol);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                if(wRs.next())
                {
                   objSolicitud.setSNROSINIESTRO(strNumSol);                   
                   objSolicitud.setNIDROLRESP(wRs.getInt("NIDROLRESP"));                   
                   objSolicitud.setNIDESTADO(wRs.getInt("NIDESTADO"));                   
                   objSolicitud.setNIDTIPOSOLICITUD(wRs.getInt("NIDTIPOSOLICITUD"));                   
                   objSolicitud.setDFECHAREG(wRs.getString("SFECHAREG"));                   
                   objSolicitud.setNFLGAMPLIACION(wRs.getInt("NFLGAMPLIACION"));                   
                   objSolicitud.setSOBSERVAMED(wRs.getString("SOBSERVACIONMED"));                   
                   objSolicitud.getObjSolhis().setSOBSERVA(wRs.getString("SOBSERVA"));                   
                   objSolicitud.getObjSolhis().setNIDHISTORICO(wRs.getInt("NIDHISTORICO"));                   
                   objSolicitud.getObjSolhis().setSARCHIVO1(wRs.getString("SARCHIVO1"));                   
                   objSolicitud.getObjSolhis().setNTRANSAC(wRs.getInt("NTRANSAC"));                   
                   objSolicitud.getObjSolhis().setNCODMOTIVO(wRs.getInt("NCODMOTIVO"));                   
                   objSolicitud.getObjSolhis().setDFECHAREG(wRs.getString("SFECHAREGHIS"));                   
                   objSolicitud.setSOBSERVACLI(wRs.getString("SOBSERVACIONCLI"));                   
                   objSolicitud.setSCMPMEDICO(wRs.getString("SCMPMEDICO"));                   
                   objSolicitud.setSNOMBMEDICO(wRs.getString("SNOMBREMEDICO"));                   
                   objSolicitud.setIntCodOficina(wRs.getInt("NCODOFICINA"));                   
                   objSolicitud.setIntIdUsuFirma1(wRs.getInt("NIDUSUFIRMA1"));                   
                   objSolicitud.setIntIdUsuFirma2(wRs.getInt("NIDUSUFIRMA2"));                   
                   objSolicitud.setStrNombOficina(wRs.getString("SNOMBOFICINA"));                   
                   objSolicitud.setDblFactorIgv(wRs.getDouble("NFACTORIGV"));                   
                   objSolicitud.setNIDSOLICITUD(wRs.getInt("NIDSOLICITUD"));          
                   
                   // AF-64
                   objSolicitud.setIntTiempoEnfermedad(wRs.getInt("NTIEMPOENFERMEDAD"));
                   // Fin AF-64
                }
                return objSolicitud;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getSolicitud:" + se);
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getSolicitud:" + e);
            }
            return null;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return null;
            }
        }
    }  

    public Solicitud getSolicitud(int intIdSol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Solicitud objSolicitud = new Solicitud();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_GET (?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdSol);                
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                if(wRs.next())
                {
                   objSolicitud.setNIDSOLICITUD(intIdSol);
                   objSolicitud.setNIDROLRESP(wRs.getInt("NIDROLRESP"));
                   objSolicitud.setNIDESTADO(wRs.getInt("NIDESTADO"));
                   objSolicitud.setNIDTIPOSOLICITUD(wRs.getInt("NIDTIPOSOLICITUD"));
                   objSolicitud.setSNROSINIESTRO(wRs.getString("SNROSINIESTRO"));
                   objSolicitud.setDFECHAREG(wRs.getString("SFECHAREG"));
                   objSolicitud.setNFLGAMPLIACION(wRs.getInt("NFLGAMPLIACION"));
                   objSolicitud.setSOBSERVAMED(wRs.getString("SOBSERVACIONMED"));
                   objSolicitud.getObjSolhis().setSOBSERVA(wRs.getString("SOBSERVA"));
                   objSolicitud.getObjSolhis().setNIDHISTORICO(wRs.getInt("NIDHISTORICO"));
                   objSolicitud.getObjSolhis().setSARCHIVO1(wRs.getString("SARCHIVO1"));
                   objSolicitud.getObjSolhis().setNTRANSAC(wRs.getInt("NTRANSAC"));
                   objSolicitud.getObjSolhis().setNCODMOTIVO(wRs.getInt("NCODMOTIVO"));
                   objSolicitud.getObjSolhis().setDFECHAREG(wRs.getString("SFECHAREGHIS"));
                   objSolicitud.setSOBSERVACLI(wRs.getString("SOBSERVACIONCLI"));
                   objSolicitud.setSCMPMEDICO(wRs.getString("SCMPMEDICO"));
                   objSolicitud.setSNOMBMEDICO(wRs.getString("SNOMBREMEDICO"));
                   objSolicitud.setIntCodOficina(wRs.getInt("NCODOFICINA"));                   
                   //Inicio Req. 2014-000204 Paradigmasoft GJB
                   objSolicitud.setIntIdUsuFirma1(Tool.parseInt(Constante.getConst("COD_SUBGERENTE")));
                   objSolicitud.setIntIdUsuFirma2(0);                            
                   //Fin Req. 2014-000204 Paradigmasoft GJB
                   objSolicitud.setStrNombOficina(wRs.getString("SNOMBOFICINA"));
                   objSolicitud.setDblFactorIgv(wRs.getDouble("NFACTORIGV"));
                   
                   // AF-64
                   objSolicitud.setIntTiempoEnfermedad(wRs.getInt("NTIEMPOENFERMEDAD"));
                   // Fin AF-64
                   //RQ205-000750 INICIO
                   objSolicitud.setStrObservacionAG(wRs.getString("SOBSAVIGEN"));
                   //RQ2015-000750 FIN
                }

                return objSolicitud;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getSolicitud:" + se);
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getSolicitud:" + e);
            }
            return null;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return null;
            }
        }
    }


public BeanList getLstSolicitudPend(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        
        /*Inicio Req. 2014-000204 Paradigmasoft GJB*/
        GestorSolicitud gestorSolicitud = new GestorSolicitud();        
        Connection objCnnIfx = null;
        PreparedStatement objPstmtIfx = null;
        ResultSet objRsIfx = null;             
        
        Bean lista_aux = new Bean();
        String strdiagnostico="";
        double dblMontoCarta = 0;        
        int intIndicador = 1;
        int intMaxSolicitudes = Tool.parseInt(Constante.getConst("LIM_SOL"));
        /*Fin Req. 2014-000204 Paradigmasoft GJB*/
        
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUDPEND_LIST(?,?,?,?,?,?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdRol);
                //Req 2011-0975
                //wCstmt.setInt(3, intIdEstado);
                wCstmt.setString(3, strIdEstados);
                //Fin Req 2011-0975
                wCstmt.setInt(4, intIdTipoSol);
                wCstmt.setString(5, strNrosiniestro);
                wCstmt.setString(6, strAsegurado);
                wCstmt.setString(7, strIdClinica);
                //Req 2011-0975
                //wCstmt.setInt(8, intCodOficina);
                wCstmt.setString(8,strOficCon);
                //Fin Req 2011-0975
                wCstmt.setInt(9, intCodBroker);
                wCstmt.setInt(10, intTipo);
                wCstmt.setInt(11, intIdUsuario);

                
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                objCnnIfx = ConexionIFX.getConnection();
                
                while (wRs.next() && intIndicador <= intMaxSolicitudes){
                  /*Inicio Req. 2014-000204 Paradigmasoft GJB*/                  
                  lista_aux = Tool.llenarRegistroCall(wRs);                  
                  strdiagnostico = gestorSolicitud.obtenerDiagnostico(objCnnIfx, lista_aux.getString("SNROSINIESTRO"));  
                  dblMontoCarta = gestorSolicitud.obtenerMontoCarta(wCon, objCnnIfx, gestorSolicitud, Tool.parseInt(lista_aux.getString("NIDSOLICITUD")), lista_aux.getString("SNROSINIESTRO"));
                  lista_aux.put("SDIAGNOSTICO", strdiagnostico!=null?strdiagnostico.trim():"NO ESPECIFICADO");
                  lista_aux.put("NMONTOCARTA", Double.toString(dblMontoCarta));
                  lista.add(lista_aux);
                  intIndicador = intIndicador + 1;
                  /*Fin Req. 2014-000204 Paradigmasoft GJB*/                  
                  
                  //lista.add(Tool.llenarRegistroCall(wRs)); Se comentó el día 20/11/2014
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudPend:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudPend:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
                if(objCnnIfx != null)
                    objCnnIfx.close();                
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    }    
  public int updSolicitudSiniestro(Solicitud objSolicitud)
  {     
  System.out.println("updSolicitudSiniestro ");
        int resultado=-1;     
        ResultSet wRs = null;
        Connection wCon = null;
        PreparedStatement wPstmt = null;
          
        try
        {   
        
            resultado=objSolicitud.getNIDSOLICITUD();
            
            String sql = "UPDATE PTBLSOLICITUD SET SNROSINIESTRO = '" + objSolicitud.getSNROSINIESTRO()  +  "'" + 
                         " WHERE NIDSOLICITUD = " + objSolicitud.getNIDSOLICITUD();
                         
            wCon = ConexionOracle.getConnectionOracle();
            wCon.setAutoCommit(true);
            wPstmt = wCon.prepareStatement(sql);
            boolean blRet = wPstmt.execute();
            wCon.commit();
            if (blRet) resultado = 0;
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wPstmt != null)
                    wPstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }

  public int updSolicitudObsMed(Solicitud objSolicitud)
  {     
        int resultado=-1;     
        ResultSet wRs = null;
        Connection wCon = null;
        PreparedStatement wPstmt = null;
          
        try
        {            
            String sql = "UPDATE PTBLSOLICITUD SET " + 
                         " SOBSERVACIONMED = '" + objSolicitud.getSOBSERVAMED() + "'" +
                         " WHERE NIDSOLICITUD = " + objSolicitud.getNIDSOLICITUD();
                         
            wCon = ConexionOracle.getConnectionOracle();
            wCon.setAutoCommit(true);
            wPstmt = wCon.prepareStatement(sql);
            boolean blRet = wPstmt.execute();
            wCon.commit();
            if (blRet) resultado = 0;
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wPstmt != null)
                    wPstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
  
 
     public BeanList getLstSolicitudHis(int intIdSolicitud)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_HIS_LIST(?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdSolicitud);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudHis:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudHis:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    } 

     public BeanList getLstSolicitudHisSin(int intIdTipoSol, 
                                                String strNrosiniestro,  
                                                String strIdClinica,
                                                String strAsegurado, 
                                                int intCodOficina,
                                                int intIdUsuario)
     {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_HIS_LIST_SIN(?,?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdTipoSol);
                wCstmt.setString(3, strNrosiniestro);
                wCstmt.setString(4, strAsegurado);
                wCstmt.setString(5, strIdClinica);
                wCstmt.setInt(6, intCodOficina);
                wCstmt.setInt(7, intIdUsuario);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudHisSin:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudHisSin:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    }
    
   public Bean getOficPol(int intPolice, int intRamo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean objBean = null;
        String sql="select office, t.descript from policy p, table9 t where " +
                   " p.usercomp = 1 and p.company = 1 and p.certype = '2' and p.branch =" + intRamo +
                   " and p.policy =" + intPolice + " and p.office = t.codigint";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
              objBean = new Bean();
              objBean = Tool.llenarRegistro(objRs, objPstmt);
            }            
            return objBean;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return null;
    } 

  public String insSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente,
                                       String strWebServer,
                                       int intCaso
                                       )
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    String strNroAutoriza ="";
    
    System.out.println("Fecha de ocurrencia del siniestro" + objSolicitud.getStrFechaOcurr());
    
    try
      {
                double dblAmount = objSolicitud.getCambioImpCarta(objCliente.getIntCodMoneda());
                String strobserva =(objSolicitud.getNIDTIPOSOLICITUD()==Constante.NTSCARGAR?"CG":"CA");
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcinsautoriza_eps(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, objSolicitud.getIntRamo());
                objCstmt.setInt(2, objCliente.getIntCertificado());
                objCstmt.setString(3, objCliente.getStrCodigo());
                objCstmt.setString(4, objSolicitud.getStrFechaEmi());
                objCstmt.setString(5, objSolicitud.getStrFechaOcurr());
                objCstmt.setInt(6, objSolicitud.getIntOficina());
                objCstmt.setInt(7, objSolicitud.getIntOficina());
                objCstmt.setInt(8, objSolicitud.getIntOficina());
                objCstmt.setInt(9, objCliente.getIntPoliza());
                objCstmt.setInt(10, objCliente.getIntProducto());
                objCstmt.setString(11, strWebServer);
                objCstmt.setInt(12, objCobertura.getIntTipoAtencion());
                objCstmt.setDouble(13, objSolicitud.getDblTipoCambio());
                objCstmt.setInt(14, objSolicitud.getIntCodProveedor());
                objCstmt.setString(15, objSolicitud.getIntCodDiagnos());
                objCstmt.setDouble(16, dblAmount);
                objCstmt.setInt(17, objCliente.getIntCodMoneda());
                objCstmt.setInt(18, objSolicitud.getIntMonedaImpoCarta());
                objCstmt.setDouble(19, objSolicitud.getDblImporteCarta());
                objCstmt.setDouble(20, dblAmount);
                objCstmt.setDouble(21, objSolicitud.getCambioImpCarta(Constante.NCODMONEDALOCAL));
                objCstmt.setInt(22, objCobertura.getIntCover());
                objCstmt.setString(23, objCobertura.getStrImpDeducible());
                objCstmt.setInt(24, objCobertura.getIntPeridoCarencia());
                objCstmt.setString(25, objCobertura.getStrCoaseguro());
                objCstmt.setString(26, objSolicitud.getStrFechaLimite());
                objCstmt.setString(27, strobserva);
                objCstmt.setString(28, "0");
                objCstmt.setString(29, "0");
                objCstmt.setInt(30, intCaso);
                objCstmt.setString(31, objSolicitud.getSCMPMEDICO());
                objCstmt.setString(32, objSolicitud.getSNOMBMEDICO());
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                  strNroAutoriza  = objRs.getString(2);
                }
                return strNroAutoriza;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insSolicitudIfx:" + se);
                return strNroAutoriza;
      }
    catch(Exception e)
      {
                System.out.println("Excep insSolicitudIfx:" + e);
                return strNroAutoriza;
                
      }
    finally
      {
        try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return strNroAutoriza;
            }
      }

  }
  public int updSolicitudIfx(Solicitud objSolicitud,
                                    Cobertura objCobertura,
                                    Cliente objCliente)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    int intTransac = -1;
    try
    {
                double dblAmount = objSolicitud.getCambioImpCarta(objCliente.getIntCodMoneda());

                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcupdautoriza(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setString(1, objSolicitud.getSNROSINIESTRO());
                objCstmt.setDouble(2, objSolicitud.getDblTipoCambio());
                objCstmt.setInt(3, objSolicitud.getIntCodProveedor());
                objCstmt.setString(4, objSolicitud.getIntCodDiagnos());
                objCstmt.setDouble(5, dblAmount);
                objCstmt.setInt(6, objCliente.getIntCodMoneda());
                objCstmt.setInt(7, objSolicitud.getIntMonedaImpoCarta());                
                objCstmt.setDouble(8, objSolicitud.getCambioImpCarta(Constante.NCODMONEDALOCAL));
                objCstmt.setString(9, objCobertura.getStrImpDeducible());
                objCstmt.setInt(10, objCobertura.getIntPeridoCarencia());
                objCstmt.setString(11, objCobertura.getStrCoaseguro());
                objCstmt.setString(12, objSolicitud.getStrFechaLimite());
                objCstmt.setDouble(13, objSolicitud.getDblImporteCarta());
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                    intReturn = objRs.getInt(1);
                    intTransac = objRs.getInt(2);
                }
    }
    catch(SQLException se)
    {
        se.printStackTrace();
        System.out.println("SQLExce updSolicitudIfx:" + se);
    }
    catch(Exception e)
    {
        System.out.println("Excep updSolicitudIfx:" + e);
        e.printStackTrace();
    }
    finally
    {
        try
        {
            if(objCstmt != null)
                objCstmt.close();
            if(objRs != null)
                objRs.close();
            if(objCnn != null)
                objCnn.close();
        }
        catch(SQLException sqlexception)
        {
            sqlexception.printStackTrace();
        }
    }
    return intTransac;

  }  

  public int ampliaSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente
                                       )
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    try
      {
                double dblAmount = objSolicitud.getCambioImpCarta(objCliente.getIntCodMoneda());
                String strobserva =(objSolicitud.getNIDTIPOSOLICITUD()==Constante.NTSCARGAR?"CG":"CA");

                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcupdampliar(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setString(1, objSolicitud.getSNROSINIESTRO());
                objCstmt.setDouble(2, dblAmount);
                objCstmt.setDouble(3, objSolicitud.getCambioImpCarta(Constante.NCODMONEDALOCAL));
                objCstmt.setInt(4, objCliente.getIntCodMoneda());
                objCstmt.setDouble(5, objSolicitud.getDblTipoCambio());
                objCstmt.setString(6, objSolicitud.getStrFechaLimite());
                objCstmt.setInt(7, objSolicitud.getIntOficina());
                objCstmt.setInt(8, objSolicitud.getIntRamo());
                objCstmt.setInt(9, objCobertura.getIntCover());
                objCstmt.setString(10, strobserva);
                objCstmt.setString(11, "0");
                objCstmt.setString(12, "0");
                objCstmt.setInt(13, objSolicitud.getIntMonedaImpoCarta());
                objCstmt.setDouble(14, objSolicitud.getDblImporteCarta());
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                }
                return intReturn;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insSolicitudIfx:" + se);
                return intReturn;
      }
    catch(Exception e)
      {
                System.out.println("Excep insSolicitudIfx:" + e);
                return intReturn;
                
      }
    finally
      {
        try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return intReturn;
            }
      }

  }  

   public void getSolicitudIfx(Solicitud objSolicitud, int intTransaccion)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        try
        {

            sql = "select illness, clinic_cod  from claim_attm where usercomp = 1  and company = 1 " +
                  " and claim = " + objSolicitud.getSNROSINIESTRO();

            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objSolicitud.setIntCodDiagnos(objRs.getString("illness"));
                 objSolicitud.setStrDiagnos(Tabla.getDiagnosticoIfx(objSolicitud.getIntCodDiagnos()));
                 objSolicitud.setIntCodProveedor(objRs.getInt("clinic_cod"));
                 objSolicitud.setStrProveedor(Tabla.getProvedorIfx(objSolicitud.getIntCodProveedor()));
            }    
            objRs.close();
            objPstmt.close();
            
            
            //Recuperando la descripcion de la clinica solicitante
            sql = "select b.code from web_cli_log a , tab_clinic b where b.usercomp = 1 and b.company = 1 and " +
                  "a.clinica_sol=b.ten_server and length(b.ten_server) > 0 and a.siniestro=" + objSolicitud.getSNROSINIESTRO();            
                  
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objSolicitud.setIntCodProveedorSol(objRs.getInt("code"));                 
                 objSolicitud.setStrProveedorSol(Tabla.getProvedorIfx(objSolicitud.getIntCodProveedorSol()));
            }
            
            objRs.close();
            objPstmt.close();   
            
            
            int intTransacInx = 0;
            sql = "select min(transac) transaccion from claim_letter where usercomp = 1  and company = 1 and " + 
                  "claim = " +objSolicitud.getSNROSINIESTRO() + " and transac >=" +  intTransaccion;
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 intTransacInx = objRs.getInt("transaccion");
            }
            
            if(intTransacInx != intTransaccion)
                intTransaccion = intTransacInx;
            
            sql = "select c.currency, c.amount, c.fec_limite, exchange, h.operdate," +
                  "(select occurdat from claim cc where cc.usercomp = 1  and cc.company = 1 and cc.claim = c.claim) occurdat " +
                  " from claim_letter c, claim_his h " +
                  " where c.usercomp = 1  and c.company = 1 " +
                  " and c.claim = h.claim " +
                  " and c.transac = h.transac " +
                  " and h.usercomp = 1 and h.company  = 1 " +
                  " and h.claim = " +objSolicitud.getSNROSINIESTRO() +
                  " and h.transac =" +  intTransaccion;
                  
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objSolicitud.setIntMonedaImpoCarta(objRs.getInt("currency"));
                 objSolicitud.setDblImporteCarta(objRs.getDouble("amount"));
                 objSolicitud.setStrFechaLimite(Tool.getString(objRs.getString("fec_limite")));
                 objSolicitud.setDblTipoCambio(objRs.getDouble("exchange"));
                 objSolicitud.setStrFechaEmi(objRs.getString("operdate"));
                 objSolicitud.setStrFechaOcurr(objRs.getString("occurdat"));
                  Bean bTemp = Tabla.reaTableIfx(11,objSolicitud.getIntMonedaImpoCarta());
                  String strMoneda="";
                  if (bTemp!=null){
                    strMoneda = bTemp.getString("4");
                  }
                  objSolicitud.setStrMonedaImpoCarta(strMoneda);
            }    
            
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        
    }    

  public double getAmountAmpIfx(String strNroAutoriza, int intTransac)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        double dblAmount = 0;
        String sql="select amount from claim_his h where  h.usercomp = 1 " +
                   " and h.company  = 1 and h.claim = " + strNroAutoriza + " and h.transac =" + intTransac;
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 dblAmount = objRs.getDouble("amount");
            }            
            return dblAmount;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return 0;
    }      

  public double getImporteAmpIfx(String strNroAutoriza, int intTransac)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        double dblAmount = 0;
        String sql="select sum(amount) amount from claim_letter where usercomp = 1 " +
                   " and company = 1 and claim = " + strNroAutoriza +
                   " and transac <=" + intTransac;
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 dblAmount = objRs.getDouble("amount");
            }            
            return dblAmount;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return 0;
    }      
  public int getTiempoTipoSol(int intTipoSol)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        int intTiempo = 0;
        String sql="SELECT NTIEMPORESPUESTA FROM PTBLTIPO_SOLICITUD T " + 
                   "WHERE T.NIDTIPOSOLICITUD =  " + intTipoSol;
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 intTiempo = objRs.getInt("NTIEMPORESPUESTA");
            }            
            return intTiempo;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return 0;
    }      
    
  public int getIDCapitalIlimitado(int intNroSiniestro)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        int intCacalili = 0;
        String sql="SELECT IDCACALILI FROM PTBLSOLICITUD T " + 
                   "WHERE T.SNROSINIESTRO =  " + intNroSiniestro;
        
        try
        {
            objCnn = ConexionOracle.getConnectionOracle();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 intCacalili = objRs.getInt("IDCACALILI");
            }            
            return intCacalili;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return 0;
    }   

  public int anulRechSolicitudIfx(String strNroSiniestro, int intTipo, Solicitud_his objSolicitudHis) 
  /*
    intTipo : 1 Anula   7 rechaza
    retorna : 1 Proceso Correcto
              0 Siniestro no existe
              -1 Siniestro anulado
              -2: Siniestro rechazado
  */
  
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcanuautoriza(?,?)}");
                objCstmt.setString(1, strNroSiniestro);
                objCstmt.setInt(2, intTipo);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                  objSolicitudHis.setNTRANSAC(objRs.getInt(2));
                }
                switch (intReturn){
                case 1 :
                  intReturn = 0;
                  break;
                case 0:
                  intReturn = -1;
                  break;
                case -1:
                  intReturn = -2;
                  break;
                case -2:
                  intReturn = -3;
                  break;
                }
                return intReturn;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insSolicitudIfx:" + se);
                return intReturn;
      }
    catch(Exception e)
      {
                System.out.println("Excep insSolicitudIfx:" + e);
                return intReturn;
                
      }
    finally
      {
        try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return intReturn;
            }
      }

  }  

  public int anulRechSolicitudAmpIfx(String strNroSiniestro, int intUsercode, 
                                            int intTransac, int intTipo, Solicitud_his objSolicitudHis) 
  /*
    intTipo : 1 Anula   7 rechaza
    retorna : 1 Proceso Correcto
              0 Siniestro no existe
              -1 Siniestro anulado
              -2: Siniestro rechazado
  */
  
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-5;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcanuampliar(?,?,?,?)}");
                objCstmt.setString(1, strNroSiniestro);
                objCstmt.setInt(2, intUsercode);
                objCstmt.setInt(3, intTransac);
                objCstmt.setInt(4, intTipo);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                  objSolicitudHis.setNTRANSAC(objRs.getInt(2));
                }
                switch (intReturn){
                case 1 :
                  intReturn = 0;
                  break;
                case 0:
                  intReturn = -2;
                  break;
                case -1:
                  intReturn = -3;
                  break;
                case -2:
                  intReturn = -4;
                  break;
                }
                  
                return intReturn;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insSolicitudIfx:" + se);
                return intReturn;
      }
    catch(Exception e)
      {
                System.out.println("Excep insSolicitudIfx:" + e);
                return intReturn;
                
      }
    finally
      {
        try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return intReturn;
            }
      }

  } 
  
  public int insPresupuesto(Solicitud objSolicitud)
  {     int resultado=-1;     
        ResultSet wRs = null;
        
        Connection wCon = null;
        CallableStatement wCstmt = null;
  
        
        int intIdPresupuesto = getNewIdPresupuesto();
        objSolicitud.getObjPresupuesto().setNIDPRESUPUESTO(intIdPresupuesto);
        if (intIdPresupuesto != -1)
        {
            Presupuesto objPresupuesto = objSolicitud.getObjPresupuesto();
            objPresupuesto.setNIDPRESUPUESTO(intIdPresupuesto);
            ArrayList arrDetalle = objPresupuesto.getArrDetalle();
            int intIndice = 0; 
            while(intIndice <arrDetalle.size())
            {
                DetallePresupuesto objDetalle = (DetallePresupuesto)arrDetalle.get(intIndice);
                if(objDetalle.getDblMontoConcepto()>0)
                {
                   try
                    {            
                        wCon = ConexionOracle.getConnectionOracle();    
                        wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_PTBLPRESUPUESTO_INS(?,?,?,?,?,?,?,?,?)}");    
                        wCstmt.registerOutParameter(1, 4);
                        wCstmt.registerOutParameter(2, 4);
                        wCstmt.setInt(3, objSolicitud.getObjPresupuesto().getNIDPRESUPUESTO());
                        wCstmt.setDouble(4, objDetalle.getDblMontoConcepto());           
                        wCstmt.setInt(5, objDetalle.getIntIdConcepto());
                        wCstmt.setInt(6, objSolicitud.getNIDSOLICITUD());            
                        wCstmt.setInt(7, objSolicitud.getObjSolhis().getNTRANSAC());
                        wCstmt.setInt(8, objSolicitud.getNIDUSUARIO());
                        wCstmt.setString(9, objDetalle.getStrObservacion()); 
                        wCstmt.execute();
                        resultado = wCstmt.getInt(2);           
                    }
                    catch(SQLException se)
                    {
                        se.printStackTrace();
                        System.out.println(se.getMessage());
                    }
                    catch(Exception e)
                    {
                        System.out.println(e.getMessage());
                    }
                    finally
                    {
                        try
                        {
                            if(wCstmt != null)
                                wCstmt.close();
                            if(wCon != null)
                                wCon.close();
                        }
                        catch(SQLException sqlexception) { }
                    }
                    
                }
                intIndice++;
                
            }
        } 
        return resultado;
  }
  
    public int updPresupuesto(Solicitud objSolicitud)
  {     int resultado=-1;     
        ResultSet wRs = null;
        
        Connection wCon = null;
        CallableStatement wCstmt = null;
  
            Presupuesto objPresupuesto = objSolicitud.getObjPresupuesto();
            ArrayList arrDetalle = objPresupuesto.getArrDetalle();
            int intIndice = 0; 
        
            String sql = "DELETE FROM PTBLPRESUPUESTO WHERE NIDPRESUPUESTO= " + objSolicitud.getObjPresupuesto().getNIDPRESUPUESTO() + 
                         " AND NIDSOLICITUD= " + objSolicitud.getNIDSOLICITUD() + " AND NTRANSAC= " + objSolicitud.getObjSolhis().getNTRANSAC();
            Tool.execute_sql(sql);
         
 
            while(intIndice <arrDetalle.size())
            {
                DetallePresupuesto objDetalle = (DetallePresupuesto)arrDetalle.get(intIndice);
                if(objDetalle.getDblMontoConcepto()>0)
                {
                   try
                    {            
                        wCon = ConexionOracle.getConnectionOracle();    
                        wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_PTBLPRESUPUESTO_UPD(?,?,?,?,?,?,?,?)}");    
                        wCstmt.registerOutParameter(1, 4);
                        wCstmt.setInt(2, objSolicitud.getObjPresupuesto().getNIDPRESUPUESTO());
                        wCstmt.setDouble(3, objDetalle.getDblMontoConcepto());           
                        wCstmt.setInt(4, objDetalle.getIntIdConcepto());
                        wCstmt.setInt(5, objSolicitud.getNIDSOLICITUD());            
                        wCstmt.setInt(6, objSolicitud.getObjSolhis().getNTRANSAC());
                        wCstmt.setInt(7, objSolicitud.getNIDUSUARIO());
                        wCstmt.setString(8, objDetalle.getStrObservacion()); 
                        wCstmt.execute();
                        resultado = wCstmt.getInt(1);           
                    }
                    catch(SQLException se)
                    {
                        se.printStackTrace();
                        System.out.println(se.getMessage());
                    }
                    catch(Exception e)
                    {
                        System.out.println(e.getMessage());
                    }
                    finally
                    {
                        try
                        {
                            if(wCstmt != null)
                                wCstmt.close();
                            if(wCon != null)
                                wCon.close();
                        }
                        catch(SQLException sqlexception) { }
                    }
                    
                }
                intIndice++;
                
            }
        return resultado;
  }
   public int getNewIdPresupuesto()
  {     int resultado=-1;     
        //ResultSet wRs = null;
        
        Connection wCon = null;
        CallableStatement wCstmt = null;
  
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();    
            wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_PTBLPRESUPUESTO_GETNEWID(?)}");    
            wCstmt.registerOutParameter(1, Types.INTEGER); 
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
  
   
   public Presupuesto getPresupuesto(int intIdSol, int intIdTransaccion)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        Presupuesto objPresupuesto= null;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLPRESUPUESTO_GET(?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdSol);
                wCstmt.setInt(3, intIdTransaccion);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                
                int intNumReg = lista.size();
                if(intNumReg>0)
                {
                    objPresupuesto = new Presupuesto();
                    ArrayList arrDetalle = new ArrayList();
                    for(int intIndice=0;intIndice<intNumReg;intIndice++)
                    {
                      DetallePresupuesto objDetalle = new DetallePresupuesto();
                      objDetalle.setDblMontoConcepto(Double.parseDouble(lista.getBean(intIndice).getString("NIMPORTE")));
                      objDetalle.setIntIdConcepto(Integer.parseInt(lista.getBean(intIndice).getString("NIDCONCEPTO")));
                      objDetalle.setStrObservacion(lista.getBean(intIndice).getString("SOBSERVACION"));
                      arrDetalle.add(objDetalle);
                      
                      objPresupuesto.setNIDPRESUPUESTO(Integer.parseInt(lista.getBean(intIndice).getString("NIDPRESUPUESTO")));
                    }
                    objPresupuesto.setArrDetalle(arrDetalle);
                }                        
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudPend:" + se);
                BeanList beanlist1 = null;
                return objPresupuesto;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudPend:" + e);
            }
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return objPresupuesto;
            }
        }
        return objPresupuesto;
    }
    
    public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        try
        {
            sql = "  select w.siniestro as SNROSINIESTRO, c.cliename as SASEGURADO, w.fec_ocur as SFECHAREG, w.hora_ocur as SHORAREG, " + 
                  " tiposolicitud as  STIPOSOLICITUD, w.policy as SPOLIZA," +
                  " w.certif as SCERTIFICADO, w.client as SCODCLIENTE, w.cover as SCOBERTURA, w.gencover as SGENCOVER, " +
                  " w.descover as SDESCOVER, " +
                  " (select d.descript from tab_clinic d where w.clinica=d.ten_server and d.statregt='1' and d.usercomp=1 and d.company=1) as SDESCLINIC, " +
                  " w.despago as SDESPAGO " +
                  " from web_cli_log w, client c where w.client=c.code and tiposolicitud=3 ";
                  //" and (w.clinica_sol is null or length(w.clinica_sol)=0) "; 
                       
            sql = sql + " and ((w.clinica = '" + strClinica + "' and (w.clinica_sol is null or length(w.clinica_sol)=0)) or w.clinica_sol = '" + strClinica + "' )";
            
            if(strSiniestro!=null && !strSiniestro.equals(""))
                sql = sql + " and w.siniestro = " + strSiniestro ;
                
            if(strNombCliente!=null && !strNombCliente.equals(""))
                sql = sql + " and c.cliename like '%" + strNombCliente + "%'";
            
            if(intGenCover==Constante.NGENCOVERODONT)
                sql = sql + " and w.gencover = " + intGenCover;
            
                
            sql = sql + " order by w.fec_ocur desc, w.hora_ocur desc";
            //System.out.println(sql);
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            
           
            while (objRs.next())
            {
              objLista.add(Tool.llenarRegistroCall(objRs));
            }  
            
            objRs.close();
            objPstmt.close();
            
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        
        if (lista != null)
            return lista;
        else
            return objLista;
        
    }    
    
    public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista, int codGrupo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        try
        {
            sql = "  select w.siniestro as SNROSINIESTRO, c.cliename as SASEGURADO, w.fec_ocur as SFECHAREG, w.hora_ocur as SHORAREG, " + 
                  " tiposolicitud as  STIPOSOLICITUD, w.policy as SPOLIZA," +
                  " w.certif as SCERTIFICADO, w.client as SCODCLIENTE, w.cover as SCOBERTURA, w.gencover as SGENCOVER, " +
                  " w.descover as SDESCOVER, " +
                  " (select d.descript from tab_clinic d where w.clinica=d.ten_server and d.statregt='1' and d.usercomp=1 and d.company=1) as SDESCLINIC, " +
                  " w.despago as SDESPAGO " +
                  " from web_cli_log w, client c where w.client=c.code and tiposolicitud=3 ";
                  //" and (w.clinica_sol is null or length(w.clinica_sol)=0) "; 
                       
            sql = sql + " and ((w.clinica = '" + strClinica + "' and (w.clinica_sol is null or length(w.clinica_sol)=0)) or w.clinica_sol = '" + strClinica + "' )";
            
            if(strSiniestro!=null && !strSiniestro.equals(""))
                sql = sql + " and w.siniestro = " + strSiniestro ;
                
            if(strNombCliente!=null && !strNombCliente.equals(""))
                sql = sql + " and c.cliename like '%" + strNombCliente + "%'";
            
            if(intGenCover==Constante.NGENCOVERODONT)
                sql = sql + " and w.gencover = " + intGenCover;
            
            if(codGrupo==Constante.NCODGRUPOTINTA || codGrupo==Constante.NCODGRUPOJCOR)
            {
              if(intGenCover==Constante.NGENCOVEREMEACC || intGenCover==Constante.NGENCOVEREMEMED)
              {
                sql = sql + " and w.gencover = " + intGenCover;
              }
            }
            
            if(codGrupo==Constante.NCODGRUPOTINTA)
            {
                sql = sql + " and w.policy in (select pc.policy from pol_clinic pc where pc.clinic_cod in (select tc.code from tab_clinic tc where tc.ten_server = '"+strClinica+"'))";
            }
                
            sql = sql + " order by w.fec_ocur desc, w.hora_ocur desc";
            System.out.println(sql);
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            
           
            while (objRs.next())
            {
              objLista.add(Tool.llenarRegistroCall(objRs));
            }  
            
            objRs.close();
            objPstmt.close();
            
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        
        if (lista != null)
            return lista;
        else
            return objLista;
        
    }
    public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, String strClinicaTinta, BeanList lista, int codGrupo,
                                                    String fInicio, String fFin)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        try
        {
            sql = "  select w.siniestro as SNROSINIESTRO, c.cliename as SASEGURADO, w.fec_ocur as SFECHAREG, w.hora_ocur as SHORAREG, " + 
                  " tiposolicitud as  STIPOSOLICITUD, w.policy as SPOLIZA," +
                  " w.certif as SCERTIFICADO, w.client as SCODCLIENTE, w.cover as SCOBERTURA, w.gencover as SGENCOVER, " +
                  " w.descover as SDESCOVER, " +
                  " (select d.descript from tab_clinic d where w.clinica=d.ten_server and d.statregt='1' and d.usercomp=1 and d.company=1) as SDESCLINIC, " +
                  " w.despago as SDESPAGO " +
                  " from web_cli_log w, client c where w.client=c.code and tiposolicitud=3 ";
           sql = sql + " and w.fec_ocur >= '" + fInicio + "' and w.fec_ocur <= '" + fFin + "' ";
                  //" and (w.clinica_sol is null or length(w.clinica_sol)=0) "; 
                       
            sql = sql + " and ((w.clinica = '" + strClinica + "' and (w.clinica_sol is null or length(w.clinica_sol)=0)) or w.clinica_sol = '" + strClinica + "' )";
            
            if(strSiniestro!=null && !strSiniestro.equals(""))
                sql = sql + " and w.siniestro = " + strSiniestro ;
                
            if(strNombCliente!=null && !strNombCliente.equals(""))
                sql = sql + " and c.cliename like '%" + strNombCliente + "%'";
            
            if(intGenCover==Constante.NGENCOVERODONT)
                sql = sql + " and w.gencover = " + intGenCover;
            
            if(codGrupo==Constante.NCODGRUPOTINTA || codGrupo==Constante.NCODGRUPOJCOR)
            {
              if(intGenCover==Constante.NGENCOVEREMEACC || intGenCover==Constante.NGENCOVEREMEMED)
              {
                sql = sql + " and w.gencover = " + intGenCover;
              }
            }
            
            if(codGrupo==Constante.NCODGRUPOTINTA)
            {
                sql = sql + " and w.policy in (select pc.policy from pol_clinic pc where pc.clinic_cod in (select tc.code from tab_clinic tc where tc.ten_server = '"+strClinicaTinta+"'))";
            }
                
            sql = sql + " order by w.fec_ocur desc, w.hora_ocur desc";
            System.out.println(sql);
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            
           
            while (objRs.next())
            {
              objLista.add(Tool.llenarRegistroCall(objRs));
            }  
            
            objRs.close();
            objPstmt.close();
            
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        
        if (lista != null)
            return lista;
        else
            return objLista;
        
    }
/*   public static BeanList getListaSolicitudBenIfxPro(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        try
        {
                  
            sql = "select w.siniestro as SNROSINIESTRO," +
                  "       c.cliename as SASEGURADO," +
                  "       w.fec_ocur as SFECHAREG," +
                  "       w.hora_ocur as SHORAREG," +
                  "       tiposolicitud as  STIPOSOLICITUD," +
                  "       w.policy as SPOLIZA," +
                  "       w.certif as SCERTIFICADO," +
                  "       w.client as SCODCLIENTE," +
                  "       w.cover as SCOBERTURA," +
                  "       w.gencover as SGENCOVER," +
                  "       w.descover as SDESCOVER," +
                  "       d.descript as SDESCLINIC " +
                  "from web_cli_log w, client c, tab_clinic d " +
                  "where w.client=c.code " +
                  "and w.clinica=d.ten_server " +
                  "and d.statregt='1' " +
                  "and d.usercomp=1 " +
                  "and d.company=1 ";
                  
                       
            sql = sql + " and w.clinica_sol = '" + strClinica + "'";
            
            if(strSiniestro!=null && !strSiniestro.equals(""))
                sql = sql + " and w.siniestro = " + strSiniestro ;
                
            if(strNombCliente!=null && !strNombCliente.equals(""))
                sql = sql + " and c.cliename like '%" + strNombCliente + "%'";
            
            if(intGenCover==Constante.NGENCOVERODONT)
                sql = sql + " and w.gencover = " + intGenCover;
                
            sql = sql + " order by w.fec_ocur desc, w.hora_ocur desc";
            
            System.out.println(sql);            
            
            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            
           
            while (objRs.next())
            {
              objLista.add(Tool.llenarRegistroCall(objRs));
            }  
            
            objRs.close();
            objPstmt.close();
            
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        
        if (lista != null)
            return lista;
        else
            return objLista;
        
    }      
    
  */  
    public BeanList getLstSolicitudDet(  int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, String strFechaIniSol, 
                                                String strFechaFinSol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUDDET_LIST(?,?,?,?,?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdRol);
                wCstmt.setInt(3, intIdEstado);
                wCstmt.setInt(4, intIdTipoSol);
                wCstmt.setString(5, strNrosiniestro);
                wCstmt.setString(6, strAsegurado);
                wCstmt.setString(7, strIdClinica);
                wCstmt.setInt(8, intCodOficina);
                wCstmt.setString(9, strFechaIniSol);
                wCstmt.setString(10, strFechaFinSol);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudDet:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudDet:" + e);
            }
            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    } 
    
     public Bean getSolicitudSin(BeanList lstSiniestroLog, String strSiniestro)
    {
       int intIndice=-1;
       Bean auxBean = null;
       
       for(int i=0; i<lstSiniestroLog.size(); i++)
       {
          auxBean = lstSiniestroLog.getBean(i);
          if(auxBean.getString("6").equals(strSiniestro))
          {
              intIndice=i;
              break;
          }
       }
       if (intIndice != -1)
       {
          lstSiniestroLog.remove(intIndice);
          return auxBean;
       } 
       System.out.println(strSiniestro + "\n");
       return null;
       
    }   

  public int validaTransaccion(int intTransaccion , int intIdSolicitud)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int nRetorno = -1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{ ? = call PKG_CONSULTA.F_VALIDA_TRANSAC(?,?)}");
                wCstmt.registerOutParameter(1,4);
                wCstmt.setInt(2, intIdSolicitud);
                wCstmt.setInt(3, intTransaccion);
                wCstmt.execute();
                nRetorno= wCstmt.getInt(1);
                return nRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce validaTransaccion:" + se);
                return -2;
            }
            catch(Exception e)
            {
                System.out.println("Excep validaTransaccion:" + e);
                return -2;
            }
            
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                System.out.println("Excep validaTransaccion:" + sqlexception);
                return -2;
            }
        }
    }
    
     public void getTransactionInfo(Solicitud objSolicitud)
    {  
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int nRetorno = -1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_TRANSACTION_INFO_GET(?,?,?,?,?,?)}");
                wCstmt.setInt(1, objSolicitud.getObjSolhis().getNTRANSAC());
                wCstmt.setInt(2, objSolicitud.getNIDSOLICITUD());
                wCstmt.setInt(3, objSolicitud.getObjSolhis().getNIDHISTORICO());
                wCstmt.registerOutParameter(4,OracleTypes.INTEGER);
                wCstmt.registerOutParameter(5,OracleTypes.INTEGER);
                wCstmt.registerOutParameter(6,OracleTypes.VARCHAR);
                wCstmt.execute();
                objSolicitud.getObjSolhis().setNESTADO(wCstmt.getInt(4));
                objSolicitud.getObjSolhis().setIntIDUSUAPROB(wCstmt.getInt(5));
                objSolicitud.getObjSolhis().setStrUSUAPROB(wCstmt.getString(6));     
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getTransactionInfo:" + se);
                
            }
            catch(Exception e)
            {
                System.out.println("Excep getTransactionInfo:" + e);
                e.printStackTrace();
            }
            
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                System.out.println("Excep getTransactionInfo:" + sqlexception);
                sqlexception.printStackTrace();
            }
        }
    }
    

    public int actualizaTransac(int intIdSolicitud, int intNewTransac, int intOldTransac)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intResultado = 1;
        try
        {
            try
            {
               wCon = ConexionOracle.getConnectionOracle();
               wCstmt = wCon.prepareCall("{call PKG_SOLICITUD.P_ACTUALIZA_TRANSAC(?,?,?,?)}");    
               wCstmt.setInt(1, intIdSolicitud);
               wCstmt.setInt(2, intNewTransac);
               wCstmt.setInt(3, intOldTransac);
               wCstmt.registerOutParameter(4, OracleTypes.INTEGER);           
               wCstmt.execute();
               intResultado = wCstmt.getInt(4);           
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudDet:" + se);
              
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep getLstSolicitudDet:" + e);
                
            }
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                sqlexception.printStackTrace();
            }
        }
        return intResultado;
    } 
  
    //SSRS Metodo que realiza el registro de la solitud de carta (CG y CA)
    public int registraSolicitud(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente, String strWebServer,
                                 int intPoliza, int intCertif, int intRamo,String strCodCliente,int intIdSol, String strWebServerSol,
                                            AtencionDAO atencion,PolClinicDAO polClinic,EmailDAO email,ClinicaDAO clinica, int intCaso)
    {
          String strNroAutoriza = "";
          String strRegistroProf ="";
          int intRet = 0;
          
          int intRet2 = insPresupuesto(objSolicitud);
          System.out.println("presupuesto:" + intRet2);
          if (intRet2==0)
          {
              strNroAutoriza = insSolicitudIfx(objSolicitud,objCobertura,objCliente,strWebServer,intCaso);
              
              //Proyecto EPS
              //strRegistroProf = insSolicitudIfx(objSolicitud,objCobertura,objCliente,strWebServer,intCaso);
              //Proyecto EPS

              System.out.println("Primer Certificado=" + objCliente.getIntCertificado() + " | " + 
                                 "Poliza=" + objCliente.getIntPoliza() + " | " +
                                 "Cliente=" + objCliente.getStrCodigo() + " | " +
                                 "Clinica=" + strWebServer + " | " +
                                 "Siniestro=" + strNroAutoriza);

              if (strNroAutoriza!=null && !"".equals(strNroAutoriza) && Tool.parseInt(strNroAutoriza)>0)
              {
                    objSolicitud.setSNROSINIESTRO(strNroAutoriza);
                    objSolicitud.setDFECHAREG(Tool.getDate("dd/MM/yyyy"));
                     
                    if (objCliente.getIntEstadoDeuda()==Constante.CODDEUDAPERMIS)
                    {
                        try
                        {
                            Bean objContratante = polClinic.getContratante(intPoliza,intCertif);
                            String strNomClinica = clinica.getClinica(strWebServer).getString("2");
                     
                            email.enviaMailDeuda(objContratante,intPoliza,intCertif,objCliente,objSolicitud,strNomClinica);
                        }
                        catch(Exception e)
                        {
                            e.printStackTrace();
                        }
                    }
              
                    boolean blRet = atencion.insLogSiniestro(intRamo, intPoliza, intCertif,strCodCliente, 
                                                           strWebServer, strNroAutoriza, objCobertura, objSolicitud.getNIDTIPOSOLICITUD(),strWebServerSol);
                                                           
                    System.out.println("Segundo Certificado=" + intCertif + " | " + 
                                     "Poliza=" + intPoliza + " | " +
                                     "Cliente=" + strCodCliente + " | " +
                                     "Clinica=" + strWebServer + " | " +
                                     "Siniestro=" + strNroAutoriza);
                                 
                    objSolicitud.setSNROSINIESTRO(strNroAutoriza);
                    updSolicitudSiniestro(objSolicitud);  
                   System.out.println("NIDROLRESP  : "+objSolicitud.getNIDROLRESP());
                   System.out.println("COD OFICINA  : "+objSolicitud.getIntCodOficina());
                   System.out.println("SNROSINIESTRO  : "+objSolicitud.getSNROSINIESTRO());
             
                    email.enviaEmailBandeja(1,objSolicitud.getNIDROLRESP(),objSolicitud.getIntCodOficina(),objSolicitud.getSNROSINIESTRO());
              }else
              {
                 Tool.execute_sql("DELETE FROM PTBLSOLICITUD WHERE NIDSOLICITUD=" + intIdSol);
                 intRet =  -1;
              }    
          }
          else
          {
             Tool.execute_sql("DELETE FROM PTBLSOLICITUD WHERE NIDSOLICITUD=" + intIdSol);
             intRet =  -1;
          }
          System.out.println("punto5=" + objCliente.getIntCertificado() + " | " + 
                       "Poliza=" + objCliente.getIntPoliza() + " | " +
                       "Cliente=" + objCliente.getStrCodigo());          
          return intRet;
    }
    
    //SSRS Metodo que realiza la ampliación de carta de garantía
    public  int ampliaSolicitudSyn(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente)
    {
          objSolicitud.setStrFechaEmi(Tool.getDate("dd/MM/yyyy"));
          objSolicitud.setDblTipoCambio(Tool.parseDouble(Tool.getTipoCambio()));
          int intTransac = ampliaSolicitudIfx(objSolicitud,objCobertura,objCliente);   
          objSolicitud.getObjSolhis().setNTRANSAC(intTransac);
          
          int intRet = insPresupuesto(objSolicitud);
         
          return intRet;
    }
  
    //SSRS Metodo que realiza la ampliación de solicitud de beneficio
    public  String  generaSolicitudSyn(int intPoliza, int intCertif, String strCodCliente, String strWebServer,
                                       int intCover, int intConceptoPago, int intSelcover,String strWebServerSol,AtencionDAO atencion , 
                                       PolClinicDAO polClinic , ClienteDAO cliente,int intRamo)
    {
         
        //SSRS Se genera el siniestro asociado a la SB
         System.out.println("SB Certificado=" + intCertif + " | " + 
                                     "Poliza=" + intPoliza + " | " +
                                     "Cliente=" + strCodCliente + " | " +
                                     "Clinica=" + strWebServer);
        
        String strNroAutoriza = atencion.getAutorizacion(intPoliza, intCertif, strCodCliente, 
                                                 strWebServer,intCover,intConceptoPago);
                                                 
        System.out.println("SB Certificado=" + intCertif + " | " + 
                                     "Poliza=" + intPoliza + " | " +
                                     "Cliente=" + strCodCliente + " | " +
                                     "Clinica=" + strWebServer + " | " +
                                     "strNroAutoriza=" + strNroAutoriza);                                                 
        
        if (!"".equals(strNroAutoriza) && !"-1".equals(strNroAutoriza))
        {
            Cliente objCliente = new Cliente();
            Bean objAtencion = atencion.getCliente(intPoliza, intCertif, strCodCliente,strWebServer,intRamo);
          
           System.out.println(objAtencion);   
            objCliente = cliente.setCliente(objAtencion,strCodCliente);
            Cobertura objCobertura = null;
            ArrayList lstCobertura = polClinic.getLstCobertura(objCliente.getIntProducto(), objCliente.getIntCodPlan(),
                                    objCliente.getIntCodMoneda(), objCliente.getIntCodParentesco(),
                                    objCliente.getStrCodExtSexo() ,intPoliza, intCertif, strWebServer,
                                    strCodCliente, objCliente.getIntCodEstado(),atencion,intRamo,0);
                                 
            objCobertura = (Cobertura)lstCobertura.get(intSelcover);
   
            int genCover =  objCobertura.getIntCoverGen();
            
            int tipoSolicitud = 0;
            if(objCobertura.getStrTipoAtencion().equals(Constante.SATENAMB) || genCover==Constante.NGENCOVERODONT)
            {
                tipoSolicitud = Constante.NTSCARBEN;
            }

            //SSRS session.setAttribute("CoberturaSel",objCobertura);
        
            //SSRS Se registra el log de siniestro para la impresion de SB
            
            System.out.println("SB Certificado=" + intCertif + " | " + 
                                     "Poliza=" + intPoliza + " | " +
                                     "Cliente=" + strCodCliente + " | " +
                                     "Clinica=" + strWebServer + " | " +
                                     "strNroAutoriza=" + strNroAutoriza);  
            
            boolean blRet = atencion.insLogSiniestro(intRamo, intPoliza, intCertif,strCodCliente, 
                                                     strWebServer, strNroAutoriza, objCobertura, tipoSolicitud,strWebServerSol );
            
            System.out.println("SB Certificado=" + intCertif + " | " + 
                                     "Poliza=" + intPoliza + " | " +
                                     "Cliente=" + strCodCliente + " | " +
                                     "Clinica=" + strWebServer + " | " +
                                     "strNroAutoriza=" + strNroAutoriza);  
                                     
            strNroAutoriza = strNroAutoriza + "|" + genCover;
        }
        else
            strNroAutoriza = "-1";
        
        return strNroAutoriza;
    }
    
    
     public BeanList getLstSolicitudHistoricoPaciente(String strFechaIniSol, 
                                                             String strFechaFinSol,
                                                             int intIdTipoSol, 
                                                             String strIdClinica,
                                                             String strNomPaciente)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUDHIST_LIST(?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setString(2, strFechaIniSol);
                wCstmt.setString(3, strFechaFinSol);
                wCstmt.setInt(4, intIdTipoSol);
                wCstmt.setString(5, strIdClinica);
                wCstmt.setString(6, strNomPaciente);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudPend:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudPend:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    }        
    
    
    public BeanList getLstFilesHistorico(int intIdSolicitud)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_FILES_HIS_LIST(?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdSolicitud);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                  lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstFilesHistorico:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstFilesHistorico:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    }            
    
    
    /*2012-0078*/
    public int insHistoricoSolicitudMaxCoaseguro(Cliente objCliente, Cobertura objCobertura, Solicitud objSolicitud,
                                                 Poliza objPoliza, Usuario objUsuario,
                                                 double dblMontoInicial, String strAccion, int intIdCompania){
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intResultado = 1;
        try
        {
            try
            {                
               wCon = ConexionIFX.getConnection();
               wCstmt = wCon.prepareCall("{call ins_claim_indem_hist(?,?,?,?,?,?,?,?,?,?)}");    
               wCstmt.setInt(1, objCliente.getIntProducto());
               wCstmt.setInt(2, objCobertura.getIntCover());
               wCstmt.setInt(3, objCobertura.getIntConceptoPago());
               wCstmt.setInt(4, Integer.parseInt(objSolicitud.getSNROSINIESTRO()));
               wCstmt.setDouble(5, objPoliza.getDblMaxMontoCoaseguro());
               wCstmt.setDouble(6, dblMontoInicial);               
               wCstmt.setString(7, strAccion);
               wCstmt.setDouble(8, Double.parseDouble(objCobertura.getStrCoaseguro()));
               wCstmt.setInt(9, objUsuario.getIntIdUsuario());
               wCstmt.setInt(10, intIdCompania);               
               wRs = wCstmt.executeQuery();
               
               if (wRs.next())
                {
                  intResultado = wRs.getInt(1);
                }
                return intResultado;                      
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce insHistoricoSolicitudMaxCoaseguro:" + se);              
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep insHistoricoSolicitudMaxCoaseguro:" + e);                
            }
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                sqlexception.printStackTrace();
            }
        }
        return intResultado;
    }
    
/*2012-0078*/
 public int updHistoricoSolicitudMaxCoaseguro (Solicitud objSolicitud, int intIdfirstClaim){
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intResultado = 1;
        try
        {
            try
            {
               wCon = ConexionIFX.getConnection();
               wCstmt = wCon.prepareCall("{call upd_claim_indem_hist(?,?,?)}");    
               wCstmt.setInt(1, intIdfirstClaim);
               wCstmt.setInt(2, Integer.parseInt(objSolicitud.getSNROSINIESTRO()));
               wCstmt.setDouble(3, objSolicitud.getDblImporteCarta());                              
               wRs = wCstmt.executeQuery();
               
               if (wRs.next())
                {
                  intResultado = wRs.getInt(1);
                }
                return intResultado;                 
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce updHistoricoSolicitudMaxCoaseguro:" + se);              
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep updHistoricoSolicitudMaxCoaseguro:" + e);                
            }
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                sqlexception.printStackTrace();
            }
        }
        return intResultado;
    }
    
    /*2012-0078*/
    public String consultaHistoricoSiniestroCoaseguro(int intIdfirstClaim)
    {
      ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        String strResultado = "0,0";
        try
        {
            try
            {
               wCon = ConexionIFX.getConnection();
               wCstmt = wCon.prepareCall("{call rea_claim_indem_hist(?)}");    
               wCstmt.setInt(1, intIdfirstClaim);
               wRs = wCstmt.executeQuery();
               
               if (wRs.next())
                {
                   String result = wRs.getString(1);
                   if (result != null)
                    strResultado = result;
                }
                return strResultado;                 
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce consultaHistoricoSiniestroCoaseguro:" + se);              
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep consultaHistoricoSiniestroCoaseguro:" + e);                
            }
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                sqlexception.printStackTrace();
            }
        }
        return strResultado;
    }
    
    //Inicio Req. 2014-000204 Paradigmasoft GJB
    public double obtenerMontoCarta(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int nIdSolicitud, String sNroSiniestro)
    {
      int nNTransac = -1;
      double nFactorIGV = 0;
      double nImporteCarta = 0;
      
      CallableStatement objCstmtOra = null;
      ResultSet objRsOra = null;   
      CallableStatement objCstmtIfx = null;
      ResultSet objRsIfx = null;
      
      try{
        objCstmtOra = objConOra.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_GET (?,?)}");
        objCstmtOra.registerOutParameter(1, -10);
        objCstmtOra.setInt(2, nIdSolicitud);                
        objCstmtOra.execute();
        objRsOra = ((OracleCallableStatement)objCstmtOra).getCursor(1);
        if(objRsOra.next()){
          nNTransac = objRsOra.getInt("NTRANSAC");
          nFactorIGV = objRsOra.getDouble("NFACTORIGV");
        }
        
        if(sNroSiniestro == ""){
          sNroSiniestro = "0";
        }
        if(nNTransac == -1 || nNTransac ==0){
          nNTransac = 1;
        }
        objCstmtIfx = objCnnIfx.prepareCall("{call rea_monto_carta(?,?)}");
        objCstmtIfx.setInt(1, Integer.parseInt(sNroSiniestro));
        objCstmtIfx.setInt(2, nNTransac);
        objRsIfx = objCstmtIfx.executeQuery();
        
        if (objRsIfx.next()){
          nImporteCarta = objRsIfx.getDouble(1);
        }        
      }
      catch(SQLException se){
        se.printStackTrace();
        System.out.println("SQLException obtenerMontoSolicitud:" + se); 
      }
      catch(Exception ex){
        ex.printStackTrace();
        System.out.println("Exception obtenerMontoSolicitud:" + ex); 
      }
      finally{
        try{
          if(objRsOra != null){
            objRsOra.close();
          }
          if(objCstmtOra != null){
            objCstmtOra.close();
          }
          if(objRsIfx != null){
            objRsIfx.close();
          }
          if(objCstmtIfx != null){
            objCstmtIfx.close();
          }          
        }
        catch(SQLException se){
          se.printStackTrace();
          System.out.println("SQLException obtenerMontoSolicitud:" + se); 
        }
      }      
      
      Presupuesto objPresupuesto = null;      
            
      if (nNTransac != 1){
        objPresupuesto = gc.getPresupuesto(nIdSolicitud,nNTransac); 
      }
      else{
        objPresupuesto = gc.getPresupuesto(nIdSolicitud,1);
      }
            
      int intTransaccion = gc.validaTransaccion(nNTransac,nIdSolicitud);    
      
      double dblMontoCarta = 0;
      if(objPresupuesto != null){
        ArrayList detalle = objPresupuesto.getArrDetalle();      
        double dblTotalPresupuesto = 0;
        for(int intIndice=0; intIndice<detalle.size(); intIndice++){
          DetallePresupuesto objDetalle = ((DetallePresupuesto)detalle.get(intIndice));
          if(objDetalle.getDblMontoConcepto()>0){
            dblTotalPresupuesto += objDetalle.getDblMontoConcepto();  
          }
        }      
        dblTotalPresupuesto = Tool.redondear(dblTotalPresupuesto,2);
        if(nImporteCarta - dblTotalPresupuesto > 0.5 && nFactorIGV == 1.19){
          dblMontoCarta = nImporteCarta;
        }         
        else{
          dblMontoCarta = nImporteCarta * nFactorIGV;    
          dblMontoCarta = Tool.redondear(dblMontoCarta,2);
        }          
      } 
      return dblMontoCarta;
    } 
    
    public int actualizarFechaLimiteSolicitud(String sNroSiniestro, int nDias){
      
      Connection objConIfx = null;
      CallableStatement objCstmtIfx = null;
      ResultSet objRsIfx = null;
      int nResultado = 0; //Por defecto no se actualiza nada
      String sNuevaFechaLimite = "";
      
      try{
        java.util.Date fecha = new Date();  
        sNuevaFechaLimite = Tool.addDays(nDias,fecha);
      
        objConIfx = ConexionIFX.getConnection();
        objCstmtIfx = objConIfx.prepareCall("{call upd_fec_lim_sol(?,?)}");
        objCstmtIfx.setInt(1,Integer.parseInt(sNroSiniestro));
        objCstmtIfx.setString(2, sNuevaFechaLimite);
        objRsIfx = objCstmtIfx.executeQuery();
        
        if(objRsIfx.next()){
          nResultado = objRsIfx.getInt(1);
        }
        return nResultado;
      }
      catch(SQLException se){
        se.printStackTrace();
        System.out.println("SQLException actualizarFechaLimiteSolicitud:" + se); 
      }
      catch(Exception ex){
        ex.printStackTrace();
        System.out.println("SQLException actualizarFechaLimiteSolicitud:" + ex); 
      }
      finally{
        try{
          if(objRsIfx != null){
            objRsIfx.close();
          }
          if(objCstmtIfx != null){
            objCstmtIfx.close();
          }
          if(objConIfx != null){
            objConIfx.close();
          }
        }
        catch(SQLException se){
          se.printStackTrace();
          System.out.println("SQLException actualizarFechaLimiteSolicitud:" + se); 
        }        
      }
      return nResultado;
    }
    //Fin Req. 2014-000204 Paradigmasoft GJB
    
    //RQ2015-000750 INICIO
    public BeanList getLstSolicitudPendPag(int intIdRol, int intIdTipoSol, String strNrosiniestro, String strAsegurado, 
                                          String strIdClinica, int intCodBroker, int intTipo, int intIdUsuario, 
                                          String strIdEstados, String strOficCon, int intAviso, int intPaginaActual, int intNumRegPag)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        GestorSolicitud gestorSolicitud = new GestorSolicitud();        
        Connection objCnnIfx = null;
        PreparedStatement objPstmtIfx = null;
        ResultSet objRsIfx = null;             
        
        Bean lista_aux = new Bean();
        String strdiagnostico="";
        double dblMontoCarta = 0;        
        
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLSOLICITUDPEND_LIST_PAG(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdRol);
                wCstmt.setString(3, strIdEstados);
                wCstmt.setInt(4, intIdTipoSol);
                wCstmt.setString(5, strNrosiniestro);
                wCstmt.setString(6, strAsegurado);
                wCstmt.setString(7, strIdClinica);
                wCstmt.setString(8,strOficCon);
                wCstmt.setInt(9, intCodBroker);
                wCstmt.setInt(10, intTipo);
                wCstmt.setInt(11, intIdUsuario);
                wCstmt.setInt(12, intAviso);
                wCstmt.setInt(13, intPaginaActual);
                wCstmt.setInt(14, intNumRegPag);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                objCnnIfx = ConexionIFX.getConnection();
                
                while (wRs.next()){         
                  lista_aux = Tool.llenarRegistroCall(wRs);                  
                  strdiagnostico = gestorSolicitud.obtenerDiagnostico(objCnnIfx, lista_aux.getString("SNROSINIESTRO"));  
                  dblMontoCarta = gestorSolicitud.obtenerMontoCartaAcumulado(wCon, objCnnIfx, gestorSolicitud, Tool.parseInt(lista_aux.getString("NIDSOLICITUD")), lista_aux.getString("SNROSINIESTRO"));
                  lista_aux.put("SDIAGNOSTICO", strdiagnostico!=null?strdiagnostico.trim():"NO ESPECIFICADO");
                  lista_aux.put("NMONTOCARTA", Double.toString(dblMontoCarta));
                  lista.add(lista_aux);
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudPend:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudPend:" + e);
            }
            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
                if(objCnnIfx != null)
                    objCnnIfx.close();                
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
   }   
   
   public AvisoSolicitud getDatosSolicitudInx(int nClaim, int nTrans)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        AvisoSolicitud objAvisoSolicitud = new AvisoSolicitud();
        
        String sql="execute procedure sp_data_aviso_gere(" + nClaim + ", " + nTrans + ")";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objAvisoSolicitud.setStrFechaMovimiento(objRs.getString("dFechaMov"));                   
                 objAvisoSolicitud.setSBroker(objRs.getString("sBroker").trim());                   
                 objAvisoSolicitud.setDBlreserva(Tool.parseDouble(objRs.getString("nReserva")));
                 objAvisoSolicitud.setSParticipacion(objRs.getString("sParticipacion").trim());                   
                 objAvisoSolicitud.setNMoneda(Tool.parseInt(objRs.getString("nMoneda")));                   
                 objAvisoSolicitud.setDblTipoCambio(Tool.parseDouble(objRs.getString("nTipoCambio")));
                 objAvisoSolicitud.setNProduct(Tool.parseInt(objRs.getString("nProduct")));
                 objAvisoSolicitud.setSCoberturaST(objRs.getString("sCover").trim());
                 objAvisoSolicitud.setStrFechaEmision(objRs.getString("sOccurdate").trim());
            }            
            return objAvisoSolicitud;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return null;
    }     
    
    public int procesarAvisoSolicitud(AvisoSolicitud objAvisoSolicitud)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLAVISOSOLICITUD_PROC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setString(2, objAvisoSolicitud.getStrFechaMovimiento());
            wCstmt.setString(3, objAvisoSolicitud.getSBroker());
            wCstmt.setDouble(4, objAvisoSolicitud.getDBlreserva());           
            wCstmt.setString(5, objAvisoSolicitud.getSParticipacion());
            wCstmt.setInt(6, objAvisoSolicitud.getNMoneda());            
            wCstmt.setDouble(7, objAvisoSolicitud.getDblTipoCambio());
            wCstmt.setString(8, objAvisoSolicitud.getSRamo());
            wCstmt.setString(9, objAvisoSolicitud.getSOficina());
            wCstmt.setString(10, objAvisoSolicitud.getSAsegurado());
            wCstmt.setString(11, objAvisoSolicitud.getSContratante());
            wCstmt.setInt(12, objAvisoSolicitud.getNPoliza());
            wCstmt.setInt(13, objAvisoSolicitud.getNCertif());
            wCstmt.setInt(14, objAvisoSolicitud.getNClaim());
            wCstmt.setString(15, objAvisoSolicitud.getSPaciente());
            wCstmt.setString(16, objAvisoSolicitud.getSModalidad());
            wCstmt.setString(17, objAvisoSolicitud.getStrFechaEmision());
            wCstmt.setString(18, objAvisoSolicitud.getSCobertura());   
            wCstmt.setString(19, objAvisoSolicitud.getSDeducible());   
            wCstmt.setDouble(20, objAvisoSolicitud.getDblCoaseguro());
            wCstmt.setInt(21, objAvisoSolicitud.getNOficina());
            wCstmt.setInt(22, objAvisoSolicitud.getNSolicitud());
            wCstmt.setInt(23, objAvisoSolicitud.getNUsuario());
            wCstmt.setDouble(24, objAvisoSolicitud.getDblSubTotal());
            wCstmt.setInt(25, objAvisoSolicitud.getNMonedaCarta());
            wCstmt.setInt(26, objAvisoSolicitud.getNProduct());
            wCstmt.setString(27, objAvisoSolicitud.getSCoberturaST());
            wCstmt.setString(28, objAvisoSolicitud.getSProducto());
            
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
  
      public int procesarAvisoCliente(AvisoSolicitud objAvisoSolicitud)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLAVISOCLIENTE_PROC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setString(2, objAvisoSolicitud.getStrFechaMovimiento());
            wCstmt.setString(3, objAvisoSolicitud.getSBroker());
            wCstmt.setDouble(4, objAvisoSolicitud.getDBlreserva());           
            wCstmt.setString(5, objAvisoSolicitud.getSParticipacion());
            wCstmt.setInt(6, objAvisoSolicitud.getNMoneda());            
            wCstmt.setDouble(7, objAvisoSolicitud.getDblTipoCambio());
            wCstmt.setString(8, objAvisoSolicitud.getSRamo());
            wCstmt.setString(9, objAvisoSolicitud.getSOficina());
            wCstmt.setString(10, objAvisoSolicitud.getSAsegurado());
            wCstmt.setString(11, objAvisoSolicitud.getSContratante());
            wCstmt.setInt(12, objAvisoSolicitud.getNPoliza());
            wCstmt.setInt(13, objAvisoSolicitud.getNCertif());
            wCstmt.setInt(14, objAvisoSolicitud.getNClaim());
            wCstmt.setString(15, objAvisoSolicitud.getSPaciente());
            wCstmt.setString(16, objAvisoSolicitud.getSModalidad());
            wCstmt.setString(17, objAvisoSolicitud.getStrFechaEmision());
            wCstmt.setString(18, objAvisoSolicitud.getSCobertura());   
            wCstmt.setString(19, objAvisoSolicitud.getSDeducible());   
            wCstmt.setDouble(20, objAvisoSolicitud.getDblCoaseguro());
            wCstmt.setInt(21, objAvisoSolicitud.getNOficina());
            wCstmt.setInt(22, objAvisoSolicitud.getNSolicitud());
            wCstmt.setInt(23, objAvisoSolicitud.getNUsuario());
            wCstmt.setDouble(24, objAvisoSolicitud.getDblSubTotal());
            wCstmt.setInt(25, objAvisoSolicitud.getNMonedaCarta());
            wCstmt.setInt(26, objAvisoSolicitud.getNProduct());
            wCstmt.setString(27, objAvisoSolicitud.getSCoberturaST());
            wCstmt.setString(28, objAvisoSolicitud.getSProducto());
            wCstmt.setString(29, objAvisoSolicitud.getSClinica());
            wCstmt.setString(30, objAvisoSolicitud.getSClient());
            wCstmt.setString(31, objAvisoSolicitud.getUrlLogo());
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
  
  public int SendAvisoGerencia(AvisoSolicitud objAvisoSolicitud)
  {     int resultado=-1;     
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.ENVIO_ALERTA(?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, objAvisoSolicitud.getNSolicitud());
            wCstmt.setString(3, objAvisoSolicitud.getSObservacion());
            wCstmt.setInt(4, objAvisoSolicitud.getNUsuario());
            wCstmt.execute();            
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
  
  
  public double obtenerMontoCartaAcumulado(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int nIdSolicitud, String sNroSiniestro)
    {
      int nNTransac = -1;
      double nFactorIGV = 0;
      double nImporteCarta = 0;
      
      CallableStatement objCstmtOra = null;
      ResultSet objRsOra = null;   
      CallableStatement objCstmtIfx = null;
      ResultSet objRsIfx = null;
      
      try{
        objCstmtOra = objConOra.prepareCall("{call PKG_CONSULTA.P_PTBLSOLICITUD_GET (?,?)}");
        objCstmtOra.registerOutParameter(1, -10);
        objCstmtOra.setInt(2, nIdSolicitud);                
        objCstmtOra.execute();
        objRsOra = ((OracleCallableStatement)objCstmtOra).getCursor(1);
        if(objRsOra.next()){
          nNTransac = objRsOra.getInt("NTRANSAC");
          nFactorIGV = objRsOra.getDouble("NFACTORIGV");
        }
        
        if(sNroSiniestro == ""){
          sNroSiniestro = "0";
        }
        if(nNTransac == -1 || nNTransac ==0){
          nNTransac = 1;
        }
        objCstmtIfx = objCnnIfx.prepareCall("{call rea_monto_carta_acumulado(?,?)}");
        objCstmtIfx.setInt(1, Integer.parseInt(sNroSiniestro));
        objCstmtIfx.setInt(2, nNTransac);
        objRsIfx = objCstmtIfx.executeQuery();
        
        if (objRsIfx.next()){
          nImporteCarta = objRsIfx.getDouble(1);
        }        
      }
      catch(SQLException se){
        se.printStackTrace();
        System.out.println("SQLException obtenerMontoSolicitud:" + se); 
      }
      catch(Exception ex){
        ex.printStackTrace();
        System.out.println("Exception obtenerMontoSolicitud:" + ex); 
      }
      finally{
        try{
          if(objRsOra != null){
            objRsOra.close();
          }
          if(objCstmtOra != null){
            objCstmtOra.close();
          }
          if(objRsIfx != null){
            objRsIfx.close();
          }
          if(objCstmtIfx != null){
            objCstmtIfx.close();
          }          
        }
        catch(SQLException se){
          se.printStackTrace();
          System.out.println("SQLException obtenerMontoSolicitud:" + se); 
        }
      }      
      
      Presupuesto objPresupuesto = null;      
            
      if (nNTransac != 1){
        objPresupuesto = gc.getPresupuesto(nIdSolicitud,nNTransac); 
      }
      else{
        objPresupuesto = gc.getPresupuesto(nIdSolicitud,1);
      }
            
      int intTransaccion = gc.validaTransaccion(nNTransac,nIdSolicitud);    
      
      double dblMontoCarta = 0;
      if(objPresupuesto != null){
        ArrayList detalle = objPresupuesto.getArrDetalle();      
        double dblTotalPresupuesto = 0;
        for(int intIndice=0; intIndice<detalle.size(); intIndice++){
          DetallePresupuesto objDetalle = ((DetallePresupuesto)detalle.get(intIndice));
          if(objDetalle.getDblMontoConcepto()>0){
            dblTotalPresupuesto += objDetalle.getDblMontoConcepto();  
          }
        }      
        dblTotalPresupuesto = Tool.redondear(dblTotalPresupuesto,2);
        if(nImporteCarta - dblTotalPresupuesto > 0.5 && nFactorIGV == 1.19){
          dblMontoCarta = nImporteCarta;
        }         
        else{
          dblMontoCarta = nImporteCarta * nFactorIGV;    
          dblMontoCarta = Tool.redondear(dblMontoCarta,2);
        }          
      } 
      return dblMontoCarta;
    } 
   //RQ2015-000750 FIN
   //RQ2015-000604 INICIO
        public int procesarAvisoRechazo(AvisoRechazo objAvisoRechazo)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.PTBLAVISORECHAZO_PROC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setString(2, objAvisoRechazo.getStrFechaMovimiento());
            wCstmt.setString(3, objAvisoRechazo.getSBroker());
            wCstmt.setDouble(4, objAvisoRechazo.getDBlreserva());           
            wCstmt.setString(5, objAvisoRechazo.getSParticipacion());
            wCstmt.setInt(6, objAvisoRechazo.getNMoneda());            
            wCstmt.setDouble(7, objAvisoRechazo.getDblTipoCambio());
            wCstmt.setString(8, objAvisoRechazo.getSRamo());
            wCstmt.setString(9, objAvisoRechazo.getSOficina());
            wCstmt.setString(10, objAvisoRechazo.getSAsegurado());
            wCstmt.setString(11, objAvisoRechazo.getSContratante());
            wCstmt.setInt(12, objAvisoRechazo.getNPoliza());
            wCstmt.setInt(13, objAvisoRechazo.getNCertif());
            wCstmt.setInt(14, objAvisoRechazo.getNClaim());
            wCstmt.setString(15, objAvisoRechazo.getSPaciente());
            wCstmt.setString(16, objAvisoRechazo.getSModalidad());
            wCstmt.setString(17, objAvisoRechazo.getStrFechaEmision());
            wCstmt.setString(18, objAvisoRechazo.getSCobertura());   
            wCstmt.setString(19, objAvisoRechazo.getSDeducible());   
            wCstmt.setDouble(20, objAvisoRechazo.getDblCoaseguro());
            wCstmt.setInt(21, objAvisoRechazo.getNOficina());
            wCstmt.setInt(22, objAvisoRechazo.getNSolicitud());
            wCstmt.setInt(23, objAvisoRechazo.getNUsuario());
            wCstmt.setDouble(24, objAvisoRechazo.getDblSubTotal());
            wCstmt.setInt(25, objAvisoRechazo.getNMonedaCarta());
            wCstmt.setInt(26, objAvisoRechazo.getNProduct());
            wCstmt.setString(27, objAvisoRechazo.getSCoberturaST());
            wCstmt.setString(28, objAvisoRechazo.getSProducto());
            wCstmt.setString(29, objAvisoRechazo.getSClinica());
            wCstmt.setString(30, objAvisoRechazo.getSClient());
            
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }
public int procesarRechazo(AvisoRechazo objAvisoRechazo)
  {     int resultado=-1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.SP_INS_CARTRECHAZO(?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, objAvisoRechazo.getNUsuario());
            wCstmt.setInt(3, objAvisoRechazo.getNClaim());
            wCstmt.setInt(4, objAvisoRechazo.getNIdMotReSBS());            
            wCstmt.setInt(5, objAvisoRechazo.getNIdSubMotRe());
            wCstmt.setString(6, objAvisoRechazo.getNIDDiagnos());
            wCstmt.setString(7, objAvisoRechazo.getSDiagnos());
            wCstmt.setString(8, objAvisoRechazo.getSProcedimient());
            wCstmt.setDouble(9, objAvisoRechazo.getNMontoRechazo());
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }  
  public AvisoRechazo getDatosRSolicitudInx(int nClaim, int nTrans)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        AvisoRechazo objAvisoRechazo = new AvisoRechazo();
        
        String sql="execute procedure rea_data_aviso_gerencia(" + nClaim + ", " + nTrans + ")";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objAvisoRechazo.setStrFechaMovimiento(objRs.getString("dFechaMov"));                   
                 objAvisoRechazo.setSBroker(objRs.getString("sBroker").trim());                   
                 objAvisoRechazo.setDBlreserva(Tool.parseDouble(objRs.getString("nReserva")));
                 objAvisoRechazo.setSParticipacion(objRs.getString("sParticipacion").trim());                   
                 objAvisoRechazo.setNMoneda(Tool.parseInt(objRs.getString("nMoneda")));                   
                 objAvisoRechazo.setDblTipoCambio(Tool.parseDouble(objRs.getString("nTipoCambio")));
                 objAvisoRechazo.setNProduct(Tool.parseInt(objRs.getString("nProduct")));
                 objAvisoRechazo.setSCoberturaST(objRs.getString("sCover").trim());
            }            
            return objAvisoRechazo;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        finally
        {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return null;
    }     
//RQ2015-000750 Inicio    
public AvisoRechazo getDatosCartaRechazo(int intclaim)
  {
            AvisoRechazo solicitud = new AvisoRechazo();
            
            solicitud.setNClaim(intclaim);
            
                  
                  Bean objTable = Tabla.reaDatosRechazo(solicitud.getNClaim());
                  //Bean objTable = Tabla.reaEmailAseg(solicitud.getStrCodigo());
                  if (objTable != null){
                    solicitud.setNIdMotReSBS(Tool.parseInt(objTable.getString("ID_MOTSBS")));
                    solicitud.setNIdSubMotRe(Tool.parseInt(objTable.getString("ID_SUBMOT")));
                    solicitud.setNIDDiagnos(objTable.getString("ID_DIAGNOS"));
                    solicitud.setSDiagnos(objTable.getString("SDIAGNOS"));
                    solicitud.setSProcedimient(objTable.getString("PROCRECHA"));
                    solicitud.setNMontoRechazo(Tool.parseDouble(objTable.getString("MONTO")));
                    solicitud.setSCond_poli(objTable.getString("COND_POLI"));
                    solicitud.setSCond_polii(objTable.getString("COND_POLII"));
                    solicitud.setSNumCartRech(objTable.getString("NUM_CARTRECHA"));
                    solicitud.setNIdStaCartR(Tool.parseInt(objTable.getString("ID_ESTADO")));
                  }
                  
                  
        return solicitud;
    
  }
public int actualizaRechazo(AvisoRechazo objAvisoRechazo)
  {     int resultado=1;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.SP_UPD_CARTRECHAZO(?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);            
            wCstmt.setInt(2, objAvisoRechazo.getNClaim());            
            wCstmt.setString(3, objAvisoRechazo.getSCond_poli());
            wCstmt.setString(4, objAvisoRechazo.getSCond_polii());
            wCstmt.setString(5, objAvisoRechazo.getSNumCartRech());
            wCstmt.setInt(6, objAvisoRechazo.getNIdStaCartR());            
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  } 
public BeanList getLstSolicitudRechazo(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        
        /*Inicio Req. 2014-000204 Paradigmasoft GJB*/
        GestorSolicitud gestorSolicitud = new GestorSolicitud();        
        Connection objCnnIfx = null;
        PreparedStatement objPstmtIfx = null;
        ResultSet objRsIfx = null;             
        
        Bean lista_aux = new Bean();
        String strdiagnostico="";
        double dblMontoCarta = 0;        
        int intIndicador = 1;
        int intMaxSolicitudes = Tool.parseInt(Constante.getConst("LIM_SOL"));
        /*Fin Req. 2014-000204 Paradigmasoft GJB*/
        
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.P_PTBLSOLICITUDRECHAZO_LIST(?,?,?,?,?,?,?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdRol);
                //Req 2011-0975
                //wCstmt.setString(3, intIdEstados);
                wCstmt.setString(3, strIdEstados);
                //Fin Req 2011-0975
                wCstmt.setInt(4, intIdTipoSol);
                wCstmt.setString(5, strNrosiniestro);
                wCstmt.setString(6, strAsegurado);
                wCstmt.setString(7, strIdClinica);
                //Req 2011-0975
                //wCstmt.setInt(8, intCodOficina);
                wCstmt.setString(8,strOficCon);
                //Fin Req 2011-0975
                wCstmt.setInt(9, intCodBroker);
                wCstmt.setInt(10, intTipo);
                wCstmt.setInt(11, intIdUsuario);

                
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                objCnnIfx = ConexionIFX.getConnection();
                
                while (wRs.next() && intIndicador <= intMaxSolicitudes){
                  /*Inicio Req. 2014-000204 Paradigmasoft GJB*/                  
                  lista_aux = Tool.llenarRegistroCall(wRs);                  
                  strdiagnostico = gestorSolicitud.obtenerDiagnostico(objCnnIfx, lista_aux.getString("SNROSINIESTRO"));  
                  dblMontoCarta = gestorSolicitud.obtenerMontoCarta(wCon, objCnnIfx, gestorSolicitud, Tool.parseInt(lista_aux.getString("NIDSOLICITUD")), lista_aux.getString("SNROSINIESTRO"));
                  lista_aux.put("SDIAGNOSTICO", strdiagnostico!=null?strdiagnostico.trim():"NO ESPECIFICADO");
                  lista_aux.put("NMONTOCARTA", Double.toString(dblMontoCarta));
                  lista.add(lista_aux);
                  intIndicador = intIndicador + 1;
                  /*Fin Req. 2014-000204 Paradigmasoft GJB*/                  
                  
                  //lista.add(Tool.llenarRegistroCall(wRs)); Se comentó el día 20/11/2014
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudPend:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudPend:" + e);
            }

            return lista;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
                if(objCnnIfx != null)
                    objCnnIfx.close();                
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }
    }
public int estadoCartaRechazo()
  {     int resultado=0;     
        ResultSet wRs = null;
         Connection wCon = null;
         CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.SP_SET_STARECHAZO(?)}");    
            wCstmt.registerOutParameter(1, 4);                                
            wCstmt.execute();
            resultado = wCstmt.getInt(1);           
            return resultado;
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println(se.getMessage());
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  } 
//RQ2015-000604 Fin
 public String benefConsumidoCase(int intCaso,int intSini)
  {   
      String strMonto ="0";
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_cover_used_case(?,?)}");            
                objCstmt.setInt(1, intCaso); 
                objCstmt.setInt(2, intSini);
                objRs = objCstmt.executeQuery();
                if ( objRs.next() )
                {
                  strMonto = objRs.getString(1);
                }

                return strMonto;
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce sp_cover_used_case:" + se);
                return "0";
      }
      catch(Exception e)
      {
                System.out.println("Excep sp_cover_used_case:" + e);
                return "0";
                
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
                return "-1";
            }
      }
  }
  
  public int ValidarCaso(int intPoliza,int intCertif,String strNombre,String strDNI,String strApellido,String strCodCliente)
  {
      int intValidar = 0;
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_web_valid_case(?,?,?,?,?,?)}");            
                objCstmt.setInt(1, intPoliza); 
                objCstmt.setInt(2, intCertif); 
                objCstmt.setString(3, strNombre); 
                objCstmt.setString(4, strDNI); 
                objCstmt.setString(5, strApellido); 
                objCstmt.setString(6, strCodCliente); 
                objRs = objCstmt.executeQuery();
                if ( objRs.next() )
                {
                  //intValidar = Integer.parseInt(objRs.getString(1));
                  intValidar = objRs.getInt(1);
                }

                System.out.println("Valor retorna:" + intValidar);
                
                return intValidar;  
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce ValidarCaso:" + se);
                return -1;
      }
      catch(Exception e)
      {
                System.out.println("Excep ValidarCaso:" + e);
                return -1;
                
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
                return -1;
            }
      }
  }
  
public BeanList getPermisosRol(int intRol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call USRWCLEPS_APP.PKG_CONSULTA.P_PERMISOS_ROL(?,?)}");                
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intRol);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                    lista.add(Tool.llenarRegistroCall(wRs));                    
                  }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getPermisosRol:" + se);
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getPermisosRol:" + e);
            }
            return null;
        }
        finally
        {
            try
            {
                if(wCstmt != null)
                    wCstmt.close();
                if(wRs != null)
                    wRs.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception)
            {
                return null;
            }
        }
    } 

	//INICIO RQ2019-691 - CPHQ
public int getBroker(String p_certype,int p_branch,int p_certif,int p_policy )
    {
        int intIntermed = 0;
        Connection objCnn = null;
        CallableStatement objCstmt = null;
        ResultSet objRs = null;
        try
        {
                  objCnn = ConexionIFX.getConnection();
                  objCstmt = objCnn.prepareCall("{call prd_get_broker(?,?,?,?)}");            
                  objCstmt.setString(1, p_certype); 
                  objCstmt.setInt(2, p_branch); 
                  objCstmt.setInt(3, p_certif); 
                  objCstmt.setInt(4, p_policy); 
                  objRs = objCstmt.executeQuery();
                  if ( objRs.next() )
                  {
                    intIntermed = objRs.getInt(1);
                  }

                  System.out.println("Valor retorna:" + intIntermed);
                  
                  return intIntermed;  
        }
        catch(SQLException se)
        {
                  se.printStackTrace();
                  System.out.println("SQLExce ValidarCaso:" + se);
                  return -1;
        }
        catch(Exception e)
        {
                  System.out.println("Excep ValidarCaso:" + e);
                  return -1;
                  
        }
        finally
        {
              try
              {
                  if(objCstmt != null)
                      objCstmt.close();
                  if(objRs != null)
                      objRs.close();
                  if(objCnn != null)
                      objCnn.close();
              }
              catch(SQLException sqlexception)
              {
                  return -1;
              }
        }
    }
//FIN RQ2019-691 - CPHQ    

}  