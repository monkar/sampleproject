package com.clinica.service;

import com.clinica.beans.Cliente;
import com.clinica.beans.Solicitud;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.EmailDAO;
import com.clinica.utils.Bean;


public class GestorEmail 
{

 DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
 EmailDAO email =  subFactory.getEmailDAO();

 
public int enviaEmail(int intMotivo, String strAsunto,  String strContenido){
    return email.enviaEmail(intMotivo,strAsunto,strContenido);
}
public int enviaEmailBandeja(int intMotivo, int intRol, int intOficina, String strSiniestro){
    return email.enviaEmailBandeja(intMotivo,intRol,intOficina,strSiniestro);
}
public int enviaMailDeuda(Bean objContratante, int intPoliza, int intCertificado, Cliente objCliente, 
                              Solicitud objSolicitud, String strNombClinica){
                              return email.enviaMailDeuda(objContratante,intPoliza,intCertificado,objCliente,
                              objSolicitud,strNombClinica);
            }


}