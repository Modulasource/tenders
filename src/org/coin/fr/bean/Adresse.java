/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;

import java.io.*;

import org.coin.bean.ObjectType;
import org.coin.db.*;
import org.coin.util.BasicDom;
import org.coin.util.HttpUtil;
import org.coin.util.Outils;
import org.json.JSONException;
import org.json.JSONObject;

import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.ParamPart;
import com.oreilly.servlet.multipart.Part;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Map;
import java.util.Vector;
import java.util.regex.*;
import org.w3c.dom.Node;


public class Adresse extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;
	
	protected String sVoieNumero;
	protected String sVoieType;
	protected String sVoieNom;
	protected String sAdresseLigne1;
	protected String sAdresseLigne2;
	protected String sAdresseLigne3;
	protected String sCodePostal;
	protected String sCommune;
	protected String sIdPays;
	protected String sBoitePostale;
	protected String sCedex;
	protected double dLongitude;
	protected double dLatitude;
	
    protected static Map<String,String>[] s_sarrLocalizationLabel;

	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setString(++i, preventStore(this.sAdresseLigne1));
		ps.setString(++i, preventStore(this.sAdresseLigne2));
		ps.setString(++i, preventStore(this.sAdresseLigne3));
		ps.setString(++i, preventStore(this.sCodePostal));
		ps.setString(++i, preventStore(this.sCommune));
		ps.setString(++i, preventStore(this.sIdPays));
		ps.setString(++i, preventStore(this.sVoieNumero));
		ps.setString(++i, preventStore(this.sVoieType));
		ps.setString(++i, preventStore(this.sVoieNom));
		ps.setString(++i, preventStore(this.sBoitePostale));
		ps.setString(++i, preventStore(this.sCedex));
		ps.setDouble(++i, this.dLongitude);
		ps.setDouble(++i, this.dLatitude);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.sAdresseLigne1 = preventLoad(rs.getString(++i));
		this.sAdresseLigne2 = preventLoad(rs.getString(++i));
		this.sAdresseLigne3 = preventLoad(rs.getString(++i));
		this.sCodePostal = preventLoad(rs.getString(++i));
		this.sCommune = preventLoad(rs.getString(++i));
		this.sIdPays = preventLoad(rs.getString(++i));
		this.sVoieNumero = preventLoad(rs.getString(++i));
		this.sVoieType = preventLoad(rs.getString(++i));
		this.sVoieNom = preventLoad(rs.getString(++i));
		this.sBoitePostale = preventLoad(rs.getString(++i));
		this.sCedex = preventLoad(rs.getString(++i));
		this.dLongitude = rs.getDouble(++i);
		this.dLatitude = rs.getDouble(++i);
	}
	
	
	public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("sAdresseLigne1", this.sAdresseLigne1 );
		item.put("sAdresseLigne2", this.sAdresseLigne2 ); 
		item.put("sAdresseLigne3", this.sAdresseLigne3 );
		item.put("sCodePostal", this.sCodePostal );
		item.put("sCommune", this.sCommune );
		item.put("sIdPays", this.sIdPays );
		item.put("sVoieNumero", this.sVoieNumero );
		item.put("sVoieType", this.sVoieType );
		item.put("sVoieNom", this.sVoieNom );
		item.put("sBoitePostale", this.sBoitePostale );
		item.put("sCedex", this.sCedex );
		item.put("dLongitude", this.dLongitude );
		item.put("dLatitude", this.dLatitude );
		
		Connection conn = this.getConnection();
		try{
			Pays pays = Pays.getPaysMemory(this.getIdPays(),false,conn);
			pays.setAbstractBeanLocalization(this);
			item.put("pays",pays.toJSONObject());
		}catch(CoinDatabaseLoadException e){}
		item.put("sAllAdresseString", getAllAdresseString("\n",false,conn));
		
		this.releaseConnection(conn);
		
		return item;
	}
	

	
	/*
	public void populateVariables(){
		this.variables = new ArrayList<HashMap<String,String>>();
		HashMap<String,String> map = null;
		map = new HashMap<String,String>();map.put("variable","sAdresseLigne1");map.put("getter","getAdresseLigne1");map.put("sql","adresse_ligne_1");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sAdresseLigne2");map.put("getter","getAdresseLigne2");map.put("sql","adresse_ligne_2");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sAdresseLigne3");map.put("getter","getAdresseLigne3");map.put("sql","adresse_ligne_3");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sCodePostal");map.put("getter","getCodePostal");map.put("sql","code_postal");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sCommune");map.put("getter","getCommune");map.put("sql","commune");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sIdPays");map.put("getter","getIdPays");map.put("sql","id_pays");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sVoieNumero");map.put("getter","getVoieNumero");map.put("sql","voie_numero");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sVoieType");map.put("getter","getVoieType");map.put("sql","voie_type");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sVoieNom");map.put("getter","getVoieNom");map.put("sql","voie_nom");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sBoitePostale");map.put("getter","getBoitePostale");map.put("sql","boite_postale");this.variables.add(map);
		map = new HashMap<String,String>();map.put("variable","sCedex");map.put("getter","getCedex");map.put("sql","cedex");this.variables.add(map);
	}
	*/
	
	/**
	 * Constructeur classique de la classe Adresse
	 *
	 */
	public Adresse() {
		init();
	}

	
	
	public String getAdresseString(String sLineDelimiter)
	{
		 String sAdr = "";
		 String sItem = this.sAdresseLigne1;
		 if(!Outils.isNullOrBlank(sItem) )
		 {
			 sAdr += sItem + sLineDelimiter;
		 }
		 
		 sItem = this.getAdresseLigne2();
		 if(!Outils.isNullOrBlank(sItem))
		 {
			 sAdr += sItem + sLineDelimiter;
		 }

		 sItem = this.sVoieNumero + " " + this.sVoieType + " " + this.sVoieNom;
		 if(!sItem.equals("  "))
		 {
			 sAdr += sItem + sLineDelimiter;
		 }
		 
		 sItem = this.sAdresseLigne3;
		 if(!Outils.isNullOrBlank(sItem))
		 {
			 sAdr += sItem + sLineDelimiter;
		 }
		 
		 sItem = this.sBoitePostale;
		 if(!Outils.isNullOrBlank(sItem))
		 {
			 sAdr += "BP " + sItem + sLineDelimiter;
		 }


		return sAdr;
	
	}

	public String serialize()
	{
		 String sAdr 
		 	= "<adresse>\n"
		 	+ "<complementDeRemise>" +  this.sAdresseLigne1 + "</complementDeRemise>\n" 
		 	+ "<complementDeDistribution>" +  this.sAdresseLigne2 + "</complementDeDistribution>\n" 
		 	+ "<voie>\n"
		 		+ "<voieNumero>" +  this.sVoieNumero + "</voieNumero>\n" 
		 		+ "<voieType>" +  this.sVoieType + "</voieType>\n" 
		 		+ "<voieNom>" +  this.sVoieNom+ "</voieNom>\n" 
			+ "</voie>\n"
		 	+ "<lieuDit>" +  this.sAdresseLigne3 + "</lieuDit>\n" 
		 	+ "<codePostal>" +  this.sCodePostal + "</codePostal>\n" 
		 	+ "<commune>" +  this.sCommune + "</commune>\n" 
		 	+ "<cedex>" +  this.sCedex + "</cedex>\n" 
		 	+ "<pays>" +  this.sIdPays + "</pays>\n" 
		 	+ "<longitude>" +  this.dLongitude + "</longitude>\n" 
		 	+ "<latitude>" +  this.dLatitude + "</latitude>\n" 
			+ "</adresse>\n";
		 
		 return sAdr;
	
	}
	
	public void deserialize (Node node){
		try{
			this.sAdresseLigne1 = (!BasicDom.getChildNodeValueByNodeName(node, "complementDeRemise").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "complementDeRemise"):"");
		}
		catch(Exception e){this.sAdresseLigne1 = "";}
		try{
			this.sAdresseLigne2 = (!BasicDom.getChildNodeValueByNodeName(node, "complementDeDistribution").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "complementDeDistribution"):"");
		}
		catch(Exception e){this.sAdresseLigne2 = "";}
		try{
			this.sAdresseLigne3 = (!BasicDom.getChildNodeValueByNodeName(node, "lieuDit").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "lieuDit"):"");
		}
		catch(Exception e){this.sAdresseLigne3 = "";}
		try{
			this.sCodePostal = (!BasicDom.getChildNodeValueByNodeName(node, "codePostal").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "codePostal"):"");
		}
		catch(Exception e){this.sCodePostal = "";}

		try{
			Node nVoieNode = BasicDom.getChildNodeByNodeName(node,"voie");
	
			try{
				this.sVoieNumero = (!BasicDom.getChildNodeValueByNodeName(nVoieNode,"voieNumero").equalsIgnoreCase("")
						?BasicDom.getChildNodeValueByNodeName(nVoieNode, "voieNumero"):"");
			}
			catch(Exception e){this.sVoieNumero = "";}
			try{
				this.sVoieType = (!BasicDom.getChildNodeValueByNodeName(nVoieNode,"voieType").equalsIgnoreCase("")
						?BasicDom.getChildNodeValueByNodeName(nVoieNode, "voieType"):"");
			}
			catch(Exception e){}
			try{
				this.sVoieNom = (!BasicDom.getChildNodeValueByNodeName(nVoieNode,"voieNom").equalsIgnoreCase("")
						?BasicDom.getChildNodeValueByNodeName(nVoieNode, "voieNom"):"");
			}
			catch(Exception e){this.sVoieNom = "";}
		} catch (Exception e) {}
		
		try{
			this.sCommune = (!BasicDom.getChildNodeValueByNodeName(node, "commune").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "commune"):"");
		}
		catch(Exception e){this.sCommune = "";}

		try{
			this.dLatitude = Double.parseDouble(BasicDom.getChildNodeValueByNodeName(node, "latitude"));
		} catch(Exception e){}

		try{
			this.dLongitude = Double.parseDouble(BasicDom.getChildNodeValueByNodeName(node, "longitude"));
		} catch(Exception e){}

	}

	public static Adresse synchroniser(Node node,  int iIdAdresse) throws Exception{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			return synchroniser(node,iIdAdresse, conn);
		}finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	
	public static Adresse synchroniser(Node node, int iIdAdresse,Connection conn) throws Exception{
		return synchroniser(node, iIdAdresse, null, conn);
	}
	
	public static Adresse synchroniser(
			Node node, 
			int iIdAdresse,
			Vector<Adresse> vAdresse,
			Connection conn) 
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException, 
	SQLException, NamingException
	{
		Adresse adresse = null;
		try {
			if(vAdresse!=null && !vAdresse.isEmpty()){
				try{adresse = (Adresse)
					CoinDatabaseAbstractBean.getCoinDatabaseAbstractBeanFromId(
							iIdAdresse, 
							vAdresse);
				} catch(CoinDatabaseLoadException le) {
					adresse = Adresse.getAdresse(iIdAdresse,true,conn);
				}
			}else{
				adresse = Adresse.getAdresse(iIdAdresse,true,conn);
			}
			
			/**
			 * if objects are equals don't update !
			 */
			Adresse adresseTemp = (Adresse) adresse.clone();
			adresseTemp.deserialize(node);
			if(!adresseTemp.equals(adresse) )
			{
				adresse.deserialize(node);
				adresse.store(conn);
			}
		} catch (Exception e) {
			adresse = new Adresse();
			adresse.deserialize(node);
			adresse.create(conn);
		}
		return adresse;
		
	}
	

	@Override
	protected Object clone() throws CloneNotSupportedException {
		Adresse item = new Adresse();

		item.lId = this.lId;
		item.sVoieNumero = this.sVoieNumero;
		item.sVoieType = this.sVoieType;
		item.sVoieNom = this.sVoieNom;
		item.sAdresseLigne1 = this.sAdresseLigne1;
		item.sAdresseLigne2 = this.sAdresseLigne2;
		item.sAdresseLigne3 = this.sAdresseLigne3;
		item.sCodePostal = this.sCodePostal;
		item.sCommune = this.sCommune;
		item.sIdPays = this.sIdPays;
		item.sBoitePostale = this.sBoitePostale;
		item.sCedex = this.sCedex;
		item.dLongitude = this.dLongitude;
		item.dLatitude = this.dLatitude;

		return item;
	}
	
	@Override
	public boolean equals(Object obj) {
		Adresse item = (Adresse) obj;
		boolean bEquals = true;

		if(!this.sVoieNumero.equals(item.sVoieNumero)) bEquals = false;
		if(!this.sVoieType.equals(item.sVoieType)) bEquals = false;
		if(!this.sVoieNom.equals(item.sVoieNom)) bEquals = false;
		if(!this.sAdresseLigne1.equals(item.sAdresseLigne1)) bEquals = false;
		if(!this.sAdresseLigne2.equals(item.sAdresseLigne2)) bEquals = false;
		if(!this.sAdresseLigne3.equals(item.sAdresseLigne3)) bEquals = false;
		if(!this.sCodePostal.equals(item.sCodePostal)) bEquals = false;
		if(!this.sCommune.equals(item.sCommune)) bEquals = false;
		if(!this.sIdPays.equals(item.sIdPays)) bEquals = false;
		if(!this.sBoitePostale.equals(item.sBoitePostale)) bEquals = false;
		if(!this.sCedex.equals(item.sCedex)) bEquals = false;
		if(this.dLongitude != item.dLongitude) bEquals = false;
		if(this.dLatitude != item.dLatitude) bEquals = false;
		return bEquals;
	}
	
	
	public String getAllAdresseString(
			String sLineDelimiter) 
	throws NamingException, SQLException	
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return getAllAdresseString(sLineDelimiter, true, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}	
	
	/**
	 * 
	 * @param sLineDelimiter
	 * @return
	 */
	public String getAllAdresseString(
			String sLineDelimiter,
			boolean bUseHttpPrevent,
			Connection conn) 
	{
		String sAdr ="";
		
		sAdr = getAdresseString(sLineDelimiter );
		String sCedex = "";
		if (!Outils.isNullOrBlank(this.sCedex))
			sCedex = " CEDEX "+ this.sCedex;
		
		sAdr += this.sCodePostal + " " + this.sCommune 
			+ sCedex
			+ sLineDelimiter;
	
		try {
			Pays pays = Pays.getPaysMemory(this.sIdPays, false, conn);
			pays.bUseHttpPrevent= bUseHttpPrevent;
			pays.bUseEmbeddedConnection = true;
			pays.connEmbeddedConnection = conn;
			pays.bPropagateEmbeddedConnection = true;

			pays.setAbstractBeanLocalization(this);
			sAdr += pays.getName() + sLineDelimiter; 
		}catch (Exception e) {
			e.printStackTrace();
		}

		return sAdr ;
	}

	
	public String getLignesAdresseConcat(){
		return this.sAdresseLigne1+this.sAdresseLigne2+this.sAdresseLigne3;
	}
	
	/**
	 * Constructeur de la classe Adresse
	 * @param id - identifiant de l'enregistrement correspondant dans la base
	 * @throws Exception 
	 */
	public Adresse(int iIdAdresse) {
		init();
		this.lId = iIdAdresse;
	}
	
	/**
	 * Initilisation de tous les champs de l'objet Adresse
	 * avec des paramètres par défaut
	 */
	public void init() {
	
		this.TABLE_NAME = "adresse";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME 
			= " adresse_ligne_1,"
				+ " adresse_ligne_2,"
				+ " adresse_ligne_3,"
				+ " code_postal,"
				+ " commune,"
				+ " id_pays,"
				+ " voie_numero,"
				+ " voie_type,"
				+ " voie_nom,"
				+ " boite_postale,"
				+ " cedex,"
				+ " longitude,"
				+ " latitude";
 
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		this.iAbstractBeanIdObjectType = ObjectType.ADRESSE;
		this.sAdresseLigne1 = "";
		this.sAdresseLigne2 = "";
		this.sAdresseLigne3 = "";
		this.sCodePostal = "";
		this.sCommune = "";
		this.sIdPays = "FRA";
		
		this.sBoitePostale = "";
		this.sCedex = "";
		this.sVoieNom = "";
		this.sVoieType = "";
		this.sVoieNumero = "";
		this.dLongitude = 0;
		this.dLatitude = 0;
		
	}
	
	public void parse(String sAdresse){
		String[] sarrSplitedAdresse;
		init();
		// NB : pour les codes postaux, on n'oublie pas le cas Corse 2A et 2B !
		Pattern pAdresse = Pattern.compile("^([0-9]*.*?)((20A|20B|2A|2B|[0-9]{2})[0-9]{3})(.*?)(CEDEX.*?$)?$",
						Pattern.CASE_INSENSITIVE);
		Matcher mAdresse = pAdresse.matcher(sAdresse.trim());
		
		if (mAdresse.find() && mAdresse.groupCount()>0){
			String sRue = mAdresse.group(1).trim();
			this.setCodePostal(mAdresse.group(2).trim());
			this.setCommune(mAdresse.group(4).trim());
			if (mAdresse.group(5) != null) this.setCedex(mAdresse.group(5).trim());
			
			// Capture éventuelle de la boite postale : B.P. xxx ou BP xxx ou B P. xxx etc.
			Pattern pBoitePostale = Pattern.compile("(.*?)(B[.| ]*P[.| ]*([0-9]*))(.*?)", 
													Pattern.CASE_INSENSITIVE);
			Matcher mBoitePostal = pBoitePostale.matcher(sRue);
			if (mBoitePostal.find()){
				// on uniformise l'affichage B.P. (et non BP ou B.P ou b.p. etc.)
				this.setBoitePostale("B.P. "+mBoitePostal.group(3).trim());
				// on affecte la ligne de la rue mais sans la partie BP
				sRue = mBoitePostal.group(1).trim();
			}
			// L'adresse est découpée en plusieurs lignes en fonction du nombre de \n trouvé
			sarrSplitedAdresse = sRue.split("\n");
		}else{
			//throw new AddresseException("Erreur : le parser ne pavient pas à déterminer cette adresse");
			// Pour l'instant on conserve l'ancien traitement proposé dans cette méthode (car manque d'infos)
			// le cas suivant arrive lorsque le code postal n'est pas trouvé
			sarrSplitedAdresse = sAdresse.split("\n");
		}
		if (sarrSplitedAdresse.length > 1 ) this.setAdresseLigne1(sarrSplitedAdresse[0].trim());
		if (sarrSplitedAdresse.length > 2 ) this.setAdresseLigne2(sarrSplitedAdresse[1].trim());
		if (sarrSplitedAdresse.length > 3 ){
			// on concatène toutes les lignes restantes
			int i = 2;
			String s = "";
			while(i<sarrSplitedAdresse.length){
				s += sarrSplitedAdresse[i++].trim()+" ";
			}
			this.setAdresseLigne3(s.trim());
		}
	}

	public void parseOld(String sAdresse)
	{
		int iZipCodeSize = 5;
		if(sAdresse.trim().endsWith("SUISSE")) {
			iZipCodeSize = 4;
		} else if(sAdresse.trim().endsWith("PAYS BAS")) {
			iZipCodeSize = 6;
		}
		parseOld(sAdresse, iZipCodeSize);
	} 

	/* replace multiple whitespaces between words with single blank */
    public static String itrim(String source) {
        return source.replaceAll("\\b\\s{2,}\\b", " ");
    }

	
	public void parseOld(
			String sAdresse,
			int iZipCodeSize)
	{
		/**
		 * clean double space
		 */
		
		String[] sarrSplitedAdresse = sAdresse.split("\n");
		String[] sarrSplitedLine;
		int i;
		int iCodePostalIndex = -1;
		init();

		
		if(sAdresse.trim().endsWith("SUISSE")) {
			this.sIdPays = "SUI";
		} else if(sAdresse.trim().endsWith("PAYS BAS")) {
			this.sIdPays = "NED";
		}

		
		// recherche de la ligne contenant le code postal et à la Boite postale
		for (i = 0; i < sarrSplitedAdresse.length; i++)
		{
			String sTemp;
			sarrSplitedLine = itrim(sarrSplitedAdresse[i]).trim().split("\\s");
			sTemp = sarrSplitedLine [0];
			if(sTemp.length() == iZipCodeSize)
			{
				try {
					if(iZipCodeSize <= 5) {
						Integer.parseInt(sTemp);
					}
					iCodePostalIndex = i;
					this.sCodePostal = sarrSplitedLine [0].trim();
					this.sCommune = sarrSplitedLine [1].trim();
					break;
				} catch (Exception e) {
					// on continue à chercher ..
				}
				
			}
			if (sTemp.equalsIgnoreCase("B.P."))
			{
				this.sBoitePostale = sarrSplitedAdresse[i].trim();
			}
			
		}
		
		if( iCodePostalIndex == -1 )
		{
			if (sarrSplitedAdresse.length > 1 )
				this.sAdresseLigne1 = sarrSplitedAdresse[0].trim();

			if (sarrSplitedAdresse.length > 2 )
				this.sAdresseLigne2 = sarrSplitedAdresse[1].trim();
			
			if (sarrSplitedAdresse.length > 3 )
				this.sAdresseLigne3 = sarrSplitedAdresse[2].trim();
		}
		else
		{
			if ( (sarrSplitedAdresse.length) > 1 && (iCodePostalIndex >= 1) )
				this.sAdresseLigne1 = sarrSplitedAdresse[0].trim();

			if ( (sarrSplitedAdresse.length > 2) && (iCodePostalIndex >= 2))
				this.sAdresseLigne2 = sarrSplitedAdresse[1].trim();
			
			if ( (sarrSplitedAdresse.length > 3) && (iCodePostalIndex >= 3))
				this.sAdresseLigne3 = sarrSplitedAdresse[2].trim();
			
		}
		
	}
	
	
	public void setIdAdresse(int id) { this.lId = id; }
	public void setAdresseLigne1(String s) { this.sAdresseLigne1 = s; }
	public void setAdresseLigne2(String s) { this.sAdresseLigne2 = s; }
	public void setAdresseLigne3(String s) { this.sAdresseLigne3 = s; }
	public void setCodePostal(String s) { this.sCodePostal = s; }
	public void setCommune(String s) { this.sCommune = s; }
	public void setIdPays(String s) { this.sIdPays = s; }
	public void setBoitePostale(String boitePostale) { this.sBoitePostale = boitePostale; }
	public void setCedex(String cedex) { this.sCedex = cedex; }
	public void setVoieNom(String voieNom) { this.sVoieNom = voieNom; }
	public void setVoieNumero(String voieNumero) { this.sVoieNumero = voieNumero; }
	public void setVoieType(String voieType) { this.sVoieType = voieType; }
	public void setLongitude(double dLongitude ) { this.dLongitude = dLongitude ; }
	public void setLatitude(double dLatitude ) { this.dLatitude = dLatitude ; }

	public int getIdAdresse() { return (int)this.lId; }
	public String getBoitePostale() { return this.sBoitePostale; }
	public String getCedex() { return this.sCedex; }
	public String getVoieNumero() { return this.sVoieNumero; }
	public String getVoieType() { return this.sVoieType; }
	public String getVoieNom() { return this.sVoieNom; }
	public String getAdresseLigne1() { return this.sAdresseLigne1; }
	public String getAdresseLigne2() { return this.sAdresseLigne2; }
	public String getAdresseLigne3() { return this.sAdresseLigne3; }
	public String getCodePostal() { return this.sCodePostal; }
	public String getCommune() { return this.sCommune; }
	public double getLongitude() { return this.dLongitude; }
	public double getLatitude() { return this.dLatitude; }
	
	public String getCommune(String sDefaultValue) {
		if(Outils.isNullOrBlank(this.sCommune)){
			return sDefaultValue;
		}
		return this.sCommune;
	}

	public String getIdPays() {
		try{
			return this.sIdPays;
		}catch(Exception e){return "FRA";}
	}
	
    public static Adresse getAdresse(int iIdAdresse) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	return getAdresse(iIdAdresse, true);
    }
    
    public static Adresse getAdresse(int iIdAdresse, boolean bUseHttpPrevent) 
    throws CoinDatabaseLoadException, SQLException, NamingException
    {
    	Adresse adresse = new Adresse (iIdAdresse);
    	adresse.bUseHttpPrevent = bUseHttpPrevent;
    	adresse.load();
    	return adresse;
    }

    public static Adresse getAdresse(
			int iId, 
			Vector<Adresse> vAdresse) 
	throws CoinDatabaseLoadException, SQLException, NamingException  {
	    
		return (Adresse)CoinDatabaseAbstractBean.getCoinDatabaseAbstractBeanFromId(iId, vAdresse);
	}

    
    public static Adresse getAdresse(
    		int iIdAdresse, 
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, NamingException, SQLException 
    {
    	Adresse adresse = new Adresse (iIdAdresse);
    	adresse.bUseHttpPrevent = bUseHttpPrevent;
    	adresse.bUseFieldValueFilter = bUseHttpPrevent;
    	adresse.load(conn);
    	return adresse;
    }

	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.sVoieNumero = HttpUtil.parseString(sFormPrefix + "sVoieNumero", request,this.sVoieNumero);
		this.sVoieType = HttpUtil.parseString(sFormPrefix + "sVoieType", request,this.sVoieType);
		this.sVoieNom = HttpUtil.parseString(sFormPrefix + "sVoieNom", request,this.sVoieNom);

		this.sAdresseLigne1 = HttpUtil.parseString(sFormPrefix + "sAdresseLigne1", request,this.sAdresseLigne1);
		this.sAdresseLigne2 = HttpUtil.parseString(sFormPrefix + "sAdresseLigne2", request,this.sAdresseLigne2);
		this.sAdresseLigne3 = HttpUtil.parseString(sFormPrefix + "sAdresseLigne3", request,this.sAdresseLigne3);
		this.sCodePostal = HttpUtil.parseString(sFormPrefix + "sCodePostal", request,this.sCodePostal);
		this.sCommune = HttpUtil.parseString(sFormPrefix + "sCommune", request,this.sCommune);
		this.sIdPays = HttpUtil.parseString(sFormPrefix + "sIdPays", request,this.sIdPays);

		this.sBoitePostale = HttpUtil.parseString(sFormPrefix + "sBoitePostale", request,this.sBoitePostale);
		this.sCedex = HttpUtil.parseString(sFormPrefix + "sCedex", request,this.sCedex);

		this.dLongitude = HttpUtil.parseDouble(sFormPrefix + "dLongitude", request,this.dLongitude );
		this.dLatitude = HttpUtil.parseDouble(sFormPrefix + "dLatitude", request,this.dLatitude );
	}
	
	public void setFromFormMultiPart(HttpServletRequest request, String sFormPrefix)
	{
		
		MultipartParser mp = null;
		Part part = null;
		try{
			mp = new MultipartParser(request, Integer.MAX_VALUE);
		}
		catch(IOException e){
			e.printStackTrace();
		}
		try {
			part = mp.readNextPart();
		}
		catch(IOException e){
			e.printStackTrace();
		}
		while (part != null)
		{
	
			if (part.isParam())
			{
				ParamPart param = (ParamPart)part;

				if (param.getName().equals(sFormPrefix + "sVoieNumero")){
					try{
						this.sVoieNumero = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sVoieType"))
				{
					try{
						this.sVoieType = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sVoieNom"))
				{
					try{
						this.sVoieNom = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sAdresseLigne1"))
				{
					try{
						this.sAdresseLigne1 = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sAdresseLigne2"))
				{
					try{
						this.sAdresseLigne2 = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sAdresseLigne3"))
				{
					try{
						this.sAdresseLigne3 = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sCodePostal"))
				{
					try{
						this.sCodePostal = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sCommune"))
				{
					try{
						this.sCommune = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sIdPays"))
				{
					try{
						this.sIdPays = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sBoitePostale"))
				{
					try{
						this.sBoitePostale = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
				if (param.getName().equals(sFormPrefix + "sCedex"))
				{
					try{
						this.sCedex = param.getStringValue();
					}
					catch(UnsupportedEncodingException e){
						e.printStackTrace();
					}
				}
			}

			try {
				part = mp.readNextPart();
			}
			catch(IOException e){
				
			}
		}
	}
	
	/**
	 * Méthode qui teste si l'object courant est valide cad si tous les champs sont != null ou !=""
	 * @return true/false
	 */
	public boolean isValideAdresse(){
		boolean bIsValide = false;
		if (!this.sVoieNumero.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sVoieType.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sAdresseLigne1.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sAdresseLigne2.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sAdresseLigne3.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sCodePostal.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sCommune.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sBoitePostale.equalsIgnoreCase("")) bIsValide = true;
		if (!this.sCedex.equalsIgnoreCase("")) bIsValide = true;
		
		return bIsValide;
	}

	public static Vector<Adresse> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Adresse item = new Adresse (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<Adresse> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Adresse item = new Adresse (); 
		return item.getAll();
	}

	public static Vector<Adresse> getAllStatic(Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Adresse item = new Adresse (); 
		return item.getAll(conn);
	}

	@Override
	public String getName() {
		
		try {
			return getAllAdresseString("\n");
		} catch (Exception e) {
		}
		return "";
	}
	
	public String getAdresseLigne1Label() {
		return getLocalizedLabel("sAdresseLigne1");
	}
	public String getAdresseLigne2Label() {
		return getLocalizedLabel("sAdresseLigne2");
	}
	public String getAdresseLigne3Label() {
		return getLocalizedLabel("sAdresseLigne3");
	}
	public String getVoieLabel() {
		return getLocalizedLabel("sVoie");
	}
	public String getVoieNumeroLabelShort() {
		return getLocalizedLabel("sVoieNumero");
	}
	public String getVoieTypeLabelShort() {
		return getLocalizedLabel("sVoieType");
	}
	public String getVoieNomLabelShort() {
		return getLocalizedLabel("sVoieNom");
	}
	public String getCodePostalLabel() {
		return getLocalizedLabel("sCodePostal");
	}
	public String getCommuneLabel() {
		return getLocalizedLabel("sCommune");
	}
	public String getIdPaysLabel() {
		return getLocalizedLabel("sIdPays");
	}
	public String getBoitePostaleLabel() {
		return getLocalizedLabel("sBoitePostale");
	}
	
	public String getCedexLabel() {
		return getLocalizedLabel("sCedex");
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
    
    public static Vector<Adresse> getAllWithWhereAndOrderByClauseStatic(
    		String sWhereClause, String sOrderByClause) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
    {
    	Adresse item = new Adresse(); 
    	return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);	
    }
    
	public static Vector<Adresse> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Adresse item = new Adresse();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		return getAllWithWhereClause(sWhereClause, vParams, item);
	}

	public static Vector<Adresse> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Adresse item = new Adresse();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		return getAllWithWhereClause(sWhereClause, vParams, item);
	}
	
	public static Vector<Adresse> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Adresse item) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}

}
