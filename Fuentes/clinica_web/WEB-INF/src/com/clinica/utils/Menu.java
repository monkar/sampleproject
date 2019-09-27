package com.clinica.utils;
import com.clinica.beans.Modulo;


public class Menu 
{

  public BeanList lstModulo;
  public BeanList lstModuloCab;
  public BeanList lstModuloDet;
  public BeanList lstModRol;
  private StringBuffer menu;

  private BeanList lstModuloCabAux;
  private BeanList lstModuloDetAux;

  public Menu(BeanList lstModulo, BeanList lstModRol)
  {
    this.lstModulo = lstModulo;
    this.lstModRol = lstModRol;
  }
  
  public void listModuloCab()
  {

  //Creado : Tania Villar C.
  //Fecha  : 06/03/07
  //Parámetros :
  //           
  
   Modulo objModulo = null;
   lstModuloCab = new BeanList();
   //System.out.println("lstModulo.size():" + lstModulo.size());
   for(int o = 0; o < lstModulo.size(); o++)
   {
     objModulo = (Modulo) lstModulo.get(o);
     //System.out.println("cab pad:" + objModulo.getNIDMODULOSUP() + "cab id:" + objModulo.getNIDMODULO());
     if (objModulo.getNIDMODULOSUP()==0)
        //listModCabRol(objModulo);
        lstModuloCab.add(objModulo);
     objModulo = null;
   }
  }
  
/*  private void listModCabRol(Modulo objModCab)
  {
   Modulo objModaux=null;
   System.out.println("lstModRol.size():" + lstModRol.size());
   for(int o = 0; o < lstModRol.size(); o++)
   {
     objModaux = (Modulo) lstModRol.get(o);
     System.out.println("sup:" + objModaux.getNIDMODULOSUP() + " aux:" + objModaux.getNIDMODULO());
     if (objModaux.getNIDMODULOSUP()==objModCab.getNIDMODULO())
        lstModuloCab.add(objModCab);
        
     objModaux =null;
   }    
  }
 */ 
  public void listModuloDet()
  {

  //Creado : Tania Villar C.
  //Fecha  : 06/03/07
  //Parámetros :
  //            
     lstModuloDet = new BeanList();
   Modulo objModulo = new Modulo();
   for(int o = 0; o < lstModulo.size(); o++)
   {
     objModulo = (Modulo) lstModulo.get(o);
     if (objModulo.getNIDMODULOSUP()!=0)
        lstModuloDet.add(objModulo);
        //listModDetRol(objModulo);
     objModulo = null;
   }    
  }

  /*private void listModDetRol(Modulo objModDet)
  {
   Modulo objModaux=null;
   for(int o = 0; o < lstModRol.size(); o++)
   {
     objModaux = (Modulo) lstModRol.get(o);
     if (objModaux.getNIDMODULOSUP()==objModDet.getNIDMODULO())
        lstModuloDet.add(objModDet);
     else
      if (objModaux.getNIDMODULO()==objModDet.getNIDMODULO())
        lstModuloDet.add(objModDet);
     objModaux =null;
   }    
  }*/
  
    public String GenerarMenu()
    {
        menu = new StringBuffer();
        listModuloCab();
        listModuloDet();
        listModuloRol();
        String cadena = "";
        Modulo objModulo;
        for(int o = 0; o < lstModuloCab.size(); o++)
        {
            objModulo = (Modulo) lstModuloCab.get(o);
            for(int w = 0; w < lstModuloCab.size() - 1 - o; w++)
                if(objModulo.getNORDEN() > ((Modulo) lstModuloCab.get(w + 1)).getNORDEN())
                {
                    Object aux = lstModuloCab.get(w);
                    lstModuloCab.set(w, lstModuloCab.get(w + 1));
                    lstModuloCab.set(w + 1, aux);
                }
            objModulo = null;
        }
        
        try
        {
            
            menu.append("<SCRIPT>");
            menu.append("var menuItems = [ ");            
            for(int i = 0; i < lstModuloCab.size(); i++)
            {
                objModulo = (Modulo) lstModuloCab.get(i);
                if(objModulo.getNNIVEL()==1)
                    menu.append("[\"" + Tool.getString(objModulo.getSNOMBRE()) + "\",,\"\",\"\",\"\",,\"0\"]");
                if(objModulo.getNNIVEL()==2)
                {
                    if(objModulo.getNTIPOVISTA()==0)
                        menu.append("[\"" + objModulo.getSNOMBRE() + "\",\"" + objModulo.getSURL() + "\",\"\",\"\",\"\",,\"0\"]");
                    if(objModulo.getNTIPOVISTA()==1)
                        menu.append("[\"" + objModulo.getSNOMBRE() + "\",\"" + objModulo.getSURL() + "\",\"\",\"\",\"\",\"_blank\",,\"0\"]");
                }
                String strPad = "|";
                crearMenuItemAux(objModulo.getNIDMODULO(),strPad);
                objModulo = null;
            }

            menu.append("];");
            menu.append("apy_init();");
            menu.append("</SCRIPT>");
            cadena = menu.toString();
            String cadenaAux = "";
            for(int w = 0; w < cadena.lastIndexOf("]"); w++)
                if(cadena.charAt(w) == ']' && cadena.charAt(w + 1) != ',')
                {
                    cadenaAux = cadena.substring(0, w + 1);
                    cadenaAux = cadenaAux + ",";
                    cadena = cadena.substring(w + 1);
                    cadenaAux = cadenaAux + cadena;
                    cadena = cadenaAux;
                }

        }
        catch(Exception se)
        {
            System.out.println("Entro al catch del crearMenuAux!!!!");
            se.printStackTrace();
        }
        return cadena;
    }  

