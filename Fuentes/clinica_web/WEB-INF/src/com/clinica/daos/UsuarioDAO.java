package com.clinica.daos;
import com.clinica.beans.*;
import com.clinica.utils.Bean;
import com.clinica.utils.BeanList;


public interface UsuarioDAO {

public int esHabilAnulacion(int intIdUsuario);

public Usuario getUsuario(String strNombre, String strClave);

public BeanList lstModuloRol(String strRoles,int CodGrupo);

public BeanList lstModulo(String strRoles,int CodGrupo);

public Usuario getUsuario(int intCodigo);

public BeanList listUsuarioRol(int nIdUsuario);

public String getNombOficina(int intCodOficina);

public BeanList getlstOficina();

public BeanList getLstUsuario(String strLogin, String strCodServer,  int intCodOficina, int intCodRol);

public BeanList getLstUsuarioIntranet(String strLogin);

public BeanList getFirmaUsuario(int intCodigo);

public int insUsuario(Usuario objUsuario, int intIdUser, String strConfFirma);

public int updUsuario(Usuario objUsuario, String strConfFirma, String strConFirmaDel);

public byte[] getFileFirmaBin(int idusuario);

public Usuario getUsuarioShare(String  strUser);

public Bean getUsuarioGenerico(int intIdUsuario);

public int updUsuGenPassword(int intIdUsuario, String strPassword);

public BeanList getOficinasConfiguracionUsuario(int intIdUsuario);

/*RQ2015-000750 INICIO*/
public BeanList getlstZona();
public BeanList getlstOficinaCore();
/*RQ2015-000750 FIN*/
}