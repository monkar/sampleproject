package com.clinica.daos;

import com.clinica.beans.ConceptoProducto;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.beans.*;
import com.clinica.utils.Constante;
import com.clinica.utils.Tool;
import com.clinica.utils.coneccion.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.StringTokenizer;
import java.util.ArrayList;



public class PolClinicDAOImpl implements PolClinicDAO
{

  public boolean insPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    String strNroAutoriza ="";
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call ins_pol_clinic(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, objPolcli.getIntBranch());
                objCstmt.setInt(2, objPolcli.getIntPolicy());
                objCstmt.setInt(3, objPolcli.getIntCover());
                objCstmt.setInt(4, objPolcli.getIntModalidad());
                objCstmt.setInt(5, objPolcli.getIntTariff());
                objCstmt.setInt(6, objPolcli.getIntRed());
                objCstmt.setString(7, objPolcli.getDEffecdate());
                objCstmt.setInt(8, intUserCode);
                objCstmt.setInt(9, objPolcli.getIntCodClinic());
                objCstmt.setDouble(10, objPolcli.getDblDed_amount());
                objCstmt.setDouble(11, objPolcli.getDblDed_percen());
                objCstmt.setDouble(12, objPolcli.getDblIndem_rate());
                objCstmt.setDouble(13, objPolcli.getDblLimit());
                objCstmt.setInt(14, objPolcli.getIntPay_concep());
                objCstmt.setInt(15, objPolcli.getIntDed_quanti());
                objCstmt.setInt(16, intIdUsuario);
                objCstmt.setString(17, "INS");
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                }
                return true;
    }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep insPolclinic:" + e);
                return false;
                
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
                return false;
            }
      }

  }
  
 /* public static boolean insPolclinic(Pol_Clinic objPolcli, int intIdUsuario)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    boolean ret = false;
    try
      {
            String sql = "insert into pol_clinic (" +
                         "usercomp, company, " + 
                         "certype, branch," +
                         "policy,compdate," +
                         "usercode,clinic_cod," +
                         "effecdate,nulldate," +
                         "modalidad,cover," +
                         "tariff,ded_amount," +
                         "ded_percen,indem_rate," +
                         "limit,red,"+
                         "pay_concep,ded_quanti)" +
                         "values (" +
                         objPolcli.getIntUsercomp() + "," + objPolcli.getIntCompany() + ",'" + 
                         objPolcli.getStrCertype() + "'," + objPolcli.getIntBranch() + "," + 
                         objPolcli.getIntPolicy() + ",today," + 
                         Constante.NUSERCODE + "," + objPolcli.getIntCodClinic() + ",'" + 
                         objPolcli.getDEffecdate() + "'," + "null" + "," + 
                         objPolcli.getIntModalidad() + "," +objPolcli.getIntCover() + "," + 
                         objPolcli.getIntTariff() + "," + objPolcli.getDblDed_amount() + "," + 
                         objPolcli.getDblDed_percen() + "," + objPolcli.getDblIndem_rate() + "," + 
                         objPolcli.getDblLimit() + "," + objPolcli.getIntRed() + "," + 
                         objPolcli.getIntPay_concep() + "," + objPolcli.getIntDed_quanti() + ")";
            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objPstmt.execute();
            insPolclinicLog(objPolcli,intIdUsuario,"INS");
            return true;

      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep insPolclinic:" + e);
                return false;
                
      }
    finally
      {
        try
            {
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }
  */  
  public boolean delPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    boolean ret = false;
    //Inicio RQ2018-1627-CPHQ
    ResultSet objRs = null;
    CallableStatement objCstmt = null;
    int var_poliza = 0;
    int product = 0;
    int sub_product = 0;
    //Fin RQ2018-1627-CPHQ
    try
      {
            //Inicio RQ2018-1627-CPHQ
            objCnn = ConexionIFX.getConnection();
            objCstmt = objCnn.prepareCall("{call get_polclinic_valid(?,?,?,?,?,?,?,?,?,?,?)}");
            objCstmt.setInt(1, objPolcli.getIntBranch());
            objCstmt.setInt(2, objPolcli.getIntPolicy());
            objCstmt.setInt(3, objPolcli.getIntCodClinic());
            objCstmt.setString(4, "");      
            objCstmt.setInt(5, objPolcli.getIntTariff());                 
            objCstmt.setInt(6, objPolcli.getIntModalidad()); 
            objCstmt.setInt(7, objPolcli.getIntCover()); 
            objCstmt.setInt(8, objPolcli.getIntRed()); 
            objCstmt.setString(9, objPolcli.getDEffecdate()); 
            objCstmt.setInt(10, 1); 
            objCstmt.setInt(11, 1); 
        
              objRs = objCstmt.executeQuery();
              while ( objRs.next() )
              {
                  var_poliza = objRs.getInt(1);
                  product  = objRs.getInt(2);
                  sub_product = objRs.getInt(3);
              }    
                        /*String sql = "delete from pol_clinic where usercomp=1 and company=1 " +
                                     " and certype = '2' and branch = " + objPolcli.getIntBranch() +
                                     " and clinic_cod = " + objPolcli.getIntCodClinic() +
                                     " and policy = " + objPolcli.getIntPolicy() + 
                                     " and cover = " + objPolcli.getIntCover() +
                                     " and modalidad = " + objPolcli.getIntModalidad()  +
                                     " and tariff = " + objPolcli.getIntTariff() +
                                     " and red=" + objPolcli.getIntRed();*/

            String sql = "update pol_clinic set nulldate = today, statregt = 4 " +
                         " where usercomp=1 and company=1 " +
                         " and certype = '2' and branch = " + objPolcli.getIntBranch() +
                         " and product  = " + product + 
                         " and sub_product = " + sub_product + 
                         " and policy = " + var_poliza +
                         " and clinic_cod = " + objPolcli.getIntCodClinic() +
                         " and cover = " + objPolcli.getIntCover() +
                         " and modalidad = " + objPolcli.getIntModalidad()  +
                         " and tariff = " + objPolcli.getIntTariff() +
                         " and red=" + objPolcli.getIntRed() +
                         " and effecdate  <= '" + objPolcli.getDEffecdate() +
                         "' and (nulldate  is null " +
                         " or nulldate   > '" + objPolcli.getDEffecdate() + "') " +
                         " and statregt = 1";
                        
            objPstmt = objCnn.prepareStatement(sql);
            objPstmt.execute();
            insPolclinicLog(objPolcli,intIdUsuario,intUserCode, "DEL");
            return true;
            //Fin RQ2018-1627-CPHQ
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep insPolclinic:" + e);
                return false;
                
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
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }  

   public BeanList lstPol_Clinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                        int intTariff,int intRed, String dEffeccdate, int intConcep)
 {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sel_pol_clinic(?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, intBranch);
                objCstmt.setInt(2, intPolicy);
                objCstmt.setInt(3, intCover);
                objCstmt.setInt(4, intModalidad);
                objCstmt.setInt(5, intTariff);
                objCstmt.setInt(6, intRed);
                objCstmt.setString(7, dEffeccdate);
                objCstmt.setInt(8, intConcep);                
                objRs = objCstmt.executeQuery();
                Pol_Clinic objPolclinic = null;
                while ( objRs.next() )
                {
                  //objList.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                  objPolclinic =  new Pol_Clinic();
                  objPolclinic.setStrClinica(objRs.getString(1));
                  objPolclinic.setStrModalidad(objRs.getString(2));
                  objPolclinic.setStrConcepto(objRs.getString(3));
                  objPolclinic.setStrTipoDedu(objRs.getString(4));
                  objPolclinic.setIntDed_quanti(objRs.getInt(5));
                  objPolclinic.setDblDed_amount(objRs.getDouble(6));
                  objPolclinic.setDblDed_percen(objRs.getDouble(7));
                  objPolclinic.setDblIndem_rate(objRs.getDouble(8));
                  objPolclinic.setIntCodClinic(objRs.getInt(9));
                  objPolclinic.setIntCover(objRs.getInt(10));
                  objPolclinic.setIntRed(objRs.getInt(11));
                  objPolclinic.setIntModalidad(objRs.getInt(12)); 
                  objPolclinic.setIntPay_concep(objRs.getInt(13));
                  objPolclinic.setDEffecdate(objRs.getString(14));
                  objPolclinic.setDblLimit(objRs.getDouble(15));
                  objList.add(objPolclinic);                  
                  objPolclinic = null;
                  
                }

                return objList;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce lstPol_Clinic:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep lstPol_Clinic:" + e);
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

   public Poliza getPoliza(int intBranch, int intPolicy, int intFlgValida)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;        
        String sql ="";
        Poliza objPoliza = null; 
        try
        {
            if(intFlgValida==1)
                sql="select product,politype,office,colinvot,bussityp from POLICY " +
                    " where usercomp=1 and company=1 " +
                    " and certype='2' and branch=" +intBranch +" and policy="+intPolicy + 
                    " and effecdate <= today and (expirdat is null or expirdat > today) " +
                    " and (nulldate is null or nulldate > today)";            
            else
                sql="select product,politype,office,colinvot,bussityp from POLICY " +
                    " where usercomp=1 and company=1 " +
                    " and certype='2' and branch=" +intBranch +" and policy="+intPolicy;
             
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();   
            if(objRs.next())
            {         
                  objPoliza = new Poliza();
                  //objBean = Tool.llenarRegistroIfx(objRs, objPstmt);
                  objPoliza.setIntBranch(intBranch);
                  objPoliza.setIntPolicy(intPolicy);
                  objPoliza.setIntProduct(objRs.getInt("product"));
            }
            objRs.close();
            objPstmt.close();
            
            if(objPoliza != null)
            {
                if (objPoliza.getIntProduct()>0)
                {
                  /*
                    sql="select short_des from product pr " + 
                        "where pr.usercomp = 1 and pr.company = 1 " + 
                        "and pr.branch = " +intBranch +" and pr.product = "  + objPoliza.getIntProduct() +
                        "and pr.nulldate is null";
                  */
                  //2012-0078
                     sql="select pr.short_des, c.max_mount from product pr, " +
                         "outer(conf_maxmount_prod c) " + 
                         "where pr.usercomp = 1 and pr.company = 1 " + 
                         "and pr.branch = " +intBranch +" and pr.product = " + objPoliza.getIntProduct() +                                                                          
                         "  and pr.nulldate is null "+
                         "  and c.branch = pr.branch and c.product = pr.product "; 
                    //2012-0078
                    objPstmt = objCnn.prepareStatement(sql);
                    objRs = objPstmt.executeQuery();            
                    if(objRs.next())
                    {
                          objPoliza.setStrDesProduct(objRs.getString("short_des"));
                          /*P2012-0078*/
                          try{
                                double dblMaxMontoCoaseguro = objRs.getDouble("max_mount");
                                objPoliza.setDblMaxMontoCoaseguro(dblMaxMontoCoaseguro);
                            }
                          catch (Exception e){                                                         
                            }
                          /*P2012-0078*/
                    }
                    objRs.close();
                    objPstmt.close();
                }
              
                sql="select c.cliename " + 
                    "from roles r, client c " +
                    "where r.usercomp = 1 and r.company = 1 and r.certype = '2' " + 
                    "and r.branch =  " +intBranch + " and r.policy = " + intPolicy +
                    "and r.certif = 0 and r.role = 1 and c.code = r.client " +
                    "and r.nulldate is null";
                    
                objPstmt = objCnn.prepareStatement(sql);
                objRs = objPstmt.executeQuery();
                if(objRs.next())
                {
                      objPoliza.setStrContrat(objRs.getString("cliename"));
                }           
              
                /*sql="select currency " +
                   " from curren_pol " +
                   " where usercomp = 1  and company  = 1  and     certype  = '2' "+
                   " and branch = " +intBranch + " and policy = " + intPolicy +
                   " and certif = 0"; Comentado: Codigo Antes del 2012-0078*/
                
                /*2012-0078*/
                sql="select p.currency, c.descript[27,30] " +
                   " from curren_pol p, outer(table11 c)" +
                   " where p.usercomp = 1  and p.company = 1  and p.certype  = '2' "+
                   " and p.branch = " +intBranch + " and p.policy = " + intPolicy +
                   " and p.certif = 0 and c.company = p.company and statregt = 1 and " +
                   " c.codigint = p.currency";
                /*2012-0078*/
                
                objPstmt = objCnn.prepareStatement(sql);
                objRs = objPstmt.executeQuery();
                if(objRs.next())
                {
                      objPoliza.setIntCurrrency(objRs.getInt("currency"));
                } 
            }
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
        return objPoliza;
    }   

  public boolean valinsPolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    ResultSet objRs = null;
    boolean ret = false;
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
          objCstmt.setInt(1, intBranch);
          objCstmt.setInt(2, intPolicy);
          objCstmt.setInt(3, intCodClinic);
          objCstmt.setString(4, "");  
          objCstmt.setString(5, null); 
          objCstmt.setString(6, null); 
          objCstmt.setString(7, null); 
          objCstmt.setInt(8, intRed); 
          objCstmt.setString(9, null); 
          objCstmt.setInt(10, 1);
          objCstmt.setInt(11, 2);
          objRs = objCstmt.executeQuery();
          while ( objRs.next() )
          {
              var_poliza = objRs.getInt(1);
              product  = objRs.getInt(2);
              sub_product = objRs.getInt(3);
          }
                  
            String sql = "select count(*) n  from pol_clinic p where p.usercomp=1 and p.company=1 " +
                        " and p.certype = '2' and p.branch = " + intBranch +
                        " and p.product  = " + product + 
                        " and p.sub_product = " + sub_product +
                        " and p.policy = " + var_poliza +
                        " and p.clinic_cod = " + intCodClinic +
                        " and p.red <>" + intRed +
                        " and p.effecdate  <= today " +
                        " and (p.nulldate  is null " +
                        " or p.nulldate   > today )" +
                        " and statregt = 1";
                        
            //Fin RQ2018-1627-CPHQ         
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                ret = (objRs.getInt("n")==0?true:false);
            }            
                        
            if (ret){
                
            //Inicio RQ2018-1627-CPHQ
            objCstmt = objCnn.prepareCall("{call get_polclinic_valid(?,?,?,?,?,?,?,?,?,?,?)}");
            objCstmt.setInt(1, intBranch);
            objCstmt.setInt(2, intPolicy);
            objCstmt.setInt(3, intCodClinic);
            objCstmt.setString(4, "");  
            objCstmt.setInt(5, intTariff); 
            objCstmt.setInt(6, intModalidad); 
            objCstmt.setInt(7, intCover); 
            objCstmt.setInt(8, intRed); 
            objCstmt.setString(9, null); 
            objCstmt.setInt(10, 1);
            objCstmt.setInt(11, 3);
            objRs = objCstmt.executeQuery();
            while ( objRs.next() )
            {
                var_poliza = objRs.getInt(1);
                product  = objRs.getInt(2);
                sub_product = objRs.getInt(3);
            }      
            
            sql = "select count(*) n  from pol_clinic p where p.usercomp=1 and p.company=1 " +
                    " and p.certype = '2' and p.branch = " + intBranch +
                    " and p.product  = " + product + 
                    " and p.sub_product = " + sub_product + 
                    " and p.policy =" + var_poliza +
                    " and p.clinic_cod = " + intCodClinic +
                    " and p.cover = " + intCover +
                    " and p.modalidad = " + intModalidad  +
                    " and p.tariff = " + intTariff +
                    " and p.red=" + intRed +
                    " and p.effecdate  <= today "  +                           
                    " and (p.nulldate  is null " +
                    " or p.nulldate   > today)" +
                    " and statregt = 1";
            
            //Fin RQ2018-1627-CPHQ
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                ret = (objRs.getInt("n")==0?true:false);
            }       
        }
        return ret;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce valPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep valPolclinic:" + e);
                return false;
                
      }
    finally
      {
        try
            {
                if(objCstmt!=null)
                    objCstmt.close();
                if(objRs != null)
                    objRs.close();           
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }  

 public boolean updPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode)
  {
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    int intReturn =-1;
    String strNroAutoriza ="";
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call upd_pol_clinic(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, objPolcli.getIntBranch());
                objCstmt.setInt(2, objPolcli.getIntPolicy());
                objCstmt.setInt(3, objPolcli.getIntCover());
                objCstmt.setInt(4, objPolcli.getIntModalidad());
                objCstmt.setInt(5, objPolcli.getIntTariff());
                objCstmt.setInt(6, objPolcli.getIntRed());
                objCstmt.setString(7, objPolcli.getDEffecdate());
                objCstmt.setInt(8, intUserCode);
                objCstmt.setInt(9, objPolcli.getIntCodClinic());
                objCstmt.setDouble(10, objPolcli.getDblDed_amount());
                objCstmt.setDouble(11, objPolcli.getDblDed_percen());
                objCstmt.setDouble(12, objPolcli.getDblIndem_rate());
                objCstmt.setDouble(13, objPolcli.getDblLimit());
                objCstmt.setInt(14, objPolcli.getIntPay_concep());
                objCstmt.setInt(15, objPolcli.getIntDed_quanti());
                objCstmt.setInt(16, intIdUsuario);
                objCstmt.setString(17, "UPD");
                objRs = objCstmt.executeQuery();
                if (objRs.next())
                {
                  intReturn = objRs.getInt(1);
                }
                if (intReturn ==0) 
                  return true;
                else
                  return false;
    }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce updPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep updPolclinic:" + e);
                return false;
                
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
                return false;
            }
      }

  }
 /* public static boolean updPolclinic(Pol_Clinic objPolcli, int intIdUsuario)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    boolean ret = false;
    try
      {
            String sql = "update pol_clinic set " +
                         " ded_amount = "  + objPolcli.getDblDed_amount() + 
                         ", ded_percen = " + objPolcli.getDblDed_percen() +
                         ", indem_rate = " + objPolcli.getDblIndem_rate() +
                         ", limit = " + objPolcli.getDblLimit() + 
                         ", ded_quanti = " + objPolcli.getIntDed_quanti() +
                         " where usercomp=1 and company=1 " +
                         " and certype = '2' and branch = " + objPolcli.getIntBranch() +
                         " and clinic_cod = " + objPolcli.getIntCodClinic() +
                         " and policy = " + objPolcli.getIntPolicy() + 
                         " and cover = " + objPolcli.getIntCover() +
                         " and modalidad = " + objPolcli.getIntModalidad()  +
                         " and tariff = " + objPolcli.getIntTariff() +
                         " and red=" + objPolcli.getIntRed();
           
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objPstmt.execute();
            insPolclinicLog(objPolcli,intIdUsuario,"UPD");
            return true;

      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce updPolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep updPolclinic:" + e);
                return false;
                
      }
    finally
      {
        try
            {
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }  */ 

  public boolean insPolclinicLog(Pol_Clinic objPolcli, int idUsuario, int intUserCode, String strAcc)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    boolean ret = false;
    try
      {
            String sql = "insert into pol_clinic_log (" +
                         "usercomp, company, " + 
                         "certype, branch," +
                         "policy,compdate," +
                         "usercode,clinic_cod," +
                         "effecdate,nulldate," +
                         "modalidad,cover," +
                         "tariff,ded_amount," +
                         "ded_percen,indem_rate," +
                         "limit,red,"+
                         "pay_concep, ded_quanti," +
                         "iduserint, action )" +
                         "values (" +
                         objPolcli.getIntUsercomp() + "," + objPolcli.getIntCompany() + ",'" + 
                         objPolcli.getStrCertype() + "'," + objPolcli.getIntBranch() + "," + 
                         objPolcli.getIntPolicy() + ",today," + 
                         intUserCode + "," + objPolcli.getIntCodClinic() + "," + 
                         ("".equals(objPolcli.getDEffecdate()) || objPolcli.getDEffecdate()==null?"null":"'" + objPolcli.getDEffecdate() + "'") +
                         "," + "null" + "," + 
                         objPolcli.getIntModalidad() + "," +objPolcli.getIntCover() + "," + 
                         objPolcli.getIntTariff() + "," + objPolcli.getDblDed_amount() + "," + 
                         objPolcli.getDblDed_percen() + "," + objPolcli.getDblIndem_rate() + "," + 
                         objPolcli.getDblLimit() + "," + objPolcli.getIntRed() + "," + 
                         objPolcli.getIntPay_concep() + "," + objPolcli.getIntDed_quanti() + "," +
                         idUsuario + ",'" + strAcc + "')";
            
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objPstmt.execute();
            return true;

      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce insPolclinicLog:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep insPolclinicLog:" + e);
                return false;
                
      }
    finally
      {
        try
            {
                if(objPstmt != null)
                    objPstmt.close();
                if(objCnn != null)
                    objCnn.close();
            }
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }
 
    public boolean valDatePolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate)
                                        
 {
    Connection objCnn = null;
    PreparedStatement objPstmt = null;
    ResultSet objRs = null;
    boolean ret = false;
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
            objCstmt.setInt(1, intBranch);
            objCstmt.setInt(2, intPolicy);
            objCstmt.setInt(3, intCodClinic);
            objCstmt.setString(4, "");  
            objCstmt.setInt(5, intTariff); 
            objCstmt.setInt(6, intModalidad); 
            objCstmt.setInt(7, intCover); 
            objCstmt.setInt(8, intRed); 
            objCstmt.setString(9, null); 
            objCstmt.setInt(10, 1);
            objCstmt.setInt(11, 3);
            objRs = objCstmt.executeQuery();
            objRs = objCstmt.executeQuery();
            while ( objRs.next() )
            {
                var_poliza = objRs.getInt(1);
                product  = objRs.getInt(2);
                sub_product = objRs.getInt(3);
            }            
                  
            String sql = "select case when max(nulldate)>'" + strEffecdate + "' then 0 else 1 end  n" +
                         " from pol_clinic p where p.usercomp=1 and p.company=1 " +
                         " and p.certype = '2' and p.branch = " + intBranch +
                         " and p.product = " + product + 
                         " and p.sub_product = " + sub_product +
                         " and p.policy =" + var_poliza +
                         " and p.clinic_cod = "  + intCodClinic +
                         " and p.cover = " + intCover +
                         " and p.modalidad = " + intModalidad  +
                         " and p.tariff = " + intTariff +
                         " and p.red=" + intRed +                         
                         " and p.effecdate  <= today " +
                         " and p.nulldate  is not null ";
            //" and statregt = 1";         
            //Fin RQ2018-1627-CPHQ      
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery();
            if(objRs.next())
            {
                ret = (objRs.getInt("n")==0?false:true);
            }            
                        
            return ret;
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce valDatePolclinic:" + se);
                return false;
      }
    catch(Exception e)
      {
                System.out.println("Excep valDatePolclinic:" + e);
                return false;
                
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
        catch(SQLException sqlexception)
            {
                return false;
            }
      }

  }  

  public Bean getMonedaPoliza(int intPoliza)
  {     
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      int intReturn =-1;
      Bean objBean = null;
      try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_curren_pol(?,?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, 1);//usercomp
                objCstmt.setInt(2, 1);//company
                objCstmt.setString(3, "2");//certype
                objCstmt.setInt(4, Constante.NRAMOASME);
                objCstmt.setInt(5, intPoliza);
                objCstmt.setInt(6, 0);//ccertif
                objCstmt.setString(7, Tool.getDate("dd/MM/yyyy"));//effecdate
                objCstmt.setString(8,"S");//type_mov
                objRs = objCstmt.executeQuery();
                if(objRs.next())
                {
                   objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
             
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getMonedaPoliza:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getMonedaPoliza:" + e);
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
  
  public BeanList getCoberturaPoliza(int intProducto, int intMoneda)
  {     
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      int intReturn =-1;
      BeanList objLista = null;
      try
      {
                objLista = new BeanList();
                
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_cover_emire(?,?,?,?,?,?,?)}");
                objCstmt.setInt(1, 1);//usercomp
                objCstmt.setInt(2, 1);//company
                objCstmt.setInt(3, Constante.NRAMOASME);
                objCstmt.setInt(4, intProducto);
                objCstmt.setInt(5, intMoneda);
                objCstmt.setInt(6, 0);//cover
                objCstmt.setString(7, Tool.getDate("dd/MM/yyyy"));//efeccdate
                objRs = objCstmt.executeQuery();
                
                while (objRs.next())
                {
                  objLista.add(Tool.llenarRegistroCallIfx(objRs,objCstmt));
                }  
                
                return objLista;
             
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getCoberturaPoliza:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getCoberturaPoliza:" + e);
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

public Bean getContratante(int intPoliza, int  intCertificado)
  {     
      Connection objCnn = null;
      CallableStatement objCstmt = null;
      ResultSet objRs = null;
      int intReturn =-1;
      Bean objBean = null;
      try
      {
  
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call sp_rea_contratante(?,?,?)}");
                objCstmt.setInt(1, intPoliza);
                objCstmt.setInt(2, intCertificado);
                objCstmt.setInt(3, Constante.NRAMOASME);
                
                objRs = objCstmt.executeQuery();
                if(objRs.next())
                {
                   objBean = Tool.llenarRegistroCallIfx(objRs,objCstmt);
                }
                return objBean;
             
      }
    catch(SQLException se)
      {
                se.printStackTrace();
                System.out.println("SQLExce getContratante:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getContratante:" + e);
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
  
  public ArrayList getLstCobertura( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado,AtencionDAO atencion,int intRamo,int intCaso)
  {
      int intRet = -1;
    
      BeanList objLista = null;
      objLista = atencion.lstCobertura(intProducto, intTariff, intCurrency, 
                                       intRelation, strSexo, intPoliza, 
                                       intCertif, strClinica, strCodCliente,
                                       intEstado, intRamo,intCaso);

      ArrayList objLstCober = null;
      if (objLista!=null)
      {
          objLstCober = new ArrayList();
          Cobertura objCober = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
              strTrama = objLista.getBean(i).getString("1");
              stkTrama = new StringTokenizer(strTrama, "|");
              objCober = new Cobertura();
              if (stkTrama.hasMoreTokens())
                objCober.setStrNomCobertura(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrConceptoPago(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrTipoDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrImpDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrCoaseguro(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrBeneficioMax(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrBeneficioCons(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setIntPeridoCarencia(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setStrCantidad(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setIntTipoAtencion(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntCoverGen(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntCover(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntConceptoPago(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntPeriodoTrans(Tool.parseInt(stkTrama.nextToken()));
                    
              if (objCober.getIntTipoAtencion()==1)
                  objCober.setStrTipoAtencion("HOSP");
              if (objCober.getIntTipoAtencion()==2)
                  objCober.setStrTipoAtencion("AMB");
                  
              objLstCober.add(objCober);    
              objCober = null;        
          }
      }
    
    return objLstCober;
  }
  
  // REQ 2011-0490 BIT/FMG
  public ArrayList getLstCobertura_his( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado, String strNroSolicitud,AtencionDAO atencion,int intRamo)
  {
      int intRet = -1;
    
      BeanList objLista = null;
      objLista = atencion.lstCobertura_his(intProducto, intTariff, intCurrency, 
                                       intRelation, strSexo, intPoliza, 
                                       intCertif, strClinica, strCodCliente,
                                       intEstado,strNroSolicitud,intRamo);

      ArrayList objLstCober = null;
      if (objLista!=null)
      {
          objLstCober = new ArrayList();
          Cobertura objCober = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
              strTrama = objLista.getBean(i).getString("1");
              stkTrama = new StringTokenizer(strTrama, "|");
              objCober = new Cobertura();
              if (stkTrama.hasMoreTokens())
                objCober.setStrNomCobertura(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrConceptoPago(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrTipoDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrImpDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrDeducible(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrCoaseguro(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrBeneficioMax(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setStrBeneficioCons(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setIntPeridoCarencia(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setStrCantidad(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objCober.setIntTipoAtencion(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntCoverGen(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntCover(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntConceptoPago(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objCober.setIntPeriodoTrans(Tool.parseInt(stkTrama.nextToken()));
                    
              if (objCober.getIntTipoAtencion()==1)
                  objCober.setStrTipoAtencion("HOSP");
              if (objCober.getIntTipoAtencion()==2)
                  objCober.setStrTipoAtencion("AMB");
                  
              objLstCober.add(objCober);    
              objCober = null;        
          }
      }
    
    return objLstCober;
  }
  
  public Cobertura getCoberSin( Bean objBean,int intPoliza, int intCertif , AtencionDAO atencion, int intRamo)
  {
      
      Cobertura objCobertura = null;
      if (objBean!=null)
      {
          objCobertura = new Cobertura();
          objCobertura.setIntCover(Tool.parseInt(objBean.getString("4")));
          objCobertura.setIntPeridoCarencia(Tool.parseInt(objBean.getString("17")));
          objCobertura.setIntTipoAtencion(Tool.parseInt(objBean.getString("18")));
          objCobertura.setStrBeneficioCons(objBean.getString("16"));
          objCobertura.setStrBeneficioMax(objBean.getString("15"));
          objCobertura.setStrCoaseguro(objBean.getString("14"));
          objCobertura.setStrConceptoPago(objBean.getString("10"));
          objCobertura.setStrDeducible(objBean.getString("17"));
          objCobertura.setStrImpDeducible(objBean.getString("12"));
          objCobertura.setStrNomCobertura(objBean.getString("9"));
          objCobertura.setStrTipoAtencion(objBean.getString("7"));
          objCobertura.setIntTipoAtencion(Tool.parseInt(objBean.getString("18")));
          objCobertura.setStrTipoDeducible(objBean.getString("11"));
          objCobertura.setStrCantidad(objBean.getString("21"));
                    
          String sql =  "select startdate,expirdat from health where usercomp = 1 and " +
                        "company = 1 and certype = 2 and branch = " + intRamo + " and " +
                        "policy = " + intPoliza  + " and certif  = " + intCertif + " and effecdate <= today and " + 
                        "(nulldate is null or nulldate > today)";          
          Bean bean = Tool.executeQuery(sql);
          if(bean == null)
          {
            sql =   "select first 1 effecdate, startdate,expirdat, nulldate " +
                    " from health where usercomp = 1 and company = 1 and certype = 2 and branch = " + intRamo + " and " +
                    " policy =  " + intPoliza  + "  and certif  = " + intCertif + 
                    " order by effecdate desc";
            bean = Tool.executeQuery(sql);
          }
          String strStartDate = bean.getString("startdate");
          String strExpireDate = bean.getString("expirdat");
          
          double dblMontoCoverCons = atencion.getMontoConsCover(intPoliza,intCertif,strStartDate,strExpireDate,objCobertura.getIntCover(),intRamo);
          objCobertura.setStrBeneficioCons(Double.toString(dblMontoCoverCons));
      }
      
      return objCobertura;
  }
  
  
  public ArrayList getLstConceptoProducto( int intBranch,
                                                  int intPolicy,
                                                  int intPayConcep,
                                                  int intModalidad,
                                                  int intCover,
                                                  int intTariff,
                                                  String strEffecdate,AtencionDAO atencion)
  {
      int intRet = -1;
    
      BeanList objLista = null;
      objLista = atencion.lstConceptoProducto(intBranch,
                                              intPolicy,
                                              intPayConcep,
                                              intModalidad,
                                              intCover,
                                              intTariff,
                                              strEffecdate);                                       

      ArrayList objLstConProd = null;
      if (objLista!=null)
      {
          objLstConProd = new ArrayList();
          ConceptoProducto objConProd = null;
          String strTrama = "";
          String strValor = "";
          StringTokenizer stkTrama = null;
          for (int i=0;i<objLista.size();i++)
          {
              strTrama = objLista.getBean(i).getString("1");
              stkTrama = new StringTokenizer(strTrama, "|");
              objConProd = new ConceptoProducto();
              if (stkTrama.hasMoreTokens())
                objConProd.setDblMonto(Tool.parseDouble(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setDblPorcentaje(Tool.parseDouble(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setIntConcepto(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setStrDescripcion(stkTrama.nextToken());
              if (stkTrama.hasMoreTokens())
                objConProd.setIntModalidad(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setIntTipo(Tool.parseInt(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setDblRatio(Tool.parseDouble(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setDblRatio2(Tool.parseDouble(stkTrama.nextToken()));
              if (stkTrama.hasMoreTokens())
                objConProd.setIntCantidad(Tool.parseInt(stkTrama.nextToken()));
                  
              objLstConProd.add(objConProd);    
              objConProd = null;        
          }
      }
    
    return objLstConProd;
  }  
  
  public BeanList getLstClinicaCoberturaWeb(int intCodClinica, int intCodCobertura, int intUserComp, int intCompany, String strStatRegt)
  {     
    Connection objCnn = null;
    CallableStatement objCstmt = null;
    ResultSet objRs = null;
    BeanList objList = new BeanList();
    int intSiniestro=0;
    try
      {
                objCnn = ConexionIFX.getConnection();
                objCstmt = objCnn.prepareCall("{call rea_tab_cli_cov_web(?,?,?,?,?)}");
                objCstmt.setInt(1,intCodClinica);
                objCstmt.setInt(2,intCodCobertura);
                objCstmt.setInt(3,intUserComp);
                objCstmt.setInt(4,intCompany);
                objCstmt.setString(5,strStatRegt);
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
                System.out.println("SQLExce getLstSiniestroLog:" + se);
                return null;
      }
    catch(Exception e)
      {
                System.out.println("Excep getLstSiniestroLog:" + e);
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
  
  
    public Bean getClinicaCoberturaWeb(BeanList lstClinicaCoberturaWeb, int intCodCobertura)
    {
       int intIndice=-1;
       Bean auxBean = null;
       
       for(int i=0; i<lstClinicaCoberturaWeb.size(); i++)
       {
          auxBean = lstClinicaCoberturaWeb.getBean(i);         
          if(Tool.parseInt(auxBean.getString("2"))== intCodCobertura)
          {
              intIndice=i;
              break;
          }
       }
       if (intIndice != -1)
       {
            return auxBean;
       } 
         return null;
       
    }     
    
    
public Poliza getDatePoli(int intPoliza, int intCertif)
    {
        ResultSet objRs = null;
        Connection objCnn = null;
        PreparedStatement objPstmt = null;        
        //String sql ="";
        Poliza objPoliza = new Poliza(); 
      try {
          String sql =  "select startdate,expirdat from health where usercomp = 1 and " +
                        "company = 1 and certype = 2 and branch = 23 and " +
                        "policy = " + intPoliza  + " and certif  = " + intCertif + " and effecdate <= today and " + 
                        "(nulldate is null or nulldate > today)";  
                        
            //Bean bean = Tool.executeQuery(sql);
            objCnn = ConexionIFX.getConnection();
            objPstmt = objCnn.prepareStatement(sql);
            objRs = objPstmt.executeQuery(); 
            if(objRs.next())
            {                           
                  objPoliza.setStrStarDate(objRs.getString("startdate"));
                  objPoliza.setStrExpirDate(objRs.getString("expirdat"));
            }
            objRs.close();
            objPstmt.close();
        } catch(SQLException se)
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
          
        /*  if(bean == null)
          {
            sql =   "select first 1 effecdate, startdate,expirdat, nulldate " +
                    " from health where usercomp = 1 and company = 1 and certype = 2 and branch = 23 and " +
                    " policy =  " + intPoliza  + "  and certif  = " + intCertif + 
                    " order by effecdate desc";
            bean = Tool.executeQuery(sql);
          }
          
           //bean = Tool.executeQuery(sql);
           
          String startdate = bean.getString("startdate");
          String expirdat  = bean.getString("expirdat");
          
          objPoliza.setStrStarDate(startdate); 
          objPoliza.setStrExpirDate(expirdat);                       */
                   
        return objPoliza;
    }   


}