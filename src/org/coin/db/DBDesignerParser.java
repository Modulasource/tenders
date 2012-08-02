package org.coin.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.conf.Configuration;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.coin.util.BasicDom;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

@RemoteProxy
public class DBDesignerParser {

	//TODO : a charger depuis le modele
	public static int DATATYPE_LONGBLOB = 26;
	public static String OBJECT_BALISE = "[iIdRefObject]";
	public static String BINARY_OBJECT_BALISE = "[iIdBinaryRefObject]";
	public static String BINARY_OBJECT_BALISE_URL = "%5BiIdBinaryRefObject%5D";

	
	public static void main(String[] args) throws Exception
	{
		//String sXMLFilePath = "D:\\_sources\\eclipse_galileo\\modula_core\\config\\database\\scheme\\MODULA-011-12Y Schema de la base de donnees.xml"; 
		//String sXMLFilePath = "C:\\Users\\miguel\\tucma\\workspace\\modula_wtp07\\config\\database\\scheme\\MODULA-011-12U Schema de la base de donnees.xml"; 
		//RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://localhost:3306/prueba?","root", "root");
		//String sDbNameA =  "modula_affiches_grenoble";
		String sXMLFilePath = "D:\\developpement\\sources\\micimmo\\src\\mt\\micimmo\\schema\\MICI-035-12H Schema de la base de donnees.xml";
		//RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://localhost:3306/test_db?","dba_account", "dba_account");
		//RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://ns60388.ovh.net:3306/"+ sDbNameA + "?","dev", "19012010");
		//Connection connA = a.getConnexionMySQL();

		//String sDbNameB =  "modula_affiches_grenoble";
		//RemoteControlServiceConnection b = new RemoteControlServiceConnection("jdbc:mysql://serveur23.matamore.com:3306/" + sDbNameB + "?","dba_account", "dba_account");
		String sDbNameB =  "mtcrm_isi_recette";
		RemoteControlServiceConnection b = new RemoteControlServiceConnection("jdbc:mysql://serveur24.matamore.com:3306/" + sDbNameB + "?","dba_account", "dba_account");
		Connection connB = b.getConnexionMySQL();
		

		System.out.println("Start ! ... (peut prendre 20 s pour un schéma de 300 tables)");

		
		/**
		 * A
		 */

		// Example using 2 Data Base Mysql
		//a.sInstanceName = sDbNameA;
		//System.out.println("*****DATA BASE (A) " + a.sInstanceName);
		long lStartA = System.currentTimeMillis();
		Document doc =  BasicDom.parseXmlFile(sXMLFilePath, false);
		
		/**
		 * XML file
		 */
		HashMap<Integer,Table> mapTablesInScheme = getAllTable(doc);
		Vector<Table> vTableA = Table.generateAllTable(mapTablesInScheme);
		
		/**
		 * DB instance
		 */
		//Vector<Table> vTableA = ConnectionManager.getAllTable(-1, true, conn);
		//Vector<Table> vTableA = ConnectionManager.getTableAllFromInformationSchema(-1, true, conn,a.sInstanceName);
		long lStopA = System.currentTimeMillis();
		System.out.println("time A IS : " + (lStopA - lStartA) + " ms table=" + vTableA.size());
		
		
		/**
		 * B
		 */		
		long lStartB = System.currentTimeMillis();
		b.sInstanceName = sDbNameB;
		System.out.println("\n*****DATA BASE (B) " + b.sInstanceName);
		Vector <Table> vTableB = ConnectionManager.getTableAllFromInformationSchema(-1,true,connB ,b.sInstanceName);
		long lStopB = System.currentTimeMillis();
		System.out.println("time B IS : " + (lStopB - lStartA) + " ms table=" + vTableB.size());
		
		/*
		long lStartB = System.currentTimeMillis();
		Document doc =  BasicDom.parseXmlFile(sXMLFilePath, false);
		HashMap<Integer,Table> mapTablesInScheme = getAllTable(doc);
		Vector<Table> vTableB = Table.generateAllTable(mapTablesInScheme);
		//Vector<Table> vTableB = ConnectionManager.getAllTable(true, connB);
		long lStopB = System.currentTimeMillis();
		System.out.println("time B : " + (lStopB - lStartB) + " ms table=" + vTableB.size());
	*/
		
		
		
		System.out.println("\nmissing column's table in db list : ");
		
		/*******************************/		
		Vector <Table> vTableMissing = Table.getMissingTables(vTableA, vTableB);				
		Vector<Table> vTableColumnMissingInDb = Table.getMissingTableColumns(vTableA, vTableB);
		
		for(Table table : vTableColumnMissingInDb){
			System.out.println("- " + table.sName);			
			Vector<Column> vColumn = table.getAllColumn();			
			for(Column column : vColumn){
				System.out.println( "\t[state " + column.getStateName() + "] '" + column.sName + "'");				
			}
			System.out.println();
		}
		
		System.out.println("\nmissing table in db list : ");
		Vector<Table> vTableMissingInDb = Table.getMissingTables(vTableB, vTableA);
		for(Table table : vTableMissingInDb){
			System.out.println("- " + table.sName);
			
		}
		
		System.out.println("\nmissing table in scheme list : ");
		Vector<Table> vTableMissingInScheme = Table.getMissingTables(vTableA, vTableB);
		
		
		for(Table table : vTableMissingInScheme){
			System.out.println("- " + table.sName);
		}
		
		/*
		// add by miguel
		System.out.println("\n*** Begin Create Table ***");
		Table.createTableMissingInDb(vTableMissingInScheme,conn);		
		System.out.println("\n*** Begin Alter Table ***");
		System.out.println(Column.createAlterColumnMissingInDb(vTableColumnMissingInDb));
		//------
		 * 
		 */
		
		//ConnectionManager.closeConnection(connA);
		ConnectionManager.closeConnection(connB);
	}
	
