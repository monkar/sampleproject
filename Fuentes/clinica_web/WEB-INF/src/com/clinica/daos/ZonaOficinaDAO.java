package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface ZonaOficinaDAO 
{
  public BeanList listZonaOficina(int intZona, int intOficina);

  public int insZonaOficina(int intZona, int intOficina, int intUsuarioReg, int intEstado, String strAction);
}