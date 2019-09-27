package com.clinica.beans;

import com.clinica.utils.*;

public class AvisoRechazo 
{
    protected int nSolicitud = 0;
    protected String sClient = "";
    protected String sClinica = "";
    protected String sRamo = "";
    protected String sProducto = "";
    protected String strFechaMovimiento = "";
    protected int nOficina = 0;
    protected String sOficina = "";
    protected String sContratante = "";
    protected String sAsegurado = "";
    protected int nPoliza = 0;
    protected int nCertif = 0;
    protected String sBroker = "";
    protected int nClaim = 0;
    protected String sPaciente = "";
    protected String sModalidad = "";
    protected String strFechaEmision = "";
    protected String sCobertura = "";
    protected String sDeducible = "";
    protected double dblCoaseguro = 0;
    protected int nMoneda = 0;
    protected int nMonedaCarta = 0;
    protected double dblReserva = 0;
    protected double dblSubTotal = 0;
    protected double dblTipoCambio = 0;
    protected String sParticipacion = "";
    protected String sObservacion = "";
    protected int nProduct = 0;
    protected String sCoberturaST = "";
    protected int nUsuario = 0;
    //RQ2015-000604 INICIO
    protected int nIdMedAudit = 0;
    protected int nIdMotReSBS = 0;
    protected String sMotSBS = "";
    protected int nIdSubMotRe = 0;
    protected String sSubMotSBS = "";
    protected String NIDDiagnos = "";
    protected String sDiagnos = "";
    protected String sProcedimient = "";
    protected String sCond_poli = "";
    protected String sCond_polii = "";
    protected String sNumCartRech = "";
    protected int nIdStaCartR = 0;
    protected double nMontoRechazo =0;
    
    protected String sNombre1 = "";
    protected String sNombre2 = "";
    protected int nIdSta1 = 0;
    protected String sCargo1 = "";
    protected String sCargo2 = "";
    protected int nIdSta2 = 0;
    //RQ2015-000604 FIN


  public void setSRamo(String sRamo)
  {
    this.sRamo = sRamo;
  }


  public String getSRamo()
  {
    return sRamo;
  }


  public void setStrFechaMovimiento(String strFechaMovimiento)
  {
    this.strFechaMovimiento = strFechaMovimiento;
  }


  public String getStrFechaMovimiento()
  {
    return strFechaMovimiento;
  }


  public void setSOficina(String sOficina)
  {
    this.sOficina = sOficina;
  }


  public String getSOficina()
  {
    return sOficina;
  }


  public void setSContratante(String sContratante)
  {
    this.sContratante = sContratante;
  }


  public String getSContratante()
  {
    return sContratante;
  }


  public void setSAsegurado(String sAsegurado)
  {
    this.sAsegurado = sAsegurado;
  }


  public String getSAsegurado()
  {
    return sAsegurado;
  }


  public void setNPoliza(int nPoliza)
  {
    this.nPoliza = nPoliza;
  }


  public int getNPoliza()
  {
    return nPoliza;
  }


  public void setNCertif(int nCertif)
  {
    this.nCertif = nCertif;
  }


  public int getNCertif()
  {
    return nCertif;
  }


  public void setSBroker(String sBroker)
  {
    this.sBroker = sBroker;
  }


  public String getSBroker()
  {
    return sBroker;
  }


  public void setNClaim(int nClaim)
  {
    this.nClaim = nClaim;
  }


  public int getNClaim()
  {
    return nClaim;
  }


  public void setSPaciente(String sPaciente)
  {
    this.sPaciente = sPaciente;
  }


  public String getSPaciente()
  {
    return sPaciente;
  }


  public void setSModalidad(String sModalidad)
  {
    this.sModalidad = sModalidad;
  }


  public String getSModalidad()
  {
    return sModalidad;
  }


  public void setStrFechaEmision(String strFechaEmision)
  {
    this.strFechaEmision = strFechaEmision;
  }


  public String getStrFechaEmision()
  {
    return strFechaEmision;
  }


  public void setSCobertura(String sCobertura)
  {
    this.sCobertura = sCobertura;
  }


  public String getSCobertura()
  {
    return sCobertura;
  }


  public void setSDeducible(String sDeducible)
  {
    this.sDeducible = sDeducible;
  }


  public String getSDeducible()
  {
    return sDeducible;
  }


  public void setDBlreserva(double dblReserva)
  {
    this.dblReserva = dblReserva;
  }


  public double getDBlreserva()
  {
    return dblReserva;
  }


  public void setSParticipacion(String sParticipacion)
  {
    this.sParticipacion = sParticipacion;
  }


  public String getSParticipacion()
  {
    return sParticipacion;
  }


  public void setSObservacion(String sObservacion)
  {
    this.sObservacion = sObservacion;
  }


  public String getSObservacion()
  {
    return sObservacion;
  }


  public void setDblTipoCambio(double dblTipoCambio)
  {
    this.dblTipoCambio = dblTipoCambio;
  }


  public double getDblTipoCambio()
  {
    return dblTipoCambio;
  }


  public void setNOficina(int nOficina)
  {
    this.nOficina = nOficina;
  }


  public int getNOficina()
  {
    return nOficina;
  }


  public void setNMoneda(int nMoneda)
  {
    this.nMoneda = nMoneda;
  }


  public int getNMoneda()
  {
    return nMoneda;
  }


