package org.coin.db;

import java.util.Vector;

public class Relation {
	
	protected int iId;
	protected String sName;
	
	/**
	 * its mandatory for parsing, 
	 * its not a good idea to have strong links between objects
	 */
	protected int iIdSrcTable;
	protected Table srcTable;
	
	protected int iIdDestTable;
	protected Table destTable;
	
	protected String sRelation;
	
	public Relation() { }
	
	public Relation(
			int iId,
			Table srcTable, 
			Table destTable, 
			String sRelation) 
	{
		this.iId = iId;
		setDestTable(destTable);
		setSrcTable(srcTable);
		this.sRelation = sRelation;
	}

	public Relation(
			int iId,
			int iIdSrcTable, 
			int iIdDestTable, 
			String sRelation) 
	{
		this.iId = iId;
		this.iIdSrcTable = iIdSrcTable;
		this.iIdDestTable = iIdDestTable;
		this.sRelation = sRelation;
	}

	
	public int getId() { return iId;}
	public void setId(int id) { iId = id;}

	public String getName() { return sName;}
	public void setName(String sName) { this.sName = sName;}

	public String getRelation() { return sRelation; }
	public void setRelation(String relation) { sRelation = relation;}

	public Table getDestTable() {
		return destTable;
	}
	public void setDestTable(Table destTable) {
		this.iIdDestTable = destTable.getId();
		this.destTable = destTable;
	}
	public Table getSrcTable() {
		return srcTable;
	}
	public void setSrcTable(Table srcTable) {
		this.iIdSrcTable = srcTable.getId();
		this.srcTable = srcTable;
	}
	


	
	public static Relation getRelation(
			int iId,
			Vector<Relation> vRelation)
	{
		for (Relation relation : vRelation) {
			if(relation.iId == iId)
			{
				return relation;
			}
		}
		return null;
	}
}
