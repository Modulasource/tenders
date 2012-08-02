package org.coin.util;

import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CoinJsonUtil {
	public static String getXmlString(
			JSONArray array) 
	throws JSONException
	{
		StringBuilder sb = new StringBuilder();
		for (int i=0 ; i < array.length(); i++) {
			Object o = array.get(i);
			sb.append(getXmlString(o, "o")); 
		}
		
		return sb.toString();
	}

	public static String getXmlString(
			JSONObject obj) 
	throws JSONException
	{
		StringBuilder sb = new StringBuilder();
		Iterator<String> it = obj.keys();
		while( it.hasNext() ){
			String key = it.next();
			Object o = obj.get(key);
			sb.append(getXmlString(o, key)); 
		}
		return sb.toString();
	}	

	public static String getXmlString(
			Object o,
			String sName) 
	throws JSONException
	{
		String s = null;
		if(o instanceof JSONArray )
		{
			JSONArray item = (JSONArray) o;
			s = "<array>" + getXmlString(item) + "</array>\n";
		} else if (o instanceof JSONObject) {
			JSONObject item  = (JSONObject ) o;
			s = "<" + sName + ">\n" + getXmlString(item) + "</" + sName + ">\n";
		} else {
			String sData = o.toString();
			sData = Outils.replaceAll(sData , "&", "&amp;");
			sData = Outils.replaceAll(sData , ">", "&gt;");
			sData = Outils.replaceAll(sData , "<", "&lt;");
			sData = Outils.replaceAll(sData , "'", "&apos;");

			s = "<" + sName + ">" + sData + "</" + sName+ ">\n";
		}
		return s;
	}
	
	
}
