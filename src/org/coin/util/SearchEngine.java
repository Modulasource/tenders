/*
 * Matamore Software 2009
 * 
**/
package org.coin.util;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import modula.graphic.Theme;

import org.coin.autoform.AutoFormSearchEngine;
import org.coin.autoform.component.AutoFormComponent;
import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectAttributeLocalization;
import org.coin.localization.Language;
import org.coin.security.PreventInjection;
import org.coin.servlet.filter.HabilitationFilterUtil;




public class SearchEngine {
	protected int iItemPerPage;
	protected int iMaxPage;
	protected int iElementCount;
	protected String sRequest;
	protected String sFilter;
	protected String sTri;
	protected String sOrder;
	protected Vector vResultats;
	protected Object oContext;
	protected Object oContextSup;
	
	public String sFieldNameTri;
	public String sFieldNameTriValue;
	public String sFieldNameTriDefault;
	public String sFieldNameOrderBy;
	public String sFieldNameOrderByValue;
	public String sFieldNameFiltre;
	public String sFieldNameFiltreType;
	public String sFieldNameCurrentPage;
	public String sFieldNameFiltreValue;
	public String sFieldNameFiltreTypeValue;
	public String sExtraParamHeaderUrl;

	public String sPaveHeaderLibelle;
	public String sPaveHeader0OccurenceLibelle;
	public String sPaveHeader1OccurenceLibelle;
	public String sPaveHeaderNOccurenceLibelle;

	public String sUrlTarget;
	public int iCurrentPage;
	public Vector<Object> vFields;
	public Connection conn;
	public Object itemSearch;
	
	public int MAX_SEARCH_ELEMENT_DEFAULT = 1000;
	
	/**  
	 * used to optimize search in table with a lot of records
	 */
	public boolean bCutSearchWithMaxElement;
	public int iCutSearchWithMaxElementSize;
	
	public boolean bUseCountQuery;
	
	protected static Map<String,String>[] s_sarrLocalizationLabel;
	protected int iAbstractBeanIdLanguage;
	protected int iAbstractBeanIdObjectType;

	public static String LABEL_LIST = "LABEL_LIST";
	public static String LABEL_SEARCH = "LABEL_SEARCH";
	public static String LABEL_CONTAINS = "LABEL_CONTAINS";
	public static String LABEL_PREV = "LABEL_PREV";
	public static String LABEL_NEXT = "LABEL_NEXT";
	public static String LABEL_SEARCH_BUT = "LABEL_SEARCH_BUT";
	public static String LABEL_ADVANCED_SEARCH_BUT = "LABEL_ADVANCED_SEARCH_BUT";
	public static String LABEL_PAGINATE_BETWEEN = "LABEL_PAGINATE_BETWEEN";
	public static String LABEL_UNDEFINED = "LABEL_UNDEFINED";
	public static String LABEL_DISPLAY = "LABEL_DISPLAY";
	public static String LABEL_PAGE = "LABEL_PAGE";
	
	public void setExtraParamHeaderUrl(String sExtraParamHeaderUrl )
	{
		this.sExtraParamHeaderUrl = sExtraParamHeaderUrl ;
	}

	public String getExtraParamHeaderUrl()
	{
		return this.sExtraParamHeaderUrl ;
	}
	
