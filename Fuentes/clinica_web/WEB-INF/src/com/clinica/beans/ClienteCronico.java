package com.clinica.beans;
import  java.util.*;

public class ClienteCronico 
{


  String strCode="";
  Date fecCompdate = null;
  String strStatregt="";
  Date fecEffecdate = null;
  Date fecNulldate = null; 
  int usercode = 0;


  public void setStrCode(String strCode)
  {
    this.strCode = strCode;
  }


  public String getStrCode()
  {
    return strCode;
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


}