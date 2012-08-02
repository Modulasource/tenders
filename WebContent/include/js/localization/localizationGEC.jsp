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
		notSelectedItems	: "<%= locScriptTitle.getValue (49, "Liste des éléments non sélectionnés") %>",
		selectedItems		: "<%= locScriptTitle.getValue (50, "Liste des éléments sélectionnés")%>",
		noItem				: "<%= locScriptTitle.getValue (51, "Aucun élément")%>",
		noTitle				: "<%= locScriptTitle.getValue (52, "Sans titre")%>",
		empty				: "<%= locScriptTitle.getValue (53, "vide")%>",
		loading				: "<%= locScriptTitle.getValue (54, "loading...")%>",
		allCategories		: "<%= locScriptTitle.getValue (55, "Toutes les catégories")%>"
	},
	"message" : {
		noSelectedItem		: "<%= locScriptMessage.getValue (32, "Aucun élément n'est sélectionné")%>",
		selectItems			: "<%= locScriptMessage.getValue (33, "Sélectionnez un ou plusieurs éléments")%>",
		selectCategories	: "<%= locScriptMessage.getValue (34, "Sélectionnez une ou plusieurs catégories")%>"		
	}
};
</script>
<%
}
%>