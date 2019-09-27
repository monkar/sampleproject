package com.clinica.service;
import com.clinica.daos.AtencionDAO;
import com.clinica.daos.ClinicaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.CoberturaDAO;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.beans.Cobertura;

public class Atencion 
{

      DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
     
       AtencionDAO atencion =  subFactory.getAntencionDAO(); 
       
       ClinicaDAO clinica = subFactory.getClinicaDAO();
     
     public String getNombreClinica(BeanList lista, String codServer){
          return atencion.getNombreClinica(lista,codServer);
     }
     
    public BeanList getClienteVT(String Num_Doc, String Tipo_per, String sCode) {
               return atencion.getClienteVT(Num_Doc,Tipo_per,sCode);
     }
     
     
    public BeanList getTitularVT(String Num_Doc, String Tipo_per, String sCode){
              return atencion.getTitularVT(Num_Doc,Tipo_per,sCode);   
    }
    
   public BeanList lstClienteFiltro(String strDNI,String strNombreApe,String strCodigo,String strTipo,String strClinica, int intCodBroker,int intRamo){
         return atencion.lstClienteFiltro(strDNI,strNombreApe,strCodigo,strTipo,strClinica,intCodBroker,intRamo);
   }
   
public BeanList lstCliente(int intPoliza, int intCertif, String strClinica, int intCodBroker){
           return atencion.lstCliente(intPoliza,intCertif,strClinica,intCodBroker);
 }
 
public BeanList lstCliente(String strNombre, String strClinica, int intCodBroker ){
         return atencion.lstCliente(strNombre,strClinica,intCodBroker);
}
public Bean getCliente(int intPoliza, int intCertif, String strCodCliente, String strClinica, int intRamo){
         return atencion.getCliente(intPoliza,intCertif,strCodCliente,strClinica,intRamo);
}
//APPLE
public Bean getClienteApple(int intPoliza, int intCertif, String strCodCliente, String strClinica, int intRamo){
         return atencion.getClienteApple(intPoliza,intCertif,strCodCliente,strClinica, intRamo);
}
public Bean getCliente_his(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strNroSolicitud, int intRamo){
     return atencion.getCliente_his(intPoliza,intCertif,strCodCliente,strClinica,strNroSolicitud,intRamo);
}
public String getAutorizacion(int intPoliza, int intCertif, String strCodCliente, String strClinica, 
                                       int intCover, int intConceptoPago){
        return atencion.getAutorizacion(intPoliza,intCertif,strCodCliente,strClinica,intCover,
                                                     intConceptoPago);                          
                                       }
                                       
public BeanList lstExclusion(int intRamo, int intPoliza, int intCertif, String strCodCliente, String strFecha){
                  return atencion.lstExclusion(intRamo,intPoliza,intCertif,strCodCliente,strFecha);
}                
public BeanList lstCobertura(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado,int intRamo,int intCaso){
                                      
             return atencion.lstCobertura(intProducto,intTariff,intCurrency,intRelation,strSexo,
                                        intPoliza,intCertif,strClinica,strCodCliente,intEstado,intRamo,intCaso);                          
 }
public  boolean insLogSiniestro(int intRamo,int intPoliza, int intCertif, String strCodCliente, 
                                        String strClinica, String strNroautoriza,
                                        Cobertura objCover, int intTipoSolicitud, String strClinicaSol){
            return atencion.insLogSiniestro(intRamo,intPoliza,intCertif,strCodCliente,strClinica
                                    ,strNroautoriza,objCover,intTipoSolicitud,strClinicaSol);                            
}
                                                                         
public BeanList lstCobertura_his(int intProducto, int intTariff, int intCurrency, 
                                      int intRelation, String strSexo, int intPoliza, 
                                      int intCertif, String strClinica, String strCodCliente,
                                      int intEstado, String strNroSolicitud,int intRamo){
                     return atencion.lstCobertura_his(intProducto,intTariff,intCurrency,intRelation
                                     ,strSexo,intPoliza,intCertif,strClinica,strCodCliente,intEstado,strNroSolicitud,intRamo);                                             
            }
                                      
