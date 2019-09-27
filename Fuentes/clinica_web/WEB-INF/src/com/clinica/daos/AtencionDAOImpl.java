package com.clinica.daos;
import com.clinica.beans.Cobertura;
import com.clinica.utils.*;
import com.clinica.utils.coneccion.*;
import com.clinica.beans.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.StringTokenizer;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;

public class AtencionDAOImpl implements AtencionDAO
{

    public String getNombreClinica(BeanList lista, String codServer)
    {
      String sClinica = "";
      for(int i = 0; i < lista.size(); i++)
      {
        if( lista.getBean(i).getString("1").trim().equals(codServer.trim()))
        {
          sClinica =  lista.getBean(i).getString("6").trim();
          break;
        }
      }
      return sClinica;
    }
    public BeanList getClienteVT(String Num_Doc, String Tipo_per, String sCode) {
        Connection objCnn = null;
        CallableStatement objCstmt = null;
        ResultSet objRs = null;
        BeanList lista = new BeanList();
        try {
            objCnn = ConexionOracle.getConnectionVTime();
            objCstmt = objCnn.prepareCall("{call REAOVCLIENT(?,?,?,?)}");
            objCstmt.setInt(1, Tool.parseInt(Tipo_per));
            objCstmt.setString(2, Num_Doc);
            objCstmt.setString(3, sCode);
            objCstmt.registerOutParameter(4, OracleTypes.CURSOR);
            objCstmt.execute();            
            for (objRs = ((OracleCallableStatement)objCstmt).getCursor(4);
                 objRs.next(); lista.add(Tool.llenarRegistroCallVtime(objRs)));

            return lista;
        } catch (SQLException se) {
            se.printStackTrace();
            System.out.println("SQLExce lstCliente:" + se);
            return lista;
        } catch (Exception e) {
            System.out.println("Excep lstCliente:" + e);
            return lista;

        } finally {
            try {
                if (objCstmt != null)
                    objCstmt.close();
                if (objRs != null)
                    objRs.close();
                if (objCnn != null)
                    objCnn.close();
            } catch (SQLException sqlexception) {
                return lista;
            }
        }
    }
    
    /*PRT
     * Método que llama al Store Procedure REAOVCLIENT
     * para obtener los datos del titular
     * */
    public BeanList getTitularVT(String Num_Doc, String Tipo_per, String sCode) {
        Connection objCnn = null;
        CallableStatement objCstmt = null;
        ResultSet objRs = null;
        BeanList lista = new BeanList();
        try {
            objCnn = ConexionOracle.getConnectionVTime();
            objCstmt = objCnn.prepareCall("{call REAOVCLIENT(?,?,?,?)}");
            objCstmt.setInt(1, Tool.parseInt(Tipo_per));
            objCstmt.setString(2, Num_Doc);
            objCstmt.setString(3, sCode);
            objCstmt.registerOutParameter(4, OracleTypes.CURSOR);
            objCstmt.execute();            
            for (objRs = ((OracleCallableStatement)objCstmt).getCursor(4);
                 objRs.next(); lista.add(Tool.llenarRegistroCallVtime(objRs)));

            return lista;
        } catch (SQLException se) {
            se.printStackTrace();
            System.out.println("SQLExce lstTitular:" + se);
            return lista;
        } catch (Exception e) {
            System.out.println("Excep lstCliente:" + e);
            return lista;

        } finally {
            try {
                if (objCstmt != null)
                    objCstmt.close();
                if (objRs != null)
                    objRs.close();
                if (objCnn != null)
                    objCnn.close();
            } catch (SQLException sqlexception) {
                return lista;
            }
        }
    }
     
