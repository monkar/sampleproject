package com.clinica.daos;

public class SubFactoryOracleInformix extends DAOFactory 
{
  public ParamNuevaMarcaDAO getParamNuevaMarcaDAO(){
        return new ParamNuevaMarcaDAOImpl();
    }
}