package com.clinica.beans;

public class Cliente 
{
  
      int intCodSexo=0;//PRT  
    String strIdeDocIdentidad="";//PRT si tiene valor el campo DNI será 2, si no tiene valor, será 1
    String strIdeDocIdentidadTitular =""; //PRT si tiene valor el campo DNI será 2, si no tiene valor, será 1    
    String strDni="";//PRT
    String strRuc="";//PRT
    String strApePat="";//PRT
    String strApeMat="";//PRT
    String strNomb="";//PRT
    String strDniTitular = ""; //PRT
    String strRucTitular = ""; //PRT
    String strApePatTitular = ""; //PRT
    String strApeMatTitular = ""; //PRT
    String strNombTitular = ""; //PRT
    String strCodParentesco="";//PRT

  String strNombreAseg = "";
  String strCodAseg = "";
  String strNombreTitular = "";
  String strCodigo = "";
  String strFecNac = "";
  String strParentesco = "";
  String strSexo = "";
    //INI
    //*************** Definicion de Variables de Imagenes____Cambio QNET 28/12/11
    String strRuta_Server_D = "";
    String strRuta_Server_I = "";
    String strRuta_ServerTmp = "";
    //FIN
    //*************** Definicion de Variables de Imagenes____Cambio QNET 28/12/11
    
  String strCodExtSexo = "";
  String strFecIngreso = "";
  String strFecFinCarencia = "";
  String strContratante = "";
  String strCodContratante = "";
  String strFecFinVigencia = "";
  int intDiasCarencia = -1;
  String strPlan = "";
  String strEstado = "";
  String strMoneda = "";
  int intProducto = 0;
  String strFecCese = "";
  int intPoliza=0;
  int intCertificado=-1;  
  int intCodMoneda = 0;
  int intCodEstado = 0;
  int intCodPlan  = 0;
  int intCodParentesco = 0;
  int intIndExcl = 0;
  int intEstadoDeuda = 0;
  
  int intFlgObserv = 0;
  String strCodTitular = "";
  String strFecInicioVigencia = "";
  int intFlgRenov = 0;
  
  String strDNI = "";
  String strDireccion = "";
  String strTelefono = "";
  int intCategoria = 0;
  int intCodBrokerInx = 0;
  // AVM : variable para la continuidad es el campo continuity
  String strContinuidadInx="";
  //Apple
  int intRamo =0;
  String strRamo= "";
  int intCase = 0;
  String strCausa = "";
  String strOcurr = "";
  String strClinic = "";
  String strContrat= "";
  String strIngres = "";
  //Apple
  //RQ2015-000750 Inicio
  protected String strEmail="";
  //RQ2015-000750 Fin
  
  
  

  
   public void setStrNombreAseg(String strNombreAseg)
  {
    this.strNombreAseg = strNombreAseg;
  }


  public String getStrNombreAseg()
  {
    return strNombreAseg;
  }


  public void setStrNombreTitular(String strNombreTitular)
  {
    this.strNombreTitular = strNombreTitular;
  }


  public String getStrNombreTitular()
  {
    return strNombreTitular;
  }


  public void setStrFecNac(String strFecNac)
  {
    this.strFecNac = strFecNac;
  }


  public String getStrFecNac()
  {
    return strFecNac;
  }


  public void setStrParentesco(String strParentesco)
  {
    this.strParentesco = strParentesco;
  }


  public String getStrParentesco()
  {
    return strParentesco;
  }


  public void setStrSexo(String strSexo)
  {
    this.strSexo = strSexo;
  }


  public String getStrSexo()
  {
    return strSexo;
  }

 //INI
 //****************** Definicion de Variables de Imagenes____Cambio QNET 28/12/11
  public void setStrRuta_Server_D(String strRuta_Server_D)
  {
    this.strRuta_Server_D = strRuta_Server_D;
  }

 public String getStrRuta_Server_D()
  {
   return strRuta_Server_D;
  }
  
 public void setStrRuta_Server_Tmp(String strRuta_Server_Tmp)
  {
    this.strRuta_ServerTmp = strRuta_ServerTmp;
  }

 public String getStrRuta_Server_Tmp()
  {
   return strRuta_ServerTmp;
  }

  public void setStrRuta_Server_I(String strRuta_Server_I)
  {
    this.strRuta_Server_I = strRuta_Server_I;
  }

 public String getStrRuta_Server_I()
  {
   return strRuta_Server_I;
  }
 //FIN
 //****************** Definicion de Variables de Imagenes____Cambio QNET 28/12/11
  public void setStrFecIngreso(String strFecIngreso)
  {
    this.strFecIngreso = strFecIngreso;
  }


  public String getStrFecIngreso()
  {
    return strFecIngreso;
  }


  public void setStrFecFinCarencia(String strFecFinCarencia)
  {
    this.strFecFinCarencia = strFecFinCarencia;
  }


  public String getStrFecFinCarencia()
  {
    return strFecFinCarencia;
  }


  public void setStrContratante(String strContratante)
  {
    this.strContratante = strContratante;
  }


