<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*" %>
<%@ page import="org.coin.bean.*,modula.marche.*" %>
<%@ page import="modula.graphic.*" %>
<%@page import="org.coin.mail.Courrier"%>
<%@page import="org.coin.util.HttpUtil"%>
<%

// WARNING : Même usecase que "Afficher les événements"
	String sPageUseCaseId = "IHM-DESK-AFF-45";
	String sTitle = "Afficher les emails"; 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	Marche marche = Marche.getMarche(HttpUtil.parseInt("lId", request) );

	
	Vector<Courrier> vCourrier = Courrier.getAllFromTypeAndReferenceObjet(ObjectType.AFFAIRE, marche.getId());
	
%>
 
<script type="text/javascript">

function displayBodyEmail(id)
{
    var sText = $('sMessageText_' + id).value;
    var sHTML = $('sMessageHTML_' + id).value;
    var sSubject = $('sSubject_' + id).value;

    openModalBodyEmail(null, sSubject, sHTML, sText);
}


function openModalBodyEmail(obj, sTitle, sHTML, sText){
    var modal, div ;
    
    try{div = createModalBodyEmail(obj,parent.document,sTitle, sHTML, sText);}
    catch(e){div = createModalBodyEmail(obj,document, sTitle, sHTML, sText);}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
    modal.open();
}

function createModalBodyEmail(obj, doc, sTitle, sHTML , sText){
    
    var modal_princ = doc.createElement("div");
    
    var divControls = doc.createElement("div");
    divControls.className = "modal_controls";
        
    var divTitle = doc.createElement("div");
    divTitle.className = "modal_title";
    divTitle.innerHTML = sTitle;
    
    
    var img = doc.createElement("img");
    img.style.position = "absolute";
    img.style.top = "3px";
    img.style.right = "3px";
    img.style.cursor = "pointer";
    img.src = "<%= rootPath %>images/icons/close.gif";
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
    divContent.style.height = "350px";
    divContent.style.overflow = "auto";
    divContent.innerHTML = sHTML;
    divFrame.appendChild(divContent);


    var divContentText = doc.createElement("div");
    divContentText.className = "modal_frame_content";
    divContentText.style.height = "100px";
    divContentText.style.overflow = "auto";
    divContentText.innerHTML = sText;
    divFrame.appendChild(divContentText);
    
    var divOptions = doc.createElement("div");
    divOptions.className = "modal_options";

    
    modal_princ.appendChild(divControls);
    modal_princ.appendChild(divFrame);
    modal_princ.appendChild(divOptions);
    modal_princ.style.width="800px";
    
    return modal_princ;
}
</script>

</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>

<%

	if(sessionUserHabilitation.isSuperUser())
	{
%>

<button onclick="doUrl('<%=
	response.encodeURL(rootPath + "desk/marche/algorithme/creation/aatr/sendEmailCreerPublicationAttr.jsp"
			+ "?lId=" + marche.getId()) %>');">Relancer publication AATR (test)</button>
<%
	}
%>

<br />
<i><%= vCourrier.size() %> emails envoyés</i>
<br />
			<table class="liste" >
				<tr>
					<th >Date d'envoi</th>
                    <th >De</th>
                    <th >A </th>
                    <th >Objet</th>
					<th >&nbsp;</th>
				</tr>
				<% 
				for (int i=0; i < vCourrier.size(); i++)
				{
					Courrier item = vCourrier.get(i);
					int	j = i % 2;
					
                    item.getDateEnvoiEffectif();
                    item.getDateEnvoiPrevu();
                    item.getDateStockage();
					
					%>

				<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 onclick="displayBodyEmail(<%= item.getId() %>);"> 
					<td style="width:15%" ><%= CalendarUtil.getDateFormattee(item.getDateEnvoiEffectif() ) %></td>
<!-- 				
                   	<td style="width:10%" ><%= item.getDateEnvoiPrevu() %></td>
					<td style="width:10%" ><%= item.getDateStockage() %></td>
 -->
                    <td style="width:10%" ><%= item.getFrom() %></td>
                    <td style="width:10%" ><%= item.getTo() %></td>
                    <td style="width:40%" ><%= item.getSubject() %></td>
					<td style="width:3%" >
                <textarea id="sSubject_<%= item.getId() 
                    %>" style="display:none"><%= item.getSubject()  %></textarea>
                <textarea id="sMessageHTML_<%= item.getId() 
                    %>" style="display:none"><%= item.getMessageHTML()  %></textarea>
                <textarea id="sMessageText_<%= item.getId() 
                    %>" style="display:none"><%= Outils.replaceNltoBr(
                            "Date : " +  CalendarUtil.getDateFormattee(item.getDateEnvoiEffectif() ) + "\n"
                            + "De : " + item.getFrom() + "\n"
                            + "A : " + item.getTo() + "\n\n"
                            + item.getMessage())  %></textarea>
<%
				if(!item.isSend())
				{
%>
                        <img src="<%=rootPath + Icone.ICONE_WARNING %>" alt="Pas encore envoyé" title="Pas encore envoyé" />
<%
				}
%>
						<img src="<%=rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>"  />
					</td>
				</tr>
					<%		
				}
				%>
			</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.util.Outils"%></html>