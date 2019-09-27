package com.clinica.daos;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public interface ModuloDAO 
{

  public BeanList getLstModulo(String strCriterio);
  public Bean getModulo(int codigo);
  public String listaCombo(BeanList beanList, String valor, String texto, String idPadre, int sModulo);
  public Bean getContadorModulo(int intOrden, int intPadre, int intModulo);
  public int insertaModulo(String strNombre, int intNivel, int intPadre, String strUrl,int intOrden,int intUsuario);
  public int actualizaModulo(int intModulo, String strNombre, int intNivel, int intPadre, String strUrl, int intOrden,int intUsuario);
  public int deleteModuloGroup(String strCodigos);


}