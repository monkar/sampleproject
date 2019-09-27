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

public class ClienteCronicoDAOImpl implements ClienteCronicoDAO
{
   public int esPacCronico (String strClient){     
   
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intEsPacCronico = -1;
   try
      {
         objCnn = ConexionIFX.getConnection();
         objCstmt = objCnn.prepareCall("{call espatientchronic(?)}");
         objCstmt.setString(1, strClient);
         objRs = objCstmt.executeQuery();
         if ( objRs.next() )
         {
            intEsPacCronico = objRs.getInt(1);
         }
         return intEsPacCronico;
      }
    catch(SQLException se)
      {
         se.printStackTrace();
      }
    catch(Exception exception)
      {
        exception.printStackTrace();
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
              return -1;
            }
      }
   
    return intEsPacCronico;
  }
  
  public BeanList lstEnfermedadCronicaPorCliente(String strClient)
    {
       Connection objCnn = null;
       CallableStatement objCstmt = null;
       ResultSet objRs = null;
       BeanList objList = new BeanList();
      
        try
        {
            objCnn = ConexionIFX.getConnection();
            objCstmt = objCnn.prepareCall("{call getchrobyinsured(?)}");
           // objCstmt.setString(1, "N0000419001");
            objCstmt.setString(1, strClient);
            System.out.println("strCliente"+strClient);
            objRs = objCstmt.executeQuery();
            EnfermedadCronica objEfermedadCronica = null;
            while ( objRs.next() )
            {
                  objEfermedadCronica = new EnfermedadCronica ();
                  objEfermedadCronica.setIntId_cro(objRs.getInt(1));
                  objEfermedadCronica.setStrDescript(objRs.getString(2));
                  objEfermedadCronica.setStrShortdescript(objRs.getString(3));
                  objEfermedadCronica.setFecEffecdate(objRs.getDate(4));
                  objList.add(objEfermedadCronica);                  
                  objEfermedadCronica = null;
            }
          return objList;
        }
        catch(SQLException se)
        {
            System.out.println("SQLException se");
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            System.out.println("exception");
            exception.printStackTrace();
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
            catch(SQLException sqlexception) { System.out.println("SQLException sqlexception"); }
        }
        return null;
    } 
  
   public BeanList lstEnfermedadCronica(String strClient)
    {
       Connection objCnn = null;
       CallableStatement objCstmt = null;
       ResultSet objRs = null;
       BeanList objList = new BeanList();
      
        try
        {
            objCnn = ConexionIFX.getConnection();
            objCstmt = objCnn.prepareCall("{call getcronic("+strClient+")}");
            //objCstmt.setString(1, "N0069916823");
           // objCstmt.setString(1, strClient);
            System.out.println("strCliente"+strClient);
            objRs = objCstmt.executeQuery();
            EnfermedadCronica objEfermedadCronica = null;
            while ( objRs.next() )
            {
                  objEfermedadCronica = new EnfermedadCronica ();
                  objEfermedadCronica.setIntId_cro(objRs.getInt(1));
                  objEfermedadCronica.setStrDescript(objRs.getString(2));
                  objEfermedadCronica.setStrState(objRs.getString(3));
                  objEfermedadCronica.setFecEffecdate(objRs.getDate(4));
                  objList.add(objEfermedadCronica);                  
                  objEfermedadCronica = null;
            }
          return objList;
        }
        catch(SQLException se)
        {
            System.out.println("SQLException se");
            se.printStackTrace();
        }
        catch(Exception exception)
        {
            System.out.println("exception");
            exception.printStackTrace();
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
            catch(SQLException sqlexception) { System.out.println("SQLException sqlexception"); }
        }
        return null;
    } 
  
  
}