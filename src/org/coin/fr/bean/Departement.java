/*
 * Created on 4 nov. 2004
 *
 */
package org.coin.fr.bean;

import java.io.Serializable;
import java.sql.*;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.EnumeratorString;
import org.coin.util.EnumeratorStringMemory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@SuppressWarnings("unchecked")
public class Departement extends EnumeratorStringMemory implements Serializable, Comparable{

	private static final long serialVersionUID = 1L;
	protected static final String TABLE_DEPARTEMENT = "departement";
	
	public static Vector<Departement> m_vItem = null;
	public static Vector<Departement> m_unprevent_vItem = null; 
	
	public void setConstantes() {
		super.TABLE_NAME = "departement";
        this.FIELD_ID_NAME = "code";
        this.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;

	}

	public Departement() {
		super();
		setConstantes();
	}

	public Departement(String sCode, String sName) {
		super(sCode, sName);
		setConstantes();
	}

	public Departement(String sCode) {
		super(sCode);
		setConstantes();
	}

	public Departement(String sId, String sName,boolean bUseHttpPrevent) {
		super(sId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected EnumeratorString getAll_onNewItem(String sId, String sName)
	{
		return getAll_onNewItem(sId,sName,true);
	}
   
	protected EnumeratorString getAll_onNewItem(String sId, String sName,boolean bUseHttpPrevent)
	{
		return new Departement(sId, sName,bUseHttpPrevent);
	}

	public static String getDepartementName(String sCode) throws Exception {
    	Departement departement = new Departement(sCode);
    	departement.load();
    	return departement.getName();
    }

	public static Departement getDepartement(String sCode) throws Exception {
    	Departement departement = new Departement(sCode);
    	departement.load();
    	return departement;
    }

	public static Departement getDepartement(
			String sCode,
			boolean UseHttpPrevent,
			Connection conn) 
	throws Exception {
    	Departement departement = new Departement(sCode);
    	departement.bUseHttpPrevent = UseHttpPrevent;
    	departement.load(conn);
    	return departement;
    }
	
	public static Vector<Departement> getAllDepartement(boolean bUseHttpPrevent, boolean bUseEmebeddedConn, Connection conn) throws NamingException, SQLException
	{
		Departement item = new Departement();
		item.bUseHttpPrevent = bUseHttpPrevent;
		item.bUseEmbeddedConnection = bUseEmebeddedConn;
		item.connEmbeddedConnection = conn;
		return item.getAllOrderById();
	}

	public static Vector<Departement> getAllDepartement(boolean bUseHttpPrevent, Connection conn) throws NamingException, SQLException
	{
		return getAllDepartement(bUseHttpPrevent, true, conn);
	}

	public static Vector<Departement> getAllDepartement(boolean bUseHttpPrevent) throws NamingException, SQLException
	{
		return getAllDepartement(bUseHttpPrevent, false, null);
	}
	public static Vector<Departement> getAllDepartement() throws NamingException, SQLException
	{
		return getAllDepartement(true);
	}
    

  
    

	
    public boolean equals(Object o) {
    	return ((o != null && o instanceof Departement)?this.sId.equalsIgnoreCase(((Departement)o).sId):false);
        }

	public int compareTo(Object o) {
    	return ((o != null && o instanceof Departement)?this.sName.compareToIgnoreCase(((Departement)o).sName):-1);
	}
	
	public void populateMemory() throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		m_vItem = getAllDepartement(true,this.bUseEmbeddedConnection,this.connEmbeddedConnection);
		m_unprevent_vItem = getAllDepartement(false,this.bUseEmbeddedConnection,this.connEmbeddedConnection);
	}
    
	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return (Vector<T>) getAllStaticMemory();
	}

	public static Vector<Departement> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		return getAllStaticMemory(bUseHttpPrevent, false, null);
    }
    
	public static Vector<Departement> getAllStaticMemory(boolean bUseHttpPrevent, boolean bUseEmbeddedConnection, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		Departement item = new Departement();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.bUseEmbeddedConnection = bUseEmbeddedConnection;
    	item.connEmbeddedConnection = conn;
    	reloadMemoryStatic(item);
		
		return item.getItemMemory();
    }
    
	public static Vector<Departement> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getAllStaticMemory(true);
    }

    public static Departement getDepartementMemory(String sId,boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector<Departement> vItems = getAllStaticMemory(bUseHttpPrevent);

    	for (Departement item : vItems) {
        	if(item.getIdString().equalsIgnoreCase(sId)) return item;
		}

    	throw new CoinDatabaseLoadException("" + sId, "getDepartementMemory");
    }
    
    public static Departement getDepartementMemory(String sId,boolean bUseHttpPrevent, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector<Departement> vItems = getAllStaticMemory(bUseHttpPrevent, true,conn);

    	for (Departement item : vItems) {
        	if(item.getIdString().equalsIgnoreCase(sId)) return item;
		}

    	throw new CoinDatabaseLoadException("Departement unknow : " + sId, "getDepartementMemory");
    }

    
    public static Departement getDepartementMemory(String sId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getDepartementMemory(sId,true);
    }

	public Vector<Departement> getItemMemory() {
		return (this.bUseHttpPrevent?m_vItem:m_unprevent_vItem);
	}

	
    public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("sId", this.sId);
		item.put("sName", this.sId+". "+this.getName());
		
		return item;
	}
    
	public static JSONArray getJSONArray() throws Exception {
		return getJSONArray(true);
	}
	
	public static JSONArray getJSONArray(boolean bUseHttpPrevent) throws Exception {
		JSONArray items = new JSONArray();
		for (Departement item:getAllStaticMemory(bUseHttpPrevent)) items.put(item.toJSONObject());
		return items;
	}
    
}
