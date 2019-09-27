package com.clinica.utils;

import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;


public class TablaConfig 
{
  public TablaConfig()
  {
  }

  public static String getTablaConfig(String sKey)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        String sRetorno = "";
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{ ? = call PKG_TABLACONFIG.F_TABCONF_VALUE(?)}");
                wCstmt.registerOutParameter(1,OracleTypes.VARCHAR);
                wCstmt.setString(2, sKey);
                wCstmt.execute();
                sRetorno= wCstmt.getString(1);
                return sRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getTablaConfig:" + se);
                return "";
            }
            catch(Exception e)
            {
                System.out.println("Excep getTablaConfig:" + e);
                return "";
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
                System.out.println("Excep getTablaConfig:" + sqlexception);
                return "";
            }
        }
    }
}