  public String getStrContratante()
  {
    return strContratante;
  }


  public void setStrFecFinVigencia(String strFecFinVigencia)
  {
    this.strFecFinVigencia = strFecFinVigencia;
  }


  public String getStrFecFinVigencia()
  {
    return strFecFinVigencia;
  }


  public void setIntDiasCarencia(int intDiasCarencia)
  {
    this.intDiasCarencia = intDiasCarencia;
  }


  public int getIntDiasCarencia()
  {
    return intDiasCarencia;
  }


  public void setStrPlan(String strPlan)
  {
    this.strPlan = strPlan;
  }


  public String getStrPlan()
  {
    return strPlan;
  }


  public void setStrEstado(String strEstado)
  {
    this.strEstado = strEstado;
  }


  public String getStrEstado()
  {
    return strEstado;
  }


  public void setStrMoneda(String strMoneda)
  {
    this.strMoneda = strMoneda;
  }


  public String getStrMoneda()
  {
    return strMoneda;
  }



  public void setStrFecCese(String strFecCese)
  {
    this.strFecCese = strFecCese;
  }


  public String getStrFecCese()
  {
    return strFecCese;
  }


  public void setIntPoliza(int intPoliza)
  {
    this.intPoliza = intPoliza;
  }


  public int getIntPoliza()
  {
    return intPoliza;
  }


  public void setIntCertificado(int intCertificado)
  {
    this.intCertificado = intCertificado;
  }


  public int getIntCertificado()
  {
    return intCertificado;
  }


  public void setStrCodigo(String strCodigo)
  {
    this.strCodigo = strCodigo;
  }


  public String getStrCodigo()
  {
    return strCodigo;
  }


  public void setIntProducto(int intProducto)
  {
    this.intProducto = intProducto;
  }


  public int getIntProducto()
  {
    return intProducto;
  }


  public void setIntCodMoneda(int intCodMoneda)
  {
    this.intCodMoneda = intCodMoneda;
  }


  public int getIntCodMoneda()
  {
    return intCodMoneda;
  }


  public void setIntCodEstado(int intCodEstado)
  {
    this.intCodEstado = intCodEstado;
  }


  public int getIntCodEstado()
  {
    return intCodEstado;
  }


  public void setIntCodPlan(int intCodPlan)
  {
    this.intCodPlan = intCodPlan;
  }


  public int getIntCodPlan()
  {
    return intCodPlan;
  }


  public void setIntCodParentesco(int intCodParentesco)
  {
    this.intCodParentesco = intCodParentesco;
  }


  public int getIntCodParentesco()
  {
    return intCodParentesco;
  }


  public void setIntIndExcl(int intIndExcl)
  {
    this.intIndExcl = intIndExcl;
  }


  public int getIntIndExcl()
  {
    return intIndExcl;
  }


  public void setStrCodExtSexo(String strCodExtSexo)
  {
    this.strCodExtSexo = strCodExtSexo;
  }


  public String getStrCodExtSexo()
  {
    return strCodExtSexo;
  }


  public void setStrCodAseg(String strCodAseg)
  {
    this.strCodAseg = strCodAseg;
  }


  public String getStrCodAseg()
  {
    return strCodAseg;
  }


  public void setStrCodContratante(String strCodContratante)
  {
    this.strCodContratante = strCodContratante;
  }


  public String getStrCodContratante()
  {
    return strCodContratante;
  }


  public void setIntEstadoDeuda(int intEstadoDeuda)
  {
    this.intEstadoDeuda = intEstadoDeuda;
  }


  public int getIntEstadoDeuda()
  {
    return intEstadoDeuda;
  }
  
  public void setIntFlgObserv(int intFlgObserv)
  {
    this.intFlgObserv = intFlgObserv;
  }


  public int getIntFlgObserv()
  {
    return intFlgObserv;
  }




  public void setStrDNI(String strDNI)
  {
    this.strDNI = strDNI;
  }


  public String getStrDNI()
  {
    return strDNI;
  }


  public void setStrDireccion(String strDireccion)
  {
    this.strDireccion = strDireccion;
  }


  public String getStrDireccion()
  {
    return strDireccion;
  }


  public void setStrCodTitular(String strCodTitular)
  {
    this.strCodTitular = strCodTitular;
  }


  public String getStrCodTitular()
  {
    return strCodTitular;
  }


  public void setStrTelefono(String strTelefono)
  {
    this.strTelefono = strTelefono;
  }


  public String getStrTelefono()
  {
    return strTelefono;
  }


  public void setStrFecInicioVigencia(String strFecInicioVigencia)
  {
    this.strFecInicioVigencia = strFecInicioVigencia;
  }


  public String getStrFecInicioVigencia()
  {
    return strFecInicioVigencia;
  }


  public void setIntFlgRenov(int intFlgRenov)
  {
    this.intFlgRenov = intFlgRenov;
  }


  public int getIntFlgRenov()
  {
    return intFlgRenov;
  }


  public void setIntCategoria(int intCategoria)
  {
    this.intCategoria = intCategoria;
  }


