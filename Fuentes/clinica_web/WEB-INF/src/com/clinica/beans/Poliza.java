package com.clinica.beans;

public class Poliza 
{
  int intPolicy = 0;
  int intProduct = 0;
  int intBranch = 0;
  String strContrat =""; //Nombre del contratante
  String strDesProduct =""; //Descripcion del Producto
  int intCurrrency = 0;
  double dblMaxMontoCoaseguro = 0; // P 2012-0078
  String strCurrencySymbol = ""; // P 2012-0078
  String strStarDate ="";       //RQ2015-000604
  String strExpirDate ="";      //RQ2015-000604
  
  public Poliza()
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


  public void setIntProduct(int intProduct)
  {
    this.intProduct = intProduct;
  }


  public int getIntProduct()
  {
    return intProduct;
  }


  public void setIntBranch(int intBranch)
  {
    this.intBranch = intBranch;
  }


  public int getIntBranch()
  {
    return intBranch;
  }


  public void setStrContrat(String strContrat)
  {
    this.strContrat = strContrat;
  }


  public String getStrContrat()
  {
    return strContrat;
  }


  public void setStrDesProduct(String strDesProduct)
  {
    this.strDesProduct = strDesProduct;
  }


  public String getStrDesProduct()
  {
    return strDesProduct;
  }


  public void setIntCurrrency(int intCurrrency)
  {
    this.intCurrrency = intCurrrency;
  }


  public int getIntCurrrency()
  {
    return intCurrrency;
  }
  
    
  public void setDblMaxMontoCoaseguro(double dblMaxMontoCoaseguro)
  {
    this.dblMaxMontoCoaseguro = dblMaxMontoCoaseguro;
  }

  public double getDblMaxMontoCoaseguro()
  {
    return dblMaxMontoCoaseguro;
  }

  public void setStrCurrencySymbol(String strCurrencySymbol)
  {
    this.strCurrencySymbol = strCurrencySymbol;
  }
  
  public String getStrCurrencySymbol()
  {
    return strCurrencySymbol;
  }  


  public void setStrStarDate(String strStarDate)
  {
    this.strStarDate = strStarDate;
  }


  public String getStrStarDate()
  {
    return strStarDate;
  }


  public void setStrExpirDate(String strExpirDate)
  {
    this.strExpirDate = strExpirDate;
  }


  public String getStrExpirDate()
  {
    return strExpirDate;
  }

}