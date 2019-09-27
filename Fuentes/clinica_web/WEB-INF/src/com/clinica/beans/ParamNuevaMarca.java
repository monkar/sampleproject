package com.clinica.beans;

public class ParamNuevaMarca 
{
  private int NIdApp;
  private String SDescripcionApp;
  private String SUrlAnterior;
  private String SUrlNew;
  private int NIdFlag;  
  
  public ParamNuevaMarca()
  {
  }

  public void setNIdApp(int NIdApp)
  {
    this.NIdApp = NIdApp;
  }

  public int getNIdApp()
  {
    return NIdApp;
  }

  public void setSDescripcionApp(String SDescripcionApp)
  {
    this.SDescripcionApp = SDescripcionApp;
  }

  public String getSDescripcionApp()
  {
    return SDescripcionApp;
  }

  public void setSUrlAnterior(String SUrlAnterior)
  {
    this.SUrlAnterior = SUrlAnterior;
  }

  public String getSUrlAnterior()
  {
    return SUrlAnterior;
  }

  public void setSUrlNew(String SUrlNew)
  {
    this.SUrlNew = SUrlNew;
  }

  public String getSUrlNew()
  {
    return SUrlNew;
  }

  public void setNIdFlag(int NIdFlag)
  {
    this.NIdFlag = NIdFlag;
  }

  public int getNIdFlag()
  {
    return this.NIdFlag;
  } 
  
}