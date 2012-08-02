package org.coin.autoform;

import java.util.Vector;

import org.coin.autoform.component.AutoFormComponent;

public class AutoFormTab extends AutoFormObject {
/**
 * TODO
 * Cet élément n'est pas développé !!!
 */
	protected Vector<AutoFormComponent> vComponent;

	
	/*
	 * Constructeur
	 */

	public AutoFormTab() {
		init();
	}
	public void init(){
		super.init();
		this.vComponent = new Vector<AutoFormComponent>();
	}
	
	/*
	 * Setter
	 */
	public void setComponent(Vector<AutoFormComponent> component) {
		vComponent = component;
	}
	public void addComponent(AutoFormComponent afComponent){
		this.vComponent.add(afComponent);
	}
	/*
	 * Getter
	 */

	public Vector<AutoFormComponent> getComponent() {
		return vComponent;
	}
	
	
	public String getJavascriptControlCode(){
		String sHTML = "";
		for (int i=0;i<this.vComponent.size();i++){
			sHTML += this.vComponent.get(i).getJavascriptControlCode();
		}
		return sHTML;
	}
	
	public String getHTML(){
		String sHTML = "<table "; 
		sHTML += super.getCommonAttributesForHTML();
		

		sHTML += ">"+NL;
		for (int i=0;i<this.vComponent.size();i++){
			sHTML += this.vComponent.get(i).getHTML()+"<br />"+NL;
		}
		sHTML += "</table>"+NL;
		return sHTML;
	}
}
