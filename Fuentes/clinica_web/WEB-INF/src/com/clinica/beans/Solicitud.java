package com.clinica.beans;

import com.clinica.utils.*;

public class Solicitud 
{
  protected int NIDSOLICITUD=0;
  protected int NIDROLRESP=0;
  protected int NIDESTADO=0;
  protected int NIDTIPOSOLICITUD=0;
  protected int NIDUSUARIO=0;
  protected String SNROSINIESTRO="";
  protected String  DFECHAREG="";
  protected String  SOBSERVAMED="";
  protected String  SASEGURADO="";
  protected String  SIDCLINICA="";
  protected String  SIDCLINICASOL="";
  protected int NFLGAMPLIACION=0;
  
  protected String  SOBSERVACLI="";   
  protected String  SCMPMEDICO="";   
  protected String  SNOMBMEDICO="";   
     
     
  /*AF-64*/ 
  protected int intTiempoEnfermedad = 0;
  /*Fin AF-64*/ 
     
  protected int intRamo=0;
  protected int intOficina=0;
  protected int intCodProveedor=0;
  protected int intCodProveedorSol=0;
  protected String strProveedor="";
  protected String strProveedorSol=""; 
  protected String intCodDiagnos="";
  protected String strDiagnos="";  
  protected int intMonedaImpoCarta=0;
  protected String strMonedaImpoCarta="";
  protected double dblImporteCarta = 0;
  protected double dblImporteLocal = 0;
  protected String strFechaLimite="";
  protected String strFechaOcurr="";
  protected String strFechaEmi="";

  protected double dblTipoCambio=0;  
  
  protected int intCodOficina=0;
  protected int intIdUsuFirma1=0;
  protected int intIdUsuFirma2=0;
  protected String strNombOficina="";
  /* RQ2015-000750 Inicio*/
  protected String strObservacionAG="";
  /* RQ2015-000750 Fin*/  
  
    //RQ2015-000604 INICIO
    protected int nIdMedAudit = 0;
    protected int nIdMotReSBS = 0;
    protected int nIdSubMotRe = 0;
    protected String sDiagnos = "";
    protected String sProcedimient = "";
    protected String sCond_poli = "";
    protected String sCond_polii = "";
    protected String sNumCartRech = "";    
    //RQ2015-000604 FIN
  
  protected double dblFactorIgv=0;  
  
  protected Solicitud_his objSolhis = new Solicitud_his();
  protected Presupuesto objPresupuesto = new Presupuesto();

  /*PRT
   * Este es el flag que permite saber si el Valor está seteado como flag IGV para el arcvhivo XML.
   * */
  protected String flgIgvValorDed="";

  /* RQ2015-000750 Inicio*/
  protected String sCorreo="";
  protected String SClient="";
  /* RQ2015-000750 Fin*/

  public Solicitud()
  {
  }

  public double getCambioImpCarta(int intMonedaPrin)
  {
    double dblImpCalc =0;
    
    if (this.intMonedaImpoCarta == intMonedaPrin)
        dblImpCalc = this.dblImporteCarta;
    else
      if (intMonedaPrin==Constante.NCODMONEDASOL)
        dblImpCalc = this.getDblImporteCarta() * this.dblTipoCambio;
      else
        dblImpCalc = this.getDblImporteCarta() / this.dblTipoCambio;
    
    return dblImpCalc;
  }

  
  public void setNIDSOLICITUD(int NIDSOLICITUD)
  {
    this.NIDSOLICITUD = NIDSOLICITUD;
  }


  public int getNIDSOLICITUD()
  {
    return NIDSOLICITUD;
  }


  public void setNIDROLRESP(int NIDROLRESP)
  {
    this.NIDROLRESP = NIDROLRESP;
  }


  public int getNIDROLRESP()
  {
    return NIDROLRESP;
  }


  public void setNIDESTADO(int NIDESTADO)
  {
    this.NIDESTADO = NIDESTADO;
  }


  public int getNIDESTADO()
  {
    return NIDESTADO;
  }


  public void setNIDTIPOSOLICITUD(int NIDTIPOSOLICITUD)
  {
    this.NIDTIPOSOLICITUD = NIDTIPOSOLICITUD;
  }


  public int getNIDTIPOSOLICITUD()
  {
    return NIDTIPOSOLICITUD;
  }


