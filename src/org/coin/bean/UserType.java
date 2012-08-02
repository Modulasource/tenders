/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean ;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.fr.bean.OrganisationType;
import org.coin.util.Enumerator;

/** Cette classe permet de gérer les statuts des utilisateurs
 * @author Robert Xavier Montori
 */
@SuppressWarnings("unchecked")
public class UserType extends Enumerator implements Serializable{    
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final int TYPE_PRM = 0;
	public static final int TYPE_CANDIDAT = 1;
	public static final int TYPE_CONSULTANT = 2;
	public static final int TYPE_PUBLICATION = 3;
	public static final int TYPE_ADMINISTRATEUR = 4;
	public static final int TYPE_SYSTEME = 5;
	public static final int TYPE_REDACTEUR_PA = 6;
	
	public static final int TYPE_BUSINESS_UNIT = 100;
	public static final int TYPE_CLIENT = 101;
	public static final int TYPE_FOURNISSEUR = 102;
	public static final int TYPE_HEAD_QUARTER = 103;
	public static final int TYPE_TRAIN_CUSTOMER = 105;

	public void setConstantes(){
        super.TABLE_NAME = "coin_user_type";
        super.FIELD_ID_NAME = "id_coin_user_type";
        super.FIELD_NAME_NAME = "name";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
    }
    
    public UserType() {
        super();
        setConstantes();
    }
    
    public UserType(String sName) {
        super(sName);
        setConstantes();
    }
    
    public UserType(int iId) {
        super(iId);
        setConstantes();
    }
    
    public UserType(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
	public UserType(int iId, String sName,boolean bUseHttpPrevent) {
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
		return new UserType(iId, sName,bUseHttpPrevent);
	}

    public static String getUserTypeName(int iId) throws Exception {
    	UserType type = new UserType(iId);
    	type.load();
    	return type.getName();
    }
    

    public static Vector getAllUserType() throws SQLException, NamingException
	{
    	UserType type = new UserType();
		return type.getAll();
	}

    public static UserType getUserType(int iId) throws Exception
	{
    	UserType type = new UserType(iId);
    	type.load();
		return type;
	}
    
    public static int getIdUserTypeFromOrganisationType(int iIdOrganisationType) throws Exception
    {
    	int iIdUserType = -1;
    	
    	switch(iIdOrganisationType)
    	{
    		case OrganisationType.TYPE_ACHETEUR_PUBLIC:
    			iIdUserType = TYPE_PRM;
    			break;
    		case OrganisationType.TYPE_ADMINISTRATEUR:
    			iIdUserType = TYPE_ADMINISTRATEUR;
    			break;
    		case OrganisationType.TYPE_ANNONCEUR:
    			//FIXME: est ce le bon type?  
    			iIdUserType = TYPE_REDACTEUR_PA;
    			break;
    		case OrganisationType.TYPE_CANDIDAT:
    			iIdUserType = TYPE_CANDIDAT;
    			break;
    		case OrganisationType.TYPE_CONSULTANT:
    			iIdUserType = TYPE_CONSULTANT;
    			break;
    		case OrganisationType.TYPE_PUBLICATION:
    			iIdUserType = TYPE_PUBLICATION;
    			break;
    		case OrganisationType.TYPE_BUSINESS_UNIT:
    			iIdUserType = TYPE_BUSINESS_UNIT;
    			break;
    		case OrganisationType.TYPE_CLIENT:
    			iIdUserType = TYPE_CLIENT;
    			break;
    		case OrganisationType.TYPE_TRAIN_CUSTOMER:
    			iIdUserType = TYPE_TRAIN_CUSTOMER;
    			break;
    		case OrganisationType.TYPE_FOURNISSEUR:
    			iIdUserType = TYPE_FOURNISSEUR;
    			break;
    		case OrganisationType.TYPE_HEAD_QUARTER:
    			iIdUserType = TYPE_HEAD_QUARTER;
    			break;
    	}
    	
    	return iIdUserType;
    }

}