  public int getIntCategoria()
  {
    return intCategoria;
  }
  
  public void setIntCodBrokerInx(int intCodBrokerInx)
  {
    this.intCodBrokerInx = intCodBrokerInx;
  }


  public int getIntCodBrokerInx()
  {
    return intCodBrokerInx;
  }
// AVM : variable para la continuidad es el campo continuity
  public void setStrContinuidadInx(String strContinuidadInx)
  {
    this.strContinuidadInx = strContinuidadInx;
  }
// AVM : variable para la continuidad es el campo continuity
  public String getStrContinuidadInx()
  {
    return strContinuidadInx;
  }

//PRT
  public void setIntCodSexo(int intCodSexo)
  {
    this.intCodSexo = intCodSexo;
  }

//PRT
  public int getIntCodSexo()
  {
    return intCodSexo;
  }

//PRT
  public void setStrIdeDocIdentidad(String strIdeDocIdentidad)
  {
    this.strIdeDocIdentidad = strIdeDocIdentidad;
  }

//PRT
  public String getStrIdeDocIdentidad()
  {
    return strIdeDocIdentidad;
  }

//PRT
  public void setStrIdeDocIdentidadTitular(String strIdeDocIdentidadTitular)
  {
    this.strIdeDocIdentidadTitular = strIdeDocIdentidadTitular;
  }

//PRT
  public String getStrIdeDocIdentidadTitular()
  {
    return strIdeDocIdentidadTitular;
  }

//PRT
  public void setStrDni(String strDni)
  {
    this.strDni = strDni;
  }

//PRT
  public String getStrDni()
  {
    return strDni;
  }

//PRT
  public void setStrRuc(String strRuc)
  {
    this.strRuc = strRuc;
  }

//PRT
  public String getStrRuc()
  {
    return strRuc;
  }

//PRT
  public void setStrApePat(String strApePat)
  {
    this.strApePat = strApePat;
  }

//PRT
  public String getStrApePat()
  {
    return strApePat;
  }

//PRT
  public void setStrApeMat(String strApeMat)
  {
    this.strApeMat = strApeMat;
  }

//PRT
  public String getStrApeMat()
  {
    return strApeMat;
  }

//PRT
  public void setStrNomb(String strNomb)
  {
    this.strNomb = strNomb;
  }

//PRT
  public String getStrNomb()
  {
    return strNomb;
  }

//PRT
  public void setStrDniTitular(String strDniTitular)
  {
    this.strDniTitular = strDniTitular;
  }

//PRT
  public String getStrDniTitular()
  {
    return strDniTitular;
  }

//PRT
  public void setStrRucTitular(String strRucTitular)
  {
    this.strRucTitular = strRucTitular;
  }

//PRT
  public String getStrRucTitular()
  {
    return strRucTitular;
  }

//PRT
  public void setStrApePatTitular(String strApePatTitular)
  {
    this.strApePatTitular = strApePatTitular;
  }

//PRT
  public String getStrApePatTitular()
  {
    return strApePatTitular;
  }

//PRT
  public void setStrApeMatTitular(String strApeMatTitular)
  {
    this.strApeMatTitular = strApeMatTitular;
  }

//PRT
  public String getStrApeMatTitular()
  {
    return strApeMatTitular;
  }

//PRT
  public void setStrNombTitular(String strNombTitular)
  {
    this.strNombTitular = strNombTitular;
  }

//PRT
  public String getStrNombTitular()
  {
    return strNombTitular;
  }

//PRT
  public void setStrCodParentesco(String strCodParentesco)
  {
    this.strCodParentesco = strCodParentesco;
  }

//PRT
  public String getStrCodParentesco()
  {
    return strCodParentesco;
  }
  

  public void setStrEmail(String strEmail)
  {
    this.strEmail = strEmail;
  }


  public String getStrEmail()
  {
    return strEmail;
  }


  public void setIntRamo(int intRamo)
  {
    this.intRamo = intRamo;
  }


  public int getIntRamo()
  {
    return intRamo;
  }


  public void setStrRamo(String strRamo)
  {
    this.strRamo = strRamo;
  }


  public String getStrRamo()
  {
    return strRamo;
  }


  public void setIntCase(int intCase)
  {
    this.intCase = intCase;
  }


  public int getIntCase()
  {
    return intCase;
  }


  public void setStrCausa(String strCausa)
  {
    this.strCausa = strCausa;
  }


  public String getStrCausa()
  {
    return strCausa;
  }


  public void setStrOcurr(String strOcurr)
  {
    this.strOcurr = strOcurr;
  }


  public String getStrOcurr()
  {
    return strOcurr;
  }


  public void setStrClinic(String strClinic)
  {
    this.strClinic = strClinic;
  }


  public String getStrClinic()
  {
    return strClinic;
  }


  public void setStrContrat(String strContrat)
  {
    this.strContrat = strContrat;
  }


  public String getStrContrat()
  {
    return strContrat;
  }


  public void setStrIngres(String strIngres)
  {
    this.strIngres = strIngres;
  }


  public String getStrIngres()
  {
    return strIngres;
  }
  
}