	public int getElementCount() {
		return iElementCount;
	}
	
	
	public void setParam(String sUrlTarget , String sFieldNameTriDefault)
	{
		setParam("tri", sFieldNameTriDefault, "filtre", "filtreType", "numPage", "orderby", sUrlTarget);
	}		
	public void setParam(
			String sFieldNameTri,
			String sFieldNameTriDefault,
			String sFieldNameFiltre,
			String sFieldNameFiltreType,
			String sFieldNameCurrentPage,
			String sFieldNameOrderBy,
			String sUrlTarget){
		
		this.sFieldNameTri = sFieldNameTri  ;
		this.sFieldNameTriDefault = sFieldNameTriDefault  ;
		this.sFieldNameFiltre = sFieldNameFiltre ;
		this.sFieldNameFiltreType = sFieldNameFiltreType;
		this.sFieldNameCurrentPage = sFieldNameCurrentPage;
		this.sFieldNameOrderBy = sFieldNameOrderBy ;
		this.sExtraParamHeaderUrl = "";
		this.sUrlTarget = sUrlTarget;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.sFieldNameTriValue = request.getParameter(sFormPrefix + this.sFieldNameTri) ;
		if (this.sFieldNameTriValue  == null)
			this.sFieldNameTriValue = this.sFieldNameTriDefault; 
				
		
		this.sFieldNameOrderByValue = request.getParameter(sFormPrefix + this.sFieldNameOrderBy) ;
		if (this.sFieldNameOrderByValue  == null)
			this.sFieldNameOrderByValue = ""; 
		
		setTri(this.sFieldNameTriValue + " " + this.sFieldNameOrderByValue );
		
		this.sFieldNameFiltreValue = request.getParameter(sFormPrefix + this.sFieldNameFiltre) ;
		this.sFieldNameFiltreTypeValue = request.getParameter(sFormPrefix + this.sFieldNameFiltreType) ;
		if (this.sFieldNameFiltreValue == null) 
		{
			this.sFieldNameFiltreValue = "";
		}
		if (this.sFieldNameFiltreTypeValue  == null) 
		{
			this.sFieldNameFiltreTypeValue  ="";
		}

		// BUG 167
		String sTemp = this.sFieldNameFiltreValue ;
		this.sFieldNameFiltreValue = Outils.replaceAll(this.sFieldNameFiltreValue, "'", "''");
		
		if ((!this.sFieldNameFiltreValue .equalsIgnoreCase(""))
			&&(!this.sFieldNameFiltreTypeValue.equalsIgnoreCase(""))){
			String[] sSplitFilter = this.sFieldNameFiltreValue .split(" ");
			String filter = "";
			for (int i = 0; i < sSplitFilter.length; i++) {
				String splitFilter = sSplitFilter[i];
				filter += " AND " + this.sFieldNameFiltreTypeValue 
						+ " LIKE '%" + splitFilter +"%' ";
				
			}
			setFilterClause(filter);
		}
		
		this.sFieldNameFiltreValue = sTemp;
		setFromFormPagination(request, sFormPrefix);
	}

	
	//TODO:security
	public void setFromFormPrevent(HttpServletRequest servlerRequest, String sFormPrefix)
	{
		HashMap<String,String> request = PreventInjection.preventStoreRequest(servlerRequest);
		this.sFieldNameTriValue = request.get(sFormPrefix + this.sFieldNameTri) ;
		if (this.sFieldNameTriValue  == null)
			this.sFieldNameTriValue = this.sFieldNameTriDefault; 
				
		
		this.sFieldNameOrderByValue = request.get(sFormPrefix + this.sFieldNameOrderBy) ;
		if (this.sFieldNameOrderByValue  == null)
			this.sFieldNameOrderByValue = ""; 
		
		setTri(this.sFieldNameTriValue + " " + this.sFieldNameOrderByValue );
		
		this.sFieldNameFiltreValue = request.get(sFormPrefix + this.sFieldNameFiltre) ;
		this.sFieldNameFiltreTypeValue = request.get(sFormPrefix + this.sFieldNameFiltreType) ;
		if (this.sFieldNameFiltreValue == null) 
		{
			this.sFieldNameFiltreValue = "";
		}
		if (this.sFieldNameFiltreTypeValue  == null) 
		{
			this.sFieldNameFiltreTypeValue  ="";
		}
		if ((!this.sFieldNameFiltreValue .equalsIgnoreCase(""))
			&&(!this.sFieldNameFiltreTypeValue.equalsIgnoreCase(""))){
			String[] sSplitFilter = this.sFieldNameFiltreValue .split(" ");
			String filter = "";
			for (int i = 0; i < sSplitFilter.length; i++) {
				String splitFilter = sSplitFilter[i];
				filter += " AND "+ this.sFieldNameFiltreTypeValue 
						+ " LIKE '%" + Outils.addLikeSlashes(splitFilter) +"%' ";
				
			}
			setFilterClause(filter);
		}
		
		setFromFormPagination(servlerRequest, sFormPrefix);
		try{setFromFormAdvancedFunction(servlerRequest, sFormPrefix);}
		catch(Exception e){}
	}
	
	
	public void setFromFormAdvancedFunction(HttpServletRequest request, String sFormPrefix)
	{
		String sVar = "";
		sVar = request.getParameter(AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_COUNT);
		if (!Outils.isNullOrBlank(sVar))
			this.iCutSearchWithMaxElementSize = Integer.parseInt(sVar);
		
		sVar = request.getParameter(AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_PER_PAGE);
		if (!Outils.isNullOrBlank(sVar))
			this.iItemPerPage = Integer.parseInt(sVar);
		
		sVar = request.getParameter(AutoFormSearchEngine.PARAM_NAME_USE_CUT_COUNT);
		if (!Outils.isNullOrBlank(sVar))
			this.bCutSearchWithMaxElement=Boolean.valueOf(sVar);
	}
	
	
	//TODO:security
	public void preventFromForm()
	{
		this.sFieldNameFiltreValue = PreventInjection.preventLoad(this.sFieldNameFiltreValue);
		this.sFieldNameFiltreTypeValue = PreventInjection.preventLoad(this.sFieldNameFiltreTypeValue) ;
	}

