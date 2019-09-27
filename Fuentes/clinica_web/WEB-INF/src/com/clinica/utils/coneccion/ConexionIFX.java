package com.clinica.utils.coneccion;

import com.informix.jdbcx.IfxDataSource;
import com.clinica.utils.*;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class ConexionIFX 
{
    public ConexionIFX()
    {
  
    }

    private static void initJDBCConnection()
    {    
        try
        {
            context = new InitialContext();
            //jdbcURL = (DataSource)context.lookup("jdbc/DBConnectionINFPooledDS");
            //System.out.println("Obtained Cached Data Source ");
        }
        catch(NamingException e)
        {
            System.err.println("Error looking up Data Source from Factory: " + e);
        }

        try
        {
            informixURL = new IfxDataSource();
            informixURL.setDescription("InsunixDB Data Source");
              
            informixURL.setIfxIFXHOST(Constante.getConst("IPGEN_IFX_EPS"));
            informixURL.setPortNumber(Tool.parseInt(Constante.getConst("PORTGEN_IFX_EPS")));
            informixURL.setUser(Constante.getConst("USRGEN_IFX_EPS"));
            informixURL.setPassword(Constante.getConst("PWDGEN_IFX_EPS"));
            informixURL.setServerName(Constante.getConst("SERGEN_IFX_EPS"));
            informixURL.setDatabaseName("insunixdb");
            informixURL.setIfxGL_DATE("%d/%m/%Y");
            
            context.rebind("jdbc/DBConnectionINFPooledDS", informixURL);
            System.out.println("Obtained Cached Data Source ");
        }
        catch(Exception e)
        {
            System.out.println("Problem with registering the DS");
            System.out.println("Error: " + e.toString());
        }    
        
    }
//AGREGADO PARA EL PROYECTO EPS    
     private static void initJDBCConnectionEPS()
     {
        try
        {
            context = new InitialContext();
            //jdbcURL = (IfxDataSource)context.lookup("jdbc/DBConnectionINFEPSPooledDS");
            //System.out.println("Obtained Cached Data Source ");
        }
        catch(NamingException e)
        {
            System.err.println("Error looking up Data Source from Factory: " + e);
        }

        try
        {
            jdbcURL = new IfxDataSource();
            jdbcURL.setDescription("InsunixDB Data Source 2");

            jdbcURL.setIfxIFXHOST(Constante.getConst("IPGEN_IFX_EPS"));
            jdbcURL.setPortNumber(Tool.parseInt(Constante.getConst("PORTGEN_IFX_EPS")));
            jdbcURL.setUser(Constante.getConst("USRGEN_IFX_EPS"));
            jdbcURL.setPassword(Constante.getConst("PWDGEN_IFX_EPS"));
            jdbcURL.setServerName(Constante.getConst("SERGEN_IFX_EPS"));
            jdbcURL.setDatabaseName("insunixdb");
            jdbcURL.setIfxGL_DATE("%d/%m/%Y");
            
            context.rebind("jdbc/DBConnectionINFEPSPooledDS", jdbcURL);
            System.out.println("Obtained Cached Data Source " + jdbcURL.getIfxIFXHOST() + jdbcURL.getPortNumber() +  jdbcURL.getUser()
                               + jdbcURL.getPassword() + jdbcURL.getServerName() +  jdbcURL.getDatabaseName() + jdbcURL.getIfxGL_DATE());
        }
        catch(Exception e)
        {
            System.out.println("Problem with registering the DS");
            System.out.println("Error: " + e.toString());
        } 
    }
    public static Connection getConnectionEPS()
    {        
        try
        {
            /*if(jdbcURL == null)
            {
                initJDBCConnection();
                System.out.println("Initialization OracleIFX Successfull");
            }
            Connection connection = jdbcURL.getConnection();*/
            
            if(jdbcURL == null)
            {
                initJDBCConnectionEPS();
                System.out.println("Initialization Informix Successfull");
           }            
           
            Connection connection2 = jdbcURL.getConnection();
            
            return connection2;
        }
        catch(SQLException e)
        {
            System.out.println("Error getting pooled connection from Factory:" + e);
        }
        Connection connection2 = null;
        return connection2;
    }
//AGREGADO PARA EL PROYECTO EPS FIN
    public static Connection getConnection()
    {            
        try
        {
            /*
            if(jdbcURL == null)
            {
                initJDBCConnection();
                System.out.println("Initialization OracleIFX Successfull");
            }
            Connection connection = jdbcURL.getConnection();*/
            
            if(informixURL == null)
            {             
                initJDBCConnection();
                System.out.println("Initialization Informix Successfull");
            }
            Connection connection = informixURL.getConnection();
            
            return connection;
        }
        catch(SQLException e)
        {            
            System.out.println("Error getting pooled connection from Factory:" + e);
        }
        Connection connection1 = null;
        return connection1;
    }


    private static IfxDataSource jdbcURL;
    private static InitialContext context;
    private Connection Conn;
 
    private static IfxDataSource informixURL;
    private static IfxDataSource informixURL2;
}