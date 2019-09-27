package com.clinica.service;
import com.clinica.beans.Cobertura;
import com.clinica.daos.AtencionDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.PolClinicDAO;
import com.clinica.beans.Pol_Clinic;
import com.clinica.beans.Poliza;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import java.util.ArrayList;


public class GestorPolClinic 
{

     DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
     
     AtencionDAO atencion =  subFactory.getAntencionDAO(); 
     PolClinicDAO polClinica =  subFactory.getPolClinicDAO();
    
    public boolean insPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode){
          return polClinica.insPolclinic(objPolcli,intIdUsuario,intUserCode);
    }
public boolean delPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode){
         return polClinica.delPolclinic(objPolcli,intIdUsuario,intUserCode);
}
public BeanList lstPol_Clinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                        int intTariff,int intRed, String dEffeccdate, int intConcep){
     return polClinica.lstPol_Clinic(intBranch,intPolicy,intCover,intModalidad,intTariff,intRed,dEffeccdate,intConcep);                                   
                                        
                                        }
 
public Poliza getPoliza(int intBranch, int intPolicy, int intFlgValida){
      return polClinica.getPoliza(intBranch,intPolicy,intFlgValida);
}

public boolean valinsPolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate){
     return polClinica.valinsPolclinic(intBranch,intPolicy,intCover,intModalidad,intTariff,intRed,
                                        intCodClinic,strEffecdate);                                
                                     }
                                        
public boolean updPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode){
      return polClinica.updPolclinic(objPolcli,intIdUsuario,intUserCode);
}

public boolean insPolclinicLog(Pol_Clinic objPolcli, int idUsuario, int intUserCode, String strAcc){
      return polClinica.insPolclinicLog(objPolcli,idUsuario,intUserCode,strAcc);
}

public boolean valDatePolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate){
      return polClinica.valDatePolclinic(intBranch,intPolicy,intCover,intModalidad,intTariff
                   ,intRed,intCodClinic,strEffecdate);                                  
 }
                                                                       
public Bean getMonedaPoliza(int intPoliza){
     return polClinica.getMonedaPoliza(intPoliza);
}
  
public BeanList getCoberturaPoliza(int intProducto, int intMoneda){
   return polClinica.getCoberturaPoliza(intProducto,intMoneda);
}
    
public Bean getContratante(int intPoliza, int  intCertificado){
     return polClinica.getContratante(intPoliza,intCertificado);
}

public ArrayList getLstCobertura( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado,int intRamo, int intCaso){
       return polClinica.getLstCobertura(intProducto,intTariff,intCurrency,intRelation,strSexo,
                    intPoliza,intCertif,strClinica,strCodCliente,intEstado,atencion, intRamo,intCaso);                             
  }
  
 public ArrayList getLstCobertura_his( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado, String strNroSolicitud,int intRamo){
                return polClinica.getLstCobertura_his(intProducto,intTariff,intCurrency,intRelation,
                    strSexo,intPoliza,intCertif,strClinica,strCodCliente,intEstado,strNroSolicitud,atencion,intRamo);
              }
                               
public Cobertura getCoberSin( Bean objBean,int intPoliza, int intCertif,int intRamo){
          return polClinica.getCoberSin(objBean,intPoliza,intCertif,atencion,intRamo);
}

public ArrayList getLstConceptoProducto( int intBranch,
                                                  int intPolicy,
                                                  int intPayConcep,
                                                  int intModalidad,
                                                  int intCover,
                                                  int intTariff,
                                                  String strEffecdate){
          return polClinica.getLstConceptoProducto(intBranch,intPolicy,intPayConcep,
                                   intModalidad,intCover,intTariff,strEffecdate,atencion);                                              
    }
                                                  
                            
 public BeanList getLstClinicaCoberturaWeb(int intCodClinica, int intCodCobertura, int intUserComp, int intCompany, String strStatRegt){
       return polClinica.getLstClinicaCoberturaWeb(intCodClinica,intCodCobertura,intUserComp,intCompany,strStatRegt);
 }
   
      
public Bean getClinicaCoberturaWeb(BeanList lstClinicaCoberturaWeb, int intCodCobertura){
         return polClinica.getClinicaCoberturaWeb(lstClinicaCoberturaWeb,intCodCobertura);
}  
//RQ2015-000604       
public Poliza getDatePoli(int intPoliza, int intCertif){
      return polClinica.getDatePoli(intPoliza,intCertif);
}

}