   //INI  
   //************ Store de busqueda por DNI,Nombre,Codigo Cliente_______Cambio QNET 28/12/11    
       public BeanList lstClienteFiltro(String strDNI,String strNombreApe,String strCodigo,String strTipo,String strClinica, int intCodBroker , int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                //objCstmt = objCnn.prepareCall("{call web000033(?,?,?,?,?,?)}");//Nuevo                
                objCstmt = objCnn.prepareCall("{call sp_dni_nom_cod_apple(?,?,?,?,?,?)}");//Nuevo
                objCstmt.setString(1, strDNI);
                objCstmt.setString(2, strNombreApe);                
                objCstmt.setString(3, strCodigo); 
                objCstmt.setString(4, strTipo); 
                objCstmt.setString(5, strClinica);
                objCstmt.setInt(6, intCodBroker);                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstClienteFiltro:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstClienteFiltro:" + e);
                return null;
     
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
                return null;
            }
      }

  }
  //FIN
  //************ Store de busqueda por DNI,Nombre,Codigo Cliente_______Cambio QNET 28/12/11
  public BeanList lstCliente(int intPoliza, int intCertif, String strClinica, int intCodBroker)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call web_asegurado2_apple(?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strClinica);
                objCstmt.setInt(4, intCodBroker);                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstCliente:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstCliente:" + e);
                return null;
                
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
                return null;
            }
      }

  }

  public BeanList lstCliente(String strNombre, String strClinica, int intCodBroker)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnectionEPS();
                objCstmt = objCnn.prepareCall("{call apple_nombre(?,?,?)}");
                objCstmt.setString(1, strNombre);
                objCstmt.setString(2, strClinica);                
                objCstmt.setInt(3, intCodBroker);                                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstCliente:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstCliente:" + e);
                return null;
                
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
                return null;
            }
      }

  }
  
  public Bean getCliente(int intPoliza, int intCertif, String strCodCliente, String strClinica, int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call apple_asex(?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strCodCliente);
                objCstmt.setString(4, strClinica);
                objCstmt.setInt(5, intRamo);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCliente:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getCliente:" + e);
                return null;
                
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
                return null;
            }
      }

  }
  //Metodo Apple para Prueba
  public Bean getClienteApple(int intPoliza, int intCertif, String strCodCliente, String strClinica, int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call apple_asex(?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strCodCliente);
                objCstmt.setString(4, strClinica);
                objCstmt.setInt(5, intRamo);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCliente:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getCliente:" + e);
                return null;
                
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
                return null;
            }
      }

  }
  
  public Bean getCliente_his(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strNroSolicitud, int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call eps_asex_his(?,?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strCodCliente);
                objCstmt.setString(4, strClinica);
                objCstmt.setString(5, strNroSolicitud);
                objCstmt.setInt(6, intRamo);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCliente_his:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getCliente_his:" + e);
                return null;
                
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
                return null;
            }
      }

  }
  
  public String getAutorizacion(int intPoliza, int intCertif, String strCodCliente, String strClinica, 
                                       int intCover, int intConceptoPago)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    String strReturn ="-1";
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call web_cre_claim(?,?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strCodCliente);
                objCstmt.setString(4, strClinica);
                objCstmt.setInt(5, intCover);
                objCstmt.setInt(6, intConceptoPago);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                    strReturn = Tool.getString(objRs.getString(1));
                }
                return strReturn;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getAutorizacion:" + se);
                return strReturn;
      }
    catch(Exception e)
      {
                System.out.println("Excep getAutorizacion:" + e);
                return strReturn;
                
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
                return strReturn;
            }
      }

  }

  public BeanList lstExclusion(int intRamo, int intPoliza, int intCertif, String strCodCliente, String strFecha)
  {
  
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call web_exclusion(?,?,?,?,?)}");
                objCstmt.setInt(1, intRamo);
                objCstmt.setInt(2, intPoliza);
                objCstmt.setInt(3, intCertif);
                objCstmt.setString(4, strCodCliente);
                objCstmt.setString(5, strFecha);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstExclusion:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstExclusion:" + e);
                return null;
                
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
                return null;
            }
      }

  }

  public BeanList lstCobertura(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado,int intRamo, int intCaso)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call apple_dedux(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, intProducto);
                objCstmt.setInt(2, intTariff);
                objCstmt.setInt(3, intCurrency);
                objCstmt.setInt(4, intRelation);
                objCstmt.setString(5, strSexo);
                objCstmt.setInt(6, intPoliza);
                objCstmt.setInt(7, intCertif);
                objCstmt.setString(8, strClinica);
                objCstmt.setString(9, strCodCliente);
                objCstmt.setInt(10, intEstado);
                objCstmt.setInt(11, 0);
                objCstmt.setInt(12, intRamo);
                objCstmt.setInt(13, intCaso);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstCobertura:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstCobertura:" + e);
                return null;
                
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
                return null;
            }
      }

  }

  // REQ 2011-0490 BIT/FMG
  public BeanList lstCobertura_his(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado, String strNroSolicitud, int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call apple_dedux_his(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, intProducto);
                objCstmt.setInt(2, intTariff);
                objCstmt.setInt(3, intCurrency);
                objCstmt.setInt(4, intRelation);
                objCstmt.setString(5, strSexo);
                objCstmt.setInt(6, intPoliza);
                objCstmt.setInt(7, intCertif);
                objCstmt.setString(8, strClinica);
                objCstmt.setString(9, strCodCliente);
                objCstmt.setInt(10, intEstado);
                objCstmt.setInt(11, 0);
                objCstmt.setString(12, strNroSolicitud);
                objCstmt.setInt(13, intRamo);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstCobertura:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstCobertura:" + e);
                return null;
                
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
                return null;
            }
      }

  }

