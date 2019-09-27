package com.clinica.service;
import com.clinica.beans.ParamNuevaMarca;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.ParamNuevaMarcaDAO;
import com.clinica.utils.Constante;
import com.clinica.utils.ConstanteConfig;

public class ParamNuevaMarcaService 
{

  DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);
  ParamNuevaMarcaDAO oNuevaMarcaDAO =   subFactory.getParamNuevaMarcaDAO();
  
  public ParamNuevaMarcaService()
  {
  
  }
  
  public ParamNuevaMarca getUrlLogo(int intApp){
    return oNuevaMarcaDAO.getUrlsLogo(intApp);    
  }
  
  public ParamNuevaMarca getUrlLogo(){
    String sIdApp = Constante.getConst(ConstanteConfig.ID_APP);    
    return getUrlLogo(sIdApp.equals("")?0:Integer.parseInt(sIdApp) );
  }
  
  public String getPathUrlLogo(String urlBase){
  
    String sIdApp = Constante.getConst(ConstanteConfig.ID_APP);
    
    if( sIdApp.equals("") )
    {
      return getLogoDefecto(urlBase);
    } else 
    {
      return getPathUrlLogo(Integer.parseInt(sIdApp), urlBase);  
    }
    
  }
  
  public String getPathUrlLogo(int intApp, String urlBase){
    return getPathUrlLogo(intApp, urlBase, getUrlLogo(intApp));
  }
  
  public String getPathUrlLogo(int intApp, String urlBase, ParamNuevaMarca paramNuevaMarca)
  {
    String logo = "";
    
    if( paramNuevaMarca.getNIdFlag() < 0)
    {
      return getLogoDefecto(urlBase);
    }
    
    if( paramNuevaMarca.getNIdFlag() == 1 )
    {
      logo = paramNuevaMarca.getSUrlNew();
    } else 
    {
      logo = paramNuevaMarca.getSUrlAnterior();  
    }
    
    if( logo == null || ( logo != null && logo.trim().equals("")) )
    {
      return getLogoDefecto(urlBase);
    }
    
    return getPathUrlLogo(urlBase, logo);
  }
  
  protected String getPathUrlLogo(String urlBase, String urlConfig)
  {
    //validar si la url es relativa
    if( !urlConfig.substring(0, 4).toLowerCase().equals("http") )
    {
      return parserPathLogo(urlBase, urlConfig); 
    } else 
    {
      return urlConfig;
    }
  }
  
  protected String parserPathLogo(String urlBase, String urlLogo)
  {
    if (!urlBase.substring(urlBase.length() - 1, urlBase.length()).equals("/"))
    {
        urlBase += "/";
    }    
    if (urlLogo.substring(0, 1).equals("/"))
    {
        //urlLogo = "/" + urlLogo;
        urlLogo = urlLogo.substring(1);
    }
    return urlBase + urlLogo;
  }
  
  public String getLogoDefecto(String path)
  {
    //request.getContextPath()
    return parserPathLogo(path, Constante.LOGO_DEFECTO);
  }
  
  public String getAndSetPathUrlLogo(String urlBase)
  {
    String urlLogo = Constante.onlyGetConst(Constante.KEY_URL_LOGO);
    if( urlLogo == null )
    {
      urlLogo = getPathUrlLogo(urlBase);
      if( urlLogo != null && !urlLogo.equals("") )
      {
        setSetPathUrlLogo(urlLogo);
      }
    }
    return urlLogo;
  }
  
  public void setSetPathUrlLogo(String path)
  {
    Constante.setConst(Constante.KEY_URL_LOGO, path);
  }
  
}