 public Bean getSiniestroLog(String strSiniestro){
        return atencion.getSiniestroLog(strSiniestro);
 }
 
public BeanList getLstSiniestroLog(String strFechaIniSol, String strFechaFinSol, String strSiniestro){
         return atencion.getLstSiniestroLog(strFechaIniSol,strFechaFinSol,strSiniestro);

}
public BeanList getLstSiniestroLog(String strFechaIniSol, String strFechaFinSol, String strSiniestro, String strClinica){

     return atencion.getLstSiniestroLog(strFechaIniSol,strFechaFinSol,strSiniestro,strClinica,clinica);
}
public double getMontoConsCover(int intPoliza, int intCertificado, String strStartDate,
                                      String strExpirDate, int intCover,int intRamo){
         return atencion.getMontoConsCover(intPoliza,intCertificado,strStartDate,strExpirDate,intCover,intRamo);                             
}
                                        
public int getEstadoCliente(int intPoliza, int intCertificado, int intRamo){
        return atencion.getEstadoCliente(intPoliza,intCertificado,intRamo);
}
public int getCantUsoCobertura(int intPoliza, int  intCertificado, int intCover, 
                                     int intPeriodo, String strCodCliente, int intConceptoPago, int intTipoFreq){
          return atencion.getCantUsoCobertura(intPoliza,intCertificado,intCover,intPeriodo,
                               strCodCliente,intConceptoPago,intTipoFreq);                                   
  }

public int validaClienteVip(int intPoliza , int intCertificado){
   return atencion.validaClienteVip(intPoliza,intCertificado);
}

public String getParentesco(int intCodParentesco){
 return atencion.getParentesco(intCodParentesco);
}
public BeanList lstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint){
      return atencion.lstDiagnosticosCabecera(intUsercomp,intCompany,intCodigint);
}
public BeanList lstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType){
       return atencion.lstDiagnosticosCabecera(intUsercomp,intCompany,intType);
}
public BeanList lstConceptoProducto(int intBranch,
                                              int intPolicy,
                                              int intPayConcep,
                                              int intModalidad,
                                              int intCover,
                                              int intTariff,
                                              String strEffecdate){
    return atencion.lstConceptoProducto(intBranch,intPolicy,intPayConcep,intModalidad,
                                 intCover,intTariff,strEffecdate);                                          
    }
  
public BeanList getLstWebCliHist(int intNroSiniestro, 
                                          int intNroTransaccion,
                                          String strCodDiagnostico){
              return atencion.getLstWebCliHist(intNroSiniestro,intNroTransaccion,strCodDiagnostico);                            
      }
                                          
public Bean getCliente_bit(int intPoliza, int intCertif, String strCodCliente, String strClinica, String strEffecDate){
        return atencion.getCliente_bit(intPoliza,intCertif,strCodCliente,strClinica,strEffecDate);
}                                          

public BeanList lstMaestroDiagnosticos(int intUsercomp, int intCompany, String strIllness, String strIllnessDes, String strStatregt){
         return atencion.lstMaestroDiagnosticos(intUsercomp,intCompany,strIllness,strIllnessDes,strStatregt);
}

public BeanList getLstExclusion(int intPoliza, int intCertif, String strCodCliente, int intRamo){
    return atencion.getLstExclusion(intPoliza,intCertif,strCodCliente,atencion, intRamo);
}

public BeanList getLstDiagnosticosDetalle(int intUsercomp,int intCompany,int intType){
       return atencion.getLstDiagnosticosDetalle(intUsercomp,intCompany,intType,atencion);
}

public BeanList getLstDiagnosticosCabecera(int intUsercomp,int intCompany,int intCodigint){
       return atencion.getLstDiagnosticosCabecera(intUsercomp,intCompany,intCodigint,atencion);
}

}