package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;
import com.clinica.beans.*;

public class ModuloDAOImpl implements ModuloDAO
{

  public BeanList getLstModulo(String strCriterio)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_LIST(?,?)}");
                wCstmt.setString(1, strCriterio);
                wCstmt.registerOutParameter(2, -10);
                wCstmt.execute();
                for(wRs = ((OracleCallableStatement)wCstmt).getCursor(2); wRs.next(); lista.add(Tool.llenarRegistroCall(wRs)));
                BeanList beanlist = lista;
                return beanlist;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstModulo:" + se);
                BeanList beanlist1 = null;
                return beanlist1;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstModulo:" + e);
            }
            BeanList beanlist2 = null;
            return beanlist2;
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
                BeanList beanlist3 = null;
                return beanlist3;
            }
        }
    }
    
    public Bean getModulo(int codigo)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Bean modulo = new Bean();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_GET(?,?)}");
                wCstmt.setInt(1, codigo);
                wCstmt.registerOutParameter(2, -10);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(2);
                if(wRs.next())
                    modulo = Tool.llenarRegistroCall(wRs);
                Bean bean = modulo;
                return bean;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getModulo:" + se);
                Bean bean1 = null;
                return bean1;
            }
            catch(Exception e)
            {
                System.out.println("Excep getModulo:" + e);
            }
            Bean bean2 = null;
            return bean2;
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
                Bean bean3 = null;
                return bean3;
            }
        }
    }
    
    public String listaCombo(BeanList beanList, String valor, String texto, String idPadre, int sModulo)
    {
        StringBuffer cadena = new StringBuffer();
        String sModuloAux = "" + sModulo;
        for(int i = 0; i < beanList.size(); i++)
        {
            if(idPadre.length() == 0)
            {
                if(i == 0)
                {
                    cadena.append("<option selected value=\"0\">");
                    cadena.append("----Ninguno----");
                    cadena.append("</option>\n");
                }
                cadena.append("<option value=\"" + beanList.getBean(i).getString(valor) + "\">");
                cadena.append(beanList.getBean(i).getString(texto));
                cadena.append("</option>\n");
            }
            if(idPadre.equalsIgnoreCase("0"))
            {
                if(beanList.getBean(i).getString(valor).equalsIgnoreCase(sModuloAux))
                {
                    cadena.append("<option selected value=\"0\">");
                    cadena.append("----Ninguno----");
                }
                if(!beanList.getBean(i).getString(valor).equalsIgnoreCase(sModuloAux))
                {
                    cadena.append("<option value=\"" + beanList.getBean(i).getString(valor) + "\">");
                    cadena.append(beanList.getBean(i).getString(texto));
                }
                cadena.append("</option>\n");
            }
            if(idPadre.equalsIgnoreCase("0") || idPadre.length() <= 0 || beanList.getBean(i).getString(valor).equalsIgnoreCase(sModuloAux))
                continue;
            if(beanList.getBean(i).getString(valor).equalsIgnoreCase(idPadre))
                cadena.append("<option selected value=\"" + beanList.getBean(i).getString(valor) + "\">");
            if(!beanList.getBean(i).getString(valor).equalsIgnoreCase(idPadre))
                cadena.append("<option value=\"" + beanList.getBean(i).getString(valor) + "\">");
            cadena.append(beanList.getBean(i).getString(texto));
            cadena.append("</option>\n");
        }

        return cadena.toString();
    }
    
      public Bean getContadorModulo(int intOrden, int intPadre, int intModulo)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Bean modulo = new Bean();
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_CONT(?,?,?,?)}");
                wCstmt.setInt(1, intOrden);
                wCstmt.setInt(2, intPadre);
                wCstmt.setInt(3, intModulo);
                wCstmt.registerOutParameter(4, -10);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(4);
                if(wRs.next())
                    modulo = Tool.llenarRegistroCall(wRs);
                Bean bean = modulo;
                return bean;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getModulo:" + se);             
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getModulo:" + e);
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
    
        
    public int insertaModulo(String strNombre, int intNivel, int intPadre, String strUrl,int intOrden,int intUsuario)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intRetorno = 1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_INS(?,?,?,?,?,?,?,?)}");
                wCstmt.setString(1, strNombre);
                wCstmt.setInt(2, intNivel);
                wCstmt.setInt(3, intPadre);
                wCstmt.setString(4, strUrl);
                wCstmt.setInt(5, intOrden);
                wCstmt.setInt(6, intUsuario);
                wCstmt.registerOutParameter(7, 4);
                wCstmt.registerOutParameter(8, 4);
                wCstmt.execute();
                intRetorno = wCstmt.getInt(8);                
                return intRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce insertaModulo:" + se);
                byte byte0 = -2;
                return byte0;
            }
            catch(Exception e)
            {
                System.out.println("Excep insertaModulo:" + e);
            }
            byte byte1 = -2;
            return byte1;
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
                byte byte2 = -2;
                return byte2;
            }
        }
    }
    
   public int actualizaModulo(int intModulo, String strNombre, int intNivel, int intPadre, String strUrl, int intOrden,int intUsuario)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intRetorno = 1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_UPD(?,?,?,?,?,?,?,?)}");
                wCstmt.setInt(1, intModulo);
                wCstmt.setString(2, strNombre);
                wCstmt.setInt(3, intNivel);
                wCstmt.setInt(4, intPadre);
                wCstmt.setString(5, strUrl);
                wCstmt.setInt(6, intOrden);
                wCstmt.setInt(7, intUsuario);
                wCstmt.registerOutParameter(8, 4);
                wCstmt.execute();
                intRetorno = wCstmt.getInt(8);                
                return intRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce actualizaModulo:" + se);
                byte byte0 = -2;
                return byte0;
            }
            catch(Exception e)
            {
                System.out.println("Excep actualizaModulo:" + e);
            }
            byte byte1 = -2;
            return byte1;
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
                byte byte2 = -2;
                return byte2;
            }
        }
    }

    public int deleteModuloGroup(String strCodigos)
    {
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intRetorno = 1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_MANTENIM.P_MODULO_DEL(?,?)}");
                wCstmt.setString(1, strCodigos);
                wCstmt.registerOutParameter(2, 4);
                wCstmt.execute();
                intRetorno = wCstmt.getInt(2);                
                return intRetorno;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce deleteModuloGroup:" + se);
                byte byte0 = -2;
                return byte0;
            }
            catch(Exception e)
            {
                System.out.println("Excep deleteModuloGroup:" + e);
            }
            byte byte1 = -2;
            return byte1;
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
                byte byte2 = -2;
                return byte2;
            }
        }
    }
}