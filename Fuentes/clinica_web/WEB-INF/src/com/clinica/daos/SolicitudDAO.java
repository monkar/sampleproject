package com.clinica.daos;
import com.clinica.beans.*;
import com.clinica.beans.Cliente;
import com.clinica.beans.Cobertura;
import com.clinica.utils.*;
import java.sql.Connection;
import com.clinica.service.*;


public interface SolicitudDAO 
{

  public int getMotivoAnulacion(int pclaim);
  public int getStaclaim(int pclaim);
  public boolean anularCartaIFX(int pclaim, int pmotivo, int pusercode);
  public boolean anularCartaORA(int pclaim);
  public int insSolicitud(Solicitud objSolicitud, Cliente objCliente,int intCacalili);
  public BeanList getLstHistoricoSolicitud(int nIdSolicitud); 
  public BeanList getUltimoComentario(int nIdSolicitud);
  public int updFlujoSolicitud(Solicitud objSolicitud, int IdRolClinica);
  public Solicitud getDatosSolicitud(String strNumSol);
  public Solicitud getSolicitud(int intIdSol);
  public BeanList getLstSolicitudPend(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon);
    
  public int updSolicitudSiniestro(Solicitud objSolicitud);
  public int updSolicitudObsMed(Solicitud objSolicitud);
  public BeanList getLstSolicitudHis(int intIdSolicitud);
  
  public BeanList getLstSolicitudHisSin(int intIdTipoSol, 
                                                String strNrosiniestro,  
                                                String strIdClinica,
                                                String strAsegurado, 
                                                int intCodOficina,
                                                int intIdUsuario);
     
  public Bean getOficPol(int intPolice, int intRamo);
  public String insSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente,
                                       String strWebServer,
                                       int intCaso
                                       );
  
 public int updSolicitudIfx(Solicitud objSolicitud,
                                    Cobertura objCobertura,
                                    Cliente objCliente);
  
public int ampliaSolicitudIfx(Solicitud objSolicitud,
                                       Cobertura objCobertura,
                                       Cliente objCliente
                                       );
       
public void getSolicitudIfx(Solicitud objSolicitud, int intTransaccion); 

public double getAmountAmpIfx(String strNroAutoriza, int intTransac);

public double getImporteAmpIfx(String strNroAutoriza, int intTransac);
  
public int getTiempoTipoSol(int intTipoSol);  

public int getIDCapitalIlimitado(int intNroSiniestro);
  
public int anulRechSolicitudIfx(String strNroSiniestro, int intTipo, Solicitud_his objSolicitudHis);  
  
public int anulRechSolicitudAmpIfx(String strNroSiniestro, int intUsercode, 
                                            int intTransac, int intTipo, Solicitud_his objSolicitudHis);
                                            
public int insPresupuesto(Solicitud objSolicitud);  

public int updPresupuesto(Solicitud objSolicitud);
  
public int getNewIdPresupuesto();
  
public Presupuesto getPresupuesto(int intIdSol, int intIdTransaccion);

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista);

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, BeanList lista, int codGrupo);

public BeanList getListaSolicitudBenIfx(int intGenCover , String strSiniestro, String strNombCliente, String strClinica, String strClinicaTinta, BeanList lista, int codGrupo,
                                                    String fInicio, String fFin);
    

public BeanList getLstSolicitudDet(  int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, String strFechaIniSol, 
                                                String strFechaFinSol);
                                                
public Bean getSolicitudSin(BeanList lstSiniestroLog, String strSiniestro);

public int validaTransaccion(int intTransaccion , int intIdSolicitud);

public void getTransactionInfo(Solicitud objSolicitud);
    
public int actualizaTransac(int intIdSolicitud, int intNewTransac, int intOldTransac);
    
public int registraSolicitud(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente, String strWebServer,
                                 int intPoliza, int intCertif, int intRamo,String strCodCliente,int intIdSol, String strWebServerSol,
                                            AtencionDAO atencion,PolClinicDAO polClinic,EmailDAO email,ClinicaDAO clinical,int intCaso);
