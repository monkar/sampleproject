package com.clinica.daos;

public class SubFactoryOracleInformix extends DAOFactory 
{

    public AtencionDAO getAntencionDAO(){
          return new AtencionDAOImpl();
     }

    public ClienteDAO getClienteDAO(){
          return new ClienteDAOImpl();
    }

    public EmailDAO getEmailDAO(){
         return new EmailDAOImpl();
    }
    
    public ModuloDAO getModuloDAO(){
         return new ModuloDAOImpl();
    }

    public PolClinicDAO getPolClinicDAO(){
          return new PolClinicDAOImpl();
    }
    
    public RolDAO getRolDAO(){
         return new RolDAOImpl();
    }
    
    public UsuarioDAO getUsuarioDAO(){
         return new UsuarioDAOImpl();
    } 
    
    public SolicitudDAO getSolicitudDAO(){
           return new SolicitudDAOImpl();
    }
    
    public CoberturaDAO getCoberturaDAO(){
          return new CoberturaDAOImpl();
    }
    
    public ClinicaDAO getClinicaDAO(){
           return new ClinicaDAOImpl();
    }
    
    public FirmaDAO getFirmaDAO(){
         return new FirmaDAOImpl();
    }
    
    public DiagnosticoDAO getDiagnosticoDAO(){
        return new DiagnosticoDAOImpl();
    }
    
    //RQ2015-000750 INICIO
    public ZonaOficinaDAO getZonaOficinaDAO(){
        return new ZonaOficinaDAOImpl();
    }
    
    public AlertaDAO getAlertaDAO(){
        return new AlertaDAOImpl();
    }
    
    public CorreoDAO getCorreoDAO(){
        return new CorreoDAOImpl();
    }
    //RQ2015-000750 FIN
       public AlertaRechazoDAO getAlertaRechazoDAO(){
        return new AlertaRechazoDAOImpl();
    }  
    
    public ParamNuevaMarcaDAO getParamNuevaMarcaDAO(){
        return new ParamNuevaMarcaDAOImpl();
    }

    @Override
    public ClienteCronicoDAO getClienteCronicoDAO() {
        
        return new ClienteCronicoDAOImpl();
    }


    @Override
    public DiagnosticoPorEnfermedadDAO getDiagnosticoPorEnfermedadDAO() {
        return new DiagnosticoPorEnfermedadDAOImpl();
    }
}
