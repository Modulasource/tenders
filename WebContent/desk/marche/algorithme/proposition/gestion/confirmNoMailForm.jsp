<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.fr.bean.mail.*,modula.marche.*, java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.coin.util.*" %>
<%
	boolean bNegociation=false;
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sAction = request.getParameter("sAction");
	String sAvertissement="";
	String sTitle = "Confirmation de non envoi du mail";
	
	if (sAction.equalsIgnoreCase("nonRec"))
	{
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-14");
	sAvertissement="Etes vous sûr de ne pas vouloir envoyer de mails aux candidats non recevables (vous ne pourrez plus leur envoyer de mails après cette confirmation).";
	}
	if (sAction.equalsIgnoreCase("rec"))
	{
		bNegociation = HttpUtil.parseBoolean("bNegociation", request,  false);
	 	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");
	 	sAvertissement="Etes vous sûr de ne pas vouloir envoyer de mails aux candidats recevables (vous ne pourrez plus leur envoyer de mails après cette confirmation).";
	 }
	 
	 int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
		


%><script type="text/javascript" src="<%= rootPath + "include/fonctions.js" %>"></script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<div align="center">
<br />
<div class="rouge" style="font-size:12px;"><h2>
<%=sAvertissement %></h2>
</div>
<button type="button" 
			name="poursuivre"  
			class="disableOnClick"
			onclick="Redirect('<%= 
		response.encodeURL(rootPath 
			+ "desk/marche/algorithme/proposition/gestion/confirmNoMail.jsp"
			+ "?sAction="+sAction
			+"&bNegociation"+bNegociation
			+ "&iIdNextPhaseEtapes=" +iIdNextPhaseEtapes) 
			+ "&iIdAffaire=" + iIdAffaire %>');" >Confirmer</button>&nbsp;&nbsp;

<button type="button" 
			name="retour"  
			class="disableOnClick"
			onclick="closeModalAndRedirectTabActive('<%= 
		response.encodeURL(rootPath
				+"desk/marche/algorithme/proposition/gestion/afficherEnveloppesA.jsp?iIdAffaire=" + iIdAffaire
						+ "&iIdNextPhaseEtapes=" +iIdNextPhaseEtapes
						) %>');" >Annuler</button>&nbsp;



</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</body>
<%@page import="org.coin.util.HttpUtil"%>
</html>