  public void setNIDUSUARIO(int NIDUSUARIO)
  {
    this.NIDUSUARIO = NIDUSUARIO;
  }


  public int getNIDUSUARIO()
  {
    return NIDUSUARIO;
  }


  public void setSNROSINIESTRO(String SNROSINIESTRO)
  {
    this.SNROSINIESTRO = SNROSINIESTRO;
  }


  public String getSNROSINIESTRO()
  {
    return SNROSINIESTRO;
  }


  public void setIntRamo(int intRamo)
  {
    this.intRamo = intRamo;
  }


  public int getIntRamo()
  {
    return intRamo;
  }


  public void setIntOficina(int intOficina)
  {
    this.intOficina = intOficina;
  }


  public int getIntOficina()
  {
    return intOficina;
  }


  public void setIntCodProveedor(int intCodProveedor)
  {
    this.intCodProveedor = intCodProveedor;
  }


  public int getIntCodProveedor()
  {
    return intCodProveedor;
  }


  public void setStrProveedor(String strProveedor)
  {
    this.strProveedor = strProveedor;
  }


  public String getStrProveedor()
  {
    return strProveedor;
  }




  public void setStrDiagnos(String strDiagnos)
  {
    this.strDiagnos = strDiagnos;
  }


  public String getStrDiagnos()
  {
    return strDiagnos;
  }


  public void setIntMonedaImpoCarta(int intMonedaImpoCarta)
  {
    this.intMonedaImpoCarta = intMonedaImpoCarta;
  }


  public int getIntMonedaImpoCarta()
  {
    return intMonedaImpoCarta;
  }


  public void setDblImporteCarta(double dblImporteCarta)
  {
    this.dblImporteCarta = dblImporteCarta;
  }


  public double getDblImporteCarta()
  {
    return dblImporteCarta;
  }


  public void setStrFechaLimite(String strFechaLimite)
  {
    this.strFechaLimite = strFechaLimite;
  }


  public String getStrFechaLimite()
  {
    return strFechaLimite;
  }


  public void setObjSolhis(Solicitud_his objSolhis)
  {
    this.objSolhis = objSolhis;
  }


  public Solicitud_his getObjSolhis()
  {
    return objSolhis;
  }


  public void setDFECHAREG(String DFECHAREG)
  {
    this.DFECHAREG = DFECHAREG;
  }


  public String getDFECHAREG()
  {
    return DFECHAREG;
  }


  public void setSOBSERVAMED(String SOBSERVAMED)
  {
    this.SOBSERVAMED = SOBSERVAMED;
  }


  public String getSOBSERVAMED()
  {
    return SOBSERVAMED;
  }


  public void setSASEGURADO(String SASEGURADO)
  {
    this.SASEGURADO = SASEGURADO;
  }


  public String getSASEGURADO()
  {
    return SASEGURADO;
  }


  public void setSIDCLINICA(String SIDCLINICA)
  {
    this.SIDCLINICA = SIDCLINICA;
  }


  public String getSIDCLINICA()
  {
    return SIDCLINICA;
  }


  public void setStrFechaOcurr(String strFechaOcurr)
  {
    this.strFechaOcurr = strFechaOcurr;
  }


  public String getStrFechaOcurr()
  {
    return strFechaOcurr;
  }


  public void setDblTipoCambio(double dblTipoCambio)
  {
    this.dblTipoCambio = dblTipoCambio;
  }


  public double getDblTipoCambio()
  {
    return dblTipoCambio;
  }


  public void setIntCodDiagnos(String intCodDiagnos)
  {
    this.intCodDiagnos = intCodDiagnos;
  }


  public String getIntCodDiagnos()
  {
    return intCodDiagnos;
  }


  public void setNFLGAMPLIACION(int NFLGAMPLIACION)
  {
    this.NFLGAMPLIACION = NFLGAMPLIACION;
  }


  public int getNFLGAMPLIACION()
  {
    return NFLGAMPLIACION;
  }


  public void setDblImporteLocal(double dblImporteLocal)
  {
    this.dblImporteLocal = dblImporteLocal;
  }


  public double getDblImporteLocal()
  {
    return dblImporteLocal;
  }


  public void setStrFechaEmi(String strFechaEmi)
  {
    this.strFechaEmi = strFechaEmi;
  }


  public String getStrFechaEmi()
  {
    return strFechaEmi;
  }


