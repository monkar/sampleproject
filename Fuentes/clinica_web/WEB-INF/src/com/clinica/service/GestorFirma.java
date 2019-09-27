package com.clinica.service;
import com.clinica.beans.Firma;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.FirmaDAO;

public class GestorFirma 
{
   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
     FirmaDAO firma = subFactory.getFirmaDAO();
     
   public Firma getFirmaBin(int intIdUsuFirma1, int intIdUsuFirma2, int IntRamo){
        return   firma.getFirmaBin(intIdUsuFirma1,intIdUsuFirma2, IntRamo);
   }
   public Firma getFirma(int intTipoSolicitud, int intCodOficina){
         return firma.getFirma(intTipoSolicitud,intCodOficina);
   }
   
   
}