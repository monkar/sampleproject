package com.clinica.utils.coneccion;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConexionOracle
{

    private static void initJDBCConnection()
    {
        try
        {
            context = new InitialContext();
            //jdbcURL = (DataSource)context.lookup("jdbc/DBConnectionPOSVRTPooledDS");
            jdbcURL = (DataSource)context.lookup("jdbc/DBConnectionUSRWCLEPSPooledDS");
            System.out.println("Obtained Cached Data Source ");
        }
        catch(NamingException e)
        {
            System.err.println("Error looking up Data Source from Factory: " + e);
        }
    }


    //PRT Conexion de Visual Time
    private static void initJDBCConnectionVT()
    {
        try
        {
            context = new InitialContext();
            jdbcURLVT = (DataSource)context.lookup("jdbc/DBConnectionVTIMEPooledDS");
            System.out.println("Obtained Cached Data Source a Visual Time*");
        }
        catch(NamingException e)
        {
            System.err.println("Error looking up Data Source from Factory: " + e);
        }
    }

    //PRT Conexion de Visual Time
    public static Connection getConnectionVTime()
    {
        try
        {           
            if(jdbcURLVT == null)
            {
                initJDBCConnectionVT();
                System.out.println("Initialization OracleDB Successfull");
            }
            Connection connection = jdbcURLVT.getConnection();
            return connection;
        }
        catch(Exception e)
        {
            System.out.println("Error getting pooled connection from Factory:" + e);
        }
        Connection connection1 = null;
        return connection1;
    }      
    

    public static Connection getConnectionOracle()
    {
        try
        {
            if(jdbcURL == null)
            {
                initJDBCConnection();
                System.out.println("Initialization OracleDB Successfull");
            }
            Connection connection = jdbcURL.getConnection();
            return connection;
        }
        catch(SQLException e)
        {
            System.out.println("Error getting pooled connection from Factory:" + e);
        }
        Connection connection1 = null;
        return connection1;
    }

    //PRT Data Source utilizado para la conexion a VT
    private static DataSource jdbcURLVT;   
    private static DataSource jdbcURL;
    private static InitialContext context;
    private String jdbcDriver;
    private Connection Conn;
}