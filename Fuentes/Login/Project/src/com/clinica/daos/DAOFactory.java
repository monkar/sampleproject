package com.clinica.daos;

public abstract class DAOFactory {

  public static final int ORACLE_INFORMIX = 1;
  public abstract ParamNuevaMarcaDAO getParamNuevaMarcaDAO();
  
  public static DAOFactory getSubFactory(int bd) {
  switch(bd){
  
    case ORACLE_INFORMIX :  return new SubFactoryOracleInformix();
  }
    return null;
  }
}