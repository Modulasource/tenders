package org.coin.db;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;


public class Table implements Comparable{
	public String sName;
	public int iId;
	
	
	public int iPosX;
	public int iPosY; 
	public int iWidth = 150;
	public int iHeight = 80;
	
	protected HashMap<Integer,Relation> hmStartRelation; 
	protected HashMap<Integer,Relation> hmEndRelation;
	protected HashMap<Integer,Column> hmColumn;


	
	public Table(String name, int id) {
		sName = name;
		iId = id;
		hmStartRelation = new HashMap<Integer,Relation>();
		hmEndRelation = new HashMap<Integer,Relation>();
		hmColumn = new HashMap<Integer,Column>();
	}

	public Table() {
		hmStartRelation = new HashMap<Integer,Relation>();
		hmEndRelation = new HashMap<Integer,Relation>();
		hmColumn = new HashMap<Integer,Column>();
	}

	public int getId() {
		return iId;
	}

	public void setId(int id) {
		iId = id;
	}

	public String getName() {
		return sName;
	}

	public void setName(String name) {
		sName = name;
	}

	public HashMap<Integer,Relation> getStartRelation() {
		return hmStartRelation;
	}

	public void setStartRelation(HashMap<Integer,Relation> relation) {
		hmStartRelation = relation;
	}
	
	public HashMap<Integer,Relation> getEndRelation() {
		return hmEndRelation;
	}

	public void setEndRelation(HashMap<Integer,Relation> relation) {
		hmEndRelation = relation;
	}
	
	public void addStartRelation(Relation relation) {
		hmStartRelation.put(relation.iId,relation);
	}
	public void addEndRelation(Relation relation) {
		hmEndRelation.put(relation.iId,relation);
	}
	public void addColumn(Column col) {
		hmColumn.put(col.iId,col);
	}
	
	public void addColumn(int iId, Column col) {
		col.iId = iId;
		hmColumn.put(col.iId,col);
	}
	
	public HashMap<Integer,Table> getRelationTables() {
		HashMap<Integer,Table> mapTables = new HashMap<Integer,Table>();
		for(Relation rel : this.hmStartRelation.values())
		{
			mapTables.put(rel.destTable.iId,rel.destTable);
		}
		for(Relation rel : this.hmEndRelation.values())
		{
			mapTables.put(rel.srcTable.iId,rel.srcTable);
		}
		return mapTables;
	}
	
	public Relation getRelationFromTable(int iIdTable) {
		for(Relation rel : this.hmStartRelation.values())
		{
			if(rel.destTable.iId == iIdTable)
				return rel;
		}
		for(Relation rel : this.hmEndRelation.values())
		{
			if(rel.srcTable.iId == iIdTable)
				return rel;
		}
		return null;
	}

	/**
	 * TODO il peut y en avoir plusieur !
	 * @return
	 */
	public Column getPKColumn()
	{
		for(Column col : this.hmColumn.values())
		{
			if(col.bIsPK)
				return col;
		}
		return null;
	}
	
    public boolean equals(Object o) {
    	return ((o != null && o instanceof Table)?(this.iId == ((Table)o).iId):false);
        }

	public int compareTo(Object o) {
    	return ((o != null && o instanceof Table)?this.sName.compareToIgnoreCase(((Table)o).sName):-1);
	}

	public boolean exists(Vector<Table> vTable) {
		
		return ConnectionManager.existsTable(this, vTable);
	}
	
	public Table getTable(Vector<Table> vTable) {
		
		return ConnectionManager.getTable(this, vTable);
	}

	
	public static boolean exists(Table table, Vector<Table> vTable) {
		
		return ConnectionManager.existsTable(table, vTable);
	}
	
	public static Table getTable(Table table, Vector<Table> vTable) {
		
		return ConnectionManager.getTable(table, vTable);
	}

	public static Table getTable(int iIdTable, Vector<Table> vTable) 
	{
		for (Table table : vTable) {
			if(table.iId == iIdTable)
			{
				return table;
			}
		}
		return null;
	}

	
	public static Vector<Table> generateAllTable(
			Vector<String> sarrTableName) 
	{
		Vector<Table> vTable = new Vector<Table>();
		for (String name : sarrTableName) {
			Table table = new Table(name, 0);
			vTable.add(table);
		}
		
		return vTable;
	}
	
	public static Vector<Table> generateAllTable(
			HashMap<Integer,Table> mapTables) 
	{
		Vector<Table> vTable = new Vector<Table>();
		List<Table> listTable = new ArrayList<Table>(mapTables.values());
		Collections.sort(listTable);
		
		
		for(Table table : listTable){
			vTable.add(table);
		}
		
		
		return vTable;
	}
	
