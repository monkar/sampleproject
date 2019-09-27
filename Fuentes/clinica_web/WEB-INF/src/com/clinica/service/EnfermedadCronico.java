package com.clinica.service;

import com.clinica.daos.AtencionDAO;
import com.clinica.daos.ClinicaDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.CoberturaDAO;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;
import com.clinica.beans.Cobertura;

public class EnfermedadCronico 
{
  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
     
  //AtencionDAO atencion =  subFactory.getAntencionDAO(); 
      

  public EnfermedadCronico()
  {
  }
}