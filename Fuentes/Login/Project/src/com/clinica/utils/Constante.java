package com.clinica.utils;

import java.util.HashMap;

public class Constante 
{
  private static HashMap cConsMap = new HashMap();

  public Constante()
  {
  }

  public static final String LOGO_DEFECTO = "images/logo.png";
  public static final String KEY_URL_LOGO = "URL_LOGO";
  
	public static void setConst(String sKey, String sValue){
		cConsMap.put(sKey,sValue);
  }

	public static String getConst(String sKey){
    Object object = cConsMap.get(sKey);
    if (object!=null)
      return cConsMap.get(sKey).toString();
    else{
      String strValor = TablaConfig.getTablaConfig(sKey);
      if (strValor != null){
        setConst(sKey,strValor);
        return cConsMap.get(sKey).toString();
      }else
        return "";
    }
	}  
  
  public static String getConstBD(String sKey){
    Object object = null;
    if (object!=null)
      return cConsMap.get(sKey).toString();
    else{
      String strValor = TablaConfig.getTablaConfig(sKey);
      if (strValor != null){
        setConst(sKey,strValor);
        return cConsMap.get(sKey).toString();
      }else
        return "";
    }
	}
  
  public static String onlyGetConst(String sKey){
     Object object = cConsMap.get(sKey);
     if (object!=null)
      return cConsMap.get(sKey).toString();
     else
      return null;
   }
}