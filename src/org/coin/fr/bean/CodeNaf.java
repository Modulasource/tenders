/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 13 avr. 2004
 *
 */
package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.util.Outils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * TODO : abstract bean
 */
public class CodeNaf {	
	private static String TABLE_CODE_NAF = "code_naf";
	private static String FIELD_ID_CODE_NAF = "id_code_naf";
	protected int iIdCodeNaf;
	protected String sCodeNaf;
	protected String sLibelle;
	protected int iIdCodeNafEtat;
	
	static final String SQL_QUERY_SELECT_FROM_CLAUSE = "SELECT id_code_naf FROM code_naf "  ;
	static final String SQL_QUERY_COUNT_FROM_CLAUSE = "SELECT COUNT(*) FROM code_naf "  ;

	public boolean bUseHttpPrevent = true;
	
	public CodeNaf(int iIdCodeNaf, String sCodeNaf, String sLibelle, int iIdCodeNafEtat) {
		init();
		this.iIdCodeNaf = iIdCodeNaf;
		this.sCodeNaf = sCodeNaf;
		this.sLibelle = sLibelle;
		this.iIdCodeNafEtat = iIdCodeNafEtat;
	}
	
	public CodeNaf(){
	    init();
	}
	
	public CodeNaf(int iIdCodeNaf) {
		init();
		this.iIdCodeNaf = iIdCodeNaf;
	}
	
	public void init() {
		this.iIdCodeNaf = 0;
		this.sCodeNaf = "";
		this.sLibelle = "";
		this.iIdCodeNafEtat = 0;
	}
	
	
	
	/**
     * @param idCodeNaf The iIdCodeNaf to set.
     */
    public void setIdCodeNaf(int iIdCodeNaf) {
        this.iIdCodeNaf = iIdCodeNaf;
    }
    
    
    /**
     * @param codeNaf The sCodeNaf to set.
     */
    public void setCodeNaf(String sCodeNaf) {
        this.sCodeNaf = sCodeNaf;
    }
    /**
     * @param libelle The sLibelle to set.
     */
    public void setLibelle(String sLibelle) {
        this.sLibelle = sLibelle;
    }
    
	public int getIdCodeNaf() {
		return this.iIdCodeNaf;
	}
	public String getCodeNaf() {
		return this.sCodeNaf;
	}
	
	public void setIdCodeNafEtat(int iIdCodeNafEtat) {
        this.iIdCodeNafEtat = iIdCodeNafEtat;
    }
    
	public int getIdCodeNafEtat() {
		return this.iIdCodeNafEtat;
	}
	