public boolean insLogSiniestro(int intRamo,int intPoliza, int intCertif, String strCodCliente, 
                                        String strClinica, String strNroautoriza,
                                        Cobertura objCover, int intTipoSolicitud, String strClinicaSol)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    String strReturn ="";
    try
      {
            String sql = "insert into web_cli_log (branch, policy, certif, cover	, client, clinica," +
                         "destipoaten, siniestro, descover, despago, tipodedu, " +
                         "importededu, desdedu, descoaseguro, benemax, beneconsu, periodocarencia, " +
                         "tipoaten, fec_ocur, hora_ocur, diascuarto, tiposolicitud, gencover, clinica_sol) values " +
                         "("  + intRamo + "," + intPoliza + "," + intCertif + "," + objCover.getIntCover() + ",'" + 
                         strCodCliente + "','" + strClinica + "','" + objCover.getStrTipoAtencion() + "','" +
                         strNroautoriza + "','" + objCover.getStrNomCobertura() + "','" + objCover.getStrConceptoPago() + "','" +
                         objCover.getStrTipoDeducible()  + "','" + objCover.getStrImpDeducible()   + "','" + objCover.getStrDeducible() + "','" +
                         objCover.getStrCoaseguro() + "','" + objCover.getStrBeneficioMax() + "','" + objCover.getStrBeneficioCons() + "'," +
                         objCover.getIntPeridoCarencia()  + "," +  objCover.getIntTipoAtencion() + 
                         ", today, current hour to second," + objCover.getStrCantidad() + "," + intTipoSolicitud +  "," + objCover.getIntCoverGen() + ",'" + strClinicaSol + "')";
            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objPstmt.execute();
            return true;

      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insLogSiniestro:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep insLogSiniestro:" + e);
                return false;
                
      }
    finally
      {
        try
            {
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }

  public Bean getSiniestroLog(String strSiniestro)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean objBean = new Bean();
        String sql ="";
        try
        {
            sql = "select branch, policy, certif, cover	, client, clinica," +
                         "destipoaten, siniestro, descover, despago, tipodedu, " +
                         "importededu, desdedu, descoaseguro, benemax, beneconsu, periodocarencia, " +
                         "tipoaten, fec_ocur, hora_ocur, diascuarto " +
                         "from web_cli_log where siniestro = '" + strSiniestro + "'";
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                  objBean = Tool.llenarRegistroIfx(objRs, objPstmt);
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
    
  public BeanList getLstSiniestroLog(String strFechaIniSol, String strFechaFinSol, String strSiniestro)
  {     
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    int intSiniestro=0;
    int cantidadRegis = 0;
    String acabo = "no";
    try
      {
                
                
                if(strFechaIniSol == null || strFechaIniSol.equals(""))
                    strFechaIniSol="01/01/2006";
                if(strFechaFinSol == null || strFechaFinSol.equals(""))
                    strFechaFinSol="01/01/2050";
                if(strSiniestro == null || strSiniestro.equals(""))
                    intSiniestro=0;
                else
                    intSiniestro=Tool.parseInt(strSiniestro);
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcselwebclilog(?,?,?)}");
                objCstmt.setString(1,strFechaIniSol);
                objCstmt.setString(2,strFechaFinSol);
                objCstmt.setInt(3,intSiniestro);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                  cantidadRegis++;
                  if(cantidadRegis==73319)
                  {
                    acabo = "si";
                  }
                }
                  if(cantidadRegis==73319)
                  {
                    acabo = "si";
                  }
                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getLstSiniestroLog:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getLstSiniestroLog:" + e);
                return null;
                
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
                acabo = acabo + " - ";
                acabo = acabo + cantidadRegis;
               // return objList;    
            }
        catch(SQLException sqlexception)
            {
                return null;
            }
      }
