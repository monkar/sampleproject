package com.clinica.daos;
import com.clinica.beans.*;
import com.clinica.utils.*;
import java.sql.*;

public class DiagnosticoDAOImpl implements DiagnosticoDAO
{
  public String obtenerDiagnostico(Connection objCnnIfx, String strNroSiniestro){      
      Connection objCnnIfx_aux = objCnnIfx;
      CallableStatement objCstmtIfx = null;
      ResultSet objRsIfx = null;      
      String strDiagnostico = "";
      
      try{
        if(strNroSiniestro == ""){
          strNroSiniestro = "0";
        }        
        objCstmtIfx = objCnnIfx.prepareCall("{call rea_diag_sin(?)}");
        objCstmtIfx.setInt(1, Tool.parseInt(strNroSiniestro));        
        objRsIfx = objCstmtIfx.executeQuery();
        
        if (objRsIfx.next()){
          strDiagnostico = objRsIfx.getString(1);
        }
      }
      catch(SQLException se){
        se.printStackTrace();
        System.out.println("SQLException ObtenerDiagnostico:" + se);        
      }
      catch(Exception e){
         e.printStackTrace();
        System.out.println("Exception ObtenerDiagnostico:" + e);        
      }
      finally{
        try{
          if(objRsIfx != null){
            objRsIfx.close();
          }
          if(objCstmtIfx != null){
            objCstmtIfx.close();
          }          
        }
        catch(SQLException sqlexception){
          return strDiagnostico;
        }
      }
      return strDiagnostico;
  }
}