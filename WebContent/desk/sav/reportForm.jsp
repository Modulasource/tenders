<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.conf.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Report de bug"; 
	String sPageUseCaseId = "IHM-DESK-BUG-1";
	PersonnePhysique pp = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sApplication = Configuration.getConfigurationValueMemory("modula.application.name");
	String sVersion = Configuration.getConfigurationValueMemory("modula.version");
	String sDB = Configuration.getConfigurationValueMemory("modula.db.version");
	String sTo = Configuration.getConfigurationValueMemory("mail.to.defaut");
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%=rootPath%>include/js/prototype.js?v=<%= JavascriptVersion.PROTOTYPE_JS %>"></script>
<script type="text/javascript">
function changeSelectValue(select_name){
	var select = $(select_name);
	if(select.value=="Autre")
		$(select.id+"_compl_div").style.display="block";
	else
		$(select.id+"_compl_div").style.display="none";
}
</script>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" action="<%= response.encodeURL("report.jsp" ) %>" method='post' >
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Contexte</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Reporter :</td>
			<td class="pave_cellule_droite">
			<%= pp.getName() %>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Application :</td>
			<td class="pave_cellule_droite"><%= sApplication %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Version :</td>
			<td class="pave_cellule_droite"><%= sVersion %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">DB Version :</td>
			<td class="pave_cellule_droite"><%= sDB %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Plateforme :</td>
			<td class="pave_cellule_droite">
				<select id="plateforme" name="plateforme" onchange="changeSelectValue('plateforme')">
					<option value="PC" selected="selected">PC</option>
					<option value="Mac" >Mac</option>
					<option value="Sun" >Sun</option>
					<option value="Autre" >Autre</option>
				</select>
				<div id="plateforme_compl_div" style="display:none"><input type="text" id="plateforme_compl" name="plateforme_compl" size="50" /></div>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">OS :</td>
			<td class="pave_cellule_droite">
				<select id="os" name="os" onchange="changeSelectValue('os')">
			      <option value="Windows 3.1">Windows 3.1      </option>
			      <option value="Windows 95">Windows 95      </option>
			      <option value="Windows 98">Windows 98      </option>
			      <option value="Windows ME">Windows ME      </option>
			      <option value="Windows 2000">Windows 2000      </option>
			      <option value="Windows NT">Windows NT      </option>
			      <option value="Windows XP" selected="selected">Windows XP      </option>
			      <option value="Windows Server 2003">Windows Server 2003      </option>
			      <option value="Mac System 7">Mac System 7      </option>
			      <option value="Mac System 7.5">Mac System 7.5      </option>
			      <option value="Mac System 7.6.1">Mac System 7.6.1      </option>
			      <option value="Mac System 8.0">Mac System 8.0      </option>
			      <option value="Mac System 8.5">Mac System 8.5      </option>
			      <option value="Mac System 8.6">Mac System 8.6      </option>
			      <option value="Mac System 9.x">Mac System 9.x      </option>
			      <option value="Mac OS X 10.0">Mac OS X 10.0      </option>
			      <option value="Mac OS X 10.1">Mac OS X 10.1      </option>
			      <option value="Mac OS X 10.2">Mac OS X 10.2      </option>
			      <option value="Mac OS X 10.3">Mac OS X 10.3      </option>
			      <option value="Linux">Linux      </option>
			      <option value="BSD/OS">BSD/OS      </option>
			      <option value="FreeBSD">FreeBSD      </option>
			      <option value="NetBSD">NetBSD      </option>
			      <option value="OpenBSD">OpenBSD      </option>
			      <option value="AIX">AIX      </option>
			      <option value="BeOS">BeOS      </option>
			      <option value="HP-UX">HP-UX      </option>
			      <option value="IRIX">IRIX      </option>
			      <option value="Neutrino">Neutrino      </option>
			      <option value="OpenVMS">OpenVMS      </option>
			      <option value="OS/2">OS/2      </option>
			      <option value="OSF/1">OSF/1      </option>
			      <option value="Solaris">Solaris      </option>
			      <option value="SunOS">SunOS      </option>
			      <option value="Autre">Autre      </option>
				</select>
				<div id="os_compl_div" style="display:none"><input type="text" id="os_compl" name="os_compl" size="50" /></div>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Navigateur :</td>
			<td class="pave_cellule_droite">
				<select id="navigateur" name="navigateur" onchange="changeSelectValue('navigateur')">
				  <option value="Amaya">Amaya</option>
				  <option value="AWeb">AWeb </option>
				  <option value="Dillo">Dillo </option>
				  <option value="Espial Escape ">Espial Escape </option>
				  <option value="HotJava">HotJava</option>
				  <option value="IBrowse">IBrowse </option>
				  <option value="iCab">iCab</option>
				  <option value="Internet Explorer" selected="selected">Internet Explorer</option>
				  <option value="Kidz CD">Kidz CD </option>
				  <option value="Konqueror">Konqueror</option>
				  <option value="AOL Explorer">AOL Explorer </option>
				  <option value="Avant Browser">Avant Browser</option>
				  <option value="Crazybrowser">Crazybrowser </option>
				  <option value="Maxthon">Maxthon</option>
				  <option value="NetCaptor">NetCaptor </option>
				  <option value="Slim Browser">Slim Browser</option>
				  <option value="Abrowse">Abrowse </option>
				  <option value="Safari">Safari</option>
				  <option value="Shiira">Shiira</option>
				  <option value="SunriseBrowser">SunriseBrowser </option>
				  <option value="DeskBrowse">DeskBrowse</option>
				  <option value="OmniWeb">OmniWeb </option>
				  <option value="Mozilla">Mozilla</option>
				  <option value="Aphrodite">Aphrodite</option>
				  <option value="Beonex">Beonex </option>
				  <option value="Camino">Camino</option>
				  <option value="Epiphany">Epiphany </option>
				  <option value="Galeon">Galeon</option>
				  <option value="IBM Web Browser">IBM Web Browser </option>
				  <option value="K-Meleon">K-Meleon</option>
				  <option value="Mozilla Firefox">Mozilla Firefox </option>
				  <option value="Netscape">Netscape</option>
				  <option value="uBrowser">uBrowser </option>
				  <option value="Seamonkey">Seamonkey</option>
				  <option value="NetPositive">NetPositive</option>
				  <option value="Netscape Navigator">Netscape Navigator </option>
				  <option value="Netscape Communicator">Netscape Communicator</option>
				  <option value="Opera">Opera</option>
				</select>
				<div id="navigateur_compl_div" style="display:none"><input type="text" id="navigateur_compl" name="navigateur_compl" size="50" /></div>
			</td>
		</tr>
	</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Erreur</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Priorité :</td>
			<td class="pave_cellule_droite">
				<select id="priorite" name="priorite">
					<option value="P1" >P1</option>
					<option value="P2" selected="selected">P2</option>
					<option value="P3" >P3</option>
					<option value="P4" >P4</option>
					<option value="P5" >P5</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Sévérité :</td>
			<td class="pave_cellule_droite">
				<select id="severite" name="severite">
					<option value="Bloquant" >Bloquant</option>
					<option value="Critique" >Critique</option>
					<option value="Majeur" >Majeur</option>
					<option value="Normal" selected="selected">Normal</option>
					<option value="Mineur" >Mineur</option>
					<option value="Trivial" >Trivial</option>
					<option value="Evol" >Evol</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Composant :</td>
			<td class="pave_cellule_droite">
				<select id="composant" name="composant" onchange="changeSelectValue('composant')">
					<option value="Dématerialisation" >Dématerialisation</option>
					<option value="Carnet d'adresse" >Carnet d'adresse</option>
					<option value="Paramètrage" >Paramètrage</option>
					<option value="Administration" >Administration</option>
					<option value="Autre" >Autre</option>
				</select>
				<div id="composant_compl_div" style="display:none"><input type="text" id="composant_compl" name="composant_compl" size="50" /></div>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Page :</td>
			<td class="pave_cellule_droite">
				<input type="text" id="page" name="page" size="100" />
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Résumé :</td>
			<td class="pave_cellule_droite">
				<input type="text" id="resume" name="resume" size="100" />
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Description :</td>
			<td class="pave_cellule_droite">
				<textarea rows="5" cols="100" id="description" name="description"></textarea>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Assigné à :</td>
			<td class="pave_cellule_droite"><%= sTo %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Ajouter CC :</td>
			<td class="pave_cellule_droite">
				<input type="text" id="cc" name="cc" size="100"/>
				<div id="cc_compl_div" class="mention">Vous pouvez ajouter plusieurs cc en les séparant par des ";"</div>
			</td>
		</tr>
		<tr><td class="pave_cellule_gauche" colspan="2">* Champs obligatoires</td></tr>
	</table>
	<br />
	<input type="submit" value="Envoyer" />
<%@ include file="../include/footerDesk.jspf"%>
</form>
</body>
</html>
