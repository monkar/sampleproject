package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleCallableStatement;
import java.sql.Types;

public class AlertaDAOImpl implements AlertaDAO
{
    public BeanList listAlerta(double dblMontoMaximo, double dblMontoMinimo)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLALERTA_LIST(?,?,?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setDouble(2, dblMontoMaximo);
            wCstmt.setDouble(3, dblMontoMinimo);
            wCstmt.setDouble(4, 999);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              lista.add(Tool.llenarRegistroCall(wRs));
            }
            
            if(lista.size()>0)
            {
                for(int i=0; i<lista.size(); i++)
                {
                    Bean auxBean = lista.getBean(i);
                }            
            }   
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println("SQLExce getListAlerta:" + se);
            return lista;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Excep getListAlerta:" + e);
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
        return lista;
    }
    
    public int insAlerta(int intAlerta, String sDescripcion, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLALERTA_INS(?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intAlerta);
            wCstmt.setString(3, sDescripcion);
            wCstmt.setDouble(4, dblMontoMinimo);
            wCstmt.setDouble(5, dblMontoMaximo);
            wCstmt.setInt(6, intEstado);
            wCstmt.setInt(7, intUsuarioReg);
            wCstmt.setString(8, strAction);
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
    
  public BeanList getlstAlerta()
  {
     Connection objCnn = null;
     CallableStatement objCstmt = null;  
     ResultSet objRs = null;
     BeanList list =  new BeanList();
      try
      {      
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLALERTA_LIST(?,?,?,?)}");
          objCstmt.registerOutParameter(1,-10);
          objCstmt.setDouble(2, 0);
          objCstmt.setDouble(3, 0);
          objCstmt.setInt(4, 1);
          objCstmt.execute();                
          objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
          
          while (objRs.next())
          {
             list.add(Tool.llenarRegistroCall(objRs));
          }                    
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getlstAlerta:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep getlstAlerta:" + e);
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
      return list;    
  }
 //RQ2015-000604 
   public BeanList listAlertaRechazo(double dblMontoMaximo,double dblMontoMinimo,String nEncargado,String nCargo)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.P_PTBLALERTARECHAZO_LIST(?,?,?,?,?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setDouble(2, dblMontoMaximo);
            wCstmt.setDouble(3, dblMontoMinimo);
            wCstmt.setString(4, nEncargado);
            wCstmt.setString(5, nCargo);
            wCstmt.setDouble(6, 999);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              lista.add(Tool.llenarRegistroCall(wRs));
            }
            
            if(lista.size()>0)
            {
                for(int i=0; i<lista.size(); i++)
                {
                    Bean auxBean = lista.getBean(i);
                }            
            }   
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println("SQLExce getListAlerta:" + se);
            return lista;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Excep getListAlerta:" + e);
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
        return lista;
    }
public int insAlertaRechazo(int intAlerta, String sDescripcion, String sCargo, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.P_PTBLALERTARECHAZO_INS(?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intAlerta);
            wCstmt.setString(3, sDescripcion);
            wCstmt.setString(4, sCargo);
            wCstmt.setDouble(5, dblMontoMinimo);
            wCstmt.setDouble(6, dblMontoMaximo);
            wCstmt.setInt(7, intEstado);
            wCstmt.setInt(8, intUsuarioReg);
            wCstmt.setString(9, strAction);
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
}