<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	long lIdWorkflowDocument;
	String sAction;
	String sTitle ;
	Document item;
	Folder folder;
	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";

	lIdWorkflowDocument = Integer.parseInt( request.getParameter("lIdWorkflowDocument") );
	sTitle = "Modifier un document";
	item = Document.getDocument(lIdWorkflowDocument);
	folder = Folder.getFolder(item.getIdWorkflowFolder());

	Workflow workflow = null;
	// il faut récupérer le workflow associé
	try {
		workflow = Workflow.getWorkflowFromObject(ObjectType.WORKFLOW_DOCUMENT, item.getId());
	} catch (Exception e ) {
		e.printStackTrace();
		workflow = new Workflow ();
	}

	Vector vWorkflows =  DefinitionWorkflow.getAllStatic();
	Vector vStates = DefinitionState.getAllStatic();
	Vector vTransitions = DefinitionTransition.getAllFromIdDefinitionWorkflow(item.getId());
	Vector vObjectType =  ObjectType.getAllObjectType();
	Vector vPathEvent = PathEvent.getAllFromIdWorkflow(workflow.getId());



	String sTypeObjectName = "";
	String sWFInitialName = "";
	String sWFCurrentName = "";
	String sStateCurrentName = "";

	try {

		ObjectType typeObject =
			(ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (workflow.getIdTypeObject(), vObjectType);

		sTypeObjectName = typeObject.getName();

		DefinitionWorkflow wfInitial =
			(DefinitionWorkflow) DefinitionWorkflow
				.getCoinDatabaseAbstractBeanFromId (workflow.getIdDefinitionWorkflowInitial(), vWorkflows);

		sWFInitialName = wfInitial.getName();

		DefinitionWorkflow wfCurrent =
			(DefinitionWorkflow) DefinitionWorkflow
				.getCoinDatabaseAbstractBeanFromId (workflow.getIdDefinitionWorkflowCurrent(), vWorkflows);

		sWFCurrentName = wfCurrent.getName();


		DefinitionState stateCurrent =
			(DefinitionState) DefinitionState
				.getCoinDatabaseAbstractBeanFromId (workflow.getIdDefinitionStateCurrent(), vStates);

		sStateCurrentName = stateCurrent.getName() + " (" + stateCurrent.getId()  + ")";

	} catch (Exception e){}

	Vector vDTR = DocumentReferentType.getAllStatic();
	DocumentReferentType dtr = new DocumentReferentType();

	Vector vDestinataire = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_DESTINATAIRE);

	Vector vEmetteur = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_EMETTEUR);

	Vector vDestinataireCopie = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_DESTINATAIRE_EN_COPIE);

	Vector vDestinataireCopieCachee = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_DESTINATAIRE_EN_COPIE_CACHEE);

	Vector vCorrecteur = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_CORRECTEUR);

	Vector vSignataire = DocumentReferent.getAllFromIdWorkflowDocumentAndType(
			item.getId(),
			DocumentReferentType.TYPE_SIGNATAIRE);


	Vector vPersonne = PersonnePhysique.getAllStatic();



