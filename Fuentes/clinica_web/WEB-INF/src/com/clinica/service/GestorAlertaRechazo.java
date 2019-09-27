package com.clinica.service;
import com.clinica.beans.AvisoRechazo;
import com.clinica.beans.Firma;
import com.clinica.daos.AlertaRechazoDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.FirmaDAO;

public class GestorAlertaRechazo 
{
   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
     AlertaRechazoDAO alertaRechazo = subFactory.getAlertaRechazoDAO();
     
   public Firma getFirmaBin(double dMontoCarta){
        return   alertaRechazo.getFirmaBin(dMontoCarta);
   }
   public Firma getFirma(int intTipoSolicitud, int intCodOficina){
         return alertaRechazo.getFirma(intTipoSolicitud,intCodOficina);
   }
   
   public AvisoRechazo getDatosFirmaRechazo(double montoRechazo){
        return alertaRechazo.getDatosFirmaRechazo(montoRechazo);
   };
}