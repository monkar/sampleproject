package com.clinica.service;
import com.clinica.beans.AvisoRechazo;
import com.clinica.beans.Presupuesto;
import com.clinica.daos.AtencionDAO;
import com.clinica.daos.ClienteDAO;
import com.clinica.daos.ClinicaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.EmailDAO;
import com.clinica.daos.PolClinicDAO;
import com.clinica.daos.SolicitudDAO;
import com.clinica.daos.DiagnosticoDAO;   //Req. 2014-000204 Paradigmasoft GBJ
import com.clinica.beans.Solicitud;
import com.clinica.beans.AvisoSolicitud;
import com.clinica.beans.Cobertura;
import com.clinica.beans.Cliente;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.beans.Solicitud_his;
import com.clinica.beans.Poliza;
import com.clinica.beans.DetallePresupuesto;
import com.clinica.beans.Usuario;
import java.sql.*;

public class GestorSolicitud 
{

  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
 
  SolicitudDAO solicitud =   subFactory.getSolicitudDAO();
  AtencionDAO atencion = subFactory.getAntencionDAO();
  PolClinicDAO polClinic = subFactory.getPolClinicDAO();
  EmailDAO email = subFactory.getEmailDAO();
  ClienteDAO cliente = subFactory.getClienteDAO();
  ClinicaDAO clinica = subFactory.getClinicaDAO();
  DiagnosticoDAO diagnostico = subFactory.getDiagnosticoDAO();   //Req. 2014-000204 Paradigmasoft GBJ
 
  public int getMotivoAnulacion(int pclaim){
      return solicitud.getMotivoAnulacion(pclaim);
  }
  public int getStaclaim(int pclaim){
      return solicitud.getStaclaim(pclaim);
  }
  public boolean anularCartaIFX(int pclaim, int pmotivo, int pusercode){
        return solicitud.anularCartaIFX(pclaim,pmotivo,pusercode);
  }
  public boolean anularCartaORA(int pclaim){
        return solicitud.anularCartaORA(pclaim);
  }
  public int insSolicitud(Solicitud objSolicitud, Cliente objCliente, int intCacalili){
       return solicitud.insSolicitud(objSolicitud,objCliente,intCacalili);
  }
  public BeanList getLstHistoricoSolicitud(int nIdSolicitud){
     return solicitud.getLstHistoricoSolicitud(nIdSolicitud);
  }
  public BeanList getUltimoComentario(int nIdSolicitud){
     return solicitud.getUltimoComentario(nIdSolicitud);
  }
  public int updFlujoSolicitud(Solicitud objSolicitud, int IdRolClinica){
     return solicitud.updFlujoSolicitud(objSolicitud,IdRolClinica);
  }
  public Solicitud getDatosSolicitud(String strNumSol){
    return solicitud.getDatosSolicitud(strNumSol);
  }
  public Solicitud getSolicitud(int intIdSol){
    return solicitud.getSolicitud(intIdSol);
  }
  public BeanList getLstSolicitudPend(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon){
           return solicitud.getLstSolicitudPend(intIdRol,intIdEstado,intIdTipoSol,strNrosiniestro
                                       ,strAsegurado,strIdClinica,intCodOficina,intCodBroker,intTipo,intIdUsuario,strIdEstados,
                                                          strOficCon);                            
   }
    
  public int updSolicitudSiniestro(Solicitud objSolicitud){
         return solicitud.updSolicitudSiniestro(objSolicitud);
  }
  public int updSolicitudObsMed(Solicitud objSolicitud){
          return solicitud.updSolicitudObsMed(objSolicitud);
  }
  public BeanList getLstSolicitudHis(int intIdSolicitud){
           return solicitud.getLstSolicitudHis(intIdSolicitud);
  }
  
