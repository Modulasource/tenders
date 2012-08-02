/****************************************************************************
Studio Matamore - France 2005
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.util;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;

/**
 * Gestion des librairies de médias
 * @author julien
 *
 */
public abstract class ObjectLibrary extends CoinDatabaseAbstractBean
{
	private static final long serialVersionUID = 1L;
	
	protected int iIdOwnedObject ;
	protected int iIdOwnerTypeObject ;
	protected int iIdOwnerReferenceObject ;
	
	protected String TABLE_OWNED_OBJECT;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setInt(++i, this.iIdOwnedObject);
		ps.setInt(++i, this.iIdOwnerTypeObject);
		ps.setInt(++i, this.iIdOwnerReferenceObject);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;
		this.iIdOwnedObject = rs.getInt(++i);
		this.iIdOwnerTypeObject = rs.getInt(++i);
		this.iIdOwnerReferenceObject = rs.getInt(++i);
	}
	
	public int getIdOwnedObject() {
		return this.iIdOwnedObject;
	}
	public int getIdOwnerTypeObject() {
		return this.iIdOwnerTypeObject;
	}
	public int getIdOwnerReferenceObject() {
		return this.iIdOwnerReferenceObject;
	}
	
	public void setIdOwnedObjet(int iIdOwnedObject) {
		this.iIdOwnedObject = iIdOwnedObject;
	}
	public void setIdOwnerTypeObject(int iIdOwnerTypeObject) {
		this.iIdOwnerTypeObject = iIdOwnerTypeObject;
	}
	public void setIdOwnerReferenceObject(int iIdOwnerReferenceObject) {
		this.iIdOwnerReferenceObject = iIdOwnerReferenceObject;
	}

	public <T>Vector<T> getAllFromOwnerTypeAndReferenceObjectNonStatic(int iIdTypeObjet, int iIdReferenceObjet) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_type_objet=" + iIdTypeObjet
		+ " AND id_reference_objet=" + iIdReferenceObjet;
		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectNonStatic(long iIdOwnedObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + iIdOwnedObject;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public void removeAllFromOwnedObjectNonStatic(long iIdOwnedObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sWhereClause = " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + iIdOwnedObject;
		this.remove(sWhereClause);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectAndOwnerTypeObjectNonStatic(int iIdOwnedObject, int iIdOwnerTypeObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + iIdOwnedObject
		+ " AND id_type_objet=" + iIdOwnerTypeObject;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public <T>Vector<T> getAllFromOwnedObjectAndOwnerReferenceAndTypeObjectNonStatic(int iIdOwnedObject, int iIdOwnerReferenceObjet, int iIdOwnerTypeObject) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		String sSqlQuery = "SELECT "+this.getSelectFieldsName("") + ", " + this.FIELD_ID_NAME 
		+ " FROM "+this.TABLE_NAME
		+ " WHERE id_"+this.TABLE_OWNED_OBJECT+"=" + iIdOwnedObject
		+ " AND id_type_objet=" + iIdOwnerTypeObject
		+ " AND id_reference_objet=" + iIdOwnerReferenceObjet;

		return this.getAllWithSqlQuery(sSqlQuery);
	}
	
	public void init()
	{
		this.SELECT_FIELDS_NAME 
			= " id_"+this.TABLE_OWNED_OBJECT+","
			+ " id_type_objet,"
			+ " id_reference_objet";
			
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
	
		this.lId = -1;
		this.iIdOwnedObject = 0;
		this.iIdOwnerTypeObject = 0;
		this.iIdOwnerReferenceObject = 0;	
	}
	
	public abstract void setFromForm(HttpServletRequest request, String sFormPrefix);
}
