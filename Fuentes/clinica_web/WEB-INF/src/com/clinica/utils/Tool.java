package com.clinica.utils;

import com.clinica.utils.coneccion.*;
import java.sql.*;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
import java.util.Vector;


public class Tool 
{
  public Tool()
  {
  }

    public static String parStringList(String[] items)
    {
      String strEstados = "";
      boolean flgEstados = false;
      
      if(items != null || items.length > 0)
      {
 
        for(int i = 0; i < items.length; i++)
        {
          strEstados = strEstados + items[i] + ",";
          if(items[i].equals("0"))
          {
            flgEstados = true;
            break;
          }
        }
      
      
        if(flgEstados)
        {
          strEstados = "0";
        }
        else
        {
          strEstados = strEstados.substring(0,strEstados.length()-1);
        }
   
      }
      return strEstados;
    }
    public static int parseInt(String val)
    {
        try
        {   
            if (val != null)
                val = val.trim();
            if(val != null && !val.equals(""))
            {
                int i = Integer.parseInt(val);
                int l = i;
                return l;
            } else
            {
                int j = 0;
                int i1 = j;
                return i1;
            }
        }
        catch(Exception e)
        {
            System.out.println("ERROR comnvirtiendo:" + val + " a int ERROR=" + e);
        }
        int k = 0;
        return k;
    }

    public static double parseDouble(String val)
    {
        try
        {
            if (val != null)
              val = val.trim();

            if(val != null && !val.equals(""))
            {
                double i = Double.parseDouble(val);
                double d1 = i;
                return d1;
            } else
            {
                int j = 0;
                double d = j;
                return d;
            }
        }
        catch(Exception e)
        {
            System.out.println("ERROR comnvirtiendo:" + val + " a int ERROR=" + e);
        }
        int k = 0;
        return (double)k;
    }

    public static String getString(String val)
    {
        if(val != null && !val.equals(""))
            return val.trim();
        else
            return "";
    }

    public static String toDecimal(double val, int numdecimal)
    {
        try
        {
            NumberFormat nf = NumberFormat.getInstance(Locale.US);
            nf.setMinimumFractionDigits(numdecimal);
            nf.setMaximumFractionDigits(numdecimal);
            if(val != (double)0)
            {
                String s = nf.format(val);
                return s;
            } else
            {
                String s1 = "0";
                return s1;
            }
        }
        catch(Exception e)
        {
            System.out.println("ERROR comnvirtiendo:" + val + " a int ERROR=" + e);
        }
        String s2 = "0";
        return s2;
    }

  public static Bean llenarRegistro(ResultSet objRs, PreparedStatement objPstmt)
        throws SQLException
  {
    Bean has = new Bean();
    for(int i = 1; i <= objPstmt.getMetaData().getColumnCount(); i++)
      has.put(objPstmt.getMetaData().getColumnName(i), getString(objRs.getString(objPstmt.getMetaData().getColumnName(i))));

    return has;
  }
  
    public static Bean llenarRegistroCall(ResultSet objRs)
          throws SQLException
    {
      Bean has = new Bean();
      for(int i = 1; i <= objRs.getMetaData().getColumnCount(); i++)
        has.put(objRs.getMetaData().getColumnName(i), getString(objRs.getString(objRs.getMetaData().getColumnName(i))));
  
      return has;
    } 
    
    public static Bean llenarRegistroCallIfx(ResultSet rs, CallableStatement cstmt1)
        throws SQLException
    {
        Bean has = new Bean();
        for(int i = 1; i <= cstmt1.getMetaData().getColumnCount(); i++)
            has.put(String.valueOf(i), getString(rs.getString(i)));

        return has;
    }

  public static Bean llenarRegistroIfx(ResultSet objRs, PreparedStatement objPstmt)
        throws SQLException
  {
    Bean has = new Bean();
    for(int i = 1; i <= objPstmt.getMetaData().getColumnCount(); i++)
      has.put(String.valueOf(i), getString(objRs.getString(i)));
      return has;
  }

  
  //PRT Metodo creado para devolver el contenido de un cursor de VT
    public static Bean llenarRegistroCallVtime(ResultSet rs)
        throws SQLException
    {
        Bean has = new Bean();
        for(int i = 1; i <= rs.getMetaData().getColumnCount(); i++){
            has.put(String.valueOf(i), getString(rs.getString(i)));
        }
    return has;
  }

