<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="java.sql.*,org.coin.util.treeview.*,modula.algorithme.*,java.text.*,org.coin.util.*, java.util.*, modula.journal.*, org.coin.fr.bean.*, modula.marche.*, modula.commission.*,org.coin.bean.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "événements";
	String sType = "";
	String sConstraint = "";
	String sExtraParam = "";
	Timestamp tsDateAujourdhui = new Timestamp(System.currentTimeMillis());
	//Timestamp tsDate = CalendarUtil.getConversionSimpleTimestamp(sdate);
	Calendar calDate = Calendar.getInstance();
	calDate.setTimeInMillis(tsDateAujourdhui.getTime());
	calDate.set(Calendar.DAY_OF_MONTH, 1);


	int jour=0,mois=0,annee=0;
	jour = calDate.get(Calendar.DAY_OF_MONTH);
	mois = calDate.get(Calendar.MONTH) + 1;
	annee = calDate.get(Calendar.YEAR);
	
	try { jour = Integer.parseInt(request.getParameter("iDay")); } catch (Exception e) {}
	try { mois = Integer.parseInt(request.getParameter("iMonth")); } catch (Exception e) {}
	try { annee = Integer.parseInt(request.getParameter("iYear")); } catch (Exception e) {}

	calDate.set(Calendar.DAY_OF_MONTH, jour);
	calDate.set(Calendar.MONTH, mois -1);
	calDate.set(Calendar.YEAR, annee);
	
	Calendar calDateFin = Calendar.getInstance();
	calDateFin.setTimeInMillis(tsDateAujourdhui.getTime());
	calDateFin.set(Calendar.DAY_OF_MONTH, calDate.getActualMaximum(Calendar.DAY_OF_MONTH));
	calDateFin.set(Calendar.MONTH, mois -1);
	calDateFin.set(Calendar.YEAR, annee);

	
	int iNbJoursDuMois = calDate.getActualMaximum(Calendar.DAY_OF_MONTH);
	String sMois[] = CalendarUtil.arrMonthNameFR;

	int iPremierJour = CalendarUtil.getFirstDayOfMonth(calDate) - 1; 
	if (iPremierJour ==-1) iPremierJour=6;
	else if (iPremierJour == 0) iPremierJour = 7;
	int iObjectType = -1;
	
	if (request.getParameter("sType") != null){
		sType = request.getParameter("sType");
		sConstraint += " AND typ.id_type_objet_modula = " + sType;
		sExtraParam += "&sType=" + sType;
		
		iObjectType =Integer.parseInt(sType);
		switch (iObjectType )
		{
		case ObjectType.AFFAIRE: 
			sTitle += " Marché ";
			break;

		case ObjectType.COMMISSION: 
			sTitle += " Commission ";
			break;
		
		case ObjectType.ORGANISATION: 
			sTitle += " Organisation ";
			break;
		
		case ObjectType.PERSONNE_PHYSIQUE: 
			sTitle += " Personne physique ";
			break;
		}
			
		
	} else {
		sType = "";
	}

	String sIdObjet = "";
	if (request.getParameter("sIdObjet") != null){
		sIdObjet = request.getParameter("sIdObjet");
		
		if (request.getParameter("sReference") != null)
		{
			sTitle += " réf. " + request.getParameter("sReference") ;
		}
		else
		{
			sTitle += " réf. interne " + sIdObjet ;
		}
		
		if(iObjectType == ObjectType.PERSONNE_PHYSIQUE)
		{
			PersonnePhysique pp = PersonnePhysique.getPersonnePhysique( Integer.parseInt(sIdObjet) );
			sConstraint = 
		    	" AND (( evt.id_reference_objet=" + sIdObjet
		     		+ " AND evt.id_type_evenement=typ.id_type_evenement )"
		     	+ " OR (evt.id_coin_user=" + User.getIdUserFromIdIndividual(pp.getId()) 
		     		+ " AND evt.id_type_evenement=typ.id_type_evenement)   ) ";
		}
		else
		{
			sConstraint += " AND evt.id_reference_objet=" + sIdObjet;
			
		}

		sExtraParam += "&sIdObjet=" + sIdObjet ;
		
	} else {
		sIdObjet = "";
	}

	SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");

	String sSqlQueryPart = 
		 "\n FROM evenement evt, type_evenement typ "
		+ "\n WHERE evt.id_type_evenement=typ.id_type_evenement " 
		+ " AND evt.date_creation_evenement"
		+ " BETWEEN '" + formatDate.format(calDate.getTime()) + " 00:00:00'"
		+ " AND '" + formatDate.format(calDateFin.getTime()) + " 23:59:59'"
		+ sConstraint 
		+ " ORDER BY evt.date_creation_evenement ASC";

	
	String sSqlQuery = "SELECT COUNT(*) " + sSqlQueryPart;
	
	// C'est pour éviter les FLONNERIES !
	int iCount =org.coin.db.ConnectionManager.getCountInt(sSqlQuery) ;
	if( iCount > 1000)
	{
		throw new Exception("Trop d'évémenent à afficher : " + iCount );
	}

	Evenement item = new Evenement();
	sSqlQuery = "SELECT " + item.getSelectFieldsName("evt.") + ", evt.id_evenement " + sSqlQueryPart;

	Vector<Evenement> vEvenementsAAfficher = Evenement.getAllWithSqlQueryStatic(sSqlQuery);
	