	public void setFromFormPagination(HttpServletRequest request, String sFormPrefix)
	{
		
		this.iCurrentPage = 1;
		try{
			this.iCurrentPage = Integer.parseInt(sFormPrefix + request.getParameter(this.sFieldNameCurrentPage));
		} catch (Exception e) {
		}

		this.bUseCountQuery = ((request.getParameter("bUseCountQuery") != null) 
				&& request.getParameter("bUseCountQuery").equalsIgnoreCase("on"));
		
		/*this is mandatory */
	//	if(!this.bUseCountQuery) this.bCutSearchWithMaxElement = true;
		
		if(request.getParameter("iCutSearchWithMaxElementSize") != null)
			this.iCutSearchWithMaxElementSize = Integer.parseInt(request.getParameter("iCutSearchWithMaxElementSize"));
	}
	
	public void addFieldName(String sFieldName, String sFieldLibelle, int iFieldType)
	{
		SearchEngineArrayHeaderItem item = new SearchEngineArrayHeaderItem (sFieldName, sFieldLibelle, iFieldType);
		
		this.vFields.add(item);
	}

	public String getComboFields()
	{
		String sHtmlCombo = "<select name='" + this.sFieldNameFiltreType + "'>";
		for (int i = 0; i < this.vFields.size(); i++) {
			SearchEngineArrayHeaderItem item = (SearchEngineArrayHeaderItem) this.vFields.get(i);
			String sSelected = "";
			if(this.sFieldNameFiltreTypeValue.equalsIgnoreCase( item.sFieldName ))
			{
				sSelected = " selected='selected' ";
			}
			switch (item.iFieldType) {
			case SearchEngineArrayHeaderItem.FIELD_TYPE_STRING:
				sHtmlCombo += "<option value='" + item.sFieldName + "'" + sSelected + " >" + item.sFieldLibelle + "</option>\n"; 
				break;
			default:
				break;
			}
		}
		
		sHtmlCombo += "</select>\n";
	
		return sHtmlCombo;
	}

