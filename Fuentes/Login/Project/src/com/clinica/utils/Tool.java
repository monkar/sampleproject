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
}
