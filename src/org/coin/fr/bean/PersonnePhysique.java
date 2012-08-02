/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 15 mars 2004
 *
 */
package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Map;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import modula.marche.VeilleMarcheAbonnes;
import mt.common.addressbook.AddressBookMerger;

import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.bean.ws.PersonnePhysiqueWebService;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.coin.mail.Mail;
import org.coin.security.PreventSqlInjection;
import org.coin.util.BasicDom;
import org.coin.util.HttpUtil;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

@RemoteProxy
public class PersonnePhysique extends CoinDatabaseAbstractBean {
	private static final long serialVersionUID = 1L;
	protected static String TABLE_CIVILITE = "personne_physique_civilite";
	
	protected String sIdNationalite;
	protected int iIdAdresse;
	protected int iIdPersonnePhysiqueCivilite;
	protected int iIdOrganisation;
	protected String sNom;
	protected String sPrenom;
	protected String sFonction;
	protected String sTel;
	protected String sEmail;
	protected String sFax;
	protected String sTelPortable;
	protected Timestamp tsDateCreation;
	protected Timestamp tsDateModification;
	protected String sReferenceExterne;
	protected String sSiteWeb;
	protected String sPoste;
	protected boolean bAlerteMail;
	protected String sInitials;
	
	protected long lIdObjectTypeOwner;
	protected long lIdObjectReferenceOwner;
	
	protected boolean bCreateIndividualCheckDuplicate;

	public static final int GET_NAME_TYPE_FIRST_NAME_LAST_NAME = 1;
	public static final int GET_NAME_TYPE_LAST_NAME_FIRST_NAME = 2;
	public static final int GET_NAME_TYPE_TITLE_FIRST_NAME_LAST_NAME = 3;
	public static final int GET_NAME_TYPE_FIRST_NAME_LAST_NAME_EMAIL = 4;
	public static final int GET_NAME_TYPE_TITLE_FIRST_NAME_LAST_NAME_FUNCTION = 5;
	
	public int iGetNameType = GET_NAME_TYPE_TITLE_FIRST_NAME_LAST_NAME;
	
	protected static Map<String,String>[] s_sarrLocalizationLabel;

	
	public boolean isCreateIndividualCheckDuplicate() {
		return this.bCreateIndividualCheckDuplicate ;
	}

