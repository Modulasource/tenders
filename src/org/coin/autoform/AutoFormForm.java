package org.coin.autoform;

import java.util.Vector;

import org.coin.autoform.component.AutoFormComponent;
import org.coin.autoform.field.AutoFormField;
import org.coin.autoform.field.AutoFormInputButton;
import org.coin.autoform.field.AutoFormInputHidden;
import org.coin.autoform.field.AutoFormInputSubmit;

public class AutoFormForm extends AutoFormObject {
	/* TODO
	 * En fait peut être qu'il faudrait déclarer un field "Form" et puis faire un composant
	 * de ce Form de sorte à séparer les couches "Field" et "Component" car dans cette classe
	 * tout est mélangé et finalement ça restreint les possibilités d'affichage.
	 * 
	 * En même temps, c'est un cas particulier, car c'est un field qui contient d'autres fields,
	 * contrairement aux fields classiques.
	 */
	protected String sAction;
	protected String sMethod;
	protected String sEncType;
	protected String sAccept;
	protected String sOnSubmit;
	protected String sOnReset;
	protected String sAcceptCharset;
	
	protected boolean bShowButtons;
	
	protected Vector<AutoFormComponent> vComponent;
	protected Vector<AutoFormField> vField;
	protected Vector<AutoFormInputHidden> vHidden;
	protected AutoFormInputSubmit afButtonValidation;
	protected Vector<AutoFormInputButton> vFooterButton;
	
	/*
	 * Constructeur
	 */
	/**
	 * @param sMethod : get|post (post par défaut)
	 * @param sName : le nom (et automatiquement l'id) du formulaire
	 * @param sAction : l'url
	 */
	public AutoFormForm(String sMethod, String sName, String sAction) {
		init();
		this.sName = this.sId = sName;
		if (sMethod.equalsIgnoreCase("get") || sMethod.equalsIgnoreCase("post")){
			this.sMethod = sMethod.toLowerCase();
		}else{
			this.sMethod = "post";
		}		
		this.sAction = sAction;
		this.afButtonValidation = new AutoFormInputSubmit("but_"+sName, "but_"+sName, "Enregistrer");
	}
	public void init(){
		super.init();
		this.sAction = "";
		this.sMethod = "";
		this.sEncType = "";
		this.sAccept = "";
		this.sOnSubmit = "";
		this.sOnReset = "";
		this.sAcceptCharset = "";
		this.vComponent = new Vector<AutoFormComponent>();
		this.vField = new Vector<AutoFormField>();
		this.vHidden = new Vector<AutoFormInputHidden>();
		this.afButtonValidation = new AutoFormInputSubmit();
		this.vFooterButton = new Vector<AutoFormInputButton>();
		this.bShowButtons = true;
	}
	
