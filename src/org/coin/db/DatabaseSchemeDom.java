package org.coin.db;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import org.w3c.dom.Document;

public class DatabaseSchemeDom {
	
	public Document doc;
	public HashMap<Integer,Table> mapTables;
	public int[] canvasSize; 
	
	public Vector<Table> vTable;
	public Vector<Region> vRegion;
	public Vector<Relation> vRelation ;
	
	public DatabaseSchemeDom(
			Document doc)
	{
		this.doc = doc;
	} 
	

	public void computeVectorAllTable()
	{
		this.vTable = generateAllTable(mapTables);
	}

	public Table getTableSource(
			Relation relation)
	{
		return Table.getTable(relation.iIdSrcTable, this.vTable);
	}

	public Table getTableDestination(
			Relation relation)
	{
		return Table.getTable(relation.iIdDestTable, this.vTable);
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
}
