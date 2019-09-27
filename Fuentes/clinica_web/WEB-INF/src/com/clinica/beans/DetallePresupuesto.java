package com.clinica.beans;

public class DetallePresupuesto 
{
  protected int intIdConcepto = 0;
  protected double dblMontoConcepto = 0;
  protected String strObservacion = "";

  public DetallePresupuesto()
  {
  }


  public void setIntIdConcepto(int intIdConcepto)
  {
    this.intIdConcepto = intIdConcepto;
  }


  public int getIntIdConcepto()
  {
    return intIdConcepto;
  }


  public void setDblMontoConcepto(double dblMontoConcepto)
  {
    this.dblMontoConcepto = dblMontoConcepto;
  }


  public double getDblMontoConcepto()
  {
    return dblMontoConcepto;
  }


  public void setStrObservacion(String strObservacion)
  {
    this.strObservacion = strObservacion;
  }


  public String getStrObservacion()
  {
    return strObservacion;
  }
}