%>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<form name="formulaire" action="nonce" method="post" >
	<input type="hidden" name="lIdWorkflowDocument" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<%@ include file="../../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Définition du document <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><%= item.getName()%></td>
			</tr>
			<tr>
				<td class="label" >Dossier :</td>
				<td class="frame"><%= folder.getName() %>
				</td>
			</tr>
			<tr>
				<td class="label" >Emetteurs :</td>
				<td class="frame">
				<%= DocumentReferent.getAllPersonNameHtml(vEmetteur, vPersonne) %>
				<input type="button"
					value="+"
					onclick="Redirect('<%=response.encodeURL(
		  	 			"modifyDocumentReferentForm.jsp?sAction=create"
		  	 			+ "&lIdWorkflowDocument="+ item.getId()
		  	 			+ "&lIdWorkflowDocumentReferentType=" + DocumentReferentType.TYPE_EMETTEUR)  %>')" />

				</td>
			</tr>
			<tr>
				<td class="label" >Destinataires :</td>
				<td class="frame">
				<%= DocumentReferent.getAllPersonNameHtml(vDestinataire, vPersonne) %>
				<input type="button"
					value="+"
					onclick="Redirect('<%=response.encodeURL(
		  	 			"modifyDocumentReferentForm.jsp?sAction=create"
		  	 			+ "&lIdWorkflowDocument="+ item.getId()
		  	 			+ "&lIdWorkflowDocumentReferentType=" + DocumentReferentType.TYPE_DESTINATAIRE)  %>')" />
				</td>
			</tr>
			<tr>
				<td class="label" >Destinataires en copie :</td>
				<td class="frame">
				<%= DocumentReferent.getAllPersonNameHtml(vDestinataireCopie, vPersonne) %>
				<input type="button"
					value="+"
					onclick="Redirect('<%=response.encodeURL(
		  	 			"modifyDocumentReferentForm.jsp?sAction=create"
		  	 			+ "&lIdWorkflowDocument="+ item.getId()
		  	 			+ "&lIdWorkflowDocumentReferentType=" + DocumentReferentType.TYPE_DESTINATAIRE_EN_COPIE)  %>')" />
				</td>
			</tr>
			<tr>
				<td class="label" >Destinataires en copie cachée :</td>
				<td class="frame">
				<%= DocumentReferent.getAllPersonNameHtml(vDestinataireCopieCachee, vPersonne) %>
				<input type="button"
					value="+"
					onclick="Redirect('<%=response.encodeURL(
		  	 			"modifyDocumentReferentForm.jsp?sAction=create"
		  	 			+ "&lIdWorkflowDocument="+ item.getId()
		  	 			+ "&lIdWorkflowDocumentReferentType=" + DocumentReferentType.TYPE_DESTINATAIRE_EN_COPIE_CACHEE)  %>')" />
				</td>
			</tr>
		</table>
	</div>
	<br />


	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Workflow initial :</td>
				<td class="frame">
			<%=	sWFInitialName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Etat courant :</td>
				<td class="frame">
			<%=	sStateCurrentName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Workflow courant :</td>
				<td class="frame">
			<%=	sWFCurrentName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Type objet :</td>
				<td class="frame">
			<%=	sTypeObjectName %>
				</td>
			</tr>
			<tr>
				<td class="label" >Référence objet :</td>
				<td class="frame"><%= workflow.getIdReferenceObject()%></td>
			</tr>
		</table>
	</div>
	<br />




	<!-- La liste -->
	<div class="sectionTitle"><div>Historique</div></div>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="10%">Objet type</td>
				<td width="10%">Objet ref</td>
				<td width="10%">Objet type cible</td>
				<td width="10%">Objet ref cible</td>
				<td width="20%"></td>
			</tr>
<%
for (int i=0; i < vPathEvent.size(); i++)
{
	PathEvent evt = (PathEvent ) vPathEvent.get(i);

	String sTypeEvent = "";
	String sTypeTarget = "";
	String sReferenceObjectName = "";

	try {

		ObjectType typeEvent =
			(ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (evt.getIdTypeObjectEvent(), vObjectType);

		ObjectType typeTarget
			= (ObjectType) ObjectType
				.getCoinDatabaseAbstractBeanFromId (evt.getIdTypeObjectTarget(), vObjectType);

		sTypeEvent = typeEvent.getName();
		sTypeTarget = typeTarget.getName();


		switch((int)evt.getIdTypeObjectEvent())
		{
		case ObjectType.WORKFLOWDEFINITION_STATE :
			DefinitionState state = DefinitionState.getDefinitionState(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = state.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION :
			DefinitionTransition transition = DefinitionTransition.getDefinitionTransition(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = transition.getName();
			break;

		case ObjectType.WORKFLOWDEFINITION_TRANSITION_CONDITION :
			DefinitionTransitionCondition condition = DefinitionTransitionCondition.getDefinitionTransitionCondition(evt.getIdReferenceObjectEvent());
			sReferenceObjectName = condition.getName();
			break;

		}


	} catch (Exception e){}

%>
		  	<tr class="liste<%=i%2%>"
		  	 	onmouseover="className='liste_over'"
		  	 	onmouseout="className='liste<%=i%2%>'"
		  	 	onclick="Redirect('<%=response.encodeRedirectURL(
		  	 			rootPath + "desk/workflow/modifyPathEventForm.jsp?sAction=store&lIdPathEvent="+evt.getId())  %>')">
		    	<td><%= sTypeEvent  %></td>
		    	<td><%=sReferenceObjectName + " (" + evt.getIdReferenceObjectEvent() + ")" %></td>
		    	<td><%= sTypeTarget    %></td>
		    	<td><%=evt.getIdReferenceObjectTarget()    %></td>
		    	<td></td>
		  	</tr>
<%
}

%>

		</table>
	</div>




	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<input type="button" value="Modifier" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyDocumentForm.jsp?sAction=store&lIdWorkflowDocument=" + item.getId() )
				%>')" />
			<input type="button" value="Supprimer" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"modifyDocument.jsp?sAction=remove&lIdWorkflowDocument=" + item.getId() )
				%>')" />
			<input type="button" value="Annuler" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayAllDocument.jsp" )
				%>')" />
		</div>
	</div>
</div>
<%@ include file="../../include/footerFiche.jspf" %>
</form>
</body>
</html>