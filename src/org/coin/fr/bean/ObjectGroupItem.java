/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;

import org.coin.bean.ObjectType;
import org.coin.db.*;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class ObjectGroupItem extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;

	protected long lIdObjectGroup;
	protected long lIdTypeObject;
	protected long lIdReferenceObject;

	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		int i = 0;
		ps.setLong(++i, this.lIdObjectGroup);
		ps.setLong(++i, this.lIdTypeObject);
		ps.setLong(++i, this.lIdReferenceObject);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;
		this.lIdObjectGroup = rs.getLong(++i);
		this.lIdTypeObject = rs.getLong(++i);
		this.lIdReferenceObject = rs.getLong(++i);
	}

	public ObjectGroupItem() {
		init();
	}

	public ObjectGroupItem(long lIdObjectGroupItem) {
		init();
		this.lId = lIdObjectGroupItem;
	}

	public void init() {

		this.TABLE_NAME = "object_group_item";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		this.SELECT_FIELDS_NAME
				= "id_object_group,"
				+ "id_type_object,"
				+ "id_reference_object";

		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ;

		this.lIdObjectGroup = -1;
		this.lIdTypeObject = -1;
		this.lIdReferenceObject = -1;
	}

	public long getIdObjectGroup() {
		return lIdObjectGroup;
	}

	public long getIdReferenceObject() {
		return lIdReferenceObject;
	}

	public long getIdTypeObject() {
		return lIdTypeObject;
	}

	public void setIdObjectGroup(long idObjectGroup) {
		lIdObjectGroup = idObjectGroup;
	}

	public void setIdReferenceObject(long idReferenceObjet) {
		lIdReferenceObject = idReferenceObjet;
	}

	public void setIdTypeObject(long idTypeObjet) {
		lIdTypeObject = idTypeObjet;
	}


	public static ObjectGroupItem getObjectItem(long lIdObjectGroupItem) throws Exception {
		ObjectGroupItem objectGroupItem = new ObjectGroupItem (lIdObjectGroupItem);
		objectGroupItem.load();
    	return objectGroupItem;
    }

	public void setFromForm(HttpServletRequest request, String sFormPrefix)	{
		this.lIdObjectGroup = Integer.parseInt(request.getParameter(sFormPrefix+"lIdObjectGroup"));
		this.lIdTypeObject = Integer.parseInt(request.getParameter(sFormPrefix+"lIdTypeObject"));
		this.lIdReferenceObject = Integer.parseInt(request.getParameter(sFormPrefix+"lIdReferenceObject"));
	}

	public static Vector<ObjectGroupItem> getAllObjectGroupItemFromIdObjectGroupAndIdObject(int iIdObjectGroup, int iIdObject)
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
			return getAllWithWhereAndOrderByClauseStatic(
					" WHERE id_object_group=" + iIdObjectGroup
					+ " AND id_object="+iIdObject, "");
	}


	public static Vector<ObjectGroupItem> getAllObjectGroupItemFromIdObjectGroup(long lIdObjectGroup)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithWhereAndOrderByClauseStatic(
				" WHERE id_object_group=" + lIdObjectGroup
				, "");
}

	public static Vector<ObjectGroupItem> getAllWithSqlQueryStatic(String sSQLQuery)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		ObjectGroupItem item = new ObjectGroupItem ();
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<ObjectGroupItem> getAllStatic()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		ObjectGroupItem item = new ObjectGroupItem ();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	@SuppressWarnings("unchecked")
	public static Vector<ObjectGroupItem> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		ObjectGroupItem item = new ObjectGroupItem();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}

	@Override
	public String getName() {
		return "objectItem" + this.lId;
	}


	public static Vector<PersonnePhysique> getAllPersonnePhysique(Vector<ObjectGroupItem> vItems) throws Exception
	{
		Vector<PersonnePhysique> vPP = new Vector<PersonnePhysique>();
		for (int i = 0; i < vItems.size(); i++) {
			ObjectGroupItem item = vItems.get(i);
			if(item.getIdTypeObject() != ObjectType.PERSONNE_PHYSIQUE)
				throw new Exception ("le Vector d'items ne doit contenir que des personnes physiques.");

			vPP.add(PersonnePhysique.getPersonnePhysique(item.getIdReferenceObject()));

		}
		return vPP;

	}

}