%>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript">
function goToCalendar(iYear,iMonth, iDay )
{
	var sUrl = "<%= response.encodeURL("afficherTousEvenementsParMois.jsp?") %>iDay=" + iDay + "&iMonth=" + iMonth + "&iYear=" + iYear;
	Redirect( sUrl + "<%= sExtraParam %>");
} 

function goToCalendarAll(iYear,iMonth, iDay )
{
	var sUrl = "<%= response.encodeURL("afficherTousEvenementsParMois.jsp?") %>iDay=" + iDay + "&iMonth=" + iMonth + "&iYear=" + iYear;
	Redirect( sUrl );
} 

function goToCalendarTypeObjet(iYear,iMonth, iDay , iTypeObjet)
{
	var sUrl = "<%= response.encodeURL("afficherTousEvenementsParMois.jsp?") %>iDay=" + iDay + "&iMonth=" + iMonth + "&iYear=" + iYear;
	Redirect( sUrl + "&sType=" + iTypeObjet);
} 

</script>
</head>
<body>
<div class="titre_page"><%= sTitle %><br />
	<a href="javascript:goToCalendarAll(<%= annee %>,<%= mois %>,<%=jour%>)">
		<font color="#ff8c00"><strong>Tout</strong></font>
	</a>
	<a href="javascript:goToCalendarTypeObjet(<%= annee %>,<%= mois %>,<%=jour%>,<%= ObjectType.AFFAIRE %>)">
		<font color="#ff8c00"><strong> - Marchés</strong></font>
	</a>
	<a href="javascript:goToCalendarTypeObjet(<%= annee %>,<%= mois %>,<%=jour%>,<%= ObjectType.ORGANISATION %>)">
		<font color="#ff8c00"><strong> - Organisations</strong></font>
	</a>
	<a href="javascript:goToCalendarTypeObjet(<%= annee %>,<%= mois %>,<%=jour%>,<%= ObjectType.PERSONNE_PHYSIQUE %>)">
		<font color="#ff8c00"><strong> - Personnes Physiques</strong></font>
	</a>

</div>


<table border="0" cellspacing="0" cellpadding="0"> 
    <tr bgcolor="#2361AA"> 
      <td> 
<%
	int iMoisPrecedent;
	int iAnneePrecedente;
	if(mois == 12){
		iAnneePrecedente = annee - 1;
		iMoisPrecedent= 12;
	} else 	{
		iAnneePrecedente = annee ;
		iMoisPrecedent = mois - 1;
	}
%>
			<a href="javascript:goToCalendar(<%= iAnneePrecedente%>,<%= iMoisPrecedent %>,<%=jour%>)"><font color="#ff8c00"><strong>&lt;&lt;</strong></font></a>
		</td>
		<td>
		<div style="text-align:center">
        	<select name="mois" style="min-width:100px;max-width:100px;width:100px;">
<%
		for(int i=0;i<sMois.length;i++){
			String sSelected = "";
			
			if(mois == i+1 ) {
				sSelected = "selected='selected'";
			}
%>				
				<option value="<%=i+1%>" <%= sSelected %> ><%=sMois[i]%></option>		
<%			
		}
%>        
        	</select>
       		<select name="annee" style="min-width:100px;max-width:100px;width:100px;">