	/*
	 * Setter
	 */
	public void setAction(String sAction){
		this.sAction = sAction;
	}
	public void setMethod(String sMethod){
		this.sMethod = sMethod;
	}
	/**
	 * @param sEncType : normalement application/x-www-form-urlencoded ou multipart/form-data
	 */
	public void setEncType(String sEncType){
		this.sEncType = sEncType;
	}
	/**
	 * Met le enctype par défaut : application/x-www-form-urlencoded
	 */
	public void setEncTypeDefault(){
		this.setEncType("application/x-www-form-urlencoded");
	}
	/**
	 * Met le enctype à : multipart/form-data
	 */
	public void setEncTypeMultipart(){
		this.setEncType("multipart/form-data");
	}
	public void setAccept(String sAccept){
		this.sAccept = sAccept;
	}
	public void setOnSubmit(String sOnSubmit){
		this.sOnSubmit = sOnSubmit;
	}
	public void setOnReset(String sOnReset){
		this.sOnReset = sOnReset;
	}
	public void setAcceptCharset(String sAcceptCharset) {
		this.sAcceptCharset = sAcceptCharset;
	}
	public void setComponent(Vector<AutoFormComponent> component) {
		vComponent = component;
	}
	public void addComponent(AutoFormComponent afComponent){
		this.vComponent.add(afComponent);
	}
	public void addHidden(AutoFormInputHidden afHidden){
		this.vHidden.add(afHidden);
	}
	public void addHidden(String sName, String sValue){
		this.vHidden.add(new AutoFormInputHidden(sName, sName, sValue));
	}
	public void addHidden(String sName, int iValue){
		this.addHidden(sName, Integer.toString(iValue));
	}
	public void setField(Vector<AutoFormField> vfield) {
		this.vField = vfield;
	}
	public void addField(AutoFormField afField){
		this.vField.add(afField);
	}
	/**
	 * Ajoute un bouton à côté du bouton "enregistrer" en bas du formulaire
	 * @param sId : l'id du bouton et aussi son nom
	 * @param sValue : la valeur du bouton
	 * @param sActionOnClick : l'action onclick associé à ce bouton
	 */
	public void addFooterButton(String sId, String sValue, String sActionOnClick){
		addFooterButton(sId, sId, sValue, sActionOnClick);	
	}
	/**
	 * Ajoute un bouton à côté du bouton "enregistrer" en bas du formulaire
	 * @param sId : l'id du bouton
	 * @param sName : le nom du bouton
	 * @param sValue : la valeur du bouton
	 * @param sActionOnClick : l'action onclick associé à ce bouton
	 */
	public void addFooterButton(String sId, String sName, String sValue, String sActionOnClick){
		AutoFormInputButton afButton = new AutoFormInputButton(sId, sName, sValue);
		afButton.setOnClick(sActionOnClick);
		this.vFooterButton.add(afButton);		
	}
	/**
	 * Précise s'il faut afficher ou pas les boutons valider (et retour ?) du formulaire
	 * @param bShowButtons
	 */
	public void setShowButtons(boolean bShowButtons){
		this.bShowButtons = bShowButtons;
	}
	/*
	 * Getter
	 */
	public String getAction(){
		return this.sAction;
	}
	public String getMethod(){
		return this.sMethod;
	}
	public String getEncType(){
		return this.sEncType;
	}
	public String getAccept(){
		return this.sAccept;
	}
	public String getOnSubmit(){
		return this.sOnSubmit;
	}
	public String getOnReset(){
		return this.sOnReset;
	}
	public String getAcceptCharset(){
		return this.sAcceptCharset;
	}
	public Vector<AutoFormComponent> getComponent() {
		return vComponent;
	}
	public Vector<AutoFormField> getField() {
		return this.vField;
	}
	public Vector<AutoFormInputButton> getFooterButton(){
		return this.vFooterButton;
	}
	public boolean isShowButtons(){
		return this.bShowButtons;
	}
	
	public String getJavascriptControlCode(){
		String sHTML = "";
		for (int i=0;i<this.vComponent.size();i++){
			sHTML += this.vComponent.get(i).getJavascriptControlCode();
		}
		return sHTML;
	}
	
	public String getHTML(){
		String sHTML = "<form "; 
		sHTML += super.getCommonAttributesForHTML();
		
		if (!this.getAction().equals("")) sHTML += "action=\""+this.getAction()+"\" ";
		if (!this.getMethod().equals("")) sHTML += "method=\""+this.getMethod()+"\" ";
		if (!this.getEncType().equals("")) sHTML += "enctype=\""+this.getEncType()+"\" ";
		if (!this.getAccept().equals("")) sHTML += "accept=\""+this.getAccept()+"\" ";
		if (!this.getOnSubmit().equals("")) sHTML += "onsubmit=\""+this.getOnSubmit()+"\" ";
		if (!this.getOnReset().equals("")) sHTML += "onreset=\""+this.getOnReset()+"\" ";
		if (!this.getAcceptCharset().equals("")) sHTML += "accept-charset=\""+this.getAcceptCharset()+"\" ";
		
		sHTML += ">"+NL;
		for (int i=0;i<this.vField.size();i++){
			sHTML += this.vField.get(i).getHTML()+NL;
		}
		for (int i=0;i<this.vComponent.size();i++){
			sHTML += "<br />"+this.vComponent.get(i).getHTML()+NL;
		}
		for (int i=0;i<this.vHidden.size();i++){
			sHTML += "<br />"+this.vHidden.get(i).getHTML()+NL;
		}
		if (this.isShowButtons() || this.getFooterButton().size()>0){
			sHTML += "<div id=\"fiche_footer\">"+NL;
			for (int i=0;i<this.getFooterButton().size();i++){
				sHTML += this.getFooterButton().get(i).getHTML();
			}
			if (this.isShowButtons()) sHTML += this.afButtonValidation.getHTML()+NL;
			sHTML += "</div>"+NL;
		}
		sHTML += "</form>"+NL;
		return sHTML;
	}
}
