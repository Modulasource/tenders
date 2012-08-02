
<%@ page import="modula.marche.cpv.*,modula.*,modula.algorithme.*,modula.marche.*, java.util.*" %>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
    %><%@ include file="/desk/include/typeForm.jspf" %><%

    String sAction = request.getParameter("sAction");
	String sFormPrefix = "";
	int iIdMarcheLot = -1;	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request,0);
	
	String sIdMarcheLot = request.getParameter("iIdMarcheLot");
	String sRedirect = "afficherAffaire.jsp";
	if(marche.isAffaireAATR(false))
		sRedirect = "afficherAttribution.jsp";
	
	int iIdTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	/* exception pour les proc qui font intervenir une phase de négociation dans une procédure non négociée */
	boolean bForcedNegociation = AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure());
	
	MarcheLot lot = null;
	if( sAction.equals("store") ) 
	{

		iIdMarcheLot = Integer.parseInt( sIdMarcheLot );
		lot = MarcheLot.getMarcheLot(iIdMarcheLot );
		lot.setFromFormPaveCreationLot(request, "");
		
		if(iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE || bForcedNegociation)
		{
			lot.setEnCoursDeNegociation(true);
		}
		
		
		if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
		{
			MarcheLotDetail marcheLotDetail = null;
			try {
				marcheLotDetail = MarcheLotDetail.getMarcheLotDetailFormIdMarcheLot(lot.getId());
			} catch (Exception e) {
				marcheLotDetail = new MarcheLotDetail();
				marcheLotDetail.remove(" WHERE id_marche_lot=" + lot.getId());
				marcheLotDetail.setIdMarcheLot(lot.getId());
				marcheLotDetail.create();
			}
			
			
			marcheLotDetail.setFromForm(request, "");
			marcheLotDetail.updateValueFromIdCoutEstimeType(
					Integer.parseInt( request.getParameter("radioCoutEstimee")));
	
			marcheLotDetail.updateValueFromIdAutreDureeType(
					Integer.parseInt( request.getParameter("radioAutreDuree")));
	
			marcheLotDetail.store();
		}
		
		/* TRAITEMENT DES NOMENCLATURES */
		
		if(!bUseBoamp17 || 
		(bUseBoamp17 && (bUseFormNS || bUseFormUE)) )
		{
			
			/* suppression des anciennes nomenclatures */
			Vector vAncienCPVObjet = MarcheCPVObjet.getAllMarcheCPVObjetFromLot(lot.getIdMarcheLot());
			for (int k = 0; k < vAncienCPVObjet.size(); k++)
			{
				MarcheCPVObjet ancienCPVObjet = (MarcheCPVObjet)vAncienCPVObjet.get(k);
				Vector vAncienCPVDescripteur = CPVDescripteur.getAllCPVDescripteur(ancienCPVObjet.getIdMarcheCpvObjet());
				for (int i = 0; i < vAncienCPVDescripteur.size(); i++)
				{
					CPVDescripteur ancienCPVDescripteur = (CPVDescripteur)vAncienCPVDescripteur.get(i);
					Vector vAncienDescSupp = 
						CPVDescripteurSupplementaire
							.getAllCPVDescripteurSupplementaireFromDescripteur(
								ancienCPVDescripteur.getIdCpvDescripteur());
								
					for (int j = 0; j < vAncienDescSupp.size(); j++)
					{
						CPVDescripteurSupplementaire ancienDescSupp 
							= (CPVDescripteurSupplementaire)vAncienDescSupp.get(j);
						ancienDescSupp.remove();
					}
					ancienCPVDescripteur.remove();
				}
				ancienCPVObjet.remove();
			}
			
			/* Création des nouvelles nomenclatures CPV */
			for(int i=0;i<4;i++)
			{
				String sFieldNameDescPrincipal
					= "sIdDescripteurPrincipal" + i;
					
				if (request.getParameter(sFieldNameDescPrincipal)!= null 
				&& !request.getParameter(sFieldNameDescPrincipal).equals("") )
				{
					MarcheCPVObjet cpvObjetsup = new MarcheCPVObjet();
					cpvObjetsup.setIdMarcheLot(lot.getIdMarcheLot());
					cpvObjetsup.setCpvType(
						i==0?MarcheConstant.CPV_PRINCIPAL:MarcheConstant.CPV_SUPPLEMENTAIRE);
						
					cpvObjetsup.create();
					
					CPVDescripteur cpvDescripteur = new CPVDescripteur();
					cpvDescripteur.setCpvDescripteurType(MarcheConstant.CPV_PRINCIPAL);
					cpvDescripteur.setIdCpvPrincipal(request.getParameter(sFieldNameDescPrincipal));
					cpvDescripteur.setIdMarcheCpv(cpvObjetsup.getIdMarcheCpvObjet());
				
					cpvDescripteur.create();
	
					for (int j = 0; j < 3; j++)
					{
						String sFieldNameDescSupp
							= "iIdDescripteurSupp" + i + "_" + j ;
							
						if (request.getParameter(sFieldNameDescSupp) != null && !request.getParameter(sFieldNameDescSupp).equals(""))
						{
							CPVDescripteurSupplementaire cpvSupp = new CPVDescripteurSupplementaire();
							cpvSupp.setId(cpvDescripteur.getIdCpvDescripteur());
							cpvSupp.setName(request.getParameter(sFieldNameDescSupp));
							cpvSupp.create();
						}
					
					}
				}
			}
		}
		
		lot.store();
		
	}

	if( sAction.equals("remove") ) 
	{
		iIdMarcheLot = Integer.parseInt( sIdMarcheLot );
		lot = MarcheLot.getMarcheLot(iIdMarcheLot );
		lot.removeWithObjectAttached();

		// il faut renuméroter !
		MarcheLot.generateNumeroLotFromMarche( marche.getIdMarche() );
		
		response.sendRedirect(
				response.encodeRedirectURL(
						sRedirect+"?sAction=store&iIdOnglet="+iIdOnglet
						+"&iIdAffaire="+ marche.getIdMarche()));
		return;
	}
	
	if( sAction.equals("create") ) 
	{
		iIdMarcheLot = -1;
		lot = new MarcheLot();
		lot.setFromFormPaveCreationLot(request, "");
		lot.setIdMarche( marche.getIdMarche() );
		lot.setAttribue(false);
		
		Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche( marche.getIdMarche() );
		if(vLots == null)
		{
			lot.setNumero(1);
		}
		else
		{
			lot.setNumero(vLots.size() + 1);
		}
		
		if(iIdTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE || bForcedNegociation)
		{
			lot.setEnCoursDeNegociation(true);
		}
		
		Vector<Validite> vValiditeB = Validite.getAllValiditeEnveloppeBFromAffaire(iIdAffaire);
		if(vValiditeB != null && vValiditeB.size() > 0)	
			lot.setIdValiditeEnveloppeBCourante(vValiditeB.firstElement().getIdValidite());
		lot.create();
		
		// au cas ou c'est le bordel !
		MarcheLot.generateNumeroLotFromMarche( marche.getIdMarche() );
	}
%>
<%@page import="org.coin.util.HttpUtil"%>
<head>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js"></script>

<script type="text/javascript">
function updateParentFrame(url)
{
 try {
	 alert(parent.main.window.location.href);
 	parent.main.window.location.href=url;
 } catch(e) {
 	try {parent.window.location.href=url;
 	} catch(e) {
 		alert(e);
 	}
 }
}	
	
function closeModalFrame()
{
	parent.redirectParentTabActive('<%= 
			   response.encodeURL(rootPath + "desk/marche/algorithme/affaire/"+sRedirect+"?nonce="+System.currentTimeMillis()
			+ "&sAction=store&iIdOnglet="+ iIdOnglet 
			+ "&iIdAffaire="+marche.getIdMarche()
			+ "&nonce=" + System.currentTimeMillis()) %>');
	
	//mt.html.redirectTabActive(url).bind(parent);
	
			
	try {new parent.Control.Modal.close();}
	catch(e) { Control.Modal.close();}
}	
onPageLoad = function(){
    closeModalFrame();
}
</script>

</head>
<body>
</body>
</html>