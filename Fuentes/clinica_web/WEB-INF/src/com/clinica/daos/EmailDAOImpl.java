package com.clinica.daos;

import com.clinica.utils.coneccion.*;
import com.clinica.utils.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;
import com.clinica.beans.*;


public class EmailDAOImpl implements EmailDAO
{

  public int enviaEmail(int intMotivo, String strAsunto,  String strContenido)
    {     
        int resultado=-1;     
        Connection wCon = null;
        CallableStatement wCstmt = null;
  
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();    
            wCstmt = wCon.prepareCall("{call PKG_EMAIL.P_PTBLENVIAEMAIL(?,?,?,?)}");    
            wCstmt.setInt(1,intMotivo); 
            wCstmt.setString(2,strAsunto);
            wCstmt.setString(3,strContenido); 
            wCstmt.registerOutParameter(4, Types.INTEGER); 
            wCstmt.execute();
            resultado = wCstmt.getInt(4);           
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

  public int enviaEmailBandeja(int intMotivo, int intRol, int intOficina, String strSiniestro)
  {     
        int resultado=-1;     
        Connection wCon = null;
        CallableStatement wCstmt = null;
      System.out.println("enviaEmailBandeja :"+"\n");
       System.out.println("intMotivo :"+intMotivo);
       System.out.println("intRol :"+intRol);
       System.out.println("intOficina :"+intOficina);
        System.out.println("strSiniestro :"+strSiniestro);
        try
        {            
            wCon = ConexionOracle.getConnectionOracle();    

            wCstmt = wCon.prepareCall("{call PKG_EMAIL.P_PTBLENVIAEMAIL_BANDEJA(?,?,?,?,?)}");    
            wCstmt.setInt(1,intMotivo); 
            wCstmt.setInt(2,intRol);
            wCstmt.setInt(3,intOficina); 
            wCstmt.setString(4,strSiniestro); 
            wCstmt.registerOutParameter(5, Types.INTEGER); 
            wCstmt.execute();
            resultado = wCstmt.getInt(5);           
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
  
   public int enviaMailDeuda(Bean objContratante, int intPoliza, int intCertificado, Cliente objCliente, 
                              Solicitud objSolicitud, String strNombClinica)
    {
        String strAsunto="";
        String strContenido="";
        try
        {
  
        
            strAsunto="SE OTORGA PASE PARA ATENCION MEDICA, CLIENTE CON DEUDA";
       
            strContenido="\nPOLIZA                : " + intPoliza + "\n" + 
                           "CERTIFICADO           : " + intCertificado + "\n" + 
                           "NOMB. PACIENTE        : " + objCliente.getStrNombreAseg() + "\n" + 
                           "CODIGO PACIENTE       : " + objCliente.getStrCodigo() + "\n" + 
                           "NOMB. CONTRATANTE     : " + objContratante.getString("2") + "\n" + 
                           "CODIGO CONTRATANTE    : " + objContratante.getString("1") + "\n" + 
                           "TELEF. 1 CONTRATANTE  : " + objContratante.getString("3") + "\n" + 
                           "TELEF. 2 CONTRATANTE  : " + objContratante.getString("4") + "\n" + 
                           "NRO. SINIESTRO        : " + objSolicitud.getSNROSINIESTRO() + "\n" + 
                           "FECHA OCURRENCIA      : " + Tool.getDate("dd/MM/yyyy", new Date()) + "\n" + 
                           "LUGAR ATENCION        : " + strNombClinica;     
                enviaEmail(Constante.CODMOTIVODEUDA,strAsunto,strContenido); 
            return 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return -1;
        }
    }
    
    
  
}