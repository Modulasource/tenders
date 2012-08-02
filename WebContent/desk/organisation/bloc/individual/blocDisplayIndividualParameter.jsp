<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="../../pave/localizationObject.jspf" %>
<div>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	PersonnePhysique personne = (PersonnePhysique) request.getAttribute("personne");
	String sAction = (String) request.getAttribute("sAction");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

	Vector<PersonnePhysiqueParametre> vParams
		= PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(personne.getId());
 		
	String sTabParameterNameParameterList = locBloc.getValue(7, "Liste des paramètres");
	String sTabParameterNameParameterName =  localizeButton.getValueName();
	String sTabParameterNameParameterValue = localizeButton.getValueValue();

 		
	if(sAction.equals("store"))		
	{
%><%@ include file="../../pave/ongletPersonnePhysiqueParametreForm.jspf" %><%	
	}else{ 
%><%@ include file="../../pave/ongletPersonnePhysiqueParametre.jspf" %><%
	}
%>
</div>
		