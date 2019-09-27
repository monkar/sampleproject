package com.clinica.service;
import com.clinica.daos.AlertaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorAlerta 
{
   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
    
   AlertaDAO alerta =  subFactory.getAlertaDAO();
   
   public BeanList listAlerta(double dblMontoMaximo, double dblMontoMinimo){
    return alerta.listAlerta(dblMontoMaximo, dblMontoMinimo);
   }
   
   public int insAlerta(int intAlerta, String sDescripcion, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction){
           return alerta.insAlerta(intAlerta, sDescripcion, dblMontoMinimo, dblMontoMaximo, intEstado, intUsuarioReg, strAction);    
   }
   
   public BeanList getlstAlerta(){
    return alerta.getlstAlerta();
   }
   
   public BeanList listAlertaRechazo(double dblMontoMaximo, double dblMontoMinimo, String nEncargado,String nCargo){
    return alerta.listAlertaRechazo(dblMontoMaximo, dblMontoMinimo,nEncargado,nCargo);
   }
   
  public int insAlertaRechazo(int intAlerta, String sDescripcion, String sCargo, double dblMontoMinimo, double dblMontoMaximo, int intEstado, int intUsuarioReg,  String strAction){
           return alerta.insAlertaRechazo(intAlerta, sDescripcion, sCargo, dblMontoMinimo, dblMontoMaximo, intEstado, intUsuarioReg, strAction);    
   }
}