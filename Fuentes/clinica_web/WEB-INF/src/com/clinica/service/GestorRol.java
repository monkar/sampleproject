package com.clinica.service;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.RolDAO;
import com.clinica.utils.BeanList;

public class GestorRol 
{

      DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
      RolDAO rol =   subFactory.getRolDAO();


    public BeanList getLstRol(){
         return rol.getLstRol();
    }
    public BeanList lstRolJer(int intIdRol){
          return rol.lstRolJer(intIdRol);
    }
    public double getRangoRol(int intIdRol){
           return rol.getRangoRol(intIdRol);
    }
    public int valHoraAten(){
           return rol.valHoraAten();
    }
    public int valHoraAten(int intCodOficina){
           return rol.valHoraAten(intCodOficina);
    }
    public BeanList getLstRolModulo(int intTipo, int intIdRol){
              return rol.getLstRolModulo(intTipo,intIdRol);
    }
    public int updModuloRol(String strModulos , int intIdRol, int intIdUser){
                return rol.updModuloRol(strModulos,intIdRol,intIdUser);
    }


}