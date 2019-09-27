package com.clinica.utils;

import java.util.HashMap;

public class Constante 
{
  private static HashMap cConsMap = new HashMap();

  public Constante()
  {
  }
  
  public static final int NRAMOASME = 23; //Codigo de ramo de asistencia médica
  public static final int NCOVEREMACC = 215; //Codigo de cobertura de emergencia accdidental
  public static final int NCOVEREMMED = 138; //Codigo de cobertura de emergencia accdidental
  
  public static final String SATENAMB = "AMB"; //Modalidad de atencion ambulatoria
  public static final String SATENHOSP = "HOSP"; //Modalidad de atencion hospitalaria
  public static final int NATENAMB = 2; //Modalidad de atencion ambulatoria
  public static final int NATENHOSP = 1; //Modalidad de atencion hospitalaria
  public static final int NCNCEPCU = 3; //Concepto Cuarto unipersonal
  public static final int NCNCEPHM = 7; //Concepto Honorarios Médicos

  public static final int NESTREG = 1; //Estado registrado
  public static final int NESTPEN = 2; //Estado solicitado 
  public static final int NESTANU = 3; //Estado anulado
  public static final int NESTRECH= 4; //Estado rechazado
  public static final int NESTAPR = 5; //Estado aprobado
  public static final int NESTOBS = 6; //Estado observado
  // INI - REQ 2011-0305 BIT/FMG
  public static final int NESTLEVOBS = 8; //Estado levantamiento de observación
  public static final int NESTDER = 9; //Estado derivado
  public static final int NESTAMP = 10; //Estado ampliado
  public static final int NESTAVG = 11; //Estado aviso de gerencia dlch
  // FIN - REQ 2011-0305 BIT/FMG
  
  public static final int NROLOPE = 1; //Rol Operador
  public static final int NROLMED = 2; //Rol Medico Auditor
  public static final int NROLCME = 3; //Rol Central Médica
  public static final int NROLATEC= 4; //Rol Analista Tecnico
  public static final int NROLFUN = 5; //Rol Funcionario
  public static final int NROLADM = 6; //Rol Administrador
  public static final int NROLASAD = 7; //Rol Asistente Administrador
  public static final int NROLADMSIS = 8; //Rol Administrador Sistema
  public static final int NROLENF = 9; //Rol Enfermera
  public static final int NROLBRK = 10; //Rol Broker
  public static final int NROPERFILBRK = 11; //Rol Broker P-2012-0510
  public static final int NROLENTEX = 12; //Rol Broker
  public static final int NROLAUDIMED = 13; //Rol Soporte Auditor Medico RQ2015-000604
  public static final int NROLASIRECH = 14; //Rol Asistente de Rechazo RQ2015-000604
  public static final int NROLEMISOR = 16; //Rol EMISOR RQ2017-1848
  
  //RQ2015-000604 - Estados de la carta de rechazo
  public static final int NSTCRPEND = 1; //Estado Pendiente
  public static final int NSTCRTER = 2; //Estado Terminado
  public static final int NSTCRIMP = 3; //Estado Impreso
  //RQ2015-000604
  
  public static final int NTSCARGAR = 2; //Tipo de solicitud Carta de Garantía
  public static final int NTSCARAUT = 1; //Tipo de solicitud Carta de Autorizacion
  public static final int NTSCARBEN = 3; //Tipo de solicitud Solicitud de Beneficio

  public static final String SNOMCARBEN = "Sol. de Beneficio"; //Tipo de solicitud Solicitud de Beneficio
  public static final String SNOMCARODO = "Sol. de Beneficio Odontológico"; //Tipo de solicitud Solicitud de Beneficio Odontológico
  public static final String SNOMCOVEMERACC = "Sol. de Emergencia Accidental"; //Tipo de solicitud Solicitud de Beneficio Odontológico
  public static final String SNOMCOVEMERMED = "Sol. de Emergencia Médica"; //Tipo de solicitud Solicitud de Beneficio Odontológico
  
