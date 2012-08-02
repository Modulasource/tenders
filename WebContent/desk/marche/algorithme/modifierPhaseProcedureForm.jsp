<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.algorithme.*,modula.graphic.*" %>
<%
	String sSelected ;
	String sTitle ;
	String sAction = "store";
	int iIdPhaseProcedure;

	String sFlecheGauche = rootPath + Icone.ICONE_GAUCHE;
	String sFlecheDroite = rootPath + Icone.ICONE_DROITE;
	String sFlecheHaut = rootPath + Icone.ICONE_HAUT;
	String sFlecheBas = rootPath + Icone.ICONE_BAS;
	iIdPhaseProcedure = Integer.parseInt( request.getParameter("iIdPhaseProcedure") );
	
	PhaseProcedure oPhaseProcedure = PhaseProcedure.getPhaseProcedureMemory(iIdPhaseProcedure);	
	Vector<Etape> vEtapes = PhaseEtapes.getAllEtapesForPhaseProcedureMemory(oPhaseProcedure.getId());
	Vector<Etape> vEtapesAll = Etape.getAllForPhaseMemory( oPhaseProcedure.getIdAlgoPhase());
	sTitle = "Définition de la phase " + Phase.getPhaseName(oPhaseProcedure.getIdAlgoPhase() ); 

	
%>
<script src="<%= rootPath %>include/bascule.js" type="text/javascript"></script>
<script type="text/javascript">
function confirmSubmit(phrase){
	var agree=confirm("Etes vous sûr de vouloir "+phrase);
	if (agree)
		return true ;
	else
		return false ;
}

function confirmAndDoUrl(phrase, url){
	if(!confirm("Etes vous sûr de vouloir "+phrase))
		return false;
	
	Redirect(url);
}

</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierPhaseEtapes.jsp")%>"  >
	<input type="hidden" name="iIdPhaseProcedure" value="<%=oPhaseProcedure.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<br />
	<table class="menu" cellspacing="2" summary="menu">
		<tr>
			<th>
				<button type="button" onclick="javascript:confirmAndDoUrl('supprimer cette phase ?','<%= 
					response.encodeURL("modifierPhaseProcedure.jsp?sAction=remove&amp;iIdProcedure="+oPhaseProcedure.getIdAlgoProcedure()
					+"&amp;iIdPhaseProcedure="+iIdPhaseProcedure) 
					%>');" >Supprimer</button>
			</th>
			<td>&nbsp;</td>
		</tr>
	</table>
	<br />
	
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan='2'>Liste des étapes de la phase</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<select name="iIdEtape" size="15" style="width:250px" multiple="multiple" >
<%

	for (int i=0; i < vEtapesAll.size(); i++)
	{
		Etape etape = (Etape) vEtapesAll.get(i);
		boolean bDisplayEtape = true;
		
		for (int j=0; j < vEtapes.size(); j++)
		{
			Etape etapeTmp = (Etape) vEtapes.get(j);
		
			if(etape.getId() == etapeTmp.getId())
			{
				bDisplayEtape = false;
			}
		}
		if(bDisplayEtape )
		{
			out.write("<option value='"+ etape.getId() +"'>" + etape.getLibelle() + "</option>\n");
		}
		
	}
		  %>
                </select>
			</td >
		
		
			<td class="pave_cellule_droite">
				<table summary="none">
					<tr>
						<td style="width:100px;text-align:center">
						
						
						
						
			<table colspan="2">
				<tr>
					<td colspan="2" align="center">
					<a href="#" onclick="monter(document.formulaire.iIdEtapeSelection)">
						<img src="<%= sFlecheHaut %>"  />
					</a>
					</td>
				</tr>
				<tr>
					<td style="width:50%">
					<a href="#" onclick="DeplacerTous(document.formulaire.iIdEtapeSelection,document.formulaire.iIdEtape)">
						<img src="<%= sFlecheGauche %>"  />
					</a>
					</td>
					<td align="right">
					<a href="#" onclick="DeplacerTous(document.formulaire.iIdEtape,document.formulaire.iIdEtapeSelection)">
						<img src="<%= sFlecheDroite %>"  />
					</a>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<a href="#" onclick="descendre(document.formulaire.iIdEtapeSelection)">
							<img src="<%= sFlecheBas %>"  />
						</a>
					</td>
				</tr>
			</table>
						
						
						
						</td>
						<td>
							<select name="iIdEtapeSelection" size="15" style="width:250px" multiple="multiple" >
							<%
							
								for (int j=0; j < vEtapes.size(); j++)
								{
									Etape etape = (Etape) vEtapes.get(j);
									out.write("<option value='"+ etape.getId() +"'>" + etape.getLibelle() + "</option>\n");
								}
									  %>
		                    </select>
							<input type="hidden" name="iIdEtapeSelectionListe" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br />
	<div align="center">
	<button type="submit" 
		onclick="javascript:Visualise(document.formulaire.iIdEtapeSelection,document.formulaire.iIdEtapeSelectionListe);" 
		><%=sTitle %></button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure="+oPhaseProcedure.getIdAlgoProcedure()) 
		%>')" >Annuler</button>
	</div>
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
