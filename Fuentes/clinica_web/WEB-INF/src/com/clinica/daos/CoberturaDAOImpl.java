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

public class CoberturaDAOImpl implements CoberturaDAO{


public Bean getUsoCoberturaConfig(int intPoliza, int intCoberturaGen ,int intConceptoPago)
  {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Bean objBean = null;
    
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLUSOCONFIG_GET(?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intPoliza);
                wCstmt.setInt(3, intCoberturaGen);
                wCstmt.setInt(4, intConceptoPago);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                    objBean =  Tool.llenarRegistroCall(wRs);
                }
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudDet:" + se);
                objBean = null;
                
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudDet:" + e);
                e.printStackTrace();
                objBean = null;
            }
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
                System.out.println("Excep getLstSolicitudDet:" + sqlexception);
                sqlexception.printStackTrace();
                objBean = null;
            }
        }
        return objBean;
    } 
    
    public int insUsoCoberturaConfig(int intPoliza, int intCobertura, int intPeriodo, 
                                          int intFrecuencia, int intConceptoPago, int intUsuario, int intCoberturaGen,
                                          int intEstado, int intTipoFrec)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLUSOCONFIG_INS(?,?,?,?,?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intPoliza);
            wCstmt.setInt(3, intCobertura);
            wCstmt.setInt(4, intCoberturaGen);
            wCstmt.setInt(5, intPeriodo);           
            wCstmt.setInt(6, intFrecuencia);     
            wCstmt.setInt(7, intConceptoPago); 
            wCstmt.setInt(8, intUsuario); 
            wCstmt.setInt(9, intEstado);
            wCstmt.setInt(10, intTipoFrec); 
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


 public BeanList listUsoCoberturaConfig(int intPoliza)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
       
        ResultSet wRs1 = null;
        Connection wCon1 = null;
        CallableStatement wCstmt1 = null;
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLUSOCONFIG_LIST(?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, intPoliza);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              lista.add(Tool.llenarRegistroCall(wRs));
            }
            
            if(lista.size()>0)
            {
               
                wCon1 = ConexionIFX.getConnection();
                for(int i=0; i<lista.size(); i++)
                {
                    Bean auxBean = lista.getBean(i);
                    int intCoverGen = Tool.parseInt(auxBean.getString("NCOBERTURAGEN"));
                    int intConceptoPago = Tool.parseInt(auxBean.getString("NCONCEPTOPAGO"));
                    int intPolizaAux = Tool.parseInt(auxBean.getString("NPOLIZA"));
                    
                    String strDesCover = "";
                    String strDesConceptoPago=""; 
                
                    wCstmt1 = wCon1.prepareCall("{call sp_rea_cover(?,?)}");
                    wCstmt1.setInt(1, intCoverGen);
                    wCstmt1.setInt(2, intConceptoPago);
                
                    wRs1 = wCstmt1.executeQuery();
                    if (wRs1.next())
                    {
                        strDesCover  = wRs1.getString(1);
                        strDesConceptoPago  = wRs1.getString(2);
                    }
                    
                    lista.getBean(i).put("SDESCOVER", strDesCover);
                    lista.getBean(i).put("SDESCONPAGO", strDesConceptoPago);
                }            
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
                    
                if(wCstmt1 != null)
                    wCstmt1.close();
                if(wRs1 != null)
                    wRs1.close();
                if(wCon1 != null)
                    wCon1.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }

        return lista;
    }    
     
    public BeanList listControlCoberturaConfig(int intPoliza)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
       
        ResultSet wRs1 = null;
        Connection wCon1 = null;
        CallableStatement wCstmt1 = null;
        
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLCONTROLCONFIG_LIST(?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, intPoliza);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()){
              lista.add(Tool.llenarRegistroCall(wRs));
            }
            
            if(lista.size()>0)
            {
               
                wCon1 = ConexionIFX.getConnection();
                for(int i=0; i<lista.size(); i++)
                {
                    Bean auxBean = lista.getBean(i);
                   
                    int intPolizaAux = Tool.parseInt(auxBean.getString("NPOLIZA"));
                    int intCoverGen = Tool.parseInt(auxBean.getString("NCOBERTURAGEN"));
                    int intConceptoPago = 0;
                    
                    String strDesCover = "";
                    String strDesConceptoPago=""; 
                
                    wCstmt1 = wCon1.prepareCall("{call sp_rea_cover(?,?)}");
                    wCstmt1.setInt(1, intCoverGen);
                    wCstmt1.setInt(2, intConceptoPago);
                
                    wRs1 = wCstmt1.executeQuery();
                    if (wRs1.next())
                    {
                        strDesCover  = wRs1.getString(1);
                        strDesConceptoPago  = wRs1.getString(2);
                    }
                    
                    lista.getBean(i).put("SDESCOVER", strDesCover);
                }            
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
                    
                if(wCstmt1 != null)
                    wCstmt1.close();
                if(wRs1 != null)
                    wRs1.close();
                if(wCon1 != null)
                    wCon1.close();
            }
            catch(SQLException sqlexception)
            {
                return lista;
            }
        }

        return lista;
    }
    
    public int insControlCoberturaConfig(int intPoliza, int intCobertura, int intCoberturaGen, String strControl,
                                                int intUser)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLCONTROLCONFIG_INS(?,?,?,?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intPoliza);
            wCstmt.setInt(3, intCobertura);
            wCstmt.setInt(4, intCoberturaGen);
            wCstmt.setString(5, strControl);
            wCstmt.setInt(6, intUser);
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
   
   
   
   public String getControlCoberturaConfig(int intPoliza, int intCoberturaGen)
  {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        
        String strControl = "|";
        
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLCONTROLCONFIG_GET(?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setInt(2, intPoliza);
                wCstmt.setInt(3, intCoberturaGen);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next())
                {
                    strControl = strControl + wRs.getString("SCONTROL") + "|";
                }
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstSolicitudDet:" + se);
                strControl = null;
                
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstSolicitudDet:" + e);
                e.printStackTrace();
                strControl = null;
            }
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
                System.out.println("Excep getLstSolicitudDet:" + sqlexception);
                sqlexception.printStackTrace();
                strControl = null;
            }
        }
        return strControl;
    }
    
    public int delControlCoberturaConfig(int intPoliza, int intCoberturaGen)
    {
          int resultado=-1;     
          ResultSet wRs = null;
          Connection wCon = null;
          CallableStatement wCstmt = null;
         
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_MANTENIMIENTO.P_PTBLCONTROLCONFIG_DEL(?,?,?)}");    
            wCstmt.registerOutParameter(1, 4);
            wCstmt.setInt(2, intPoliza);
            wCstmt.setInt(3, intCoberturaGen);
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



    //RQ2019-626-INICIO
    public String obtenerObservacionAsegurado(int branch, int policy, int certif, String client){
        String resultado ="";
        Connection objCnn = null;
        CallableStatement objCstmt = null;
        ResultSet objRs = null;
        try {
            objCnn = ConexionIFX.getConnection();
            objCstmt = objCnn.prepareCall("{call sp_sit10_observ_aseg(?,?,?,?)}");
            objCstmt.setInt(1, branch);
            objCstmt.setInt(2, policy);
            objCstmt.setInt(3, certif);
            objCstmt.setString(4, client);
            objRs = objCstmt.executeQuery();
            if (objRs.next()) {
                resultado = objRs.getString(1);
            }

        } catch (SQLException se) {
            se.printStackTrace();
            System.out.println("SQLExce sp_sit10_observ_aseg:" + se);
        } catch (Exception e) {
            System.out.println("Excep sp_sit10_observ_aseg:" + e);

        } finally {
            try {
                if (objCstmt != null)
                    objCstmt.close();
                if (objRs != null)
                    objRs.close();
                if (objCnn != null)
                    objCnn.close();
            } catch (SQLException sqlexception) {

            }
        }

        return resultado;
    }
    //RQ2019-626-FIN

}