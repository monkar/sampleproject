package com.clinica.service;
import com.clinica.daos.ClinicaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorClinica {

  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
   ClinicaDAO clinica =  subFactory.getClinicaDAO();
  
  
 public BeanList lstClinica(int intIdUsuario){
    return clinica.lstClinica(intIdUsuario);
 }
  public BeanList lstClinicaAviso(int intIdUsuario){
    return clinica.lstClinicaAviso(intIdUsuario);
 }
public Bean getClinica(String strCode){
     return clinica.getClinica(strCode);
}
public boolean getPolClinica(String strWerServer, int intPoliza, int codRamo){
     return clinica.getPolClinica(strWerServer,intPoliza, codRamo);
}
public BeanList lstClinicaIfx(String strDesc){
      return clinica.lstClinicaIfx(strDesc);
 }
public BeanList lstClinicaWeb(int intUsercomp,
                                      int intCompany,
                                      String strTenserver,
                                      String strStatregt,
                                      String strDescriptCliename){
      return clinica.lstClinicaWeb(intUsercomp,intCompany,strTenserver,strStatregt,strDescriptCliename);                                  
    }


}