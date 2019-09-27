package com.clinica.daos;
import com.clinica.daos.CoberturaDAO;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.beans.Cobertura;

public interface AtencionDAO 
{

public String getNombreClinica(BeanList lista, String codServer);
public BeanList getClienteVT(String Num_Doc, String Tipo_per, String sCode) ;
public BeanList getTitularVT(String Num_Doc, String Tipo_per, String sCode);
public BeanList lstClienteFiltro(String strDNI,String strNombreApe,String strCodigo,String strTipo,String strClinica, int intCodBroker,int intRamo);
public BeanList lstCliente(int intPoliza, int intCertif, String strClinica, int intCodBroker);
public BeanList lstCliente(String strNombre, String strClinica, int intCodBroker);
public Bean getCliente(int intPoliza, int intCertif, String strCodCliente, String strClinica,int intRamo);
//Apple
public Bean getClienteApple(int intPoliza, int intCertif, String strCodCliente, String strClinica, int intRamo);
public Bean getCliente_his(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strNroSolicitud, int intRamo);
public String getAutorizacion(int intPoliza, int intCertif, String strCodCliente, String strClinica, 
                                       int intCover, int intConceptoPago);
public BeanList lstExclusion(int intRamo, int intPoliza, int intCertif, String strCodCliente, String strFecha);                      
public BeanList lstCobertura(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado,int intRamo,int intCaso);
public  boolean insLogSiniestro(int intRamo,int intPoliza, int intCertif, String strCodCliente, 
                                        String strClinica, String strNroautoriza,
                                        Cobertura objCover, int intTipoSolicitud, String strClinicaSol);
                                                                         
public BeanList lstCobertura_his(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado, String strNroSolicitud,int intRamo);
                                      
 public Bean getSiniestroLog(String strSiniestro); 
 public BeanList getLstSiniestroLog(String strFechaIniSol, String strFechaFinSol, String strSiniestro);
public BeanList getLstSiniestroLog(String strFechaIniSol, String strFechaFinSol, String strSiniestro, String strClinica,ClinicaDAO clinica);
public double getMontoConsCover(int intPoliza, int intCertificado, String strStartDate,
                                      String strExpirDate, int intCover,int intRamo);
                                        
public int getEstadoCliente(int intPoliza, int intCertificado,int intRamo);
public int getCantUsoCobertura(int intPoliza, int  intCertificado, int intCover, 
                                     int intPeriodo, String strCodCliente, int intConceptoPago, int intTipoFreq);

public int validaClienteVip(int intPoliza , int intCertificado);
public String getParentesco(int intCodParentesco);
public BeanList lstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint);
public BeanList lstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType);
public BeanList lstConceptoProducto(int intBranch,
                                              int intPolicy,
                                              int intPayConcep,
                                              int intModalidad,
                                              int intCover,
                                              int intTariff,
                                              String strEffecdate);
  
public BeanList getLstWebCliHist(int intNroSiniestro, 
                                          int intNroTransaccion,
                                          String strCodDiagnostico);
                                          
public Bean getCliente_bit(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strEffecDate);                                          

public BeanList lstMaestroDiagnosticos(int intUsercomp, int intCompany, String strIllness, String strIllnessDes, String strStatregt);

/*Estos metodos estaban en el Servlet*/
public BeanList getLstExclusion(int intPoliza, int intCertif, String strCodCliente,AtencionDAO atencion , int intRamo);

public BeanList getLstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType,AtencionDAO atencion);

 public BeanList getLstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint,AtencionDAO atencion);
}