package com.clinica.daos;

import com.clinica.beans.*;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Constante;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ClinicaDAOImpl implements ClinicaDAO
{

public BeanList lstClinica(int intIdUsuario)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objList = new BeanList();
        String sql ="";
        try
        {
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";            
            sql="select a.ten_server,a.code codigo,cliename[1,34] nombre,a.client,b.ruc, a.descript " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and ten_server[1]='S' and a.statregt = 1 order by nombre";            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while ( objRs.next() )
            {
                  objList.add(Tool.llenarRegistroIfx(objRs,objPstmt));
            }

            return objList;
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
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return objList;
    }  

    public BeanList lstClinicaAviso(int intIdUsuario)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objList = new BeanList();
        String sql ="";
        try
        {
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";            
            sql="select a.ten_server,a.code codigo,cliename[1,40] nombre,a.client,b.ruc, a.descript " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and ten_server[1]='S' and a.statregt = 1 order by nombre";            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while ( objRs.next() )
            {
                  objList.add(Tool.llenarRegistroIfx(objRs,objPstmt));
            }

            return objList;
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
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return objList;
    }  

   public Bean getClinica(String strCode)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean objBean = new Bean();
        String sql ="";
        try
        {
            //sql = "select distinct c.code, c.cliename from web_clinic_eq w, client c where c.code = w.client and w.web_server = '" + strCode + "'";
            sql="select a.client code, cliename[1,40] cliename " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and ten_server='" + strCode + "' and a.statregt = 1";            

            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                  objBean = Tool.llenarRegistroIfx(objRs, objPstmt);
            }
            return objBean;
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
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return null;
    }  
    
    public boolean getPolClinica(String strWerServer, int intPoliza, int codRamo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        boolean blRet = false;
        String sql ="";
        //Inicio RQ2018-1627-CPHQ
        CallableStatement objCstmt = null;
        int var_poliza = 0;
        int product = 0;
        int sub_product = 0;
        //Fin RQ2018-1627-CPHQ
        try
        {
            objCnn = ConexionIFX.getConnection();
            
            //Inicio RQ2018-1627-CPHQ
            objCstmt = objCnn.prepareCall("{call get_polclinic_valid(?,?,?,?,?,?,?,?,?,?,?)}");
            objCstmt.setInt(1, codRamo);
            objCstmt.setInt(2, intPoliza);
            objCstmt.setInt(3, 0);
            objCstmt.setString(4, strWerServer);  
            objCstmt.setString(5, null); 
            objCstmt.setString(6, null); 
            objCstmt.setString(7, null); 
            objCstmt.setString(8, null); 
            objCstmt.setString(9, null);             
            objCstmt.setString(10, null);  
            objCstmt.setInt(11, 1);
            objRs = objCstmt.executeQuery();
            while ( objRs.next() )
            {
                var_poliza = objRs.getInt(1);
                product  = objRs.getInt(2);
                sub_product = objRs.getInt(3);
            }            
                        
            sql = "select count(*) from tab_clinic t, pol_clinic p  " +
                  " where  p.usercomp = 1 and " +
                  " p.company = 1 and " +
                  " p.certype = '2' and " +
                  //" p.branch = " + Constante.NRAMOASME + " and " + Modificado para proyecto Apple
                  " p.branch = " + codRamo + " and " +
                  " p.product  = " + product + " and " +
                  " p.sub_product = " + sub_product + " and " +
                  " p.policy=" + var_poliza + " and " +
                  " p.clinic_cod = t.code and " +
                  " t.ten_server = '" + strWerServer + "'";
            //Fin RQ2018-1627-CPHQ
                                                  
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 int ncount  = objRs.getInt(1);
                 blRet = (ncount>0?true:false);
            }
            return blRet;
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
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return blRet;
    }
    
    public BeanList lstClinicaIfx(String strDesc)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objList = new BeanList();
        String sql ="";
        try
        {
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";
            //sql = "select distinct web_server,client, c.cliename from web_clinic_eq w, client c where c.code = w.client and level = 0 order by cliename";            
            sql="select a.ten_server,a.code codigo,cliename[1,34] nombre,a.client,b.ruc " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and ten_server[1]='S' and a.statregt = 1 and cliename like '" + strDesc + "%' order by nombre";            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while ( objRs.next() )
            {
                  objList.add(Tool.llenarRegistroIfx(objRs,objPstmt));
            }

            return objList;
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
                if(objRs != null)
                    objRs.close();
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception) { }
        }
        return objList;
    }      
    
    
 public BeanList lstClinicaWeb(int intUsercomp,
                                      int intCompany,
                                      String strTenserver,
                                      String strStatregt,
                                      String strDescriptCliename)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tab_clinic_web(?,?,?,?,?)}");
                objCstmt.setInt(1, intUsercomp);
                objCstmt.setInt(2, intCompany);
                objCstmt.setString(3, strTenserver);
                objCstmt.setString(4, strStatregt);
                objCstmt.setString(5, strDescriptCliename);                
                objRs = objCstmt.executeQuery();
                while ( objRs.next() )
                {
                  objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
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