	public static DatabaseSchemeDom getDatabaseSchemeDom(
			Document doc ) 
	throws SAXException
	{
		DatabaseSchemeDom dom = new DatabaseSchemeDom(doc);
		dom.mapTables = getAllTable(doc);
		dom.vRegion = getAllRegion(doc);
		dom.vRelation = getAllRelation(doc);
		dom.computeVectorAllTable();
		dom.canvasSize = getCanvasSize(doc);
		return dom;
	}
	
	public static HashMap<Integer,Table> getAllTable(
			String sXMLFilePath)
	throws SAXException 
	{
		Document doc =  BasicDom.parseXmlFile(sXMLFilePath, false);
		return getAllTable(doc);
	}

	
	public static Vector<Region> getAllRegion(
			Document doc )
	throws SAXException 
	{
		Node node = BasicDom.getFirstChildElementNode(doc);
		Node nodeMetadata = BasicDom.getChildNodeByNodeName(node,"METADATA");
		Node nodeRegions = BasicDom.getChildNodeByNodeName(nodeMetadata,"REGIONS");
		Vector<Region> vRegion = new Vector<Region>();
		
		for(Node item = BasicDom.getFirstChildElementNode(nodeRegions ); 
		item != null; 
		item = BasicDom.getNextSiblingElementNode(item))
		{
			/**
			 * Example :
			 * <REGION 
			  	ID="146751" 
				  RegionName="vehicle" 
				  XPos="2380" 
				  YPos="3810" 
				  Width="2358" 
				  Height="1688" 
				  RegionColor="3" 
				  TablePrefix="0" 
				  TableType="0" 
				  OverwriteTablePrefix="0" 
				  OverwriteTableType="0" 
				  Comments="" 
				  IsLinkedObject="0" 
				  IDLinkedModel="-1" 
				  Obj_id_Linked="-1" 
				  OrderPos="619" />

			 * 
			 */
			
			Region region = new Region();
			region.iId = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"ID");
			region.sName = BasicDom.getNamedAttributeStringValueIso_8859_1(item.getAttributes(),"RegionName");
			region.iPosX = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"XPos");
			region.iPosY = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"YPos");
			region.iWidth = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"Width");
			region.iHeight = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"Height");
			region.iRegionColorIndex = BasicDom.getNamedAttributeIntValue(item.getAttributes(),"RegionColor");
			
			vRegion.add(region);
		}
		
		return  vRegion;
	}

	public static int[] getCanvasSize(
			Document doc )
	throws SAXException 
	{
		Node node = BasicDom.getFirstChildElementNode(doc);
		Node nodeSettings = BasicDom.getChildNodeByNodeName(node,"SETTINGS");
		Node nodeGlobalSettings = BasicDom.getChildNodeByNodeName(nodeSettings,"GLOBALSETTINGS");
		
		int[] size = new int[2];
		size[0] =  BasicDom.getNamedAttributeIntValue(nodeGlobalSettings.getAttributes(),"CanvasWidth");
		size[1] = BasicDom.getNamedAttributeIntValue(nodeGlobalSettings.getAttributes(),"CanvasHeight");
		
		
		return  size;
	}

	public static Vector<Relation> getAllRelation(
			Document doc )
	throws SAXException 
	{
		Vector<Relation> vRelation = new Vector<Relation>();
		
		Node node = BasicDom.getFirstChildElementNode(doc);
		Node nodeMetadata = BasicDom.getChildNodeByNodeName(node,"METADATA");
		Node nodeRelations = BasicDom.getChildNodeByNodeName(nodeMetadata,"RELATIONS");
		for(Node nodeRelation = BasicDom.getFirstChildElementNode(nodeRelations ); 
		nodeRelation != null; 
		nodeRelation = BasicDom.getNextSiblingElementNode(nodeRelation))
		{
			if(nodeRelation!=null)
			{
				/**
				 * <RELATION ID="1263" 
				 * RelationName="organsation" 
				 * Kind="2" 
				 * SrcTable="1257" 
				 * DestTable="1236" 
				 * FKFields="id_organisation=id_organisation\n" 
				 * FKFieldsComments="\n" 
				 * relDirection="4" 
				 * MidOffset="133" 
				 * OptionalStart="0" 
				 * OptionalEnd="0" 
				 * CaptionOffsetX="0" 
				 * CaptionOffsetY="0" 
				 * StartIntervalOffsetX="0" 
				 * StartIntervalOffsetY="0" 
				 * EndIntervalOffsetX="0" 
				 * EndIntervalOffsetY="0" 
				 * CreateRefDef="1" 
				 * Invisible="0" 
				 * RefDef="Matching=0\nOnDelete=3\nOnUpdate=3\n" 
				 * Comments="" 
				 * FKRefDefIndex_Obj_id="-1" 
				 * Splitted="0" 
				 * IsLinkedObject="0" 
				 * IDLinkedModel="-1" 
				 * Obj_id_Linked="-1" 
				 * OrderPos="26" />

					Kind : 
					1 TODO get desc
					2 TODO get desc

					relDirection :
					1 TODO get desc
					2 TODO get desc
					3 TODO get desc
					4 TODO get desc

				 */
				String sSourceTableID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"SrcTable");
				String sDestTableID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"DestTable");

				String sFK = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"FKFields");
				String sID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"ID");
				String sName = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"RelationName");
				Relation rel = new Relation(
						Integer.parseInt(sID),
						Integer.parseInt(sSourceTableID),
						Integer.parseInt(sDestTableID),
						sFK);
				rel.setName(sName);
				
				vRelation.add(rel);
			}
		}
		
		return vRelation;
	}

	public static HashMap<Integer,Table> getAllTable(
			Document doc )
	throws SAXException 
	{
		Vector<Relation> vRelation = getAllRelation(doc);
		return getAllTable(doc, vRelation);
	}
	
	public static HashMap<Integer,Table> getAllTable(
			Document doc ,
			Vector<Relation> vRelation)
	throws SAXException 
	{
		Node node = BasicDom.getFirstChildElementNode(doc);
		Node nodeMetadata = BasicDom.getChildNodeByNodeName(node,"METADATA");
		Node nodeTables = BasicDom.getChildNodeByNodeName(nodeMetadata,"TABLES");

		HashMap<Integer,Table> mapTables = new HashMap<Integer,Table>();
		for(Node nodeTable = BasicDom.getFirstChildElementNode(nodeTables ); 
		nodeTable != null; 
		nodeTable = BasicDom.getNextSiblingElementNode(nodeTable))
		{
			if(nodeTable!=null)
			{
				/**
				 * <TABLE ID="1003" 
				 * Tablename="coin_user" 
				 * PrevTableName="user" 
				 * XPos="6353" 
				 * YPos="1613" 
				 * TableType="0" 
				 * TablePrefix="0" 
				 * nmTable="0" 
				 * Temporary="0" 
				 * UseStandardInserts="0" 
				 * StandardInserts="\n" 
				 * TableOptions="DelayKeyTblUpdates=0\nPackKeys=0\nRowChecksum=0\nRowFormat=0\nUseRaid=0\nRaidType=0\n" 
				 * Comments="" 
				 * Collapsed="0" 
				 * IsLinkedObject="0" 
				 * IDLinkedModel="-1" 
				 * Obj_id_Linked="-1" 
				 * OrderPos="292" >
				 * <COLUMNS>
					<COLUMN />
					<COLUMN />
					...
				   </COLUMNS>
					<RELATIONS_START>
					   <RELATION_START ID="xxx" />
					    ...
					</RELATIONS_START>
					<RELATIONS_END>
					   <RELATION_END ID="xxx" />
					    ...
					</RELATIONS_END>
					<INDICES>
						<INDEX ID="1014" IndexName="PRIMARY" IndexKind="0" FKRefDef_Obj_id="-1">
							<INDEXCOLUMNS>
								<INDEXCOLUMN idColumn="1542" LengthParam="0" />
							</INDEXCOLUMNS>
						</INDEX>
						<INDEX ID="2089" IndexName="mt_user_idx_login" IndexKind="1" FKRefDef_Obj_id="-1">
							<INDEXCOLUMNS>
								<INDEXCOLUMN idColumn="1009" LengthParam="0" />
							</INDEXCOLUMNS>
						</INDEX>
					</INDICES>
					</TABLE>
				 * 
				 */
				
				
				String sTableName = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeTable.getAttributes(),"Tablename");
				String sTableID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeTable.getAttributes(),"ID");
				Table table = new Table(sTableName,Integer.parseInt(sTableID));
				table.iPosX = BasicDom.getNamedAttributeIntValue(nodeTable.getAttributes(), "XPos");
				table.iPosY = BasicDom.getNamedAttributeIntValue(nodeTable.getAttributes(), "YPos");
				
				Node nodeColumns = BasicDom.getChildNodeByNodeName(nodeTable,"COLUMNS");
				for(Node nodeColumn = BasicDom.getFirstChildElementNode(nodeColumns ); 
				nodeColumn != null; 
				nodeColumn = BasicDom.getNextSiblingElementNode(nodeColumn))
				{
					if(nodeColumn!=null)
					{
						/**
						 * <COLUMN ID="1542" 
						 * 	ColName="id_coin_user" 
						 * PrevColName="" 
						 * Pos="6" 
						 * idDatatype="5" 
						 * DatatypeParams="" 
						 * Width="-1" 
						 * Prec="-1" 
						 * PrimaryKey="1" 
						 * NotNull="1" 
						 * AutoInc="1" 
						 * IsForeignKey="0" 
						 * DefaultValue="" 
						 * Comments="">
							<OPTIONSELECTED>
							<OPTIONSELECT Value="1" />
							<OPTIONSELECT Value="0" />
							</OPTIONSELECTED>

						 */
						String sColumnName = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeColumn.getAttributes(),"ColName");
						String sColumnID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeColumn.getAttributes(),"ID");
						String sPK = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeColumn.getAttributes(),"PrimaryKey");
						String sIdDataType = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeColumn.getAttributes(),"idDatatype");
						
						Column column 
								= new Column(
										Integer.parseInt(sColumnID),
										sColumnName,
										(sPK.equalsIgnoreCase("1")?true:false));
						int iIdDataType = Integer.parseInt(sIdDataType);
						column.setIdDataType(iIdDataType);
						table.addColumn(column);
					}
				}

				mapTables.put(table.iId,table);
			}
		}

		Node nodeRelations = BasicDom.getChildNodeByNodeName(nodeMetadata,"RELATIONS");
		for(Node nodeRelation = BasicDom.getFirstChildElementNode(nodeRelations ); 
		nodeRelation != null; 
		nodeRelation = BasicDom.getNextSiblingElementNode(nodeRelation))
		{
			if(nodeRelation!=null)
			{
				String sSourceTableID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"SrcTable");
				String sDestTableID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"DestTable");
				Table srcTable = mapTables.get(Integer.parseInt(sSourceTableID));
				Table destTable = mapTables.get(Integer.parseInt(sDestTableID));
				String sID = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"ID");
				/*
				String sFK = BasicDom.getNamedAttributeStringValueIso_8859_1(nodeRelation.getAttributes(),"FKFields");
				Relation rel = new Relation(Integer.parseInt(sID),srcTable,destTable,sFK);
				 */
				
				Relation rel = Relation.getRelation(Integer.parseInt(sID), vRelation);
				srcTable.addStartRelation(rel);
				destTable.addEndRelation(rel);

				/**
				 * why ?
				 */
				//mapTables.put(srcTable.iId,srcTable);
				//mapTables.put(destTable.iId,destTable);
			}
		}


		
		
		return mapTables;
	}

	public static HashMap<Integer,Table> parseDBScheme(int iIdTypeConstraint)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
	IllegalAccessException, SAXException {
		String sSchemaPath = Configuration.getConfigurationValueMemory("application.db.scheme.path");
		String sSchemaFilename = Configuration.getConfigurationValueMemory("application.db.scheme.filename");

		return getAllTable(sSchemaPath+sSchemaFilename /*,iIdTypeConstraint*/);
	}

	@SuppressWarnings("unchecked")
	public static JSONArray convertMapToJSONArray(HashMap<Integer,Table> mapTables) throws JSONException
	{
		JSONArray json = new JSONArray();

		JSONObject init = new JSONObject();
		init.put("value","selectionner une table");
		init.put("data",0);
		json.put(init);

		List<Table> listTable = new ArrayList<Table>(mapTables.values());
		Collections.sort(listTable);
		for(Table table : listTable){
			JSONObject obj = new JSONObject();
			obj.put("value",table.getName());
			obj.put("data",table.getId());

			List<Column> listColumn = new ArrayList<Column>(table.hmColumn.values());
			Collections.sort(listColumn);
			JSONArray json_column = new JSONArray();
			for(Column col : listColumn)
			{
				JSONObject column = new JSONObject();
				column.put("value",col.getName());
				column.put("data",col.getId());
				json_column.put(column);
			}
			obj.put("columns",json_column);
			json.put(obj);

		}
		return json;
	}

	@RemoteMethod
	public static String getJSONDBScheme(int iIdTypeConstraint)
	throws CoinDatabaseLoadException, JSONException, SQLException, NamingException, InstantiationException,
	IllegalAccessException, SAXException 
	{
		return convertMapToJSONArray(parseDBScheme(iIdTypeConstraint)).toString();
	}

	@RemoteMethod
	public static String getJSONDBSchemeFromTable(String sTable,int iIdTypeConstraint)
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
	IllegalAccessException, SAXException 
	{
		HashMap<Integer,Table> mapTables = parseDBScheme(iIdTypeConstraint);
		for(Table table : mapTables.values())
		{
			if(table.sName.equalsIgnoreCase(sTable))
			{
				HashMap<Integer,Table> mapTableSelected = new HashMap<Integer,Table>();
				mapTableSelected.put(table.iId,table);
				return convertMapToJSONArray(mapTableSelected).toString();
			}
		}
		return null;
	}

	@RemoteMethod
	public static String getRelationTables(int iId,int iIdTypeConstraint)
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, SAXException 
	{
		HashMap<Integer,Table> mapTables = parseDBScheme(iIdTypeConstraint);
		return convertMapToJSONArray(mapTables.get(iId).getRelationTables()).toString();
	}

	@RemoteMethod
	public static String getSQLQueryFromFieldRequest(
			int[] tabIdTable,
			int iIdColumn, 
			String sTableRef, 
			int iIdRefObject,
			int iIdTypeConstraint)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
	IllegalAccessException, SAXException
	{
		if(tabIdTable != null && tabIdTable.length>0)
		{
			HashMap<Integer,Table> mapTables = parseDBScheme(iIdTypeConstraint);
			Table table = mapTables.get(tabIdTable[tabIdTable.length-1]);
			Column column = table.hmColumn.get(iIdColumn);

			String sSelect = "SELECT "+table.sName+"."+column.sName;
			//if binary field
			if(column.iIdDataType == DATATYPE_LONGBLOB)
			{
				Column pk = null;
				String sFileName = "";
				String sContentType = "";
				for(Column col : table.hmColumn.values())
				{
					if(col.isPK())
						pk = col;
					if(col.sName.contains("name") && col.sName.contains("file"))
						sFileName = col.sName;
					if(col.sName.contains("content") && col.sName.contains("type"))
						sContentType = col.sName;
				}
				String sBinarySQL = "SELECT "+table.sName+"."+column.sName
				+ " FROM "+table.sName
				+ " WHERE "+table.sName+"."+pk.getName()+"="+BINARY_OBJECT_BALISE;

				sSelect = "SELECT "+table.sName+"."+pk.sName+(!sFileName.equalsIgnoreCase("")?(", "+table.sName+"."+sFileName):"''")+" as filename"+(!sContentType.equalsIgnoreCase("")?(", "+table.sName+"."+sContentType):"''")+" as contenttype"+", '"+sBinarySQL+"'"+" as binarysql";
			}
			int iIdPrevTable = table.iId;

			String sFromClause = " FROM "+table.sName;
			String sWhereClause = " WHERE ";
			ArrayList<String> tabWhereClause = new ArrayList<String>();

			boolean bAddedRef = false;
			if(!sTableRef.equalsIgnoreCase("") && sTableRef.equalsIgnoreCase(table.sName))
			{
				tabWhereClause.add(table.sName+"."+table.getPKColumn().sName+"="+((iIdRefObject>0)?(iIdRefObject):"[iIdRefObject]"));
				bAddedRef = true;
			}

			for(int i=(tabIdTable.length-2);i>=0;i--)
			{
				table = mapTables.get(tabIdTable[i]);

				sFromClause+=", "+table.sName;

				Relation rel = table.getRelationFromTable(iIdPrevTable);
				String[] sRel = rel.sRelation.replaceAll("\\\\n","").split("=");
				tabWhereClause.add(rel.srcTable.sName+"."+sRel[0]+"="+rel.destTable.sName+"."+sRel[1]);

				if(!bAddedRef && !sTableRef.equalsIgnoreCase("") && iIdRefObject!=-1 && sTableRef.equalsIgnoreCase(table.sName))
				{
					tabWhereClause.add(table.sName+"."+table.getPKColumn().sName+"="+((iIdRefObject>0)?(iIdRefObject):"[iIdRefObject]"));
					bAddedRef = true;
				}

				iIdPrevTable = table.iId;
			}

			for(int i=0;i<tabWhereClause.size();i++)
			{
				sWhereClause += tabWhereClause.get(i);
				if(i<(tabWhereClause.size()-1))
					sWhereClause += " AND ";
			}
			return sSelect+sFromClause+sWhereClause;
		}
		return null;
	}



	public static ArrayList<ArrayList<String>> executeGlobalBinarySQL(
			String sSQLQuery)
	throws SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection();

		try{
			return executeGlobalBinarySQL(sSQLQuery, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}

	}


	public static ArrayList<ArrayList<String>> executeGlobalBinarySQL(
			String sSQLQuery,
			Connection conn)
	throws SQLException, NamingException {
		ArrayList<ArrayList<String>> aList = new ArrayList<ArrayList<String>>();

		Statement stat = null;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			stat = (stat.getConnection()).createStatement();
			rs = stat.executeQuery(sSQLQuery);
			while(rs.next())
			{
				ArrayList<String> aData = new ArrayList<String>();
				String sId = rs.getString(1);
				aData.add(sId);
				String sFileName = rs.getString("filename");
				aData.add(sFileName);
				String sContentType = rs.getString("contenttype");
				aData.add(sContentType);
				String sBinaryObjectSQL = rs.getString("binarysql");
				aData.add(sBinaryObjectSQL);

				aList.add(aData);
			}
		}
		finally {
			ConnectionManager.closeConnection(rs,stat);
		}

		return aList;
	}


	public static ArrayList<String> getDataFromFieldRequest(int[] tabIdTable, int iIdColumn, String sTableRef, int iIdRefObject,int iIdTypeConstraint) throws Exception{

		return ConnectionManager.executeSQLSelectLongVarBinary(getSQLQueryFromFieldRequest(tabIdTable,iIdColumn,sTableRef,iIdRefObject,iIdTypeConstraint));
	}

	public static ArrayList<String> getDataFromSQLQuery(String sSQLQuery,int iIdRefObject) throws JSONException, SQLException, NamingException{

		return ConnectionManager.executeSQLSelectLongVarBinary(getParseSQLQuery(sSQLQuery,OBJECT_BALISE,iIdRefObject));
	}

	public static ArrayList<ArrayList<String>> getDataFromGlobalBinarySQLQuery(String sSQLQuery,int iIdRefObject) throws JSONException, SQLException, NamingException{

		return executeGlobalBinarySQL(getParseSQLQuery(sSQLQuery,OBJECT_BALISE,iIdRefObject));
	}

	public static String getParseSQLQuery(String sSQLQuery,String sBalise,int iIdRefObject) throws JSONException, SQLException, NamingException{

		return Outils.replaceAll(sSQLQuery,sBalise,Integer.toString(iIdRefObject));
	}
}
