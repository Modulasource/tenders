<%@ include file="/include/new_style/headerDesk.jspf" %>
</head>
<body>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Contr�le de l�galit�";
	
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<div style="padding:15px">

<table border=0 class='normal' cellpadding=1 cellspacing=0>
<form action='formulaire_iXBus.asp?Note=12&enviado=1' method='post'>
	<tr>
		<td colspan=2><b>R�f�rent</b></td>
		</tr>
	<tr>
		<td>Nom:</td>
		<td><input name='nom' type='text' size=36 class='normal' value="PrenomNomConnect"></td>
	</tr>
	<tr>
		<td>T�l�phone:</td>
		<td><input name='tel' type='text' size=36 class='normal'></td>
	</tr>
	<tr>
		<td>Adresse mail:</td>
		<td><input name='mail1' type='text' size=36 class='normal' value="utiemail"></td>";
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=2><b>Adresses mails de retour</b></td>
	</tr>
	<tr>
		<td>Mail:</td><td><input name='mail2' type='text' size=36 value="utiemail"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=2><b>D�tail de l'acte</b></td>
	</tr>
	<tr>
		<td>Date de d�cision:</td>
		<td><input name='datede' type='text' size=36 value="vfecha"></td>
	</tr>
	<tr>
		<td>Num�ro de l'acte:</td>
		<td><input name='refe' type='text' size=36 value="noenreg"></td>
	</tr>
		<tr>
			<td>Nature de l'acte:</td>
		<td>
	
			<select size="1" name='Nature_de_la_acte' >
			<option value="1">D�lib�rations</option>
			<option value="2">Arr�t�s r�glementaires</option>
			<option value="3">Arr�t�s individuels</option>
			<option value="4">Contrats et conventions</option>
			<option value="5">Documents budg�taires et financiers</option>
			<option value="6">Autres</option>
			</select>
					
		</td>
	</tr>
	<tr>
		<td>Objet:</td>
		<td><textarea name='objet' cols=39 rows=2 >" + objet + "</textarea></td>
	</tr>
	<tr>
		<td>Date de classification:</td>
		<td><input name='datecla' type='text' size=36  value="vfecha"></td>
	</tr>

	
	<tr>
		<td>Mati�re de l'acte:</td>
		<td>
				
			<select size=1 name='Matiere_de_la_acte' >
			<option value='1.0'>1 Commande Publique</option>
			<option value='1.1'>1.1 March�s Publics</option>
			<option value='1.2'>1.2 D�l�gations de service public</option>
			<option value='1.3'>1.3 Conventions de mandat</option>
			<option value='1.4'>1.4 Autres types de contrats</option>
			<option value='1.5'>1.5 Transactions (protocole d'accord transactionnel)</option>
			<option value='1.6'>1.6 Ma�trise d'oeuvre</option>
			<option value='1.7'>1.7 Actes sp�ciaux et divers</option>
			<option value='2.0'>2 Urbanisme</option>
			<option value='2.1'>2.1 Documents d'urbanisme</option>
			<option value='2.2'>2.2 Actes relatifs au droit d'occupation ou d'utilisation des sols</option>
			<option value='2.3'>2.3 Droit de pr�emption urbain</option>
			<option value='3.0'>3.0 Domaine et Patrimoine</option>
			<option value='3.1'>3.1 Acquisitions</option>
			<option value='3.2'>3.2 Ali�nations</option>
			<option value='3.3'>3.3 Locations</option>
			<option value='3.4'>3.4 Limites territoriales</option>
			<option value='3.5'>3.5 Actes de gestion du domaine public</option>
			<option value='3.6'>3.6 Autres actes de gestion du domaine priv�</option>
			<option value='4.0'>4.0 Fonction publique</option>
			<option value='4.1'>4.1 Personnels titulaires et stagiaires de la F.P.T.</option>
			<option value='4.2'>4.2 Personneles contractuels</option>
			<option value='4.3'>4.3 Fonction publique hospitali�re</option>
			<option value='4.4'>4.4 Autres cat�gories de personnels</option>
			<option value='4.5'>4.5 R�gime indemnitaire</option>
			<option value='5.0'>5.0 Intitutions et vie politique</option>
			<option value='5.1'>5.1 Election des ex�cutifs</option>
			<option value='5.2'>5.2 Fonctionnement des assembl�es</option>
			<option value='5.3'>5.3 D�signation des repr�sentants</option>
			<option value='5.4'>5.4 D�l�gation de fonctions</option>
			<option value='5.5'>5.5 D�l�gations de signature</option>
			<option value='5.6'>5.6 Exercice des mandats locaux</option>
			<option value='5.7'>5.7 Intercommunalit�</option>
			<option value='6.0'>6.0 Libert�s publiques et pouvoirs de justice</option>
			<option value='6.1'>6.1 Police municipale</option>
			<option value='6.2'>6.2 Pouvoirs du pr�sident du conseil g�n�ral</option>
			<option value='6.3'>6.3 Pouvoirs du pr�sident du conseil r�gional</option>
			<option value='6.4'>6.4 autres actes r�glementaires</option>
			<option value='6.5'>6.5 Actes pris au nom de l'etat</option>
			<option value='7.0'>7.0 finances locales</option>
			<option value='7.1'>7.1 D�cisions budg�taires (B.P., D.M., C.A....)</option>
			<option value='7.2'>7.2 Fiscalit�</option>
			<option value='7.3'>7.3 Emprunts</option>
			<option value='7.4'>7.4 Interventions �conomiques</option>
			<option value='7.5'>7.5 Subventions</option>
			<option value='7.6'>7.6 Contributions budg�taires</option>
			<option value='7.7'>7.7 Avances</option>
			<option value='7.8'>7.8 Fonds de concours</option>
			<option value='7.9'>7.9 Prise de participation (SEM, etc.)</option>
			<option value='7.10'>7.10 Divers</option>
			<option value='8.0'>8.0 Domaines de comp�tences par th�mes</option>
			<option value='8.1'>8.1 Enseignement</option>
			<option value='8.2'>8.2 Aide sociale</option>
			<option value='8.3'>8.3 Voirie</option>
			<option value='8.4'>8.4 Am�nagement du territoire</option>
			<option value='8.5'>8.5 Politique de la ville</option>
			<option value='8.6'>8.6 Emploi, formation professionnelle</option>
			<option value='8.7'>8.7 Transports</option>
			<option value='8.8'>8.8 Environnement</option>
			<option value='8.9'>8.9 Culture</option>
			<option value='9.0'>9.0 Autres domaines de comp�tences</option>
			<option value='9.1'>9.1 Autres domaines de comp�tence des communes</option>
			<option value='9.2'>9.2 Autres domaines de comp�tence des d�partements</option>
			<option value='9.3'>9.3 Autres domaines de comp�tence des r�gions</option>
			<option value='9.4'>9.4 Voeux et motions</option>
			</select>
		</td>
	</tr>
	
	<tr>
		<td>Acte pr�c�dent:</td>
		<td><input name='actepre' type='text' size="36" ></td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align='right'><input type='submit' value='Envoyer' name='Envoyer' ></td>
	</tr>

</form>
</table>


</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.User"%>

<%@page import="modula.marche.Marche"%></html>
