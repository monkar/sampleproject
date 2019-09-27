package com.clinica.daos;
import com.clinica.beans.ParamNuevaMarca;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleCallableStatement;
import java.sql.Types;

public class ParamNuevaMarcaDAOImpl implements ParamNuevaMarcaDAO
{
  public ParamNuevaMarcaDAOImpl()
  {
  }
  public ParamNuevaMarca getUrlsLogo(int idApp)
  {
      ParamNuevaMarca oParamNuevaMarca = new ParamNuevaMarca();
      oParamNuevaMarca.setNIdApp(idApp);
      oParamNuevaMarca.setNIdFlag(-1);
      
      ResultSet wRs = null;
      Connection wCon = null;
      CallableStatement wCstmt = null;
         
      try
      {            
            wCon = ConexionOracle.getConnectionVTime();
            wCstmt = wCon.prepareCall("{call INSUDB.OBTENER_FLAG_NUEVAMARCA(?,?,?,?)}");    
            wCstmt.setInt(1, idApp);
            wCstmt.registerOutParameter(2, 12);
            wCstmt.registerOutParameter(3, 12);
            wCstmt.registerOutParameter(4, 4);            
            wCstmt.execute();
            oParamNuevaMarca.setSUrlAnterior(wCstmt.getString(2));
            oParamNuevaMarca.setSUrlNew(wCstmt.getString(3));
            oParamNuevaMarca.setNIdFlag(wCstmt.getInt(4));
            return oParamNuevaMarca;
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
      return oParamNuevaMarca;
  }
}