	public String getHeaderFieldsNewStyle(HttpServletResponse response, String sRootPath)
	{
		return getHeaderFieldsNewStyle(response, sRootPath, "&nbsp;");
	}
	
	
	public String getAdvancedFunction(HttpSession session) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		int iLanguage = (int)((Language)session.getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE)).getId();
		
		String sHTML = "";
		HashMap<String, Object> mapAdvancedFunction = AutoFormSearchEngine.getAdvancedFunction(this.bCutSearchWithMaxElement, this.iCutSearchWithMaxElementSize, this.iItemPerPage, this.sRequest,iLanguage);
		Vector<AutoFormComponent> vCpt = (Vector<AutoFormComponent>)mapAdvancedFunction.get("autoformComponents");
		
		for(AutoFormComponent cpt : vCpt){
			sHTML+=cpt.getHTML();
		}
		
		String sAddJavascript = (String)mapAdvancedFunction.get("javascriptCode");
		sHTML += "<script type=\"text/javascript\">"+sAddJavascript+"</script>";
		
		return sHTML;
	}
	
	
	public String getHeaderFieldsNewStyle(HttpServletResponse response, String sRootPath, String sLastCaption)
	{
		String sHtmlHeaderField = "<tr class=\"header\">";
		String sIconPrefix = Theme.getIconPrefix();
		
		for (int i = 0; i < this.vFields.size(); i++) 
		{
			SearchEngineArrayHeaderItem item = (SearchEngineArrayHeaderItem) this.vFields.get(i);
			String sTri = ""; 
			String sUrl = "";
			String sOrderByValue = "";
	
			String sAHRefTag = "";
			
			if( this.sFieldNameOrderByValue.equals("desc"))
			{
				sOrderByValue = "asc";
			}
			else
			{
				sOrderByValue = "desc";
			}
			switch (item.iFieldType) {
			case SearchEngineArrayHeaderItem.FIELD_TYPE_STRING:
				sTri = item.sFieldName; 
				 
				sUrl= response.encodeURL( this.sUrlTarget + "?"
						+ this.sFieldNameFiltreType + "=" + this.sFieldNameFiltreTypeValue + "&amp;" 
						+ this.sFieldNameFiltre + "=" + this.sFieldNameFiltreValue + "&amp;"
						+ this.sFieldNameTri + "=" + sTri + "&amp;"
						+ this.sFieldNameOrderBy + "=" + sOrderByValue + "&amp;"
						+ "numPage="+ this.iCurrentPage + "&amp;"
						+ "bUseCountQuery=" + (bUseCountQuery ?"on":"off") + "&amp;"
						+ "iCutSearchWithMaxElementSize=" + iCutSearchWithMaxElementSize
						+ this.sExtraParamHeaderUrl) ;
				
				sAHRefTag = "<a class=\"se_header\" href='" + sUrl + "' " + " >" + item.sFieldLibelle + "</a>";
				
				break;
			default:
				sAHRefTag = "<label>"+item.sFieldLibelle+"</label><a class=\"se_header\"></a>";
				break;
			}
			
			String sUrlIconOrderBy = "";
			
			if(item.sFieldName.equals(this.sFieldNameTriValue))
			{
				if(this.sFieldNameOrderByValue.equals("desc"))
				{
					sUrlIconOrderBy = "asc.gif";
				}
				else
				{
					sUrlIconOrderBy = "desc.gif";
				}
				
				sUrlIconOrderBy = "&nbsp;<img style=\"vertical-align : middle;\" src=\"" 
					+ sRootPath + "images/icones/fleches/"+sIconPrefix + sUrlIconOrderBy + "\" alt=\"ordre\" />";
			}	
			
			sHtmlHeaderField += "<td class=\"cell\"><div>" + sAHRefTag  + sUrlIconOrderBy  + "</div></td>\n"  ;
		}
		
		sHtmlHeaderField += "<td class=\"cell\"><div><label>"+sLastCaption+"</label><a class=\"se_header\"></a></div></td></tr>\n";
	
		return sHtmlHeaderField ;
	}

	public String getHeaderFields(HttpServletResponse response, String sRootPath)
	{
		return getHeaderFields(response, sRootPath, "&nbsp;");
	}
	public String getHeaderFields(HttpServletResponse response, String sRootPath, String sLastCaption)
	{
		String sHtmlHeaderField = "<tr>";
		
		for (int i = 0; i < this.vFields.size(); i++) 
		{
			SearchEngineArrayHeaderItem item = (SearchEngineArrayHeaderItem) this.vFields.get(i);
			String sTri = ""; 
			String sUrl = "";
			String sOrderByValue = "";

			String sAHRefTag = "";
			
			if( this.sFieldNameOrderByValue.equals("desc"))
			{
				sOrderByValue = "asc";
			}
			else
			{
				sOrderByValue = "desc";
			}
			switch (item.iFieldType) {
			case SearchEngineArrayHeaderItem.FIELD_TYPE_STRING:
				sTri = item.sFieldName; 
				 
				sUrl= response.encodeURL( this.sUrlTarget + "?"
						+ this.sFieldNameFiltreType + "=" + this.sFieldNameFiltreTypeValue + "&amp;" 
						+ this.sFieldNameFiltre + "=" + this.sFieldNameFiltreValue + "&amp;"
						+ this.sFieldNameTri + "=" + sTri + "&amp;"
						+ this.sFieldNameOrderBy + "=" + sOrderByValue + "&amp;"
						+ "numPage="+ this.iCurrentPage + "&amp;"
						+ "bUseCountQuery=" + (bUseCountQuery ?"on":"off") + "&amp;"
						+ "iCutSearchWithMaxElementSize=" + iCutSearchWithMaxElementSize
						+ this.sExtraParamHeaderUrl) ;
				
				sAHRefTag = "<a href='" + sUrl + "' " + " >" + item.sFieldLibelle + "</a>";
				
				break;
			default:
				sAHRefTag = item.sFieldLibelle ;
				break;
			}
			
			String sUrlIconOrderBy = "";
			
			if(item.sFieldName.equals(this.sFieldNameTriValue))
			{
				if(this.sFieldNameOrderByValue.equals("desc"))
				{
					sUrlIconOrderBy = "asc.gif";
				}
				else
				{
					sUrlIconOrderBy = "desc.gif";
				}
				
				sUrlIconOrderBy = "&nbsp;<img style=\"vertical-align : middle;\" src=\"" 
					+ sRootPath + "images/icones/" + sUrlIconOrderBy + "\" alt=\"ordre\" />";
			}	
			
			sHtmlHeaderField += "<th>" + sAHRefTag  + sUrlIconOrderBy  + "</th>\n"  ;
		}
		
		sHtmlHeaderField += "<th style=\"width:10%;text-align:right\">" + sLastCaption + "</th>\n</tr>\n";
	
		return sHtmlHeaderField ;
	}
	
	
	public String getUrlPrevPage()
	{
		return  getUrlPage(this.iCurrentPage - 1);
	}
	
	public String getUrlNextPage()
	{
		return  getUrlPage(this.iCurrentPage + 1);
	}

	public String getUrlPage(int iPage)
	{
		return  this.sUrlTarget + "?"
		+ this.sFieldNameFiltreType + "=" + this.sFieldNameFiltreTypeValue + "&amp;" 
		+ this.sFieldNameFiltre + "=" + this.sFieldNameFiltreValue + "&amp;"
		+ this.sFieldNameTri + "=" + this.sFieldNameTriValue  + "&amp;"
		+ this.sFieldNameOrderBy + "=" + this.sFieldNameOrderByValue + "&amp;"
		+ this.sFieldNameCurrentPage + "=" + iPage  + "&amp;"
		+ "bUseCountQuery=" + (this.bUseCountQuery ?"on":"off") + "&amp;"
		+ AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_COUNT + "=" + this.iCutSearchWithMaxElementSize + "&amp;"
		+ AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_PER_PAGE + "=" + this.iItemPerPage + "&amp;"
		+ AutoFormSearchEngine.PARAM_NAME_USE_CUT_COUNT + "=" + this.bCutSearchWithMaxElement
		+ this.sExtraParamHeaderUrl ;
	
	}
	
	public String getUrlFirstPage()
	{
		return  getUrlPage(1);
	}

	public String getUrlLastPage()
	{
		return  getUrlPage(this.iMaxPage);
	}

	
	public String getTri() {
		return this.sTri;
	}
	
	protected void init()
	{
		this.iItemPerPage = 0;
		this.sRequest = "";
		this.sFilter="";
		this.sTri="";
		this.sOrder = "";
		this.vFields = new Vector<Object>();
		this.bCutSearchWithMaxElement = false;
		this.bUseCountQuery = false;
		this.iCutSearchWithMaxElementSize = MAX_SEARCH_ELEMENT_DEFAULT;
		
		this.iAbstractBeanIdLanguage = Language.LANG_FRENCH;
		this.iAbstractBeanIdObjectType = ObjectType.SEARCH_ENGINE;
	}
	public SearchEngine(){
		init();
	}

	public SearchEngine(String sRequest,int iItemPerPage){
		init();
		this.iItemPerPage = iItemPerPage;
		this.sRequest = sRequest;
	}

	public void setFilter(String sField,String sFilter){
	    
	    this.sFilter= " WHERE "+sField+" LIKE "+ "'%"+Outils.addLikeSlashes(sFilter)+"%'";
	}
	
	public void setOrder(String sOrder){
	    
	    this.sOrder = sOrder;
	}
	
	public void setFilterClause(String sClause){
	    
	    this.sFilter= " "+sClause;
	}
	
	public void setTri(String sField){
	    this.sTri += " ORDER BY "+sField;
	}
	
	public void setTriFull(String sField){
	    this.sTri = sField;
	}
	
	public String getRequest(){
	    return this.sRequest;
	}
	
	public String getFilter(){
	    return this.sFilter;
	}

	public void setResultat(Vector vResultats){
	    
	    this.vResultats = vResultats;
	    
	}
	
	public Vector<Object> getCurrentPage(){
		return getPage(this.iCurrentPage);
	}
	@SuppressWarnings("unchecked")
	public Vector<Object> getPage(int iCurrentPage){
	    
	   /* Vector<Object> vResult = new Vector<Object>();
	    
	    int fin = this.iItemPerPage*iCurrentPage;
	    if (fin>this.vResultats.size()) fin = this.vResultats.size();
	    
	    for(int i=((iCurrentPage-1)*this.iItemPerPage);i<fin;i++){
	        vResult.add(this.vResultats.get(i));
	    }
	    */
		
	    return this.vResultats;
	}

	public int getMaxPage(){
	    return this.iMaxPage;
	}

	public void setMaxPage(int iMaxPage){
	    this.iMaxPage = iMaxPage;
	}

	
	public int getNbResultats(){
	    //return this.vResultats.size();
		return iElementCount;
	}

	public Vector getAllResults(){
	    return this.vResultats;
	}
	public void computeAfterTreatment(Vector vResults){
	    setResultat(vResults);
	    computeMaxPage();
	}

	public void computeMaxPage(){
	    this.iMaxPage = (this.vResultats.size()/this.iItemPerPage);
	    int iMaxPageReste = (this.vResultats.size()%this.iItemPerPage);
	    if(iMaxPageReste !=0 ) this.iMaxPage++;
	}

	/**
	 * 
	 * 
	 * @param sItem
	 * @param oContext
	 * @deprecated use isObjectToAdd
	 * @return
	 */
	public boolean isObjectAddable(String sItem, Object oContext){
	    return true;
	}

	/**
	 * 
	 * To complete
	 * 
	 * @param oItem
	 * @param oContext
	 * @return
	 */
	 public boolean isObjectToAdd(Object oItem, Object oContext){
	    return true;
	}
	
	/**
	 * 
	 * @throws NamingException
	 * @throws SQLException
	 * @deprecated use getAllResultObjects() method @see SearchEngine.getAllResultObjects()
	 */
	public void load() throws NamingException, SQLException{
	    String sRequete = this.sRequest;
	    if (this.sFilter !="") sRequete += " " + this.sFilter;
	    if (this.sTri !="") sRequete += " " + this.sTri + " " +this.sOrder;
	    Vector<Object> vResultats = new Vector<Object>();
	    Connection conn = null;
	    Statement stat = null;
	    ResultSet rs = null;
	    ResultSetMetaData rsMetaData = null;
	    
	   long lAddableObject = 0;
	   
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
		    rsMetaData = rs.getMetaData();
			while(rs.next()) {
			    String item="";
			    String sType = rsMetaData.getColumnTypeName(1);
			    if (sType.equals( "LONG" ) ){item = String.valueOf(rs.getInt(1));}
			    else if (sType.equals("TEXT") ) {item = rs.getString(1);}
			    else if (sType.equals("VARCHAR") ) {item = rs.getString(1);}
			    else if (sType.equals("INTEGER UNSIGNED") ) {item = Integer.toString(rs.getInt(1));}
			    
			    
			    if (isObjectAddable(item , this.oContext ) )
			    {
			    	lAddableObject++;
			    	vResultats.add(item);
			    
			    }
			}
			
		    this.vResultats = vResultats;
			   
		    this.iElementCount = this.vResultats.size(); 
		    computeMaxPage();
		}
		catch (SQLException e) {
		   ConnectionManager.closeConnection(rs, stat, conn);
			throw e;
		}
		
		
		ConnectionManager.closeConnection(rs, stat, conn);
		
	}

	/**
	 * To override ! 
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	 public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
		return null;
	}
	

	
	public void setCutSearchWithMaxElement(boolean cutSearchWithMaxElement) {
		this.bCutSearchWithMaxElement = cutSearchWithMaxElement;
	}
	
	public void setUseCountQuery(boolean useCountQuery) {
		this.bUseCountQuery = useCountQuery;
	}
	
	public boolean isCutSearchWithMaxElement() {
		return bCutSearchWithMaxElement;
	}

	public boolean isUseCountQuery() {
		return bUseCountQuery;
	}
	
	public boolean hasNextPage()
	{
		if(bCutSearchWithMaxElement) return true;
		
		if (this.iCurrentPage < this.iMaxPage ) return true;
		return false;
	}
	
	/**
	 * 
	 * Attention cette méthode rempli le moteur avec les bons objets et non plus avec les ID
	 * Elle remplace la méthode load();
	 * @throws NamingException
	 * @throws SQLException
	 */
	public void getAllResultObjects() throws NamingException, SQLException{
	    String sRequete = this.sRequest;
	    if (this.sFilter !="") sRequete += " " + this.sFilter;
	    if (this.sTri !="") sRequete += " " + this.sTri + " " +this.sOrder;
	    Vector<Object> vResultats = new Vector<Object>();
	    Connection conn = null;
	    Statement stat = null;
	    ResultSet rs = null;
		long lAddableObject = 0;

		
		CoinDatabaseAbstractBean.traceQueryStatic(sRequete);
	
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			while(rs.next()) {
			    Object item= getObjetFromResultSet(rs);
			    if (isObjectToAdd(item , this.oContext ) )
			    {
			    	// if faut by passer les n premier
			    	// x x x x    x x x x 
			    	// si page 1 et 5 par page : alors de 1 à 5     (1-1)*5+1 à	1*5
			    	// si page 3 et 5 par page : alors de 11 à 15   (3-1)*5+1 à  3*5  
			    	lAddableObject++;
			    	
			    	if ( ( ( ( this.iCurrentPage - 1 )* this.iItemPerPage ) < lAddableObject )
			    	&&   ( lAddableObject <= ( this.iCurrentPage * this.iItemPerPage )  ) )
			    	{
						vResultats.add(item);
			    	}
			    	
			    	if ( (this.bUseCountQuery) 
			    	&& (vResultats.size() == this.iItemPerPage) )
			    		break;

			    	if (this.bCutSearchWithMaxElement)
			    	{
			    		if(lAddableObject >= this.iCutSearchWithMaxElementSize)
			    			break;
				 	}
			    }
			}
			
		    if(this.bUseCountQuery)
		    {
		    	String sSqlTemp 
		    		= Outils.getTextBetweenOptional( sRequete, "SELECT", "FROM" );
		    	
		    	String sSqlCountQuery
		    		= sRequete.replace(sSqlTemp, " COUNT(*) ");
		    	
		    	
		    	this.iElementCount 
		    		= ConnectionManager.getCountInt(sSqlCountQuery);
		    }
		    else
		    {
		    	this.iElementCount =(int)lAddableObject; 	
		    }
		    this.vResultats = vResultats;
		    
		    /* 
		     * compute max page
		     */
		    this.iMaxPage = this.iElementCount / this.iItemPerPage ;
		    if( (int)this.iElementCount % this.iItemPerPage > 0) this.iMaxPage++ ;
		    if(this.iMaxPage==0) this.iMaxPage = 1 ;

		} catch (CoinDatabaseLoadException e) {
			e.printStackTrace();
		}finally {
		    ConnectionManager.closeConnection(rs, stat, conn);
		} 
	}
	
	/**
	 * TODO : fonction ajoutée pour faire face au problème d'affichage sur le publisher
	 * @throws NamingException
	 * @throws SQLException
	 */
	public void getAllResultObjectsBis() throws NamingException, SQLException{
	    String sRequete = this.sRequest;
	    Vector<Object> vResultats = new Vector<Object>();
	    Connection conn = null;
	    Statement stat = null;
	    ResultSet rs = null;
		CoinDatabaseAbstractBean.traceQueryStatic(sRequete);
	    try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			
			rs = stat.executeQuery(sRequete);
			while(rs.next()) {
			    Object item= getObjetFromResultSet(rs);
			    vResultats.add(item);
		    }
		    this.vResultats = vResultats;
		    
		} finally {
			ConnectionManager.closeConnection(rs, stat, conn);	
		}
	}


	 
	
	/**
	 * TODO : fonction ajoutée pour faire face au problème d'affichage sur le publisher
	 * @throws NamingException
	 * @throws SQLException
	 * @throws CoinDatabaseLoadException 
	 */
	public void loadTotalCountFromRequest(
			String sFullQuerySql,
			String sMainTable,
			String sMainTableField,
			boolean bUseDistinct)
	throws NamingException, SQLException, CoinDatabaseLoadException
	{
		String sReplacement = null;
		sReplacement = " " + sMainTableField + " " ;
		
	    String sSqlTemp = Outils.getTextBetweenOptional( sFullQuerySql, "SELECT", "FROM" );
	    String sSqlCountQuery = sFullQuerySql.replace(sSqlTemp, sReplacement);

		
		/**
		 * add SELECT in SELECT
		 */
		
		sSqlCountQuery = 
			"SELECT "
			+ (bUseDistinct?"DISTINCT":"")
			+ " COUNT(*) \n"
			+ " FROM " + sMainTable + " \n"
			+ "	WHERE " + sMainTableField + " IN ( \n"
			+ sSqlCountQuery + "\n"
			+ ")"
			;
		
		
		this.iElementCount 
			= ConnectionManager.getCountInt(sSqlCountQuery);
	}
			
	public void loadTotalCountFromRequest(
			String sFullQuerySql)
	throws NamingException, SQLException, CoinDatabaseLoadException
	{
		loadTotalCountFromRequest(sFullQuerySql, false);
	}
	
	/**
	 * TODO : fonction ajoutée pour faire face au problème d'affichage sur le publisher
	 * @throws NamingException
	 * @throws SQLException
	 * @throws CoinDatabaseLoadException 
	 */
	public void loadTotalCountFromRequest(
			String sFullQuerySql,
			boolean bUseDistinct)
	throws NamingException, SQLException, CoinDatabaseLoadException
	{
		String sReplacement = null;
		if(bUseDistinct) {
			sReplacement = " DISTINCT COUNT(*) ";
		} else {
			sReplacement = " COUNT(*) ";
		}
	    String sSqlTemp = Outils.getTextBetweenOptional( sFullQuerySql, "SELECT", "FROM" );
	    String sSqlCountQuery = sFullQuerySql.replace(sSqlTemp, sReplacement);

	    
		this.iElementCount 
			= ConnectionManager.getCountInt(sSqlCountQuery);
	}
	
	/**
	 * @return Returns the oContext.
	 */
	public Object getContext() {
		return this.oContext;
	}
	public Object getContextSup() {
		return this.oContextSup;
	}
	/**
	 * @param context The oContext to set.
	 */
	public void setContext(Object context) {
		this.oContext = context;
	}
	public void setContextSup(Object context) {
		this.oContextSup = context;
	}
	
	public void setCutSearchWithMaxElementSize(int cutSearchWithMaxElementSize) {
		iCutSearchWithMaxElementSize = cutSearchWithMaxElementSize;
	}
	
	public int getCutSearchWithMaxElementSize() {
		return iCutSearchWithMaxElementSize;
	}
	
	public static String getLocalizedLabel(String sFieldName, long iLanguage,String sDefaultValue) {
		String sValue = getLocalizedLabel(sFieldName, iLanguage);
		if(Outils.isNullOrBlank(sValue))
			return sDefaultValue;
		return sValue;
	}
	
	public static String getLocalizedLabel(String sFieldName, long iLanguage) {
		return getLocalizedLabel(sFieldName, (int)iLanguage);
	}
	
	public static String getLocalizedLabel(String sFieldName, int iLanguage) {
		SearchEngine af = new SearchEngine();
		af.iAbstractBeanIdLanguage = iLanguage;
		s_sarrLocalizationLabel = af.getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[iLanguage].get(sFieldName);
	}
	
	public String getLocalizedLabel(String sFieldName) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);
	}
	
	public void updateLocalization() 
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{

		Connection conn = ConnectionManager.getConnection();
		try {
			updateLocalization( conn);
		}  finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
    
    public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel) {
		return getLocalizationLabel(sarrLocalizationLabel, false);
	}
	
	public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel,
			boolean bForceReload) {
		
		if(sarrLocalizationLabel != null && !bForceReload) return sarrLocalizationLabel;
		
		try {
			
			sarrLocalizationLabel 
				= ObjectAttributeLocalization
					.generateAttributeLocalizationMatrixString(this.iAbstractBeanIdObjectType);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sarrLocalizationLabel; 
	}
}
