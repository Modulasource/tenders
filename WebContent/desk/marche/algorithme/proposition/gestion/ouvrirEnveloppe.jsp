<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.util.*,java.net.*,modula.marche.*,org.coin.fr.bean.*, modula.candidature.*, java.util.*" %>
<%


	boolean bExistVirus = false;
	
	PersonnePhysique user = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

	int iIdCandidature = -1;
	try {iIdCandidature = HttpUtil.parseInt("iIdCandidature",request);} 
	catch (Exception e ) {
		throw new Exception("iIdCandidature non défini, ceci est dû au retour de l'applet sur la même page."
				+ "<br/> il n'y a que deux params iIdMarche et iIdNextPhaseEtape. Pb à corriger");
	}
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	boolean bIsCandidaturePapier = candidature.isCandidaturePapier(false);
	
	Organisation organisationCDT = Organisation.getOrganisation(candidature.getIdOrganisation());
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
    Marche marche = Marche.getMarche(lot.getIdMarche());
    int iIdAffaire = marche.getIdMarche();
	int iTypeEnveloppe = HttpUtil.parseInt("iTypeEnveloppe",request);
	String sPageUseCaseId = "";
	boolean bIsClassementEnveloppesFige = false;
	boolean bIsAnonyme = false;
	String sTypeEnveloppe = "";
	
	switch(iTypeEnveloppe){
	case Enveloppe.TYPE_ENVELOPPE_A:
		sPageUseCaseId = "IHM-DESK-AFF-13";
		bIsClassementEnveloppesFige = lot.isClassementEnveloppesAFige(false);
		bIsAnonyme = marche.isEnveloppesAAnonyme(false);
		sTypeEnveloppe = "A";
		break;
	case Enveloppe.TYPE_ENVELOPPE_B:
		sPageUseCaseId = "IHM-DESK-AFF-16";
		bIsClassementEnveloppesFige = lot.isClassementEnveloppesBFige(false);
		bIsAnonyme = marche.isEnveloppesBAnonyme(false);
		sTypeEnveloppe = "B";
		break;
	case Enveloppe.TYPE_ENVELOPPE_C:
		sPageUseCaseId = "IHM-DESK-AFF-16";
		bIsClassementEnveloppesFige = lot.isClassementEnveloppesCFige(false);
		bIsAnonyme = marche.isEnveloppesCAnonyme(false);
		sTypeEnveloppe = "C";
		break;
	}
	
	if(!sPageUseCaseId.equalsIgnoreCase(""))
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	URL oURLImage = null;
	URL oURLServlet = null;
	URL oURLTraitement = null;
	oURLImage = HttpUtil.getUrlWithProtocolAndPort(
			rootPath+"images/icones/",
			request); 
	oURLServlet = HttpUtil.getUrlWithProtocolAndPort(
				rootPath,
				request);
	oURLTraitement = HttpUtil.getUrlWithProtocolAndPort(
			rootPath+"desk/marche/algorithme/proposition/gestion/ouvrirEnveloppe.jsp",
			request); 
	 
	String sURL[] = Outils.parserChaineVersString(response.encodeURL(oURLServlet.toString()),";");
	String sSessionId = "";
	if(Outils.parserChaineVersString(response.encodeURL(oURLServlet.toString()),";") != null) sSessionId = ";"+sURL[1];
		
	String sVaultPath = "";
	try {sVaultPath = MarcheParametre.getMarcheParametreValue(marche.getIdMarche(),"vault.path");}
	catch(Exception e){}
	
	String sFileSeparator = System.getProperty("file.separator");
%>
</head>
<body>
<div style="padding:15px">
<%
if(!bIsCandidaturePapier)
{

	Vector<HashMap<String,Object>> vAllEnveloppes = Candidature.getMapEnveloppeFromCtx(iIdCandidature,iTypeEnveloppe,marche,iIdLot);
    for(HashMap<String,Object> map : vAllEnveloppes){
		Vector vEnveloppes = (Vector)map.get("enveloppes");
		int iIdTypeObjetEnv = (Integer)map.get("iIdTypeObjetEnv");
		int iIdTypeObjetEnvPJ = (Integer)map.get("iIdTypeObjetEnvPJ");
		String sTitleListPJ = (String)map.get("title");
		if(vEnveloppes != null && !vEnveloppes.isEmpty())
		{
			for(Enveloppe eEnveloppe : (Vector<Enveloppe>)vEnveloppes)
			{
				Vector vDemandes = DemandeInfoComplementaire.getAllDemandeFromEnveloppe(sTypeEnveloppe,eEnveloppe.getIdEnveloppe()); 
				boolean bIsCachetee = false;
				Vector vPiecesJointes = null;
				switch(iIdTypeObjetEnvPJ){
				case ObjectType.ENVELOPPE_A_PJ:
					vPiecesJointes = EnveloppeAPieceJointe.getAllEnveloppeAPiecesJointesFromEnveloppe(eEnveloppe.getIdEnveloppe());
					bIsCachetee = ((EnveloppeA)eEnveloppe).isCachetee(false);
					break;
				case ObjectType.ENVELOPPE_B_PJ:
					vPiecesJointes = EnveloppeBPieceJointe.getAllEnveloppeBPiecesJointesFromEnveloppe(eEnveloppe.getIdEnveloppe());
					bIsCachetee = ((EnveloppeB)eEnveloppe).isCachetee(false);
					break;
				case ObjectType.ENVELOPPE_C_PJ:
					vPiecesJointes = EnveloppeCPieceJointe.getAllEnveloppeCPiecesJointesFromEnveloppe(eEnveloppe.getIdEnveloppe());
					bIsCachetee = ((EnveloppeC)eEnveloppe).isCachetee(false);
					break;
				}
				
			    if(vPiecesJointes.size() == 0) {
			        %>
					<table class="pave" >
					   <tr>
					       <td class="pave_titre_gauche">Attention</td>
					       <td class="pave_titre_droit"></td>
					   </tr>
					   <tr>
					       <td class="pave_cellule_gauche" colspan="2">Il n'y a aucune pièce dans l'enveloppe !!</td>
					       
					   </tr>
					</table>
			        <%
			    }
				
				if(bIsCachetee){
				%>
				<input type="hidden" name="iIdEnveloppe" value="<%= eEnveloppe.getIdEnveloppe() %>" />
				<%@ include file="paveTable/tableListPJ.jsp" %>
				<br/>
				<% if(iIdTypeObjetEnvPJ == ObjectType.ENVELOPPE_A_PJ){%>
					<%@ include file="paveTable/tableDemandeInfo.jsp" %>
					<br/>
				<%} %>
				<%@ include file="paveTable/tableCommentaireEnv.jsp" %>
				<br/>
				<%
				}
			}
		}
	}

	
}
else
{
%>
<%@ include file="paveTable/tableCandPapier.jsp" %>
<br/>
<%
}
%>

<%if(bExistVirus){%>
<div class="rouge" style="text-align:left;">
* : <b>AVERTISSEMENT SECURITE</b> 
Attention ! Si vous téléchargez un fichier considéré par l'antivirus ClamAV comme vérolé, vous risquez de contaminer votre ordinateur. L'ouverture de ce fichier est à vos risques et périls. Matamore décline toute responsabilité quand aux conséquences qui pourraient s'en suivre.
</div>
<%}%>

</div>
</body>
</html>