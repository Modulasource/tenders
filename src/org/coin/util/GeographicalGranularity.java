/*
 * Matamore Software
 *
 */
package org.coin.util;

import java.sql.*;
import java.util.Vector;

import javax.naming.NamingException;

/**
 *
 */
public class GeographicalGranularity extends Enumerator {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final int COUNTRY = 1;
	public static final int ZONE = 2;
	public static final int SECTEUR = 3;
	
	public void setConstantes() {
		super.TABLE_NAME = "geographical_granularity";
		super.FIELD_ID_NAME  = "id_geographical_granularity";
		super.FIELD_NAME_NAME = "libelle";
		super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
	}
	/**
	 * 
	 */
	public GeographicalGranularity() {
		super();
		setConstantes();
	}
	
	/**
	 * @param iId
	 * @param sName
	 */
	public GeographicalGranularity(int iId, String sName) {
		super(iId, sName);
		setConstantes();
	}
	
	/**
	 * @param iId
	 */
	public GeographicalGranularity(int iId) {
		super(iId);
		setConstantes();
	}
	
	/**
	 * @param sName
	 */
	public GeographicalGranularity(String sName) {
		super(sName);
		setConstantes();
	}
	
	
    public GeographicalGranularity(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}

	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new GeographicalGranularity(iId, sName,bUseHttpPrevent);
	}

	/* (non-Javadoc)
	 * @see org.coin.util.Enumerator#getAll_onNewItem(int, java.lang.String)
	 */
	protected Enumerator getAll_onNewItem(int iId, String sName) {
		return new GeographicalGranularity(iId, sName);
	}
	
	/**
	 * Méthode renvoyant le libellé de l'item en bdd
	 * @param sId - identifiant 
	 * @return le libellé 
	 * @throws Exception 
	 */
	public static String getGeographicalGranularityName(String sId) throws Exception {
		GeographicalGranularity item = new GeographicalGranularity(sId);
		item.load();
		return item.getName();
	}
	/**
	 * Méthode renvoyant l'objet granularité géographique identifiée
	 * @param sId - identifiant de l'objet 
	 * @return un item
	 * @throws Exception 
	 */
	public static GeographicalGranularity getGeographicalGranularity(int iId) throws Exception {
		GeographicalGranularity item = new GeographicalGranularity(iId);
		item.load();
		return item ;
	}
	/**
	 * Méthode renvoyant tous les 
	 * @return a Vector of Geographical Granularities
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public static Vector getAllStatic() throws SQLException, NamingException
	{
		GeographicalGranularity item = new GeographicalGranularity();
		return item.getAllOrderById();
	}
}
