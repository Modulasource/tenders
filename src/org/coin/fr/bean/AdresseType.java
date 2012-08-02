/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.util.Enumerator;


/**
 * @author julien
 * @version last updated: 05/08/2005
 */
public class AdresseType extends Enumerator 
{
	private static final long serialVersionUID = 1L;

	public static final int LIVRAISON = 1;
	public static final int EXECUTION = 2;
	public static final int FACTURATION = 3;
	
	public void setConstantes(){
        super.TABLE_NAME = "adresse_type";
        super.FIELD_ID_NAME  = "id_adresse_type";
        super.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
   }
    
    public AdresseType() {
        super();
        setConstantes();
    }
    
    public AdresseType(String sName) {
        super(sName);
        setConstantes();
    }
    
    public AdresseType(int iId) {
        super(iId);
        setConstantes();
    }
    
    public AdresseType(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
    public static AdresseType getAdresseType(int iId) throws Exception
	{
    	AdresseType adresseType = new AdresseType(iId);
    	adresseType.load();
		return adresseType;
	}
    
    public AdresseType(int iId, String sName,boolean bUseHttpPrevent) {
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
		return new AdresseType(iId, sName,bUseHttpPrevent);
	}

    public static String getAdresseTypeName(int iId) throws Exception {
    	AdresseType adresseType = new AdresseType(iId);
    	adresseType.load();
    	return adresseType.getName();
    }
    

    public static Vector getAllAdresseType() throws SQLException, NamingException
	{
    	AdresseType adresseType = new AdresseType();
		return adresseType.getAll();
	}
}
