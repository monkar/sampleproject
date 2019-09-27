package com.clinica.service;

import com.clinica.daos.ClienteCronicoDAO;

import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorClienteCronico 
{

  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
  ClienteCronicoDAO clienteCronico =  subFactory.getClienteCronicoDAO();
  
  public int esPacCronico (String strCode){     
    return clienteCronico.esPacCronico(strCode);
  }
  
  public BeanList lstEnfermedadCronica (String strCode){     
    return clienteCronico.lstEnfermedadCronica(strCode);
  }
  
   public BeanList lstEnfermedadCronicaPorCliente (String strCode){     
    return clienteCronico.lstEnfermedadCronicaPorCliente(strCode);
  }
}