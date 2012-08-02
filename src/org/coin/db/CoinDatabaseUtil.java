package org.coin.db;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.util.StringUtilBasic;
import org.json.JSONArray;
import org.json.JSONException;

public class CoinDatabaseUtil {
	
	@SuppressWarnings("unchecked")
	public static void merge(
			CoinDatabaseAbstractBean bean ,
			Vector  vBean)
	{
		if(!isInList(bean, vBean))
		{
			vBean.add(bean);
		}
	}
	
	public static void remove(
			CoinDatabaseAbstractBean bean ,
			Vector  vBean)
	{
		int i=0;
		int iIndexBean = -1;
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBean) {
			if(bean.getId() == item.getId()){
				iIndexBean = i;
				break;
			}
			i++;
		}
		
		if(iIndexBean>=0) vBean.remove(iIndexBean);
	}
	
	public static void remove(
			long lIdBean ,
			Vector  vBean)
	{
		int i=0;
		int iIndexBean = -1;
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBean) {
			if(lIdBean == item.getId()){
				iIndexBean = i;
				break;
			}
			i++;
		}
		
		if(iIndexBean>=0) vBean.remove(iIndexBean);
	}

	public static Vector distinct(
			Vector  vBean)
	{
		Vector<CoinDatabaseAbstractBean> vBeanDistinct = new Vector<CoinDatabaseAbstractBean>();
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBean) {
			if(!isInList(item, vBeanDistinct))
			{
				vBeanDistinct.add(item);
			}
		}
		return vBeanDistinct;
	}
	
	public static void merge(
			Vector  vBeanToMerge,
			Vector  vBean)
	{
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBeanToMerge) {
			if(!isInList(item, vBean))
			{
				vBean.add(item);
			}
		}
	}
	
	public static JSONArray convertToJSONArray(Vector vBeanToConvert) throws CoinDatabaseLoadException, JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		JSONArray json = new JSONArray();
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>)vBeanToConvert) {
			json.put(item.toJSONObject());
		}
		return json;
	}
	
	@SuppressWarnings("unchecked")
	public static boolean isInList(
			CoinDatabaseAbstractBean bean ,
			Vector vBean)
	{
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBean) {
			if( (bean.getPrimaryKeyType() == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_INTEGER
				|| bean.getPrimaryKeyType() == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG)
				&& bean.getId() == item.getId())
				return true;
			else if(bean.getPrimaryKeyType() == CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING 
					&& bean.getIdString().equalsIgnoreCase(item.getIdString()) )
				return true;
				
		}
		return false;
		
	}
	
	@SuppressWarnings("unchecked")
	public static boolean isInList(
			long lIdBean ,
			Vector vBean)
	{
		for (CoinDatabaseAbstractBean item : (Vector<CoinDatabaseAbstractBean>) vBean) {
			if(lIdBean == item.getId())
				return true;
		}
		return false;
		
	}
	
	public static String getSqlGroupConcatFunction(
			String sFieldNameA,
			String sFieldNameB)
	{
		return getSqlGroupConcatFunction(sFieldNameA, sFieldNameB, "");
	}
	
	/**
	 * @see TODO: http://blog.shlomoid.com/2008/11/emulating-mysqls-groupconcat-function.html
	 * @param sFieldNameA
	 * @param sFieldNameB
	 * @param sSeparator
	 * @return
	 */
	public static String getSqlGroupConcatFunction(
			String sFieldNameA,
			String sFieldNameB,
			String sSeparator)
	{
		String sSql = null;
		boolean bUseSeparator = !StringUtilBasic.isNullOrBlank(sSeparator);
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
		case ConnectionManager.DBTYPE_ORACLE:
			sSql = "GROUP_CONCAT(" + sFieldNameA + " "+(bUseSeparator?"SEPARATOR '"+sSeparator+"'":"")+") as " + sFieldNameB ;
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = " ' ' as "  + sFieldNameB;
			break;

		default:
			break;
		}

		return sSql;
	}
	
	public static String getSqlConcatFunction(
			String sFieldNameA,
			String sFieldNameB,
			String sDelimiter)
	{
		String sSql = null;
			
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
		case ConnectionManager.DBTYPE_ORACLE:
			sSql = "CONCAT(" + sFieldNameA + ",'" + sDelimiter + "'," + sFieldNameB + ")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "" + sFieldNameA + "+'"+ sDelimiter +"'+"  + sFieldNameB;
			//sSql = "CONVERT(VARCHAR(10), "+sDateFieldName + ", 103)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlConcatFunction(
			String sFieldNameA,
			String sFieldNameB)
	{
		String sSql = null;
		
		/**
		 * 
		 * 
		 *  MySQL/Oracle:
				SELECT CONCAT(region_name,store_name) FROM Geography
				WHERE store_name = 'Boston';
				
			
			SQL Server:
				SELECT region_name + ' ' + store_name FROM Geography
				WHERE store_name = 'Boston';
			
		 *  
		 */
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
		case ConnectionManager.DBTYPE_ORACLE:
			sSql = "CONCAT(" + sFieldNameA + "," + sFieldNameB + ")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "" + sFieldNameA + "+' '+"  + sFieldNameB;
			//sSql = "CONVERT(VARCHAR(10), "+sDateFieldName + ", 103)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlStandardDateFunction(String sDateFieldName)
	{
		String sSql = null;
		
		/**
		 * 
		 * en MySQL 
		 * 
		 * DATE_FORMAT(date, date_format)
		 * DATE_FORMAT(date,'%d/%m/%Y')
		 * 
		 * en SQL SERVER 2005
		 * 
		 * CONVERT(VARCHAR(10), date, 103) 
		 * @see http://technet.microsoft.com/fr-fr/library/ms187928.aspx
		 *  
		 */
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "DATE_FORMAT("+sDateFieldName + ", '%d/%m/%Y')";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "CONVERT(VARCHAR(10), "+sDateFieldName + ", 103)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlDateODBCFunction(String sDate)
	{
		String sSql = null;
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "'"+sDate + "'";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "CONVERT(datetime, '"+sDate+"', 120)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlDateODBCFunction(Timestamp tsDate)
	{
		String sSql = null;
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "'"+tsDate + "'";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "CONVERT(datetime, '"+tsDate+"', 120)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	
	public static String getSqlDatePreparedStatementODBCFunction()
	{
		String sSql = null;
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "?";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "CONVERT(datetime, ?, 120)";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlHexFunction(String sData)
	{
		String sSql = null;
		
		/**
		 * 
		 * en MySQL 
		 * 
		 * HEX(data)
		 * 
		 * en SQL SERVER 2005
		 * 
		 * CONVERT(CHAR, data) n'a pas l'air de fonctionner correctement (renvoie blank value)
		 * @see http://classicasp.aspfaq.com/general/how-do-i-convert-from-hex-to-int-and-back.html
		 * 
		 * master.dbo.fn_varbintohexstr(data)
		 * @see http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=385706&SiteID=1
		 * 
		 * possible aussi avec SSIS (non dispo sur la version express)
		 * @see http://technet.microsoft.com/fr-fr/library/ms141812(SQL.100).aspx
		 *  
		 */
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "HEX("+sData+")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "master.dbo.fn_varbintohexstr("+sData +")";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlLengthFunction(String sData)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "LENGTH("+sData+")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "LEN("+sData +")";
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlSubStringFunction(String sStr, String sPos, String sLen)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "SUBSTR("+sStr+","+sPos+","+sLen+")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "SUBSTRING("+sStr+","+sPos+","+sLen+")";
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlText2VarcharFunction(String sStr)
	{
		return getSqlText2VarcharFunction(sStr, 2000);
	}
	
	public static String getSqlText2VarcharFunction(String sStr,int iLength)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = sStr;
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "CONVERT(VARCHAR("+iLength+"),"+sStr+")";
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlLPADFunction(String sStr,String sLen,String sPadstr)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "LPAD("+sStr+","+sLen+","+sPadstr+")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "LEFT("+sStr+" + REPLICATE("+sPadstr+","+sLen+") ,"+sLen+")";
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlRPADFunction(String sStr,String sLen,String sPadstr)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "RPAD("+sStr+","+sLen+","+sPadstr+")";
			break;
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "RIGHT(REPLICATE("+sPadstr+","+sLen+")+"+sStr+" ,"+sLen+")";
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlCurrentDateFunction()
	{
		String sSql = null;
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "curdate()";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "getdate()";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlTimestampDiffFunction(
			String sDateA,
			String sDateB,
			String sDiff)
	{
		String sSql = null;
		
		/**
		 * http://msdn2.microsoft.com/fr-fr/library/ms189794.aspx
		 * http://www.inetsoftware.de/products/jdbc/mssql/manual.asp
		 * http://support.microsoft.com/kb/311000/fr
		 * http://www.smallsql.de/doc/sql-functions/date-time/timestampdiff.html
		 */
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "TIMESTAMPDIFF("+sDiff + "," + sDateA + "," + sDateB + ")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "DATEDIFF("+sDiff + "," + sDateA + "," + sDateB + ")";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlDateAddFunction(
			String sDate,
			String sInterval,
			String sDiff)
	{
		String sSql = null;
		
		/**
		 * en MySQL 
		 * DATE_ADD(curdate(),INTERVAL 12 MONTH )
		 * 
		 * en SQL SERVER 2005
		 * DATEADD(MONTH,12,getdate())
		 * @see http://msdn2.microsoft.com/fr-fr/library/ms186819.aspx
		 *  
		 */
		
		 
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "DATE_ADD("+sDate + ",INTERVAL " + sInterval + " " + sDiff + ")";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "DATEADD("+sDiff + "," + sInterval + "," + sDate + ")";
			break;

		default:
			break;
		}
		
		return sSql;
		
	}
	
	public static String getSqlSelectWithLimit(
			String sSqlQuery,
			int iLimitOffset,
			int iLimit,
			String sFieldOrderBy,
			String sOrderByDir)
	{
		return getSqlSelectWithLimit(
				sSqlQuery, 
				iLimitOffset, 
				iLimit, 
				sFieldOrderBy,
				sOrderByDir,
				false);
	}
	
	public static String getSqlSelectWithLimit(
			String sSqlQuery,
			int iLimitOffset,
			int iLimit,
			String sFieldOrderBy,
			String sOrderByDir,
			boolean bUseSelectDistinct)
	{
		String sSql = null;
		
		/**
		 * 
		 * en MySQL 
		 * 
		 *  SELECT id_vehicle, vin, vehicle_number FROM VEHICLE LIMIT 10,30
		 * 
		 * 
		 * en SQL SERVER 2005
		 * 
			SELECT * 
			FROM
			( 
				SELECT TOP 10 * 
				FROM (
					SELECT TOP 30 id_vehicle, vin, vehicle_number 
					FROM  vehicle
					ORDER BY id_vehicle asc 
				) as temp_limit_A ORDER BY id_vehicle desc 
			) as temp_limit_B ORDER BY id_vehicle asc 
		 *  
		 */
		
		String sDistinct = bUseSelectDistinct?" DISTINCT " : "" ;
		
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = sSqlQuery + sDistinct
				+ " LIMIT " + iLimitOffset + "," + iLimit + "";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			boolean bIsAsc = sOrderByDir.equalsIgnoreCase("ASC");
			sSql = "SELECT * \n"
				+ " FROM \n"
				+ " ( \n"
				+ "     SELECT " +  "TOP " + iLimit + " *\n" 
				+ "     FROM "
				+ "     (\n" 
				+ "         " + sSqlQuery.replaceFirst(
								"SELECT", 
								"SELECT " + sDistinct +" TOP " + (iLimitOffset + iLimit) + " ") + "\n" 
				+ "         	 ORDER BY " + sFieldOrderBy +" "+sOrderByDir+"\n"
				+ "     ) as temp_limit_A ORDER BY " + sFieldOrderBy + " "+(bIsAsc?"desc":"asc")+" \n"
				+ " ) as temp_limit_B ORDER BY " + sFieldOrderBy + " "+(bIsAsc?"asc":"desc");
			break;

		default:
			break;
		}
		
		return sSql;
	}
	
	public static String getSqlEntityName(
			String sIdEntityType,
			String sIdOjectType,
			String sIdReferenceObject)
	{
		String sSQL = "";
		switch(ConnectionManager.getDbType()){
			case ConnectionManager.DBTYPE_MYSQL:
				sSQL += "GET_ENTITY_NAME_FUNC";
				break;
			case ConnectionManager.DBTYPE_SQL_SERVER:
				sSQL += "dbo.GET_ENTITY_NAME_FUNC";
				break;
		}
		sSQL += "("+sIdEntityType+","+sIdOjectType+","+sIdReferenceObject+")";
		return sSQL;
	}
	
	public static String getSqlLocalizationName(
			String sIdLanguage,
			String sIdOjectType,
			String sIdReferenceObject)
	{
		String sSQL = "";
		switch(ConnectionManager.getDbType()){
			case ConnectionManager.DBTYPE_MYSQL:
				sSQL += "GET_NAME_FUNC";
				break;
			case ConnectionManager.DBTYPE_SQL_SERVER:
				sSQL += "dbo.GET_NAME_FUNC";
				break;
		}
		sSQL += "("+sIdLanguage+","+sIdOjectType+","+sIdReferenceObject+")";
		return sSQL;
	}

	public static String getSqlUpdateLeftJoin(String sTable, String sTableLeft,String sClauseLeft, String sSet)
	{
		return getSqlUpdateLeftJoin(sTableLeft, new String[]{sTableLeft}, new String[]{sClauseLeft}, sSet);
	}
	
	public static String getSqlUpdateLeftJoin(String sTable, String[] sTableLeft,String[] sClauseLeft, String sSet)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "UPDATE "+sTable;
			for(int i=0;i<sTableLeft.length;i++){
				String sTableJoin = sTableLeft[i];
				String sClauseJoin = sClauseLeft[i];
				sSql +=" LEFT JOIN "+sTableJoin+" on ("+sClauseJoin+")";
			}
			sSql += " SET "+sSet;
			break;
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "UPDATE "+sTable+" SET "+sSet+" FROM "+sTable;
			for(int i=0;i<sTableLeft.length;i++){
				String sTableJoin = sTableLeft[i];
				String sClauseJoin = sClauseLeft[i];
				sSql +=" LEFT JOIN "+sTableJoin+" on ("+sClauseJoin+")";
			}
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlUpdateClassicJoin(String sTable, String sTableJoin,String sSet)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "UPDATE "+sTable+","+sTableJoin+" SET "+sSet;
			break;
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "UPDATE "+sTable+" SET "+sSet+" FROM "+sTable
			+" , "+sTableJoin;
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlShowColumns(String sTable){
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "show full columns from " + sTable ;
			break;
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "sp_columns @table_name = " + sTable;
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlDatePartFunction(
			String sDate,
			String sDatePart)
	{
		String sSql = null;
		
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			if(sDatePart.equalsIgnoreCase("year")) sDatePart = "%Y";
			if(sDatePart.equalsIgnoreCase("month")) sDatePart = "%m";
			if(sDatePart.equalsIgnoreCase("dayofyear")) sDatePart = "%d";
			
			sSql = "DATE_FORMAT("+sDate+", '"+sDatePart+"')";
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "DATEPART("+sDatePart + "," + sDate + ")";
			break;

		default:
			break;
		}
		
		return sSql;
	}
	
	public static String getSqlAge(
			String sDateA,
			String sDateB,
			String sAlias){
		
		String sSQL = getSqlIfFunction(
				getSqlDatePartFunction(sDateA, "MONTH")+">"+getSqlDatePartFunction(sDateB, "MONTH")+
				" OR ("+getSqlDatePartFunction(sDateA, "MONTH")+"="+getSqlDatePartFunction(sDateB, "MONTH")+
				" AND "+getSqlDatePartFunction(sDateA, "DAYOFYEAR")+">"+getSqlDatePartFunction(sDateB, "DAYOFYEAR")+")", 
				"("+getSqlTimestampDiffFunction(sDateA, sDateB, "YEAR")+"-1)",
				getSqlTimestampDiffFunction(sDateA, sDateB, "YEAR"), 
				sAlias);
		//System.out.println(sSQL);
		return sSQL;
	}
	
	/**
	 * IF function in SQL
	 * 
	 * MYSQL : IF(cv.id_vehicle IS NULL,construction.value_string,initialOperation.value_datetime) as dateStart
	 * SQL SERVER : Case When cv.id_vehicle IS NULL OR initialOperation.value_datetime IS NULL Then construction.value_string Else initialOperation.value_datetime End dateStart
		
	 * @param sCondition : the IF condition
	 * @param sValueIfYes : the value returned if condition is validated
	 * @param sValueIfNo : the value returned if condition isn't validated
	 * @param sAlias : the column alias of returned result
	 * @return
	 */
	public static String getSqlIfFunction(
			String sCondition,
			String sValueIfYes,
			String sValueIfNo,
			String sAlias)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "IF("+sCondition+","+sValueIfYes+","+sValueIfNo+") "
				+(StringUtilBasic.isNullOrBlank(sAlias)?"":"as "+sAlias);
			break;

		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "Case When "+sCondition+" Then "+sValueIfYes+" Else "+sValueIfNo+" End "+sAlias;
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static String getSqlUpdate(String sTable, String sSet)
	{
		String sSql = null;
		switch (ConnectionManager.getDbType()) {
		case ConnectionManager.DBTYPE_MYSQL:
			sSql = "UPDATE "+sTable+" SET "+sSet;
			break;
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSql = "UPDATE "+sTable+" SET "+sSet+" FROM "+sTable;
			break;

		default:
			break;
		}
		return sSql;
	}
	
	public static void main(String[] args) {
		getSqlAge(
				getSqlIfFunction(
						"cv.id_vehicle IS NULL OR initialOperation.value_datetime IS NULL", 
						"construction.value_string", 
						"initialOperation.value_datetime", 
						""), 
				getSqlCurrentDateFunction(), 
				"age");
	}
}
