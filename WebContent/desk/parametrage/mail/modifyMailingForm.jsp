<%@ include file="../../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Mail Type "; 
	String sFormPrefix = "";
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	String sPageUseCaseId = "IHM-DESK-xxx";
	String sAction = request.getParameter("sAction");
	
	sPageUseCaseId = "IHM-DESK-xxx";
	sTitle += ": <span class=\"altColor\">Nouveau Mailing</span>"; 

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	String sHtmlValue = "";
	try{
		Configuration conf = Configuration.getConfigurationMemory("server.mail.mailtype.html", false);
        sHtmlValue = conf.getDescription();
	} catch (Exception e){
		sHtmlValue = "Tapez ici votre mailing en HTML";
	}
	
	
	OrganisationType organisationType = new OrganisationType();
	
	
	
%>
<script type="text/javascript">
<!--




function displayHtmlModal(){
	openModal(null);
}

function openModal(obj){
	var modal, div;
	
	try{div = createModal(obj,parent.document);}
	catch(e){div = createModal(obj,document);}
	
	try {modal = new parent.Control.Modal(false,{contents: div});}
	catch(e) {modal = new Control.Modal(false,{contents: div});}
	
    modal.container.insert(div);
	modal.open();
}

function createModal(obj,doc){
	
	var modal_princ = doc.createElement("div");
	modal_princ.style.height = "350px";
	modal_princ.style.overflow = "auto";
	
	var divControls = doc.createElement("div");
	divControls.className = "modal_controls";
		
	var divTitle = doc.createElement("div");
	divTitle.className = "modal_title";
	divTitle.innerHTML = "HTML Généré";
	
	
	var img = doc.createElement("img");
	img.style.position = "absolute";
	img.style.top = "3px";
	img.style.right = "3px";
	img.style.cursor = "pointer";
	img.src = "/modula_test/images/icons/close.gif";
	img.onclick = function(){
		try {new parent.Control.Modal.close();}
		catch(e) { Control.Modal.close();}
	}
	
	
	divControls.appendChild(divTitle);
	divControls.appendChild(img);
	
	var divFrame = doc.createElement("div");
	divFrame.className = "modal_frame_principal";
	
	var divContent = doc.createElement("div");
	divContent.className = "modal_frame_content";
	
	var sHTML = $('sContenuHTML').value;
	
	divContent.innerHTML = sHTML;
	divFrame.appendChild(divContent);

	divContent.onclick = function(){
		try {new parent.Control.Modal.close();}
		catch(e) { Control.Modal.close();}
	}
	
	var divOptions = doc.createElement("div");
	divOptions.className = "modal_options";
		
	modal_princ.appendChild(divFrame);
	modal_princ.appendChild(divOptions);
	
	return modal_princ;
}

//-->
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
<form id="form" action="<%= response.encodeURL("modifyMailing.jsp") %>" >
<div class="rouge" style="text-align:left" id="divError"></div>
	<input type="hidden" name="sAction" value="<%= sAction %>" />
	<table class="formLayout fullWidth" cellspacing="3">
    <%= pave.getHtmlTrInput("Objet :", 
    		"sObjet", 
    		"Mailing du "+ CalendarUtil.getDateFormattee(new Timestamp(System.currentTimeMillis())) ,
    		"size=\"100\" maxlength=\"255\"") %>
	<tr>
		<td class="label">
			Carnet d'adresses sélectionné :
		</td>
		<td class="frame">
        <%= organisationType.getAllInHtmlInputRadio("lIdOrganisationType") %>
		</td>
	</tr>
	<tr>
		<td class="label">
			Corps :
		</td>
		<td class="frame">
			<textarea cols="100" rows="8" name="<%=sFormPrefix
			%>sContenu" >Text brut</textarea>
		</td>
	</tr>
	<tr>
		<td class="label">Corps HTML :</td>
		<td class="frame">
			<textarea style="width:100%" rows="30" id="sContenuHTML" name="<%=sFormPrefix 
			%>sContenuHTML" ><%= sHtmlValue %></textarea>
		</td>
	</tr>
	</table>
</div>
<div id="fiche_footer">
	<button type="submit" >Envoyer Mailing</button>
	<button type="button" onclick="javascript:displayHtmlModal()" >Afficher HTML</button>
</div>
</form>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.fr.bean.mail.MailType"%>
<%@page import="org.coin.fr.bean.OrganisationType"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.sql.Timestamp"%>
</html>