  public BeanList getLstSolicitudHisSin(int intIdTipoSol, 
                                                String strNrosiniestro,  
                                                String strIdClinica,
                                                String strAsegurado, 
                                                int intCodOficina,
                                                int intIdUsuario){
                return solicitud.getLstSolicitudHisSin(intIdTipoSol,strNrosiniestro,
               strIdClinica,strAsegurado,intCodOficina,intIdUsuario);                            
}
     
  public Bean getOficPol(int intPolice, int intRamo){
         return solicitud.getOficPol(intPolice,intRamo);
  }
  public String insSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente,
                                       String strWebServer,int intCaso
                                       ){
         return solicitud.insSolicitudIfx(objSolicitud,objCobertura,objCliente,strWebServer,intCaso);                              
  }
  
 public int updSolicitudIfx(Solicitud objSolicitud,
                                    Cobertura objCobertura,
                                    Cliente objCliente){
          return solicitud.updSolicitudIfx(objSolicitud,objCobertura,objCliente);                    
                }
  
public int ampliaSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente
                                       ){
               return solicitud.ampliaSolicitudIfx(objSolicitud,objCobertura,objCliente);                        
 }
       
public void getSolicitudIfx(Solicitud objSolicitud, int intTransaccion){
      solicitud.getSolicitudIfx(objSolicitud,intTransaccion);
}

public double getAmountAmpIfx(String strNroAutoriza, int intTransac){
    return solicitud.getAmountAmpIfx(strNroAutoriza,intTransac);
}

public double getImporteAmpIfx(String strNroAutoriza, int intTransac){
    return solicitud.getImporteAmpIfx(strNroAutoriza,intTransac);
}
  
public int getTiempoTipoSol(int intTipoSol){
        return solicitud.getTiempoTipoSol(intTipoSol);
} 
public int getIDCapitalIlimitado(int intNroSiniestro){
        return solicitud.getIDCapitalIlimitado(intNroSiniestro);
} 
  
public int anulRechSolicitudIfx(String strNroSiniestro, int intTipo, Solicitud_his objSolicitudHis){
      return solicitud.anulRechSolicitudIfx(strNroSiniestro,intTipo,objSolicitudHis);
}
  
public int anulRechSolicitudAmpIfx(String strNroSiniestro, int intUsercode, 
                                            int intTransac, int intTipo, Solicitud_his objSolicitudHis){
              return solicitud.anulRechSolicitudAmpIfx(strNroSiniestro,intUsercode,intTransac
                                           ,intTipo,objSolicitudHis);                         
 }
                                            
public int insPresupuesto(Solicitud objSolicitud){
      return solicitud.insPresupuesto(objSolicitud);
}  

public int updPresupuesto(Solicitud objSolicitud){
     return solicitud.updPresupuesto(objSolicitud);
}
  
public int getNewIdPresupuesto(){
     return solicitud.getNewIdPresupuesto();
}
  
public Presupuesto getPresupuesto(int intIdSol, int intIdTransaccion){
     return solicitud.getPresupuesto(intIdSol,intIdTransaccion);
}

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista){
        return solicitud.getListaSolicitudBenIfx(intGenCover,strSiniestro,strNombCliente,strClinica,lista);
}

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista, int codGrupo){
      return solicitud.getListaSolicitudBenIfx(intGenCover,strSiniestro,strNombCliente,strClinica,lista,codGrupo);
}

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, String strClinicaTinta, BeanList lista, int codGrupo,
                                                    String fInicio, String fFin){
     return solicitud.getListaSolicitudBenIfx(intGenCover,strSiniestro,strNombCliente,strClinica,strClinicaTinta,lista,codGrupo,fInicio,fFin);
                                                    }
    

public BeanList getLstSolicitudDet(  int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, String strFechaIniSol, 
                                                String strFechaFinSol){
      return solicitud.getLstSolicitudDet(intIdRol,intIdEstado,intIdTipoSol,strNrosiniestro,strAsegurado,
                                   strIdClinica,intCodOficina,strFechaIniSol,strFechaFinSol);                                        
      }
                                                
