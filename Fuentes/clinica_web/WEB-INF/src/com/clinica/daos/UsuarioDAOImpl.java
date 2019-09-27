package com.clinica.daos;

import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.utils.Constante;
import com.clinica.utils.Tabla;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;
import com.clinica.beans.*;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.StringTokenizer;
import oracle.jdbc.*;
//import oracle.sql.BLOB;
import oracle.jdbc.OracleResultSet;

public class UsuarioDAOImpl implements UsuarioDAO
{

  public int esHabilAnulacion(int intIdUsuario)
  {
      int result = -1;
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      
      try
      {
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call P_PTBLUSUARIO_ANUL_VAL(?,?)}");
          objCstmt.registerOutParameter(1,OracleTypes.INTEGER);
          objCstmt.setInt(2, intIdUsuario);
          objCstmt.execute();
          result = ((OracleCallableStatement)objCstmt).getInt(1);
          return result;
      }
      catch(SQLException se)
      {
          se.printStackTrace();
          System.out.println("SQLExce P_PTBLUSUARIO_ANUL_VAL:" + se);
          return -1;
      }
      catch(Exception e)
      {
          System.out.println("Excep P_PTBLUSUARIO_ANUL_VAL:" + e);
          return -1;
      }
      finally
      {
          try
          {
              if(objRs != null)
                  objRs.close();
              if(objCstmt != null)
                  objCstmt.close();
              if(objCnn != null)
                  objCnn.close();
          }
          catch(SQLException sqlexception)
          {
            return -1;
          }
      }
  }
  //Fin Req 2011-0480
  public Usuario getUsuario(String strNombre, String strClave)
  {
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      Usuario objUsuario = new Usuario();
      try
      {
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_VALIDAUSUARIO(?,?,?)}");
          objCstmt.registerOutParameter(1,-10);
          objCstmt.setString(2, strNombre);
          objCstmt.setString(3, strClave);
          objCstmt.execute();
          objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
          if (objRs.next())
          {
              objUsuario = new Usuario();
              objUsuario.setNIDUSUARIO(objRs.getInt("NIDUSUARIO"));
              objUsuario.setIntIdRol(objRs.getInt("NIDROL"));
              objUsuario.setStrWebServer(objRs.getString("SCODIGO"));
              objUsuario.setStrNombreExt(objRs.getString("SNOMBRE"));
              objUsuario.setIntCodOficina(objRs.getInt("NCODOFICINA"));
              objUsuario.setIntCodBroker(objRs.getInt("NCODBROKER"));
              objUsuario.setIntFlgActivo(objRs.getInt("NFLGACTIVO"));
              objUsuario.setStrEmail(objRs.getString("SEMAIL"));
              objUsuario.setStrLogin(objRs.getString("SLOGIN"));
              objUsuario.setIntXMLActivo(objRs.getInt("NXMLACTIVO")); //REQ 2011-0389 BIT/FMG
              objUsuario.setIntTipoUsuario(objRs.getInt("NIDTIPOUSUARIO")); //REQ 2011-xxxx BIT/FMG
              objUsuario.setIntFlgDeshabilitado(objRs.getInt("NFLGDESHABILITADO")); //REQ. 2014-0000561 Paradigmasoft GJB

              String strCodigo = Tool.getString(objRs.getString("SCODIGO"));
              if (!strCodigo.equals(""))
              {
                  Bean bTmp = Tabla.getProvedorIfxServ(strCodigo);
                  objUsuario.setStrNombreExt(bTmp.getString("4"));
                  objUsuario.setIntCodGrupo(Tool.parseInt(bTmp.getString("6")));
              }
          }
          
          System.out.println("Usuario encontrado:" + objUsuario.getIntIdUsuario());
          
          return objUsuario;
      }
      catch(SQLException se)
      {
          se.printStackTrace();
          System.out.println("SQLExce getUsuario:" + se);
          return null;
      }
      catch(Exception e)
      {
          System.out.println("Excep getUsuario:" + e);
          return null;
      }
      finally
      {
          try
          {
              if(objRs != null)
                  objRs.close();
              if(objCstmt != null)
                  objCstmt.close();
              if(objCnn != null)
                  objCnn.close();
          }
          catch(SQLException sqlexception)
          {
          }
      }
  }

