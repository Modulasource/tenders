/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ObjectLocalization;
import org.coin.util.Enumerator;

/** 
 * 
 */
public class OrganisationType extends Enumerator {    
    
	private static final long serialVersionUID = 1L;
    protected static String[][] s_sarrLocalization;

	//FLON: DK=>JR = 0 pour TYPE_ACHETEUR_PUBLIC , merci flon. Tu as une idée ?
	//FIXME: on pourrait faire un script de maj mais il faut verifier que le parametre
	// est toujours passé avec la constante...
	public static final int TYPE_ACHETEUR_PUBLIC = 0;
	public static final int TYPE_CANDIDAT = 1;
	public static final int TYPE_CONSULTANT = 2;
	public static final int TYPE_PUBLICATION = 3;
	public static final int TYPE_ADMINISTRATEUR = 4;
	/** servait pour la demo à Paru Vendu */
	public static final int TYPE_ANNONCEUR = 5;
	public static final int TYPE_PARTICULIER = 6;

	/** VFR CONSTANT */
	public static final int TYPE_BUSINESS_UNIT = 100;
	public static final int TYPE_CLIENT = 101;
	public static final int TYPE_FOURNISSEUR = 102;
	public static final int TYPE_HEAD_QUARTER = 103;
	public static final int TYPE_EXTERNAL_COMPANY = 104;
	public static final int TYPE_TRAIN_CUSTOMER = 105;
	public static final int TYPE_LEASING_COMPANY = 106;
	public static final int TYPE_MAINTENANCE_COMPANY = 107;
	
	/**
	 * paraph
	 */
	public static final int TYPE_EXTERNAL = 200;
	public static final int TYPE_EXTERNAL_CASUAL = 201;
	
	
	public void setConstantes(){
        super.TABLE_NAME = "organisation_type";
        super.FIELD_ID_NAME  = "id_organisation_type";
        super.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
        super.iAbstractBeanIdObjectType = ObjectType.ORGANISATION_TYPE;
    }
    
    public OrganisationType() {
        super();
        setConstantes();
    }
    
    public OrganisationType(String sName) {
        super(sName);
        setConstantes();
    }
    
    public OrganisationType(int iId) {
        super(iId);
        setConstantes();
    }
    
    public OrganisationType(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
    public OrganisationType(int iId, String sName,boolean bUseHttpPrevent) {
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
		return new OrganisationType(iId, sName,bUseHttpPrevent);
	}

    public static String getOrganisationTypeName(int iId) throws Exception {
    	OrganisationType item = new OrganisationType(iId);
    	item.load();
    	return item.getName();
    }
    

    public static Vector<OrganisationType> getAllOrganisationType() throws SQLException, NamingException
	{
    	OrganisationType item = new OrganisationType();
		return item.getAll();
	}

    public static OrganisationType getOrganisationType(int iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	OrganisationType item = new OrganisationType(iId);
    	item.load();
		return item;
	}
    
    public static OrganisationType getOrganisationType(
    		long lId,
    		Vector<OrganisationType> v)
    throws CoinDatabaseLoadException 
	{
    	for (OrganisationType ot : v) {
			if(ot.getId() == lId) return ot;
		}
    	throw new CoinDatabaseLoadException("not found " + lId, "");
	}
    

    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sName;
    		return s;
    	}
        return this.sName;
    }

    
    @Override
    public String getLocalizedName(Connection conn) {
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }
    	
	
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}
	

}

