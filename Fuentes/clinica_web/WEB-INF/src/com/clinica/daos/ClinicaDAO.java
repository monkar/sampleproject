package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface ClinicaDAO 
{

public BeanList lstClinica(int intIdUsuario);
public BeanList lstClinicaAviso(int intIdUsuario);
public Bean getClinica(String strCode);
public boolean getPolClinica(String strWerServer, int intPoliza, int codRamo);
public BeanList lstClinicaIfx(String strDesc);
public BeanList lstClinicaWeb(int intUsercomp,
                                      int intCompany,
                                      String strTenserver,
                                      String strStatregt,
                                      String strDescriptCliename);




}