package com.clinica.beans;

public class Rol
{
   private int NIDROL=0;
   private String SNOMBRE="";
   private int NIDROL_SUP=0;
   private int NIDROL_SUP2=0;
   private String  STIPO="";
   private int NMONTOMAXIOMO=0;
   
   public Rol() 
   {
    
   }


  public void setNIDROL(int NIDROL)
  {
    this.NIDROL = NIDROL;
  }


  public int getNIDROL()
  {
    return NIDROL;
  }


  public void setSNOMBRE(String SNOMBRE)
  {
    this.SNOMBRE = SNOMBRE;
  }


  public String getSNOMBRE()
  {
    return SNOMBRE;
  }


  public void setNIDROL_SUP(int NIDROL_SUP)
  {
    this.NIDROL_SUP = NIDROL_SUP;
  }


  public int getNIDROL_SUP()
  {
    return NIDROL_SUP;
  }


  public void setNIDROL_SUP2(int NIDROL_SUP2)
  {
    this.NIDROL_SUP2 = NIDROL_SUP2;
  }


  public int getNIDROL_SUP2()
  {
    return NIDROL_SUP2;
  }


  public void setSTIPO(String STIPO)
  {
    this.STIPO = STIPO;
  }


  public String getSTIPO()
  {
    return STIPO;
  }


  public void setNMONTOMAXIOMO(int NMONTOMAXIOMO)
  {
    this.NMONTOMAXIOMO = NMONTOMAXIOMO;
  }


  public int getNMONTOMAXIOMO()
  {
    return NMONTOMAXIOMO;
  }
}
