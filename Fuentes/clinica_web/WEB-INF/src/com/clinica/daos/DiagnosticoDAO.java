package com.clinica.daos;
import com.clinica.beans.*;
import com.clinica.utils.*;
import java.sql.Connection;

public interface DiagnosticoDAO 
{
  public String obtenerDiagnostico(Connection objCnnIfx, String strNroSiniestro);
}