package com.clinica.service;

import com.clinica.daos.DAOFactory;
import com.clinica.daos.ModuloDAO;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;

public class GestorModulo 
{
  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
  ModuloDAO modulo =  subFactory.getModuloDAO();

  public BeanList getLstModulo(String strCriterio){
      return modulo.getLstModulo(strCriterio);
  }
  public Bean getModulo(int codigo){
   return modulo.getModulo(codigo);
  }
  public String listaCombo(BeanList beanList, String valor, String texto, String idPadre, int sModulo){
    return modulo.listaCombo(beanList,valor,texto,idPadre,sModulo);
  }
  public Bean getContadorModulo(int intOrden, int intPadre, int intModulo){
  
   return modulo.getContadorModulo(intOrden,intPadre,intModulo);
  }
  public int insertaModulo(String strNombre, int intNivel, int intPadre, String strUrl,int intOrden,int intUsuario){
      return modulo.insertaModulo(strNombre,intNivel,intPadre,strUrl,intOrden,intUsuario);
  }
  public int actualizaModulo(int intModulo, String strNombre, int intNivel, int intPadre, String strUrl, int intOrden,int intUsuario){
      return modulo.actualizaModulo(intModulo,strNombre,intNivel,intPadre,strUrl,intOrden,intUsuario);
  }
  public int deleteModuloGroup(String strCodigos){
       return modulo.deleteModuloGroup(strCodigos);
  }





}