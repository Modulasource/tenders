package org.coin.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Hashtable;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class UISearchEngine {
	
	protected Vector<Hashtable> vResults;
	protected int iCountResultLimit;
	
	protected String sSelectPart;
	protected boolean bSelectWithDistinct;
	protected String sIdInTable;
	protected String sMainTable;
	protected String sMainAliasTable;
	protected Vector<String> vOtherTables;
	protected Vector<String[]> vOtherTablesWithLeftJoin;
	protected Vector<String> vClausesInvariantes;
	protected Vector<String> vClausesFromForm;
	protected String sGroupByClause;
	protected int iMaxElementsPerPage;
	protected int iCurrentPage;
	protected int iResultsIndex;
	protected String sOrderByName;
	protected String sOrderByDirection;
	
	public UISearchEngine() {
		init();
	}
	
	public UISearchEngine(String sJSON) throws Exception {
		init();
		buildQueryFromJSONObject(new JSONObject((sJSON==null)?"{}":sJSON));
	}
	
	public void init() {
		this.sMainTable = "";
		this.iMaxElementsPerPage = 20;
		this.iCurrentPage = 0;
		this.iResultsIndex = 0;
		this.vOtherTables = new Vector<String>();
		this.vOtherTablesWithLeftJoin = new Vector<String[]>();
		this.vClausesInvariantes = new Vector<String>();
		this.vClausesFromForm = new Vector<String>();
		this.sIdInTable = "";
		this.sSelectPart = "";
		this.sMainAliasTable = "";
		this.vResults = new Vector<Hashtable>();
		this.iCountResultLimit = 0;
		this.bSelectWithDistinct = false;
		this.sGroupByClause = "";
		this.sOrderByName = "";
		this.sOrderByDirection = "";
	}
	
	protected void setCountResultLimit(int iCountResultLimit){
		this.iCountResultLimit = iCountResultLimit;
	}
	public void setMaxElementsPerPage(int iMaxElementsPerPage){
		this.iMaxElementsPerPage = iMaxElementsPerPage;
	}
	public void setGroupByClause(String sGroupByClause) {
		this.sGroupByClause = sGroupByClause;
	}
	
	public Vector<Hashtable> getResults() throws Exception{
		load();
		return this.vResults;
	}
	
	public void addClauseInvariante(String sClause){
		this.vClausesInvariantes.add(sClause);
	}
	public void addOtherTable(String sTable, String sJoin){
		this.vOtherTables.add(sTable);
		this.addClauseInvariante(sJoin);
	}
	public void addOtherTableWithLeftJoin(String sTable, String sJoin){
		String[] leftJoin = {sTable, sJoin};
		this.vOtherTablesWithLeftJoin.add(leftJoin);
	}
	
	public Vector<String> getClausesFromForm(){
		return this.vClausesFromForm;
	}
	public Vector<String> getClausesInvariantes(){
		return this.vClausesInvariantes;
	}
	public Vector<String[]> getOtherTableWithLeftJoin(){
		return this.vOtherTablesWithLeftJoin;
	}
	public Vector<String> getOtherTable(){
		return this.vOtherTables;
	}
	public String getMainTable(){
		return this.sMainTable;
	}
	public String getIdInTable(){
		return this.sIdInTable;
	}
	public String getMainAliasTable(){
		return this.sMainAliasTable;
	}
	public boolean isSelectWithDistinct(){
		return this.bSelectWithDistinct;
	}
	public String getSelectPart(){
		return this.sSelectPart;
	}
	public String getGroupByClause(){
		return this.sGroupByClause;
	}	
	public int getMaxElementsPerPage() {
		return this.iMaxElementsPerPage;
	}
	public int getResultsIndex(){
		return this.iResultsIndex;
	}
	public void setResultsIndex(int iResultsIndex){
		this.iResultsIndex = iResultsIndex;
	}
	
	
	public void setOrderByName(String sOrderByName){
		this.sOrderByName = sOrderByName;
	}
	public void setOrderByDirection(String sOrderByDirection){
		this.sOrderByDirection = sOrderByDirection;
	}
	
	public String getSelectPartForRequest(){
		if (this.getSelectPart().equalsIgnoreCase("*")){
			return "SELECT "+(this.isSelectWithDistinct()?"DISTINCT ":"")+"*";
		}
		return "SELECT "
					+(this.isSelectWithDistinct()?"DISTINCT ":"")
					+this.getMainAliasTable()
					+"."+this.getIdInTable()
					+((this.getSelectPart().equals("")) ? "" : ", "+this.getSelectPart());
	}
	
	
	public String getFromPartForRequest(){
		String sReq = "FROM "+this.getMainTable()+" "+this.getMainAliasTable();
		for(int i=0;i<this.getOtherTable().size();i++){
			sReq += ", "+this.getOtherTable().get(i);
		}
		
		for(int i=0;i<this.getOtherTableWithLeftJoin().size();i++){
			String[] leftJoin = this.getOtherTableWithLeftJoin().get(i);
			sReq += " LEFT JOIN "+leftJoin[0] + " ON (" + leftJoin[1] + ")";
		}
		return sReq;
	}
	
	
	public String getWherePartForRequest(){
		Vector<String> vClauses = new Vector<String>();
		// Fusion des 2 types de clauses
		for (int i=0;i<this.getClausesInvariantes().size();i++){
			vClauses.add(this.getClausesInvariantes().get(i));
		}
		for (int i=0;i<this.getClausesFromForm().size();i++){
			vClauses.add(this.getClausesFromForm().get(i));
		}
		
		if (vClauses.size()==0) return "";
		if (vClauses.size()==1) return "WHERE "+vClauses.firstElement();
		String sReq = "WHERE "+vClauses.firstElement();
		for (int i=1;i<vClauses.size();i++){
			sReq += " AND "+vClauses.get(i);
		}
		return sReq;
	}
	
	
	public String getGroupByPartForRequest(){
		String sReq = "";
		if (!this.getGroupByClause().equalsIgnoreCase("")){
			sReq = "GROUP BY "+this.getGroupByClause();
		}
		return sReq;
	}
	
	public String getOrderByPartForRequest(){
		String sReq = "";
		if (!this.sOrderByName.equalsIgnoreCase("")){
			sReq = "ORDER BY "+this.sOrderByName;
			if (!this.sOrderByDirection.equalsIgnoreCase("")){
				sReq += " "+this.sOrderByDirection;
			}
		}
		return sReq;
	}
	
	public String getLimitForRequest(){
		if (this.getMaxElementsPerPage()<0) return "";
		return "LIMIT "
				+this.getResultsIndex()
				+", "
				+this.getMaxElementsPerPage();
	}
	
	public String getGeneratedRequest(){
		return this.getSelectPartForRequest()
				+" "+this.getFromPartForRequest()
				+" "+this.getWherePartForRequest()
				+" "+this.getGroupByPartForRequest()
				+" "+this.getOrderByPartForRequest()
				+" "+this.getLimitForRequest();
	}
	
	
	/**
	 * Retourne la requ�te construite pour �valuer le nombre d'�l�ments
	 * trouv� avec les crit�res
	 */
	public String getGeneratedRequestCountResult(){
		return "SELECT "+(this.isSelectWithDistinct()?"DISTINCT ":"") + (this.getGroupByClause().equalsIgnoreCase("")?"":this.getGroupByClause()+", ") + "COUNT(*)"
				+" "+this.getFromPartForRequest()
				+" "+this.getWherePartForRequest()
				+" "+this.getGroupByPartForRequest();
	}
	
	/**
	 * il faut avoir lanc� le getResults() avant, sinon elle est lanc� dans la m�thode.
	 * @return
	 * @throws Exception 
	 */
	public CoinDatabaseWhereClause getCoinDatabaseWhereClause(int iItemType, String sFieldName) throws Exception{
		CoinDatabaseWhereClause wcWhereClause 
			= new CoinDatabaseWhereClause(iItemType);

		if(this.vResults == null) getResults();
		
		for(Hashtable item:this.vResults) {
			long lId = Long.parseLong((String)item.get(sFieldName));
			wcWhereClause .add(lId);
		}

		return wcWhereClause;
	}
	
	/**
	 * Compte le nombre total d'�l�ments avec crit�res
	 * @throws Exception 
	 */
	public int getTotalCount() throws Exception{
	    String sRequete = this.getGeneratedRequestCountResult();
	    int iCount = 0;		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			
			while(rs.next()) {
				if(this.getGroupByClause().equalsIgnoreCase(""))
					iCount = rs.getInt(1);
				else
					iCount++;
			}
		}
		catch(NamingException e){
			throw e;
		}catch(SQLException e){
			throw e;
		}finally{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		return iCount;
	}
	
	@SuppressWarnings("unchecked")
	private void load() throws Exception{
		String sRequete = this.getGeneratedRequest();
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		ResultSetMetaData rsMetaData = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			rsMetaData = rs.getMetaData();
			int i = 0;
			int iCol;
			iCol = rsMetaData.getColumnCount();
			
			while(rs.next()) {
				Hashtable h= new Hashtable();
				for (int j=1;j<=iCol;j++){
					try{
						h.put(rsMetaData.getColumnName(j), rs.getString(j));
					}catch(Exception e){
						h.put(rsMetaData.getColumnName(j),"");
					}
				}
				this.vResults.add(h);
				i++;
			}
			
		}
		catch(NamingException e){
			throw e;
		}catch(SQLException e){
			throw e;
		}finally{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		this.setCountResultLimit(this.vResults.size());
	}
	
	/*
	 var searchObj = {
	 		idInTable:"id_agent",
	 		mainTable:"agent",
	 		mainTableAlias:"ag",
			index:0,
			offset:9,
			otherTables:[
				{tableName:"personne_physique pp", jointure:"ag.id_personne_physique = pp.id_personne_physique"},
				{tableName:"adresse adr", jointure:"pp.id_adresse = adr.id_adresse"}
			],
			otherTablesWithLeftJoin:[
				{tableName:"personne_physique pp", jointure:"ag.id_personne_physique = pp.id_personne_physique"},
				{tableName:"adresse adr", jointure:"pp.id_adresse = adr.id_adresse"}
			],
			filters:[
				"adr.pays=FR",
				"pp.prenom like '%flo%'",
				"pp.commune=paris"
			],
			orderBy:{name:"pp.nom", direction:"ASC"},
			groupBy:"fiche.id_fiche_prospect"
			}
	 */
	
	private void buildQueryFromJSONObject(JSONObject jsonObj) throws JSONException {		
		this.sIdInTable = jsonObj.getString("idInTable");
		this.sMainTable = jsonObj.getString("mainTable");
		this.sMainAliasTable = jsonObj.getString("mainTableAlias");
		this.sSelectPart = "";
		try{this.sSelectPart = jsonObj.getString("selectPart");}
		catch(Exception e){}
		
		try {
			this.setMaxElementsPerPage(jsonObj.getInt("offset"));
		} catch(Exception e) {}
		
		try {
			this.setResultsIndex(jsonObj.getInt("index"));
		} catch(Exception e) {}
		
		try {
			JSONArray otherTables = jsonObj.getJSONArray("otherTables");
			for(int i=0; i<otherTables.length(); i++) {			
				JSONObject table = otherTables.getJSONObject(i);
				this.addOtherTable(table.getString("tableName"), table.getString("jointure"));
			}
		} catch(Exception e) {}
		
		try {
			JSONArray otherTablesWithLeftJoin = jsonObj.getJSONArray("otherTablesWithLeftJoin");
			for(int i=0; i<otherTablesWithLeftJoin.length(); i++) {			
				JSONObject table = otherTablesWithLeftJoin.getJSONObject(i);
				this.addOtherTableWithLeftJoin(table.getString("tableName"), table.getString("jointure"));
			}
		} catch(Exception e) {}
		
		try {
			JSONArray filters = jsonObj.getJSONArray("filters");
			for(int i=0; i<filters.length(); i++) {
				this.addClauseInvariante(filters.getString(i));
			}
		} catch(Exception e) {}
		
		try {
			JSONObject order = jsonObj.getJSONObject("orderBy");
			this.setOrderByName(order.getString("name"));
			try {
				this.setOrderByDirection(order.getString("direction"));
			}  catch(Exception e) {}
		} catch(Exception e) {}
		
		try {
			this.setGroupByClause(jsonObj.getString("groupBy"));
		} catch(Exception e) {}
		
	}
	
	public Vector<Hashtable> getResults(String sJSON) throws Exception {
		buildQueryFromJSONObject(new JSONObject((sJSON==null)?"{}":sJSON));		
		return getResults();
	}
	
}