	public void setCreateIndividualCheckDuplicate(
			boolean bCreateIndividualCheckDuplicate) {
		this.bCreateIndividualCheckDuplicate = bCreateIndividualCheckDuplicate;
	}
	
	
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		ps.setString(1, preventStore(getIdNationalite()));
		ps.setInt(2, getIdAdresse());
		ps.setInt(3, getIdPersonnePhysiqueCivilite());
		ps.setInt(4, getIdOrganisation());
		ps.setString(5, preventStore(this.sNom));
		ps.setString(6, preventStore(this.sPrenom));
		ps.setString(7, preventStore(this.sFonction));
		ps.setString(8, preventStore(this.sTel));
		ps.setString(9, preventStore(this.sEmail));
		ps.setString(10, preventStore(this.sFax));
		ps.setString(11, preventStore(this.sTelPortable));
		ps.setTimestamp(12, this.tsDateCreation); 
		ps.setTimestamp(13, this.tsDateModification); 
		ps.setString(14, preventStore(this.sReferenceExterne));
		ps.setString(15, preventStore(this.sSiteWeb));
		ps.setString(16, preventStore(this.sPoste));
		ps.setBoolean(17, this.bAlerteMail);
		ps.setString(18, preventStore(this.sInitials));
		ps.setLong(19, this.lIdObjectTypeOwner);
		ps.setLong(20, this.lIdObjectReferenceOwner);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		this.sIdNationalite = preventLoad(rs.getString(1));
		this.iIdAdresse = rs.getInt(2);
		this.iIdPersonnePhysiqueCivilite = rs.getInt(3);
		this.iIdOrganisation = rs.getInt(4);
		this.sNom = preventLoad(rs.getString(5));
		this.sPrenom = preventLoad(rs.getString(6));
		this.sFonction = preventLoad(rs.getString(7));
		this.sTel = preventLoad(rs.getString(8));
		this.sEmail = preventLoad(rs.getString(9));
		this.sFax = preventLoad(rs.getString(10));
		this.sTelPortable = preventLoad(rs.getString(11));
		this.tsDateCreation = rs.getTimestamp(12);
		this.tsDateModification = rs.getTimestamp(13);
		this.sReferenceExterne = preventLoad(rs.getString(14));
		this.sSiteWeb = preventLoad(rs.getString(15));
		this.sPoste = preventLoad(rs.getString(16));
		this.bAlerteMail = rs.getBoolean(17);
		this.sInitials = preventLoad(rs.getString(18));
		this.lIdObjectTypeOwner = rs.getInt(19);
		this.lIdObjectReferenceOwner = rs.getInt(20);
	}
	
	public JSONObject toJSONObject() throws JSONException {
		return toJSONObject(false);
	}

	public JSONObject toJSONObject(
			boolean bAddOrganisation) 
	throws JSONException {
		return toJSONObject(bAddOrganisation, bAddOrganisation, null , null);
	}
	
	public JSONObject toJSONObject(
			boolean bAddOrganisation,
			boolean bAddAdresse,
			Vector<Organisation> vOrganisation,
			Vector<Adresse> vAdresse) 
	throws JSONException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("sIdNationalite", preventStore(this.sIdNationalite));
		item.put("iIdAdresse", this.iIdAdresse);
		item.put("iIdPersonnePhysiqueCivilite", this.iIdPersonnePhysiqueCivilite);
		item.put("iIdOrganisation", this.iIdOrganisation);
		item.put("sNom", preventStore(this.sNom));
		item.put("sPrenom", preventStore(this.sPrenom));
		item.put("sFonction", preventStore(this.sFonction));
		item.put("sTel", preventStore(this.sTel));
		item.put("sEmail", preventStore(this.sEmail));
		item.put("sFax", preventStore(this.sFax));
		item.put("sTelPortable", preventStore(this.sTelPortable));
		item.put("tsDateCreation", this.tsDateCreation); 
		item.put("tsDateModification", this.tsDateModification); 
		item.put("sReferenceExterne", preventStore(this.sReferenceExterne));
		item.put("sSiteWeb", preventStore(this.sSiteWeb));
		item.put("sPoste", preventStore(this.sPoste));
		item.put("bAlerteMail", this.bAlerteMail);
		item.put("sInitials", preventStore(this.sInitials));
		item.put("lIdObjectTypeOwner", this.lIdObjectTypeOwner);
		item.put("lIdObjectReferenceOwner", this.lIdObjectReferenceOwner);
		
		if(bAddOrganisation){
			try{
				Organisation org = null;
				if(vOrganisation != null) {
					org = Organisation.getOrganisation(this.getIdOrganisation(), vOrganisation);
				} else {
					org = Organisation.getOrganisation(this.getIdOrganisation());
				}
				item.put("organisation", org.toJSONObject(bAddAdresse, vAdresse));
			}catch(Exception e){}
		}
		
		
		return item;
	}
	

	
 

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        PersonnePhysique item = getPersonnePhysique(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (PersonnePhysique item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdObjectTypeOwner = item.getLong("lIdObjectTypeOwner");
        } catch(Exception e){}
        try {
            this.iIdOrganisation = item.getInt("lIdOrganisation");
        } catch(Exception e){}
        try {
            this.sIdNationalite = item.getString("sIdNationalite");
        } catch(Exception e){}
        try {
            this.iIdAdresse = item.getInt("lIdAdresse");
        } catch(Exception e){}
        try {
            this.iIdPersonnePhysiqueCivilite = item.getInt("lIdPersonnePhysiqueCivilite");
        } catch(Exception e){}
        try {
            this.sNom = item.getString("sNom");
        } catch(Exception e){}
        try {
            this.sPrenom = item.getString("sPrenom");
        } catch(Exception e){}
        try {
            this.sFonction = item.getString("sFonction");
        } catch(Exception e){}
        try {
            this.sTel = item.getString("sTel");
        } catch(Exception e){}
        try {
            this.sFax = item.getString("sFax");
        } catch(Exception e){}
        try {
            this.sEmail = item.getString("sEmail");
        } catch(Exception e){}
        try {
            this.sTel = item.getString("sTelDomicile");
        } catch(Exception e){}
        try {
            this.sTelPortable = item.getString("sTelPortable");
        } catch(Exception e){}
        try {
            this.tsDateCreation = item.getTimestamp("tsDateCreation");
        } catch(Exception e){}
        try {
            this.tsDateModification = item.getTimestamp("tsDateDerniereModification");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = item.getString("sReferenceExterne");
        } catch(Exception e){}
        try {
            this.sSiteWeb = item.getString("sSiteWeb");
        } catch(Exception e){}
        try {
            this.sPoste = item.getString("sPoste");
        } catch(Exception e){}
        try {
            this.bAlerteMail = item.getBoolean("bAlerteMail");
        } catch(Exception e){}
        try {
            this.sInitials = item.getString("sInitials");
        } catch(Exception e){}
        try {
            this.lIdObjectReferenceOwner = item.getLong("lIdObjectReferenceOwner");
        } catch(Exception e){}
    }

	@RemoteMethod
    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            PersonnePhysique item = null;
            try{
                item = PersonnePhysique.getPersonnePhysique(data.getLong("lId"));
            } catch(Exception e){
                item = new PersonnePhysique();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }
	

	
	public void copy(PersonnePhysique item) {

		this.sIdNationalite = item.sIdNationalite ;
		this.iIdAdresse = item.iIdAdresse;
		this.iIdPersonnePhysiqueCivilite = item.iIdPersonnePhysiqueCivilite;
		this.iIdOrganisation = item.iIdPersonnePhysiqueCivilite;
		this.sNom = item.sNom;
		this.sPrenom = item.sPrenom;
		this.sFonction = item.sFonction;
		this.sTel = item.sTel;
		this.sEmail = item.sEmail;
		this.sFax = item.sFax;
		this.sTelPortable = item.sTelPortable;
		this.tsDateCreation = item.tsDateCreation;
		this.tsDateModification = item.tsDateModification;
		this.sReferenceExterne = item.sReferenceExterne;
		this.sInitials = item.sInitials;
		this.lIdObjectTypeOwner = item.lIdObjectTypeOwner;
		this.lIdObjectReferenceOwner = item.lIdObjectReferenceOwner;
		
		this.bCreateIndividualCheckDuplicate = true;
		
		this.bUseHttpPrevent = item.bUseHttpPrevent;
		this.bUseEmbeddedConnection = item.bUseEmbeddedConnection ;
		this.connEmbeddedConnection = item.connEmbeddedConnection;
	}
	
	
	
	public PersonnePhysique() {
		this.init();
	}
	public PersonnePhysique(int i) {
		init();
		this.lId = i;
	}
	public PersonnePhysique(long lId) {
		init();
		this.lId = lId;
	}
	public PersonnePhysique(
							int iIdPersonnePhysique,
							String sIdNationalite,
							int iIdAdresse,
							int iIdPersonnePhysiqueCivilite,
							int iIdOrganisation,
							String sNom,
							String sPrenom,
							String sFonction,
							String sTel,
							String sEmail,
							String sFax,
							String sTelPortable
							) {
		this(
				sIdNationalite,
				iIdAdresse,
				iIdPersonnePhysiqueCivilite,
				iIdOrganisation,
				sNom,
				sPrenom,
				sFonction,
				sTel,
				sEmail,
				sFax,
				sTelPortable);
		this.iIdAdresse = iIdPersonnePhysique;
	}
	public PersonnePhysique(
							String sIdNationalite,
							int iIdAdresse,
							int iIdPersonnePhysiqueCivilite,
							int iIdOrganisation,
							String sNom,
							String sPrenom,
							String sFonction,
							String sTel,
							String sEmail,
							String sFax,
							String sTelPortable
							) {
		init();
		this.sIdNationalite = sIdNationalite;
		this.iIdAdresse = iIdAdresse;
		this.iIdPersonnePhysiqueCivilite = iIdPersonnePhysiqueCivilite;
		this.iIdOrganisation = iIdOrganisation;
		this.sNom = sNom;
		this.sPrenom = sPrenom;
		this.sFonction = sFonction;
		this.sTel = sTel ;
		this.sEmail = sEmail;
		this.sFax = sFax;
		this.sTelPortable = sTelPortable;
	}

	public String serialize() 
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection();
		
		try {
			return serialize(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public String serialize(Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
		Adresse adr = Adresse.getAdresse( this.iIdAdresse, false, conn);
		
		 String sPersonnePhysique
		 	= "<personnePhysique>\n"
		 		+ "<idPersonnePhysique >" + this.lId + "</idPersonnePhysique >\n" 
		 		+ "<referenceExterne >" + this.sReferenceExterne + "</referenceExterne >\n" 
		 		+ "<idOrganisation >" + this.iIdOrganisation + "</idOrganisation >\n" 
			 	+ "<idPersonnePhysiqueCivilite >" + this.iIdPersonnePhysiqueCivilite + "</idPersonnePhysiqueCivilite >\n" 
			 	+ "<nom >" + this.sNom + "</nom >\n" 
		 		+ "<prenom >" + this.sPrenom + "</prenom >\n" 
		 		+ "<fonction >" + this.sFonction + "</fonction >\n" 
		 		+ "<idNationalite >" + this.sIdNationalite + "</idNationalite >\n" 
		 		+ "<email >" + this.sEmail + "</email>\n" 
		 		+ "<fax>" + this.sFax + "</fax>\n" 
		 		+ "<tel>" + this.sTel + "</tel>\n" 
		 		+ "<telPortable >" + this.sTelPortable + "</telPortable >\n" 
			 	+ adr.serialize()
			 	+ "<dateCreation >" + this.tsDateCreation + "</dateCreation >\n" 
		 		+ "<dateModification >" + this.tsDateModification + "</dateModification >\n"
		 		+ "<initials>" + this.sInitials+ "</initials>\n" 
		 		+ "<idObjectTypeOwner>" + this.lIdObjectTypeOwner + "</idObjectTypeOwner>\n" 
		 		+ "<idObjectReferenceOwner>" + this.lIdObjectReferenceOwner + "</idObjectReferenceOwner>\n" 
		 	+ "</personnePhysique>\n";
		 
		 return sPersonnePhysique;
	
	}
	public void deserialize (Node node){
		try{
			this.sReferenceExterne = BasicDom.getChildNodeValueByNodeName(node, "referenceExterne");
		}
		catch(Exception e){}
		try{
			//if(this.iIdPersonnePhysiqueCivilite == 0) this.iIdPersonnePhysiqueCivilite  = PersonnePhysiqueCivilite.MONSIEUR;
			this.iIdPersonnePhysiqueCivilite = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "idPersonnePhysiqueCivilite"));
			/**
			 * pour éviter les pbs avec les Affiches de Grenoble
			 */
			if(this.iIdPersonnePhysiqueCivilite == 99){
				this.iIdPersonnePhysiqueCivilite = 0;
			}
		}
		catch(Exception e){
			this.iIdPersonnePhysiqueCivilite = 0;
		}
		try{
			this.sNom = (!BasicDom.getChildNodeValueByNodeName(node, "nom").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "nom"):"");
		}
		catch(Exception e){this.sNom = "";}
		try{
			this.sPrenom = (!BasicDom.getChildNodeValueByNodeName(node, "prenom").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "prenom"):"");
		}
		catch(Exception e){this.sPrenom = "";}
		try{
			this.sInitials = (!BasicDom.getChildNodeValueByNodeName(node, "initials").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "initials"):"");
		}
		catch(Exception e){this.sInitials = "";}
		try{
			this.sFonction = (!BasicDom.getChildNodeValueByNodeName(node, "fonction").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "fonction"):"");
		}
		catch(Exception e){}
		try{
			this.sIdNationalite = (!BasicDom.getChildNodeValueByNodeName(node, "idNationalite").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "idNationalite"):"");
		}
		catch(Exception e){this.sIdNationalite = "";}
		
		try{
			String sEmailInXml = BasicDom.getChildNodeValueByNodeName(node, "email").trim();
			if(sEmailInXml != null 
			&& !sEmailInXml.equals("")
			){
				if(Outils.isEmailValide(sEmailInXml))
				{
					this.sEmail = sEmailInXml;
				} 
			}
		}
		catch(Exception e){
			if(this.sEmail == null)
			{
				this.sEmail = "";
			}
		}
		
		try{
			this.sFax = (!BasicDom.getChildNodeValueByNodeName(node, "fax").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "fax"):"");
		}
		catch(Exception e){this.sFax = "";}
		try{
			this.sTel = (!BasicDom.getChildNodeValueByNodeName(node, "tel").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "tel"):"");
		}
		catch(Exception e){this.sTel= "";}
		try{
			this.sTelPortable = (!BasicDom.getChildNodeValueByNodeName(node, "telPortable").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "telPortable"):"");
		}
		catch(Exception e){this.sTelPortable = "";}
		try{
			this.tsDateCreation = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "dateCreation");
		}
		catch(Exception e){}
		try{
			this.tsDateModification = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "dateModification");
		}
		catch(Exception e){}
	}

	public static Vector<PersonnePhysique> getAllPersonnePhysiqueByReferenceExterne(
			String sRefExt,
			Vector<PersonnePhysique> vPPTotal)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<PersonnePhysique> vPPSelected = new Vector<PersonnePhysique> ();
		
		for (PersonnePhysique pp : vPPTotal) {
			if(sRefExt.equals(pp.getReferenceExterne()))
			{
				vPPSelected.add(pp );
			}
		}
		
		return vPPSelected;
	}
	
	public static Vector<PersonnePhysique> getPersonnePhysiquesByReferenceExterne(
			String sRefExt)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Object> vParam = new Vector<Object>();
        vParam.add(sRefExt);

		return getAllWithWhereClause(" WHERE reference_externe LIKE ? ", vParam, false);
	}
	
	public static Vector<PersonnePhysique> getPersonnePhysiquesByReferenceExterne(
			String sRefExt,Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException{
        Vector<Object> vParam = new Vector<Object>();
        vParam.add(sRefExt);

		return getAllWithWhereClause(" WHERE reference_externe LIKE ? ", vParam,conn);
	}
	
	public static PersonnePhysique synchroniser(Node node)
	throws CoinDatabaseDuplicateException, CoinDatabaseLoadException, CoinDatabaseCreateException,
	CoinDatabaseStoreException, InstantiationException, NamingException, SAXException,
	IllegalAccessException, SQLException, CloneNotSupportedException {
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			return synchroniser(node, conn);
		}finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	
	public static PersonnePhysique synchroniser(Node node,Connection conn) 
	throws CoinDatabaseDuplicateException, CoinDatabaseLoadException, CoinDatabaseCreateException,
	CoinDatabaseStoreException, InstantiationException, NamingException, SAXException,
	IllegalAccessException, SQLException, CloneNotSupportedException {
		return synchroniser(node, null, true, false, conn);
	}
	
	@Override
	protected Object clone() throws CloneNotSupportedException {
		PersonnePhysique item = new PersonnePhysique();

		item.lId = this.lId;
		item.sIdNationalite = this.sIdNationalite;
		item.iIdAdresse = this.iIdAdresse;
		item.iIdPersonnePhysiqueCivilite = this.iIdPersonnePhysiqueCivilite;
		item.iIdOrganisation = this.iIdOrganisation;
		item.sNom = this.sNom;
		item.sPrenom = this.sPrenom;
		item.sFonction = this.sFonction;
		item.sTel = this.sTel;
		item.sEmail = this.sEmail;
		item.sFax = this.sFax;
		item.sTelPortable = this.sTelPortable;
		item.tsDateCreation = this.tsDateCreation;
		item.tsDateModification = this.tsDateModification;
		item.sReferenceExterne = this.sReferenceExterne;
		item.sSiteWeb = this.sSiteWeb;
		item.sPoste = this.sPoste;
		item.bAlerteMail = this.bAlerteMail;
		item.sInitials = this.sInitials;
		item.lIdObjectTypeOwner = this.lIdObjectTypeOwner;
		item.lIdObjectReferenceOwner = this.lIdObjectReferenceOwner;

		return item;
	}
	
	
	@Override
	public boolean equals(Object obj) {
		PersonnePhysique item = (PersonnePhysique) obj;
		boolean bEquals = true;

		/**
		 * don't verify ID
		 */
		if(!this.sIdNationalite.equals(item.sIdNationalite)) bEquals = false;
		if(this.iIdAdresse != item.iIdAdresse) bEquals = false;
		if(this.iIdPersonnePhysiqueCivilite != item.iIdPersonnePhysiqueCivilite) bEquals = false;
		if(this.iIdOrganisation != item.iIdOrganisation) bEquals = false;
		if(!this.sNom.equals(item.sNom)) bEquals = false;
		if(!this.sPrenom.equals(item.sPrenom)) bEquals = false;
		if(!this.sFonction.equals(item.sFonction)) bEquals = false;
		if(!this.sTel.equals(item.sTel)) bEquals = false;
		if(!this.sEmail.equals(item.sEmail)) bEquals = false;
		if(!this.sFax.equals(item.sFax)) bEquals = false;
		if(!this.sTelPortable.equals(item.sTelPortable)) bEquals = false;
		if(!this.sInitials.equals(item.sInitials)) bEquals = false;

		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateCreation, item.tsDateCreation);
		}
		
		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateModification, item.tsDateModification);
		}
		
		if(!this.sReferenceExterne.equals(item.sReferenceExterne)) bEquals = false;
		if(!this.sSiteWeb.equals(item.sSiteWeb)) bEquals = false;
		if(!this.sPoste.equals(item.sPoste)) bEquals = false;
		if(this.bAlerteMail != item.bAlerteMail) bEquals = false;

		System.out.println("PP bEquals : " + bEquals);
		
		return bEquals;
	}

	public static void computeEmail(
			PersonnePhysique personne)
	{
		String[] saEmails = personne.getEmail().split(";");
		
		if(saEmails.length > 1)
		{
			boolean bFirstEmail = true;
			for (String email : saEmails) {
				if(bFirstEmail){
					personne.setEmail(email);
					bFirstEmail = false;
				} 
			}
		}
	}

	public static PersonnePhysique synchroniser(
			Node node,
			Vector<PersonnePhysique> vItem, 
			boolean bCreateIndividualCheckDuplicate,
			boolean bCreateParamWebServiceSync,
			Connection conn)
	throws InstantiationException, NamingException, CoinDatabaseDuplicateException, SAXException, 
	IllegalAccessException, SQLException, CoinDatabaseLoadException, CoinDatabaseCreateException,
	CoinDatabaseStoreException, CloneNotSupportedException
	{
		String sReferenceExterne 
	 		= BasicDom.getChildNodeValueByNodeName(node, "referenceExterne");
		PersonnePhysique personne = null; 
		
		/**
		 * control external reference
		 */
		if(sReferenceExterne == null 
		|| sReferenceExterne.trim().equals(""))
		{
			personne = new PersonnePhysique();
			personne.deserialize(node);
			throw new CoinDatabaseLoadException("Erreur dans la liste des personnes "
					+ "pas de ref ext : '" + sReferenceExterne + "'" 
					+ " pour : " + personne.getPrenomNom() + " / " + personne.getEmail(), "");	
		}	
		
		Vector<PersonnePhysique> vPP = null;
		if(vItem == null) vPP = getPersonnePhysiquesByReferenceExterne(sReferenceExterne,conn);
		else vPP = getAllPersonnePhysiqueByReferenceExterne(sReferenceExterne,vItem);
		
		switch(vPP.size())
		{
		case 1:
			personne = vPP.firstElement() ;
			break;
		
		case 0 :
			// ici on a pas trouvé l'objet en base, il faut le créer.
			PersonnePhysique personneNew = new PersonnePhysique();
			personneNew.deserialize(node);
			

			/**
			 * EVOL bug #2250, try to merge person
			 */
			personne = AddressBookMerger.mergePersonnePhysiquePublisher(personneNew, conn);
			if(personne == null){
				/**
				 * Not mergeable , so create it
				 */
				personne = personneNew;
			} else {
				/**
				 * Merge it !
				 */
				System.out.println("sync pp : merge !");
				//  personne.setReferenceExterne(sReferenceExterne) done in deserialize()
				personne.deserialize(node);
				personne.store(conn);
			}
			
			break;
		
		default:
			throw new CoinDatabaseLoadException("Erreur dans la liste des personnes "
					+ "plusieurs références externes pour : '" + sReferenceExterne+"'", "");
		}
		
		/**
		 * if its an update verify if its the same values
		 */
		boolean bEquals = false;
		if(personne.getId() > 0){
			PersonnePhysique persTmp = (PersonnePhysique ) personne.clone();
			persTmp.deserialize(node);
			computeEmail(persTmp);
			bEquals = persTmp.equals(personne);
		}

		/**
		 * deserialize
		 */
		personne.deserialize(node);
		computeEmail(personne);

		/**
		 * control email validity
		 */
		if(!personne.getEmail().equals("") && !Outils.isEmailValide(personne.getEmail())) {
			throw new CoinDatabaseStoreException(
					"PersonnePhysique.synchroniser()  invalid email adress : '" + personne.getEmail()
					+ "' for " + personne.getPrenomNom() 
					+ " " + sReferenceExterne, 
					sReferenceExterne);
		}
		
		if(personne.getId() > 0){
			/**
			 * if objects are equals don't update !
			 */
			if(!bEquals){
				personne.store(conn);
			}
		} else {
			personne.create(conn);
		}
		

		
		
		
		/**
		 * treat multiple email
		 * 
		 * 
		 */
		String[] saEmails = personne.getEmail().split(";");
	

		personne.setCreateIndividualCheckDuplicate(bCreateIndividualCheckDuplicate);
		


		if(saEmails.length > 1)
		{
			/**
			 * update email list for the veille de marchés
			 */
			ArrayList<String> alMailList = new ArrayList<String>();
			
			/**
			 * dont take the first
			 */
			for (int i =1; i < saEmails.length ; i++) {
				String sEmail = saEmails[i];
				alMailList.add(sEmail.trim());
			
				if(!sEmail.equals("") && !Outils.isEmailValide(sEmail)) {
					throw new CoinDatabaseStoreException(
							"PersonnePhysique.synchroniser()  invalid email adress : '" +sEmail
							+ "' for " + personne.getPrenomNom() 
							+ " " + sReferenceExterne, 
							sReferenceExterne);
				}
			}
			
			
			
			VeilleMarcheAbonnes.updateMail(
					personne.getId(), 
					alMailList, 
					true, 
					conn);
		}


		/**
		 * Web Service Sync
		 */
		if(bCreateParamWebServiceSync)
		{
			PersonnePhysiqueWebService.createParamSynchro(personne, conn);
		}

		return personne;
	}

	public void init() {
		super.TABLE_NAME = "personne_physique";
		super.FIELD_ID_NAME = "id_personne_physique";

		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		super.SELECT_FIELDS_NAME 
			= " id_nationalite,"
			+ " id_adresse,"
			+ " id_personne_physique_civilite,"
			+ " id_organisation,"
			+ " nom,"
			+ " prenom,"
			+ " fonction,"
			+ " tel,"
			+ " email,"
			+ " fax,"
			+ " tel_portable,"
			+ " date_creation,"
			+ " date_derniere_modification,"
			+ " reference_externe,"
			+ " site_web,"
			+ " poste,"
			+ " alerte_mail,"
			+ " initials,"
			+ " id_object_type_owner,"
			+ " id_object_reference_owner";
			
		super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length ; 
		super.iAbstractBeanIdObjectType = ObjectType.PERSONNE_PHYSIQUE;
		
		this.lId = 0;
		this.sIdNationalite = "";
		this.iIdAdresse = 0;
		this.iIdPersonnePhysiqueCivilite = 0;
		this.iIdOrganisation= 0;
		this.sNom = "";
		this.sPrenom = "";
		this.sFonction = "";
		this.sTel = "";
		this.sEmail = "";
		this.sFax = "";
		this.sTelPortable = "";
		this.sReferenceExterne = "";
		this.sSiteWeb = "";
		this.sPoste = "";
		this.bAlerteMail = false;
		this.sInitials = "";
		this.lIdObjectTypeOwner = 0;
		this.lIdObjectReferenceOwner = 0;
	}
	
	public void setIdPersonnePhysique(int i) {
		this.lId = i;
	}
	public void setIdNationalite(String s) {
		this.sIdNationalite = s;
	}
	public void setIdAdresse(int i) {
		this.iIdAdresse = i;
	}
	public void setIdPersonnePhysiqueCivilite(int i) {
		this.iIdPersonnePhysiqueCivilite = i;
	}
	public void setIdOrganisation(int i) {
		this.iIdOrganisation = i;
	}
	public void setNom(String s) {
		this.sNom = s;
	}
	public void setPrenom(String s) {
		this.sPrenom = s;
	}
	public void setFonction(String s) {
		this.sFonction = s;
	}
	public void setTel(String s) {
		this.sTel = s;
	}
	public void setEmail(String s) {
		this.sEmail = s;
	}

	public void setFax(String s) {
		this.sFax = s;
	}
	public void setTelPortable(String s) {
		this.sTelPortable = s;
	}
	public void setDateCreation(Timestamp ts) {
		this.tsDateCreation = ts;
	}
	
	public void setDateModification(Timestamp ts) {
		this.tsDateModification = ts;
	}
	
	public void setReferenceExterne(String sReferenceExterne){
		this.sReferenceExterne = sReferenceExterne;
	}
	
	public String getReferenceExterne(){
		return this.sReferenceExterne;
	}

	public void setIdObjectTypeOwner(long lIdObjectTypeOwner) {
		this.lIdObjectTypeOwner = lIdObjectTypeOwner;
	}

	public void setIdObjectReferenceOwner(long lIdObjectReferenceOwner) {
		this.lIdObjectReferenceOwner = lIdObjectReferenceOwner;
	}

	
	
	public void setSiteWeb(String sSiteWeb){
		this.sSiteWeb = sSiteWeb;
	}
	
	public void setPoste(String sPoste){
		this.sPoste = sPoste;
	}
	
	public void setAlerteMail(boolean bAlerte){
		this.bAlerteMail = bAlerte;
	}
	public void setInitials(String sInitials){
		this.sInitials = sInitials;
	}
	public String getInitials(){
		return this.sInitials;
	}
	
	public int getIdPersonnePhysique() {
		return (int)this.lId;
	}
	public String getIdNationalite() {
		return this.sIdNationalite;
	}
	public int getIdAdresse() {
		return this.iIdAdresse;
	}
	public int getIdPersonnePhysiqueCivilite() {
		return this.iIdPersonnePhysiqueCivilite;
	}
	public int getIdOrganisation() {
		return this.iIdOrganisation;
	}
	
	public String getPrenomNom() {
		return (this.sPrenom + " " +  this.sNom).trim() ;
	}
	
	public String getNomPrenom() {
		return (this.sNom + " " +  this.sPrenom).trim() ;
	}
	
	/**
	 * 
	 * @return Generate initials from a first and a last name
	 */
	public String generateInitials(){
		return this.generateInitials(this.getPrenomNom());
	}
	public String generateInitials(String sPrenomNom){
		Pattern p = Pattern.compile("((\\w|[éèàâêûôùäëüÿö])\\w*)", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		String sText = Outils.stripAccents(sPrenomNom.toLowerCase());
		Matcher m = p.matcher(sText);
		StringBuffer sb = new StringBuffer();
		while (m.find()){
			sb.append((sText.substring(m.start(), m.end())).substring(0, 1).toUpperCase());
		}
		return sb.toString();
	}
	
	@RemoteMethod
	public static String generateInitialsJSON(String sJsonData) throws JSONException{
		JSONObject data = new JSONObject(sJsonData);
		PersonnePhysique item = new PersonnePhysique();
		String sPrenomNom = "";
		try{sPrenomNom = data.getString("sPrenomNom");
		}catch (Exception e) {return "";}
		return item.generateInitials(sPrenomNom);
	}
	
	public String getCivilitePrenomNom() 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		try{
			return (getCivilite() + " " + this.sPrenom + " " +  this.sNom).trim() ;
		} catch (CoinDatabaseLoadException e) {
			return  ("(civilité inconnue : id=" + this.iIdPersonnePhysiqueCivilite
					+ ") " + this.sPrenom + " " +  this.sNom ).trim();
		}
	}

	public String getCivilitePrenomNom(Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		try{
			return (getCivilite(conn) + " " + this.sPrenom + " " +  this.sNom).trim() ;
		} catch (CoinDatabaseLoadException e) {
			return  ("(civilité inconnue : id=" + this.iIdPersonnePhysiqueCivilite
					+ ") " + this.sPrenom + " " +  this.sNom).trim() ;
		}
	}


	public String getCivilitePrenomNomOptional() {
		try {
			return (getCivilite() + " " + this.sPrenom + " " +  this.sNom).trim() ;
		}catch (Exception e) {
			return (this.sPrenom + " " +  this.sNom).trim() ;
		}
	}

	public String getCivilitePrenomNomFonction() 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		try{
			return (getCivilite() + " " + this.sPrenom + " " +  this.sNom  + " " +this.sFonction).trim();
		} catch (CoinDatabaseLoadException e) {
			return  ("(civilité inconnue : id=" + this.iIdPersonnePhysiqueCivilite
					+ ") " + this.sPrenom + " " +  this.sNom  + " " +this.sFonction).trim();
		}	
	}

	public String getCivilitePrenomNomFonctionOptional() 
	{
		try{
			return (getCivilite() + " " + this.sPrenom + " " +  this.sNom  + " " +this.sFonction).trim();
		} catch (Exception e) {
			return (this.sPrenom 
					+ " " +  this.sNom
					+ " " +this.sFonction).trim();
		}	
	}

	
	
	public String getNom() {
		return this.sNom;
	}
	public String getPrenom() {
		return this.sPrenom;
	}
	public String getFonction() {
		return this.sFonction;
	}
	public String getFonction(String sDefaultValue) {
		if(Outils.isNullOrBlank(this.sFonction)){
			return sDefaultValue;
		}
		return this.sFonction;
	}
	public String getTel() {
		return this.sTel;
	}
	public String getEmail() {
		return this.sEmail;
	}
	public String getFax() {
		return this.sFax;
	}
	public String getTelPortable() {
		return this.sTelPortable;
	}
	public Timestamp getDateCreation() {
		return this.tsDateCreation;
	}
	public Timestamp getDateModification() {
		return this.tsDateModification;
	}
	
	public String getSiteWeb() {
		return this.sSiteWeb;
	}
	
	public String getPoste() {
		return this.sPoste;
	}
	
	public Boolean getAlerteMail() {
		return this.bAlerteMail;
	}

	public long getIdObjectTypeOwner(){
		return this.lIdObjectTypeOwner;
	}

	public long getIdObjectReferenceOwner(){
		return this.lIdObjectReferenceOwner;
	}

	public boolean isOwnerIndividual(
			long lIdIndividual)
	{
		return this.lIdObjectTypeOwner == ObjectType.PERSONNE_PHYSIQUE
		&& this.lIdObjectReferenceOwner == lIdIndividual;
	}
	
	public static PersonnePhysique getPersonnePhysique(long lId) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		return getPersonnePhysique(lId,true);
    }

	public static PersonnePhysique getPersonnePhysique(
			long lId,
			Vector<PersonnePhysique> vPersonnePhysique) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		return (PersonnePhysique)getCoinDatabaseAbstractBeanFromId(lId, vPersonnePhysique);
	}
	
	/**
	 * Search in the vector if the person exists 
	 * - if ok return the personn
	 * - if not, get it from database and add it into the vector 
	 * 
	 * @param lId
	 * @param vPersonnePhysique
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws SQLException
	 * @throws NamingException
	 */
	public static PersonnePhysique getOrLoadPersonnePhysique(
			long lId,
			Vector<PersonnePhysique> vPersonnePhysique) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		try{
			return getPersonnePhysique(lId, vPersonnePhysique);
		} catch (CoinDatabaseLoadException e) {
			PersonnePhysique personne =  getPersonnePhysique(lId);
			vPersonnePhysique.add(personne);
			return personne;
		}
    }
	
	public static PersonnePhysique getPersonnePhysique(long lId, boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, SQLException, NamingException{
		PersonnePhysique personne = new PersonnePhysique(lId);
		personne.bUseHttpPrevent = bUseHttpPrevent;
		personne.load();
    	return personne;
    }
	
	public static PersonnePhysique getPersonnePhysique(
			long lIdPersonnePhysique, 
			boolean bUseHttpPrevent,
			Connection conn) throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		PersonnePhysique personne = new PersonnePhysique(lIdPersonnePhysique);
		personne.bUseHttpPrevent = bUseHttpPrevent;
		personne.load(conn);
    	return personne;
    }
	
	/**
	 * Méthode renvoyant la personne physique identifiée par son email que l'on 
	 * considère unique
	 * @param sEmail - adresse email de la personne
	 * @return un objet PersonnePhysique valide ou null si erreur
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws CoinDatabaseDuplicateException 
	 * @throws Exception 
	 */
	public static PersonnePhysique getPersonnePhysiqueFromEmail(String sEmail)
	throws NamingException, SQLException, CoinDatabaseLoadException,
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException
	{
		PersonnePhysique item = new PersonnePhysique();
		item.bUseHttpPrevent = false ; 
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sEmail);

		return (PersonnePhysique) item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE email=?", "", vParams, true);

	}

	public static PersonnePhysique getPersonnePhysiqueFromReferenceExterne(
			String sReferenceExterne,
			boolean bUseHttpPrevent,
			Connection conn)
	throws NamingException, SQLException, CoinDatabaseLoadException,
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException
	{
		PersonnePhysique item = new PersonnePhysique();
		item.bUseHttpPrevent = bUseHttpPrevent ; 
		item.bUseEmbeddedConnection = true; 
		item.connEmbeddedConnection = conn; 
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sReferenceExterne);

		return (PersonnePhysique) item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE reference_externe=? ", "", vParams, true);

	}

	
	public static PersonnePhysique getPersonnePhysiqueFromNomPrenom(
			String sNom, 
			String sPrenom)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException
	{
		PersonnePhysique item = new PersonnePhysique();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sNom);
		vParams.add(sPrenom);

		return (PersonnePhysique) item.getAbstractBeanWithWhereAndOrderByClause(
				 " WHERE nom=? and prenom=?", "", vParams, true);
	}
   
	public static Vector<PersonnePhysique> getPersonnePhysiqueFromNom(String sNom) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		PersonnePhysique item = new PersonnePhysique();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sNom);

		return item.getAllWithWhereAndOrderByClause(
				" WHERE nom=? ORDER BY prenom", "", vParams);
		
	}
	
	public String getCivilite() 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {	
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			try{
				return getCivilite( conn);
			} catch (Exception e) {
				return "unkown civility = " + this.iIdPersonnePhysiqueCivilite;
			}
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
   
	public String getCivilite(Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		PersonnePhysiqueCivilite civ = PersonnePhysiqueCivilite
			.getPersonnePhysiqueCiviliteMemory(this.iIdPersonnePhysiqueCivilite, false, conn);
		
		civ.bPropagateEmbeddedConnection = this.bPropagateEmbeddedConnection;
		civ.setAbstractBeanLocalization(this);
		
		return civ.getName();
	}
	
	/**
	 * Méthode testant si le paramètre existe déjà chez une personne physique
	 * @param sEmail - email de la personne à priori unique à chacune
	 * @return true si doublon (existe déjà), false si n'existe pas
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public boolean isDoublonPersonnePhysique(
			String sEmail,
			Connection conn)
	throws NamingException, SQLException {
		String sSqlQuery = "SELECT "+this.FIELD_ID_NAME+" FROM " + this.TABLE_NAME 
						+" WHERE email=?";
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sEmail);
		
		try {
			long lId = ConnectionManager.getLongValueFromSqlQuery(sSqlQuery, vParams, conn);
			if (lId != this.lId)
				return true;
			return false;
		} catch (CoinDatabaseLoadException e) {
			return false;
		}
	}
	
	/**
	 * Ajoute un enregistrement PersonnePhysique dans la base
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseDuplicateException 
	 */
	public void create() throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		
		Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			create( conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	public void create(Connection conn) throws CoinDatabaseCreateException, NamingException, SQLException,
	CoinDatabaseDuplicateException, CoinDatabaseLoadException 
	{
		setDateCreation(new Timestamp(System.currentTimeMillis()));
		setDateModification(new Timestamp(System.currentTimeMillis()));
		boolean bAuthorizeCreate = true;
		if(this.bCreateIndividualCheckDuplicate)
		{
			if(this.sEmail != null && !this.sEmail.equalsIgnoreCase(""))
			{
				bAuthorizeCreate = !isDoublonPersonnePhysique(this.sEmail, conn);
			}
		}
		
		if (bAuthorizeCreate) 
		{
			super.create(conn);
		}
	    else 
	    {
	    	throw new CoinDatabaseDuplicateException("email",getEmail(),"");
	    }
	}
	
	public static PersonnePhysique createPersonnePhysiqueCasual(
			String sName,
			Organisation orgCasual,
			long lIdObjectReferenceOwner,
			Connection conn)
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException, NamingException, SQLException
	{
		Adresse adrCasual = new Adresse ();
		adrCasual.create(conn);
		PersonnePhysique personneCasual = new PersonnePhysique();
		personneCasual.setNom(sName);
		personneCasual.setIdPersonnePhysiqueCivilite(PersonnePhysiqueCivilite.EMPTY);
		personneCasual.setIdAdresse((int)adrCasual.getId());
		personneCasual.setIdOrganisation((int)orgCasual.getId());
		personneCasual.setIdObjectTypeOwner(ObjectType.PERSONNE_PHYSIQUE);
		personneCasual.setIdObjectReferenceOwner(lIdObjectReferenceOwner);
		personneCasual.create(conn);
		
		return personneCasual;
	}

	public static Vector<PersonnePhysique> getAllFromIdOrganisationAndNameLike(
			int iIdOrganisation, 
			String sName,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisation));
		vParams.add("%"+sName+"%");
		
		return getAllFromIdOrganisation(iIdOrganisation, " AND nom LIKE ?", vParams, bUseHttpPrevent);
	}
	
	public static Vector<PersonnePhysique> getAllFromIdOrganisation(
			int iIdOrganisation, 
			String sClause,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisation));
		return getAllFromIdOrganisation(iIdOrganisation, sClause, vParams, bUseHttpPrevent);
	}
	
	public static Vector<PersonnePhysique> getAllFromIdOrganisation(
			int iIdOrganisation, 
			String sClause,
			Vector<Object> vParams,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		
		String sWhereClause = " WHERE id_organisation=?"+sClause;
		return getAllWithWhereClause(sWhereClause, vParams, bUseHttpPrevent);
	}

	public static Vector<PersonnePhysique> getAllFromIdOrganisation(
			int iIdOrganisation) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdOrganisation(iIdOrganisation, true);
	}
	
	public static Vector<PersonnePhysique> getAllFromIdOrganisation(
			int iIdOrganisation, 
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Connection conn = ConnectionManager.getConnection();
		
		try {
			return getAllFromIdOrganisation(iIdOrganisation, bUseHttpPrevent, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static Vector<PersonnePhysique> getAllFromEmailOrNameOrOrganizationName(
			String sValue,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>();
		vParams.add("%" + sValue + "%");
		vParams.add("%" + sValue + "%");
		vParams.add("%" + sValue + "%");

		
		PersonnePhysique item = new PersonnePhysique();	
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		String sSqlQuery
		= item.getAllSelect("pp.") 
		    + ", organisation orga"
		    + " WHERE pp.id_organisation = orga.id_organisation "
		    + " AND (pp.nom LIKE ?" 
				+ " OR pp.email LIKE ?"
				+ " OR orga.raison_sociale LIKE ?)";
		
		return item.getAllWithSqlQuery(sSqlQuery, vParams);
	}	
	
	public static Vector<PersonnePhysique> getAllFromEmailOrName(
			String sValue,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>();
		vParams.add("%" + sValue + "%");
		vParams.add("%" + sValue + "%");

		
		PersonnePhysique item = new PersonnePhysique();	
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(
				" WHERE nom LIKE ?" 
				+ " OR email LIKE ?", "", vParams);
	}	
	
	public static Vector<PersonnePhysique> getAllFromIdOrganisation(
			int iIdOrganisation, 
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisation));
		String sWhereClause = " WHERE id_organisation=?";
		PersonnePhysique item = new PersonnePhysique();
		item.bUseHttpPrevent = bUseHttpPrevent;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		
		return item.getAllWithWhereAndOrderByClause(
					sWhereClause, 
					"",
					vParams);
	}

	public static Vector<PersonnePhysique> getAllStatic() 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereClause("");
	}

	public static Vector<PersonnePhysique> getAllStatic(Connection conn)
	throws InstantiationException, IllegalAccessException, SQLException {
		PersonnePhysique item =  new PersonnePhysique();
		return item.getAll(conn);
	}

	/**
	 * Méthode permettant de récupérer les personnes physiques appartenant à des 
	 * organisations dont le type est spécifié
	 * @param iIdOrganisationType - type de l'organisation
	 * @param sClause - clause de tri généralement " ORDER BY <champ> "
	 * 					et/ou clause de limite " LIMIT x,x " 
	 * @return un vecteur d'objet castables en PersonnePhysique
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<PersonnePhysique> getAllWithOrganisationType(
			int iIdOrganisationType, 
			String sClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisationType));
		 
		String sSqlQuery = getSqlQueryAllFromOrganisationType(sClause);

		return item.getAllWithSqlQuery(sSqlQuery, vParams);
	}
	
	public static Vector<PersonnePhysique> getAllWithOrganisationType(
			int iIdOrganisationType, 
			String sClause,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisationType));
		
		return getAllWithOrganisationType(iIdOrganisationType, sClause, vParams, bUseHttpPrevent);
	}
	
	/**
	 * need to add vParams.add(new Integer(iIdOrganisationType)); at the first place in the vector
	 * 
	 * @param iIdOrganisationType
	 * @param sClause
	 * @param vParams
	 * @param bUseHttpPrevent
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public static Vector<PersonnePhysique> getAllWithOrganisationType(
			int iIdOrganisationType, 
			String sClause,
			Vector<Object> vParams ,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();
		 
		String sSqlQuery = getSqlQueryAllFromOrganisationType(sClause);
		item.bUseHttpPrevent=bUseHttpPrevent;
		return item.getAllWithSqlQuery(sSqlQuery, vParams);
	}
	
	
	public static Vector<PersonnePhysique> getAllWithOrganisationTypeAndNameLike(
			int iIdOrganisationType, 
			String sName,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisationType));
		vParams.add("%" + sName + "%");
		
		return PersonnePhysique.getAllWithOrganisationType(
				iIdOrganisationType,
					" AND pers.nom LIKE ?",
					vParams,
					bUseHttpPrevent);
	}
	
	public static Vector<PersonnePhysique> getAllWithOrganisationTypeAndNameLikeFull(
			int iIdOrganisationType, 
			String sName,
			String sAddWhereClause,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisationType));
		vParams.add("%" + sName + "%");
		vParams.add("%" + sName + "%");
		
		return PersonnePhysique.getAllWithOrganisationType(
				iIdOrganisationType,
					" AND ( pers.nom LIKE ? OR org.raison_sociale LIKE ?) "
					+ sAddWhereClause,
					vParams,
					bUseHttpPrevent);
	}
	
	public static Vector<PersonnePhysique> getAllWithOrganisationType(
			int iIdOrganisationType, 
			String sClause,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrganisationType));
		 
		String sSqlQuery = getSqlQueryAllFromOrganisationType(sClause);
		item.bUseHttpPrevent=bUseHttpPrevent;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		return item.getAllWithSqlQuery(sSqlQuery, vParams);
	}
	
	public static String getSqlQueryAllFromOrganisationType(String sClause) 
	{
		PersonnePhysique item = new PersonnePhysique();

		return item.getAllSelect("pers.")
		+ ", organisation org " 
		+ " WHERE pers.id_organisation = org.id_organisation " 
		+ " AND org.id_organisation_type=? "
		+ sClause;
	}
	
	
	public static Vector<PersonnePhysique> getAllWithWhereClause(String sWhereClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();		
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "");
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			boolean bUseHttpPrevent) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();		
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}


	public void removeWithObjectAttached()
	throws SQLException, NamingException 
	{
		Connection conn = getConnection();
		try{
			removeWithObjectAttached(conn) ;
		} finally {
			releaseConnection(conn);
		}
	}
	
	public void removeWithObjectAttached(Connection conn)
	throws SQLException, NamingException 
	{
		
		try{User.getUserFromIdIndividual((int)this.lId, false, conn).remove(conn);}
		catch(Exception e){}
		
		try{Adresse.getAdresse(this.iIdAdresse, false, conn).remove(conn);}
		catch(Exception e){}
		
		try{Organisation.removeCreator(this.lId, conn);}
		catch(Exception e){}
		
		try{
			PersonnePhysiqueParametre ppParam = new PersonnePhysiqueParametre();
			ppParam.remove("WHERE id_personne_physique=" + this.lId, conn);
		} catch(Exception e){}
		
		OrganisationGroupPersonnePhysique.removeAllFromPersonnePhysique(this.lId, conn);
		
		try {
			Vector<Multimedia> vMultimedia = Multimedia.getAllMultimedia(
					(int)this.lId, 
					ObjectType.PERSONNE_PHYSIQUE, 
					false, 
					conn);
			
			for(Multimedia m : vMultimedia)
			{
				m.remove(conn);
			}
		} catch(Exception e){}
		
		
		
		this.remove(conn);
	}
	
	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.iIdPersonnePhysiqueCivilite = HttpUtil.parseInt(sFormPrefix + "iIdCivilite", request, this.iIdPersonnePhysiqueCivilite) ;
		this.sNom = HttpUtil.parseString(sFormPrefix + "sNom", request, this.sNom) ;
		this.sPrenom = HttpUtil.parseString(sFormPrefix + "sPrenom", request, this.sPrenom) ;
		this.sFonction = HttpUtil.parseString(sFormPrefix + "sFonction", request, this.sFonction) ;
		this.sIdNationalite = HttpUtil.parseString(sFormPrefix + "iIdNationalite", request, this.sIdNationalite) ;
		this.sTel = HttpUtil.parseString(sFormPrefix + "sTel", request, this.sTel) ;
		this.sFax = HttpUtil.parseString(sFormPrefix + "sFax", request, this.sFax) ;
		this.sTelPortable = HttpUtil.parseString(sFormPrefix + "sTelPortable", request, this.sTelPortable) ;
		this.sSiteWeb = HttpUtil.parseString(sFormPrefix + "sSiteWeb", request, this.sSiteWeb) ;
		this.sPoste = HttpUtil.parseString(sFormPrefix + "sPoste", request, this.sPoste) ;
		this.sReferenceExterne = HttpUtil.parseString(sFormPrefix + "sReferenceExterne", request, this.sReferenceExterne) ;
		this.sEmail = HttpUtil.parseString(sFormPrefix + "sEmail", request, this.sEmail) ;
		this.sInitials = HttpUtil.parseString(sFormPrefix + "sInitials", request, this.sInitials) ;
		this.lIdObjectTypeOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectTypeOwner", request, this.lIdObjectTypeOwner) ;
		this.lIdObjectReferenceOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectReferenceOwner", request, this.lIdObjectReferenceOwner) ;
		
		int iAlertMail = -1; 
		if(request.getParameter(sFormPrefix+"alertMail") != null)
			iAlertMail = Integer.parseInt(request.getParameter(sFormPrefix+"alertMail"));
		if(iAlertMail == 1) this.bAlerteMail = true;
	}
	
	public void setFromFormWithoutEmail(HttpServletRequest request, String sFormPrefix)
	{
		this.iIdPersonnePhysiqueCivilite = HttpUtil.parseInt(sFormPrefix + "iIdCivilite", request, this.iIdPersonnePhysiqueCivilite) ;
		this.sNom = HttpUtil.parseString(sFormPrefix + "sNom", request, this.sNom) ;
		this.sPrenom = HttpUtil.parseString(sFormPrefix + "sPrenom", request, this.sPrenom) ;
		this.sFonction = HttpUtil.parseString(sFormPrefix + "sFonction", request, this.sFonction) ;
		this.sIdNationalite = HttpUtil.parseString(sFormPrefix + "iIdNationalite", request, this.sIdNationalite) ;
		this.sTel = HttpUtil.parseString(sFormPrefix + "sTel", request, this.sTel) ;
		this.sFax = HttpUtil.parseString(sFormPrefix + "sFax", request, this.sFax) ;
		this.sTelPortable = HttpUtil.parseString(sFormPrefix + "sTelPortable", request, this.sTelPortable) ;
		this.sSiteWeb = HttpUtil.parseString(sFormPrefix + "sSiteWeb", request, this.sSiteWeb) ;
		this.sPoste = HttpUtil.parseString(sFormPrefix + "sPoste", request, this.sPoste) ;
		this.sReferenceExterne = HttpUtil.parseString(sFormPrefix + "sReferenceExterne", request, this.sReferenceExterne) ;
		this.sInitials = HttpUtil.parseString(sFormPrefix + "sInitials", request, this.sInitials) ;
		this.lIdObjectTypeOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectTypeOwner", request, this.lIdObjectTypeOwner) ;
		this.lIdObjectReferenceOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectReferenceOwner", request, this.lIdObjectReferenceOwner) ;
	}

	public static boolean isPersonnesPhysiquesWithEmail(String Email) 
	throws SQLException, NamingException, CoinDatabaseLoadException{
		long nbRows = 0;
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(PreventSqlInjection.cleanEmail(Email));
		String sSqlQuery = "SELECT COUNT(*) FROM personne_physique " 
					+ " PERS WHERE PERS.email LIKE ?";

		
		nbRows = ConnectionManager.getLongValueFromSqlQuery(sSqlQuery, vParams);
	
		return (nbRows>0);
	}

	@Override
	public String getName() {
		
		switch (iGetNameType) {
		case GET_NAME_TYPE_FIRST_NAME_LAST_NAME:
			return getPrenomNom();

		case GET_NAME_TYPE_LAST_NAME_FIRST_NAME:
			return getNomPrenom();

		case GET_NAME_TYPE_TITLE_FIRST_NAME_LAST_NAME:
			return getCivilitePrenomNomOptional();

		case GET_NAME_TYPE_FIRST_NAME_LAST_NAME_EMAIL:
			return (getPrenomNom() + " " + this.sEmail ).trim(); 

		case GET_NAME_TYPE_TITLE_FIRST_NAME_LAST_NAME_FUNCTION:
			return getCivilitePrenomNomFonctionOptional(); 

			
		default:
			break;
		}
		return getCivilitePrenomNomOptional();
	}

	public static Vector<PersonnePhysique> getAllWithSqlQueryStatic(String sSQLQuery) 
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		PersonnePhysique item = new PersonnePhysique(); 
	return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	/**
	 * Cette fonction a été mise en place pour permettre de générer 
	 * un tableau en HTML contenant toutes les données de 
	 * cette table nécessaire pour la newsletter.
	 * 
	 */
	public static String getAllForExportHTML() throws Exception{
		String sRetour = "";
		Vector<PersonnePhysique> vPP = null;
		try {
			vPP = getAllStatic();
		} catch (Exception e) {
			e.printStackTrace();
		}

		String[] LibEntete = {"IdPP", "Nom", "Prénom", "Organisation", "VOIE : N°+type+Nom",
				"Boite postale + Code Postal", "Ville + Cedex", "Pays", 
				"Tél. Personne Physique", "Tél. Organisation", 
				"Portable", 
				"Fax Personne physique", "Fax Organisation",
				"Type de l'organisation", "Email PP", "Validité Email PP",
				"Email organisation", "Validité Email Organisation"};

		sRetour += "<table border='1' cellspacing='0' bordercolor='#CCCCCC'>" +
				"<tr>";
		int i = 0;
		for (i=0;i<LibEntete.length;i++){
			sRetour += "<td><b>"+LibEntete[i]+"</b></td>";
		}
		sRetour += "</tr>";
		Adresse ad = new Adresse();
		Organisation org = new Organisation();
		int iNbResultats = vPP.size();
		System.out.println("Nombre de résultats : "+iNbResultats);
		int iIdOrganisation = -1;
		for (i=0;i<iNbResultats;i++){
			try{
				System.out.println("Ligne "+(i+1)+"/"+iNbResultats+" idPP : "+vPP.get(i).getIdPersonnePhysique());
				sRetour += "<tr>";
				sRetour += "<td>"+vPP.get(i).getIdPersonnePhysique()+"</td>";
				sRetour += "<td>"+vPP.get(i).getNom()+"</td>";
				sRetour += "<td>"+vPP.get(i).getPrenom()+"</td>";
				iIdOrganisation = -1;
				try{
					iIdOrganisation = vPP.get(i).getIdOrganisation();
				}catch(Exception e){e.printStackTrace();}
				if (iIdOrganisation>0){
					org = Organisation.getOrganisation(iIdOrganisation);
					
				}else{
					org = null;
				}
				sRetour += "<td>"+((org!=null)?org.getRaisonSociale():"")+"</td>";
				
				if(vPP.get(i).getIdAdresse()==0){
					sRetour += "<td>Erreur l'adresse n'a pas pu être trouvée</td>";
					sRetour += "<td>Erreur</td>";
					sRetour += "<td>Erreur</td>";
					sRetour += "<td>Erreur</td>";
				}else{
					ad = Adresse.getAdresse(vPP.get(i).getIdAdresse());
					sRetour += "<td>"+ad.getVoieNumero()+" "+ad.getVoieType()+" "+ad.getVoieNom()+"</td>";
					sRetour += "<td>"+ad.getBoitePostale()+" "+ad.getCodePostal()+"</td>";
					sRetour += "<td>"+ad.getCommune()+" "+ad.getCedex()+"</td>";
					sRetour += "<td>"+Pays.getPaysName(ad.getIdPays())+"</td>";
				}
				
				sRetour += "<td>"+vPP.get(i).getTel()+"</td>";
				sRetour += "<td>"+((org!=null)?org.getTelephone():"")+"</td>";
				sRetour += "<td>"+vPP.get(i).getTelPortable()+"</td>";
				sRetour += "<td>"+vPP.get(i).getFax()+"</td>";
				sRetour += "<td>"+((org!=null)?org.getFax():"")+"</td>";
				
				sRetour += "<td>"+((org!=null)?OrganisationType.getOrganisationTypeName(org.getIdOrganisationType()):"")+"</td>";
				sRetour += "<td>"+vPP.get(i).getEmail()+"</td>";
				if (vPP.get(i).getEmail()!=null && vPP.get(i).getEmail().length()>0){
					sRetour += "<td>"+( (Mail.isGoodDNS(vPP.get(i).getEmail())?"valide":"<b>DNS inconnu/Mail invalide</b>") )+"</td>";
				}else{
					sRetour += "<td>&nbsp;</td>";
				}
				
				sRetour += "<td>"+((org!=null)?org.getMailOrganisation():"")+"</td>";
				if (org!=null && vPP.get(i).getEmail()!=null && vPP.get(i).getEmail().length()>0){
					sRetour += "<td>"+( (Mail.isGoodDNS(org.getMailOrganisation())?"valide":"<b>DNS inconnu/Mail invalide</b>") )+"</td>";
				}else{
					sRetour += "<td>&nbsp;</td>";
				}
				sRetour += "</tr>";
			}catch (NamingException ne) {
	            System.err.println("getAllForExportHTML : [idPP = "+vPP.get(i).getIdPersonnePhysique()+"] " + ne.getMessage()+" ");
	        }
		}
		sRetour += "</table>";
	
		return sRetour;
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereAndOrderByClauseStatic(
			String sWhereClause, 
			String sOrderByClause) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		PersonnePhysique item = new PersonnePhysique(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		PersonnePhysique item = new PersonnePhysique(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereAndOrderByClauseStatic(CoinDatabaseWhereClause cw, String sOrderByClause) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Connection conn = ConnectionManager.getConnection();
		try {
			return getAllWithWhereAndOrderByClauseStatic(cw, sOrderByClause, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static Vector<PersonnePhysique> getAllWithWhereAndOrderByClauseStatic(CoinDatabaseWhereClause cw, String sOrderByClause,Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		PersonnePhysique item = new PersonnePhysique(); 
		String sWhereClause = " WHERE " + cw.generateWhereClause(item.FIELD_ID_NAME) ;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}
	
	
	public String getEmailLabel() {
		return getLocalizedLabel("sEmail");
	}
	
	public String getIdPersonnePhysiqueCiviliteLabel() {
		return getLocalizedLabel("iIdPersonnePhysiqueCivilite");
	}
	public String getNomLabel() {
		return getLocalizedLabel("sNom");
	}
	public String getPrenomLabel() {
		return getLocalizedLabel("sPrenom");
	}
	public String getFonctionLabel() {
		return getLocalizedLabel("sFonction");
	}
	public String getIdNationaliteLabel() {
		return getLocalizedLabel("sIdNationalite");
	}
	public String getIdAdresseLabel() {
		return getLocalizedLabel("iIdAdresse");
	}
	public String getTelLabel() {
		return getLocalizedLabel("sTel");
	}
	public String getPosteLabel() {
		return getLocalizedLabel("sPoste");
	}
	public String getFaxLabel() {
		return getLocalizedLabel("sFax");
	}
	public String getTelPortableLabel() {
		return getLocalizedLabel("sTelPortable");
	}
	public String getSiteWebLabel() {
		return getLocalizedLabel("sSiteWeb");
	}
	public String getIdOrganisationLabel() {
		return getLocalizedLabel("iIdOrganisation");
	}
	public String getInitialsLabel() {
		return getLocalizedLabel("sInitials");
	}
	public String getReferenceExterneLabel() {
		return getLocalizedLabel("sReferenceExterne");
	}
	public String getLocalizedLabel(String sFieldName) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);
	}
	
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
		
    
	public static Vector<PersonnePhysique> getAllByOwner(
			long lIdObjectTypeOwner,
			long lIdObjectReferenceOwner,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysique item = new PersonnePhysique();
		return Organisation.getAllByOwner(item, lIdObjectTypeOwner, lIdObjectReferenceOwner, conn);
	}
	
	public Vector <String> getAdditionalEMailAddresses ()
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return PersonnePhysiqueParametre.getPersonnePhysiqueParametreValues(lId, PersonnePhysiqueParametre.PARAM_ADDITIONAL_EMAIL_ADDRESS);
	}
	
	public void setAdditionalEMailAddresses (Vector <String> vAddresses)
	throws CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException,
	SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		PersonnePhysiqueParametre.updateValues(
				lId,
				PersonnePhysiqueParametre.PARAM_ADDITIONAL_EMAIL_ADDRESS,
				new ArrayList <String> (vAddresses));
	}
}
