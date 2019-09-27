package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface CoberturaDAO {

public Bean getUsoCoberturaConfig(int intPoliza, int intCoberturaGen ,int intConceptoPago);
public int insUsoCoberturaConfig(int intPoliza, int intCobertura, int intPeriodo, 
                                          int intFrecuencia, int intConceptoPago, int intUsuario, int intCoberturaGen,
                                          int intEstado, int intTipoFrec);
                                          
public BeanList listUsoCoberturaConfig(int intPoliza);
   
public BeanList listControlCoberturaConfig(int intPoliza);

public int insControlCoberturaConfig(int intPoliza, int intCobertura, int intCoberturaGen, String strControl,
                                                int intUser);

 public String getControlCoberturaConfig(int intPoliza, int intCoberturaGen);
  
 public int delControlCoberturaConfig(int intPoliza, int intCoberturaGen);

 //RQ2019-626-INICIO
 public String obtenerObservacionAsegurado(int branch, int policy, int certif, String client);
 //RQ2019-626-FIN

}