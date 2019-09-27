package com.clinica.beans;

public class Modulo 
{
   protected int NIDMODULO=-1;
   private String SNOMBRE;
   private int NIDMODULOSUP=-1;
   private String SURL;
   private int NORDEN=-1;
   private int NNIVEL=-1;
   private int NTIPOVISTA=0;
   public Modulo() 
   {
    
   }


  public void setNIDMODULO(int NIDMODULO)
  {
    this.NIDMODULO = NIDMODULO;
  }


  public int getNIDMODULO()
  {
    return NIDMODULO;
  }


  public void setSNOMBRE(String SNOMBRE)
  {
    this.SNOMBRE = SNOMBRE;
  }


  public String getSNOMBRE()
  {
    return SNOMBRE;
  }


  public void setNIDMODULOSUP(int NIDMODULOSUP)
  {
    this.NIDMODULOSUP = NIDMODULOSUP;
  }


  public int getNIDMODULOSUP()
  {
    return NIDMODULOSUP;
  }


  public void setSURL(String SURL)
  {
    this.SURL = SURL;
  }


  public String getSURL()
  {
    return SURL;
  }


  public void setNORDEN(int NORDEN)
  {
    this.NORDEN = NORDEN;
  }


  public int getNORDEN()
  {
    return NORDEN;
  }


  public void setNNIVEL(int NNIVEL)
  {
    this.NNIVEL = NNIVEL;
  }


  public int getNNIVEL()
  {
    return NNIVEL;
  }


  public void setNTIPOVISTA(int NTIPOVISTA)
  {
    this.NTIPOVISTA = NTIPOVISTA;
  }


  public int getNTIPOVISTA()
  {
    return NTIPOVISTA;
  }
}
