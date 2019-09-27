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

public class CorreoDAOImpl implements CorreoDAO
{
  public BeanList listCorreo(int intZona, int intAlerta)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLCORREO_LIST(?,?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, intZona);
            wCstmt.setInt(3, intAlerta);
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
            System.out.println("SQLExce listCorreo:" + se);
            return lista;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Excep listCorreo:" + e);
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
    
    public int insCorreo(int intSec, int intZona, int intAlerta, String sCargo, String sApellido, String sNombre, String sEmail, int intEstado, int intUserReg, String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLCORREO_INS(?,?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intAlerta);
            wCstmt.setInt(3, intZona);
            wCstmt.setInt(4, intSec);
            wCstmt.setString(5, sCargo);
            wCstmt.setString(6, sNombre);
            wCstmt.setString(7, sApellido);
            wCstmt.setString(8, sEmail);
            wCstmt.setInt(9, intEstado);
            wCstmt.setInt(10, intUserReg);
            wCstmt.setString(11, strAction);
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
    
    public int GrabaCorreoAvisoGerencia(int nIdCorreo, String sCorreo, int intUserReg, String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLCORREOAVISOGERENCIA_INS(?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, nIdCorreo);
            wCstmt.setString(3, sCorreo);
            wCstmt.setInt(4, intUserReg);
            wCstmt.setString(5, strAction);
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
    
    public int ProcesarEmailAsegurado(String sClient, String sCorreo, int intUserReg)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLCLIENTNOTIFICA_INS(?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setString(2, sClient);
            wCstmt.setString(3, sCorreo);
            wCstmt.setString(4, "");
            wCstmt.setInt(5, intUserReg);
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
 public int GrabaCopiaCorreoRechazo(int nIdCorreo, String sCorreo, int intUserReg, String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.P_PTBLCOPIARECHAZO_INS(?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, nIdCorreo);
            wCstmt.setString(3, sCorreo);
            wCstmt.setInt(4, intUserReg);
            wCstmt.setString(5, strAction);
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