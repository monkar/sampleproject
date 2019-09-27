<%@ page import="com.clinica.beans.XML"%>
<%@ page contentType="text/xml;charset=UTF8"%>

<?xml version = '1.0' encoding = 'windows-1252'?>
<jsp:useBean id="objXml" class="com.clinica.beans.XML" scope="request"/>
<archivoxml>
    <asegurado>
        <ruc_financiador><%=objXml.getRuc_financiador()%></ruc_financiador>
        <tip_doc_autorizacion><%=objXml.getTip_doc_autorizacion()%></tip_doc_autorizacion>
        <cod_autorizacion><%=objXml.getCod_autorizacion()%></cod_autorizacion>
        <fec_autorizacion><%=objXml.getFec_autorizacion()%></fec_autorizacion>
        <des_asegurado_codigo><%=objXml.getDes_asegurado_codigo()%></des_asegurado_codigo>
        <des_paterno_asegurado><%=objXml.getDes_paterno_asegurado()%></des_paterno_asegurado>
        <des_materno_asegurado><%=objXml.getDes_materno_asegurado()%></des_materno_asegurado>
        <des_nombre_asegurado><%=objXml.getDes_nombre_asegurado()%></des_nombre_asegurado>
        <ide_sexo><%=objXml.getIde_sexo()%></ide_sexo>
        <fec_nacimiento_asegurado><%=objXml.getFec_nacimiento_asegurado()%></fec_nacimiento_asegurado>
        <ide_doc_identidad><%=objXml.getIde_doc_identidad()%></ide_doc_identidad>
        <num_doc_identidad_asegurado><%=objXml.getNum_doc_identidad_asegurado()%></num_doc_identidad_asegurado>
        <ide_parentesco><%=objXml.getIde_parentesco()%></ide_parentesco>
        <des_paterno_titular><%=objXml.getDes_paterno_titular()%></des_paterno_titular>
        <des_materno_titular><%=objXml.getDes_materno_titular()%></des_materno_titular>
        <des_nombre_titular><%=objXml.getDes_nombre_titular()%></des_nombre_titular>
        <ide_doc_identidad_titular><%=objXml.getIde_doc_identidad_titular()%></ide_doc_identidad_titular>
        <num_doc_identidad_titular><%=objXml.getNum_doc_identidad_titular()%></num_doc_identidad_titular>
        <des_razon_social_contratante><%=objXml.getDes_razon_social_contratante()%></des_razon_social_contratante>
        <num_ruc_contratante><%=objXml.getNum_ruc_contratante()%></num_ruc_contratante>
    </asegurado>
    <cobertura>
        <cod_beneficio><%=objXml.getCod_beneficio()%></cod_beneficio>
        <des_beneficio><%=objXml.getDes_beneficio()%></des_beneficio>
        <imp_tipo_valor_ded><%=objXml.getImp_tipo_valor_ded()%></imp_tipo_valor_ded>
        <ide_moneda_ded><%=objXml.getIde_moneda_ded()%></ide_moneda_ded>
        <imp_valor_ded><%=objXml.getImp_valor_ded()%></imp_valor_ded>
        <flg_igv_valor_ded><%=objXml.getFlg_igv_valor_ded()%></flg_igv_valor_ded>
        <por_coa><%=objXml.getPor_coa()%></por_coa>
    </cobertura>
    <exclusion>
        <ide_tipo_codif_diag><%=objXml.getIde_tipo_codif_diag()%></ide_tipo_codif_diag>
        <ref_codif_diag><%=objXml.getRef_codif_diag()%></ref_codif_diag>
        <des_exclusion><%=objXml.getDes_exclusion()%></des_exclusion>
    </exclusion>
</archivoxml>
