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

public class ZonaOficinaDAOImpl implements ZonaOficinaDAO
{
    public BeanList listZonaOficina(int intZona, int intOficina)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLZONAOFICINA_LIST(?,?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, intZona);
            wCstmt.setInt(3, intOficina);
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
            System.out.println("SQLExce getListZonaOficina:" + se);
            return lista;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Excep getListZonaOficina:" + e);
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
    
    public int insZonaOficina(int intZona, int intOficina, int intUsuarioReg, int intEstado, String strAction)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLZONAOFICINA_INS(?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intZona);
            wCstmt.setInt(3, intOficina);
            wCstmt.setInt(4, intUsuarioReg);
            wCstmt.setInt(5, intEstado);
            wCstmt.setString(6, strAction);
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