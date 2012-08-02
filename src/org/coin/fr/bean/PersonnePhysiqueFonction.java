/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.Enumerator;


/**
 * @author julien
 * @version last updated: 05/08/2005
 */
public class PersonnePhysiqueFonction extends Enumerator 
{
	private static final long serialVersionUID = 1L;

	public static final int PRM = 1;
	public static final int DELEGUE_PRM = 2;
	public static final int RESP_ADMIN = 3;
	public static final int RESP_TECH = 4;
	public static final int DOCUMENTALISTE = 5;
	public static final int RECIPIENDAIRE = 6;
	public static final int CONSULTANT = 7;
	public static final int RESP_ADMIN_ET_TECH = 8;
	public static final int INFORMATEUR = 9;
	public static final int FISCALITE = 10;
	public static final int PROTECTION_ENVIRONNEMENT = 11;
	public static final int PROTECTION_EMPLOI = 12;
	
	public void setConstantes(){
        super.TABLE_NAME = "personne_physique_fonction";
        super.FIELD_ID_NAME  = "id_personne_physique_fonction";
        super.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
   }
    
    public PersonnePhysiqueFonction() {
        super();
        setConstantes();
    }
    
    public PersonnePhysiqueFonction(String sName) {
        super(sName);
        setConstantes();
    }
    
    public PersonnePhysiqueFonction(int iId) {
        super(iId);
        setConstantes();
    }
    
    public PersonnePhysiqueFonction(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
    public PersonnePhysiqueFonction(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName)
	{
		return getAll_onNewItem(iId,sName,true);
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new PersonnePhysiqueFonction(iId, sName,bUseHttpPrevent);
	}

    public static String getPersonnePhysiqueFonctionName(int iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	PersonnePhysiqueFonction item = new PersonnePhysiqueFonction(iId);
    	item.load();
    	return item.getName();
    }
    

    
    public static String getPersonnePhysiqueFonctionName(
    		int iId,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException
    {
    	PersonnePhysiqueFonction item = new PersonnePhysiqueFonction(iId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
    	return item.getName();
    }
    
    
    public static Vector getAllPersonnePhysiqueFonction() throws SQLException, NamingException
	{
    	PersonnePhysiqueFonction ppFonction = new PersonnePhysiqueFonction();
		return ppFonction.getAll();
	}
    
    public static PersonnePhysiqueFonction getPersonnePhysiqueFonction(int iId) throws Exception
	{
    	PersonnePhysiqueFonction ppFonction = new PersonnePhysiqueFonction(iId);
    	ppFonction.load();
		return ppFonction;
	}

}