  public void setStrMonedaImpoCarta(String strMonedaImpoCarta)
  {
    this.strMonedaImpoCarta = strMonedaImpoCarta;
  }


  public String getStrMonedaImpoCarta()
  {
    return strMonedaImpoCarta;
  }


  public void setObjPresupuesto(Presupuesto objPresupuesto)
  {
    this.objPresupuesto = objPresupuesto;
  }


  public Presupuesto getObjPresupuesto()
  {
    return objPresupuesto;
  }


  public void setSOBSERVACLI(String SOBSERVACLI)
  {
    this.SOBSERVACLI = SOBSERVACLI;
  }


  public String getSOBSERVACLI()
  {
    return SOBSERVACLI;
  }


  public void setSCMPMEDICO(String SCMPMEDICO)
  {
    this.SCMPMEDICO = SCMPMEDICO;
  }


  public String getSCMPMEDICO()
  {
    return SCMPMEDICO;
  }


  public void setSNOMBMEDICO(String SNOMBMEDICO)
  {
    this.SNOMBMEDICO = SNOMBMEDICO;
  }


  public String getSNOMBMEDICO()
  {
    return SNOMBMEDICO;
  }


  public void setIntCodOficina(int intCodOficina)
  {
    this.intCodOficina = intCodOficina;
  }


  public int getIntCodOficina()
  {
    return intCodOficina;
  }


  public void setIntIdUsuFirma1(int intIdUsuFirma1)
  {
    this.intIdUsuFirma1 = intIdUsuFirma1;
  }


  public int getIntIdUsuFirma1()
  {
    return intIdUsuFirma1;
  }


  public void setIntIdUsuFirma2(int intIdUsuFirma2)
  {
    this.intIdUsuFirma2 = intIdUsuFirma2;
  }


  public int getIntIdUsuFirma2()
  {
    return intIdUsuFirma2;
  }


  public void setStrNombOficina(String strNombOficina)
  {
    this.strNombOficina = strNombOficina;
  }


  public String getStrNombOficina()
  {
    return strNombOficina;
  }


  public void setDblFactorIgv(double dblFactorIgv)
  {
    this.dblFactorIgv = dblFactorIgv;
  }


  public double getDblFactorIgv()
  {
    return dblFactorIgv;
  }
  
  //PRT seteo del flag
  public void setFlgIgvValorDed(String flgIgvValorDed)
  {
    this.flgIgvValorDed = flgIgvValorDed;
  }

  //PRT get del flag
  public String getFlgIgvValorDed()
  {
    return flgIgvValorDed;
  }
  
public void setIntCodProveedorSol(int intCodProveedorSol)
  {
    this.intCodProveedorSol = intCodProveedorSol;
  }


  public int getIntCodProveedorSol()
  {
    return intCodProveedorSol;
  }


  public void setStrProveedorSol(String strProveedorSol)
  {
    this.strProveedorSol = strProveedorSol;
  }


  public String getStrProveedorSol()
  {
    return strProveedorSol;
  }  
  
  
  public void setSIDCLINICASOL(String SIDCLINICASOL)
  {
    this.SIDCLINICASOL = SIDCLINICASOL;
  }


  public String getSIDCLINICASOL()
  {
    return SIDCLINICASOL;
  }    



  
 /*AF-64*/
 
   public void setIntTiempoEnfermedad(int intTiempoEnfermedad)
  {
    this.intTiempoEnfermedad = intTiempoEnfermedad;
  }


  public int getIntTiempoEnfermedad()
  {
    return intTiempoEnfermedad;
  }
    

  public void setSCorreo(String sCorreo)
  {
    this.sCorreo = sCorreo;
  }


  public String getSCorreo()
  {
    return sCorreo;
  }


  public void setSClient(String SClient)
  {
    this.SClient = SClient;
  }


  public String getSClient()
  {
    return SClient;
  }


  public void setStrObservacionAG(String strObservacionAG)
  {
    this.strObservacionAG = strObservacionAG;
  }


  public String getStrObservacionAG()
  {
    return strObservacionAG;
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


  public void setSDiagnos(String sDiagnos)
  {
    this.sDiagnos = sDiagnos;
  }


  public String getSDiagnos()
  {
    return sDiagnos;
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

 /*Fin AF-64*/
  
  
}