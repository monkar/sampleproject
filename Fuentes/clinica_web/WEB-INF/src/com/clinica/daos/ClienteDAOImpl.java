package com.clinica.daos;

import com.clinica.beans.Cliente;
import com.clinica.utils.Bean;
import com.clinica.utils.*;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.StringTokenizer;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;

public class ClienteDAOImpl implements ClienteDAO
{

public String getClientInpDate(String pcode)
  {
    
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        String resultado = "";
        
        try
        {
            try
            {
                wCon = ConexionIFX.getConnection();
                wCstmt = wCon.prepareCall("{call sp_inpdate_cli(?)}");
                wCstmt.setString(1, pcode);
                wRs = wCstmt.executeQuery();
                if(wRs.next())
                {
                    resultado = wRs.getString(1);
                    
                }
                return resultado;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getClientInpDate:" + se);
                return "";
                
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep getClientInpDate:" + e);
                return "";
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
                System.out.println("SQLExce getClientInpDate:" + sqlexception);
            }
        }
  }
  
   public boolean getCertifVig(int intPoliza, int intCertif , int intRamo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        boolean blRet = false;
        String sql ="";
        try
        {
            sql = "select count(*) from health p  " +
                  " where  p.usercomp = 1 and " +
                  " p.company = 1 and " +
                  " p.certype = '2' and " +
                  //" p.branch = " + Constante.NRAMOASME + " and " +
                  " p.branch = " + intRamo + " and " + // Agregado campo Ramo para APple
                  " p.policy = " + intPoliza + " and " +
                  "p.certif = " + intCertif  + " and " +
                  //"p.effecdate < today and " +
                  // JCAC
                  "(p.nulldate is null or p.nulldate > today )  and " +
                  "p.expirdat >today";
                  
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                  int ncount  = objRs.getInt(1);
                  blRet = (ncount>0?true:false);
            }
            return blRet;
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
        return blRet;
    }  

//INI
//***** Validar Cliente XSTRATA - Cambio QNET 28/12/11
public boolean getXstrata(int intPoliza)
    {
     ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        boolean blRet = false;
        String sql ="";
        try
        {
            
            //System.out.println(intPoliza);
            sql = "select count(*) from client a " +
             "inner join policy b " +
             "on a.code = b.titularc " +
             "where a.cliename LIKE 'XSTRATA%' " +
             "and b.branch = 23 and " +
             "policy = " + intPoliza ;
              //    System.out.println(sql);
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                  int ncount  = objRs.getInt(1);
                  blRet = (ncount>0?true:false);
            }
            return blRet;
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
        return blRet;
    }  
    
//FIN

public Cliente setCliente(Bean objAtencion, String strCodCliente)
  {
              int intCantExcl = 0;
              
              Cliente cliente = new Cliente();
              
              if (objAtencion!=null){
                String strTrama = "";
                StringTokenizer stkTrama = null;
                  strTrama = objAtencion.getString("1");
                  stkTrama = new StringTokenizer(strTrama, "|");
                  cliente.setStrCodigo(strCodCliente);
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrNombreAseg(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrNombreTitular(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecNac(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrCodExtSexo(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntPoliza(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCertificado(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCodPlan(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrContratante(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecFinVigencia(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrParentesco(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCodEstado(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecCese(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCodMoneda(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecIngreso(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrEstado(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntProducto(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrPlan(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCodParentesco(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntIndExcl(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    intCantExcl = Tool.parseInt(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecFinCarencia(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntDiasCarencia(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntFlgObserv(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrCodTitular(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrFecInicioVigencia(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntFlgRenov(Tool.parseInt(stkTrama.nextToken()));
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntCodBrokerInx(Tool.parseInt(stkTrama.nextToken()));
                  // AVM : variable para la continuidad es el campo continuity
                  if (stkTrama.hasMoreTokens())
                    cliente.setStrContinuidadInx(stkTrama.nextToken());
                  if (stkTrama.hasMoreTokens())
                    cliente.setIntRamo(Tool.parseInt(stkTrama.nextToken()));
  
                  Bean objTable = Tabla.reaTableIfx(11,cliente.getIntCodMoneda());
                  if (objTable != null)
                    cliente.setStrMoneda(objTable.getString("4"));

                  objTable = Tabla.reaTableIfx(18,cliente.getStrCodExtSexo());                    
                  if (objTable != null){
                    cliente.setStrSexo(objTable.getString("4"));
                  }
                  
                  //RQ2015-000750 Inicio
                  objTable = Tabla.reaEmailAseg(cliente.getStrCodigo());
                  if (objTable != null){
                    cliente.setStrEmail(objTable.getString("SCORREO"));
                  }
                  //RQ2015-000750 Fin
                  
                  //***Cambios 12/12/2011-Definir ruta de imagenes
                  objTable = Tabla.Ruta_Imagenes_Asegurado("ruta_servidor","1");   
                  if (objTable != null){
                    cliente.setStrRuta_Server_D(objTable.getString("1"));
                    }                                      
                    
                  objTable = Tabla.Ruta_Impresion_Asegurado("ruta_servidor","2");   
                  if (objTable != null){
                    cliente.setStrRuta_Server_I(objTable.getString("1"));
                    }  
                    
                  objTable = Tabla.Ruta_Imagenes_Asegurado_Tmp("ruta_servidor","3");   
                  if (objTable != null){
                    cliente.setStrRuta_Server_Tmp(objTable.getString("1"));
                    }                     
                  
              }
         return cliente;
  }


 public Cliente getCliente(String strCodigo)
 {    
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int resultado = 0;
            Cliente cliente = new Cliente();
        try
        {
            try
            {   
                wCon = ConexionIFX.getConnection();
                wCstmt = wCon.prepareCall("{call sp_rea_client_det(?,?,?)}");
                wCstmt.setInt(1, 0);
                wCstmt.setString(2, "");
                wCstmt.setString(3, strCodigo);
                wRs = wCstmt.executeQuery();
                if(wRs.next())
                {
                    resultado = Tool.parseInt(wRs.getString(1));
                    if(resultado==0)
                    {
                        cliente.setStrDNI(wRs.getString(8));
                        cliente.setStrDireccion(wRs.getString(12));
                        cliente.setStrTelefono(wRs.getString(14));
                    }            
                }
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getTitularInfo:" + se);
                
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep getTitularInfo:" + e);
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
                System.out.println("SQLExce getTitularInfo:" + sqlexception);
            }
        }
        return cliente;
    }

//INICIO BIT FLOPEZ RQ2013-000400 , obtiene flag de cliente Vigente(0), No Vigente(1)
    public String getClienteVigente(int nUsercomp,int ncompany,String sCertype, int nBranch,int nPolicy,int nCertif,String sEffecdate)
    { 
      
    
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        String resultado = "";
        
        try
        {
            try
            {
                wCon = ConexionIFX.getConnection();
                wCstmt = wCon.prepareCall("{call valpolicertblock(?,?,?,?,?,?,?)}");
                wCstmt.setInt(1, nUsercomp);
                wCstmt.setInt(2, ncompany);
                wCstmt.setString(3, sCertype);
                wCstmt.setInt(4, nBranch);
                wCstmt.setInt(5, nPolicy);
                wCstmt.setInt(6, nCertif);
                wCstmt.setString(7, sEffecdate);
                wRs = wCstmt.executeQuery();
                if(wRs.next())
                {
                    resultado = (String)wRs.getString(1);
                    System.out.println(" valpolicertblock =" + resultado);
                    
                }
                return resultado;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce valpolicertblock:" + se);
                return "";
                
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep valpolicertblock:" + e);
                return "";
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
                System.out.println("SQLExce valpolicertblock:" + sqlexception);
            }
        }
    }

//FIN  BIT FLOPEZ RQ2013-000400
public Cliente getClienteDir(String strCodigo)
  {
        
        ResultSet wRs = null;
        Connection wConOrac = null;
        PreparedStatement wCstmt = null;
        
        ResultSet wRs2 = null;
        Connection wConOrac2 = null;
        CallableStatement wCstmt2 = null;        
        String sql="";        
        String valorConfig = "";
        int resultado = 0;
            Cliente cliente = new Cliente();
             BeanList objLista = new BeanList();
        try
        {
            try
            {   
            
                sql = "SELECT SVALOR FROM USRWCLEPS_APP.TABLACONFIG WHERE SKEY= 'ADDRESS_TYPE'";
                wConOrac = ConexionOracle.getConnectionOracle();
                wCstmt = wConOrac.prepareStatement(sql);               
                wRs = wCstmt.executeQuery();
                if(wRs.next())
                {   
                    //String tipoaddress= 
                    cliente.setStrRuta_Server_I(wRs.getString("SVALOR"));                                                    
                }
                    //int parametro = objLista.get(0);
                    
                    wConOrac2 = ConexionOracle.getConnectionVTime();
                    wCstmt2 = wConOrac2.prepareCall("{call PKG_CARTAS_RECHAZO.DIRECCIONCLIENT_CR(?,?,?)}");
                    wCstmt2.registerOutParameter(1, -10);
                    wCstmt2.setString(2, strCodigo);                    
                    wCstmt2.setString(3, cliente.getStrRuta_Server_I());                                
                    wCstmt2.execute();
                    wRs2 = ((OracleCallableStatement)wCstmt2).getCursor(1);
                   
                if(wRs2.next())
                {    
                    cliente.setStrDireccion(wRs2.getString("SDIRECCION"));
                }
                
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getTitularInfo:" + se);
                
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep getTitularInfo:" + e);
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
                if(wConOrac != null)
                    wConOrac.close();
                if(wCstmt2 != null)
                    wCstmt.close();
                if(wRs2 != null)
                    wRs.close();
                if(wConOrac2 != null)
                    wConOrac.close();
            }
            catch(SQLException sqlexception)
            {
                sqlexception.printStackTrace();
                System.out.println("SQLExce getTitularInfo:" + sqlexception);
            }
        }
        return cliente;
  }

}