	public static Vector<Table> getMissingTableColumns(Vector<Table> vTableA, Vector<Table> vTableB) {
		Vector<Table> vTableMissing = new Vector<Table>();
		for(Table table : vTableA){
			
			Table tableTmp = table.getTable( vTableB);
			if(tableTmp != null)
			{
					
				Vector<Column> vColumn = table.getAllColumn();
				Vector<Column> vColumnTmp = tableTmp.getAllColumn();
				
				boolean bSynchroOk = true;
				for(Column column : vColumn){
					column.iSynchoState = Column.SYNCHO_STATE_NOT_FOUND;
					
					for(Column columnTmp : vColumnTmp){
						if(columnTmp.sName.equalsIgnoreCase(column.sName))
						{
							column.iSynchoState = Column.SYNCHO_STATE_OK;
							break;
						} 
					}
					
					if(column.iSynchoState != Column.SYNCHO_STATE_OK) bSynchroOk = false;
				}
				

				int iMissingFieldCount = 0;
				for(Column columnTmp : vColumnTmp){
					columnTmp.iSynchoState = Column.SYNCHO_STATE_MISSING;
					
					for(Column column : vColumn){
						if(columnTmp.sName.equalsIgnoreCase(column.sName))
						{
							columnTmp.iSynchoState = Column.SYNCHO_STATE_OK;
							break;
						} 
					}

					//System.out.println("");
					
					if(columnTmp.iSynchoState != Column.SYNCHO_STATE_OK){
						/**
						 * field missing
						 */
						bSynchroOk = false;
						iMissingFieldCount ++;
						table.addColumn(1000 + iMissingFieldCount , columnTmp);
					}
				}

				
				
				if(!bSynchroOk)
				{
					vTableMissing.add(table);
				}
				
			}
		}
		
		return vTableMissing;
	}

	public static Vector<Table> getUnionTables(Vector<Table> vTableA, Vector<Table> vTableB) {
		Vector<Table> vTableUnion = new Vector<Table>();
		for(Table table : vTableA){
			if(Table.exists(table, vTableB))
			{
				vTableUnion.add(table);
			}
		}
		return vTableUnion;
	}

	
	public static Vector<Table> getMissingTables(Vector<Table> vTableA, Vector<Table> vTableB) {
		Vector<Table> vTableMissing = new Vector<Table>();
		for(Table table : vTableA){
			if(!Table.exists(table, vTableB))
			{
				vTableMissing.add(table);
			}
		}
		
		return vTableMissing;
	}
	
	
	public  Vector<Column> getAllColumn(){
		Vector<Column> vColumn = new Vector<Column>();
		
		List<Column> listColumn = new ArrayList<Column>(this.hmColumn.values());
		Collections.sort(listColumn);
		
		for(Column column : listColumn){
			vColumn.add(column);
		}
		
		
		return vColumn;
	}
	
	public  Vector<Column> getAllColumnFromDb(Connection conn)
	throws SQLException
	{
		return ConnectionManager.getFieldsFromTableName(this.sName, conn);
	}

	public  void setAllColumn(Vector<Column> vColumn)
	throws SQLException
	{
		int i = 0;
		for (Column column : vColumn) {
			if (column.sTableName.equalsIgnoreCase(this.sName)){
				addColumn(i , column);
				i++;
			}
		}
		
	}
	
	public  void setAllColumnFromDb(Connection conn)
	throws SQLException
	{
			
		 Vector<Column> vColumn =  ConnectionManager.getFieldsFromTableName(this.sName, conn);
		
		
		int i = 0;
		for (Column column : vColumn) {
			addColumn(i , column);
			i++;
		}
	}
	
	// Added by Miguel
	public static int  createTableMissingInDb(Vector<Table> vTable,Connection conn){
		String sTableName	="";
		String sColumnType	="";
		String sColumnName;		
		
		String sQueryCreator;
		String sQueryDrop;
		String sQuery;
		
		int iResp = -1;		
		boolean bConcat;
		
		for(Table table : vTable){
			sColumnName		= "";
			sQueryCreator 	= "";
			sQueryDrop 		= "";
			sQuery 			= "";
			
			bConcat = false;
			sTableName = table.getName();
			System.out.println("--------------------------");
			
			Vector<Column> vColumn = table.getAllColumn();
			for(Column column : vColumn){
				column.sDbNull = (column.sDbNull.equals("YES"))?"NULL" : "NOT NULL";  // check nullable
				if(bConcat){
					sColumnName += ", "+ column.getName() +" "+ column.sDbType +" "+ column.sDbNull; 
				}else{
					sColumnName += column.getName() +" "+ column.sDbType +" "+ column.sDbNull;
					bConcat = true;
				}
			}
			
			sQueryDrop 		= " DROP TABLE "	+ sTableName 	+" ; \n";			
			sQueryCreator 	= " CREATE TABLE "	+ sTableName	+"( "+ sColumnName+ ") ; \n ";
			
			sQuery = sQueryDrop+sQueryCreator;
			System.out.println(sQuery);
			
			//iResp = ConnectionManager.createTableInDb(sQuery,conn);
		}
				
		return 1;
	}
	
	
}
