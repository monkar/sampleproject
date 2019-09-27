package com.clinica.daos;
import com.clinica.beans.Firma;

public interface FirmaDAO 
{
public Firma getFirmaBin(int intIdUsuFirma1, int intIdUsuFirma2, int IntRamo);
public Firma getFirma(int intTipoSolicitud, int intCodOficina);

}