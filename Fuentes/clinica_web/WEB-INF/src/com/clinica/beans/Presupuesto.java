package com.clinica.beans;
import java.util.ArrayList;

public class Presupuesto 
{
  protected int NIDPRESUPUESTO = 0;
  protected ArrayList arrDetalle = new ArrayList();
  
  public Presupuesto()
  {
  }

  public void setNIDPRESUPUESTO(int NIDPRESUPUESTO)
  {
    this.NIDPRESUPUESTO = NIDPRESUPUESTO;
  }


  public int getNIDPRESUPUESTO()
  {
    return NIDPRESUPUESTO;
  }

   public void setArrDetalle(ArrayList arrDetalle)
  {
    this.arrDetalle = arrDetalle;
  }


  public ArrayList getArrDetalle()
  {
    return arrDetalle;
  }
  
}