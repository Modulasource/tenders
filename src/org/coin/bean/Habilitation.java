/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.util.HttpUtil;
import org.coin.util.Outils;


public class Habilitation extends CoinDatabaseAbstractBeanMemory{    

	private static final long serialVersionUID = 1L;

	protected long lIdRole;
	protected String sIdUseCase;
	protected boolean bIsManageable;
	
	public static Vector<Habilitation> m_vHab = null;
	protected static Map<String,String>[] s_sarrLocalizationLabel;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setLong(++i, this.lIdRole);
		ps.setString(++i, this.sIdUseCase);
		ps.setBoolean(++i, this.bIsManageable);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.lIdRole = rs.getLong(++i);
		this.sIdUseCase = rs.getString(++i);
		this.bIsManageable = rs.getBoolean(++i);
	}
	
    public Habilitation() {
    	init();
    }
        
    public Habilitation(long lIdRole, String sIdUseCase) {
    	init();
    	this.lIdRole = lIdRole;
    	this.sIdUseCase = sIdUseCase;
    	
    }
    
    public Habilitation(long lId, long lIdRole, String sIdUseCase) {
    	this.lId = lId ;
    	this.lIdRole = lIdRole ;
    	this.sIdUseCase = sIdUseCase ;
    }
 
    public void init()
    {
    	super.TABLE_NAME = "habilitation";
    	super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		super.SELECT_FIELDS_NAME 
			= " id_coin_role,"
				+ " id_use_case,"
				+ " is_manageable";
		
		super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length ; 
		super.iAbstractBeanIdObjectType = ObjectType.HABILITATION;
		super.lId = 0;
	
		this.lIdRole = 0;
		this.sIdUseCase = "";
		this.bIsManageable = false;
    }
    
    public static ArrayList<Vector<UseCase>> getAllUseCaseFromIdUser(long iIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	return getAllUseCaseFromIdUser(iIdUser, false);
    }
    
    public static ArrayList<Vector<UseCase>> getAllUseCaseFromIdUser(long lIdUser, boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	Vector<Group> vGroups = UserGroup.getAllGroup(lIdUser);
    	return getAllUseCaseFromIdUser(vGroups, lIdUser, bUseDifferential);
    }

    @SuppressWarnings("unchecked")
	public static ArrayList<Vector<UseCase>> getAllUseCaseFromIdUser(Vector<Group> vGroups, long lIdUser, boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	Vector<UseCase> vUseCases = new Vector<UseCase>();
    	Vector<UseCase> vUseCasesManageable = new Vector<UseCase>();
    	Vector<UseCase> vUseCasesFinal = new Vector<UseCase>();
    	ArrayList<Vector<UseCase>> arrCUFinal = new ArrayList<Vector<UseCase>>();

    	for (int i = 0; i < vGroups.size(); i++)
    	{
			Group group = (Group) vGroups .get(i);
			ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdGroup((int)group.getId());
			Vector<UseCase> vUseCasesTemp = arrCU.get(0);
			Vector<UseCase> vUseCasesManageableTemp = arrCU.get(1);
			
			for (UseCase cu : vUseCasesTemp){
				vUseCases.add( cu );
			}
			for (UseCase cu : vUseCasesManageableTemp){
				vUseCasesManageable.add( cu );
			}
		}

    	if(!bUseDifferential)
    	{
    		vUseCases = CoinDatabaseUtil.distinct(vUseCases);
    		vUseCasesManageable = CoinDatabaseUtil.distinct(vUseCasesManageable);
    		
    		arrCUFinal.add(vUseCases);
    		arrCUFinal.add(vUseCasesManageable);
    		return arrCUFinal;
    	}

    	/*
    	 * Added by DK for V2
    	 **/
    	Vector<UseCase> vAllUseCases = UseCase.getAllStaticMemory();		

		try {
	    	Vector<UserUsecase> vUserUsecaseRemoved = UserUsecase.getAllFromIdUser(lIdUser, UserUsecaseType.TYPE_REMOVE);
	    	Vector<UserUsecase> vUserUsecaseAdded = UserUsecase.getAllFromIdUser(lIdUser, UserUsecaseType.TYPE_ADD);

	    	/***
	    	 * Ajout des UC suppl
	    	 */
	    	for (int i = 0; i < vUserUsecaseAdded .size(); i++)
	    	{
	    		UserUsecase uuc = (UserUsecase) vUserUsecaseAdded.get(i);

	    		try{
	    		     vUseCases.add(
	    				(UseCase) UseCase
	    					.getCoinDatabaseAbstractBeanFromIdString(uuc.getIdUseCase() , vAllUseCases) );

	    		} catch (CoinDatabaseLoadException e) {
	    			// Le Use case n'est pas reconnu comme un UC existant en BDD.
	    			// ce cas ne doit pas arriver
	    			e.printStackTrace();
				}

			}

	    	/***
	    	 * Filtrage des UC � supprimer
	    	 */

			for (int i = 0; i < vUseCases.size(); i++)
			{
				UseCase uc = vUseCases.get(i);
				boolean bAddUseCase = true;

		    	for (int j = 0; j < vUserUsecaseRemoved .size(); j++)
		    	{
		    		UserUsecase uuc = (UserUsecase) vUserUsecaseRemoved.get(j);
		    		if(uuc.getIdUseCase().equals(uc.getIdString()))
		    		{
		       			bAddUseCase = false;
		    			break;
		    		}

				}

		    	if(bAddUseCase)
		    	{
		    		vUseCasesFinal.add( uc );

		    	}

			}
		} catch (InstantiationException e) {
		} catch (IllegalAccessException e) {
		}
		
		vUseCasesFinal = CoinDatabaseUtil.distinct(vUseCasesFinal);
		vUseCasesManageable = CoinDatabaseUtil.distinct(vUseCasesManageable);
		arrCUFinal.add(vUseCasesFinal);
		arrCUFinal.add(vUseCasesManageable);
		
    	return arrCUFinal;
    }
    
    public static ArrayList<Vector<UseCase>> getAllUseCaseFromIdGroup(int iIdGroup) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	ArrayList<Vector<UseCase>> arrCU = new ArrayList<Vector<UseCase>>();
    	
    	Vector<Role> vRoles = GroupRole.getAllRole(iIdGroup);
    	Vector<UseCase> vUseCases = new Vector<UseCase>();
    	Vector<UseCase> vUseCasesManageable = new Vector<UseCase>();
    	
    	for (int i = 0; i < vRoles.size(); i++) 
    	{
			Role role = (Role) vRoles.get(i);
			Vector<Habilitation> vHab = Habilitation.getAllFromRoleMemory(role.getId());
			for (Habilitation hab : vHab) 
			{
				UseCase cu = UseCase.getUseCaseMemory(hab.getIdUseCase());
				vUseCases.add( cu ); 
				
				if(hab.bIsManageable) vUseCasesManageable.add(cu);
			}
		}
    	
    	arrCU.add(vUseCases);
    	arrCU.add(vUseCasesManageable);
    	return arrCU;
    }
   
    @SuppressWarnings("unchecked")
	public static Vector<UseCase> getAllUseCase(int iIdRole) throws NamingException, SQLException
	{
    	UseCase usecase = new UseCase();
    	String sSQLQuery = "SELECT usecase." + usecase.FIELD_NAME_NAME
						+ ", usecase." + usecase.FIELD_ID_NAME
    					+ " FROM " + usecase.TABLE_NAME + " usecase, habilitation hab "
						+ " WHERE usecase." + usecase.FIELD_ID_NAME+ "=" + "hab.id_use_case"
						+ " AND hab.id_coin_role=" + iIdRole;
    	return usecase.getAllWithSQLQuery(sSQLQuery);
	}
    
    public static void updateManageable(long iIdRole, HttpServletRequest request) throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseStoreException{
    	Vector<Habilitation> vHabCU = Habilitation.getAllFromRoleMemory(iIdRole);
    	for(Habilitation hab : vHabCU){
    		int iManageable = HttpUtil.parseInt("manageable_"+hab.getId(), request,0);
    		boolean bIsManageable = (iManageable==1);
    		if(bIsManageable != hab.isManageable()){
    			hab.setManageable(bIsManageable);
    			hab.store();
    		}
    	}
    }

    public static void createByStringList(int iIdRole, Vector<String> vStringList ) throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException
	{
    	for(int i =0; i < vStringList.size(); i++)
    	{
    		String sIdUseCase = (String) vStringList.get(i);
    		Habilitation hab = new Habilitation (iIdRole, sIdUseCase);
    		hab.create();
    	}
    }

    public static void removeByStringList(int iIdRole, Vector<String> vStringList ) throws SQLException, NamingException
	{
    	Habilitation hab = new Habilitation();
    	for(int i =0; i < vStringList.size(); i++)
    	{
    		String sIdUseCase = (String) vStringList.get(i);
        	String sSQLQuery = " WHERE id_coin_role=" + iIdRole
					+ " AND id_use_case = '" + sIdUseCase + "'" ;
	
        	hab.remove(sSQLQuery);
    	}
    }

	public static void removeAllByUseCasePrefix(int iIdRole, String sUseCasePrefix) throws SQLException, NamingException
	{
		Habilitation hab = new Habilitation();
        String sSQLQuery = " WHERE id_coin_role=" + iIdRole
					+ " AND id_use_case LIKE '" + sUseCasePrefix + "%' ";

        hab.remove(sSQLQuery);
    }

	public static void removeAllFromUseCase(String sIdUseCase) throws SQLException, NamingException
	{
		Habilitation hab = new Habilitation();
        String sSQLQuery = " WHERE id_use_case = '" + sIdUseCase + "' ";

        hab.remove(sSQLQuery);
    }
	
    public static void removeAllByIdRole(int iIdRole) throws SQLException, NamingException
    {
    	Habilitation hab = new Habilitation();
        String sSQLQuery = " WHERE id_coin_role=" + iIdRole;

        hab.remove(sSQLQuery);
    }

	public String getName() {
		return null;
	}
	
	public static Vector<Habilitation> getAllWithSqlQueryStatic(String sSQLQuery,boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Habilitation item = new Habilitation (); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<Habilitation> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,boolean bUseHttpPrevent)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		Habilitation item = new Habilitation(); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	public static Vector<Habilitation> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Habilitation item = new Habilitation (); 
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item); 
	}
	
	public static Vector<Habilitation> getAllFromUseCase(String sIdUseCase) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_use_case='"+sIdUseCase+"'","",true);
	}
	
    public static Vector<Habilitation> getAllFromUseCaseMemory(String sIdUseCase) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	Vector<Habilitation> vItems = getAllStaticMemory();
    	Vector<Habilitation> vItemsReturn = new Vector<Habilitation>();
    	for (Habilitation item : vItems) {
        	if(item.getIdUseCase().equalsIgnoreCase(sIdUseCase))
        		vItemsReturn.add(item);
		}

    	return vItemsReturn;
	}
    
    public static Vector<Habilitation> getAllFromRoleMemory(long iIdRole) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	Vector<Habilitation> vItems = getAllStaticMemory();
    	Vector<Habilitation> vItemsReturn = new Vector<Habilitation>();
    	for (Habilitation item : vItems) {
        	if(item.getIdRole()== iIdRole)
        		vItemsReturn.add(item);
		}

    	return vItemsReturn;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		this.lIdRole= Long.parseLong(request.getParameter(sFormPrefix + "lIdRole"));
		this.sIdUseCase= request.getParameter(sFormPrefix + "sIdUseCase");
	}

	public long getIdRole() {
		return lIdRole;
	}

	public void setIdRole(long idRole) {
		lIdRole = idRole;
	}

    public String getIdRoleLabel() {
		return getIdRoleLabel("Role");
	}
	public String getIdRoleLabel(String sDefaultValue) {
		return getLocalizedLabel("lIdRole",sDefaultValue);
	}
	
	public String getIdUseCase() {
		return sIdUseCase;
	}

	public void setIdUseCase(String idUseCase) {
		sIdUseCase = idUseCase;
	}
	
    public String getIdUseCaseLabel() {
		return getIdUseCaseLabel("Cas d'utilisation");
	}
	public String getIdUseCaseLabel(String sDefaultValue) {
		return getLocalizedLabel("sIdUseCase",sDefaultValue);
	}
	
	public boolean isManageable() {
		return this.bIsManageable;
	}

	public void setManageable(boolean bIsManageable) {
		this.bIsManageable = bIsManageable;
	}
	
    public String getIsManageableLabel() {
		return getIsManageableLabel("Administrable");
	}
	public String getIsManageableLabel(String sDefaultValue) {
		return getLocalizedLabel("bIsManageable",sDefaultValue);
	}
	
	public void populateMemory() throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		m_vHab = getAllStatic();
	}
    
	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return (Vector<T>) getAllStaticMemory();
	}
	
	public static Vector<Habilitation> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	reloadMemoryStatic(new Habilitation());
    	return m_vHab;
    }

    public static Habilitation getHabilitationMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector<Habilitation> vItems = getAllStaticMemory();

    	for (Habilitation item : vItems) {
        	if(item.getId()==lId) return item;
		}

    	throw new CoinDatabaseLoadException("" + lId, "static");
    }

    public Vector<Habilitation> getItemMemory() {
		return m_vHab;
	}
	
	public String getLocalizedLabel(String sFieldName, String sDefaultValue) {
		String sValue = sDefaultValue;
		try{sValue = getLocalizedLabel(sFieldName);}
		catch(Exception e){sValue = sDefaultValue;}
		if(Outils.isNullOrBlank(sValue))
			sValue = sDefaultValue;
		
		return sValue;
	}

	public String getLocalizedLabel(String sFieldName) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);
	}
	

    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
}

