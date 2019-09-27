package com.clinica.daos;
import com.clinica.utils.BeanList;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.StringTokenizer;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;
import com.clinica.beans.*;



public class RolDAOImpl implements RolDAO{

    public BeanList getLstRol()
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lstListado = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_SEGURIDAD.P_ROL_LIST(?)}");
                wCstmt.registerOutParameter(1, -10); 
                wCstmt.execute();      
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);                
                while(wRs.next()){
                    lstListado.add(Tool.llenarRegistroCall(wRs));
                }                            
                return lstListado;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstRolModulo:" + se);               
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstRolModulo:" + e);
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

  public BeanList lstRolJer(int intIdRol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lstListado = new BeanList();
        //Rol objRol = null;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLROL_LIST(?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intIdRol);  
                wCstmt.execute();      
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);                
                while(wRs.next()){
                    /*objRol = new Rol();
                    objRol.setNIDROL(wRs.getInt("NIDROL"));
                    objRol.setNIDROL_SUP(wRs.getInt("NIDROL_SUPERIOR"));
                    objRol.setNIDROL_SUP2(wRs.getInt("NIDROL_SUPERIOR2"));
                    objRol.setSTIPO(wRs.getString("STIPO"));
                    objRol.setNMONTOMAXIOMO(wRs.getInt("NMONTOMAXIMO"));
                    lstListado.add(objRol);*/
                    //objRol = null;
                    lstListado.add(Tool.llenarRegistroCall(wRs));
                }                            
                return lstListado;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstRol:" + se);               
                return lstListado;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstRol:" + e);
            }            
            return lstListado;
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
                return lstListado;
            }
        }
    }

   public double getRangoRol(int intIdRol)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        double nRetorno = -1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{ ? = call PKG_CONSULTA.F_RANGO_ROL(?)}");
                wCstmt.registerOutParameter(1,4);
                wCstmt.setInt(2, intIdRol);
                wCstmt.execute();
                nRetorno= wCstmt.getInt(1);
                return nRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getRangoRol:" + se);
                return -2;
            }
            catch(Exception e)
            {
                System.out.println("Excep getRangoRol:" + e);
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
                System.out.println("Excep getRangoRol:" + sqlexception);
                return -2;
            }
        }
    }

   public int valHoraAten()
   {
    return valHoraAten(0);
   }

   public int valHoraAten(int intCodOficina)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int nRetorno = -1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{ ? = call PKG_CONSULTA.F_VALHORATEN(?)}");
                wCstmt.registerOutParameter(1,4);
                wCstmt.setInt(2, intCodOficina);
                wCstmt.execute();
                nRetorno= wCstmt.getInt(1);
                return nRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce valHoraAten:" + se);
                return -2;
            }
            catch(Exception e)
            {
                System.out.println("Excep valHoraAten:" + e);
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
                System.out.println("Excep getRangoRol:" + sqlexception);
                return -2;
            }
        }
    }  
    
    public BeanList getLstRolModulo(int intTipo, int intIdRol)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lstListado = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_REL(?,?,?)}");
                wCstmt.setInt(1, intIdRol);     
                wCstmt.setInt(2, intTipo);     
                wCstmt.registerOutParameter(3, -10);                
                wCstmt.execute();      
                wRs = ((OracleCallableStatement)wCstmt).getCursor(3);                
                while(wRs.next()){
                    lstListado.add(Tool.llenarRegistroCall(wRs));
                }                            
                return lstListado;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstRolModulo:" + se);               
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstRolModulo:" + e);
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
    
    
    public int updModuloRol(String strModulos , int intIdRol, int intIdUser)
    {
        Connection objCnn = null;
        CallableStatement objCstmt = null; 
        PreparedStatement wStmt = null;
        ResultSet objRs = null;
        BeanList lista = new BeanList();
        
      
        int resultado = -1;
        try
        {
            objCnn =  ConexionOracle.getConnectionOracle();
            
            objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_DEL(?)}"); 		  			
            objCstmt.setInt(1, intIdRol);
            objCstmt.execute();
           
            StringTokenizer tkDatos = new StringTokenizer(strModulos, "|"); 
            int res = -1;
            while(tkDatos.hasMoreTokens())
            {
                int intIdModulo = Tool.parseInt(tkDatos.nextToken());
                
                
                objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_INS (?,?,?,?)}"); 		  			
                objCstmt.setInt(1, intIdRol);
                objCstmt.setInt(2, intIdModulo);
                objCstmt.setInt(3, intIdUser);
                objCstmt.registerOutParameter(4, Types.INTEGER);
                objCstmt.execute();
                res =  objCstmt.getInt(4);
            }
            return res;

        }
        catch(SQLException se)
        {
                  se.printStackTrace();
                  System.out.println("SQLExce updModuloRol:" + se);
                  return -1;
        }
        catch(Exception e)
        {
                  System.out.println("Excep updModuloRol:" + e);
                  return -1;
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
              }
        } 
        
    }
}