/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.conf.TreeviewNode;
import org.coin.bean.conf.TreeviewNodeTimeStamped;
import org.coin.bean.conf.TreeviewParsing;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseRemoveException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.ConnectionManager;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.sql.*;
import java.util.Collections;
import java.util.Vector;


@RemoteProxy
public class OrganisationGroup extends TreeviewNodeTimeStamped  {

	private static final long serialVersionUID = 1L;
	
	public static final int ROOT = 1;

	protected String sDescription;
	protected String sIdPays;
	protected String sExternalReference;

	public String getExternalReference() {
		return this.sExternalReference;
	}

	public void setExternalReference(String externalReference) {
		this.sExternalReference = externalReference;
	}

	public void setPreparedStatement (PreparedStatement ps ) throws SQLException
	{
		super.setPreparedStatement(ps);
		int i = SELECT_FIELDS_SIZE;
		ps.setString(++i, preventStore(this.sDescription));
		ps.setString(++i, this.sIdPays);
		ps.setString(++i, this.sExternalReference);
		ps.setTimestamp(++i, this.tsDateCreation);
		ps.setTimestamp(++i, this.tsDateModification);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException
	{
		super.setFromResultSet(rs);
		int i = SELECT_FIELDS_SIZE;
		this.sDescription = preventLoad(rs.getString(++i));
		this.sIdPays = rs.getString(++i);
		this.sExternalReference = rs.getString(++i);
		this.tsDateCreation = rs.getTimestamp(++i);
		this.tsDateModification = rs.getTimestamp(++i);
	}


	/**
	 * Constructeur 
	 *
	 */
	public OrganisationGroup() {
		init();
	}

	public OrganisationGroup(String sName) {
		init();
		this.sName = sName;
	}


	/**
	 * Constructeur
	 * @param id - identifiant de l'enregistrement correspondant dans la base
	 * @throws Exception
	 */
	public OrganisationGroup(long lIdCaption) {
		init();
		this.lId = lIdCaption;
	}

	/**
	 * Initilisation de tous les champs de l'objet 
	 * avec des paramètres par défaut
	 */
	public void init() {
		super.init();
		this.TABLE_NAME = "organisation_group";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME
				= " name,"
				+ " id_organisation_group_fc,"
				+ " id_organisation_group_ns,"
				+ " description,"
				+ " id_pays,"
				+ " external_reference,"
				+ " date_creation,"
				+ " date_modification";

		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ;

		//this.sFieldHtmlName = "sName" ;
		//this.sFieldHtmlIdTreeviewNodeFirstChild = "lIdTreeviewNodeFirstChild";
		//this.sFieldHtmlIdTreeviewNodeNextSibling = "lIdTreeviewNodeNextSibling";

		this.lId = 0;
		this.lIdTreeviewNodeFirstChild = 0;
		this.lIdTreeviewNodeNextSibling = 0;
		this.lIdTreeviewNodeParent = 0;
		this.sName = "";
		this.sDescription = "";
		this.sIdPays = "";
		this.sExternalReference = "";
	}


	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		super.setFromForm(request, sFormPrefix);
        try {
            this.sDescription = request.getParameter(sFormPrefix + "sDescription");
        } catch(Exception e){}
        try {
            this.sIdPays = request.getParameter(sFormPrefix + "sIdPays");
        } catch(Exception e){}
        try {
            this.sExternalReference = request.getParameter(sFormPrefix + "sExternalReference");
        } catch(Exception e){}
	}