    public static String getDateIfx()
    {
        String fecha = null;
        ResultSet rs = null;
        Connection con = null;
        CallableStatement cstmt = null;
        try
        {
            try
            {
                con = ConexionIFX.getConnection();
                cstmt = con.prepareCall("{call rea_dat_system()}");
                rs = cstmt.executeQuery();
                if(rs.next())
                    fecha = rs.getString(1);
                return fecha;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getDateInsx:" + se);
                return null;
            }
            catch(Exception e)
            {
                System.out.println("Excep getDateInsx:" + e);
            }
            return null;
        }
        finally
        {
            try
            {
                if(cstmt != null)
                    cstmt.close();
                if(rs != null)
                    rs.close();
                if(con != null)
                    con.close();
            }
            catch(SQLException sqlexception)
            {
                return null;
            }
        }
    } 


  

    public static String getDate(String formato)
    {
        try
        {
            DateFormat formatter = null;
            formatter = new SimpleDateFormat(formato);
            String dato = formatter.format(new java.util.Date());
            String s1 = dato;
            return s1;
        }
        catch(Exception e)
        {
            System.out.println("Error getdate:" + e);
        }
        String s = null;
        return s;
    }

    public static String addDate(int num,String formato) //yyyy:año, MM:mes, dd:dia
    {
        try
        {
            DateFormat formatter = null;
            formatter=new SimpleDateFormat(formato);            
            Calendar c1 = Calendar.getInstance();
            c1.setTime(new java.util.Date());
            c1.add(Calendar.DATE, num); 
            String dato=formatter.format(c1.getTime());
             return dato;
        }
        catch(Exception e)
        {
            System.out.println("Error getdate:" + e);
            return null;
        }

    }

