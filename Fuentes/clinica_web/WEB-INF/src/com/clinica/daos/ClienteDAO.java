package com.clinica.daos;
import com.clinica.beans.Cliente;
import com.clinica.utils.Bean;

public interface ClienteDAO 
{

public Cliente setCliente(Bean objAtencion, String strCodCliente);
public String getClientInpDate(String pcode);
public boolean getCertifVig(int intPoliza, int intCertif,int intRamo);
public boolean getXstrata(int intPoliza);
public Cliente getCliente(String strCodigo);
//BIT FLOPEZ RQ2013-0004000
public String getClienteVigente(int nUsercomp,int ncompany,String sCertype, int nBranch,int nPolicy,int nCertif,String sEffecdate);
//FIN FLOPEZ RQ2013-0004000
public Cliente getClienteDir(String strCodigo);
}