    public static OrganisationGroup getOrganisationGroup(long lId )
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	OrganisationGroup item = new OrganisationGroup (lId );
    	item.load();
    	return item ;
    }
    
    
    public static OrganisationGroup getOrganisationGroup(
    		long lId ,
    		Vector<OrganisationGroup> vOrganisationGroup )
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	
    	for (OrganisationGroup organisationGroup : vOrganisationGroup) {
			if (organisationGroup.getId() == lId) {
				return organisationGroup;
			}
		}
    	
    	throw new CoinDatabaseLoadException("not found lId="+lId,"");
    	
    }
    
    public static OrganisationGroup getOrganisationGroupNode(
    		long lId ,
    		Vector<TreeviewNode> vOrganisationGroup )
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	
    	for (TreeviewNode node : vOrganisationGroup) {
			if (node.getId() == lId) {
				return (OrganisationGroup)node;
			}
		}
    	
    	throw new CoinDatabaseLoadException("not found lId="+lId,"");
    }
    
    public static Vector<OrganisationGroup> getOrganisationGroupTreeNode(long lIdOrganisation)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			return getOrganisationGroupTreeNode(lIdOrganisation, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
    }
    /**
     * @see TreeviewParsing.getPath ??
     * @param lIdOrganisation
     * @param conn
     * @return
     * @throws CoinDatabaseLoadException
     * @throws SQLException
     * @throws NamingException
     * @throws InstantiationException
     * @throws IllegalAccessException
     */
    public static Vector<OrganisationGroup> getOrganisationGroupTreeNode(long lIdOrganisation, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	OrganisationGroup og = new OrganisationGroup();
    	Vector<TreeviewNode> vItemList = og.getAll(conn);
    	vItemList = TreeviewParsing.getTreeviewNodeList(OrganisationGroup.ROOT,vItemList);
    	
    	Vector<OrganisationGroupItem> vGroupItem = OrganisationGroupItem.getAllFromIdOrganisationAndGroup(lIdOrganisation,false,conn);
    	
    	return getOrganisationGroupTreeNode(lIdOrganisation, vItemList, vGroupItem, conn);
    }
    public static Vector<OrganisationGroup> getOrganisationGroupTreeNode(long lIdOrganisation, Vector<TreeviewNode> vItemList, Vector<OrganisationGroupItem> vGroupItem, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {

    	for(OrganisationGroupItem item : vGroupItem){
    		if(item.getIdOrganisation() == lIdOrganisation){
	    		Vector<OrganisationGroup> vTree = new Vector<OrganisationGroup>();
	    		OrganisationGroup finalNode = null;
	    		for (int i=0; i < vItemList.size(); i++){
	    			OrganisationGroup node = (OrganisationGroup ) vItemList.get(i);
	    			if(node.getId()==item.getIdOrganisationGroup()){
	    				finalNode = node;
	    			}
	    		}
	    		if(finalNode != null){
	    			vTree.add(finalNode);
	    			while(finalNode.lIdTreeviewNodeParent != OrganisationGroup.ROOT){
	    				OrganisationGroup nodeParent = OrganisationGroup.getOrganisationGroupNode(finalNode.lIdTreeviewNodeParent,vItemList);
	    				vTree.add(nodeParent);
	    				finalNode = nodeParent;
	    			}
	    			Collections.reverse(vTree);
	    			return vTree;
	    		}
    		}
    	}
    	
    	return null;
    }
    
    
    
    public static OrganisationGroup getOrganisationGroup(
    		long lId ,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	OrganisationGroup item = new OrganisationGroup (lId );
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.bUseEmbeddedConnection = true;
    	item.connEmbeddedConnection = conn;
    	item.load();
    	return item ;
    }

	public static Vector<OrganisationGroup> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationGroup item = new OrganisationGroup();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationGroup> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	OrganisationGroup item = new OrganisationGroup();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationGroup> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	OrganisationGroup item = new OrganisationGroup();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<OrganisationGroup> getAllWithWhereAndOrderByClauseStatic(
    		String sWhereClause, 
    		String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	OrganisationGroup item = new OrganisationGroup();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    public String getIdPays() {return this.sIdPays;}
    public void setIdPays(String sIdPays) {this.sIdPays = sIdPays;}

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public String getDescription() {return this.sDescription;}
    public void setDescription(String sDescription) {this.sDescription = sDescription;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdTreeviewNodeNextSibling", this.lIdTreeviewNodeNextSibling);
        item.put("lIdTreeviewNodeFirstChild", this.lIdTreeviewNodeFirstChild);
        item.put("sIdPays", this.sIdPays);
        item.put("sName", this.sName);
        item.put("sDescription", this.sDescription);
        item.put("sExternalReference", this.sExternalReference);
        item.put("data", this.lId);
        item.put("value", this.sName);
        return item;
    }

    public static JSONObject getJSONObject(long lId) 
    throws CoinDatabaseLoadException, SQLException, NamingException, JSONException {
    	OrganisationGroup item = getOrganisationGroup(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONArray items = new JSONArray();
        for (OrganisationGroup item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdTreeviewNodeNextSibling = item.getLong("lIdTreeviewNodeNextSibling");
        } catch(Exception e){}
        try {
            this.lIdTreeviewNodeFirstChild = item.getLong("lIdTreeviewNodeFirstChild");
        } catch(Exception e){}
        try {
            this.sIdPays = item.getString("sIdPays");
        } catch(Exception e){}
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.sDescription = item.getString("sDescription");
        } catch(Exception e){}
        try {
            this.sExternalReference = item.getString("sExternalReference");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
        	OrganisationGroup item = null;
            try{
                item = OrganisationGroup.getOrganisationGroup(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationGroup();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    @RemoteMethod
    public static void removeFromId(long lId, long lIdRootNode) 
    throws CoinDatabaseLoadException, CoinDatabaseRemoveException, SQLException,
    NamingException, InstantiationException, IllegalAccessException, CoinDatabaseStoreException {
    	OrganisationGroup item = getOrganisationGroup(lId);
		item.removeWithObjectAttached(lIdRootNode);
	}
    
    public void removeWithObjectAttached(long lIdRootNode) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseRemoveException, CoinDatabaseStoreException
	{
		long lCountOrg = new OrganisationGroupItem().getCount("WHERE id_organisation_group="+this.lId);
		if(lCountOrg>0)
			throw new CoinDatabaseRemoveException("this group can't be delete because there is "+lCountOrg+" organization using it ");
	
		long lCountPP = new OrganisationGroupPersonnePhysique().getCount("WHERE id_organisation_group="+this.lId);
		if(lCountPP>0)
			throw new CoinDatabaseRemoveException("this group can't be delete because there is "+lCountPP+" users using it ");
	
		Vector<TreeviewNode> vItemList = this.getAll();
		vItemList = TreeviewParsing.getTreeviewNodeList(ROOT,vItemList);
		TreeviewParsing.removeNode(this,vItemList);
	}
}
