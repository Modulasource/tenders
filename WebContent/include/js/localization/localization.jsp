<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.localization.Language"%>

<%@page import="org.coin.localization.LocalizeButton"%><script>
<%
{
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {}
	
	Localize locScript = null;
	try{
		locScript = new Localize(Long.parseLong( request.getParameter("iIdLang")),
				LocalizationConstant.CAPTION_CATEGORY_SCRIPT_LOCALIZATION);
	}catch(Exception e){
		locScript = new Localize();
	}
		
//String[] sTabLocScript = locScript.getArrayValue();
//if(sTabLocScript.length>=1){
	//for(int i=1;i<sTabLocScript.length;i++){
		//>MESSAGE_RUNJS[<%= i >] = "<%= sTabLocScript[i] >";<%
		//i++;
	//}
//}
%>
var MESSAGE_RUNJS_FormFieldsValidation = [];
MESSAGE_RUNJS_FormFieldsValidation[1]= "<%= locScript.getValue(1,"Ne doit pas être vide")%>";
MESSAGE_RUNJS_FormFieldsValidation[2]= "<%= locScript.getValue(2,"L'adresse email n'est pas valide")%>";
MESSAGE_RUNJS_FormFieldsValidation[3]="<%= locScript.getValue(3,"Ne doit contenir que des chiffres")%>";
MESSAGE_RUNJS_FormFieldsValidation[4]="<%= locScript.getValue(4,"Ne doit contenir que des lettres")%>";
MESSAGE_RUNJS_FormFieldsValidation[5]="<%= locScript.getValue(5,"Ne doit contenir que des caractères alphanumériques")%>";
MESSAGE_RUNJS_FormFieldsValidation[6]="<%= locScript.getValue(6,"La date n'est pas valide")%>";
MESSAGE_RUNJS_FormFieldsValidation[7]="<%= locScript.getValue(7,"Ce champ doit contenir au moins %1 caractères")%>";
MESSAGE_RUNJS_FormFieldsValidation[8]="<%= locScript.getValue(8,"Cet onglet comporte des champs non valides")%>";
MESSAGE_RUNJS_FormFieldsValidation[9]="<%= locScript.getValue(9,"Ne doit contenir que des prix")%>";
MESSAGE_RUNJS_FormFieldsValidation[10]="<%= locScript.getValue(10,"Ce champ doit contenir au plus %1 caractères")%>";
MESSAGE_RUNJS_FormFieldsValidation[11]="<%= locScript.getValue(11,"L'heure n'est pas au format hh:mm")%>";

var MESSAGE_TV = [];
MESSAGE_TV[1] = "<%= locScript.getValue(12,"Ouvrir dans un nouvel onglet")%>";
MESSAGE_TV[2] = "<%= locScript.getValue(13,"Ouvrir dans la même fenêtre")%>";

var MESSAGE_AJCL = [];
MESSAGE_AJCL[1] = "<%= locScript.getValue(14,"Effacer")%>";
MESSAGE_AJCL[2] = "<%= locScript.getValue(15,"Aucun résultat n'a été trouvé")%>";
MESSAGE_AJCL[3] = "<%= locScript.getValue(16,"résultat")%>";
MESSAGE_AJCL[4] = "<%= locScript.getValue(17,"Patientez SVP...")%>";
MESSAGE_AJCL[5] = "<%= locScript.getValue(18,"Chargement...")%>";
MESSAGE_AJCL[6] = "<%= locScript.getValue(19,"Selectionner")%>";
MESSAGE_AJCL[7] = "<%= locScript.getValue(20,"veuillez saisir votre recherche ici (3 car. min)")%>";

var MESSAGE_TV_ADMIN = [];
MESSAGE_TV_ADMIN[1] = "<%= locScript.getValue(21,"Choix")%>";
MESSAGE_TV_ADMIN[2] = "<%= locScript.getValue(22,"Ajouter un fils")%>";
MESSAGE_TV_ADMIN[3] = "<%= locScript.getValue(23,"Afficher les informations")%>";
MESSAGE_TV_ADMIN[4] = "<%= locScript.getValue(24,"Ajouter un frère")%>";
MESSAGE_TV_ADMIN[5] = "<%= locScript.getValue(25,"Supprimer le noeud")%>";
MESSAGE_TV_ADMIN[6] = "<%= locScript.getValue(26,"Décaler le noeud vers le haut")%>";
MESSAGE_TV_ADMIN[7] = "<%= locScript.getValue(27,"Décaler le noeud vers le bas")%>";
MESSAGE_TV_ADMIN[8] = "<%= locScript.getValue(28,"Décaler le noeud vers la gauche")%>";
MESSAGE_TV_ADMIN[9] = "<%= locScript.getValue(29,"Décaler le noeud vers la droite")%>";
MESSAGE_TV_ADMIN[10] = "<%= locScript.getValue(30,"Do you want to delete this ComponentType ?")%>";

var MESSAGE_TAB = [];
MESSAGE_TAB[1] = "<%= locScript.getValue(31,"Accueil")%>";

var MESSAGE_AJAX_SEARCH = [];
MESSAGE_AJAX_SEARCH[1] = "<%= locScript.getValue(32,"Ouvrir dans un nouvel onglet")%>";
MESSAGE_AJAX_SEARCH[2] = "<%= locScript.getValue(33,"précédente")%>";
MESSAGE_AJAX_SEARCH[3] = "<%= locScript.getValue(34,"suivante")%>";
MESSAGE_AJAX_SEARCH[4] = "<%= locScript.getValue(35,"limite de recherche")%>";
MESSAGE_AJAX_SEARCH[5] = "<%= locScript.getValue(36,"Limiter les résultats")%>";
MESSAGE_AJAX_SEARCH[6] = "<%= locScript.getValue(37,"Limite")%>";
MESSAGE_AJAX_SEARCH[7] = "<%= locScript.getValue(38,"Nombre de résultats par page")%>";
MESSAGE_AJAX_SEARCH[8] = "<%= locScript.getValue(39,"fonctions avancées")%>";
MESSAGE_AJAX_SEARCH[9] = "<%= locScript.getValue(40,"Aucun%1")%>";
MESSAGE_AJAX_SEARCH[10] = "<%= locScript.getValue(41,"%1 correspondant%2 à votre recherche")%>";
MESSAGE_AJAX_SEARCH[11] = "<%= locScript.getValue(42,"Aucun")%>";
MESSAGE_AJAX_SEARCH[12] = "<%= locScript.getValue(43,"Page")%>";
MESSAGE_AJAX_SEARCH[13] = "<%= locScript.getValue(44,"Tous")%>";
MESSAGE_AJAX_SEARCH[14] = "<%= localizeButton.getValueSelect("Select") %>";
MESSAGE_AJAX_SEARCH[15] = "<%= locScript.getValue(77,"supprimer le tri")%>";
MESSAGE_AJAX_SEARCH[16] = "<%= localizeButton.getValue(41,"Aucune") %>";
MESSAGE_AJAX_SEARCH[17] = "<%= localizeButton.getValueNoneMale("Aucun") %>";
MESSAGE_AJAX_SEARCH[18] = "<%= locScript.getValue(79,"Ouvrir tout en onglet")%>";

var MESSAGE_CALENDAR_MONTH = ["<%= locScript.getValue(45,"Janvier")%>", "<%= locScript.getValue(46,"Février")%>","<%= locScript.getValue(47,"Mars")%>","<%= locScript.getValue(48,"Avril")%>","<%= locScript.getValue(49,"Mai")%>", "<%= locScript.getValue(50,"Juin")%>","<%= locScript.getValue(51,"Juillet")%>","<%= locScript.getValue(52,"Août")%>","<%= locScript.getValue(53,"Septembre")%>", "<%= locScript.getValue(54,"Octobre")%>","<%= locScript.getValue(55,"Novembre")%>","<%= locScript.getValue(56,"Décembre")%>"];

var MESSAGE_CALENDAR_DAY = ["<%= locScript.getValue(57,"D")%>","<%= locScript.getValue(58,"L")%>", "<%= locScript.getValue(59,"M")%>", "<%= locScript.getValue(60,"M")%>", "<%= locScript.getValue(61,"J")%>", "<%= locScript.getValue(62,"V")%>", "<%= locScript.getValue(63,"S")%>"]; 

var MESSAGE_CALENDAR_CLEAN = "<%= locScript.getValue(64,"effacer")%>"; 

var MESSAGE_BATCH = [];
MESSAGE_BATCH[1] = "<%= locScript.getValue(65,"Etes vous sur de vouloir lancer cette opération ?")%>";
MESSAGE_BATCH[2] = "<%= locScript.getValue(66,"Sélectionnez une action")%>";
MESSAGE_BATCH[3] = "<%= localizeButton.getValue(45,"Attention") %>";
MESSAGE_BATCH[4] = "<%= locScript.getValue(78,"Implementation Report")%>";

var MESSAGE_BUTTON = [];
MESSAGE_BUTTON[1] = "<%= locScript.getValue(67,"Ok")%>";
MESSAGE_BUTTON[2] = "<%= locScript.getValue(68,"Annuler")%>";
MESSAGE_BUTTON[3] = "<%= locScript.getValue(69,"Enregistrer")%>";
MESSAGE_BUTTON[4] = "<%= locScript.getValue(70,"Supprimer")%>";
MESSAGE_BUTTON[5] = "<%= locScript.getValue(71,"Ajouter")%>";
MESSAGE_BUTTON[6] = "<%= locScript.getValue(72,"Valider")%>";
MESSAGE_BUTTON[7] = "<%= localizeButton.getValue(37,"from") %>";
MESSAGE_BUTTON[8] = "<%= localizeButton.getValue(38,"to") %>";
MESSAGE_BUTTON[9] = "<%= localizeButton.getValue(80, "Page précédente")%>";
MESSAGE_BUTTON[10] = "<%= localizeButton.getValue(81, "Page suivante")%>";
MESSAGE_BUTTON[11] = "<%= localizeButton.getValue(27, "Nouveau")%>";
MESSAGE_BUTTON[12] = "<%= localizeButton.getValue(75, "Editer")%>";
MESSAGE_BUTTON[13] = "<%= locScript.getValue(14, "Effacer")%>";
MESSAGE_BUTTON[14] = "<%= localizeButton.getValue(82, "Restaurer")%>";

var MESSAGE_LAYER = [];
MESSAGE_LAYER[1] = "<%= locScript.getValue(73,"Choisir")%>";
MESSAGE_LAYER[2] = "<%= locScript.getValue(74,"voir les options")%>";

var MESSAGE_TITLE = [];
MESSAGE_TITLE[1] = "<%= locScript.getValue(75,"une erreur s'est produite")%>";
MESSAGE_TITLE[2] = "<%= locScript.getValue(76,"Attention, vous ne pouvez pas le supprimer")%>";
MESSAGE_TITLE[3] = "<%= locScript.getValue(2,"L'adresse email n'est pas valide")%>";
<%}%>
</script>