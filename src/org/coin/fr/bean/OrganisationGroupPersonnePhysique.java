
/*
 * Studio Matamore - France 2007, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 */

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.conf.TreeviewNode;
import org.coin.bean.conf.TreeviewParsing;
import org.coin.db.CoinDatabaseAbstractBeanTimeStamped;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RemoteProxy
public class OrganisationGroupPersonnePhysique extends CoinDatabaseAbstractBeanTimeStamped {

	private static final long serialVersionUID = 1L;

	protected long lIdPersonnePhysique;
	protected long lIdOrganisationGroup;

	public OrganisationGroupPersonnePhysique() {
		init();
	}

	public OrganisationGroupPersonnePhysique(long lId) {
		init();
		this.lId = lId;
	}

	public void init() {
		super.TABLE_NAME = "organisation_group_personne_physique";
		super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
		super.SELECT_FIELDS_NAME =
			" id_personne_physique,"
			+ " id_organisation_group,"
			+ " date_creation,"
			+ " date_modification";

		super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

		super.lId = 0;
		this.lIdPersonnePhysique = 0;
		this.lIdOrganisationGroup = 0;
		super.tsDateCreation = null;
		super.tsDateModification = null;
	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		int i = 0;
		ps.setLong(++i, this.lIdPersonnePhysique);
		ps.setLong(++i, this.lIdOrganisationGroup);
		ps.setTimestamp(++i, super.tsDateCreation);
		ps.setTimestamp(++i, super.tsDateModification);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;
		this.lIdPersonnePhysique = rs.getLong(++i);
		this.lIdOrganisationGroup = rs.getLong(++i);
		super.tsDateCreation = rs.getTimestamp(++i);
		super.tsDateModification = rs.getTimestamp(++i);
	}

	public static OrganisationGroupPersonnePhysique getOrganisationGroupPersonnePhysique(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique(lId);
		item.load();
		return item;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) {
		try {
			this.lIdPersonnePhysique = Long.parseLong(request.getParameter(sFormPrefix + "lIdPersonnePhysique"));
		} catch(Exception e){}
		try {
			this.lIdOrganisationGroup = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationGroup"));
		} catch(Exception e){}
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllWithSqlQueryStatic(String sSQLQuery)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllStatic()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllStatic(Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item, conn);
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	@Override
	public String getName() {
		return "organisation_group_personne_physique_"+this.lId;
	}

	public long getIdPersonnePhysique() {return this.lIdPersonnePhysique;}
	public void setIdPersonnePhysique(long lIdPersonnePhysique) {this.lIdPersonnePhysique = lIdPersonnePhysique;}

	public long getIdOrganisationGroup() {return this.lIdOrganisationGroup;}
	public void setIdOrganisationGroup(long lIdOrganisationGroup) {this.lIdOrganisationGroup = lIdOrganisationGroup;}

	public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("lIdPersonnePhysique", this.lIdPersonnePhysique);
		item.put("lIdOrganisationGroup", this.lIdOrganisationGroup);
		item.put("tsDateCreation", super.tsDateCreation);
		item.put("tsDateModification", super.tsDateModification);
		return item;
	}

	public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException {
		OrganisationGroupPersonnePhysique item = getOrganisationGroupPersonnePhysique(lId);
		JSONObject data = item.toJSONObject();
		return data;
	}

	public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException {
		JSONArray items = new JSONArray();
		for (OrganisationGroupPersonnePhysique item:getAllStatic()) items.put(item.toJSONObject());
		return items;
	}

	public void setFromJSONObject(JSONObject item) {
		try {
			this.lIdPersonnePhysique = item.getLong("lIdPersonnePhysique");
		} catch(Exception e){}
		try {
			this.lIdOrganisationGroup = item.getLong("lIdOrganisationGroup");
		} catch(Exception e){}
	}

