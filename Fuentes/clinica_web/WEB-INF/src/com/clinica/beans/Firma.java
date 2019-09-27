package com.clinica.beans;

public class Firma 
{
  private byte[][] bFirmas;
  private int[] intIdUsuario;
  private String[] strNombres;
  private String[] strCargos;
  
   public void setIntIdUsuario(int[] intIdUsuario)
  {
    this.intIdUsuario = intIdUsuario;
  }


  public int[] getIntIdUsuario()
  {
    return intIdUsuario;
  }


  public void set_intIdUsuario(int[] intIdUsuario)
  {
    this.intIdUsuario = intIdUsuario;
  }


  public int[] get_intIdUsuario()
  {
    return intIdUsuario;
  }


  public void setStrCargos(String[] strCargos)
  {
    this.strCargos = strCargos;
  }


  public String[] getStrCargos()
  {
    return strCargos;
  }
  
   public void setBFirmas(byte[][] bFirmas)
  {
    this.bFirmas = bFirmas;
  }


  public byte[][] getBFirmas()
  {
    return bFirmas;
  }


  public void setStrNombres(String[] strNombres)
  {
    this.strNombres = strNombres;
  }


  public String[] getStrNombres()
  {
    return strNombres;
  }

}