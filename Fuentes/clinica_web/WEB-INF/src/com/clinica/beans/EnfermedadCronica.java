package com.clinica.beans;
import  java.util.*;

public class EnfermedadCronica 
{

 int intId_cro = 0;
 String strDescript = "";
 Date fecCompdate = null;
 String strStatregt="";
 Date fecEffecdate = null;
 Date fecNulldate = null; 
 int usercode = 0;
 String strShortdescript="";
 String strState ="";

  public void setIntId_cro(int intId_cro)
  {
    this.intId_cro = intId_cro;
  }


  public int getIntId_cro()
  {
    return intId_cro;
  }


  public void setStrDescript(String strDescript)
  {
    this.strDescript = strDescript;
  }


  public String getStrDescript()
  {
    return strDescript;
  }


  public void setFecCompdate(Date fecCompdate)
  {
    this.fecCompdate = fecCompdate;
  }


  public Date getFecCompdate()
  {
    return fecCompdate;
  }


  public void setStrStatregt(String strStatregt)
  {
    this.strStatregt = strStatregt;
  }


  public String getStrStatregt()
  {
    return strStatregt;
  }


  public void setFecEffecdate(Date fecEffecdate)
  {
    this.fecEffecdate = fecEffecdate;
  }


  public Date getFecEffecdate()
  {
    return fecEffecdate;
  }


  public void setFecNulldate(Date fecNulldate)
  {
    this.fecNulldate = fecNulldate;
  }


  public Date getFecNulldate()
  {
    return fecNulldate;
  }


  public void setUsercode(int usercode)
  {
    this.usercode = usercode;
  }


  public int getUsercode()
  {
    return usercode;
  }


  public void setStrShortdescript(String strShortdescript)
  {
    this.strShortdescript = strShortdescript;
  }


  public String getStrShortdescript()
  {
    return strShortdescript;
  }


  public void setStrState(String strState)
  {
    this.strState = strState;
  }


  public String getStrState()
  {
    return strState;
  }
}