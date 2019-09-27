package com.clinica.service;

import com.clinica.daos.DiagnosticoPorEnfermedadDAO;
import com.clinica.daos.DAOFactory;

import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorDiagnosticoPorEnfermedad 
{

    DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
    DiagnosticoPorEnfermedadDAO diagnostico =  subFactory.getDiagnosticoPorEnfermedadDAO(); 
     
    public BeanList valDiagnosticoPorAsegurado(String strCode, String strIllness){
     return diagnostico.valDiagnosticoPorAsegurado(strCode,strIllness);
 }
 
}