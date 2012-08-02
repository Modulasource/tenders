/*
 * Created on 8 mars 2005
 *
 */
package org.coin.util;

/**
 * @author d.keller
 *
 */
public class SearchEngineArrayHeaderItem {
	public String sFieldName;
	public String sFieldLibelle;
	public int iFieldType;
	
	public static final int FIELD_TYPE_NONE = 0; 
	public static final int FIELD_TYPE_STRING = 1; 
	public static final int FIELD_TYPE_INTEGER = 2; 
	public static final int FIELD_TYPE_DATETIME = 3; 
	
	public SearchEngineArrayHeaderItem() {
		this.sFieldName = "";
		this.sFieldLibelle = "";
		this.iFieldType = FIELD_TYPE_NONE;

	}

	public SearchEngineArrayHeaderItem(
			String sFieldName,
			String sFieldLibelle,
			int iFieldType) {
		this.sFieldName = sFieldName;
		this.sFieldLibelle = sFieldLibelle;
		this.iFieldType = iFieldType;

	}
}
