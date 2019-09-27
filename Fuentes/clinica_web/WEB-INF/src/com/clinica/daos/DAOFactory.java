package com.clinica.daos;

public abstract class DAOFactory {

  public static final int ORACLE_INFORMIX = 1;

  public abstract AtencionDAO getAntencionDAO();
  public abstract ClienteDAO getClienteDAO();
  public abstract EmailDAO getEmailDAO();
  public abstract ModuloDAO getModuloDAO();
  public abstract PolClinicDAO getPolClinicDAO();
  public abstract RolDAO getRolDAO();
  public abstract UsuarioDAO getUsuarioDAO();
  public abstract SolicitudDAO getSolicitudDAO();
  public abstract CoberturaDAO getCoberturaDAO();
  public abstract ClinicaDAO getClinicaDAO();
  public abstract FirmaDAO getFirmaDAO();
  public abstract AlertaRechazoDAO getAlertaRechazoDAO(); // 2015-000604
  public abstract DiagnosticoDAO getDiagnosticoDAO(); //Req. 2014-000204 Paradigmasoft GBJ
  public abstract ZonaOficinaDAO getZonaOficinaDAO(); //Req. 2015-000750 DLCH
  public abstract AlertaDAO getAlertaDAO(); //Req. 2015-000750 DLCH
  public abstract CorreoDAO getCorreoDAO(); //Req. 2015-000750 DLCH
  public abstract ParamNuevaMarcaDAO getParamNuevaMarcaDAO();
  
  public abstract ClienteCronicoDAO getClienteCronicoDAO();
  public abstract DiagnosticoPorEnfermedadDAO getDiagnosticoPorEnfermedadDAO();
  
  
  public static DAOFactory getSubFactory(int bd) {
  switch(bd){
  
    case ORACLE_INFORMIX :  return new SubFactoryOracleInformix();
  }
    return null;
  }
}