public Bean getSolicitudSin(BeanList lstSiniestroLog, String strSiniestro){
       return solicitud.getSolicitudSin(lstSiniestroLog,strSiniestro);
}

public int validaTransaccion(int intTransaccion , int intIdSolicitud){
     return solicitud.validaTransaccion(intTransaccion,intIdSolicitud);
}

public void getTransactionInfo(Solicitud objSolicitud){
    solicitud.getTransactionInfo(objSolicitud);
}
    
public int actualizaTransac(int intIdSolicitud, int intNewTransac, int intOldTransac){
   return solicitud.actualizaTransac(intIdSolicitud,intNewTransac,intOldTransac);
}
    
public int registraSolicitud(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente, String strWebServer,
                                 int intPoliza, int intCertif, int intRamo,String strCodCliente,int intIdSol, String strWebServerSol,int intCaso){
      return solicitud.registraSolicitud(objSolicitud,objCobertura,objCliente,strWebServer,intPoliza,intCertif,
                            intRamo,strCodCliente,intIdSol,strWebServerSol,atencion,polClinic,email,clinica, intCaso);                      
                                 
                                 }
                                                                      
public int ampliaSolicitudSyn(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente){
     return solicitud.ampliaSolicitudSyn(objSolicitud,objCobertura,objCliente);
   
}

public String generaSolicitudSyn(int intPoliza, int intCertif, String strCodCliente, String strWebServer,
                                       int intCover, int intConceptoPago, int intSelcover,String strWebServerSol,int intRamo){
                  return solicitud.generaSolicitudSyn(intPoliza,intCertif,strCodCliente,strWebServer,intCover,intConceptoPago
                                ,intSelcover,strWebServerSol,atencion,polClinic,cliente,intRamo);                     
                                       
         }
                                       
public BeanList getLstSolicitudHistoricoPaciente(String strFechaIniSol, 
                                                             String strFechaFinSol,
                                                             int intIdTipoSol, 
                                                             String strIdClinica,
                                                             String strNomPaciente){
            return solicitud.getLstSolicitudHistoricoPaciente(strFechaIniSol,
          strFechaFinSol,intIdTipoSol, strIdClinica,strNomPaciente);                                                         
        }
                                                             
                                                     

public BeanList getLstFilesHistorico(int intIdSolicitud){
   return solicitud.getLstFilesHistorico(intIdSolicitud);
}

/*P2012-0078*/    
public int registraHistoricoMaxCoaseguro(Cliente objCliente,
                                         Cobertura objCobertura,
                                         Solicitud objSolicitud,
                                         Poliza objPoliza,
                                         Usuario objUsuario,
                                         double dblMontoInicial,
                                         String strAccion, 
                                         int intIdCompania){
                                         
  return solicitud.insHistoricoSolicitudMaxCoaseguro(objCliente,objCobertura,objSolicitud,
                                                     objPoliza,objUsuario,
                                                     dblMontoInicial,strAccion,intIdCompania);  
}
/*P2012-0078*/    
public int actualizaHistoricoMaxCoaseguro(Solicitud objSolicitud, int intIdfirstClaim){
  
  return solicitud.updHistoricoSolicitudMaxCoaseguro(objSolicitud,intIdfirstClaim);
}

/*P2012-0078*/    
public String obtieneSegundoSiniestro(int intIdfirstClaim)
{
  return solicitud.consultaHistoricoSiniestroCoaseguro(intIdfirstClaim);
}

//Inicio Req. 2014-000204 Paradigmasoft GJB
public String obtenerDiagnostico(Connection objCnnIfx, String strNroSiniestro){
  return diagnostico.obtenerDiagnostico(objCnnIfx,strNroSiniestro);
}
public double obtenerMontoCarta(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int intIdSolicitud, String strNroSiniestro){
  return solicitud.obtenerMontoCarta(objConOra, objCnnIfx, gc, intIdSolicitud, strNroSiniestro);
}
public int actualizarFechaLimiteSolicitud(String strNroSiniestro, int intDias){
  return solicitud.actualizarFechaLimiteSolicitud(strNroSiniestro, intDias);
}
//Fin Req. 2014-000204 Paradigmasoft GJB

