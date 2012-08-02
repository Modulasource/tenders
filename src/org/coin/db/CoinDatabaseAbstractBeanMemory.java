package org.coin.db;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

/**
 * @author j.renier
 *
 */
public abstract class CoinDatabaseAbstractBeanMemory extends CoinDatabaseAbstractBean implements CoinDatabaseMemoryInterface{
	private static final long serialVersionUID = 1L;
	
	public static void populateMemoryStatic(CoinDatabaseAbstractBeanMemory bean) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		bean.populateMemory();
	}
	
	public static void populateMemoryStaticConn(
			CoinDatabaseAbstractBeanMemory bean,
			Connection conn) 
	throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		Connection connEmbeddedConnection = bean.connEmbeddedConnection;
		boolean bUseEmbeddedConnection = bean.bUseEmbeddedConnection;
		
		bean.bUseEmbeddedConnection = true;
		bean.connEmbeddedConnection = conn; 
		bean.populateMemory();
		
		bean.bUseEmbeddedConnection = bUseEmbeddedConnection;
		bean.connEmbeddedConnection = connEmbeddedConnection; 
	}
	
	public static void reloadMemoryStatic(CoinDatabaseAbstractBeanMemory bean) 
	throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		if(bean.getItemMemory()==null){
			if(bean.bUseEmbeddedConnection){
				populateMemoryStaticConn(bean, bean.connEmbeddedConnection);
			} else {
				populateMemoryStatic(bean);
			}
		}
	}
	
	@Override
	public void create(Connection conn) throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		super.create(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void store(Connection conn) throws SQLException, NamingException, CoinDatabaseStoreException {
		super.store(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void remove(Connection conn) throws SQLException, NamingException {
		super.remove(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void remove(int id) throws SQLException, NamingException {
		super.remove(id);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(long id) throws SQLException, NamingException {
		super.remove(id);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}
	
	@Override
	public void removeFromPK(String sId, Connection conn) throws SQLException, NamingException {
		super.removeFromPK(sId,conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(String sWhereClause) throws SQLException, NamingException {
		super.remove(sWhereClause);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(String sWhereClause, Connection conn) throws SQLException, NamingException {
		super.remove(sWhereClause,conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}

	public <T> Vector<T> getAllMemoryLocalized(long lIdLanguage) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException { 
		Vector<T> vResult = this.getAllMemory();
        for (T item : vResult) {
        	CoinDatabaseAbstractBeanMemory itemMem = ((CoinDatabaseAbstractBeanMemory)item);
        	itemMem.setAbstractBeanLocalization(lIdLanguage);
        	itemMem.setAbstractBeanConnexion(this);
        	String sNameLocalized = itemMem.getName();
        	itemMem.setName(sNameLocalized);
        }
        return vResult;
	}
	
}