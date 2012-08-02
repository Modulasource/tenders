<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.mail.*,org.coin.bean.*, org.json.*, org.coin.bean.html.*,java.util.*" %>
<% 
	String sTitle = "Mail Type "; 
	String sFormPrefix = "";
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	MailType item = null;
	String sPageUseCaseId = "IHM-DESK-PARAM-002";
	String sAction = request.getParameter("sAction");
	
	if(sAction.equals("create"))
	{
		sPageUseCaseId = "IHM-DESK-PARAM-002";
		item = new MailType();
		sTitle += ": <span class=\"altColor\">Nouveau Mail Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		sPageUseCaseId = "IHM-DESK-PARAM-002";
		item = MailType.getMailType(Integer.parseInt(request.getParameter("iIdMailType")));
		sTitle += item.getId() + " : " + "<span class=\"altColor\">"+ item.getLibelle()+"</span>"; 
	}
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
	Language lang = null;
	try{
		lang = Language.getLanguageMemory(item.getIdLanguage());
	} catch (Exception e){
		lang = new Language();
	}
	
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

function createModal(obj, doc){
	var modal_princ = doc.createElement("div");
	
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
	
	var sHTML = $('sContenuTypeHTML').value;
    var sPlainText = $('sContenuType').value;
	
	var reg1=new RegExp("__mailtype_body_plain_text__", "g");
    var reg2=new RegExp("\n", "g");
    
    sPlainText = sPlainText.replace(reg2,"<br/>\n");
 	sHTML = sHTML.replace(reg1,sPlainText);
	
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
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
<form id="form" action="<%= response.encodeURL("modifierMailType.jsp") %>" method="post" name="formulaire">
<div class="rouge" style="text-align:left" id="divError"></div>
	<input type="hidden" name="sAction" value="<%= sAction %>" />
	<input type="hidden" name="iIdMailType" value="<%= item.getId() %>" />
	<table class="formLayout fullWidth" cellspacing="3">
	<%= pave.getHtmlTrInput("Libelle :", sFormPrefix + "sLibelle", item.getLibelle(),"size=\"100\" maxlength=\"255\"") %>
	<%= pave.getHtmlTrInput("Objet :", sFormPrefix + "sObjetType", item.getObjetType(),"size=\"100\" maxlength=\"255\"") %>
	<%= pave.getHtmlTrInput("Reference :", sFormPrefix + "sReference", item.getReference(),"size=\"100\" maxlength=\"255\"") %>
	<tr>
		<td class="label">
			Langue :
		</td>
		<td class="frame">
			<%= lang.getAllInHtmlSelect(sFormPrefix + "lIdLanguage") %></textarea>
		</td>
	</tr>
	<tr>
		<td class="label">
			Corps :
		</td>
		<td class="frame">
			<textarea cols="100" rows="8" name="sContenuType" id="sContenuType"  ><%= item.getContenuType() %></textarea>
		</td>
	</tr>
	<tr>
		<td class="label">Corps HTML :</td>
		<td class="frame">
			<textarea style="width:100%" rows="16" id="sContenuTypeHTML" name="<%=sFormPrefix %>sContenuTypeHTML" ><%= item.getContenuTypeHTML() %></textarea>
		</td>
	</tr>
	</table>
</div>
<div id="fiche_footer">
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath+"desk/parametrage/mail/modifierMailType.jsp?sAction=remove&iIdMailType=" 
					+ item.getId() ) %>');" ><%= localizeButton.getValueDelete() %></button>
    <button type="button" onclick="javascript:displayHtmlModal()" ><%= localizeButton.getValueDisplay() %> HTML</button>
 	<%} %>
	<button type="button"  onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath+"desk/parametrage/mail/afficherTousMailType.jsp") %>');" ><%= localizeButton.getValueCancel() %></button>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.fr.bean.mail.MailType"%>
</html>
