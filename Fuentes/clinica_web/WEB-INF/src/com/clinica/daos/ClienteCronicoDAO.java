package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.beans.ClienteCronico;
import com.clinica.utils.BeanList;

public interface ClienteCronicoDAO 
{
    public int esPacCronico (String strCode); 
    public BeanList lstEnfermedadCronica (String strCode); 
    public BeanList lstEnfermedadCronicaPorCliente (String strCode); 
  
}