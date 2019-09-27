package com.clinica.utils;

import com.clinica.utils.coneccion.*;
import java.sql.*;
import oracle.jdbc.OracleCallableStatement;

public class Tabla
{
  public Tabla()
  {
  }

   public static BeanList lstProveedorIfx(String strDesc)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="select a.ten_server,a.code codigo,a.client,cliename[1,34] nombre,b.ruc, a.descript " +
                   " from tab_clinic a ,client b where b.code = a.client " +
                   " and a.usercomp = 1  and a.company = 1 " +
                   " and a.statregt = 1 and b.cliename matches '" + strDesc + "*'  order by nombre";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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
    
   public static BeanList lstTableQIfx(int intTable)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="select codigint,descript,codigext,short_des from table" + intTable + " where usercomp = 1 and company  = 1 and statregt = 1 order by 1";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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
  public static BeanList lstTableIfx(int intTabla)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList lstBean = new BeanList(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tables(?,?,?)}");
                objCstmt.setInt(1, intTabla);
                objCstmt.setInt(2, 0);
                objCstmt.setString(3, "1");
                objRs = objCstmt.executeQuery();
                while (objRs.next())
                {
                  lstBean.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }
                return lstBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstTableIfx:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstTableIfx:" + e);
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
  
  
  public static Bean Ruta_Imagenes_Asegurado(String strTipo,String strItem)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_devuelve_rutas(?,?)}");
                objCstmt.setString(1, strTipo);                
                objCstmt.setString(2, strItem); 
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getRutaFotos:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getRutaFotos:" + e);
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
  
    public static Bean Ruta_Imagenes_Asegurado_Tmp(String strTipo,String strItem)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_devuelve_rutas(?,?)}");
                objCstmt.setString(1, strTipo);                
                objCstmt.setString(2, strItem); 
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getRutaFotos:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getRutaFotos:" + e);
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
  
  public static Bean Ruta_Impresion_Asegurado(String strTipo,String strItem)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_devuelve_rutas(?,?)}");
                objCstmt.setString(1, strTipo);                
                objCstmt.setString(2, strItem); 
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getRutaFotos:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getRutaFotos:" + e);
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
  
   public static BeanList lstDiagnosticoIfx(String strDesc)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="select illness,descript from tab_am_ill where usercomp = 1 and company = 1 and descript matches '*" + strDesc + "*' and statregt = 1 order by descript";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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

   public static String getDiagnosticoIfx(String strCodigo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        String strDescript ="";
        String sql="select illness,descript from tab_am_ill where usercomp = 1 and company = 1 and illness = '" +  strCodigo + "' and statregt = 1";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 strDescript = objRs.getString("descript");
            }            
            return strDescript;
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
        return strDescript;
    }
    //Proyecto EPS
    public static String getMedicoIfx(String strCodigo,int consulta)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        String strDescript ="";
        String sql="";
        if(consulta == 1){
         sql="select descript from tab_profes where code = '" +  strCodigo + "'";
        }else if (consulta == 2){
         sql="select count(*) descript from tab_profes where code = '" +  strCodigo + "'";
        }
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 strDescript = objRs.getString("descript");
            }            
            return strDescript;
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
        return strDescript;
    } 
    //Proyecto EPS
    
  public static String getProvedorIfx(int intCodigo)
  {
      return getProvedorIfx(intCodigo, "nombre");
  }
  public static String getProvedorIfx(int intCodigo, String strCampo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        String strDescript ="";
        String sql="select a.ten_server,a.code codigo,a.client,cliename[1,34] nombre,b.ruc, a.descript " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and a.code =" + intCodigo + " and a.statregt = 1";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 strDescript = objRs.getString(strCampo);
            }            
            return strDescript;
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
        return strDescript;
    }  

  public static Bean getProvedorIfxServ(String strServer)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean bBean = new Bean();
        String sql="select a.ten_server,a.code codigo,a.client,cliename[1,34] nombre,b.ruc,a.id_group " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and a.ten_server = '" + strServer + "' and a.statregt = 1";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 bBean = Tool.llenarRegistroIfx(objRs, objPstmt);
            }            
            return bBean;
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
        return bBean;
    }  
    
  public static Bean reaTableIfx(int intTabla, int intCodigint)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tables(?,?,?)}");
                objCstmt.setInt(1, intTabla);
                objCstmt.setInt(2, intCodigint);
                objCstmt.setString(3, "1");
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce reaTableIfx:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep reaTableIfx:" + e);
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

  public static Bean reaTableQIfx(int intTabla, int intCodigint)
  {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean objBean = new Bean();
        String sql="select codigint,descript,codigext,short_des from table" + intTabla +                    
                   " where usercomp = 1 and company  = 1 and statregt = 1 " + 
                   " and codigint = " + intCodigint +
                   " order by 1";
        try
        {
            if (intCodigint==0)
              return objBean;
              
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objBean = Tool.llenarRegistro(objRs, objPstmt);
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
  
  
  public static Bean reaTableIfx(int intTabla, String strCodigExt)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    Bean objBean = new Bean(); 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tables_ext(?,?,?)}");
                objCstmt.setInt(1, intTabla);
                objCstmt.setString(2, strCodigExt);
                objCstmt.setString(3, "1");
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce reaTableIfx:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep reaTableIfx:" + e);
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

   public static BeanList lstPlanIfx(int intBranch, int intProduct, int intCurrency)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql= "select distinct a.modulec, t.descript " + 
                    " from gen_cover a, tab_modul t " + 
                    " where a.usercomp = 1 and a.company = 1 and a.branch = " + intBranch +
                    "      and a.product = " + intProduct +
                    "      and a.currency = " + intCurrency + 
                    "      and a.nulldate is null " + 
                    "      and a.modulec = t.modulec " + 
                    "      and a.statregt < 4 " + 
                    "      and t.usercomp = a.usercomp  " + 
                    "      and t.company = a.company  " + 
                    "      and t.branch = a.branch " + 
                    "      and t.product = a.product " + 
                    "      and t.nulldate is null " + 
                    " order by 2";

        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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

   public static BeanList lstCoberturaIfx(int intBranch, int intProduct, int intPlan, int intMoneda)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="select a.cover,b.descript[1,30], a.cacalfix from gen_cover a ,tab_gencov b " +
                   "where a.usercomp = 1 and a.company = 1 and branch ="  + intBranch +
                   " and a.product =" + intProduct + " and a.currency = " + intMoneda + " and a.nulldate is null " +
                   " and a.modulec = " + intPlan + " and a.statregt < 4 and b.usercomp = 1 " +
                   " and b.company = 1 and a.currency = b.currency and covergen = b.cover " +
                   " order by 2";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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
 public static Bean getRedIfx(int intBranch, int intProduct, int intPlan,
                              int intCobertura, int intModalidad, int intConcepto)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean bBean = new Bean();
        String sql="select ded_quanti, ded_amount, ded_percen, indem_rate from prod_am_bil " +
                   "where usercomp = 1 and company = 1 and branch = " + intBranch + 
                   " and product = " + intProduct + " and tariff = " + intPlan + 
                   " and cover = " + intCobertura + 
                   " and modalidad = " + intModalidad + 
                   " and pay_concep = " + intConcepto + 
                   " and nulldate is null";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 bBean = Tool.llenarRegistro(objRs, objPstmt);
            }            
             System.out.print(bBean);
            return bBean;
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
        return bBean;
    }
    
    public static Bean getProvedorIfxCode(int intCodigo)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean bBean = new Bean();
        String sql="select a.ten_server,a.code codigo,a.client,cliename[1,34] nombre,b.ruc " +
                   " from tab_clinic a ,client b where b.code = a.client and a.usercomp = 1  and a.company = 1 " +
                   " and a.code = " + intCodigo + " and a.statregt = 1";
        
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 bBean = Tool.llenarRegistroIfx(objRs, objPstmt);
            }            
            return bBean;
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
        return bBean;
    } 
    
    public static BeanList lstConceptoPagoIfx(int intCover)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        String sql="";
        if(intCover>0)
            sql=	"select  distinct p.cover, t1.short_des, t1.codigint from prod_am_bil p, table700 t1 " + 
                  "where p.usercomp = 1 and p.company = 1 and p.branch = 23  and " + 
                  "p.product = 32 and p.cover = " + intCover + " and p.modalidad  in (1,2) " + 
                  "and p.effecdate <= today and p.ded_type = 1 and " + 
                  "(p.nulldate is null or p.nulldate > today) and p.pay_concep = t1.codigint order by t1.short_des";
        else
            sql=	"select codigint,  short_des from table700 where usercomp = 1 and company = 1 order by short_des";
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;
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
    
    public static BeanList getListControl()
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
       
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLCONTROL_LIST(?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              lista.add(Tool.llenarRegistroCall(wRs));
            }
        }
        catch(SQLException se)
        {
            se.printStackTrace();
            System.out.println("SQLExce getListConfiguracion:" + se);
            return lista;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("Excep getListConfiguracion:" + e);
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
    
    //RQ2015-000750 Inicio
  public static Bean reaEmailAseg(String SClient)
  {
    Connection wCon = null;
    CallableStatement wCstmt = null;
    ResultSet wRs = null;
    Bean objBean = new Bean(); 
    try
      {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_AVISOGERENCIA.P_PTBLCLIENTNOTIFICA_LIST(?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setString(2, SClient);  
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              objBean = Tool.llenarRegistroCall(wRs);
            }
            return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce reaEmailAseg:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep reaEmailAseg:" + e);
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
    //RQ2015-000750 Fin
     public static BeanList lstTablaMotivo(String intTable)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
	String sql="SELECT IDMOTIVO, SDESCRIPT FROM  "+ intTable +"  WHERE NTYPE=1 AND NESTADO=1 order by 1";
       
        try
        {
            objCnn = ConexionOracle.getConnectionOracle();
	    objPstmt = objCnn.prepareStatement(sql);
	    objRs = objPstmt.executeQuery();
	    while(objRs.next())
            {
                 objLista.add(Tool.llenarRegistro(objRs, objPstmt));
            }            
            return objLista;

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
    public static Bean reaTablaMotivo(String intTabla, int intCodigint)
  {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean objBean = new Bean();
        String sql="SELECT IDMOTIVO, SDESCRIPT FROM  "+ intTabla +
                   " WHERE NTYPE=1 AND NESTADO=1 AND IDMOTIVO= " + intCodigint +
                   " order by 1";
        try
        {
            if (intCodigint==0)
              return objBean;
              
            objCnn = ConexionOracle.getConnectionOracle();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 objBean = Tool.llenarRegistro(objRs, objPstmt);
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
  
public static Bean reaDatosRechazo(int nClaim)
  {
    Connection wCon = null;
    CallableStatement wCstmt = null;
    ResultSet wRs = null;
    Bean objBean = new Bean(); 
    try
      {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CARTASRECHAZO.SP_SEL_CARTASRECHA(?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, nClaim);  
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              objBean = Tool.llenarRegistroCall(wRs);
            }
            return objBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce reaDatosRechazo:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep reaDatosRechazo:" + e);
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
//AGREGADO PARA EL PROYECTO EPS
public static BeanList lstTableIfxEPS(int intTabla)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList lstBean = new BeanList(); 
    try
      {
                objCnn = ConexionIFX.getConnectionEPS();
                objCstmt = objCnn.prepareCall("{call rea_tables(?,?,?)}");
                objCstmt.setInt(1, intTabla);
                objCstmt.setInt(2, 0);
                objCstmt.setString(3, "1");
                objRs = objCstmt.executeQuery();
                while (objRs.next())
                {
                  lstBean.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }
                return lstBean;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstTableIfx:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstTableIfx:" + e);
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
//AGREGADO PARA EL PROYECTO EPS
}