//RQ2015-000750 INICIO
public BeanList getLstSolicitudPendPag(int intIdRol, int intIdTipoSol, String strNrosiniestro, String strAsegurado, 
                                          String strIdClinica, int intCodBroker, int intTipo, int intIdUsuario, 
                                          String strIdEstados, String strOficCon, int intAviso, int intPaginaActual, int intNumRegPag){
   return solicitud.getLstSolicitudPendPag(intIdRol, intIdTipoSol, strNrosiniestro, strAsegurado, 
                                          strIdClinica, intCodBroker, intTipo, intIdUsuario, 
                                          strIdEstados, strOficCon, intAviso, intPaginaActual, intNumRegPag);
}
public AvisoSolicitud getDatosSolicitudInx(int nClaim, int nTrans){
    return solicitud.getDatosSolicitudInx(nClaim, nTrans);
}
public int procesarAvisoSolicitud(AvisoSolicitud objAvisoSolicitud){
  return solicitud.procesarAvisoSolicitud(objAvisoSolicitud);
}
public int procesarAvisoCliente(AvisoSolicitud objAvisoSolicitud){
  return solicitud.procesarAvisoCliente(objAvisoSolicitud);
}
public int SendAvisoGerencia(AvisoSolicitud objAvisoSolicitud){
      return solicitud.SendAvisoGerencia(objAvisoSolicitud);                      
}
public double obtenerMontoCartaAcumulado(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int intIdSolicitud, String strNroSiniestro){
  return solicitud.obtenerMontoCartaAcumulado(objConOra, objCnnIfx, gc, intIdSolicitud, strNroSiniestro);
}
//RQ2015-000750 FIN
//RQ2015-000604 INICIO
public int procesarAvisoRechazo(AvisoRechazo objAvisoRechazo){
  return solicitud.procesarAvisoRechazo(objAvisoRechazo);  
}
public int procesarRechazo(AvisoRechazo objAvisoRechazo){
  return solicitud.procesarRechazo(objAvisoRechazo);
}
public AvisoRechazo getDatosRSolicitudInx(int nClaim, int nTrans){
    return solicitud.getDatosRSolicitudInx(nClaim, nTrans);
}
public AvisoRechazo getDatosCartaRechazo(int intclaim){
    return solicitud.getDatosCartaRechazo(intclaim);
}   
public int actualizaRechazo(AvisoRechazo objAvisoRechazo){
  return solicitud.actualizaRechazo(objAvisoRechazo);
}
public BeanList getLstSolicitudRechazo(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon){
           return solicitud.getLstSolicitudRechazo(intIdRol,intIdEstado,intIdTipoSol,strNrosiniestro
                                       ,strAsegurado,strIdClinica,intCodOficina,intCodBroker,intTipo,intIdUsuario,strIdEstados,
                                                          strOficCon);                            
}
public int estadoCartaRechazo(){
  return solicitud.estadoCartaRechazo();
//RQ2015-000604 FIN
}
public String benefConsumidoCase(int intCaso,int intSini){
  return solicitud.benefConsumidoCase(intCaso,intSini);
//RQ2015-000604 FIN
}
public int ValidarCaso(int intPoliza,int intCertif,String strNombre,String strDNI,String strApellido,String strCodCliente){
      return solicitud.ValidarCaso(intPoliza,intCertif,strNombre,strDNI,strApellido,strCodCliente);
  }
public BeanList getPermisosRol(int intRol){
  return solicitud.getPermisosRol(intRol);
}
//INICIO RQ2019-691 - CPHQ
public int getBroker(String p_certype,int p_branch,int p_certif,int p_policy) {
        return solicitud.getBroker(p_certype,p_branch,p_certif,p_policy) ;
    }
}
//FIN RQ2019-691 - CPHQ