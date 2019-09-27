package com.clinica.beans;

public class Pol_Clinic 
{
  int intUsercomp = 1;
  int intCompany = 1;
  String strCertype = "2";
  int intBranch = 0;
  int intPolicy = 0;
  int intCodClinic = 0;
  String dEffecdate;
  int intModalidad;
  int intCover=0;
  int intTariff=0;
  double dblDed_amount =0 ;
  double dblDed_percen =0;
  double dblIndem_rate=0;
  double dblLimit=0;
  int intRed=0;
  int intPay_concep=0;
  int intDed_quanti=0;
  
  String strClinica = "";
  String strModalidad ="";
  String strConcepto = "";
  String strTipoDedu = "";

  public Pol_Clinic()
  {
      
  }
 
  public void setIntPolicy(int intPolicy)
  {
    this.intPolicy = intPolicy;
  }


  public int getIntPolicy()
  {
    return intPolicy;
  }

  public void setDEffecdate(String dEffecdate)
  {
    this.dEffecdate = dEffecdate;
  }


  public String getDEffecdate()
  {
    return dEffecdate;
  }


  public void setIntModalidad(int intModalidad)
  {
    this.intModalidad = intModalidad;
  }


  public int getIntModalidad()
  {
    return intModalidad;
  }


  public void setIntCover(int intCover)
  {
    this.intCover = intCover;
  }


  public int getIntCover()
  {
    return intCover;
  }


  public void setIntTariff(int intTariff)
  {
    this.intTariff = intTariff;
  }


  public int getIntTariff()
  {
    return intTariff;
  }

  public int getIntUsercomp()
  {
    return intUsercomp;
  }


  public int getIntCompany()
  {
    return intCompany;
  }


  public String getStrCertype()
  {
    return strCertype;
  }


  public void setIntBranch(int intBranch)
  {
    this.intBranch = intBranch;
  }


  public int getIntBranch()
  {
    return intBranch;
  }


  public void setDblDed_amount(double dblDed_amount)
  {
    this.dblDed_amount = dblDed_amount;
  }


  public double getDblDed_amount()
  {
    return dblDed_amount;
  }


  public void setDblDed_percen(double dblDed_percen)
  {
    this.dblDed_percen = dblDed_percen;
  }


  public double getDblDed_percen()
  {
    return dblDed_percen;
  }


  public void setDblIndem_rate(double dblIndem_rate)
  {
    this.dblIndem_rate = dblIndem_rate;
  }


  public double getDblIndem_rate()
  {
    return dblIndem_rate;
  }


  public void setDblLimit(double dblLimit)
  {
    this.dblLimit = dblLimit;
  }


  public double getDblLimit()
  {
    return dblLimit;
  }


  public void setIntRed(int intRed)
  {
    this.intRed = intRed;
  }


  public int getIntRed()
  {
    return intRed;
  }


  public void setIntPay_concep(int intPay_concep)
  {
    this.intPay_concep = intPay_concep;
  }


  public int getIntPay_concep()
  {
    return intPay_concep;
  }


  public void setIntDed_quanti(int intDed_quanti)
  {
    this.intDed_quanti = intDed_quanti;
  }


  public int getIntDed_quanti()
  {
    return intDed_quanti;
  }


  public void setIntCodClinic(int intCodClinic)
  {
    this.intCodClinic = intCodClinic;
  }


  public int getIntCodClinic()
  {
    return intCodClinic;
  }


  public void setStrClinica(String strClinica)
  {
    this.strClinica = strClinica;
  }


  public String getStrClinica()
  {
    return strClinica;
  }


  public void setStrModalidad(String strModalidad)
  {
    this.strModalidad = strModalidad;
  }


  public String getStrModalidad()
  {
    return strModalidad;
  }


  public void setStrConcepto(String strConcepto)
  {
    this.strConcepto = strConcepto;
  }


  public String getStrConcepto()
  {
    return strConcepto;
  }


  public void setStrTipoDedu(String strTipoDedu)
  {
    this.strTipoDedu = strTipoDedu;
  }


  public String getStrTipoDedu()
  {
    return strTipoDedu;
  }
}