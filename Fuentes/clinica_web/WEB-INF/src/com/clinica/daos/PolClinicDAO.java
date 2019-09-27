package com.clinica.daos;
import com.clinica.beans.Pol_Clinic;
import com.clinica.beans.Poliza;
import com.clinica.beans.Cobertura;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import java.util.ArrayList;

public interface PolClinicDAO 
{

public boolean insPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode);
public boolean delPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode);
public BeanList lstPol_Clinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                        int intTariff,int intRed, String dEffeccdate, int intConcep);
 
public Poliza getPoliza(int intBranch, int intPolicy, int intFlgValida);

public boolean valinsPolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate);
                                        
public boolean updPolclinic(Pol_Clinic objPolcli, int intIdUsuario, int intUserCode);

public boolean insPolclinicLog(Pol_Clinic objPolcli, int idUsuario, int intUserCode, String strAcc);

public boolean valDatePolclinic(int intBranch, int intPolicy,int intCover,int intModalidad,
                                     int intTariff,int intRed, int intCodClinic, String strEffecdate);
                                                                       
public Bean getMonedaPoliza(int intPoliza);
  
public BeanList getCoberturaPoliza(int intProducto, int intMoneda);
    
public Bean getContratante(int intPoliza, int  intCertificado);

public ArrayList getLstCobertura( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado,AtencionDAO atencion, int intRamo,int intCaso);
  
 public ArrayList getLstCobertura_his( int intProducto, int intTariff, int intCurrency, 
                               int intRelation, String strSexo, int intPoliza, 
                               int intCertif, String strClinica, String strCodCliente,
                               int intEstado, String strNroSolicitud,AtencionDAO atencion,int intRamo);
                               
public Cobertura getCoberSin( Bean objBean,int intPoliza, int intCertif,AtencionDAO atencion,int intRamo);

public ArrayList getLstConceptoProducto( int intBranch,
                                                  int intPolicy,
                                                  int intPayConcep,
                                                  int intModalidad,
                                                  int intCover,
                                                  int intTariff,
                                                  String strEffecdate,AtencionDAO atencion);
                                                  
                            
 public BeanList getLstClinicaCoberturaWeb(int intCodClinica, int intCodCobertura, int intUserComp, int intCompany, String strStatRegt);
 
 public Bean getClinicaCoberturaWeb(BeanList lstClinicaCoberturaWeb, int intCodCobertura);
  
public Poliza getDatePoli(int intPoliza, int intCertif);//RQ2015-000604  

}