public int ampliaSolicitudSyn(Solicitud objSolicitud, Cobertura objCobertura, Cliente objCliente);
   

public String generaSolicitudSyn(int intPoliza, int intCertif, String strCodCliente, String strWebServer,
                                       int intCover, int intConceptoPago, int intSelcover,String strWebServerSol,
                                       AtencionDAO atencion, PolClinicDAO polClinic , ClienteDAO cliente,int intRamo);
                                       
public BeanList getLstSolicitudHistoricoPaciente(String strFechaIniSol, 
                                                             String strFechaFinSol,
                                                             int intIdTipoSol, 
                                                             String strIdClinica,
                                                             String strNomPaciente);

public BeanList getLstFilesHistorico(int intIdSolicitud);
    

/* P2012-0078*/    

public int insHistoricoSolicitudMaxCoaseguro(Cliente objCliente,
                                              Cobertura objCobertura,
                                              Solicitud objSolicitud,
                                              Poliza objPoliza,
                                              Usuario objUsuario,
                                              double dblMontoInicial,
                                              String strAccion, 
                                              int intIdCompania);                     

public int updHistoricoSolicitudMaxCoaseguro(Solicitud objSolicitud, int intIdfirstClaim);  

public String consultaHistoricoSiniestroCoaseguro(int intIdfirstClaim);

/* P2012-0078*/   
                      
/*Inicio Req. 2014-000204*/
public double obtenerMontoCarta(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int intIdSolicitud, String strNroSiniestro);
public int actualizarFechaLimiteSolicitud(String strNroSiniestro, int intDias);
/*Fin Req. 2014-000204*/

//RQ2015-000750 INICIO
public BeanList getLstSolicitudPendPag(int intIdRol, int intIdTipoSol, String strNrosiniestro, String strAsegurado, 
                                          String strIdClinica, int intCodBroker, int intTipo, int intIdUsuario, 
                                          String strIdEstados, String strOficCon, int intAviso, int intPaginaActual, int intNumRegPag);
public AvisoSolicitud getDatosSolicitudInx(int nClaim, int nTrans);
public int procesarAvisoSolicitud(AvisoSolicitud objAvisoSolicitud);
public int procesarAvisoCliente(AvisoSolicitud objAvisoSolicitud);
public int SendAvisoGerencia(AvisoSolicitud objAvisoSolicitud);
public double obtenerMontoCartaAcumulado(Connection objConOra, Connection objCnnIfx, GestorSolicitud gc, int intIdSolicitud, String strNroSiniestro);
//RQ2015-000750 FIN
//RQ2015-000604 INICIO
public int procesarAvisoRechazo(AvisoRechazo objAvisoRechazo);
public int procesarRechazo(AvisoRechazo objAvisoRechazo);
public AvisoRechazo getDatosRSolicitudInx(int nClaim, int nTrans);
public AvisoRechazo getDatosCartaRechazo(int intclaim); 
public int actualizaRechazo(AvisoRechazo objAvisoRechazo);
public BeanList getLstSolicitudRechazo(int intIdRol, int intIdEstado, int intIdTipoSol, 
                                                String strNrosiniestro, String strAsegurado, 
                                                String strIdClinica, int intCodOficina, int intCodBroker,
                                                int intTipo, int intIdUsuario, String strIdEstados, String strOficCon);
public int estadoCartaRechazo();
public String benefConsumidoCase(int intCaso,int intSini);
//RQ2015-000604 FIN
public int ValidarCaso(int intPoliza,int intCertif,String strNombre,String strDNI,String strApellido,String strCodCliente);
public BeanList getPermisosRol(int intRol);
//INICIO RQ2019-691 - CPHQ
public int getBroker(String p_certype,int p_branch,int p_certif,int p_policy);
//FIN RQ2019-691 - CPHQ
}