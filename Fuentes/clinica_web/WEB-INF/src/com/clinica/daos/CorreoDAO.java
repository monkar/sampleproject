package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface CorreoDAO 
{
  public BeanList listCorreo(int intZona, int intAlerta);
  
  public int insCorreo(int intSec, int intZona, int intAlerta, String sCargo, String sApellido, String sNombre, String sEmail, int intEstado, int intUserReg, String strAction);
  
  public int GrabaCorreoAvisoGerencia(int nIdCorreo, String sCorreo, int intUserReg, String strAction);
  
  public int ProcesarEmailAsegurado(String sClient, String sCorreo, int intUserReg);
  
  public int GrabaCopiaCorreoRechazo(int nIdCorreo, String sCorreo, int intUserReg, String strAction);
}