    public void crearMenuItemAux(int intIdModulo, String strPad)
    {
        Modulo objModulo;
        menu.append(",");
        for(int i = 0; i < lstModuloDet.size(); i++)
        {
            objModulo = (Modulo)lstModuloDet.get(i);
            if(objModulo.getNIDMODULOSUP()!=intIdModulo)
                continue;
            if(objModulo.getNNIVEL()==1)
                menu.append("[\"" + strPad + objModulo.getSNOMBRE() + "\",,\"\",\"\",\"\",,\"0\"]");
            if(objModulo.getNNIVEL()==2)
            {
                if(objModulo.getNTIPOVISTA()==0)
                    menu.append("[\""  + strPad + objModulo.getSNOMBRE() + "\",\"" + objModulo.getSURL()  + "?pscodmnu=" +  objModulo.getNIDMODULO() +  "&psnommnu=" + objModulo.getSNOMBRE() + "\",\"\",\"\",\"\",,\"0\"]");
                if(objModulo.getNTIPOVISTA()==1)
                    menu.append("[\""  + strPad + objModulo.getSNOMBRE() + "\",\"" + objModulo.getSURL()  + "?pscodmnu=" +  objModulo.getNIDMODULO()  +  "&psnommnu=" + objModulo.getSNOMBRE() + "\",\"\",\"\",\"\",\"_blank\",,\"0\"]");
            }
            /*if(i < lstModuloDet.size() - 1)
                menu.append(",");*/
            
            crearMenuItemAux(objModulo.getNIDMODULO(), strPad + "|");
            objModulo = null;
        }

    }    

    public void listModuloRol()
    {
        lstModuloCabAux = new BeanList();
        lstModuloDetAux = new BeanList();
        Modulo objModRol=null;
        Modulo objModulo=null;
        int x = 0;
        for(int y = 0; y < lstModRol.size(); y++)
        {
            objModRol = (Modulo) lstModRol.get(y);
            int j = 0;
            do
            {
                if(j >= lstModuloCab.size())
                    break;
                objModulo = (Modulo) lstModuloCab.get(j);
                if(objModulo.getNIDMODULO()==objModRol.getNIDMODULO())
                {
                    x++;
                    lstModuloCabAux.add((Modulo)lstModuloCab.get(j));
                    buscarHijos(objModRol.getNIDMODULO());
                    break;
                }                
                j++;
                objModulo=null;
            } while(true);
            if(x == 0)
            {
                int i = 0;
                Modulo objModuloDet=null;
                do
                {
                    if(i >= lstModuloDet.size())
                        break;
                    int contMenuItem = 0;
                    objModuloDet = (Modulo) lstModuloDet.get(i);
                    if(objModuloDet.getNIDMODULO()==objModRol.getNIDMODULO())
                    {
                        x = 0;
                        for(int m = 0; m < lstModuloDetAux.size(); m++)
                              if(lstModuloDetAux.elementAt(m).equals(lstModuloDet.get(i)))
                                contMenuItem++;

                        if(contMenuItem == 0)
                            lstModuloDetAux.add(lstModuloDet.get(i));
                        if(objModuloDet.getNNIVEL()==2)
                            buscarPadres(objModuloDet.getNIDMODULOSUP());
                        if(objModuloDet.getNNIVEL()==1)
                        {
                            buscarPadres(objModuloDet.getNIDMODULOSUP());
                            buscarHijos(objModuloDet.getNIDMODULO());
                        }
                        break;
                    }
                    i++;
                    objModuloDet = null;
                } while(true);
            }
            x = 0;
            objModRol=null;
        }
        
        lstModuloCab = lstModuloCabAux;
        lstModuloDet = lstModuloDetAux;

    }

    public void buscarPadres(int intIdModuloSup)
    {
        int y = 0;
        int contMenuItem = 0;
        int contMenu = 0;
        int i = 0;
        Modulo objModuloDet=null;
        do
        {
            if(i >= lstModuloDet.size())
                break;
            objModuloDet = (Modulo) lstModuloDet.get(i);
            if(objModuloDet.getNIDMODULO()==intIdModuloSup)
            {
                for(int m = 0; m < lstModuloDetAux.size(); m++)
                    if(lstModuloDetAux.elementAt(m).equals(lstModuloDet.get(i)))
                        contMenuItem++;

                if(contMenuItem == 0)
                    lstModuloDetAux.add(lstModuloDet.get(i));
                buscarPadres(objModuloDet.getNIDMODULOSUP());
                y++;
                break;
            }
            i++;
            objModuloDet=null;
        } while(true);
        if(y == 0)
        {
            int j = 0;
            Modulo objModulo =null;
            do
            {
                if(j >= lstModuloCab.size())
                    break;
                objModulo = (Modulo) lstModuloCab.get(j);
                if(objModulo.getNIDMODULO()== intIdModuloSup)
                {
                    for(int l = 0; l < lstModuloCabAux.size(); l++)
                        if(lstModuloCabAux.elementAt(l).equals(lstModuloCab.get(j)))
                            contMenu++;

                    if(contMenu == 0)
                        lstModuloCabAux.add((Modulo)lstModuloCab.get(j));
                    break;
                }
                j++;
                objModulo = null;
            } while(true);
        }
    }

    public void buscarHijos(int intIdModulo)
    {
        Modulo objModuloDet = null;
        for(int i = 0; i < lstModuloDet.size(); i++){
            objModuloDet = (Modulo) lstModuloDet.get(i);
            if(objModuloDet.getNIDMODULOSUP()==intIdModulo)
            {
                lstModuloDetAux.add((Modulo)lstModuloDet.get(i));
                buscarHijos(objModuloDet.getNIDMODULO());
            }
            objModuloDet = null;
        }
    }

}