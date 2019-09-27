package com.clinica.daos;

import com.clinica.utils.coneccion.*;
import com.clinica.beans.Firma;
import com.clinica.utils.*;
import java.sql.*;
import oracle.jdbc.driver.*;
//import oracle.jdbc.driver.OracleTypes;
import oracle.jdbc.OracleTypes;
//import oracle.sql.BLOB;

public class FirmaDAOImpl implements FirmaDAO
{

 public Firma getFirmaBin(int intIdUsuFirma1, int intIdUsuFirma2, int IntRamo)
  {
   Connection objCnn = null;
   CallableStatement objCstmt = null;   
     Firma firma = new Firma();
     byte[][] byFirmas ={null, null};
    try
    {
                objCnn = ConexionOracle.getConnectionOracle();
                objCstmt = objCnn.prepareCall("{call PKG_FIRMABIN.P_FIRMABIN_GET(?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1,intIdUsuFirma1);
                objCstmt.setInt(2,intIdUsuFirma2);
                objCstmt.setInt(3,IntRamo);
                objCstmt.registerOutParameter(4, OracleTypes.BLOB);
                objCstmt.registerOutParameter(5, OracleTypes.BLOB);
                objCstmt.registerOutParameter(6, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(7, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(8, OracleTypes.VARCHAR);
                objCstmt.registerOutParameter(9, OracleTypes.VARCHAR);
                objCstmt.execute();
                            
                Blob blbFirma1 = (Blob) objCstmt.getBlob(4);
                Blob blbFirma2 = (Blob) objCstmt.getBlob(5);
                String[] nombres = {objCstmt.getString(6),objCstmt.getString(7)};
                String[] cargos = {objCstmt.getString(8),objCstmt.getString(9)};
                firma.setStrNombres(nombres);
                firma.setStrCargos(cargos);
                int c = -1;
                
                if (blbFirma1 != null)
                {
                  c = (int)blbFirma1.length();
                  byFirmas[0] = blbFirma1.getBytes(1, c);
                }
                else
                {
                  byFirmas[0] = null;
                }
                
                if (blbFirma2 != null)
                {
                  c = (int)blbFirma2.length();
                  byFirmas[1] = blbFirma2.getBytes(1, c);
                }
                else
                {
                  byFirmas[1] = null;
                }

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

}