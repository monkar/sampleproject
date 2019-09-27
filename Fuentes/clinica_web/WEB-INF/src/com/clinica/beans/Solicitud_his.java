package com.clinica.beans;

public class Solicitud_his 
{

  protected int NIDHISTORICO;
  protected int NIDSOLICITUD;
  protected int NIDUSUORG;
  protected int NIDUSUDES;
  protected int NUSUARIOREG;
  protected int NESTADO;
  protected String DFECHAREG;
  protected String DFECHAENVIO;
  protected int NIDUSURESP;
  protected String SOBSERVA="";
  protected String SARCHIVO1="";
  protected int NTRANSAC=0;
  protected int NCODMOTIVO=0;
  
  protected int intIDUSUAPROB=0;
  protected String strUSUAPROB="";

  public Solicitud_his()
  {
  }


  public void setNIDHISTORICO(int NIDHISTORICO)
  {
    this.NIDHISTORICO = NIDHISTORICO;
  }


  public int getNIDHISTORICO()
  {
    return NIDHISTORICO;
  }


  public void setNIDSOLICITUD(int NIDSOLICITUD)
  {
    this.NIDSOLICITUD = NIDSOLICITUD;
  }


  public int getNIDSOLICITUD()
  {
    return NIDSOLICITUD;
  }


  public void setNIDUSUORG(int NIDUSUORG)
  {
    this.NIDUSUORG = NIDUSUORG;
  }


  public int getNIDUSUORG()
  {
    return NIDUSUORG;
  }


  public void setNIDUSUDES(int NIDUSUDES)
  {
    this.NIDUSUDES = NIDUSUDES;
  }


  public int getNIDUSUDES()
  {
    return NIDUSUDES;
  }


  public void setNUSUARIOREG(int NUSUARIOREG)
  {
    this.NUSUARIOREG = NUSUARIOREG;
  }


  public int getNUSUARIOREG()
  {
    return NUSUARIOREG;
  }


  public void setNESTADO(int NESTADO)
  {
    this.NESTADO = NESTADO;
  }


  public int getNESTADO()
  {
    return NESTADO;
  }



  public void setNIDUSURESP(int NIDUSURESP)
  {
    this.NIDUSURESP = NIDUSURESP;
  }


  public int getNIDUSURESP()
  {
    return NIDUSURESP;
  }


  public void setSOBSERVA(String SOBSERVA)
  {
    this.SOBSERVA = SOBSERVA;
  }


  public String getSOBSERVA()
  {
    return SOBSERVA;
  }


  public void setSARCHIVO1(String SARCHIVO1)
  {
    this.SARCHIVO1 = SARCHIVO1;
  }


  public String getSARCHIVO1()
  {
    return SARCHIVO1;
  }


  public void setNTRANSAC(int NTRANSAC)
  {
    this.NTRANSAC = NTRANSAC;
  }


  public int getNTRANSAC()
  {
    return NTRANSAC;
  }


  public void setNCODMOTIVO(int NCODMOTIVO)
  {
    this.NCODMOTIVO = NCODMOTIVO;
  }


  public int getNCODMOTIVO()
  {
    return NCODMOTIVO;
  }


  public void setDFECHAREG(String DFECHAREG)
  {
    this.DFECHAREG = DFECHAREG;
  }


  public String getDFECHAREG()
  {
    return DFECHAREG;
  }


  public void setDFECHAENVIO(String DFECHAENVIO)
  {
    this.DFECHAENVIO = DFECHAENVIO;
  }


  public String getDFECHAENVIO()
  {
    return DFECHAENVIO;
  }


  public void setIntIDUSUAPROB(int intIDUSUAPROB)
  {
    this.intIDUSUAPROB = intIDUSUAPROB;
  }


  public int getIntIDUSUAPROB()
  {
    return intIDUSUAPROB;
  }


  public void setStrUSUAPROB(String strUSUAPROB)
  {
    this.strUSUAPROB = strUSUAPROB;
  }


  public String getStrUSUAPROB()
  {
    return strUSUAPROB;
  }



}