  public static final int NCODMONEDASOL = 1; //Ramo de asistencia médica
  public static final int NCODMONEDADOL = 2; //Ramo de asistencia médica
  public static final int NCODMONEDALOCAL = 1; //Tipo de solicitud Carta de Autorizacion

//  public static final String pathFileUpload="/upload/webclinic/";
  public static final String pathFileUpload= Tool.getContextPath() +"/upload/webclinic_eps/";
  public static final int NUSERCODE = 10048; //Usuario Genérico para Web Clinic
  public static final int NGENCOVERODONT = 217;//Cobertura generica para beneficio odontológico
  public static final int NGENCOVEREMEACC = 215;//Cobertura generica para emergencia accidental
  public static final int NGENCOVEREMEMED = 138;//Cobertura generica para emergencia médica
  public static final int NCODGRUPOCESP = 4; //Código de grupo, para los centros especializados
  public static final int NCODGRUPOMINV = 8; //Código de grupo, para el ministerio de vivienda
  public static final int NCODGRUPOPROT = 9; //Código de grupo, para la protectora
  //Req 2011-0849
  public static final int NCODGRUPOTINTA = 10; //Código de grupo, para la TINTAYA
  public static final int NCODGRUPOJCOR = 11; //Código de grupo, para JOSE CORNEJO DE TINTAYA
  //Fin Req 2011-0849
  public static final int NSTATCLAIMANUL = 1; //STACLAIM ANULADO TABLE CLAIM INX
  public static final int NSTATCLAIMPINF = 6; //STACLAIM PENDIENTE DE INFORMACION TABLE CLAIM INX
  public static final int NSTATCLAIMTRAMI = 2; //STACLAIM EN TRAMITE TABLE CLAIM INX
  public static final int NIDESTADOSOLICI = 3; //STACLAIM EN TRAMITE TABLE CLAIM INX
  //Req 2011-0480
  
  //Fin Req 2011-0480
  
  public static final int CODMONTOCUARTO = 1;
  public static final int CODMONTOSALAOPERA = 2;
  public static final int CODMONTOSALARECUP = 3;
  public static final int CODMONTOCIRUJANO = 4;
  public static final int CODMONTOPRIMERASIS = 5;
  public static final int CODMONTOSEGUNDOASIS = 6;
  public static final int CODMONTOANESTESIA = 7;
  public static final int CODMONTOFARMACIAPISO = 8;
  public static final int CODMONTOFARMACIASALA = 9;
  public static final int CODMONTOUSOEQUIP = 10;
  public static final int CODMONTOOXIGENO = 11;
  public static final int CODMONTOCARDIOLOGIA = 12;
  public static final int CODMONTOLABORATORIO = 13;
  public static final int CODMONTORADIOLOGIA= 14;
  public static final int CODMONTOECOGRAFIA = 15;
  public static final int CODMONTOEQUIPOSESP = 16;
  public static final int CODMONTOTOMOGRAFIA = 17;
  public static final int CODMONTORESONANCIA = 18;
  public static final int CODMONTOOTROS = 19;
  
  /* AF-64 */
  public static final int CODMONTOOSTEOSINTESIS = 20;
  public static final int CODMONTOPROTESIS = 21;
  /* Fin AF-64 */
  
  public static final int CODMOTIVODEUDA = 1;
  
  public static final int CODSINDEUDA = 0;
  public static final int CODDEUDAPERMIS = 1;
  public static final int CODDEUDABLOQUEO = 2;
  
  public static final int CATEGORIAVIP = 1;
  public static final int CATEGORIANORMAL = 2;

 /* P 2012-0078  / Sesion */
  public static final String SREGCOACERO = "sRegistroCoaseguroCero";
  public static final String MONTOMINCOASEGURO = "0.00";
  public static final String SPRIMERSIN = "sPrimerSiniestro";
  public static final String SMONTOINICIAL = "sMontoInicial";
  /* P 2012-0078 */

  public static final int NENVIOREALIZADO = 1;
  public static final int NENVIOPENDIENTE = 2;

  public static final String LOGO_DEFECTO = "images/nuevo_logo.png";
  public static final String KEY_URL_LOGO = "URL_LOGO";

  //RQ2019-626-INICIO/
  public static final int NRAMOSCRIND = 81; //Codigo de ramo de sctr independiente
  public static final int NRAMOPLANREG = 82; //Codigo de ramo de planes regulares
  public static final int NRAMOPOTEST = 83; //Codigo de ramo de potestativos
  //RQ2019-626-FIN/
  
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