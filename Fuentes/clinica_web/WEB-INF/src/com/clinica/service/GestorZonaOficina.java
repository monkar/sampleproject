package com.clinica.service;
import com.clinica.daos.ZonaOficinaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorZonaOficina 
{
   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
    
   ZonaOficinaDAO zonaoficina =  subFactory.getZonaOficinaDAO();
   
   public BeanList listZonaOficina(int intZona, int intOficina){
    return zonaoficina.listZonaOficina(intZona, intOficina);
   }
   
   public int insZonaOficina(int intZona, int intOficina, int intUsuarioReg, int intEstado, String strAction){
           return zonaoficina.insZonaOficina(intZona, intOficina, intUsuarioReg, intEstado, strAction);    
   }
}