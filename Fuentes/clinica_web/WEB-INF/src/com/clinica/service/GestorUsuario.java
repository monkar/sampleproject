package com.clinica.service;
import com.clinica.beans.*;
import com.clinica.daos.DAOFactory;
import com.clinica.daos.UsuarioDAO;
import com.clinica.utils.*;


public class GestorUsuario {


     DAOFactory subFactory = DAOFactory.getSubFactory(DAOFactory.ORACLE_INFORMIX);

      UsuarioDAO usuario =    subFactory.getUsuarioDAO();

      public int esHabilAnulacion(int intIdUsuario){
               return usuario.esHabilAnulacion(intIdUsuario);
      }

     public Usuario getUsuario(String strNombre, String strClave){
          return usuario.getUsuario(strNombre,strClave);
    }

public BeanList lstModuloRol(String strRoles,int CodGrupo){
         return usuario.lstModuloRol(strRoles,CodGrupo);
}

public BeanList lstModulo(String strRoles,int CodGrupo){
        return usuario.lstModulo(strRoles,CodGrupo);
}

public Usuario getUsuario(int intCodigo){
        return usuario.getUsuario(intCodigo);
}

public BeanList listUsuarioRol(int nIdUsuario){
        return usuario.listUsuarioRol(nIdUsuario);
}

public String getNombOficina(int intCodOficina){
        return usuario.getNombOficina(intCodOficina);
}

public BeanList getlstOficina(){
            return usuario.getlstOficina();
}

public BeanList getLstUsuario(String strLogin, String strCodServer,  int intCodOficina, int intCodRol){
        return usuario.getLstUsuario(strLogin,strCodServer,intCodOficina,intCodRol);
}

public BeanList getLstUsuarioIntranet(String strLogin){
        return usuario.getLstUsuarioIntranet(strLogin);
}

public BeanList getFirmaUsuario(int intCodigo){
        return usuario.getFirmaUsuario(intCodigo);
}

public int  insUsuario(Usuario objUsuario, int intIdUser, String strConfFirma){
       return usuario.insUsuario(objUsuario,intIdUser,strConfFirma);
}

public int updUsuario(Usuario objUsuario, String strConfFirma, String strConFirmaDel){

    return usuario.updUsuario(objUsuario,strConfFirma,strConFirmaDel);
}


public byte[] getFileFirmaBin(int idusuario){
       return usuario.getFileFirmaBin(idusuario);
}

public Usuario getUsuarioShare(String  strUser){
       return usuario.getUsuarioShare(strUser);
}

public Bean getUsuarioGenerico(int intIdUsuario){
      return usuario.getUsuarioGenerico(intIdUsuario);
}

public int updUsuGenPassword(int intIdUsuario, String strPassword){
      return usuario.updUsuGenPassword(intIdUsuario,strPassword);
}

public BeanList getOficinasConfiguracionUsuario(int intIdUsuario){
      return usuario.getOficinasConfiguracionUsuario(intIdUsuario);
}
/*RQ2015-000750 INICIO DLCH*/
public BeanList getlstZona(){
            return usuario.getlstZona();
}
public BeanList getlstOficinaCore(){
            return usuario.getlstOficinaCore();
}
/*RQ2015-000750 FIN DLCH*/

}