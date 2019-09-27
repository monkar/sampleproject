package com.clinica.daos;
import com.clinica.beans.AvisoRechazo;
import com.clinica.beans.Firma;

public interface AlertaRechazoDAO 
{
  
  public Firma getFirmaBin(double dMontoCarta);
  public Firma getFirma(int intTipoSolicitud, int intCodOficina);
  public AvisoRechazo getDatosFirmaRechazo(double montoRechazo);
  
}