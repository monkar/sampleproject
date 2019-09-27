package com.clinica.service;
import com.clinica.beans.Cliente;
import com.clinica.daos.ClienteDAO;
import com.clinica.daos.DAOFactory;
import com.clinica.utils.Bean;

public class GestorCliente 
{

   DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);

    ClienteDAO cliente =  subFactory.getClienteDAO();

   public Cliente setCliente(Bean objAtencion, String strCodCliente){
             return cliente.setCliente(objAtencion,strCodCliente);   
   }
public String getClientInpDate(String pcode){
       return cliente.getClientInpDate(pcode);
}
public boolean getCertifVig(int intPoliza, int intCertif, int intRamo){
        return cliente.getCertifVig(intPoliza,intCertif, intRamo);
}
public boolean getXstrata(int intPoliza){
      return cliente.getXstrata(intPoliza);
}
public Cliente getCliente(String strCodigo){
        return cliente.getCliente(strCodigo);
}   
  //INICIO BIT FLOPEZ RQ2013-0004000
  public String getClienteVigente(int nUsercomp,int ncompany,String sCertype, int nBranch,int nPolicy,int nCertif,String sEffecdate)
  { 
         return cliente.getClienteVigente(nUsercomp,ncompany,sCertype,nBranch,nPolicy,nCertif,sEffecdate);
  }
  //FIN BIT FLOPEZ RQ2013-0004000
public Cliente getClienteDir(String strCodigo){
        return cliente.getClienteDir(strCodigo);
}  
}