package com.clinica.beans;
import com.clinica.utils.Tool;

public class Cobertura {

String strNomCobertura;
  String strConceptoPago;
  String strTipoDeducible;
/*  double dblImpDeducible;
  double dblDeducible;
  double dblCoaseguro;
  double dblBeneficioMax;
  double dblBeneficioCons;*/
  String strImpDeducible;
  String strDeducible;
  String strCoaseguro;
  String strBeneficioMax;
  String strBeneficioCons;
  int intPeridoCarencia;
  String strCantidad="";
  int intTipoAtencion=0;
  String strTipoAtencion="";
  private int intCover=-1;
  private int intCoverGen=-1;
  private int intConceptoPago=0;
  String strCacalili = "";
  
  private int intPeriodoTrans=0;

  //RQ2019-626-INICIO
  private String strObservAseg =""; //Campo que obtiene observacion agregada desde el Core

  public void setStrObservAseg(String strObservAseg){
    this.strObservAseg = strObservAseg;
  }

  public String getStrObservAseg(){
    return this.strObservAseg;
  }
  //RQ2019-626-FIN
  
  
  public double getMaxFacturar()
  {
    return Tool.parseDouble(this.strBeneficioMax) - Tool.parseDouble(this.strBeneficioCons);
  }

  
  public void setStrNomCobertura(String strNomCobertura)
  {
    this.strNomCobertura = strNomCobertura;
  }


  public String getStrNomCobertura()
  {
    return strNomCobertura;
  }


  public void setStrConceptoPago(String strConceptoPago)
  {
    this.strConceptoPago = strConceptoPago;
  }


  public String getStrConceptoPago()
  {
    return strConceptoPago;
  }


  public void setStrTipoDeducible(String strTipoDeducible)
  {
    this.strTipoDeducible = strTipoDeducible;
  }


  public String getStrTipoDeducible()
  {
    return strTipoDeducible;
  }


  public void setStrImpDeducible(String strImpDeducible)
  {
    this.strImpDeducible = strImpDeducible;
  }


  public String getStrImpDeducible()
  {
    return strImpDeducible;
  }


  public void setStrDeducible(String strDeducible)
  {
    this.strDeducible = strDeducible;
  }


  public String getStrDeducible()
  {
    return strDeducible;
  }


  public void setStrCoaseguro(String strCoaseguro)
  {
    this.strCoaseguro = strCoaseguro;
  }


  public String getStrCoaseguro()
  {
    return strCoaseguro;
  }


  public void setStrBeneficioMax(String strBeneficioMax)
  {
    this.strBeneficioMax = strBeneficioMax;
  }


  public String getStrBeneficioMax()
  {
    return strBeneficioMax;
  }


  public void setStrBeneficioCons(String strBeneficioCons)
  {
    this.strBeneficioCons = strBeneficioCons;
  }


  public String getStrBeneficioCons()
  {
    return strBeneficioCons;
  }


  public void setIntPeridoCarencia(int intPeridoCarencia)
  {
    this.intPeridoCarencia = intPeridoCarencia;
  }


  public int getIntPeridoCarencia()
  {
    return intPeridoCarencia;
  }


  public void setStrCantidad(String strCantidad)
  {
    this.strCantidad = strCantidad;
  }


  public String getStrCantidad()
  {
    return strCantidad;
  }


  public void setStrTipoAtencion(String strTipoAtencion)
  {
    this.strTipoAtencion = strTipoAtencion;
  }


  public String getStrTipoAtencion()
  {
    return strTipoAtencion;
  }


  public void setIntTipoAtencion(int intTipoAtencion)
  {
    this.intTipoAtencion = intTipoAtencion;
  }


  public int getIntTipoAtencion()
  {
    return intTipoAtencion;
  }


  public void setIntCover(int intCover)
  {
    this.intCover = intCover;
  }


  public int getIntCover()
  {
    return intCover;
  }


  public void setIntCoverGen(int intCoverGen)
  {
    this.intCoverGen = intCoverGen;
  }


  public int getIntCoverGen()
  {
    return intCoverGen;
  }

    public void setIntConceptoPago(int intConceptoPago)
    {
      this.intConceptoPago = intConceptoPago;
    }
  
  
    public int getIntConceptoPago()
    {
      return intConceptoPago;
    }

  
    public void setIntPeriodoTrans(int intPeriodoTrans)
    {
      this.intPeriodoTrans = intPeriodoTrans;
    }
  
  
    public int getIntPeriodoTrans()
    {
      return intPeriodoTrans;
    }


  public void setStrCacalili(String strCacalili)
  {
    this.strCacalili = strCacalili;
  }


  public String getStrCacalili()
  {
    return strCacalili;
  }
    
  
}