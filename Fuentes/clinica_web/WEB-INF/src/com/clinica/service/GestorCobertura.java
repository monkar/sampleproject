package com.clinica.service;
import com.clinica.daos.CoberturaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorCobertura 
{
    DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
    
    CoberturaDAO cobertura =  subFactory.getCoberturaDAO();
    
    public Bean getUsoCoberturaConfig(int intPoliza, int intCoberturaGen ,int intConceptoPago){
           return cobertura.getUsoCoberturaConfig(intPoliza,intCoberturaGen,intConceptoPago);
    }
public int insUsoCoberturaConfig(int intPoliza, int intCobertura, int intPeriodo, 
                                          int intFrecuencia, int intConceptoPago, int intUsuario, int intCoberturaGen,
                                          int intEstado, int intTipoFrec){
           return cobertura.insUsoCoberturaConfig(intPoliza,intCobertura,intPeriodo,intFrecuencia,
                                  intConceptoPago,intUsuario,intCoberturaGen,intEstado,intTipoFrec);                               
                                          
                                          }
                                          
public BeanList listUsoCoberturaConfig(int intPoliza){
     return cobertura.listUsoCoberturaConfig(intPoliza);
}
   
public BeanList listControlCoberturaConfig(int intPoliza){
      return cobertura.listControlCoberturaConfig(intPoliza);
}

public int insControlCoberturaConfig(int intPoliza, int intCobertura, int intCoberturaGen, String strControl,
                                                int intUser){
          return cobertura.insControlCoberturaConfig(intPoliza,intCobertura,intCoberturaGen,strControl,intUser);                                       
}

 public String getControlCoberturaConfig(int intPoliza, int intCoberturaGen){
      return cobertura.getControlCoberturaConfig(intPoliza,intCoberturaGen);
 }
  
 public int delControlCoberturaConfig(int intPoliza, int intCoberturaGen){
      return cobertura.delControlCoberturaConfig(intPoliza,intCoberturaGen);
 }

//RQ2019-626-INICIO
public String obtenerObservacionAsegurado(int branch, int policy, int certif, String client){
    return cobertura.obtenerObservacionAsegurado(branch, policy, certif, client);
}
//RQ2019-626-FIN
    
}