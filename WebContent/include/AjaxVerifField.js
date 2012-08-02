function verifierChamp(champ,champAuth,div,iFieldServlet,sExtraParams,appli) {
	try
	{
		// Recuperation de la valeur du champ
		clearTimeout($(champ).lastKeyUpTimeId);
	    $(champ).lastKeyUpTimeId = setTimeout(function() {
			var rs = document.getElementById(champ).value;
			var obj = new Object();
			obj.iField = iFieldServlet;
			obj.sValue = rs;
			obj.application = appli;
			if(isNotNull(sExtraParams)){
				sExtraParams.each(function(param){
					//alert("obj."+param.data+"="+param.value);
					eval("obj."+param.data+"="+param.value);
				});
			}
			mt.config.disableAutoLoading();
			CheckAjaxVerifField.doAjaxStaticWithoutSessionUser(Object.toJSON(obj),function(reponse){
				if (reponse == "exist")
				{
					montrer(div);
					document.getElementById(champAuth).value = 0;
				}
				else
				{
					cacher(div);
					document.getElementById(champAuth).value = 1;
				}
				clearTimeout($(champ).lastKeyUpTimeId);
			});
	    }, 1000);
	} 
	catch (e){alert(e);}
}

/**
exemple d'utilisation 

///Dans le js///

//mail gerant
var champMailGerantAuth = "sEmailAuth";
var champMailGerant = "sEmail";
var divMailGerant = "tr_infoEmail";
function verifierMailGerant() 
{
	if(document.getElementById(champMailGerant).value != '<%= personne.getEmail() %>')
	{
		verifierChamp(champMailGerant,champMailGerantAuth,divMailGerant,<%= org.coin.servlet.CheckAjaxVerifField.PERSONNE_PHYSIQUE_EMAIL %>,"<%= rootPath %>","<%= session.getId() %>");
	}
}

///Dans le HTML///

<tr id="tr_infoEmail" style="display: none; visibility: hidden;">
	<td class="pave_cellule_gauche">&nbsp;</td>
	<td class="pave_cellule_droite">
		<div class="rouge" style="text-align:left">
		Attention, l'adresse Email saisie ci-dessous est d?j? enregistr?e dans la base de donn?es.
		Il est possible que vous soyez d?j? inscrit.
		</div>
	</td>
</tr>
<tr>
	<td class="pave_cellule_gauche">Email :</td>
	<td class="pave_cellule_droite">
	<input type="text" id="sEmail" name="sEmail" size="40" maxlength="40"
	value="<%= candidat.getEmail()  %>"
	onBlur="verifierMailGerant();" onKeyUp="verifierMailGerant();" />
	<input type="hidden" name="sEmailAuth" id="sEmailAuth" value="" />
	</td>
</tr>
*/