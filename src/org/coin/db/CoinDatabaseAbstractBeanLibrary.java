/****************************************************************************
Studio Matamore - France 2005
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.db;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;

/**
 * Gestion des librairies
 * @author julien
 *
 */
public abstract class CoinDatabaseAbstractBeanLibrary extends CoinDatabaseAbstractBean
{
	private static final long serialVersionUID = 1L;
	
	protected long lIdOwnedObject ;
	protected int iIdOwnerTypeObject ;
	protected long lIdOwnerReferenceObject ;
	
	protected String TABLE_OWNED_OBJECT;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setLong(++i, this.lIdOwnedObject);
		ps.setInt(++i, this.iIdOwnerTypeObject);
		ps.setLong(++i, this.lIdOwnerReferenceObject);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;
		this.lIdOwnedObject = rs.getLong(++i);
		this.iIdOwnerTypeObject = rs.getInt(++i);
		this.lIdOwnerReferenceObject = rs.getLong(++i);
	}
	
	public long getIdOwnedObject() {
		return this.lIdOwnedObject;
	}
	public int getIdOwnerTypeObject() {
		return this.iIdOwnerTypeObject;
	}
	public long getIdOwnerReferenceObject() {
		return this.lIdOwnerReferenceObject;
	}
	
	public void setIdOwnedObjet(long lIdOwnedObject) {
		this.lIdOwnedObject = lIdOwnedObject;
	}
	public void setIdOwnerTypeObject(int iIdOwnerTypeObject) {
		this.iIdOwnerTypeObject = iIdOwnerTypeObject;
	}
	public void setIdOwnerReferenceObject(long lIdOwnerReferenceObject) {
		this.lIdOwnerReferenceObject = lIdOwnerReferenceObject;
	}

	public <T>Vector<T> getAllFromOwnerTypeAndReferenceObjectNonStatic(int iIdTypeObjet, long lIdReferenceObjet) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_type_objet=" + iIdTypeObjet
		+ " AND id_reference_objet=" + lIdReferenceObjet;
		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectNonStatic(long lIdOwnedObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + lIdOwnedObject;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public void removeAllFromOwnedObjectNonStatic(long lIdOwnedObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sWhereClause = " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + lIdOwnedObject;
		this.remove(sWhereClause);
	}
	
	public void removeAllFromOwnerObjectNonStatic() throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sWhereClause = " WHERE id_type_objet=" + this.iIdOwnerTypeObject
		+ " AND id_reference_objet=" + this.lIdOwnerReferenceObject;
		this.remove(sWhereClause);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectAndOwnerTypeObjectNonStatic(long lIdOwnedObject, int iIdOwnerTypeObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + lIdOwnedObject
		+ " AND id_type_objet=" + iIdOwnerTypeObject;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectAndOwnerReferenceAndTypeObjectNonStatic(long lIdOwnedObject, long lIdOwnerReferenceObjet, int iIdOwnerTypeObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + lIdOwnedObject
		+ " AND id_type_objet=" + iIdOwnerTypeObject
		+ " AND id_reference_objet=" + lIdOwnerReferenceObjet;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public void init()
	{
		this.SELECT_FIELDS_NAME 
			= " id_"+this.TABLE_OWNED_OBJECT+","
			+ " id_type_objet,"
			+ " id_reference_objet";
			
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
	
		this.lId = 0;
		this.lIdOwnedObject = 0;
		this.iIdOwnerTypeObject = 0;
		this.lIdOwnerReferenceObject = 0;	
	}
	
	public abstract void setFromForm(HttpServletRequest request, String sFormPrefix);
}
