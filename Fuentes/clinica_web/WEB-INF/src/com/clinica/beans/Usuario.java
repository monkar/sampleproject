package com.clinica.beans;

import com.clinica.utils.*;


public class Usuario
{
    protected int NIDUSUARIO = 0;
    protected String strWebServer = "";
    protected String strNombre = "";
    protected String strNombreExt = "";
    protected String strLogin = "";
    protected int intIdUsuario = 0;
    protected int intLevel = 0;
    protected int intIdRol = 0;
    protected int intCodOficina = 0;
    protected int intCodClinica = 0;
    protected int intFlgActivo = 0;
    protected int intFlgFirma = 0;
    protected int intCodGrupo = 0;
    protected String strEmail = "";
    protected int intCodBroker = 0;
    protected int intXMLActivo = 0; // REQ 0389-2011 BIT/FMG
    protected int intTipoUsuario = 0; // REQ 2011-xxxx BIT/FMG
    protected int intFlgDeshabilitado = 0; //REQ. 2014-000561 Paradigmasoft GJB
   
    protected BeanList blLstRoles = new BeanList();
    protected BeanList lstFirmas = new BeanList();

    protected byte[] firma = null;
    
   public Usuario() 
   {
    
   }

  public String getSROLES()
  {
    String strRoles="";
    for (int i=0;i<blLstRoles.size();i++){
        if (!"".equals(strRoles)) strRoles = strRoles + ",";
        strRoles = strRoles + ((Rol)blLstRoles.get(i)).getNIDROL();
    }
    return strRoles;
  }


  public void setNIDUSUARIO(int NIDUSUARIO)
  {
    this.NIDUSUARIO = NIDUSUARIO;
    this.intIdUsuario = NIDUSUARIO;
  }


  public int getNIDUSUARIO()
  {
    return NIDUSUARIO;
  }


  public void setStrWebServer(String strWebServer)
  {
    this.strWebServer = strWebServer;
  }


  public String getStrWebServer()
  {
    return strWebServer;
  }


  public void setStrNombre(String strNombre)
  {
    this.strNombre = strNombre;
  }


  public String getStrNombre()
  {
    return strNombre;
  }


  public void setStrNombreExt(String strNombreExt)
  {
    this.strNombreExt = strNombreExt;
  }


  public String getStrNombreExt()
  {
    return strNombreExt;
  }


  public void setIntIdUsuario(int intIdUsuario)
  {
    this.intIdUsuario = intIdUsuario;
  }

 
  public int getIntIdUsuario()
  {
    return intIdUsuario;
  }


  public void setIntLevel(int intLevel)
  {
    this.intLevel = intLevel;
  }


  public int getIntLevel()
  {
    return intLevel;
  }


  public void setBlLstRoles(BeanList blLstRoles)
  {
    this.blLstRoles = blLstRoles;
  }


  public BeanList getBlLstRoles()
  {
    return blLstRoles;
  }


  public void setIntIdRol(int intIdRol)
  {
    this.intIdRol = intIdRol;
  }


  public int getIntIdRol()
  {
    return intIdRol;
  }


  public void setIntCodOficina(int intCodOficina)
  {
    this.intCodOficina = intCodOficina;
  }


  public int getIntCodOficina()
  {
    return intCodOficina;
  }


  public void setStrLogin(String strLogin)
  {
    this.strLogin = strLogin;
  }


  public String getStrLogin()
  {
    return strLogin;
  }


  public void setIntCodClinica(int intCodClinica)
  {
    this.intCodClinica = intCodClinica;
  }


  public int getIntCodClinica()
  {
    return intCodClinica;
  }


  public void setLstFirmas(BeanList lstFirmas)
  {
    this.lstFirmas = lstFirmas;
  }


  public BeanList getLstFirmas()
  {
    return lstFirmas;
  }


  public void setIntFlgActivo(int intFlgActivo)
  {
    this.intFlgActivo = intFlgActivo;
  }

  public int getIntFlgActivo()
  {
    return intFlgActivo;
  }


  public void setFirma(byte[] firma)
  {
    this.firma = firma;
  }


  public byte[] getFirma()
  {
    return firma;
  }


  public void setIntFlgFirma(int intFlgFirma)
  {
    this.intFlgFirma = intFlgFirma;
  }


  public int getIntFlgFirma()
  {
    return intFlgFirma;
  }

  public void setStrEmail(String strEmail)
  {
    this.strEmail = strEmail;
  }


  public String getStrEmail()
  {
    return strEmail;
  }


  public void setIntCodBroker(int intCodBroker)
  {
    this.intCodBroker = intCodBroker;
  }


  public int getIntCodBroker()
  {
    return intCodBroker;
  }
  
  public void setIntCodGrupo(int intCodGrupo)   
  {
    this.intCodGrupo = intCodGrupo;
  }
  

  public int getIntCodGrupo()
  {
    return intCodGrupo;
  }      
  
  //INI - REQ 0389-2011 BIT/FMG
  public int getIntXMLActivo()
  {
    return intXMLActivo;
  }
  
  public void setIntXMLActivo(int intXMLActivo)
  {
    this.intXMLActivo = intXMLActivo;
  }
  //FIN - REQ 0389-2011 BIT/FMG
  
  //INI - REQ 2011-xxxx BIT/FMG
  public int getIntTipoUsuario()
  {
    return intTipoUsuario;
  }
  
  public void setIntTipoUsuario(int intTipoUsuario)
  {
    this.intTipoUsuario = intTipoUsuario;
  }
  //FIN - REQ 2011-xxxx BIT/FMG
  
  //Inicio Req. 2014-000561 Paradigmasoft GJB
  public void setIntFlgDeshabilitado(int intFlgDeshabilitado)
  {
    this.intFlgDeshabilitado = intFlgDeshabilitado;
  }
 
  public int getIntFlgDeshabilitado()
  {
    return intFlgDeshabilitado;
  }
  //Fin Req. 2014-000561 Paradigmasoft GJB
}
