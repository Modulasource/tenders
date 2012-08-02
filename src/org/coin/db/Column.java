package org.coin.db;

import java.util.Vector;

public class Column implements Comparable{
	
	public static final int SYNCHO_STATE_OK = 1;
	public static final int SYNCHO_STATE_MODIFIED = 2;
	public static final int SYNCHO_STATE_NOT_FOUND = 3;
	public static final int SYNCHO_STATE_MISSING = 4;
	

	public String getStateName()
	{
		switch (this.iSynchoState) {
		case SYNCHO_STATE_OK:
			return "OK";

		case SYNCHO_STATE_MODIFIED:
			return "modifed";

		case SYNCHO_STATE_NOT_FOUND:
			return "not found";
			
		case SYNCHO_STATE_MISSING:
			return "missing";
			
		default:
			break;
		}
		return "iSynchoState unknown ? " + this.iSynchoState;
	}
	
	public String sName;

	
	/** 
	 * Info from scheme 
	 */
	public int iId;
	public boolean bIsPK;
	public int iIdDataType;

	/**
	 * Info from database
	 */
	public String sTableName;
	
	public String sDbType ;
	public String sDbCollation;
	public String sDbNull;
	public String sDbKey;
	public String sDbDefault;
	public String sDbExtra;
	public String sDbPrivileges;
	public String sDbComment;

	
	/**
	 * computed
	 */
	
	public int iSynchoState ;
	
	public Column() {
	}
	
	public Column(int id, String name, boolean isPK) {
		this.iId = id;
		this.sName = name;
		this.bIsPK = isPK;
	}
	
	
	public boolean isPK() {
		return this.bIsPK;
	}
	public void setPK(boolean isPK) {
		this.bIsPK = isPK;
	}
	public int getId() {
		return this.iId;
	}
	public void setId(int id) {
		this.iId = id;
	}
	public String getName() {
		return this.sName;
	}
	public void setName(String name) {
		this.sName = name;
	}
	public int getIdDataType() {
		return this.iIdDataType;
	}
	public void setIdDataType(int idDataType) {
		this.iIdDataType = idDataType;
	}
	
    public boolean equals(Object o) {
    	return ((o != null && o instanceof Column)?(this.iId == ((Column)o).iId):false);
        }

	public int compareTo(Object o) {
    	return ((o != null && o instanceof Column)?this.sName.compareToIgnoreCase(((Column)o).sName):-1);
	}

	//Add by Miguel
	public static String createAlterColumnMissingInDb(Vector<Table> vTableColumnMissingInDb){
		String sQueryAlterColumnMissingIndDb = "";
		
		for(Table table : vTableColumnMissingInDb){					
			Vector<Column> vColumn = table.getAllColumn();			
			for(Column column : vColumn){				
				column.sDbNull = (column.sDbNull.equals("YES"))? "NULL" : "NOT NULL"; // check nullable
				if(column.getStateName().equals("not found")){
					sQueryAlterColumnMissingIndDb += " \n ALTER TABLE "+table.getName()+
					 								" ADD COLUMN " +
					 								" "+column.getName()+
					 								" "+column.sDbType+
					 								" "+column.sDbNull+
					 								" ;";
				}
				
			}
			
		}
		return sQueryAlterColumnMissingIndDb;
	}
}