  public static String getTipoCambio()
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
     String moneda = null;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_rea_exchange2(?,?,?)}");
                objCstmt.setInt(1, 1);
                objCstmt.setInt(2, 1);
                objCstmt.setInt(3, 2);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  moneda = toDecimal(parseDouble(objRs.getString(1)), 2);
                }
                return moneda;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getTipoCambio:" + se);
                return "";
      }
    catch(Exception e)
      {
                System.out.println("Excep getTipoCambio:" + e);
                return "";
                
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
                return "";
            }
      }
  } 

    public static String getTipoCambioByDate(int intMoneda, String dFecha)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
     String moneda = null;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_exchange(?,?)}");
                objCstmt.setInt(1, intMoneda);
                objCstmt.setString(2, dFecha);
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  moneda = toDecimal(parseDouble(objRs.getString(5)), 2);
                }
                return moneda;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getTipoCambioByDate:" + se);
                return "";
      }
    catch(Exception e)
      {
                System.out.println("Excep getTipoCambioByDate:" + e);
                return "";
                
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
                return "";
            }
      }
  }

    public static String listaCombo(BeanList beanList, String valor, String texto)
    {
        StringBuffer cadena = new StringBuffer();
        for(int i = 0; i < beanList.size(); i++)
        {
            if (!"".equals(beanList.getBean(i).getString(valor))){
            cadena.append("<option value=\"" + beanList.getBean(i).getString(valor) + "\">");
            cadena.append(beanList.getBean(i).getString(texto));
            cadena.append("</option>\n");
            }
        }
        
        return cadena.toString();
    }

    public static String listaComboSeleccionado(BeanList beanList, String valor, String texto,String value)
    {
        StringBuffer cadena = new StringBuffer();
        for(int i = 0; i < beanList.size(); i++)
        {
            if (!"".equals(beanList.getBean(i).getString(valor))){
            cadena.append("<option value=\"" + beanList.getBean(i).getString(valor));
            cadena.append("\"");
            if( beanList.getBean(i).getString(valor).equals(value)) cadena.append(" selected ");
            cadena.append(">");
            cadena.append(beanList.getBean(i).getString(texto));
            cadena.append("</option>\n");
            }
        }
        return cadena.toString();
    }       


   public static BeanList obtieneLista(String sql, String strDB)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        BeanList objLista = new BeanList();
        try
        {
            if ("IFX".equalsIgnoreCase(strDB))
              objCnn = ConexionIFX.getConnection();
            else
              objCnn = ConexionOracle.getConnectionOracle();
              
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            while(objRs.next())
            {
                 objLista.add(llenarRegistro(objRs, objPstmt));
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

  public static double reaIGV(int intTipo, String strFecha)
  /*
   intTipo: Tipo de valor
      1: Porcentaje de IGV
      2: Porcentaje de IGV + 1
      3: Factor de IGV para obtencion de prima neta
      4: Factor de IGV para obtencion de prima neta + 1
    strFecha: Fecha a l cual se va obtener el valor, si es vacío es la fecha actual.
   */
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    double dblIgv = 0; 
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tax_igv(?,?)}");
                objCstmt.setInt(1, intTipo);
                objCstmt.setString(2,("".equals(strFecha)?Tool.getDateIfx():strFecha));
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  dblIgv = objRs.getDouble(1);
                }
                return dblIgv;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce reaIGVIfx:" + se);
                return 0;
      }
    catch(Exception e)
      {
                System.out.println("Excep reaIGVIfx:" + e);
                return 0;
                
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
                return 0;
            }
      }

  }   

  public static int execute_sql(String sql)
  {     
        int resultado=-1;     
        ResultSet wRs = null;
        Connection wCon = null;
        PreparedStatement wPstmt = null;
          
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();
            wCon.setAutoCommit(true);
            wPstmt = wCon.prepareStatement(sql);
            boolean blRet = wPstmt.execute();
            wCon.commit();
            if (blRet) resultado = 0;
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
                if(wPstmt != null)
                    wPstmt.close();
                if(wCon != null)
                    wCon.close();
            }
            catch(SQLException sqlexception) { }
        }
        return resultado;
  }  

  public static String getDescMes(int intMes)
  {
      
      String[] strMes={"","Enero","Febrero","Marzo","Abril","Mayo","Junio",
                       "Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"};

      return strMes[intMes];
  }
  
  //Agrega un numero de dias a una fecha
  public static String addDate(int num, String formato, java.util.Date fecha)
  {
      try
      {
          DateFormat formatter = null;
          formatter=new SimpleDateFormat(formato);           
          Calendar c1 = Calendar.getInstance();
          c1.setTime(fecha);
          c1.add(Calendar.DATE, num); 
          String dato=formatter.format(c1.getTime());
          return dato;
      }
      catch(Exception e)
      {
          System.out.println("Error getdate:" + e);
          return null;
      }
  }
  
  //Agrega un numero de dias a una fecha
  public static String getDate(String formato, java.util.Date fecha)
  {
      try
      {
          DateFormat formatter = null;
          formatter=new SimpleDateFormat(formato);           
          Calendar c1 = Calendar.getInstance();
          c1.setTime(fecha);
          String dato=formatter.format(c1.getTime());
          return dato;
      }
      catch(Exception e)
      {
          System.out.println("Error getdate:" + e);
          return null;
      }
  }
  
  public static String addDays(int intNum, java.util.Date fecha){
    try{      
      DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy"); 
      Calendar cal = Calendar.getInstance();
      cal.setTime(fecha);
      cal.add(Calendar.DAY_OF_MONTH,intNum);
      String nNuevaFecha = formatter.format(cal.getTime());
      return nNuevaFecha;
    }
    catch(Exception ex){
      ex.printStackTrace();
      System.out.println("Error getdate:" + ex);
      return null;
    }
  }
  
  public static double redondear( double numero, int decimales ) {
    return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
  }
  
  public static Bean executeQuery(String sql)
  {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;
        Bean bean = null;
        try
        {
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                 bean = Tool.llenarRegistro(objRs, objPstmt);
            }            
            return bean;
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
    private static String CONTEXT_PATH;
    public static void setContextPath(String contextPath){
        CONTEXT_PATH = contextPath;
    }
    public static String getContextPath(){
        return CONTEXT_PATH;
    }
}
