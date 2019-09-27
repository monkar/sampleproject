package com.clinica.daos;
import com.clinica.beans.AvisoRechazo;
import com.clinica.beans.Firma;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;

import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleCallableStatement;
import java.sql.Types;
import oracle.jdbc.OracleTypes;
//import oracle.sql.BLOB;

public class AlertaRechazoDAOImpl implements AlertaRechazoDAO
{

    public Firma getFirmaBin(double dMontoCarta)
  {
   Connection objCnn = null;
   CallableStatement objCstmt = null;   
     Firma firma = new Firma();
     byte[][] byFirmas ={null, null};
    try
    {
                objCnn = ConexionOracle.getConnectionOracle();
                objCstmt = objCnn.prepareCall("{call PKG_CARTASRECHAZO.P_FIRMARECHAZO_GET(?,?,?,?,?)}");
                objCstmt.setDouble(1,dMontoCarta);                                
                objCstmt.registerOutParameter(2, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(3, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(4, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(5, OracleTypes.VARCHAR);
                objCstmt.execute();
                            

                String[] nombres = {objCstmt.getString(2),objCstmt.getString(3)};
                String[] cargos = {objCstmt.getString(4),objCstmt.getString(5)};
                firma.setStrNombres(nombres);
                firma.setStrCargos(cargos);
                int c = -1;                

             firma.setBFirmas(byFirmas);
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getFirmaBin:" + se);
      }
      catch(Exception e)
      {
                System.out.println("Excep getFirmaBin:" + e);
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }
   return firma;
  }


 
  public Firma getFirma(int intTipoSolicitud, int intCodOficina)
  {
   Connection objCnn = null;
   CallableStatement objCstmt = null;   
   Firma firma = new Firma();
    try
    {
                objCnn = ConexionOracle.getConnectionOracle();
                objCstmt = objCnn.prepareCall("{call PKG_FIRMABIN.P_FIRMA_GET(?,?,?,?)}");
                objCstmt.setInt(1,intTipoSolicitud);
                objCstmt.setInt(2,intCodOficina);
                objCstmt.registerOutParameter(3, OracleTypes.NUMBER);
                objCstmt.registerOutParameter(4, OracleTypes.NUMBER);
                objCstmt.execute();
                 
                int[] intId= {objCstmt.getInt(3),objCstmt.getInt(4)};
                
                firma.set_intIdUsuario(intId);

      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getFirmaBin:" + se);
      }
      catch(Exception e)
      {
                System.out.println("Excep getFirmaBin:" + e);
      }
      finally
      {
            try
            {
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }
      
      return firma;
   
  }
  
   public AvisoRechazo getDatosFirmaRechazo(double montoRechazo)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        AvisoRechazo objFirmaRechazo = new AvisoRechazo();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.P_FIRMARECHAZO_GET(?,?)}");                
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setDouble(2, montoRechazo);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                if(wRs.next())
                {
                   objFirmaRechazo.setSNombre1(wRs.getString("NENCARGADO1"));                   
                   objFirmaRechazo.setSCargo1(wRs.getString("NCARGO1"));                   
                   objFirmaRechazo.setNIdSta1(wRs.getInt("STA1"));
                   objFirmaRechazo.setSNombre2(wRs.getString("NENCARGADO2"));
                   objFirmaRechazo.setSCargo2(wRs.getString("NCARGO2"));
                   objFirmaRechazo.setNIdSta2(wRs.getInt("STA2"));

                }
                return objFirmaRechazo;
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

}