	public void load() throws SQLException, NamingException, CoinDatabaseLoadException 
	{
		String sSQLQuery = 
		    	" SELECT "
		    		+ FIELD_ID_CODE_NAF + ", " 
		    		+ " code_naf, "
		    		+ " libelle, "
		    		+ " id_code_naf_etat "
		    	+ " FROM "
		    		+ TABLE_CODE_NAF 
		    	+ " WHERE "
		    		+ FIELD_ID_CODE_NAF + "='" + this.iIdCodeNaf + "'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(sSQLQuery);
			
			if(resultat.next()) 
			{
				this.iIdCodeNaf = resultat.getInt(1);
				this.sCodeNaf = resultat.getString(2);
				this.sLibelle = resultat.getString(3);
				this.iIdCodeNafEtat = resultat.getInt(4);
			}
			else
			{
				throw new CoinDatabaseLoadException("" + this.iIdCodeNaf, sSQLQuery);
			}
		} finally {
			ConnectionManager.closeConnection(resultat,stat,conn);
		}
	}
	
	public static String getCodeNafString(int iIdCodeNaf) 
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	CodeNaf codeNaf = new CodeNaf (iIdCodeNaf );
    	codeNaf.load();
   		return codeNaf.sCodeNaf;
	}
	
	public static CodeNaf getCodeNaf(int iIdCodeNaf) 
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
		return getCodeNaf(iIdCodeNaf,true);
	}
	
	public static CodeNaf getCodeNaf(int iIdCodeNaf, boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	CodeNaf codeNaf = new CodeNaf (iIdCodeNaf );
    	codeNaf.bUseHttpPrevent = bUseHttpPrevent;
    	codeNaf.load();
   		return codeNaf;
	}
	
	public static String getLibelle(int iIdCodeNaf)
	throws CoinDatabaseLoadException, SQLException, NamingException {
    	CodeNaf codeNaf = new CodeNaf (iIdCodeNaf );
    	codeNaf.load();
   		return codeNaf.sLibelle;
	}
	
	public static String getCodeNafEtLibelle(int iIdCodeNaf)
	throws CoinDatabaseLoadException, SQLException, NamingException {
		CodeNaf cn = getCodeNaf(iIdCodeNaf);
		return cn.sCodeNaf + " - " + cn.sLibelle;
	}

	public static String getCodeNafEtLibelleOptional(int iIdCodeNaf) {
		try {
			return getCodeNafEtLibelle(iIdCodeNaf);
			
		} catch (Exception e) {	}
		
		return "";
	}

	public String getCodeNafEtLibelle() {
		return this.sCodeNaf + " - " + this.sLibelle;
	}

	public String getLibelle() {
		return this.sLibelle;
	}
	
	public static Vector<CodeNaf> getAllCodeNafValide(int idCodeNaf)
	throws SQLException, NamingException, CoinDatabaseLoadException {
		
		String sWhereClause = " WHERE id_code_naf_etat = " +CodeNafEtat.VALIDE
								+ " OR (id_code_naf_etat = " +CodeNafEtat.OBSOLETE 
								+ " AND id_code_naf = " +idCodeNaf+ ")";
		return CodeNaf.getAllCodeNaf(sWhereClause);		
	}
	
	public static Vector<CodeNaf> getAllCodeNafValide()
	throws SQLException, NamingException, CoinDatabaseLoadException {
		
		String sWhereClause = " WHERE id_code_naf_etat = "+CodeNafEtat.VALIDE;
		return CodeNaf.getAllCodeNaf(sWhereClause);		
	}
	
	public static Vector<CodeNaf> getAllCodeNaf()
	throws SQLException, NamingException, CoinDatabaseLoadException {
		
		return CodeNaf.getAllCodeNaf("");		
	}
	
	
	public static Vector<CodeNaf> getAllCodeNaf(String sWhereClause)
	throws SQLException, NamingException, CoinDatabaseLoadException {
		String requete = "SELECT "
			+ FIELD_ID_CODE_NAF + ", " 
    		+ " code_naf, "
    		+ " libelle, "
    		+ " id_code_naf_etat "
    	+ " FROM " + TABLE_CODE_NAF
    	+ sWhereClause
		+ " ORDER BY id_code_naf";
		
		Vector<CodeNaf> vCodes = new Vector<CodeNaf>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(requete);
			
			while(rs.next()) 
			{
				CodeNaf code = new CodeNaf();
				code.iIdCodeNaf = rs.getInt(1);
				code.sCodeNaf = rs.getString(2);
				code.sLibelle = rs.getString(3);
				code.iIdCodeNafEtat = rs.getInt(4);
				vCodes.add(code);
			}
		}
		finally {
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		
		return vCodes;
	}
	


	//fonction ajouté par yves pour le create
	

	
	
    public static String getCodeNafHTMLComboList(int iId, String sIdListe) throws SQLException, NamingException, CoinDatabaseLoadException
	{
    	CodeNaf code = new CodeNaf(iId);
		return code.getCodeNafHTMLComboList(sIdListe,1);
	}
    
    public static String getCodeNafHTMLComboList(int iId) throws SQLException, NamingException, CoinDatabaseLoadException
	{
    	CodeNaf code = new CodeNaf(iId);
		return code.getCodeNafHTMLComboList("iIdCodeNaf",1);
	}
    
    public static String getCodeNafHTMLComboList() throws SQLException, NamingException, CoinDatabaseLoadException
	{
    	CodeNaf code = new CodeNaf();
		return code.getCodeNafHTMLComboList("iIdCodeNaf",1);
	}

	public String getCodeNafHTMLComboList(String sFormSelectName, int iSize) throws SQLException, NamingException, CoinDatabaseLoadException
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";
		
		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\""+iSize+"\">\n";
		if(this.iIdCodeNaf <= 0)
			sListe += "<option value=\""+ (this.iIdCodeNaf) +"\" "+ sSelected +">Indéfini\n";
		Vector<CodeNaf> vCodeNaf = getAllCodeNafValide(this.iIdCodeNaf);
		for (int i = 0; i < vCodeNaf.size(); i++) 
		{
			CodeNaf code = vCodeNaf.get(i);
			sListe += "<option value=\""+ code.getIdCodeNaf() +"\" "+ ((code.getIdCodeNaf()==this.iIdCodeNaf)?sSelected:"") +">"+ code.getCodeNafEtLibelle() +"\n";
		}
		sListe += "</select>";
		
		return sListe;
	}
	
	/**
	 * temp method waiting for abstract bean
	 * @param sCode
	 * @return
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseLoadException 
	 * @throws Exception
	 */
	public static CodeNaf getCodeNafFromCode(String sCode) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	 {
		return getAllCodeNafLike(sCode, 0, 1, true).firstElement();
	}
	
	public static Vector<CodeNaf> getAllCodeNafLike(String sChaine, int iLimitOffset, int iLimit)
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return getAllCodeNafLike(sChaine, iLimitOffset, iLimit, true);
	}
	
	public static Vector<CodeNaf> getAllCodeNafLike(
			String sChaine, 
			int iLimitOffset, 
			int iLimit, 
			boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			return getAllCodeNafLike(sChaine, iLimitOffset, iLimit, bUseHttpPrevent, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static Vector<CodeNaf> getAllCodeNafLike(
			String sChaine, 
			int iLimitOffset, 
			int iLimit, 
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return CodeNaf.getAllCodeNafLike(sChaine, iLimitOffset, iLimit, bUseHttpPrevent, conn, "");
	}
	
	public static Vector<CodeNaf> getAllCodeNafLike(
			String sChaine, 
			int iLimitOffset, 
			int iLimit, 
			boolean bUseHttpPrevent,
			Connection conn,
			String sWhereClause) 
	throws CoinDatabaseLoadException, NamingException, SQLException {
		String sSQLQuery = SQL_QUERY_SELECT_FROM_CLAUSE ;
		
		if (sChaine!=null){
			sSQLQuery += " WHERE (libelle LIKE '%" + Outils.addLikeSlashes(sChaine) + "%'";
			sSQLQuery += " OR code_naf LIKE '%" + Outils.addLikeSlashes(sChaine) + "%')";
			sSQLQuery += " AND "+sWhereClause;
			sSQLQuery += " ORDER BY id_code_naf";
		} else {
			sSQLQuery += " WHERE " +sWhereClause;
			sSQLQuery += " ORDER BY id_code_naf";
		}		
		
		if (iLimit>0){
			sSQLQuery += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		Statement stat = null;
		ResultSet rs = null;
		Vector<CodeNaf> vCodeNaf = new Vector<CodeNaf>();
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while(rs.next()) {
				vCodeNaf.add(CodeNaf.getCodeNaf(rs.getInt(1),bUseHttpPrevent));
			}
		} finally{
			ConnectionManager.closeConnection(rs,stat);
		}
	
		return vCodeNaf;
	}
	
	public static Vector<CodeNaf> getAllCodeNafValideLike(
			String sChaine, 
			int iLimitOffset, 
			int iLimit, 
			boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		Connection conn = ConnectionManager.getConnection();
		String sWhereClause = " id_code_naf_etat = "+CodeNafEtat.VALIDE;
		try{
			return getAllCodeNafLike(sChaine, iLimitOffset, iLimit, bUseHttpPrevent, conn, sWhereClause);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}

	public static int getCountCodeNafValideLike(String sChaine, int iLimitOffset, int iLimit)
	throws CoinDatabaseLoadException, NamingException, SQLException {
		String sWhereClause = " id_code_naf_etat = "+CodeNafEtat.VALIDE;
		return CodeNaf.getCountCodeNafLike(sChaine, iLimitOffset, iLimit, sWhereClause);
	}
	
	public static int getCountCodeNafLike(String sChaine, int iLimitOffset, int iLimit)
	throws CoinDatabaseLoadException, NamingException, SQLException {
		return CodeNaf.getCountCodeNafLike(sChaine, iLimitOffset, iLimit, "");
	}
	
	public static int getCountCodeNafLike(String sChaine, int iLimitOffset, int iLimit, String sWhereClause)
	throws CoinDatabaseLoadException, NamingException, SQLException {
		String sSQLQuery = SQL_QUERY_COUNT_FROM_CLAUSE ;
		
		if (sChaine!=null){
			sSQLQuery += " WHERE (libelle LIKE '%" + Outils.addLikeSlashes(sChaine) + "%'";
			sSQLQuery += " OR code_naf LIKE '%" + Outils.addLikeSlashes(sChaine) + "%')";
			sSQLQuery += " AND " +sWhereClause;
			sSQLQuery += " ORDER BY code_naf";
		} else sSQLQuery += " WHERE " +sWhereClause;
		
		if (iLimit>0){
			sSQLQuery += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		
		return ConnectionManager.getCountInt(sSQLQuery);
	}
	
	public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("lId", this.iIdCodeNaf);
		item.put("sName", this.sLibelle);
        

		item.put("data", this.iIdCodeNaf);
        item.put("value", this.getCodeNafEtLibelle());
		return item;
	}
		
	public static JSONArray getJSONArray() throws Exception {
        JSONArray items = new JSONArray();
        for (CodeNaf item:getAllCodeNaf()) items.put(item.toJSONObject());
        return items;
    }
}