  public void setNSolicitud(int nSolicitud)
  {
    this.nSolicitud = nSolicitud;
  }


  public int getNSolicitud()
  {
    return nSolicitud;
  }


  public void setNUsuario(int nUsuario)
  {
    this.nUsuario = nUsuario;
  }


  public int getNUsuario()
  {
    return nUsuario;
  }


  public void setDblCoaseguro(double dblCoaseguro)
  {
    this.dblCoaseguro = dblCoaseguro;
  }


  public double getDblCoaseguro()
  {
    return dblCoaseguro;
  }


  public void setDblSubTotal(double dblSubTotal)
  {
    this.dblSubTotal = dblSubTotal;
  }


  public double getDblSubTotal()
  {
    return dblSubTotal;
  }


  public void setNMonedaCarta(int nMonedaCarta)
  {
    this.nMonedaCarta = nMonedaCarta;
  }


  public int getNMonedaCarta()
  {
    return nMonedaCarta;
  }


  public void setNProduct(int nProduct)
  {
    this.nProduct = nProduct;
  }


  public int getNProduct()
  {
    return nProduct;
  }


  public void setSCoberturaST(String sCoberturaST)
  {
    this.sCoberturaST = sCoberturaST;
  }


  public String getSCoberturaST()
  {
    return sCoberturaST;
  }


  public void setSProducto(String sProducto)
  {
    this.sProducto = sProducto;
  }


  public String getSProducto()
  {
    return sProducto;
  }


  public void setSClinica(String sClinica)
  {
    this.sClinica = sClinica;
  }


  public String getSClinica()
  {
    return sClinica;
  }


  public void setSClient(String sClient)
  {
    this.sClient = sClient;
  }


  public String getSClient()
  {
    return sClient;
  }


  public void setNIdMedAudit(int nIdMedAudit)
  {
    this.nIdMedAudit = nIdMedAudit;
  }


  public int getNIdMedAudit()
  {
    return nIdMedAudit;
  }


  public void setNIdMotReSBS(int nIdMotReSBS)
  {
    this.nIdMotReSBS = nIdMotReSBS;
  }


  public int getNIdMotReSBS()
  {
    return nIdMotReSBS;
  }


  public void setNIdSubMotRe(int nIdSubMotRe)
  {
    this.nIdSubMotRe = nIdSubMotRe;
  }


  public int getNIdSubMotRe()
  {
    return nIdSubMotRe;
  }

  public void setSProcedimient(String sProcedimient)
  {
    this.sProcedimient = sProcedimient;
  }


  public String getSProcedimient()
  {
    return sProcedimient;
  }


  public void setSCond_poli(String sCond_poli)
  {
    this.sCond_poli = sCond_poli;
  }


  public String getSCond_poli()
  {
    return sCond_poli;
  }


  public void setSCond_polii(String sCond_polii)
  {
    this.sCond_polii = sCond_polii;
  }


  public String getSCond_polii()
  {
    return sCond_polii;
  }


  public void setSNumCartRech(String sNumCartRech)
  {
    this.sNumCartRech = sNumCartRech;
  }


  public String getSNumCartRech()
  {
    return sNumCartRech;
  }


  public void setSDiagnos(String sDiagnos)
  {
    this.sDiagnos = sDiagnos;
  }


  public String getSDiagnos()
  {
    return sDiagnos;
  }


  public void setSMotSBS(String sMotSBS)
  {
    this.sMotSBS = sMotSBS;
  }


  public String getSMotSBS()
  {
    return sMotSBS;
  }


  public void setSSubMotSBS(String sSubMotSBS)
  {
    this.sSubMotSBS = sSubMotSBS;
  }


  public String getSSubMotSBS()
  {
    return sSubMotSBS;
  }


  public void setNIDDiagnos(String NIDDiagnos)
  {
    this.NIDDiagnos = NIDDiagnos;
  }


  public String getNIDDiagnos()
  {
    return NIDDiagnos;
  }


  public void setNIdStaCartR(int nIdStaCartR)
  {
    this.nIdStaCartR = nIdStaCartR;
  }


  public int getNIdStaCartR()
  {
    return nIdStaCartR;
  }


  public void setNMontoRechazo(double nMontoRechazo)
  {
    this.nMontoRechazo = nMontoRechazo;
  }


  public double getNMontoRechazo()
  {
    return nMontoRechazo;
  }


  public void setSNombre1(String sNombre1)
  {
    this.sNombre1 = sNombre1;
  }


  public String getSNombre1()
  {
    return sNombre1;
  }


  public void setSNombre2(String sNombre2)
  {
    this.sNombre2 = sNombre2;
  }


  public String getSNombre2()
  {
    return sNombre2;
  }


  public void setSCargo1(String sCargo1)
  {
    this.sCargo1 = sCargo1;
  }


  public String getSCargo1()
  {
    return sCargo1;
  }


  public void setSCargo2(String sCargo2)
  {
    this.sCargo2 = sCargo2;
  }


  public String getSCargo2()
  {
    return sCargo2;
  }


  public void setNIdSta1(int nIdSta1)
  {
    this.nIdSta1 = nIdSta1;
  }


  public int getNIdSta1()
  {
    return nIdSta1;
  }


  public void setNIdSta2(int nIdSta2)
  {
    this.nIdSta2 = nIdSta2;
  }


  public int getNIdSta2()
  {
    return nIdSta2;
  }
}