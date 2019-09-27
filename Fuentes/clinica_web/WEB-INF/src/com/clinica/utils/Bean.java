package com.clinica.utils;

import java.util.Hashtable;

public class Bean extends Hashtable
{

    public Bean()
    {
    }

    public String getString(String str)
    {
        if(get(str) == null || get(str).equals(""))
            return "";
        else
            return (String)get(str);
    }

    public String getStringNotNullHtml(String str)
    {
        String strGet = "";
        if(get(str) != null)
            strGet = ((String)get(str)).trim();
        if(get(str) == null || strGet.equals(""))
            return "&nbsp;";
        else
            return strGet;
    }

    public String getStringNotNull(String str, String nul)
    {
        if(get(str) == null || get(str).equals(""))
            return nul;
        else
            return (String)get(str);
    }
}