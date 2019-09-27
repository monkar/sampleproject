package com.clinica.daos;
import com.clinica.utils.BeanList;

public interface RolDAO 
{

public BeanList getLstRol();
public BeanList lstRolJer(int intIdRol);
public double getRangoRol(int intIdRol);
public int valHoraAten();
public int valHoraAten(int intCodOficina);
public BeanList getLstRolModulo(int intTipo, int intIdRol);
public int updModuloRol(String strModulos , int intIdRol, int intIdUser);


}