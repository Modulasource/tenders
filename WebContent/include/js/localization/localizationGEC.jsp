<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.localization.Language"%>
<%
{
	Localize locScriptTitle;
	Localize locScriptMessage;
	Localize locScriptButton;
	
	try {
		long lIdLanguage = Long.parseLong (request.getParameter ("lIdLanguage"));
		
		locScriptTitle = new Localize (lIdLanguage, LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
		locScriptMessage = new Localize (lIdLanguage, LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);
		locScriptButton = new Localize (lIdLanguage, LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	} catch (Exception e){
		locScriptTitle = new Localize ();
		locScriptMessage = new Localize ();
		locScriptButton = new Localize ();
	}
%>
<script>
var captionScriptGEC = {
	"title" : {
		notSelectedItems	: "<%= locScriptTitle.getValue (49, "Liste des �l�ments non s�lectionn�s") %>",
		selectedItems		: "<%= locScriptTitle.getValue (50, "Liste des �l�ments s�lectionn�s")%>",
		noItem				: "<%= locScriptTitle.getValue (51, "Aucun �l�ment")%>",
		noTitle				: "<%= locScriptTitle.getValue (52, "Sans titre")%>",
		empty				: "<%= locScriptTitle.getValue (53, "vide")%>",
		loading				: "<%= locScriptTitle.getValue (54, "loading...")%>",
		allCategories		: "<%= locScriptTitle.getValue (55, "Toutes les cat�gories")%>"
	},
	"message" : {
		noSelectedItem		: "<%= locScriptMessage.getValue (32, "Aucun �l�ment n'est s�lectionn�")%>",
		selectItems			: "<%= locScriptMessage.getValue (33, "S�lectionnez un ou plusieurs �l�ments")%>",
		selectCategories	: "<%= locScriptMessage.getValue (34, "S�lectionnez une ou plusieurs cat�gories")%>"		
	}
};
</script>
<%
}
%>