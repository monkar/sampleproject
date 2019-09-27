package com.clinica.daos;
import com.clinica.beans.Cliente;
import com.clinica.beans.Solicitud;
import com.clinica.utils.Bean;

public interface EmailDAO 
{
public int enviaEmail(int intMotivo, String strAsunto,  String strContenido);
public int enviaEmailBandeja(int intMotivo, int intRol, int intOficina, String strSiniestro);
public int enviaMailDeuda(Bean objContratante, int intPoliza, int intCertificado, Cliente objCliente, 
                              Solicitud objSolicitud, String strNombClinica);
}