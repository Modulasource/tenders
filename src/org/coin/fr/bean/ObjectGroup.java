/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;

import org.coin.db.*;
import org.coin.util.Outils;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class ObjectGroup extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;

	protected String sNom;
	protected String sAlias;
	protected String sDescription;
	protected String sEmail;
	protected long lIdGroupType;
	protected long lIdTypeObject;
	protected long lIdReferenceObject;
	protected long lIdTypeObjectHead;
	protected long lIdReferenceObjectHead;

	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		int i = 0;
		ps.setString(++i, this.sNom);
		ps.setString(++i, this.sAlias);
		ps.setString(++i, this.sDescription);
		ps.setString(++i, this.sEmail);
		ps.setLong(++i, this.lIdGroupType);
		ps.setLong(++i, this.lIdTypeObject);
		ps.setLong(++i, this.lIdReferenceObject);
		ps.setLong(++i, this.lIdTypeObjectHead);
		ps.setLong(++i, this.lIdReferenceObjectHead);

	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;
		this.sNom = rs.getString(++i);
		this.sAlias = rs.getString(++i);
		this.sDescription = rs.getString(++i);
		this.sEmail = rs.getString(++i);
		this.lIdGroupType = rs.getLong(++i);
		this.lIdTypeObject = rs.getLong(++i);
		this.lIdReferenceObject= rs.getLong(++i);
		this.lIdTypeObjectHead = rs.getLong(++i);
		this.lIdReferenceObjectHead = rs.getLong(++i);
	}

	public ObjectGroup() {
		init();
	}

	public ObjectGroup(int iIdObjectGroup) {
		init();
		this.lId = iIdObjectGroup;
	}

	public ObjectGroup(long lIdObjectGroup) {
		init();
		this.lId = lIdObjectGroup;
	}

	public void init() {

		this.TABLE_NAME = "object_group";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		this.SELECT_FIELDS_NAME
			= "nom,"
			+ "alias,"
			+ "description,"
			+ "email,"
			+ "id_object_group_type,"
			+ "id_type_object,"
			+ "id_reference_object,"
			+ "id_type_object_head,"
			+ "id_reference_object_head";

		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ;

		this.sNom = "";
		this.sAlias = "";
		this.sDescription = "";
		this.sEmail = "";

	}


	public long getIdGroupType() {
		return lIdGroupType;
	}

	public long getIdReferenceObject() {
		return lIdReferenceObject;
	}

	public long getIdReferenceObjectHead() {
		return lIdReferenceObjectHead;
	}
	public long getIdTypeObject() {
		return lIdTypeObject;
	}

	public long getIdTypeObjectHead() {
		return lIdTypeObjectHead;
	}

	public String getEmail() {
		return sEmail;
	}

	public void setAlias(String alias) {
		sAlias = alias;
	}

	public void setDescription(String description) {
		sDescription = description;
	}

	public void setEmail(String email) {
		sEmail = email;
	}

	public void setNom(String nom) {
		sNom = nom;
	}

	public void setIdGroupType(long idGroupType) {
		lIdGroupType = idGroupType;
	}

	public void setIdReferenceObject(long idReferenceObject) {
		lIdReferenceObject = idReferenceObject;
	}

	public void setIdReferenceObjectHead(long idReferenceObjectHead) {
		lIdReferenceObjectHead = idReferenceObjectHead;
	}

	public void setIdTypeObject(long idTypeObject) {
		lIdTypeObject = idTypeObject;
	}

	public void setIdTypeObjectHead(long idTypeObjectHead) {
		lIdTypeObjectHead = idTypeObjectHead;
	}

	public static ObjectGroup getObjectGroup(int iIdObjectGroup) throws Exception {
		return getObjectGroup( iIdObjectGroup);
	}
	public static ObjectGroup getObjectGroup(long iIdObjectGroup) throws Exception {
		ObjectGroup objectGroup = new ObjectGroup (iIdObjectGroup);
		objectGroup.load();
    	return objectGroup;
    }

	public void setFromFormUTF8(HttpServletRequest request, String sFormPrefix)
	{
		setFromForm(request, sFormPrefix);
		this.sNom= Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sNom"));
		this.sAlias= Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sAlias"));
		this.sDescription= Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sDescription"));
		this.sEmail = request.getParameter(sFormPrefix+"sEmail");
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix)	{
		this.sNom = request.getParameter(sFormPrefix+"sNom");
		this.sAlias = request.getParameter(sFormPrefix+"sAlias");
		this.sDescription = request.getParameter(sFormPrefix+"sDescription");
		this.sEmail = request.getParameter(sFormPrefix+"sEmail");
		this.lIdGroupType = Long.parseLong(request.getParameter(sFormPrefix+"lIdGroupType"));
		this.lIdTypeObject = Long.parseLong(request.getParameter(sFormPrefix+"lIdTypeObject"));
		this.lIdReferenceObject = Long.parseLong(request.getParameter(sFormPrefix+"lIdReferenceObject"));
		this.lIdTypeObjectHead = Long.parseLong(request.getParameter(sFormPrefix+"lIdTypeObjectHead"));
		this.lIdReferenceObjectHead = Long.parseLong(request.getParameter(sFormPrefix+"lIdReferenceObjectHead"));
	}

	public static Vector<ObjectGroup> getAllWithSqlQueryStatic(String sSQLQuery)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		ObjectGroup item = new ObjectGroup ();
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<ObjectGroup> getAllStatic()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		ObjectGroup item = new ObjectGroup ();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<ObjectGroup> getAllGroupObjectFromIdGroupType(int iIdObjectGroupType)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_object_group_type="+iIdObjectGroupType, "");
	}


	public static Vector<ObjectGroup> getAllGroupObjectFromIdGroupTypeAndObjectReference(
			long lIdObjectGroupType,
			long lIdTypeObjet,
			long lIdReferenceObjet)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithWhereAndOrderByClauseStatic(
				" WHERE id_object_group_type=" + lIdObjectGroupType
				+ " AND id_type_object = " + lIdTypeObjet
				+  " AND id_reference_object = " + lIdReferenceObjet,
				"");
	}

	@SuppressWarnings("unchecked")
	public static Vector<ObjectGroup> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		ObjectGroup item = new ObjectGroup();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}

	@Override
	public String getName() {
		return this.sNom;
	}


	public String getDescription() {
		return sDescription;
	}

	public String getAlias() {
		return sAlias;
	}


	public String getNom() {
		return sNom;
	}
}