/*
 * Se parando los metodos lstModuloRol
 * Y lstModulo YahirRivas 01MAR2012 11:23AM
 * */

  public BeanList lstModuloRol(String strRoles,int CodGrupo)
  {
   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   Modulo objModulo = null;
   BeanList lstModuloRol = new BeanList();
    try
    {
    
                objCnn =  ConexionOracle.getConnectionOracle();
                //Req 2011-0849
                objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_LIST(?,?,?,?)}");
                ////Req 2011-0849
                //objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_LIST(?,?,?)}");
                objCstmt.registerOutParameter(1,-10);
                objCstmt.registerOutParameter(2,-10);
                objCstmt.setString(3, strRoles);
                //Req 2011-          Renzo Calderon V.
                objCstmt.setInt(4, CodGrupo);
                ////Req 2011-
                objCstmt.execute();                
                objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
                           
                while (objRs.next()){
                  objModulo = new Modulo();
                  
                  objModulo.setNIDMODULO(objRs.getInt("NIDMODULO"));
                  objModulo.setSNOMBRE(objRs.getString("SNOMBRE"));
                  objModulo.setNNIVEL(objRs.getInt("NNIVEL"));
                  objModulo.setNORDEN(objRs.getInt("NORDEN"));
                  objModulo.setNIDMODULOSUP(objRs.getInt("NIDMODULOSUP"));
                  objModulo.setSURL(objRs.getString("SURL"));
                  
                  /*
                   if(CodGrupo==Constante.NCODGRUPOPROT)
                    {
                      if(objModulo.getNIDMODULO()!=12)
                      {
                      lstModuloRol.add(objModulo);
                      }
                    }
                    else
                    {
                      if(objModulo.getNIDMODULO()!=17)   
                      {
                      lstModuloRol.add(objModulo);
                      }
                    }*/
                  //Req 2011-0849
                  
                  lstModuloRol.add(objModulo);
                  ////Req 2011-0849

                 // System.out.println("mod_id:" + objModulo.getNIDMODULO());
                }                        
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce listModulo:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep listModulo:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      }
                        
 return lstModuloRol;
  }

  public BeanList lstModulo(String strRoles,int CodGrupo)
  {

   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   Modulo objModulo = null;
  BeanList  lstModulo = new BeanList();       
    try
    {
    
                objCnn =  ConexionOracle.getConnectionOracle();
                //Req 2011-0849
                objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_LIST(?,?,?,?)}");
                ////Req 2011-0849
                //objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_MODULOROL_LIST(?,?,?)}");
                objCstmt.registerOutParameter(1,-10);
                objCstmt.registerOutParameter(2,-10);
                objCstmt.setString(3, strRoles);
                //Req 2011-          Renzo Calderon V.
                objCstmt.setInt(4, CodGrupo);
                ////Req 2011-
                objCstmt.execute();                
                objRs = ((OracleCallableStatement)objCstmt).getCursor(2);
                         
                while (objRs.next()){
                  objModulo = new Modulo();
                  objModulo.setNIDMODULO(objRs.getInt("NIDMODULO"));
                  objModulo.setSNOMBRE(objRs.getString("SNOMBRE"));
                  objModulo.setNNIVEL(objRs.getInt("NNIVEL"));
                  objModulo.setNORDEN(objRs.getInt("NORDEN"));
                  objModulo.setNIDMODULOSUP(objRs.getInt("NIDMODULOSUP"));
                  objModulo.setSURL(objRs.getString("SURL"));
                  
                   if(CodGrupo==Constante.NCODGRUPOPROT)
                    {
                      if(objModulo.getNIDMODULO()!=12)
                      {
                      lstModulo.add(objModulo);
                      }
                    }
                    else
                    {
                      if(objModulo.getNIDMODULO()!=17)
                      {
                      lstModulo.add(objModulo);
                      }
                    }
                    
                  //lstModulo.add(objModulo);                  
                  objModulo = null;
                  //System.out.println("lstListado:" + lstModulo.size());
                }                    
           
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce listModulo:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep listModulo:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      } 
      return lstModulo;
  }

   public Usuario getUsuario(int intCodigo)
  {  
   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   Usuario objUsuario = null;
    try
    {
    
                objCnn =  ConexionOracle.getConnectionOracle();
                objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_USUARIO_GET(?,?)}"); 		  			
                objCstmt.registerOutParameter(1,-10);
                objCstmt.setInt(2, intCodigo);    
                objCstmt.execute();
                objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
                if (objRs.next())
                {         
                    objUsuario = new Usuario();
                    objUsuario.setNIDUSUARIO(objRs.getInt("NIDUSUARIO"));
                    objUsuario.setIntIdRol(objRs.getInt("NIDROL"));
                    objUsuario.setIntCodOficina(objRs.getInt("NCODOFICINA"));
                    objUsuario.setStrLogin(objRs.getString("LOGIN")); 
                    objUsuario.setStrNombre(objRs.getString("SNOMBRE"));
                    
                    objUsuario.setIntFlgActivo(objRs.getInt("NFLGACTIVO"));
                    objUsuario.setStrEmail(objRs.getString("SEMAIL"));
                    objUsuario.setIntCodBroker(Tool.parseInt(objRs.getString("NCODBROKER")));
                    objUsuario.setIntFlgDeshabilitado(objRs.getInt("NFLGDESHABILITADO"));
                    
                    String strCodigo = objRs.getString("SCODIGO");
                    objUsuario.setStrWebServer(strCodigo);
                    if (strCodigo!= null && !strCodigo.equals(""))
                    {
                      Bean bTmp = Tabla .getProvedorIfxServ(strCodigo);                
                      objUsuario.setStrNombreExt(bTmp.getString("4"));
                      objUsuario.setIntCodClinica(Tool.parseInt(bTmp.getString("2")));
                      objUsuario.setIntCodGrupo(Tool.parseInt(bTmp.getString("6")));
                    }
                    
                    BeanList listaFirma = new BeanList();
                    listaFirma = getFirmaUsuario(intCodigo);
                    objUsuario.setLstFirmas(listaFirma);
                    
                }

                return objUsuario;
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getUsuario:" + se);
                return null;
      }
      catch(Exception e)
      {
                System.out.println("Excep getUsuario:" + e);
                return null;
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }  
  }
 
 /*
  * Modificando el metodo para que me retorne
  * una coleccion BeanList 
  * YahirRivas 01MAR2012 11:29AM
  * */
 
  public BeanList listUsuarioRol(int nIdUsuario)
  {

   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   Rol objRol = null;
   BeanList  lstUsuarioRol = new BeanList();
    try
    {
    
                objCnn =  ConexionOracle.getConnectionOracle();
                objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_USUARIOROL_LIST(?,?)}");
                objCstmt.registerOutParameter(1,-10);
                objCstmt.setInt(2, nIdUsuario);
                objCstmt.execute();                
                objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
                
                
                while (objRs.next()){
                  objRol = new Rol();
                  objRol.setNIDROL(objRs.getInt("NIDROL"));
                  objRol.setSNOMBRE(objRs.getString("SNOMBRE"));
                  lstUsuarioRol.add(objRol);
                 // System.out.println("mod_id:" + objModulo.getNIDMODULO());
                  objRol = null;
                }                    
                
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce listRol:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep listRol:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      } 
      return lstUsuarioRol;
  } 
  
  public String getNombOficina(int intCodOficina)
  {  
     Connection objCnn = null;
     CallableStatement objCstmt = null;  
     ResultSet objRs = null;
     String strNombOficina = "";
      try
      {
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call PKG_CONSULTA.P_OFICINA_LIST(?,?)}");
          objCstmt.registerOutParameter(1,-10);
          objCstmt.setInt(2, intCodOficina);
          objCstmt.execute();                
          objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
          
          while (objRs.next())
          {
              strNombOficina = objRs.getString("DESCRIPCION");
          }                               
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getNombOficina:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep getNombOficina:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      }
      return strNombOficina;
  }

  public BeanList getlstOficina()
  {
      Connection objCnn = null;
     CallableStatement objCstmt = null;  
     ResultSet objRs = null;
     BeanList list =  new BeanList();
      try
      {      
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call PKG_CONSULTA.P_OFICINA_LIST(?,?)}");
          objCstmt.registerOutParameter(1,-10);
          objCstmt.setInt(2, 0);
          objCstmt.execute();                
          objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
          
          while (objRs.next())
          {
             list.add(Tool.llenarRegistroCall(objRs));
          }                    
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getlstOficina:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep getlstOficina:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      }
      return list;    
  }
  
  public BeanList getLstUsuario(String strLogin, String strCodServer,  int intCodOficina, int intCodRol)
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
                wCstmt = wCon.prepareCall("{call PKG_SEGURIDAD.P_USUARIO_LIST(?,?,?,?,?)}");
                wCstmt.registerOutParameter(1, -10);
                wCstmt.setString(2, strLogin);
                wCstmt.setString(3, strCodServer);
                wCstmt.setInt(4, intCodOficina);
                wCstmt.setInt(5, intCodRol);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
                while (wRs.next()){
                    lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstUsuario:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstUsuario:" + e);
            }

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
    } 
    
    public BeanList getLstUsuarioIntranet(String strLogin)
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
                wCstmt = wCon.prepareCall("{call PKG_SEGURIDAD.P_USUARIOINTRANET_LIST(?,?)}");
                wCstmt.setString(1, strLogin);
                wCstmt.registerOutParameter(2, -10);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(2);
                while (wRs.next()){
                    lista.add(Tool.llenarRegistroCall(wRs));
                }
                return lista;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getLstUsuario:" + se);
                BeanList beanlist1 = null;
                return lista;
            }
            catch(Exception e)
            {
                System.out.println("Excep getLstUsuario:" + e);
            }

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
    } 
    
  public BeanList getFirmaUsuario(int intCodigo)
  {  
   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   Usuario objUsuario = null;
   BeanList lista = new BeanList(); 
   try
   {
      objCnn =  ConexionOracle.getConnectionOracle();
      objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_FIRMAUSUARIO_LIST(?,?)}"); 		  			
      objCstmt.setInt(1, intCodigo);
      objCstmt.registerOutParameter(2,-10);
      objCstmt.execute();
      objRs = ((OracleCallableStatement)objCstmt).getCursor(2);
    
      while (objRs.next())
      {
          lista.add(Tool.llenarRegistroCall(objRs));
      }
      return lista;

      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getFirmaUsuario:" + se);
                return null;
      }
      catch(Exception e)
      {
                System.out.println("Excep getFirmaUsuario:" + e);
                return null;
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }  
  }
  
  public int insUsuario(Usuario objUsuario, int intIdUser, String strConfFirma)
  {  
   Connection objCnn = null;
   CallableStatement objCstmt = null; 
   PreparedStatement wStmt = null;
   ResultSet objRs = null;
   BeanList lista = new BeanList();

   OutputStream fout = null;
   int resultado = -1;
   try
   {
      objCnn =  ConexionOracle.getConnectionOracle();
    
      objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLUSUARIO_INS(?,?,?,?,?,?,?,?,?,?)}"); 		  			
      objCstmt.registerOutParameter(1, Types.INTEGER);
      objCstmt.setInt(2, objUsuario.getIntIdUsuario());
      objCstmt.setString(3, objUsuario.getStrWebServer());
      objCstmt.setInt(4, intIdUser);
      objCstmt.setInt(5, objUsuario.getIntIdRol());
      objCstmt.setInt(6, objUsuario.getIntCodOficina());
      objCstmt.setString(7, objUsuario.getStrEmail());
      objCstmt.setInt(8, objUsuario.getIntCodBroker());
      objCstmt.setString(9, objUsuario.getStrLogin());
      objCstmt.setInt(10, objUsuario.getIntFlgDeshabilitado());
      objCstmt.execute();
      resultado = objCstmt.getInt(1);
      
      StringTokenizer tkConfFirma = new StringTokenizer(strConfFirma, "-"); 
      while(tkConfFirma.hasMoreTokens()) 
      {
         String strAuxConf = tkConfFirma.nextToken();
         StringTokenizer tkDatos = new StringTokenizer(strAuxConf, "|"); 
         int res = -1;
         while(tkDatos.hasMoreTokens())
         {
            int intTipoSol = Tool.parseInt(tkDatos.nextToken());
            int intOrden = Tool.parseInt(tkDatos.nextToken());
            
            objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLFIRMA_INS(?,?,?,?,?)}"); 		  			
            objCstmt.registerOutParameter(1, Types.INTEGER);
            objCstmt.setInt(2, intTipoSol);
            objCstmt.setInt(3, intOrden);
            objCstmt.setInt(4, objUsuario.getIntIdUsuario());
            objCstmt.setInt(5, objUsuario.getIntCodOficina());
            objCstmt.execute();
            res =  objCstmt.getInt(1);
         }
      } 
      
      //Registro de firma
      objCnn.setAutoCommit(false);
      wStmt = objCnn.prepareStatement("SELECT BFIRMA FROM PTBLUSUARIO WHERE NIDUSUARIO = ? FOR UPDATE");      
      wStmt.setInt(1, objUsuario.getIntIdUsuario());
      objRs=wStmt.executeQuery();
      if (objRs.next())
      {
        Blob blob = ((OracleResultSet)objRs).getBLOB("BFIRMA");
        //fout = blob.getBinaryOutputStream();
        fout = blob.setBinaryStream(1L);
        fout.write(objUsuario.getFirma());
        fout.flush();
        fout.close();
        blob = null;
      }
      wStmt.clearParameters();
      
      return resultado;
      
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insUsuario:" + se);
                return -1;
      }
      catch(Exception e)
      {
                System.out.println("Excep insUsuario:" + e);
                return -1;
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }  
  }
  
  public int updUsuario(Usuario objUsuario, String strConfFirma, String strConFirmaDel)
  {  
   Connection objCnn = null;
   CallableStatement objCstmt = null;  
   ResultSet objRs = null;
   BeanList lista = new BeanList(); 
   PreparedStatement wStmt = null;
   OutputStream fout = null;
   int resultado = -1;
   try
   {
      objCnn =  ConexionOracle.getConnectionOracle();
      objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLUSUARIO_UPD(?,?,?,?,?,?,?,?)}"); 		  			
      objCstmt.registerOutParameter(1, Types.INTEGER);
      objCstmt.setInt(2, objUsuario.getIntIdUsuario());
      objCstmt.setString(3, objUsuario.getStrWebServer());      
      objCstmt.setInt(4, objUsuario.getIntFlgActivo());
      objCstmt.setInt(5, objUsuario.getIntIdRol());
      objCstmt.setInt(6, objUsuario.getIntCodOficina());
      objCstmt.setString(7, objUsuario.getStrEmail());
      //Inicio - Req. 2014-000561 Paradigmasoft GJB
      objCstmt.setInt(8,objUsuario.getIntFlgDeshabilitado());
      //Fin - Req. 2014-000561 Paradigmasoft GJB
      objCstmt.execute();
      resultado = objCstmt.getInt(1);
      
      if(resultado!=-1)
      {
          int res = -1;
          if(objUsuario.getIntFlgFirma()==0)
          {
              objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLFIRMA_DEL(?,?,?)}"); 		  			
              objCstmt.registerOutParameter(1, Types.INTEGER);
              objCstmt.setInt(2, 0);
              objCstmt.setInt(3, objUsuario.getIntIdUsuario());
              objCstmt.execute();
              res =  objCstmt.getInt(1);
          }
          else
          {
              
              StringTokenizer tkConfFirma = new StringTokenizer(strConFirmaDel, "|"); 
              while(tkConfFirma.hasMoreTokens()) 
              {
                    int intTipoSol = Tool.parseInt(tkConfFirma.nextToken());
                 
                    objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLFIRMA_DEL(?,?,?)}"); 		  			
                    objCstmt.registerOutParameter(1, Types.INTEGER);
                    objCstmt.setInt(2, intTipoSol);
                    objCstmt.setInt(3, objUsuario.getIntIdUsuario());
                    objCstmt.execute();
                    res =  objCstmt.getInt(1);
              } 
        
              tkConfFirma = new StringTokenizer(strConfFirma, "-"); 
              while(tkConfFirma.hasMoreTokens()) 
              {
                 String strAuxConf = tkConfFirma.nextToken();
                 StringTokenizer tkDatos = new StringTokenizer(strAuxConf, "|"); 
                 res = -1;
                 while(tkDatos.hasMoreTokens())
                 {
                    int intTipoSol = Tool.parseInt(tkDatos.nextToken());
                    int intOrden = Tool.parseInt(tkDatos.nextToken());
                    
                    objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_PTBLFIRMA_INS(?,?,?,?,?)}"); 		  			
                    objCstmt.registerOutParameter(1, Types.INTEGER);
                    objCstmt.setInt(2, intTipoSol);
                    objCstmt.setInt(3, intOrden);
                    objCstmt.setInt(4, objUsuario.getIntIdUsuario());
                    objCstmt.setInt(5, objUsuario.getIntCodOficina());
                    objCstmt.execute();
                    res =  objCstmt.getInt(1);
                 }
              }
              
              if (objUsuario.getFirma() != null && objUsuario.getFirma().length>0)
              {
                  //Registro de firma
                  objCnn.setAutoCommit(false);
                  wStmt = objCnn.prepareStatement("SELECT BFIRMA FROM PTBLUSUARIO WHERE NIDUSUARIO = ? FOR UPDATE");      
                  wStmt.setInt(1, objUsuario.getIntIdUsuario());
                  objRs=wStmt.executeQuery();
                  if (objRs.next())
                  {
                    Blob blob = ((OracleResultSet)objRs).getBLOB("BFIRMA");
                    //fout = blob.getBinaryOutputStream();
                    fout = blob.setBinaryStream(1L);
                    fout.write(objUsuario.getFirma());
                    fout.flush();
                    fout.close();
                    blob = null;
                  }
                  wStmt.clearParameters();
              }
          }
      }
      return resultado;
      
      }
      catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce updUsuario:" + se);
                return -1;
      }
      catch(Exception e)
      {
                e.printStackTrace();
                System.out.println("Excep updUsuario:" + e);
                return -1;
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }
      }  
  }
  
  public byte[] getFileFirmaBin(int idusuario)
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        Blob archivo=null;
        byte[] buf=null;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call PKG_SEGURIDAD.P_USERFIRMA_GET(?,?)}");
                wCstmt.setInt(1, idusuario);
                wCstmt.registerOutParameter(2, -10);
                wCstmt.execute();
                wRs = ((OracleCallableStatement)wCstmt).getCursor(2);
                if (wRs.next()){                  
                  archivo=wRs.getBlob("BFIRMA");  
                  //System.out.println("archivo:" + archivo + " long:" + archivo.length());
                  if (!(archivo==null)){
                  int c = (int)archivo.length();
                  buf = archivo.getBytes(1, c);
                  }

                }
                
                return buf;
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce getFileFirmaBin:" + se);
                return null;
            }}
            catch(Exception e)
            {
                System.out.println("Excep getFileFirmaBin:" + e);
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
              return null;            }
            }
    }
    
    public Usuario getUsuarioShare(String  strUser)
    {  
        Connection objCnn = null;
        CallableStatement objCstmt = null;  
        ResultSet objRs = null;
        Usuario objUsuario = null;
        try
        {
    
            objCnn =  ConexionOracle.getConnectionOracle();
            objCstmt = objCnn.prepareCall("{call PKG_SEGURIDAD.P_USUARIOSHARE_GET(?,?)}"); 		  			
            objCstmt.registerOutParameter(1,-10);
            objCstmt.setString(2, strUser);    
            objCstmt.execute();
            objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
            if (objRs.next())
            {         
                objUsuario = new Usuario();
                objUsuario.setNIDUSUARIO(objRs.getInt("NIDUSUARIO"));
                objUsuario.setIntIdRol(objRs.getInt("NIDROL"));
                objUsuario.setIntCodOficina(objRs.getInt("NCODOFICINA"));
                objUsuario.setStrLogin(objRs.getString("LOGIN")); 
                
                objUsuario.setIntFlgActivo(objRs.getInt("NFLGACTIVO"));
                objUsuario.setStrEmail(objRs.getString("SEMAIL"));
                objUsuario.setIntCodBroker(Tool.parseInt(objRs.getString("NCODBROKER")));
                
                String strCodigo = objRs.getString("SCODIGO");
                objUsuario.setStrWebServer(strCodigo);
                if (strCodigo!= null && !strCodigo.equals(""))
                {
                    Bean bTmp = Tabla .getProvedorIfxServ(strCodigo);                
                    objUsuario.setStrNombreExt(bTmp.getString("4"));
                    objUsuario.setIntCodClinica(Tool.parseInt(bTmp.getString("2")));
                    objUsuario.setIntCodGrupo(Tool.parseInt(bTmp.getString("6")));
                }
                
            }
      
            return objUsuario;
      }
      catch(SQLException se)
      {
          se.printStackTrace();
          System.out.println("SQLExce getUsuario:" + se);
          return null;
      }
      catch(Exception e)
      {
          System.out.println("Excep getUsuario:" + e);
          return null;
      }
      finally
      {
          try
          {
              if(objRs != null)
                  objRs.close();
              if(objCstmt != null)
                  objCstmt.close();
              if(objCnn != null)
                  objCnn.close();
          }
          catch(SQLException sqlexception)
          {
          
          }
      }  
  }
  
  public Bean getUsuarioGenerico(int intIdUsuario)
  {
      ResultSet wRs = null;
      Connection wCon = null;
      CallableStatement wCstmt = null;
      
      Bean usuario = new Bean();
      try
      {
          try
          {
              wCon = ConexionOracle.getConnectionOracle();
              wCstmt = wCon.prepareCall("{call SP_APP.PKG_SEGURIDAD.SP_USUARIOGENERICO_GET(?,?)}");
              wCstmt.setInt(1, intIdUsuario);
              wCstmt.registerOutParameter(2, OracleTypes.CURSOR);
              wCstmt.execute();
              wRs = ((OracleCallableStatement)wCstmt).getCursor(2);
              if(wRs.next())
                  usuario = Tool.llenarRegistroCall(wRs);
              else
                  usuario = null;
          }
          catch(SQLException se)
          {
              se.printStackTrace();
              System.out.println("SQLExce getUsuarioGenerico:" + se);
              usuario = null;
          }
          catch(Exception e)
          {
              e.printStackTrace();
              System.out.println("Excep getUsuarioGenerico:" + e);
              usuario = null;
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
              sqlexception.printStackTrace();
              usuario = null;
          }
      }
      return usuario;
  }
  
  public int updUsuGenPassword(int intIdUsuario, String strPassword)
  {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        int intResult = -1;
        try
        {
            try
            {
                wCon = ConexionOracle.getConnectionOracle();
                wCstmt = wCon.prepareCall("{call SP_APP.PKG_SEGURIDAD.SP_USUGENPASSWORD_UPD(?,?,?)}");
                wCstmt.setInt(1, intIdUsuario);
                wCstmt.setString(2, strPassword);
                wCstmt.registerOutParameter(3, OracleTypes.INTEGER);
                wCstmt.execute();
                intResult = ((OracleCallableStatement)wCstmt).getInt(3);
            }
            catch(SQLException se)
            {
                se.printStackTrace();
                System.out.println("SQLExce updUsuGenPassword:" + se);
                intResult = -1;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                System.out.println("Excep updUsuGenPassword:" + e);
                intResult = -1;
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
                sqlexception.printStackTrace();
                intResult = -1;
            }
        }
        return intResult;
    }

    //Req 2011-0660
    public BeanList getOficinasConfiguracionUsuario(int intIdUsuario) 
    {
        ResultSet wRs = null;
        Connection wCon = null;
        CallableStatement wCstmt = null;
        BeanList lista = new BeanList();
        try
        {
            wCon = ConexionOracle.getConnectionOracle();
            wCstmt = wCon.prepareCall("{call PKG_CONSULTA.P_PTBLOFICINA_USUARIO_DESCRIPT(?,?)}");
            wCstmt.registerOutParameter(1, -10);
            wCstmt.setInt(2, intIdUsuario);
            wCstmt.execute();
            wRs = ((OracleCallableStatement)wCstmt).getCursor(1);
            while (wRs.next()) {
                lista.add(Tool.llenarRegistroCall(wRs));
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            try
            {
            if(wRs != null)
                wRs.close();
            if(wCstmt != null)
                wCstmt.close();
            if(wCon != null)
                wCon.close();
            }
            catch(SQLException se)
            {
                se.printStackTrace();
            }
        }
        return lista;
    }
    ////Req 2011-0660
    
  //RQ2015-000750 INICIO
  public BeanList getlstZona()
  {
     Connection objCnn = null;
     CallableStatement objCstmt = null;  
     ResultSet objRs = null;
     BeanList list =  new BeanList();
      try
      {      
          objCnn =  ConexionOracle.getConnectionOracle();
          objCstmt = objCnn.prepareCall("{call PKG_AVISOGERENCIA.P_ZONA_LIST(?,?)}");
          objCstmt.registerOutParameter(1,-10);
          objCstmt.setInt(2, 0);
          objCstmt.execute();                
          objRs = ((OracleCallableStatement)objCstmt).getCursor(1);
          
          while (objRs.next())
          {
             list.add(Tool.llenarRegistroCall(objRs));
          }                    
      }
     catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getlstZona:" + se);

      }
      catch(Exception e)
      {
                System.out.println("Excep getlstZona:" + e);
      }
      finally
      {
            try
            {
                if(objRs != null)
                    objRs.close();
                if(objCstmt != null)
                    objCstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
            catch(SQLException sqlexception)
            {
            }            
      }
      return list;    
  }     
  
  public BeanList getlstOficinaCore()
  {     
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    int intSiniestro=0;
    try
      {
          objCnn = ConexionIFX.getConnection();
          objCstmt = objCnn.prepareCall("{call sp_rea_oficina_wc(?)}");
          objCstmt.setString(1,"1");
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
          System.out.println("SQLExce getlstOficinaCore:" + se);
          return null;
      }
    catch(Exception e)
      {
          System.out.println("Excep getlstOficinaCore:" + e);
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
  //RQ2015-000750 FIN
    
}

