package org.coin.autoform;

public class AutoFormObject {
	public static String NL = "\n\r";
	public static boolean TRACE_QUERY = false;
	
	protected String sId;
	protected String sName;
	protected String sClassName;
	
	protected String sOnClick;
	protected String sOnDblClick;
	/*
	 *  onfocus, onblur, onselect, onchange, onclick, ondblclick, 
	 *  onmousedown, onmouseup, onmouseover, onmousemove, onmouseout, 
	 *  onkeypress, onkeydown, onkeyup (intrinsic events) 
	 */
	protected String sOnMouseDown;
	protected String sOnMouseUp;
	protected String sOnMouseOver;
	protected String sOnMouseMove;
	protected String sOnMouseOut;
	protected String sOnKeyUp;
	protected String sOtherJavascriptControl;
	
	
	/*
	 * Constructeur
	 */
	public AutoFormObject() {
		init();
	}
	public AutoFormObject(String sId, String sName) {
		init();
		this.sId = sId;
		this.sName = sName;
	}
	
	public void init() {
		this.sId = "";
		this.sName = "";
		this.sClassName = "";
		this.sOnClick = "";
		this.sOnDblClick = "";
		this.sOnMouseDown = "";
		this.sOnMouseUp = "";
		this.sOnMouseOver = "";
		this.sOnMouseMove = "";
		this.sOnMouseOut = "";
		this.sOnKeyUp = "";
		this.sOtherJavascriptControl = "";
	}
	
	/*
	 * Setter
	 */
	public void setId(String sId) {
		this.sId = sId;
	}
	public void setName(String sName) {
		this.sName = sName;
	}
	public void setClassName(String sClassName){
		this.sClassName = sClassName;
	}
	public void setOnClick(String sOnClick){
		this.sOnClick = sOnClick;
	}
	public void setOnDblClick(String sOnDblClick) {
		this.sOnDblClick = sOnDblClick;
	}
	public void setOnMouseDown(String sOnMouseDown) {
		this.sOnMouseDown = sOnMouseDown;
	}
	public void setOnMouseMove(String sOnMouseMove) {
		this.sOnMouseMove = sOnMouseMove;
	}
	public void setOnMouseOut(String sOnMouseOut) {
		this.sOnMouseOut = sOnMouseOut;
	}
	public void setOnMouseOver(String sOnMouseOver) {
		this.sOnMouseOver = sOnMouseOver;
	}
	public void setOnMouseUp(String sOnMouseUp) {
		this.sOnMouseUp = sOnMouseUp;
	}
	public void setOnKeyUp(String sOnKeyUp) {
		this.sOnKeyUp = sOnKeyUp;
	}
	/**
	 * Ajoute une clause libre dans la fonction checkAndValidate
	 * obtenue par getJavascriptControl
	 * @param sOtherJavascriptControl
	 */
	public void setOtherJavascriptControl(String sOtherJavascriptControl){
		this.sOtherJavascriptControl = sOtherJavascriptControl;
	}
	/*
	 * Getter
	 */
	public String getId() {
		return this.sId;
	}
	public String getName() {
		return this.sName;
	}
	public String getClassName(){
		return this.sClassName;
	}
	public String getOnClick(){
		return this.sOnClick;
	}
	public String getOnDblClick(){
		return this.sOnDblClick;
	}
	public String getOnMouseDown(){
		return this.sOnMouseDown;
	}
	public String getOnMouseUp(){
		return this.sOnMouseUp;
	}
	public String getOnMouseMove(){
		return this.sOnMouseMove;
	}
	public String getOnMouseOver(){
		return this.sOnMouseOver;
	}
	public String getOnMouseOut(){
		return this.sOnMouseOut;
	}
	public String getOnKeyUp(){
		return this.sOnKeyUp;
	}
	public String getOtherJavascriptControl(){
		return this.sOtherJavascriptControl;
	}
	/*
	 * Autres méthodes
	 */

	public String getCommonAttributesForHTML(){
		return getCommonAttributesForHTML(true);
	}
	public String getCommonAttributesForHTML(boolean bUseClass){
		String sHTML = "";
		if (!this.getName().equals("")) sHTML += "name=\""+this.getName()+"\" ";
		if (!this.getId().equals("")) sHTML += "id=\""+this.getId()+"\" ";
		if (!this.getClassName().equals("") && bUseClass) sHTML += "class=\""+this.getClassName()+"\" ";
		if (!this.getOnClick().equals("")) sHTML += "onclick=\""+this.getOnClick()+"\" ";
		if (!this.getOnDblClick().equals("")) sHTML += "ondblclick=\""+this.getOnDblClick()+"\" ";
		if (!this.getOnMouseDown().equals("")) sHTML += "onmousedown=\""+this.getOnMouseDown()+"\" ";
		if (!this.getOnMouseUp().equals("")) sHTML += "onmouseup=\""+this.getOnMouseUp()+"\" ";
		if (!this.getOnMouseOver().equals("")) sHTML += "onmouseover=\""+this.getOnMouseOver()+"\" ";
		if (!this.getOnMouseOut().equals("")) sHTML += "onmouseout=\""+this.getOnMouseOut()+"\" ";
		if (!this.getOnMouseMove().equals("")) sHTML += "onmousemove=\""+this.getOnMouseMove()+"\" ";
		if (!this.getOnKeyUp().equals("")) sHTML += "onkeyup=\""+this.getOnKeyUp()+"\" ";
		return sHTML;
	}
}
