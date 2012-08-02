package org.coin.db;

import java.util.ArrayList;
import java.util.Vector;

import org.coin.util.StringUtilBasic;


/**
 * TODO : voir utilisation de Set (qui implementerai naturellement le traitement des doublons)
 * @author grattepoil
 *
 */
public class CoinDatabaseWhereClause {
	public ArrayList<String> listItems;
	/**
	 *  1 : STRING,
	 *  2 : INTEGER 
	 */
	public int iItemType;
	public static final int ITEM_TYPE_STRING = 1;
	public static final int ITEM_TYPE_INTEGER = 2;
	
	/** used only for the prepared statement */
	public Vector<Object> vParams ;
   		
	public Vector<Object> getParams() {
		return vParams;
	}

	public void setParams(Vector<Object> params) {
		vParams = params;
	}
	
	public ArrayList<String> getItems() {
		return listItems;
	}
	public void setItems(ArrayList<String> items) {
		this.listItems = items;
	}

	public CoinDatabaseWhereClause(int iItemType) {
		this.iItemType = iItemType;
		this.listItems = new ArrayList<String>();
		this.vParams = new Vector<Object>();
	}
	
	public CoinDatabaseWhereClause(
			int iItemType,
			Vector<? extends CoinDatabaseAbstractBean> v)
	{
		this.iItemType = iItemType;
		this.listItems = new ArrayList<String>();
		this.vParams = new Vector<Object>();
		addAll(v);
	}

	public void add(int[] arriId) {
		for (int lId : arriId) {
			add(lId);
		}
	}

	public void add(long[] arrlId) {
		for (long lId : arrlId) {
			add(lId);
		}
	}
	
	public void add(String[] arrsId) {
		for (String sId : arrsId) {
			add(sId);
		}
	}

	public void add(long lId) {
		if(!this.listItems.contains("" + lId))
		{
			this.vParams.add(new Long(lId));
			this.listItems.add("" + lId);
		}
	}

	public void add(String sId) {
		if(!this.listItems.contains(sId))
		{
			this.vParams.add(sId);
			this.listItems.add(sId);
		}
	}
	
	public void addAll( Vector<? extends CoinDatabaseAbstractBean> v) {
		for(CoinDatabaseAbstractBean bean : v){
			switch(bean.getPrimaryKeyType()){
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
				this.add(bean.getIdString());
				break;
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_INTEGER:
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
				this.add(bean.getId());
				break;
			}
		}
	}

	public void clear() {
		this.listItems.clear();

	}
	
	public void addArray(String sArray) {
		addArray(sArray, ",");
	}

	public void addArray(String sArray, String sDelimiter) {
		String[] sarrId = sArray.split(sDelimiter);
		
		for (int i = 0; i < sarrId.length; i++) {
			String id = sarrId[i];
			if(!id.equals("")) add(id);
		}
	}

	
	public String generateClause(
			String sFieldName)
	{
		StringBuffer sbWhere = new StringBuffer (" " + sFieldName );

    	if( this.listItems.size() == 0) {
    		// TODO attention à  revoir par la suite
    		System.out.println("Warning :  generateWhereClause empty revoir le traitement pour  sFieldName : '" + sFieldName + "'");
    		sbWhere.append("=-1");
    		
    		Exception e = new Exception("Fausse Exception pour afficher l'etat de la pile. sFieldName : '" + sFieldName + "'");
			
			if(CoinDatabaseAbstractBean.TRACE_STACK)
			{
				System.out.println("\n<traceStack>\n");
				e.printStackTrace();
				System.out.println("\n</traceStack>\n");
				
			}
			return sbWhere.toString() ;
    	}
    	return sbWhere.toString();
	}

	public String generateWhereNotClause(
			String sFieldName)
	{
		return generateWhereNotClause(sFieldName, false);
	}
	
	public String generateWhereNotClause(
			String sFieldName,
			boolean bUsePreparedStatement)
	{
    	return generateClause(sFieldName)
    		+ (this.listItems.size() == 0?"":" NOT IN " 
    		+ generateArrayClause(bUsePreparedStatement));
	}


	public String generateWhereClause(
			String sFieldName)
	{
		return generateWhereClause(sFieldName, false);
	}
	
	public String generateWhereClause(
			String sFieldName,
			boolean bUsePreparedStatement)
	{
		return generateClause(sFieldName)
			+ (this.listItems.size() == 0?"":" IN " 
			+ generateArrayClause(bUsePreparedStatement));
	}
	
	public String generateArrayClauseNotEmpty()
	{
		String sClause = generateArrayClause(false);
		if(sClause.contains("()"))
		{
			sClause = "(-1)";
		}
		return sClause;
	}

	public String generateArrayClause()
	{
		return generateArrayClause(false);
	}
	
	public String generateArrayClause(
			boolean bUsePreparedStatement)
	{
		return generateArrayClause(
				"(", 
				") ", 
				bUsePreparedStatement);
	}
	
	public String[] generateArrayClauseStringArray()
	{
		String[] s = new String[this.listItems.size()];
		for (int i = 0; i < this.listItems.size(); i++)
		{
			s[i] = this.listItems.get(i);
		}
		
		return s;
	}
	
	public String generateArrayClause(
			String sTokenStart,
			String sTokenEnd,
			boolean bUsePreparedStatement)
	{
		StringBuffer sbWhere = new StringBuffer (sTokenStart);
		for (int i = 0; i < this.listItems.size(); i++)
		{
			if(i != 0) sbWhere.append(",");
			if(this.iItemType == ITEM_TYPE_STRING) sbWhere.append("'");
			if(bUsePreparedStatement) { 
				/**
				 * here the value is provided by the prepared statement
				 */
				sbWhere.append("?");
			} else {
				sbWhere.append(StringUtilBasic.addLikeSlashes(this.listItems.get(i)));
			}
			if(this.iItemType == ITEM_TYPE_STRING) sbWhere.append("'");
		}
		sbWhere.append(sTokenEnd);
		return sbWhere.toString() ;
	}
}
