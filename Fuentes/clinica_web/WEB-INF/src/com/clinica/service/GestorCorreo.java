package com.clinica.service;
import com.clinica.daos.CorreoDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorCorreo 
{
   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
    
   CorreoDAO correo = subFactory.getCorreoDAO();
   
   public BeanList listCorreo(int intZona, int intAlerta){
    return correo.listCorreo(intZona, intAlerta);
   }
   
   public int insCorreo(int intSec, int intZona, int intAlerta, String sCargo, String sApellido, String sNombre, String sEmail, int intEstado, int intUserReg, String strAction){
           return correo.insCorreo(intSec, intZona, intAlerta, sCargo, sApellido, sNombre, sEmail, intEstado, intUserReg, strAction);    
   }

   public int GrabaCorreoAvisoGerencia(int nIdCorreo, String sCorreo, int intUserReg, String strAction){
           return correo.GrabaCorreoAvisoGerencia(nIdCorreo, sCorreo, intUserReg, strAction);    
   }
   
   public int ProcesarEmailAsegurado(String sClient, String sCorreo, int intUserReg){
           return correo.ProcesarEmailAsegurado(sClient, sCorreo, intUserReg);    
   }
      public int GrabaCopiaCorreoRechazo(int nIdCorreo, String sCorreo, int intUserReg, String strAction){
           return correo.GrabaCopiaCorreoRechazo(nIdCorreo, sCorreo, intUserReg, strAction);    
   }
}