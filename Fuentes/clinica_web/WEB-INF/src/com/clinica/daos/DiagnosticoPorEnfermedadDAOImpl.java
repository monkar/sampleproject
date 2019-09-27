package com.clinica.daos;

import com.clinica.beans.*;
import com.clinica.utils.Bean;
import com.clinica.utils.*;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.StringTokenizer;

public class DiagnosticoPorEnfermedadDAOImpl implements DiagnosticoPorEnfermedadDAO
{
  
  public BeanList valDiagnosticoPorAsegurado(String strCode, String strIllness){
  
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call valdiagbyinsured(?,?)}");
                objCstmt.setString(1, strCode);
                objCstmt.setString(2, strIllness);
                objRs = objCstmt.executeQuery();
                DiagnosticoPorEnfermedad objDiagnostico= null;
                while ( objRs.next() )
                {
                  objDiagnostico= new  DiagnosticoPorEnfermedad();
                  objDiagnostico.setStrIdIllness(objRs.getString(1));
                  objDiagnostico.setStrDescriptIllness(objRs.getString(2));
                  objList.add(objDiagnostico);
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
}