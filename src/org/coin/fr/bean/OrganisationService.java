/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;


import modula.TypeObjetModula;
import mt.modula.batch.RemoteControlServiceConnection;
import org.coin.bean.ObjectType;
import org.coin.bean.organigram.Organigram;
import org.coin.bean.organigram.OrganigramNode;
import org.coin.bean.organigram.OrganigramNodeState;
import org.coin.db.*;
import org.coin.util.MultiMap;
import org.coin.util.Outils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;


public class OrganisationService extends CoinDatabaseAbstractBeanTimeStamped  {

	private static final long serialVersionUID = 1L;

	protected long lIdOrganisation;
	protected long lIdOrganisationServiceDepend;
	protected long lIdAdresse;
	protected String sNom;
	protected String sMatricule;
	protected String sReferenceExterne;
	protected long lIdOrganisationServiceState;
	
	
	protected static String[][] s_sarrLocalization;


	public void setPreparedStatement (PreparedStatement ps ) throws SQLException
	{
		int i = 0;
		ps.setLong(++i, this.lIdOrganisation);
		ps.setLong(++i, this.lIdOrganisationServiceDepend);
		ps.setLong(++i, this.lIdAdresse);
		ps.setString(++i, preventStore(this.sNom));
		ps.setString(++i, preventStore(this.sMatricule));
		ps.setString(++i, preventStore(this.sReferenceExterne));
		ps.setTimestamp(++i, this.tsDateCreation);
		ps.setTimestamp(++i, this.tsDateModification);
		ps.setLong(++i, this.lIdOrganisationServiceState);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException
	{
		int i = 0;
		this.lIdOrganisation = rs.getLong(++i);
		this.lIdOrganisationServiceDepend = rs.getLong(++i);
		this.lIdAdresse = rs.getLong(++i);
		this.sNom = preventLoad(rs.getString(++i));
		this.sMatricule = preventLoad(rs.getString(++i));
		this.sReferenceExterne = preventLoad(rs.getString(++i));
		this.tsDateCreation = rs.getTimestamp(++i);
		this.tsDateModification = rs.getTimestamp(++i);
		this.lIdOrganisationServiceState = rs.getLong(++i);
	}

	/**
	 * Constructeur
	 *
	 */
	public OrganisationService() {
		init();
	}

	/**
	 * Constructeur
	 * @param id - identifiant de l'enregistrement correspondant dans la base
	 * @throws Exception
	 */
	public OrganisationService(int iId) {
		init();
		this.lId = iId;
	}



	/**
	 * Initilisation de tous les champs de l'objet
	 * avec des paramètres par défaut
	 */
	public void init() {

		this.TABLE_NAME = "organisation_service";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME
			= "id_organisation,"
				+ " id_organisation_service_depend,"
				+ " id_adresse,"
				+ " nom,"
				+ " matricule,"
				+ " reference_externe,"
				+ " date_creation,"
				+ " date_modification,"
				+ " id_organisation_service_state";

		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ;

		this.lIdOrganisation = 0;
		this.lIdOrganisationServiceDepend = 0;
		this.lIdOrganisationServiceState = 0;
		this.lIdAdresse = 0;
		this.sNom = "";
		this.sMatricule = "";
		this.sReferenceExterne = "";
		
		this.iAbstractBeanIdObjectType = ObjectType.ORGANISATION_SERVICE;
		 


	}


    public static OrganisationService getOrganisationService(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	return getOrganisationService((int) lId);
    }

	public static OrganisationService getOrganisationService(
			long lId,
			Vector<OrganisationService> vOrganisationService) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		return (OrganisationService)getCoinDatabaseAbstractBeanFromId(lId, vOrganisationService);
	}
    
