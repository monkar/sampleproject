package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface AlertaDAO 
{
  public BeanList listAlerta(double dblMontoMaximo, double dblMontoMinimo);
  
  public int insAlerta(int intAlerta, String sDescripcion, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction);
  
  public BeanList getlstAlerta();
  
  public BeanList listAlertaRechazo(double dblMontoMaximo,double dblMontoMinimo,String nEncargado,String nCargo);
  
  public int insAlertaRechazo(int intAlerta, String sDescripcion, String sCargo, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction);
  
}