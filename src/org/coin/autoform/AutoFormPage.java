package org.coin.autoform;

import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import modula.graphic.BarBouton;
import modula.graphic.Theme;

import org.coin.bean.conf.*;
import org.coin.db.CoinDatabaseLoadException;

/**
 * TODO
 * Remonter le sDebugMode dans cette page (car il n'est qu'appeler en paramètre pour le moment)
 * @author François
 *
 */
public class AutoFormPage extends AutoFormObject{
	protected String sRootPath;
	protected String sDebugMode;
	protected String sTitle;
	protected Vector<AutoFormForm> vForm;
	protected Vector<BarBouton> vBarBoutons;
	protected String sFreeJavascriptCode;
	protected Vector<String> vJavascriptInclude;
	protected Vector<String> vCSSInclude;
	
	public AutoFormPage() {
		init();
	}
	/**
	 * @param sRootPath : Le rootPath (request.getContextPath()+"/")
	 * @param sTitle : Le titre de la page
	 */
	public AutoFormPage(String sRootPath, String sTitle){
		init();
		this.sRootPath = sRootPath;
		this.sTitle = sTitle;
		this.addJavascriptInclude(this.getRootPath()+"include/popup.js");
		this.addJavascriptInclude(this.getRootPath()+"include/redirection.js");
		this.addJavascriptInclude(this.getRootPath()+"include/verification.js");
		this.addJavascriptInclude(this.getRootPath()+"include/fonctions.js");
		this.addCSSInclude(this.getRootPath()+"include/css/"+Theme.getDeskCSS()+".css");
	}
	public void init(){
		super.init();
		this.sRootPath = "";
		this.sDebugMode = "disabled";
		this.sTitle = "";
		this.vForm = new Vector<AutoFormForm>();
		this.vBarBoutons = new Vector<BarBouton>();
		this.sFreeJavascriptCode = "";
		this.vJavascriptInclude = new Vector<String>();
		this.vCSSInclude = new Vector<String>();
	}
	
	/*
	 * Setter
	 */
	public void setRootPath(String sRootPath){
		this.sRootPath = sRootPath;
	}
	public void setTitle(String sTitle){
		this.sTitle = sTitle;
	}
	public void addForm(AutoFormForm afForm){
		this.vForm.add(afForm);
	}
	public void setForm(Vector<AutoFormForm> vForm){
		this.vForm = vForm;
	}
	public void setBarBoutons(Vector<BarBouton> vBarBouton){
		this.vBarBoutons = vBarBouton; 
	}
	public void setFreeJavascriptCode(String sJS){
		this.sFreeJavascriptCode = sJS;
	}
	/**
	 * Ajoute un fichier JS en inclusion
	 * @param sJSFile
	 */
	public void addJavascriptInclude(String sJSFile){
		this.vJavascriptInclude.add(sJSFile);
	}
	/**
	 * Ajoute un fichier CSS en inclusion
	 * @param sCSSFile
	 */
	public void addCSSInclude(String sCSSFile){
		this.vCSSInclude.add(sCSSFile);
	}
	
	/**
	 * TODO
	 * Ajouter une méthode plus complète pour addBoutonToBar
	 */
	/**
	 * Ajoute un bouton à la barre
	 * @param sLabel : Le libellé
	 * @param sTargetURL : Le lien
	 * @param sPathImage : L'image
	 */
	public void addBoutonToBar(String sLabel, String sTargetURL, String sPathImage){
		this.vBarBoutons.add( 
				new BarBouton(this.getBarBouton().size(),
					sLabel,
					sTargetURL,
					sPathImage, 
					"this.src='"+sPathImage+"'",
					"this.src='"+sPathImage+"'",
					"",
					true) );
	}
	
