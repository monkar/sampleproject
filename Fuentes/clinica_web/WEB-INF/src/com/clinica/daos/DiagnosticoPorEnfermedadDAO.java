package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.beans.DiagnosticoPorEnfermedad;
import com.clinica.utils.BeanList;

public interface DiagnosticoPorEnfermedadDAO 
{
 
 public BeanList valDiagnosticoPorAsegurado(String strCode, String strIllness);
 
}