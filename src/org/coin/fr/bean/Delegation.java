
/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBeanTimeStamped;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.util.BitField;
import org.coin.util.CalendarUtil;
import org.coin.util.HttpUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Delegation extends CoinDatabaseAbstractBeanTimeStamped {

    private static final long serialVersionUID = 1L;

    protected long lIdPersonnePhysiqueOwner;
    protected long lIdPersonnePhysiqueDelegate;
    protected int iIdDelegationType;
    protected int iIdDelegationState;
    protected Timestamp tsDateStart;
    protected Timestamp tsDateEnd;
    protected BigInteger biStatuts;
    protected String sSignTemplate;
    
    public static final int ID_STATUT_PRIVATE = 1;
	public static final int ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS = 2;
	public static final int STATUT_MAX_ID = 2;
	
	public static final int GROUP_DELEGATION_PARAPH = 208;
	
	protected static Map<String,String>[] s_sarrLocalizationLabel;


    public Delegation() {
        init();
    }

    public Delegation(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "delegation";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_personne_physique_owner,"
                + " id_personne_physique_delegate,"
                + " id_delegation_type,"
                + " id_delegation_state,"
                + " date_creation,"
                + " date_start,"
                + " date_end,"
                + " statuts,"
                + " sign_template";
        
        this.iAbstractBeanIdObjectType = ObjectType.DELEGATION;

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdPersonnePhysiqueOwner = 0;
        this.lIdPersonnePhysiqueDelegate = 0;
        this.iIdDelegationType = 0;
        this.iIdDelegationState = DelegationState.STATE_ACTIVATED;
        super.tsDateCreation = null;
        this.tsDateStart = null;
        this.tsDateEnd = null;
        this.biStatuts = new BigInteger(new byte[] {0x00, 0x00, 0x00, 0x00, 0x00, 0x00});
        this.sSignTemplate = "";
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdPersonnePhysiqueOwner);
        ps.setLong(++i, this.lIdPersonnePhysiqueDelegate);
        ps.setInt(++i, this.iIdDelegationType);
        ps.setInt(++i, this.iIdDelegationState);
        ps.setTimestamp(++i, super.tsDateCreation);
        ps.setTimestamp(++i, this.tsDateStart);
        ps.setTimestamp(++i, this.tsDateEnd);
        ps.setBytes(++i, BitField.getStatusFormated (this.biStatuts) );
        ps.setString(++i, preventStore(this.sSignTemplate));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdPersonnePhysiqueOwner = rs.getLong(++i);
        this.lIdPersonnePhysiqueDelegate = rs.getLong(++i);
        this.iIdDelegationType = rs.getInt(++i);
        this.iIdDelegationState = rs.getInt(++i);
        super.tsDateCreation = rs.getTimestamp(++i);
        this.tsDateStart = rs.getTimestamp(++i);
        this.tsDateEnd = rs.getTimestamp(++i);
        byte[] bytesStatus = rs.getBytes(++i);
		if(bytesStatus == null)
		{
			this.biStatuts = new BigInteger ( new byte[] {0x00, 0x00, 0x00, 0x00, 0x00, 0x00});
		}
		else 
		{
			this.biStatuts = new BigInteger ( bytesStatus);
		}
		this.sSignTemplate = preventLoad(rs.getString(++i));
    }

    public static Delegation getDelegation(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        Delegation item = new Delegation(lId);
        item.load();
        return item;
    }
    
    public static Delegation getDelegation(long lId,boolean bUseHttpPrevent,Connection conn) throws CoinDatabaseLoadException, SQLException, NamingException {
        Delegation item = new Delegation(lId);
        item.bUseHttpPrevent = bUseHttpPrevent;
        item.load(conn);
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdPersonnePhysiqueOwner = Long.parseLong(request.getParameter(sFormPrefix + "lIdPersonnePhysiqueOwner"));
        } catch(Exception e){}
        try {
            this.lIdPersonnePhysiqueDelegate = Long.parseLong(request.getParameter(sFormPrefix + "lIdPersonnePhysiqueDelegate"));
        } catch(Exception e){}
        try {
            this.iIdDelegationType = Integer.parseInt(request.getParameter(sFormPrefix + "iIdDelegationType"));
        } catch(Exception e){}
        try {
            this.iIdDelegationState = Integer.parseInt(request.getParameter(sFormPrefix + "iIdDelegationState"));
        } catch(Exception e){}
        try {
            this.tsDateStart = CalendarUtil.getConversionTimestamp(request.getParameter(sFormPrefix + "tsDateStart"), "dd/MM/yyyy");
        } catch(Exception e){}
        try {
            this.tsDateEnd = CalendarUtil.getConversionTimestamp(request.getParameter(sFormPrefix + "tsDateEnd"), "dd/MM/yyyy");
        } catch(Exception e){}
        try {
            this.sSignTemplate = HttpUtil.parseStringBlank("sSignTemplate", request);
        } catch(Exception e){}
        
        this.setPrivate(false);
        this.setDelegatorInCopyOfNotifications (false);
        this.setFromFormStatus(request, "delegation_statut_");
    }
    
    
    public void setFromFormStatus(HttpServletRequest request,String sFormPrefix){
    	Vector<Vector<String>> vStatuts = getAllStatus(STATUT_MAX_ID);
		for(Vector<String> vStatut : vStatuts)
		{
			int iId = Integer.parseInt(vStatut.get(0));
			int iValue = Integer.parseInt(vStatut.get(2));
			try{
				int iUpdateValue = HttpUtil.parseInt(sFormPrefix+iId, request);
				if(iUpdateValue != iValue){
					this.biStatuts = BitField.setStatutValeur(this.biStatuts, iId, iUpdateValue);
				}
			}catch(Exception e){}
		}
    }
    
    public String getLocalizedLabel (String sFieldName, String defaultValue){
    	try {
    		return getLocalizedLabel (sFieldName);
    	} catch (Exception e){
    		return defaultValue;
    	}
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

   	public String getIdPersonnePhysiqueOwnerLabel() {
   		 return getLocalizedLabel("lIdPersonnePhysiqueOwner");
   	}
   	
   	public String getIdPersonnePhysiqueDelegateLabel() {
  		 return getLocalizedLabel("lIdPersonnePhysiqueDelegate");
  	}
   	
   	public String getIdDelegationTypeLabel() {
 		 return getLocalizedLabel("iIdDelegationType");
 	}
   	
   	public String getIdDelegationStateLabel() {
		 return getLocalizedLabel("iIdDelegationState");
	}
   	
   	public String getStartLabel() {
		 return getLocalizedLabel("tsDateStart");
	}
   	
   	public String getEndLabel() {
		 return getLocalizedLabel("tsDateEnd");
	}
   	
   	public String getStatutsLabel() {
		 return getLocalizedLabel("biStatuts");
	}
   	
   	public String getSignTemplateLabel() {
		 return getLocalizedLabel("sSignTemplate");
	}

    
    public static Vector<Delegation> getAllFromStatutStatic(int iIndexStatut,int iValue) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
    	Delegation item = new Delegation();
		return item.getAllFromStatut(iIndexStatut, iValue);
	}
	
	public static Vector<Delegation> getAllFromStatutStatic(int iIndexStatut,int iValue,Connection conn) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		Delegation item = new Delegation();
		item.setEmbeddedConnection(conn);
		item.bUseEmbeddedConnection = true;
		return item.getAllFromStatut(iIndexStatut, iValue);
	}
	
	public Vector<Delegation> getAllFromStatut(int iIndexStatut,int iValue) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		String sSQLWhereClause = " WHERE "+BitField.getSQLQueryRequestBit("statuts",iIndexStatut,iValue);
		return this.getAllWithWhereAndOrderByClause(sSQLWhereClause,"");
	}
	
	public Vector<Vector<String>> getAllStatus(int iSTATUS_MAX_ID) 
	{
		Vector<Vector<String>> vStatus = new Vector<Vector<String>>();
		for(int i=1;i<=iSTATUS_MAX_ID;i++)
		{
			Vector<String> vStatut = new Vector<String>();
			vStatut.add(Integer.toString(i));
			vStatut.add(this.getStatusName(i));
			vStatut.add(Integer.toString(BitField.getStatutValeur(this.biStatuts,i)));
			vStatus.add(vStatut);
		}
		return vStatus;
	}
    
    public String getStatusName(int iIdStatut)
	{
		String sStatutName = "";
		switch(iIdStatut)
		{
			case ID_STATUT_PRIVATE:
				sStatutName = getLocalizedLabel ("ID_STATUT_PRIVATE", "Cacher mes documents");
				break;
			
			case ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS:
				sStatutName = getLocalizedLabel ("ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS", "Delegator in copy of notifications");
				break;
		}
		return sStatutName;
	}

    public static Vector<Delegation> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Delegation item = new Delegation();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<Delegation> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Delegation item = new Delegation();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<Delegation> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Delegation item = new Delegation();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<Delegation> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Delegation item = new Delegation();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }
    
	public static Vector<Delegation> getAllFromOwner(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Delegation item = new Delegation ();
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique_owner =" + lIdPersonnePhysique,
				 "");
		
	}	
	
	public static Vector<Delegation> getAllActiveFromOwner(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Delegation item = new Delegation ();
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique_owner =" + lIdPersonnePhysique
				+ " AND "+CoinDatabaseUtil.getSqlCurrentDateFunction()+" BETWEEN date_start AND date_end"
				+ " AND id_delegation_state = "+DelegationState.STATE_ACTIVATED
				, "");
		
	}
	
	public static Vector<Delegation> getAllFromPersonnePhysique(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Delegation item = new Delegation ();
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique_owner =" + lIdPersonnePhysique
				+ " OR id_personne_physique_delegate =" + lIdPersonnePhysique,
				 "");
		
	}	
	
	public static Vector<Delegation> getAllFromDelegate(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Delegation item = new Delegation ();
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique_delegate =" + lIdPersonnePhysique,
				 "");
		
	}
	
	public static Delegation getFromOwnerAndDelegate(long lIdPersonnePhysiqueOwner, long lIdPersonnePhysiqueDelegate) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
	{
		Delegation item = new Delegation ();
		return (Delegation)item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE id_personne_physique_delegate =" + lIdPersonnePhysiqueDelegate
				+" AND id_personne_physique_owner =" + lIdPersonnePhysiqueOwner,
				 "");
		
	}
	
	public static Vector<PersonnePhysique> getAllOwnerFromDelegate(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique ();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(lIdPersonnePhysique));
		return item.getAllWithWhereAndOrderByClause(
				"pp.",
				", delegation del"
				+ " WHERE del.id_personne_physique_delegate = ?"
				+ " AND pp.id_personne_physique = del.id_personne_physique_owner",
				"",
				vParam);
		
	}
	
	public static Vector<PersonnePhysique> getAllActiveOwnerFromDelegate(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique ();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(lIdPersonnePhysique));
		return item.getAllWithWhereAndOrderByClause(
				"pp.",
				", delegation del"
				+ " WHERE del.id_personne_physique_delegate = ?"
				+ " AND pp.id_personne_physique = del.id_personne_physique_owner"
	
				+ " AND "+CoinDatabaseUtil.getSqlCurrentDateFunction()+" BETWEEN del.date_start AND del.date_end",
				"",
				vParam);
		
	}
	
	public static Vector<Delegation> getAllActiveFromDelegate(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Delegation item = new Delegation ();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(lIdPersonnePhysique));
		vParam.add(new Long(DelegationState.STATE_ACTIVATED));
		return item.getAllWithWhereAndOrderByClause(
				"d.",
				" INNER JOIN personne_physique p "
				+ " ON p.id_personne_physique = d.id_personne_physique_owner "
				+ " WHERE d.id_personne_physique_delegate = ?"
				+ " AND d.id_delegation_state = ?"
				+ " AND "+CoinDatabaseUtil.getSqlCurrentDateFunction()+" BETWEEN d.date_start AND d.date_end",
				"",
				vParam);
		
	}

    @Override
    public String getName() {
        return "delegation_"+this.lId;
    }

    public long getIdPersonnePhysiqueOwner() {return this.lIdPersonnePhysiqueOwner;}
    public void setIdPersonnePhysiqueOwner(long lIdPersonnePhysiqueOwner) {this.lIdPersonnePhysiqueOwner = lIdPersonnePhysiqueOwner;}

    public long getIdPersonnePhysiqueDelegate() {return this.lIdPersonnePhysiqueDelegate;}
    public void setIdPersonnePhysiqueDelegate(long lIdPersonnePhysiqueDelegate) {this.lIdPersonnePhysiqueDelegate = lIdPersonnePhysiqueDelegate;}

    public int getIdDelegationType() {return this.iIdDelegationType;}
    public void setIdDelegationType(int iIdDelegationType) {this.iIdDelegationType = iIdDelegationType;}

    public int getIdDelegationState() {return this.iIdDelegationState;}
    public void setIdDelegationState(int iIdDelegationState) {this.iIdDelegationState = iIdDelegationState;}

    public Timestamp getDateStart() {return this.tsDateStart;}
    public void setDateStart(Timestamp tsDateStart) {this.tsDateStart = tsDateStart;}

    public Timestamp getDateEnd() {return this.tsDateEnd;}
    public void setDateEnd(Timestamp tsDateEnd) {this.tsDateEnd = tsDateEnd;}
    
    public String getSignTemplate() {return this.sSignTemplate;}
    public void setSignTemplate(String sSignTemplate) {this.sSignTemplate = sSignTemplate;}

	public boolean isPrivate() throws Exception{return BitField.getValue(this.biStatuts,ID_STATUT_PRIVATE);}
	public boolean isPrivate(boolean bDefaultValue){return BitField.getValue(this.biStatuts,ID_STATUT_PRIVATE, bDefaultValue);}
	public void setPrivate(boolean b) {this.biStatuts = BitField.setValue(this.biStatuts,ID_STATUT_PRIVATE,b);}
	
	public boolean isDelegatorInCopyOfNotifications () throws Exception {
		return BitField.getValue (this.biStatuts, ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS);
	}
	
	public boolean isDelegatorInCopyOfNotifications (boolean bDefaultValue) throws Exception {
		return BitField.getValue (this.biStatuts, ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS, bDefaultValue);
	}
	
	public void setDelegatorInCopyOfNotifications (boolean b){
		this.biStatuts = BitField.setValue(this.biStatuts, ID_STATUT_DELEGATOR_IN_COPY_OF_NOTIFICATIONS, b);
	}
	
    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdPersonnePhysiqueOwner", this.lIdPersonnePhysiqueOwner);
        item.put("lIdPersonnePhysiqueDelegate", this.lIdPersonnePhysiqueDelegate);
        item.put("iIdDelegationType", this.iIdDelegationType);
        item.put("iIdDelegationState", this.iIdDelegationState);
        item.put("tsDateCreation", super.tsDateCreation);
        item.put("tsDateStart", this.tsDateStart);
        item.put("tsDateEnd", this.tsDateEnd);
        item.put("status", this.getJSONStatus());
        item.put("sSignTemplate", this.sSignTemplate);
        return item;
    }
    
    public JSONArray getJSONStatus() throws JSONException, NumberFormatException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
    	JSONArray item = new JSONArray();
		Vector<Vector<String>> vStatuts = getAllStatus(STATUT_MAX_ID);
		for(Vector<String> vStatut : vStatuts)
		{
			JSONObject json = new JSONObject();
			json.put("index", vStatut.get(0));
			json.put("name", vStatut.get(1));
			json.put("value", vStatut.get(2));
			item.put(json);
		} 
		return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        Delegation item = getDelegation(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (Delegation item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdPersonnePhysiqueOwner = item.getLong("lIdPersonnePhysiqueOwner");
        } catch(Exception e){}
        try {
            this.lIdPersonnePhysiqueDelegate = item.getLong("lIdPersonnePhysiqueDelegate");
        } catch(Exception e){}
        try {
            this.iIdDelegationType = item.getInt("iIdDelegationType");
        } catch(Exception e){}
        try {
            this.iIdDelegationState = item.getInt("iIdDelegationState");
        } catch(Exception e){}
        try {
            this.tsDateStart = item.getTimestamp("tsDateStart");
        } catch(Exception e){}
        try {
            this.tsDateEnd = item.getTimestamp("tsDateEnd");
        } catch(Exception e){}
        try {
            this.sSignTemplate = item.getString("sSignTemplate");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            Delegation item = null;
            try{
                item = Delegation.getDelegation(data.getLong("lId"));
            } catch(Exception e){
                item = new Delegation();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public void removeWithObjectAttached()
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Connection conn = getConnection();
		try{
			removeWithObjectAttached(conn) ;
		} finally {
			releaseConnection(conn);
		}
	}
	
	public void removeWithObjectAttached(
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException 
	{
		try{
			DelegationObject.removeAllFromDelegation(this.lId, conn);
		} catch (Exception e) {}
		
		this.remove(conn);
	}
}
