package org.coin.util;

import java.sql.Connection;

import mt.modula.batch.RemoteControlServiceConnection;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Node;
import nu.xom.Nodes;
import nux.xom.xquery.XQueryUtil;

import org.coin.bean.ged.GedDocument;

public class CoinXQueryUtil {

	/**
	 * Return the string result of xquery,
	 * if the xquery match more than one result, return the first one.
	 * if the xquery dont match any result, return an empty string
	 * @param doc
	 * @param xquery
	 * @return
	 */
	public static String getStringFromQuery(Document doc, String xquery){
		Nodes results = XQueryUtil.xquery(doc, xquery);
		if( results.size()==0 ) { return ""; }
		return results.get(0).getValue();
	}

	/**
	 * Return the string value for an node attribute.
	 * @param doc
	 * @param xpathNode
	 * @param xpathAttr
	 * @return
	 */
	public static String getStringFromAttribute(
			Document doc, 
			String xpathNode, 
			String xpathAttr){
		String xquery = "for $n in " + xpathNode + " return text {$n"+xpathAttr+"}";
		return getStringFromQuery(doc,xquery);
	}
	
	public static void main(String[] args){
		RemoteControlServiceConnection rcsc = 
			new RemoteControlServiceConnection(
					"jdbc:mysql://m1.mtsoftware.fr:3306/modula_test?", 
					"dba_account", 
					"dba_account");
		try {
			Connection conn = rcsc.getConnexionMySQL();
			GedDocument gedDoc = GedDocument.getGedDocument(7456,false,conn);
			Document doc = new Builder().build(gedDoc.getDocumentFile(conn));
			String xqlPrefixMandat = "//Piece[BlocPiece/InfoPce/IdPce/@V='"+"1717"+"']";
			System.out.println(getStringFromAttribute(doc, xqlPrefixMandat, "/BlocPiece/InfoPce/Obj/@V"));
			
		}catch(Exception e) { e.printStackTrace(); }
	}
}