<%
		for(int i=1999;i<2030;i++)
		{
			String sSelected = "";
			if(annee == i) {
				sSelected = "selected='selected'";
			}
%>
					<option value="<%=i%>" <%= sSelected %> ><%=i%></option>
<%
		}
%>					
        	</select> 
		</div>
		</td>
		<td>
		<div align="right">
<%
	int iMoisSuivant ;
	int iAnneeSuivante ;
	if(mois == 12){
		iAnneeSuivante = annee + 1;
		iMoisSuivant  = 1;
	} else 	{
		iAnneeSuivante = annee ;
		iMoisSuivant  = mois + 1;
	}
%>
		<a href="javascript:goToCalendar(<%=iAnneeSuivante %>,<%= iMoisSuivant %>,<%=jour%>)"><font color="#ff8c00"><strong>&gt;&gt;</strong></font></a>
		</div>
		</td>
	</tr>
</table>



<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des événements </td>
	</tr>
	<tr>	
		<td>
		<table align="center" border="2">
			<tr bgcolor="#EEEEEE" align="center"> 
		      <td style="width:50px"><strong>Lu</strong></td>
		      <td style="width:50px"><strong>Ma</strong></td>
		      <td style="width:50px"><strong>Me</strong></td>
		      <td style="width:50px"><strong>Je</strong></td>
		      <td style="width:50px"><strong>Ve</strong></td>
		      <td style="width:50px"><strong>Sa</strong></td>
			  <td style="width:50px"><strong>Di</strong></td>
		    </tr>
			<tr align="center">
<%
	for(int i = 1; i < iPremierJour ; i++)
	{
%>
			<td>&nbsp;</td>
<%
	}
	int j = iPremierJour;
	for(int i=1 ; i <= iNbJoursDuMois ;i++)
	{
	%>
			<td style="vertical-align:top;">
        		<div align="right" ><%=i%></div>
				<div align="left"><br/>
<%
			int k=0 ;
			for(; k < vEvenementsAAfficher.size() ;k++)
			{
				Evenement evt = vEvenementsAAfficher.get(k);
				String sEvt = "" ;
				Calendar calTempDateDebut = Calendar.getInstance();
				calTempDateDebut.setTimeInMillis(evt.getDateDebutEvenement().getTime());
				
				if ( i == calTempDateDebut.get(Calendar.DAY_OF_MONTH)) 
				{
					try {
						sEvt = 
						"<b><a href=\"javascript:OuvrirPopup('" 
							+ response.encodeURL( 
								rootPath + "desk/journal/afficherEvenement.jsp?iIdEvenement=" 
								+ evt.getIdEvenement()) + "',600,450,'menubar=no,scrollbars=yes,statusbar=no')\" >"
						+ calTempDateDebut.get(Calendar.HOUR_OF_DAY) + ":"
						+ calTempDateDebut.get(Calendar.MINUTE) + "</a></b>";
					} catch (Exception e) {}
				
					try {
						Calendar calTempDateFin = Calendar.getInstance();
						calTempDateFin.setTimeInMillis(evt.getDateFinEvenement().getTime());
								
						sEvt += 
						" à <b>" + calTempDateFin.get(Calendar.HOUR_OF_DAY) + ":"
						+ calTempDateFin.get(Calendar.MINUTE) + "</b>";
					} catch (Exception e) {}
				
					try {
						sEvt += 
						 " " + TypeEvenement.getTypeEvenementMemory(evt.getIdTypeEvenement()).getLibelle() 
						+ " " + evt.getCommentaireLibre();
					} catch (Exception e) {}
					%><%= sEvt %>
					<br/>
				<%		
				}
			} 
			for(; k <= 7 ;k++)
			{
			%>
			<br/>
			<%	
			} 
			%>
        		</div>
			</td>
	<%
		if(j == 7)
		{
			if(i < iNbJoursDuMois)
			{
	%>
		</tr>
		<tr align="center">
	<%
				j = 1;
			}
	 	}else
	 	{
	  		j++;
	 	}
	}

	// FLON : je ne comprend pas pourquoi cela marche avec ce truc ...
	int delta = 0;
	if(iPremierJour == 5) delta= 1;
	
	for(int i=j+delta ;i<=7;i++)
	{ 
	%>
			<td align="center">&nbsp;</td>
	<%
	}
	%>
</table>
		</td>
	</tr>
</table>
<%@ include file="../include/footerDesk.jspf"%>
</body>
</html>