    public static OrganisationService getOrganisationService(int iId)
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	OrganisationService item = new OrganisationService (iId);
    	item.load();
    	return item ;
    }


	public void setFromFormUTF8(HttpServletRequest request, String sFormPrefix)
	{
		setFromForm(request, sFormPrefix);
		this.sNom= Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sNom"));
		this.sMatricule = Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sMatricule"));
		this.sReferenceExterne = Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sReferenceExterne"));
		this.lIdOrganisationServiceState = Integer.parseInt(Outils.decodeUtf8 (request.getParameter(sFormPrefix + "lIdOrganisationServiceState")));

	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.lIdOrganisation = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisation"));
		this.lIdOrganisationServiceDepend = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationServiceDepend"));
		this.lIdAdresse = Long.parseLong(request.getParameter(sFormPrefix + "lIdAdresse"));
		this.sNom= request.getParameter(sFormPrefix + "sNom");
		this.sMatricule = request.getParameter(sFormPrefix + "sMatricule");
		this.sReferenceExterne = request.getParameter(sFormPrefix + "sReferenceExterne");
		this.lIdOrganisationServiceState = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationServiceState"));

	}

    public static Vector<Organisation> getAllOrganisationFromAllOrganisationService(
    		Vector<OrganisationService > vOrganisationService  )
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	CoinDatabaseWhereClause wcOrganisation = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		for (int i=0;i<vOrganisationService.size();i++){
			OrganisationService item = vOrganisationService.get(i);
			wcOrganisation.add(item.getIdOrganisation());
		}
		Organisation organisation = new Organisation();	
		organisation.bUseHttpPrevent = false;
		
		return organisation.getAllWithWhereAndOrderByClause(
					" WHERE " + wcOrganisation.generateWhereClause("id_organisation"), "");
	
    }
	
    public static Vector<OrganisationService> getAllOrganisationServiceFromNameWithLimit(
    		String sValue,
    		int iLimitOffset,
    		int iLimit,
    		boolean UseHttpPrevent)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException 
    {
    	String sOrderByAndLimit = " ORDER BY nom "
	    	+ " LIMIT "+iLimitOffset+", "+iLimit ;
    	
    	
    	return getAllOrganisationServiceFromName(sValue, sOrderByAndLimit, UseHttpPrevent);
    }

	public static Vector<OrganisationService> getAllOrganisationServiceFromName(
			String sValue,
			String sOrderByAndLimit,
    		boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		OrganisationService item = new OrganisationService();
        Vector<Object> vParam = new Vector<Object>();
        vParam.add("%" + sValue + "%");
        	
        item.bUseHttpPrevent = bUseHttpPrevent;
        return item.getAllWithWhereAndOrderByClause(
        		" WHERE nom LIKE ? ",
				sOrderByAndLimit,
        		vParam);
	}
	
	public static Vector<OrganisationService> getAllFromIdOrganisation(
			long lIdOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		OrganisationService item = new OrganisationService();
		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		Vector<Object> vParams = new Vector<Object>();
		vParams.add(new Long(lIdOrganisation) );
		
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_organisation=? ", 
				"", 
				vParams);
	}

	public static Vector<OrganisationService> getAllFromIdOrganisationByOwned(
			long lIdOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		OrganisationService item = new OrganisationService();
		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		Vector<Object> vParams = new Vector<Object>();
		vParams.add(new Long(lIdOrganisation) );
		
		vParams.add(new Long(ObjectType.ORGANISATION_SERVICE) );
		vParams.add(new Long(ObjectType.ORGANISATION_SERVICE) );

		
		return item.getAllWithSqlQuery(
/*				item.getAllSelectDistinct("serv.")
				+ " , organisation org, personne_physique pers\n"
				+ " WHERE serv.id_organisation=? \n"
				+ " AND (\n"
					+ " (org.id_object_type_owner=?"
						+ " AND org.id_object_reference_owner=serv.id_organisation_service) \n"
					+ " OR (pers.id_object_type_owner=?"
						+ " AND pers.id_object_reference_owner=serv.id_organisation_service)\n"
				+ ")",
*/
				item.getAllSelect("serv.")
				+ " \n"
				+ " WHERE serv.id_organisation=? \n"
				+ " AND ("
					+ " serv.id_organisation_service = ("
						+ " SELECT org.id_object_reference_owner "
						+ " FROM organisation org \n"
						+ " WHERE org.id_object_type_owner=?"
						+ " AND org.id_object_reference_owner=serv.id_organisation_service)"
					+ " OR serv.id_organisation_service = ("
						+ " SELECT pers.id_object_reference_owner "
						+ " FROM personne_physique pers \n"
						+ " WHERE pers.id_object_type_owner=?"
						+ " AND pers.id_object_reference_owner=serv.id_organisation_service)"
				+ ")",
				vParams);
	}

	
	public static Vector<OrganisationService> getAllFromIdOrganisationAndState(
			long lIdOrganisation,
			int iIdOrganisationServiceState,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		OrganisationService item = new OrganisationService();
		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		Vector<Object> vParams = new Vector<Object>();
		vParams.add(new Long(lIdOrganisation) );
		vParams.add(new Integer(iIdOrganisationServiceState) );
		
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_organisation=? and id_organisation_service_state=?", 
				"", 
				vParams);
	}


	public static Vector<OrganisationService> getAllFromIdOrganisation(
			long lIdOrganisation) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		String sWhereClause = " WHERE id_organisation = " + lIdOrganisation;

		return getAllWithWhereAndOrderByClauseStatic(sWhereClause, "" );
	}
	
	public static Vector<Organisation> getAllOrganisationWithAtLeastOneService() throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Organisation org = new Organisation();
		OrganisationService item = new OrganisationService();
		String sSqlQuery = org.getAllSelectDistinct("org.")
			+ " , " + item.TABLE_NAME + " serv"
			+ " WHERE org.id_organisation =serv.id_organisation" ;
		
		return org.getAllWithSqlQuery(sSqlQuery);
	}


	public static Vector<OrganisationService> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		OrganisationService item = new OrganisationService();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}


	public static Vector<OrganisationService> getAllWithSqlQueryStatic(String sSQLQuery)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationService item = new OrganisationService ();
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<OrganisationService> getAllStatic(Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		OrganisationService item = new OrganisationService();
		return item.getAll(conn);
	}
	
	public static Vector<OrganisationService> getAllStatic(long lIdOrganisation)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		OrganisationService item = new OrganisationService ();
		String sClauseWhere = " WHERE id_organisation = "+lIdOrganisation;
		return item.getAllWithWhereAndOrderByClause(sClauseWhere, "");
	}

	public static Vector<OrganisationService> getAllStatic()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		OrganisationService item = new OrganisationService ();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static void removeAllFromOrganisation(long lIdOrganisation) throws SQLException, NamingException
	{
		String sWhereCLause = " WHERE id_organisation="+lIdOrganisation;
		OrganisationService item = new OrganisationService ();
		item.remove(sWhereCLause);
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}

	@Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sNom;
    		return s;
    	}
        return this.sNom;
    }
	
	public void setName(String sNom) {this.sNom = sNom;}

	@Override
	public String getLocalizedName(Connection conn) {
	 s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
	 return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
	}
	   
	@Override
	public void updateLocalization(Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
	 s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}
	

	
	public long getIdOrganisation() {
		return lIdOrganisation;
	}
	

	public String getMatricule() {
		return sMatricule;
	}
	
	public String getReferenceExterne() {
		return sReferenceExterne;
	}

	public String getNom() {
		return sNom;
	}

	public void setIdOrganisation(long idOrganisation) {
		lIdOrganisation = idOrganisation;
	}

	public long getIdOrganisationServiceDepend() {
		return lIdOrganisationServiceDepend;
	}

	public long getIdAdresse() {
		return lIdAdresse;
	}
	
	public long getIdOrganisationServiceState() {
		return lIdOrganisationServiceState;
	}

	public void setIdOrganisationServiceState(long idOrganisationServiceState) {
		lIdOrganisationServiceState = idOrganisationServiceState;
	}

	public static Vector<OrganisationService> getAllOrganisationServiceChild(
			long lIdOrganisationService,
			Vector<OrganisationService> v)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<OrganisationService> vOS =  new Vector<OrganisationService > ();
		for (int i = 0; i < v.size(); i++) {
			OrganisationService o = v.get(i);

			if(o.getIdOrganisationServiceDepend() == lIdOrganisationService
				&& o.getIdOrganisationServiceDepend() != o.getId())
			{
				vOS.add(o);
			}
		}

		return vOS;
	}


	public static void generateAbstractBeanArray(
			long lIdOrganisationService,
			Vector<OrganisationService> v,
			AbstractBeanArray arr)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		arr.setAtCurrentPosition (
				OrganisationService.getCoinDatabaseAbstractBeanFromId(lIdOrganisationService, v));

		Vector<OrganisationService> vOS =  getAllOrganisationServiceChild(lIdOrganisationService, v);
		int iCurrentColumn = arr.iCurrentColumn;

		for (int i = 0; i < vOS.size(); i++) {
			OrganisationService o = vOS.get(i);
			arr.iCurrentColumn = iCurrentColumn +1;
			arr.iCurrentRow++;
			generateAbstractBeanArray(o.getId(), v, arr);
		}
	}


	public static Vector<OrganisationService> getAllRoot(
			Vector<OrganisationService> v)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Vector<OrganisationService> vOSRoot =  new Vector<OrganisationService> ();

		for (int i = 0; i < v.size(); i++) {
			OrganisationService o = v.get(i);
			if(o.getIdOrganisationServiceDepend() == o.getId())
			{
				vOSRoot.add(o);
			}
		}

		return vOSRoot;
	}



	public static AbstractBeanArray generateAbstractBeanArray(
			Vector<OrganisationService> v) throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
	{

		Vector<OrganisationService> vOSRoot =  getAllRoot(v);
		AbstractBeanArray aba = new AbstractBeanArray(200, 30);
		for (int i = 0; i < vOSRoot.size(); i++) {
			OrganisationService o = vOSRoot.get(i);
			OrganisationService.generateAbstractBeanArray(o.getId(), v , aba);
			aba.iCurrentRow ++;
			aba.iCurrentColumn = 0;

		}

		return aba;


	}

	public Organigram getOrganigram()
	throws InstantiationException, IllegalAccessException, NamingException, 
	SQLException, CoinDatabaseLoadException, CoinDatabaseDuplicateException {
		return getOrganigramStatic(this.lId);
	}
	
	public Organigram getOrganigram(
			boolean bUseHttpPrevent,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, 
	SQLException, CoinDatabaseLoadException, CoinDatabaseDuplicateException {
		return getOrganigramStatic(
				this.lId,
				bUseHttpPrevent,
				conn);
	}

	public OrganigramNode getOrganigramNodeInterService() throws InstantiationException, 
	IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException, 
	CoinDatabaseDuplicateException {
		Connection conn = ConnectionManager.getConnection();
		try {
			return getOrganigramNodeInterService(true, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public OrganigramNode getOrganigramNodeInterService(
			boolean bUseHttpPrevent,
			Connection conn)
	throws InstantiationException, 
	IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException, 
	CoinDatabaseDuplicateException {

		Organigram oo = Organigram.getOrganigramFromObject(
				ObjectType.ORGANISATION,
				this.getIdOrganisation(),
				ObjectType.ORGANISATION_SERVICE	,
				bUseHttpPrevent,
				conn);

		OrganigramNode
			nn =  OrganigramNode.getOrganigramNode(
					oo.getId(),
					ObjectType.ORGANISATION_SERVICE,
					this.getId() ,
					bUseHttpPrevent,
					conn);

		return nn;

	}


	/**
	 * Return -1 if not found
	 * @param lIdOrganisationService
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws IllegalAccessException
	 * @throws InstantiationException
	 * @throws CoinDatabaseLoadException
	 * @throws CoinDatabaseDuplicateException 
	 */
	public static Organigram getOrganigramStatic(
			long lIdOrganisationService)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, 
	CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{

		return Organigram.getOrganigramFromObject(
				ObjectType.ORGANISATION_SERVICE,
				lIdOrganisationService,
				ObjectType.PERSONNE_PHYSIQUE	);
	}
	
	public static Vector<Organigram> getAllOrganigramStatic(
			Vector<OrganisationService> vOrganisationService,
			boolean bUseHttpPrevent,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, 
	CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		CoinDatabaseWhereClause wc = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		
		for (OrganisationService item : vOrganisationService) {
			wc.add(item.getId()) ;
		}
		
		return Organigram.getAllOrganigramFromObject(
				ObjectType.ORGANISATION_SERVICE,
				wc,
				ObjectType.PERSONNE_PHYSIQUE,
				bUseHttpPrevent,
				conn);
	}
	
	public static Vector<OrganigramNode> getAllOrganigramNodeFromService(long lIdService) throws InstantiationException, IllegalAccessException, NamingException, SQLException{
		return getAllOrganigramNodeFromService(lIdService, false, 0);
	}
	
	public static Vector<OrganigramNode> getAllOrganigramNodeFromService(
			long lIdService,
			boolean bFilterObjectType, 
			long lIdObjectType) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException{
		Organigram organigram = null;
		Vector<OrganigramNode> vNode = null;
		Vector<Organigram> vOrganigram 
			= Organigram.getAllFromObject(
					ObjectType.ORGANISATION_SERVICE, 
					lIdService);
		
		if(vOrganigram.size() ==1)
		{
			organigram = (Organigram ) vOrganigram.get(0);
			Vector<OrganigramNode> vNodeService =  OrganigramNode.getAllFromIdOrganigram(organigram .getId());
			if(bFilterObjectType){
				vNode = new Vector<OrganigramNode>();
				for(OrganigramNode node : vNodeService){
					if(node.getIdTypeObject()==lIdObjectType) vNode.add(node);
				}
			}else{
				vNode = vNodeService;
			}
		}
		else{
			vNode = new Vector<OrganigramNode>();
		}
		return vNode;
	}

	public static Vector<OrganigramNode> getAllOrganigramNode(
			long lIdOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseDuplicateException
	{
    	Vector<OrganisationService> vOrganisationService 
    		= OrganisationService.getAllFromIdOrganisation(
    			lIdOrganisation,
	    		false,
	            conn);
	    
	    vOrganisationService = OrganisationService.filterOnlyWithOrganigram (vOrganisationService, false, conn );
	    
	    Vector<Organigram> vOrganigramOrganisationService 
		    =  OrganisationService.getAllOrganigramStatic(vOrganisationService, false, conn);

		
		return getAllOrganigramNode(
				vOrganisationService, 
				vOrganigramOrganisationService, 
				bUseHttpPrevent, 
				conn);
	}
	
	
	public static Vector<OrganigramNode> getAllOrganigramNode(
			Vector<OrganisationService> vOrganisationService,
			Vector<Organigram> vOrganigramOrganisationService,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException
	{
		CoinDatabaseWhereClause wcOrganigram 
			= new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		
		for(OrganisationService os : vOrganisationService)
		{
			try{
			     Organigram organigram
			     	= OrganisationService.getOrganigramStatic(
			     			os.getId(),
			     			vOrganigramOrganisationService);
			     
			     wcOrganigram.add(organigram.getId());
			} catch (Exception e) {
				Organisation org = Organisation.getOrganisation(os.getIdOrganisation(), false, conn);
				System.out.println("no organigram defined for the service " 
						+ os.getId() + " : " +os.getName() 
						+ " of " + org.getName() );
			}
		}
		
		OrganigramNode item = new OrganigramNode();
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		Vector<OrganigramNode> vOrganigramNodeAll 
		    =  item.getAllWithWhereAndOrderByClause(
		    		"org_node.",
		            " WHERE " + wcOrganigram.generateWhereClause("id_organigram")+" and org_node.id_organigram_node_state = "+OrganigramNodeState.STATE_ACTIVATED, 
		            "",
		            conn);
		
		return vOrganigramNodeAll;
	}
	
	
	public static Organigram getOrganigramStatic(
			long lIdOrganisationService,
			Vector<Organigram> vOrganigram)
	throws CoinDatabaseLoadException
	{
		StringBuffer sbDebug = new StringBuffer("");

		for (Organigram item : vOrganigram) {
			if(item.getIdReferenceObject()==lIdOrganisationService
			&& item.getIdTypeObject() == ObjectType.ORGANISATION_SERVICE
			&& item.getIdTypeObjectNode() == ObjectType.PERSONNE_PHYSIQUE)
			{
				return item;
			}
			sbDebug.append(" " + item.getId() );
		}
		String sError = "error : id_organisation_service=" + lIdOrganisationService 
			+ " not in id_organigram [" + sbDebug.toString() + "]";
		throw new CoinDatabaseLoadException(sError,"static");
	}

	public static Organigram getOrganigramStatic(
			long lIdOrganisationService,
			boolean bUseHttpPrevent,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, 
	CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{

		return Organigram.getOrganigramFromObject(
				ObjectType.ORGANISATION_SERVICE,
				lIdOrganisationService,
				ObjectType.PERSONNE_PHYSIQUE,
				false, 
				conn);
	}

	public static Vector<OrganisationService> filterOnlyWithOrganigram(
			Vector<OrganisationService> vOrganisationService) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return filterOnlyWithOrganigram(vOrganisationService, true, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	/**
	 * Ne garde que les services qui ont un organigramme
	 * @param vOrganisationService
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws IllegalAccessException
	 * @throws InstantiationException
	 */
	public static Vector<OrganisationService> filterOnlyWithOrganigram(
			Vector<OrganisationService> vOrganisationService,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Vector<OrganisationService> vOrganisationServiceFiltered = new Vector<OrganisationService>();
		Vector<Organigram> vOrganigram = Organigram.getAllStatic(conn);
		for (int i = 0; i < vOrganisationService.size(); i++) {
			OrganisationService os = (OrganisationService) vOrganisationService.get(i);
			try {
				Organigram.getOrganigram(
						ObjectType.ORGANISATION_SERVICE,
						os.getId(),
						ObjectType.PERSONNE_PHYSIQUE,
						vOrganigram);

				vOrganisationServiceFiltered.add(os);
			} catch (Exception e) {
			}
		}
		return vOrganisationServiceFiltered;
	}
	
	public JSONObject toJSONObject() throws JSONException{
		JSONObject item = new JSONObject();
		item.put("lId",this.lId);
		item.put("lIdOrganisation",this.lIdOrganisation);
		item.put("lIdOrganisationServiceDepend",this.lIdOrganisationServiceDepend);
		item.put("sNom",this.sNom);
		item.put("sMatricule",this.sMatricule);
		item.put("sReferenceExterne",this.sReferenceExterne);
		item.put("tsDateCreation",this.tsDateCreation);
		item.put("tsDateModification",this.tsDateModification);
		item.put("lIdOrganisationServiceState",this.lIdOrganisationServiceState);
		/** pour la localization */
		item.put("sName",this.getName());

		return item;
	}

	public static long getIdOrganisationServiceFromIdOrganigramNode(
			long lIdOrganigramNode,
			Vector<OrganisationService> vOrganisationServiceAll,
			Vector<Organigram> vOrganigramOrganisationServiceAll,
			Vector<OrganigramNode> vOrganigramNodeAll) 
	throws CoinDatabaseLoadException 
	{
		OrganisationService os 
			= getOrganisationServiceFromIdOrganigramNode(
				lIdOrganigramNode, 
				vOrganisationServiceAll, 
				vOrganigramOrganisationServiceAll, 
				vOrganigramNodeAll);
		
		if(os != null) return os.getId();
		return -1;
	}

	
	public static OrganisationService getOrganisationServiceFromIdOrganigramNode(
			long lIdOrganigramNode,
			long lIdOrganization,
			Connection conn) 
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<OrganisationService> vOrganisationService 
			= OrganisationService.getAllFromIdOrganisation(lIdOrganization, false, conn);
		
		Vector<Organigram> vOrganigramOrganisationService 
	    =  OrganisationService.getAllOrganigramStatic(vOrganisationService, false, conn);
    
	    Vector<OrganigramNode> vOrganigramNode 
	    	= OrganisationService.getAllOrganigramNode(
	    		vOrganisationService,
	    		vOrganigramOrganisationService,
	    		false,
	    		conn);
    
		
		return getOrganisationServiceFromIdOrganigramNode(
				lIdOrganigramNode, 
				vOrganisationService, 
				vOrganigramOrganisationService, 
				vOrganigramNode);
	}
	
	public static OrganisationService getOrganisationServiceFromIdOrganigramNode(
			long lIdOrganigramNode,
			Vector<OrganisationService> vOrganisationService,
			Vector<Organigram> vOrganigramOrganisationService,
			Vector<OrganigramNode> vOrganigramNode) 
	throws CoinDatabaseLoadException 
	{
		for (OrganisationService os : vOrganisationService) 
		{
        	Organigram organigram = null;
			try{
				organigram = OrganisationService
        			.getOrganigramStatic(
        					os.getId(),
        					vOrganigramOrganisationService);
				
			} catch (CoinDatabaseLoadException e) {
				/**
				 * no organigram defined for this service, so continue to search
				 */
				continue;
			}
    	    
        	Vector<OrganigramNode> vOrganigramNodeTemp 
    	    	= OrganigramNode.getAllFromIdOrganigram( organigram.getId(), vOrganigramNode );
	        
        	for(OrganigramNode on : vOrganigramNodeTemp)
	        {
	        	if(on.getId() == lIdOrganigramNode)
	        	{
	        		return os;
	        	}
	        }
		} 
		
		return null;
	}
	
	public static Vector<OrganigramNode> getAllOrganigramNodeFromIndividual(
			long lIdOrganisation,
			long lIdIndividual,
			Connection conn)
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, InstantiationException,
	IllegalAccessException, NamingException, SQLException
	{
        return getAllOrganigramNodeFromObject(
        		lIdOrganisation, 
        		ObjectType.PERSONNE_PHYSIQUE, 
        		lIdIndividual, 
        		conn);	
	}
	
	public static Vector<OrganigramNode> getAllOrganigramNodeFromObject(
			long lIdOrganisation,
			long lIdTypeObject,
			long lIdReferenceObject,
			Connection conn)
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, InstantiationException,
	IllegalAccessException, NamingException, SQLException
	{
	    Vector<OrganisationService> vOrganisationServiceAll = null;
	    
	    vOrganisationServiceAll = OrganisationService.getAllFromIdOrganisation(
	    		lIdOrganisation,
	    		false,
	            conn);
	    
	    vOrganisationServiceAll = OrganisationService.filterOnlyWithOrganigram (vOrganisationServiceAll, false, conn );	
	    
	    Vector<Organigram> vOrganigramOrganisationService 
		    =  OrganisationService.getAllOrganigramStatic(vOrganisationServiceAll, false, conn);
	    
	    Vector<OrganigramNode> vOrganigramNodeAll = OrganisationService.getAllOrganigramNode(
	    		vOrganisationServiceAll,
	    		vOrganigramOrganisationService,
	    		false,
	    		conn);	

	    return getAllOrganigramNodeFromObject(vOrganigramNodeAll, lIdTypeObject, lIdReferenceObject);
	}

	public static Vector<OrganigramNode> getAllOrganigramNodeFromObject(
			Vector<OrganigramNode> vOrganigramNodeAll,
			long lIdTypeObject,
			long lIdReferenceObject)
	{
	    Vector<OrganigramNode> vON = new Vector<OrganigramNode>();
	    for (OrganigramNode on : vOrganigramNodeAll) {
	        if(on.getIdTypeObject() == lIdTypeObject
            && on.getIdReferenceObject() == lIdReferenceObject)
            {	
	        	vON.add(on);
            }
		}
	    return vON;
	}
	
	
	public static OrganisationService getOrganisationService(
       		long lId,  
       		boolean bUseHttpPrevent, 
       		Connection conn) 
       throws CoinDatabaseLoadException, SQLException, NamingException {
    	OrganisationService organisationService = new  OrganisationService(Long.valueOf(lId).intValue());
    	organisationService.bUseHttpPrevent = bUseHttpPrevent;
    	organisationService.load(conn);
       	
       	return organisationService;
    }

	
	public void removeWithObjectAttached(
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException 
	{
		try{
			Organigram organigram = getOrganigramStatic(this.lId, false, conn);
			organigram.removeWithObjectAttached(conn);
		} catch (Exception e) {
		}
		
		this.remove(conn);
	}
	
	public Vector <PersonnePhysique> getAllPersonnePhysiques (boolean bUseHttpPrevent, Connection conn)
	throws InstantiationException, IllegalAccessException, SQLException, NamingException, CoinDatabaseLoadException
	{
		Vector <PersonnePhysique> vPersonnes = new Vector <PersonnePhysique> ();
		for (Organigram organigram : Organigram.getAllFromObject(TypeObjetModula.ORGANISATION_SERVICE, lId, bUseHttpPrevent, conn))
			for (OrganigramNode node : OrganigramNode.getAllActivatedFromIdOrganigram(organigram.getId (), bUseHttpPrevent, conn))
				if (node.getIdTypeObject() == TypeObjetModula.PERSONNE_PHYSIQUE)
					vPersonnes.add (PersonnePhysique.getPersonnePhysique(node.getIdReferenceObject(), bUseHttpPrevent, conn));
		return vPersonnes;
	}
	
	public static JSONArray getAllWithPersonnes (long lIdOrganisation, boolean bUseHttpPrevent, Connection conn, long lIdLanguage)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, JSONException, CoinDatabaseLoadException
	{
		JSONArray jsonServices = new JSONArray ();
		for (OrganisationService service : OrganisationService.getAllFromIdOrganisation (lIdOrganisation, bUseHttpPrevent, conn)){
			JSONObject jsonService = service.toJSONObject();
			JSONArray jsonPersonnes = new JSONArray ();
			for (PersonnePhysique personne : service.getAllPersonnePhysiques (bUseHttpPrevent, conn)){
				PersonnePhysiqueCivilite civilite = PersonnePhysiqueCivilite.getPersonnePhysiqueCivilite(personne.getIdPersonnePhysiqueCivilite(), bUseHttpPrevent, lIdLanguage);
				jsonPersonnes.put (personne.toJSONObject()
						.put ("sCivilite", civilite.getName())
						.put ("sFullName", (civilite.getName() + " " + personne.getPrenomNom()).trim ())
				);
			}
			jsonService.put("personnes", jsonPersonnes);
			jsonServices.put (jsonService);
		}
		return jsonServices;
	}
	
	/** Order alphabetically **/
	public static Vector <OrganisationService> getOrganisationServicesOrderedAlphabetically (
			Collection <OrganisationService> vOrganisationServices)
	{
		switch (vOrganisationServices.size ()){
			case 0:
			return new Vector <OrganisationService> ();
				
			case 1:
			{
				Vector <OrganisationService> vOrdered = new Vector <OrganisationService> ();
				vOrdered.addAll (vOrganisationServices);
				return vOrdered;
			}

			default:
			{
				MultiMap <String, OrganisationService> map = new MultiMap <String, OrganisationService> ();
				for (OrganisationService service : vOrganisationServices)
					map.put(service.getNom(), service);
				return map.toVector();
			}
		}
	}
	
	/** Order hierarchically **/
	public static Vector <OrganisationService> getOrganisationServicesOrderedHierarchically (
			Collection <OrganisationService> vOrganisationServices,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, 
	CoinDatabaseLoadException, CoinDatabaseDuplicateException
	{
		switch (vOrganisationServices.size ()){
			case 0:
			return new Vector <OrganisationService> ();
				
			case 1:
			{
				Vector <OrganisationService> vOrdered = new Vector <OrganisationService> ();
				vOrdered.addAll (vOrganisationServices);
				return vOrdered;
			}
	
			default:
			{
				Map <Long, OrganisationService> services = new HashMap <Long, OrganisationService> ();
				for (OrganisationService service : vOrganisationServices)
					services.put (service.getId(), service);
				
				Collection <OrganigramNode> nodes = getNodes (vOrganisationServices, conn);
				for (OrganigramNode node : nodes)
					node.setName (services.get(node.getIdReferenceObject()).getNom ());
				
				Vector <OrganisationService> vResult = new Vector <OrganisationService> ();
				for (OrganigramNode node : OrganigramNode.orderNodesHierarchic (nodes)){
					OrganisationService service = services.get(node.getIdReferenceObject());
					service.setName (node.getName ());
					vResult.add (service);
				}			
				return vResult;
			}
		}
	}
	
	protected static String getIdList (Collection <OrganisationService> organisationServices){
		String sIdList = "";
		int i = 0;
		for (OrganisationService service : organisationServices){
			sIdList += service.getId();
			if (++i < organisationServices.size())
				sIdList += ",";
		}
		return sIdList;
	}
	
	/** Nodes from services **/
	static protected Collection <OrganigramNode> getNodes (
			Collection <OrganisationService> organisationServices,
			Connection conn)
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, InstantiationException, 
	IllegalAccessException, NamingException, SQLException
	{
		OrganigramNode item = new OrganigramNode ();
		String sSqlQuery = 
		"select " + getSelectFieldsName (item.SELECT_FIELDS_NAME, "n.") + ", n." + item.FIELD_ID_NAME +
		"	from organisation_service s " +
		"	inner join organigram oo " +
		"		on oo.id_type_object = " + ObjectType.ORGANISATION +
		"			and oo.id_type_object_node = " + ObjectType.ORGANISATION_SERVICE + " and oo.id_reference_object = s.id_organisation " +
		"	inner join organigram_node n " +
		"		on n.id_organigram = oo.id_organigram and n.id_type_object = " + ObjectType.ORGANISATION_SERVICE +
		" 			and n.id_reference_object = s.id_organisation_service " +
		"	where s.id_organisation_service in (" + getIdList (organisationServices) + ")";

		return item.getAllWithSqlQuery(sSqlQuery,conn);
	}
	
	
	public static void main(String[] args) throws CoinDatabaseLoadException, 
	SQLException, NamingException, InstantiationException, IllegalAccessException {
     RemoteControlServiceConnection a = new RemoteControlServiceConnection(
         "jdbc:mysql://serveur24.matamore.com:3306/modula_test?","dba_account", "dba_account" );
     Connection conn = a.getConnexionMySQL();
     Vector<OrganisationService> vOS = getAllFromIdOrganisationByOwned(2860, false, conn);
     System.out.println("vOS : " + vOS.size());
     
     ConnectionManager.closeConnection(conn);
    }
	
	public static Vector<OrganisationService> getOrganisationServiceWithNodes(
			Vector<OrganisationService> vOrganisationServiceWithoutFilter,
			Vector<Organigram> vOrganigramOrganisationService,
			Vector<OrganigramNode> vOrganigramNodeWithNodes,
			long lIdOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseDuplicateException
	{
		Organisation organisation = Organisation.getOrganisation(lIdOrganisation, false, conn);
		Vector<OrganisationService> vOrganisationServiceWithNodes = new Vector<OrganisationService>();
		for(OrganisationService os : organisation.orderServices(vOrganisationServiceWithoutFilter, conn))
		{
			try{
				Organigram organigram
			     	= OrganisationService.getOrganigramStatic(
			     			os.getId(),
			     			vOrganigramOrganisationService);
			     
				Vector<OrganigramNode> vOrganigramNodeTemp 
		    	= OrganigramNode.getAllActivatedFromIdOrganigram( 
		    			organigram.getId(), 
		    			vOrganigramNodeWithNodes);
				
				if (vOrganigramNodeTemp.size()!=0)
				{
					vOrganisationServiceWithNodes.add(os);
				}
			} catch (Exception e) {
				Organisation org = Organisation.getOrganisation(os.getIdOrganisation(), false, conn);
				System.out.println("no organigram defined for the service " 
						+ os.getId() + " : " +os.getName() 
						+ " of " + org.getName() );
			}
		}  
	return vOrganisationServiceWithNodes;
	}

}
