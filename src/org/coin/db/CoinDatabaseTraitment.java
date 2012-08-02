package org.coin.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

public class CoinDatabaseTraitment {
	
	public Object context1;
	public Object context2;
	public Object context3;
	public Object context4;

	public boolean bUseStreaming = true;
	public Connection connStreaming;

	public boolean bContinueTraitment = true;
	public boolean bUseCutTraitment = false;
	public long lCutTraitmentCount ;
	public long lCutTraitmentCurrent;
	public long lCount;
	
	public CoinDatabaseTraitment() {
		
	}
	
	public void doTraitment(CoinDatabaseAbstractBean item, Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException ,
		CoinDatabaseDuplicateException, CoinDatabaseStoreException

	{
		
	}

	
	public void doAll(CoinDatabaseAbstractBean item, Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseDuplicateException, CoinDatabaseStoreException
	{	
		doAll(item.getAllSelect(), item, conn);
	}
	
	public void doAll(String sSQLQuery,CoinDatabaseAbstractBean objTypeToLoad) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseDuplicateException, CoinDatabaseStoreException
	{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			doAll(sSQLQuery,objTypeToLoad, conn);
		}finally
		{
			ConnectionManager.closeConnection(conn);
		}
	}

	public void doAll(
			String sSQLQuery, 
			CoinDatabaseAbstractBean objTypeToLoad, 
			Connection conn) 
	throws CoinDatabaseDuplicateException, InstantiationException, 
	IllegalAccessException, NamingException, SQLException, CoinDatabaseStoreException 
	{
		doAll(sSQLQuery, null, objTypeToLoad, conn);
	}
	
	public void doAll(
			String sSQLQuery, 
			Vector<Object> vParams,
			CoinDatabaseAbstractBean objTypeToLoad, 
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, 
	SQLException, CoinDatabaseDuplicateException, CoinDatabaseStoreException 
	{
		PreparedStatement ps = null;
		ResultSet rs = null;

		CoinDatabaseAbstractBean.traceQueryStatic(sSQLQuery, objTypeToLoad);
		this.lCount = 0;
		try {
			if(this.bUseStreaming) {
				if(this.connStreaming != null)
				{
					ps = connStreaming.prepareStatement(sSQLQuery);
					ps.setFetchSize(Integer.MIN_VALUE);
				} else {
					ps = conn.prepareStatement(sSQLQuery);
					ps.setFetchSize(Integer.MIN_VALUE);
				}
				
			} else {
				ps = conn.prepareStatement(sSQLQuery);
			}
			CoinDatabaseAbstractBean.setAllWithSqlQueryPreparedStatement (ps, vParams);
			this.lCutTraitmentCurrent = 0;
			rs = ps.executeQuery();
			
			while (rs.next() && this.bContinueTraitment)
			{
				CoinDatabaseAbstractBean item = objTypeToLoad.getClass().newInstance();
				this.lCount++;
				
				this.lCutTraitmentCurrent++;
				/*System.out.println("lCutTraitmentCurrent = " + this.lCutTraitmentCurrent 
						+ " this.lCutTraitmentCount=" + this.lCutTraitmentCount);
				*/
				if(this.bUseCutTraitment && this.lCutTraitmentCurrent>this.lCutTraitmentCount)
				{
					break;
				}
				item.bUseHttpPrevent = objTypeToLoad.bUseHttpPrevent;
				item.setFromResultSet(rs);
				if ((item.PRIMARY_KEY_TYPE == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_INTEGER )
				|| (item.PRIMARY_KEY_TYPE == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG))
				{
					item.lId = rs.getLong(item.SELECT_FIELDS_NAME_SIZE + 1);
				}

				if (item.PRIMARY_KEY_TYPE == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING)
				{
					item.sId = rs.getString(item.SELECT_FIELDS_NAME_SIZE + 1);
				}
				doTraitment( item, conn);
			}
		}
		finally
		{
			ConnectionManager.closeConnection(rs,ps);
		}
	}

}