//--      return objList;

  }
 
  //PARA TINTAYA SE FILTRAN LAS POLIZAS
  public BeanList getLstSiniestroLog(String strFechaIniSol, 
  String strFechaFinSol, String strSiniestro, String strClinica,ClinicaDAO clinica)
  {     
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    int intSiniestro=0;
    try
      {
                
                
                if(strFechaIniSol == null || strFechaIniSol.equals(""))
                    strFechaIniSol="01/01/2006";
                if(strFechaFinSol == null || strFechaFinSol.equals(""))
                    strFechaFinSol="01/01/2050";
                if(strSiniestro == null || strSiniestro.equals(""))
                    intSiniestro=0;
                else
                    intSiniestro=Tool.parseInt(strSiniestro);
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call prcselwebclilog(?,?,?)}");
                objCstmt.setString(1,strFechaIniSol);
                objCstmt.setString(2,strFechaFinSol);
                objCstmt.setInt(3,intSiniestro);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  Bean obj = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                  int policy = Integer.parseInt(obj.getString("2"));
                  int intBranch = Integer.parseInt(obj.getString("1")); // Variable agregada para el proyecto Apple
                  if(clinica.getPolClinica(strClinica,policy,intBranch))
                  {
                    objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                  }
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getLstSiniestroLog:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getLstSiniestroLog:" + e);
                return null;
                
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
                return null;
            }
      }

  }

  //Obtiene el monto consumido por una cobertura
  public double getMontoConsCover(int intPoliza, int intCertificado, String strStartDate,
                                      String strExpirDate, int intCover ,int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    double dblMontoCons = 0;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_cover_used_eps(?,?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertificado);
                objCstmt.setString(3, strStartDate);
                objCstmt.setString(4, strExpirDate);
                objCstmt.setInt(5, intCover);
                objCstmt.setInt(6, intRamo);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                    dblMontoCons = objRs.getDouble(1);
                }

                return dblMontoCons;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getMontoConsCover:" + se);
                return 0;
      }
    catch(Exception e)
      {
                System.out.println("Excep getMontoConsCover:" + e);
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
  
public int getEstadoCliente(int intPoliza, int intCertificado, int intRamo)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intEstado = -1;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_pend(?,?,?)}");
                //objCstmt.setInt(1, Constante.NRAMOASME);
                objCstmt.setInt(1, intRamo);
                objCstmt.setInt(2, intPoliza);
                objCstmt.setInt(3, intCertificado);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                    intEstado = objRs.getInt(1);
                }

                return intEstado;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getEstadoCliente:" + se);
                return -1;
      }
    catch(Exception e)
      {
                System.out.println("Excep getEstadoCliente:" + e);
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
  
  public int getCantUsoCobertura(int intPoliza, int  intCertificado, int intCover, 
                                     int intPeriodo, String strCodCliente, int intConceptoPago, int intTipoFreq)
  {     
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      int intReturn =-1;
      Bean objBean = null;
      int intCont = -1;
      try
      {    
          objCnn = ConexionIFX.getConnection();
          objCstmt = objCnn.prepareCall("{call sp_rea_cover_cli(?,?,?,?,?,?,?)}");
          objCstmt.setInt(1, intPoliza);
          objCstmt.setInt(2, intCertificado);
          objCstmt.setInt(3, intCover);
          objCstmt.setInt(4, intPeriodo);
          objCstmt.setString(5, strCodCliente);
          objCstmt.setInt(6, intConceptoPago);
          objCstmt.setInt(7, intTipoFreq);
          objRs = objCstmt.executeQuery();
          if(objRs.next())
          {
             objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
             intCont = Tool.parseInt(objBean.getString("1"));
          }
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCoberturaUsed:" + se);
                intCont = -2;
      }
    catch(Exception e)
      {
                e.printStackTrace();
                System.out.println("Excep getCoberturaUsed:" + e);
                intCont = -2;
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
                System.out.println("Excep getCoberturaUsed:" + sqlexception);
                intCont = -2;
            }
      }
      
      return intCont;
  }
  
   public int validaClienteVip(int intPoliza,int intCertificado)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int nRetorno = -2;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{ ? = call PKG_CONSULTA.F_VALIDA_CLIENTEVIP(?,?)}");
                wCstmt.registerOutParameter(1,4);
                wCstmt.setInt(2, intPoliza);
                wCstmt.setInt(3, intCertificado);
                wCstmt.execute();
                nRetorno= wCstmt.getInt(1);
                
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce validaClienteVip:" + se);
               
            }
            catch(Exception e)
            {
                System.out.println("Excep validaClienteVip:" + e);
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
                System.out.println("Excep validaClienteVip:" + sqlexception);
                sqlexception.printStackTrace();
            }
        }
        return nRetorno;
    }
    
    /*PRT
     * Query que permite mapear el parentesco desde el anexo 3 del AF2009-2010 
     * */
    public String getParentesco(int intCodParentesco) {
        ResultSet wRs = null;
        Connection wCon = null;
        Statement stmt = null;
        String strCodParentesco="";        
        BeanList lista = new BeanList();
        try {
            String sql = "select cod_parentesco from ptbl_equiv where cod_positiva='"+intCodParentesco+"'";
            wCon = ConexionOracle.getConnectionOracle();
            stmt = wCon.createStatement();
            wRs = stmt.executeQuery(sql);
            int ind = 0;
            while (wRs.next()) {
                lista.add(Tool.llenarRegistroCall(wRs));
                strCodParentesco=lista.getBean(ind).getString("COD_PARENTESCO");
            }
            return strCodParentesco;
        } catch (SQLException se) {
            se.printStackTrace();
            System.out.println("SQLExce GetParentesco: " + se);
            return strCodParentesco;
        } catch (Exception e) {
            System.out.println("Excep GetParentesco: " + e);
            return strCodParentesco;
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (wRs != null)
                    wRs.close();
                if (wCon != null)
                    wCon.close();
            } catch (SQLException sqlexception) {
              sqlexception.printStackTrace();
              return strCodParentesco;
            }
        }
        
    }    
    
    
    
   public BeanList lstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_table314(?,?,?)}");
                objCstmt.setInt(1, intUsercomp);
                objCstmt.setInt(2, intCompany);
                objCstmt.setInt(3, intCodigint);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstExclusion:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstExclusion:" + e);
                return null;
                
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
                return null;
            }
      }

  }    
    
    
   public BeanList lstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tab_am_ill_web(?,?,?)}");
                objCstmt.setInt(1, intUsercomp);
                objCstmt.setInt(2, intCompany);
                objCstmt.setInt(3, intType);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstExclusion:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstExclusion:" + e);
                return null;
                
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
                return null;
            }
      }

  }        
  
   public BeanList lstConceptoProducto(int intBranch,
                                              int intPolicy,
                                              int intPayConcep,
                                              int intModalidad,
                                              int intCover,
                                              int intTariff,
                                              String strEffecdate)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_prod_am_bi_web(?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, intBranch);
                objCstmt.setInt(2, intPolicy);
                objCstmt.setInt(3, intPayConcep);
                objCstmt.setInt(4, intModalidad);
                objCstmt.setInt(5, intCover);
                objCstmt.setInt(6, intTariff);
                objCstmt.setString(7, strEffecdate);
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstExclusion:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstExclusion:" + e);
                return null;
                
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
                return null;
            }
      }

  }   
  
  
  public BeanList getLstWebCliHist(int intNroSiniestro, 
                                          int intNroTransaccion,
                                          String strCodDiagnostico)
  {     
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    int intSiniestro=0;
    try
      {            
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_webcli_his(?,?,?)}");
                objCstmt.setInt(1,intNroSiniestro);
                objCstmt.setInt(2,intNroTransaccion);
                objCstmt.setString(3,strCodDiagnostico);                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getLstSiniestroLog:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getLstSiniestroLog:" + e);
                return null;
                
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
                return null;
            }
      }

  }  
  
  
  
  public Bean getCliente_bit(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strEffecDate)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call web_asex_bit(?,?,?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertif);
                objCstmt.setString(3, strCodCliente);
                objCstmt.setString(4, strClinica);
                objCstmt.setString(5, strEffecDate);                
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCliente:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getCliente:" + e);
                return null;
                
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
                return null;
            }
      }

  }  
  
  
  public BeanList lstMaestroDiagnosticos(int intUsercomp, int intCompany, String strIllness, String strIllnessDes, String strStatregt)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tab_am_ill(?,?,?,?,?)}");
                objCstmt.setInt(1, intUsercomp);
                objCstmt.setInt(2, intCompany);
                objCstmt.setString(3, strIllness);
                objCstmt.setString(4, strIllnessDes);
                objCstmt.setString(5, strStatregt);                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstExclusion:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstExclusion:" + e);
                return null;
                
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
                return null;
            }
      }

  }              
  
  
  public BeanList getLstExclusion(int intPoliza, int intCertif, String strCodCliente,AtencionDAO atencion,int intRamo)
  {
   
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
    
    
    
    public BeanList getLstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType,AtencionDAO atencion)
  {
   
      BeanList objLista = null;      
      BeanList objLstDiagDet = null;
      objLista = atencion.lstDiagnosticosDetalle(intUsercomp,intCompany,intType);      
      
      if (objLista!=null){
          objLstDiagDet = new BeanList();
          DiagnosticoDetalle objDiagDet = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
            strTrama = objLista.getBean(i).getString("1");
            stkTrama = new StringTokenizer(strTrama, "|");
            objDiagDet = new DiagnosticoDetalle();
            if (stkTrama.hasMoreTokens())              
              objDiagDet.setIntCodigo(Tool.parseInt(stkTrama.nextToken()));              
            if (stkTrama.hasMoreTokens())
              objDiagDet.setStrDescripcion(stkTrama.nextToken());
              
            objLstDiagDet.add(objDiagDet);    
            objDiagDet = null;
                    
          }
      }
    return objLstDiagDet;
  }    
    
   public BeanList getLstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint,AtencionDAO atencion)
  {
   
      BeanList objLista = null;      
      BeanList objLstDiagCab = null;
      objLista = atencion.lstDiagnosticosCabecera(intUsercomp,intCompany,intCodigint);      
      
      if (objLista!=null){
          objLstDiagCab = new BeanList();
          DiagnosticoCabecera objDiagCab = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
            strTrama = objLista.getBean(i).getString("1");
            stkTrama = new StringTokenizer(strTrama, "|");
            objDiagCab = new DiagnosticoCabecera();
            if (stkTrama.hasMoreTokens())              
              objDiagCab.setIntCodigo(Tool.parseInt(stkTrama.nextToken()));              
            if (stkTrama.hasMoreTokens())
              objDiagCab.setStrDescripcion(stkTrama.nextToken());
            if (stkTrama.hasMoreTokens())
              objDiagCab.setStrDescripcionCorta(stkTrama.nextToken());
    
            objLstDiagCab.add(objDiagCab);    
            objDiagCab = null;
                    
          }
      }
    return objLstDiagCab;
  }    
    
}