	public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
		return storeFromJSONObject(new JSONObject(jsonStringData));
	}

	public static boolean storeFromJSONObject(JSONObject data) {
		try {
			OrganisationGroupPersonnePhysique item = null;
			try{
				item = OrganisationGroupPersonnePhysique.getOrganisationGroupPersonnePhysique(data.getLong("lId"));
			} catch(Exception e){
				item = new OrganisationGroupPersonnePhysique();
				item.create();
			}
			item.setFromJSONObject(data);
			item.store();
			return true;
		} catch(Exception e){
			return false;
		}
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllFromIdOrganisationGroup(
			long lIdOrganisationGroup)
			throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		Vector<Object> vParams = new  Vector<Object>();
		vParams.add(new Long(lIdOrganisationGroup));
		return item.getAllWithWhereAndOrderByClause(" WHERE id_organisation_group=? ", "", vParams);
	}
	
	public static Vector<OrganisationGroupPersonnePhysique> getAllFromIdOrganisationGroup(
			long lIdOrganisationGroup,
			boolean bUseHttpPrevent,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		Vector<Object> vParams = new  Vector<Object>();
		vParams.add(new Long(lIdOrganisationGroup));
        item.bUseHttpPrevent = bUseHttpPrevent;
        item.bUseEmbeddedConnection = true;
        item.connEmbeddedConnection = conn;
		return item.getAllWithWhereAndOrderByClause(" WHERE id_organisation_group=? ", "", vParams);
	}

	public static Vector<OrganisationGroupPersonnePhysique> getAllFromIdPersonnePhysiqueAndGroup(
			long lIdPP,
			long lIdOrganisationGroup)
			throws InstantiationException, IllegalAccessException, NamingException, SQLException 
			{
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		Vector<Object> vParams = new  Vector<Object>();
		vParams.add(new Long(lIdPP));
		vParams.add(new Long(lIdOrganisationGroup));
		return item.getAllWithWhereAndOrderByClause(" WHERE id_personne_physique=? AND id_organisation_group=? ", "", vParams);
			}


	public static Vector<OrganisationGroupPersonnePhysique> getAllFromIdPersonnePhysique(
			long lIdPP)
			throws InstantiationException, IllegalAccessException, NamingException, SQLException 
			{
		OrganisationGroupPersonnePhysique item = new OrganisationGroupPersonnePhysique();
		Vector<Object> vParams = new  Vector<Object>();
		vParams.add(new Long(lIdPP));
		return item.getAllWithWhereAndOrderByClause(" WHERE id_personne_physique=? ", "", vParams);
			}

	@RemoteMethod
	public static void notExistItem(long lIdPP,long lIdOrganisationGroup)
	throws InstantiationException, IllegalAccessException, NamingException,
	SQLException, CoinDatabaseLoadException 
	{
		Vector<OrganisationGroupPersonnePhysique> vItem = getAllFromIdPersonnePhysiqueAndGroup(lIdPP,lIdOrganisationGroup);
		if(vItem.size()>0)
			throw new CoinDatabaseLoadException("this HQ Collaborator already associated", "");
	}

	public static boolean isOrganisationHerarchical(
			PersonnePhysique personne,
			Organisation organisation) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		return isOrganisationHerarchical(
				personne.getId(), 
				organisation.getId());
	}
	
	public static boolean isOrganisationHerarchical(
			long lIdPP,
			long lIdOrganisation) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		CoinDatabaseWhereClause wc = getWhereClauseIdOrganisationHerarchical(lIdPP);
		return isOrganisationHerarchical(wc, lIdOrganisation);
	}
	
	public static boolean isOrganisationHerarchical(
			Vector<Organisation> vOrganisation,
			long lIdOrganisation) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		CoinDatabaseWhereClause wc = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		wc.addAll(vOrganisation);
		return isOrganisationHerarchical(wc, lIdOrganisation);
	}
	
	public static boolean isOrganisationHerarchical(
			CoinDatabaseWhereClause wc,
			long lIdOrganisation) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		for (int i = 0; i < wc.listItems.size(); i++) {
			long lId = Long.parseLong(wc.listItems.get(i));
			//System.out.println("lId:"+lId);
			if(lId == lIdOrganisation) return true;
		}
		
		return false;
	}
	
	/**
	 * 
	 * Le traitement est le suivant 
	 * 
	 * - on récupere les OGPP pour la personne connectée.
	 * - pour chaque noeud on fait une descente pour récup tous les fils
	 * - pour tous ces noeuds il faut récuperer les organisations associées
	 * - recuperation de toutes les organisations rattachées à chaque noeud
	 * 
	 * @param lIdPP
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws CoinDatabaseLoadException
	 */
	public static CoinDatabaseWhereClause getWhereClauseIdOrganisationHerarchical(long lIdPP)
	throws InstantiationException, IllegalAccessException, NamingException, 
	SQLException, CoinDatabaseLoadException
	{
	
		
		/**
		 * On récupere les OGPP pour la personne lIdPP.
		 * Normalement il n'y en a qu'une ou 2 
		 * 
		 * 
		 * og - og => lIdPP
		 *  |    |
		 *  |   og
		 *  |
		 *  - og -  og -
		 *    lIdPP | 
		 *          og 
		 *          |
		 *          og 
		 * 
		 */
		Vector<OrganisationGroupPersonnePhysique> vOGPP 
			= OrganisationGroupPersonnePhysique.getAllFromIdPersonnePhysique(lIdPP);

		Vector<TreeviewNode> vOrganisationGroupHabilitate = new Vector<TreeviewNode>();
		for(OrganisationGroupPersonnePhysique oGPP : vOGPP)
		{
			if(!CoinDatabaseUtil.isInList(oGPP.getIdOrganisationGroup(), vOrganisationGroupHabilitate))
			{
				vOrganisationGroupHabilitate.add(OrganisationGroup.getOrganisationGroup(oGPP.getIdOrganisationGroup()));
			}
		}
	

		/**
		 * pour chaque noeud on fait une descente pour récup tous les fils
		 * og - og => lIdPP
		 *  |    |
		 *  |   og(X)
		 *  |
		 *  - og -  og(X) -
		 *    lIdPP | 
		 *          og(X) 
		 *          |
		 *          og (X)
		 * 
		 */	
		Vector<OrganisationGroup> vTNAllHabilitate 
			= getAllOrganisationGroupChildFromOrganisationGroupList(vOrganisationGroupHabilitate);

		
		/**
		 * Pour tous ces noeuds il faut récupere les organisations associées
		 */
		 Vector<OrganisationGroupItem> vBUHabilitate = new Vector<OrganisationGroupItem>();
		 for (int i=0; i < vTNAllHabilitate.size(); i++)
		 {
		 	OrganisationGroup node = (OrganisationGroup ) vTNAllHabilitate.get(i);
		 	Vector<OrganisationGroupItem> vBU = OrganisationGroupItem.getAllFromIdOrganisationGroup(node.getId());
		 	CoinDatabaseUtil.merge(vBU, vBUHabilitate);
		 }
		 // à modifier un jour:
		 // pb de Class Cast
		 //Vector<OrganisationGroupItem> vBUHabilitate 
		 //	= getAllOrganisationGroupItemFromOrganisationGroupList(vTNAllHabilitate);
	
		 
		 
		/**
		 * on a récup les noeuds, il faut maintenant toutes les organisations rattachées
		 */
		 return getWhereClauseIdOrganisation(vBUHabilitate);
	}
	
	

	
	/**
	 * 
	 * @param vOrganisationGroup
	 * @return
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public static Vector getAllOrganisationGroupChildFromOrganisationGroupList(
			Vector  vOrganisationGroup )
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		/**
		 * Vector avec les noeuds enfants
		 */
		Vector<TreeviewNode> vOrganisationGroupWithChild = new Vector<TreeviewNode>();
		OrganisationGroup og = new OrganisationGroup();
		Vector<TreeviewNode> vAllItemList = og.getAll();

		for(TreeviewNode oG : (Vector<TreeviewNode>) vOrganisationGroup)
		{
			Vector<TreeviewNode> vTNHab = TreeviewParsing.getTreeviewNodeList((int)oG.getId(),vAllItemList );
			CoinDatabaseUtil.merge(vTNHab, vOrganisationGroupWithChild);
		}
		return vOrganisationGroupWithChild;

	}

	/**
	 * @deprecated TODO ne marche pas à voir plus tard
	 * @param vOrganisationGroup
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static Vector<OrganisationGroupItem> getAllOrganisationGroupItemFromOrganisationGroupList(
			Vector  vOrganisationGroup ) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Vector<OrganisationGroupItem> vOrganisationGroupItem = new Vector<OrganisationGroupItem>();
		for (int i=0; i < vOrganisationGroup.size(); i++)
		{
			TreeviewNode node = (TreeviewNode ) vOrganisationGroup.get(i);
			System.out.println("ALL : " + node.getId());

			Vector<OrganisationGroupItem> vBU = OrganisationGroupItem.getAllFromIdOrganisationGroup(node.getId());
			CoinDatabaseUtil.merge(vBU, vOrganisationGroup);
		}
		return vOrganisationGroupItem;
	}
	
	/**
	 * 
	 * @param vItem
	 * @return
	 */
	public static CoinDatabaseWhereClause getWhereClauseIdOrganisation(
			Vector<OrganisationGroupItem>  vItem )
	{

		CoinDatabaseWhereClause wc = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		for(OrganisationGroupItem oG : vItem)
		{
			wc.add(oG.getIdOrganisation());
		}
		return wc;

	}
	
    public static void removeAllFromPersonnePhysique(long lIdPP) throws SQLException, NamingException{
    	Connection conn = ConnectionManager.getConnection();
    	try {
    		removeAllFromPersonnePhysique(lIdPP, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }
    public static void removeAllFromPersonnePhysique(long lIdPP,Connection conn) throws SQLException, NamingException{
    	new OrganisationGroupPersonnePhysique().remove(" WHERE id_personne_physique =  "+lIdPP,conn);
    }

}