	/*
	 * Getter
	 */
	public String getRootPath(){
		return this.sRootPath;
	}
	public String getTitle(){
		return this.sTitle;
	}
	public Vector<AutoFormForm> getForm(){
		return this.vForm;
	}
	public Vector<BarBouton> getBarBouton(){
		return this.vBarBoutons;
	}
	public Vector<String> getJavascriptInclude(){
		return this.vJavascriptInclude;
	}
	public Vector<String> getCSSInclude(){
		return this.vCSSInclude;
	}
	/**
	 * Retourne le code HTML associé aux fichiers JS à inclure
	 * ex : <script type=\"text/javascript\" src=\"popup.js\"></script>
	 * @return
	 */
	public String getJavascriptIncludeCode(){
		String sJS = "";
		for (int i=0;i<this.vJavascriptInclude.size();i++){
			sJS += "<script type=\"text/javascript\" "
				+ "src=\""+this.vJavascriptInclude.get(i)+"\"></script>"+NL;
		}
		return sJS;
	}
	/**
	 * Retourne le code HTML associé aux fichiers CSS à inclure
	 * @return
	 */
	public String getCSSIncludeCode(){
		String sCode = "";
		for (int i=0;i<this.vCSSInclude.size();i++){
			sCode += "<link rel=\"stylesheet\" type=\"text/css\" " +
					"href=\""+this.vCSSInclude.get(i)+"\" media=\"screen\" />"+NL;
		}
		return sCode;
	}
	public String getFreeJavascriptCode(){
		return this.sFreeJavascriptCode;
	}
	public String getHeaderDesk(){
		String sHTML = "";
		sHTML += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"" +
				"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">" + NL +
				"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"fr\" lang=\"fr\">" + NL +
				"<head>" + NL +
				"<meta http-equiv=\"Expires\" content=\"-1\" />" + NL +
				"<meta http-equiv=\"Cache-Control\" content=\"no-cache, must-revalidate\" />" + NL +
				"<meta http-equiv=\"Pragma\" content=\"no-cache\" />" + NL +
				"<title>"+this.getTitle()+"</title>" + NL +
				this.getCSSIncludeCode()+ NL +
				"<link rel=\"SHORTCUT ICON\" href=\""+this.getRootPath()+"include/modula.ico\" />" + NL +
				"<script type=\"text/javascript\">"+NL+
				"var debugMode = \""+this.sDebugMode+"\";"+NL+	
				"</script>"+NL+
				this.getJavascriptIncludeCode()+
				this.getJavascriptControlCode()+NL+
				"</head>" + NL +
				"<body>" + NL +
				"<div class=\"titre_page\">"+this.getTitle()+"</div>"+NL;
		
		if (this.getBarBouton().size()>0){
			sHTML += "	<table class=\"menu\" cellspacing=\"2\" summary=\"menu\">"+NL;
			sHTML += "		<tr>"+NL;
			for (int i=0;i<this.vBarBoutons.size();i++){
				if (this.vBarBoutons.get(i).bVisible){
					sHTML += "			"+this.vBarBoutons.get(i).getHtmlDesk()+NL;
				}
			}
			sHTML += "			<td>&nbsp;</td>"+NL;
			sHTML += "		</tr>"+NL;
			sHTML += "	</table>"+NL;
		}
		
		sHTML += "<div class=\"mention\">* : Champs obligatoires </div>"+NL+
				"<br />"+NL+
				"<a name=\"ancreError\" />"+NL+
				"<div class=\"rouge\" style=\"text-align:left\" id=\"divError\"></div>";

		return sHTML;
	}
	public String getFooterDesk() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		String sHTML = "";
		sHTML += "<br /><br /><br />"+NL+
				"<div class=\"footer\">"+NL+
				
				".: <span class=\"orange\">Version : v"+
				Configuration.getConfigurationValueMemory("modula.version")+
				"</span>"+NL+
				
				"&nbsp;-&nbsp;"+NL+
				"<span class=\"orange\">DB Version : v"+
				Configuration.getConfigurationValueMemory("modula.db.version")+
				"</span>"+NL+
				"&nbsp;-&nbsp;"+NL+
				"<a href=\"http://www.matamore.com\" target=\"_blank\">"+
				"Copyright Matamore Software"+
				"</a>"+NL+
				"&copy; - <a href=\"#\">Mentions légales</a>"+NL+
				"- <a href=\"#ancreHP\">Haut de page</a> :."+NL+
				"</div>"+NL;
		return sHTML;
	}
	
	public String getJavascriptControlCode(){
		String sHTML = "<script type=\"text/javascript\">"+NL;
		for (int i=0;i<this.vForm.size();i++){
			sHTML += "function checkAndValidate_"+this.vForm.get(i).getId()+"(){"+NL;
			sHTML += "	closeAllAlerts();"+NL;
			sHTML += "	var bResult = true;"+NL;
			sHTML += "	"+this.vForm.get(i).getJavascriptControlCode();
			sHTML += "	return bResult;"+NL;
			sHTML += "}"+NL;
			
			this.vForm.get(i).setOnSubmit("return checkAndValidate_"+this.vForm.get(i).getId()+"()");
		}
		sHTML += this.getFreeJavascriptCode()+NL;
		sHTML += "</script>"+NL;
		return sHTML;
	}
	
	public String getHTML() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		String sHTML = this.getHeaderDesk(); 
		for (int i=0;i<this.vForm.size();i++){
			sHTML += this.vForm.get(i).getHTML()+NL;
		}
		sHTML += this.getFooterDesk()+NL;
		sHTML += "</body>"+NL+"</html>"+NL;
		return sHTML;
	}
}
