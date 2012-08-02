/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import modula.commission.Commission;
import modula.marche.TypeAcheteurPublic;
import mt.common.addressbook.AddressBookMerger;

import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.bean.boamp.BoampCPFItem;
import org.coin.bean.conf.TreeviewNode;
import org.coin.bean.organigram.Organigram;
import org.coin.bean.organigram.OrganigramNode;
import org.coin.bean.ws.OrganisationWebService;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
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

import com.oreilly.servlet.multipart.FilePart;
import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.ParamPart;
import com.oreilly.servlet.multipart.Part;

@RemoteProxy 
public class Organisation extends CoinDatabaseAbstractBean {

	private static final long serialVersionUID = 3257003267761452848L;
	protected int iIdOrganisationType;
	protected int iIdAdresse;
	protected int iIdCodeNaf;
	protected int iIdCreateur;
	protected int iIdTypeAcheteurPublic;
	protected int iIdCategorieJuridique;
	protected int iIdOrganisationModelePDF;
	protected int iIdOrganisationClasseProfit;
	
	protected String sRaisonSociale;
	protected String sSiret;
	protected String sMailOrganisation;
	protected String sTelephone;
	protected String sFax;
	protected String sSiteWeb;
	protected String sCommentaire;
	protected String sTvaIntra;
	protected Timestamp tsDateCreation;
	protected Timestamp tsDateModification;
	protected String sLogo;
	protected InputStream isLogo;
	protected String sReferenceExterne;
	protected String sReferenceExterneAP;
	
	protected long lIdObjectTypeOwner;
	protected long lIdObjectReferenceOwner;

	protected boolean bCreateOrganizationCheckDuplicate = true;
	
	public final static int ORGANIGRAM_NODE_ORDER_ALPHABETIC = 0;
	public final static int ORGANIGRAM_NODE_ORDER_HIERARCHIC = 1;

	public boolean isCreateOrganizationCheckDuplicate() {
		return this.bCreateOrganizationCheckDuplicate ;
	}

	public void setCreateOrganizationCheckDuplicate(
			boolean bCreateOrganizationCheckDuplicate) {
		this.bCreateOrganizationCheckDuplicate = bCreateOrganizationCheckDuplicate;
	}
	
    protected static Map<String,String>[] s_sarrLocalizationLabel;

	static final String SQL_QUERY_COUNT_FROM_CLAUSE = "SELECT COUNT(*) FROM organisation "  ;

	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		ps.setInt(1, this.iIdOrganisationType);
		ps.setInt(2, this.iIdAdresse);
		ps.setString(3, preventStore(this.sRaisonSociale));
		ps.setString(4, preventStore(this.sSiret));
		ps.setString(5, preventStore(this.sMailOrganisation));
		ps.setString(6, preventStore(this.sTelephone));
		ps.setString(7, preventStore(this.sFax));
		ps.setString(8, preventStore(this.sSiteWeb));
		ps.setString(9, preventStore(this.sCommentaire));
		ps.setInt(10, this.iIdCodeNaf);
		ps.setString(11, preventStore(this.sTvaIntra));
		ps.setInt(12, this.iIdCategorieJuridique);
		ps.setTimestamp(13, this.tsDateCreation); 
		ps.setTimestamp(14, this.tsDateModification); 
		ps.setString(15, preventStore(this.sLogo ));
		ps.setString(16, preventStore(this.sReferenceExterne ));
		ps.setInt(17, this.iIdTypeAcheteurPublic); 
		ps.setInt(18, this.iIdCreateur);
		ps.setInt(19, this.iIdOrganisationModelePDF);
		ps.setString(20, preventStore(this.sReferenceExterneAP));
		ps.setLong(21, this.lIdObjectTypeOwner);
		ps.setLong(22, this.lIdObjectReferenceOwner);
		ps.setInt(23, this.iIdOrganisationClasseProfit);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 	{
		this.iIdOrganisationType = rs.getInt(1);
		this.iIdAdresse = rs.getInt(2);
		this.sRaisonSociale = preventLoad(rs.getString(3));
		this.sSiret = preventLoad(rs.getString(4));
		this.sMailOrganisation = preventLoad(rs.getString(5));
		this.sTelephone = preventLoad(rs.getString(6));
		this.sFax = preventLoad(rs.getString(7));
		this.sSiteWeb = preventLoad(rs.getString(8));
		this.sCommentaire = preventLoad(rs.getString(9));
		this.iIdCodeNaf = rs.getInt(10);
		this.sTvaIntra = preventLoad(rs.getString(11));
		this.iIdCategorieJuridique = rs.getInt(12);
		this.tsDateCreation = rs.getTimestamp(13);
		this.tsDateModification = rs.getTimestamp(14);
		this.sLogo = preventLoad(rs.getString(15));
		this.sReferenceExterne = preventLoad(rs.getString(16));
		this.iIdTypeAcheteurPublic = rs.getInt(17);
		this.iIdCreateur = rs.getInt(18);
		this.iIdOrganisationModelePDF = rs.getInt(19);
		this.sReferenceExterneAP = preventLoad(rs.getString(20));
		this.lIdObjectTypeOwner = rs.getInt(21);
		this.lIdObjectReferenceOwner = rs.getInt(22);
		this.iIdOrganisationClasseProfit = rs.getInt(23);
	}
	
	/**
	 * Constructeur vide de la classe Organisation (par défaut)
	 */
	public Organisation() {
		init();
	}
	
	/**
	 * Constructeur vide de la classe Organisation (par défaut)
	 */
	public Organisation(boolean bUseHttpPrevent) {
		init();
		this.bUseHttpPrevent = bUseHttpPrevent;
	}
	
	/**
	 * Constructeur de la classe Organisation
	 * @param iIdOrganisationType
	 * @param iIdAdresse
	 * @param iIdCodeNaf
	 * @param iIdCategorieJuridique
	 * @param sRaisonSociale
	 * @param sSiret
	 * @param sMailOrganisation
	 * @param sTelephone
	 * @param sFax
	 * @param sSiteWeb
	 * @param sCommentaire
	 * @param sTvaIntra
	 */
	public Organisation(
					int iIdOrganisationType, 
					int iIdAdresse,
					int iIdCodeNaf,
					int iIdCategorieJuridique,
					String sRaisonSociale,
					String sSiret,
					String sMailOrganisation,
					String sTelephone,
					String sFax,
					String sSiteWeb,
					String sCommentaire,
					String sTvaIntra
					) {
		init();
		this.iIdOrganisationType = iIdOrganisationType;
		this.iIdAdresse = iIdAdresse;
		this.iIdCodeNaf = iIdCodeNaf;
		this.iIdCategorieJuridique = iIdCategorieJuridique;
		this.sRaisonSociale = sRaisonSociale;
		this.sSiret = sSiret;
		this.sMailOrganisation = sMailOrganisation;
		this.sTelephone = sTelephone;
		this.sFax = sFax;
		this.sSiteWeb = sSiteWeb;
		this.sCommentaire = sCommentaire;
		this.sTvaIntra = sTvaIntra;
		this.iIdOrganisationModelePDF = OrganisationModelePDF.TYPE_DEFAUT;
	}
	/**
	 * Constructeur de la classe Organisation
	 * @param i - identifiant de l'enregistrement correspondant
	 */
	public Organisation(long id) {
		init();
		this.lId = id;
	}
	/**
	 * Constructeur de la classe Organisation
	 * @param iIdOrganisation
	 * @param iIdOrganisationType
	 * @param iIdAdresse
	 * @param sRaisonSociale
	 * @param sSiret
	 * @param sMailOrganisation
	 * @param sTelephone
	 * @param sFax
	 * @param sSiteWeb
	 * @param sCommentaire
	 */
	public Organisation( int iIdOrganisation,
					int iIdOrganisationType, 
					int iIdAdresse,
					int iIdCodeNaf,
					int iIdCategorieJuridique,
					String sRaisonSociale,
					String sSiret,
					String sMailOrganisation,
					String sTelephone,
					String sFax,
					String sSiteWeb,
					String sCommentaire,
					String sTvaIntra
					) {
		this(
			iIdOrganisationType, 
			iIdAdresse,
			iIdCodeNaf,
			iIdCategorieJuridique,
			sRaisonSociale,
			sSiret,
			sMailOrganisation,
			sTelephone,
			sFax,
			sSiteWeb,
			sCommentaire,
			sTvaIntra
			);
		this.lId = iIdOrganisation;
	}
	
	public boolean isOrganisationPublicationPublissimo() 
	throws NamingException, SQLException 
	{
		boolean b = false;
		Connection conn = ConnectionManager.getConnection();
		try {
			b = isOrganisationPublicationPublissimo(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		return b;
	}
	
	public boolean isOrganisationPublicationPublissimo(
			Connection conn) 
	{
		boolean bIsPublicationPublissimo = false;
		try{
			String sIsPublicationPublissimo = 
				OrganisationParametre
					.getOrganisationParametreValue(
							getIdOrganisation(), 
							"isPublicationPublissimo",
							conn);
			if(sIsPublicationPublissimo.equalsIgnoreCase("true")) bIsPublicationPublissimo = true;
		}
		catch(Exception e){e.getMessage();}
		return bIsPublicationPublissimo;
	}
	
	public boolean isOrganisationPublicationBOAMP() {
		boolean bIsPublicationBOAMP = false;
		try{
			String sIsPublicationBOAMP = 
				OrganisationParametre.getOrganisationParametreValue(getIdOrganisation(), "isPublicationBOAMP");
			if(sIsPublicationBOAMP.equalsIgnoreCase("true")) bIsPublicationBOAMP = true;
		}
		catch(Exception e){e.getMessage();}
		return bIsPublicationBOAMP;
	}
	
	public boolean isOrganisationPublicationEmail() 
	throws NamingException, SQLException 
	{
		boolean b = false;
		Connection conn = ConnectionManager.getConnection();
		try {
			b = isOrganisationPublicationEmail(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		return b;
	}

	public boolean isOrganisationPublicationEmail(
			Connection conn) 
	{
		boolean bIsPublicationEmail = false;
		try{
			String sIsPublicationEmail = 
				OrganisationParametre.getOrganisationParametreValue(getIdOrganisation(), "isPublicationEmail", conn);
			if(sIsPublicationEmail.equalsIgnoreCase("true")) bIsPublicationEmail = true;
		}
		catch(Exception e){e.getMessage();}
		return bIsPublicationEmail;
	}
	
	public String serialize(
			boolean bAddPersonnePhysique, 
			boolean bAddCommission) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
	IllegalAccessException 
	{
		Connection conn = ConnectionManager.getConnection();
		String s = "";
		try {
			s = serialize(bAddPersonnePhysique, bAddPersonnePhysique, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		return s;
	}
	
	public String serialize(
			boolean bAddPersonnePhysique, 
			boolean bAddCommission,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
	IllegalAccessException 
	{
		Adresse adr = Adresse.getAdresse( this.iIdAdresse, false, conn);
		
		 String sOrganisation
		 	= "<organisation>\n"
		 		+ "<idOrganisation >" + this.lId + "</idOrganisation >\n"
		 		+ "<idOrganisationModelePDF >" + this.iIdOrganisationModelePDF + "</idOrganisationModelePDF>\n"
			 	+ "<idOrganisationType>" + this.iIdOrganisationType + "</idOrganisationType>\n" 
			 	+ "<raisonSociale >" + this.sRaisonSociale + "</raisonSociale >\n" 
			 	+ "<referenceExterne>" +  this.sReferenceExterne + "</referenceExterne>\n"
			 	+ "<idCategorieJuridique>" + this.iIdCategorieJuridique  + "</idCategorieJuridique>\n" 
			 	+ "<idCodeNaf>" + this.iIdCodeNaf + "</idCodeNaf>\n" 
		 		+ "<tvaIntra>" + this.sTvaIntra + "</tvaIntra>\n" 
			 	+ "<idAcheteurPublic >" +  this.iIdTypeAcheteurPublic + "</idAcheteurPublic >\n" 
			 	+ adr.serialize()
			 	+ "<idCreateur >" + this.iIdCreateur + "</idCreateur >\n" 
			 	+ "<commentaire>" + this.sCommentaire + "</commentaire>\n" 
		 		+ "<fax>" + this.sFax + "</fax>\n" 
		 		+ "<logo>" + this.sLogo + "</logo>\n" 
		 		+ "<mailOrganisation >" + this.sMailOrganisation + "</mailOrganisation >\n" 
		 		+ "<siret>" + this.sSiret + "</siret>\n" 
		 		+ "<siteWeb>" + this.sSiteWeb + "</siteWeb>\n" 
		 		+ "<telephone>" + this.sTelephone + "</telephone>\n" 
		 		+ "<dateCreation>" + this.tsDateCreation + "</dateCreation>\n" 
		 		+ "<dateModification>" + this.tsDateModification + "</dateModification>\n"
		 		+ "<idObjectTypeOwner>" + this.lIdObjectTypeOwner + "</idObjectTypeOwner>\n"
		 		+ "<idObjectReferenceOwner>" + this.lIdObjectReferenceOwner + "</idObjectReferenceOwner>\n";

		 if(bAddPersonnePhysique)
		 {
		 	sOrganisation +=
				 "<personnesPhysiques>\n";
		 	
		 	Vector<PersonnePhysique> vPersonnePhysique 
		 		= PersonnePhysique.getAllFromIdOrganisation((int)this.lId,false, conn);

		 	for (int i = 0; i < vPersonnePhysique.size(); i++) {
		 		PersonnePhysique personne = vPersonnePhysique.get(i);
		 		sOrganisation += personne.serialize(conn);
			}
		 	sOrganisation +=
		 		"</personnesPhysiques>\n";
		 }
		 
		 if(bAddCommission)
		 {
		 	sOrganisation +=
				 "<commissions>\n";
		 	
		 	Vector<Commission> vCommission 
		 		= Commission.getAllcommissionWithIdOrganisation((int)this.lId,false, conn);
		 	for (int i = 0; i < vCommission .size(); i++) {
		 		Commission commission= vCommission.get(i);
		 		sOrganisation += commission.serialize();
			}
		 	sOrganisation +=
		 		"</commissions>\n";
		 }
		 
		 
		 sOrganisation +=
		 	 "</organisation>\n";
		 
		 return sOrganisation;
	
	}
	
	public void deserialize (Node node, String sPathLogo) 
	throws CoinDatabaseLoadException, SAXException, SQLException, NamingException {
		Connection conn = this.getConnection();
		try {
			this.deserialize(node, sPathLogo, conn);
		}finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	
	public void deserialize (
			Node node, 
			String sPathLogo,
			Connection conn) 
	throws SAXException, SQLException, CoinDatabaseLoadException, NamingException
	{
		//this.iIdOrganisation = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "idOrganisation"));
		this.iIdOrganisationType = OrganisationType.TYPE_ACHETEUR_PUBLIC;
		try { 
			String sOrganisationType = BasicDom.getChildNodeValueByNodeName(node, "idOrganisationType");
			
			if(sOrganisationType != null) 
			{
				if(sOrganisationType.equalsIgnoreCase("E")){
					this.iIdOrganisationType = OrganisationType.TYPE_CANDIDAT;
				}else if(sOrganisationType.equalsIgnoreCase("A")){
					this.iIdOrganisationType = OrganisationType.TYPE_ACHETEUR_PUBLIC; 
				} else {
					this.iIdOrganisationType = Integer.parseInt(sOrganisationType);
				}
			}
			
		} catch (SAXException e) {
			e.printStackTrace();
			
			this.iIdOrganisationType = OrganisationType.TYPE_ACHETEUR_PUBLIC;
		}
		/**
		 * Très beau Villardon
		 */
		try { 
			this.sRaisonSociale = Outils.replaceAll(BasicDom.getChildNodeValueByNodeName(
				node, "raisonSociale"),"\"","")
				+" ("+BasicDom.getChildNodeValueByNodeName(node, "acheteurPublicReferenceExterne")+")";
		} catch (SAXException e) {
			this.sRaisonSociale = Outils.replaceAll(BasicDom.getChildNodeValueByNodeName(
					node, "raisonSociale"),"\"","");
		}
		
		this.sReferenceExterne = BasicDom.getChildNodeValueByNodeName(node, "referenceExterne");
		try { 
			this.sReferenceExterneAP = BasicDom.getChildNodeValueByNodeName(node, "acheteurPublicReferenceExterne");
		} catch (SAXException e) {
		}
		
		if(this.sRaisonSociale == null || this.sRaisonSociale.equals(""))
		{
			throw new SAXException("Organisation, ref ext " + this.sReferenceExterne
					+ ", must have the field sRaisonSociale fullfilled !");
		}
		


		try{
			this.iIdOrganisationModelePDF = (!BasicDom.getChildNodeValueByNodeName(node, "iIdOrganisationModelePDF").equalsIgnoreCase("")
					?Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "iIdOrganisationModelePDF")):1);
		}catch(Exception e){ 
			/** pour ne pas supprimer la valeur déja existante */
			if(this.iIdOrganisationModelePDF == 0)
				this.iIdOrganisationModelePDF = OrganisationModelePDF.TYPE_DEFAUT; 
		}
		try{
			this.sTvaIntra = (!BasicDom.getChildNodeValueByNodeName(node, "tvaIntra").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "tvaIntra"):"");
		}
		catch(Exception e){ }
		try{
			this.sCommentaire = (!BasicDom.getChildNodeValueByNodeName(node, "commentaire").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "commentaire"):"");
		}
		catch(Exception e){ }
		try{
			this.sFax = (!BasicDom.getChildNodeValueByNodeName(node, "fax").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "fax"):"");
		}
		catch(Exception e){ }
		try{
			this.sLogo = (!BasicDom.getChildNodeValueByNodeName(node, "logo").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "logo"):"");
			File logo = new File(sPathLogo+this.sLogo);
			setLogo(logo);
		}
		catch(Exception e){ }
		try{
			this.sMailOrganisation = (!BasicDom.getChildNodeValueByNodeName(node, "mailOrganisation").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "mailOrganisation"):"");
		}
		catch(Exception e){this.sMailOrganisation = "";}
		try{
			this.sSiret = (!BasicDom.getChildNodeValueByNodeName(node, "siret").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "siret"):"");
		}
		catch(Exception e){}
		try{
			this.sSiteWeb = (!BasicDom.getChildNodeValueByNodeName(node, "siteWeb").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "siteWeb"):"");
		}
		catch(Exception e){}
		try{
			this.sTelephone = (!BasicDom.getChildNodeValueByNodeName(node, "telephone").equalsIgnoreCase("")
					?BasicDom.getChildNodeValueByNodeName(node, "telephone"):"");
		}
		catch(Exception e){ }
		try{
			this.tsDateCreation = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "dateCreation");
		}
		catch(Exception e){ }
		try{
			this.tsDateModification = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "dateModification");
		}
		catch(Exception e){}
		try{
			this.iIdTypeAcheteurPublic = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "iIdTypeAcheteurPublic"));
		
		}catch(Exception e){ 
			/** pour ne pas supprimer la valeur déja existante */
			if(this.iIdTypeAcheteurPublic == 0)
				this.iIdTypeAcheteurPublic = TypeAcheteurPublic.TYPE_ACHETEUR_PUBLIC_AUTRE; 
		}
		

		this.sTelephone = Outils.replaceAll(this.sTelephone, ".", "");
		this.sFax = Outils.replaceAll(this.sFax, ".", "");
		
		this.sTelephone = Outils.replaceAll(this.sTelephone, " ", "");
		this.sFax = Outils.replaceAll(this.sFax, " ", "");

		this.sTelephone = Outils.replaceAll(this.sTelephone, "-", "");
		this.sFax = Outils.replaceAll(this.sFax, "-", "");
		
		try { 
			String sCodeEtat = BasicDom.getChildNodeValueByNodeName(node, "codeEtat");
			if(sCodeEtat.equalsIgnoreCase("01")){
				/**
				 * all users have to be ACTIVATED 
				 */
				User.updateAllActiveFromOrganisation(this.lId, conn);
			}else if(sCodeEtat.equalsIgnoreCase("99")){
				/**
				 * all users have to be DESACTIVATED 
				 */
				User.updateAllInactiveFromOrganisation(this.lId, conn);
			}
		} catch (SAXException e) {}
		
		try{
			this.iIdCategorieJuridique = (!BasicDom.getChildNodeValueByNodeName(node, "idCategorieJuridique").equalsIgnoreCase("")
					?Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "idCategorieJuridique")):0);
		}catch(Exception e){ 
			this.iIdCategorieJuridique = 0;
		}
		
		try { 
			/**
			 * TODO : optimize it
			 */
			String sCodeNaf = BasicDom.getChildNodeValueByNodeName(node, "idCodeNaf");
			if(!Outils.isNullOrBlank(sCodeNaf)){
				CodeNaf code = CodeNaf.getAllCodeNafLike(sCodeNaf,0, 1, false, conn).firstElement();
				this.iIdCodeNaf = code.getIdCodeNaf();
			}
		} catch (SAXException e) {
			this.iIdCodeNaf = 0;
		} catch (NoSuchElementException e) {
			this.iIdCodeNaf = 0;
		}
		
		// FLON : DK=>? il manque le createur de l'organisme, qui s'en occupe ?
		// HttpSession hsSession = 
        // User uUserSession = (User)hsSession.getAttribute("sessionUser");
        //int iPersonnePhysique = uUserSession.getIdIndividual();
		//this.setIdCreateur(iPersonnePhysique);
	}

	
	public static Vector<Organisation> getAllStatic(Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Organisation item = new Organisation();
		return item.getAll(conn);
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterne(String sRefExt)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRefExt);
		return getAllWithWhereClause(" WHERE reference_externe LIKE ?", vParams);
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterne(
			String sRefExt,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRefExt);
		return getAllWithWhereClause(" WHERE reference_externe LIKE ?", vParams,conn);
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterne(
			String sRefExt,
			int iIdOrganisationType,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRefExt);
		vParams.add(new Integer(iIdOrganisationType));
		return getAllWithWhereClause(
				" WHERE reference_externe LIKE ?"
				+ " AND id_organisation_type = ?" , 
				vParams,
				conn);
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterne(
			String sRefExt,
			Vector<Organisation> vOrgaTotal)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Organisation> vOrgaSelected = new Vector<Organisation> ();
		
		for (Organisation organisation : vOrgaTotal) {
			if(sRefExt.equals(organisation.getReferenceExterne()))
			{
				vOrgaSelected.add(organisation );
			}
		}
		
		return vOrgaSelected;
	}
	
	public static Vector<Organisation> getAllOrganisationByRaisonSociale(
			String sRaisonSociale,
			Vector<Organisation> vOrganisation)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Organisation> vOrgaSelected = new Vector<Organisation> ();
		
		for (Organisation organisation : vOrganisation) {
			if(Outils.removeAllSpaces(sRaisonSociale).equalsIgnoreCase(Outils.removeAllSpaces(organisation.getRaisonSociale())))
			{
				vOrgaSelected.add(organisation );
			}
		}
		
		return vOrgaSelected;
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterneAcheteurPublic(
			String sRefExt,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRefExt);
		return getAllWithWhereClause(" WHERE reference_externe_ap LIKE ?", vParams,conn);
	}
	
	public static Vector<Organisation> getAllOrganisationByReferenceExterneAcheteurPublic(
			String sRefExt,
			Vector<Organisation> vOrganisationTotal)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Organisation> vOrganisation =  new Vector<Organisation>();
		
		for (Organisation organisation : vOrganisationTotal) {
			if(organisation.getReferenceExterneAP().equalsIgnoreCase(sRefExt))
			{
				vOrganisation.add(organisation);
			}
		}
		
		return vOrganisation;
	}

	public static  Vector<Organisation> getAllOrganisationByRaisonSociale(String sRaisonSociale) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRaisonSociale.toLowerCase().trim());
		return getAllWithWhereClause(" WHERE LOWER(TRIM(raison_sociale)) LIKE ?", vParams);
	}
	
	public static  boolean isOrganisationWithRaisonSocialeWithout(String sRaisonSociale,int iIdOrg) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Integer(iIdOrg));
		vParams.add(sRaisonSociale.toLowerCase().trim());
		Vector<Organisation> vOrganisations = getAllWithWhereClause(" WHERE id_organisation <> ? AND LOWER(TRIM(raison_sociale)) LIKE ?", vParams);
		
		if(vOrganisations.size() > 0)
			return true;
		
		return false;
	}

	public static  boolean isOrganisationWithRaisonSociale(String sRaisonSociale) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sRaisonSociale.toLowerCase().trim());
		Vector<Organisation> vOrganisations = getAllWithWhereClause(" WHERE LOWER(TRIM(raison_sociale)) LIKE ?", vParams);
		
		if(vOrganisations.size() > 0)
			return true;
		
		return false;
	}


	/**
	 * 
	 * La méthode recherche en base l'objet en fonction de sa référence externe.
	 * s'il le trouve il le met à jour avec le contenu XML et le stocke en base
	 * sinon il crée un nouvel objet avec le contenu XML et le créé en base
	 * 
	 * La méthode renvoie l'objet synchronisé.
	 * 
	 * @param sReferenceExterne
	 * @return
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SAXException 
	 * @throws CoinDatabaseDuplicateException 
	 * @throws CoinDatabaseCreateException 
	 * @throws CoinDatabaseLoadException 
	 * @throws CoinDatabaseStoreException 
	 * @throws CloneNotSupportedException 
	 * @throws Exception 
	 * @throws Exception
	 */
	public static Organisation synchronize(Node nodeOrganisme, String sPathLogo)
	throws SQLException, SAXException, InstantiationException, IllegalAccessException, NamingException,
	CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException,
	CoinDatabaseStoreException, CloneNotSupportedException {
		Connection conn = ConnectionManager.getDataSource().getConnection();
		Organisation org = null;
		try {
			org = synchronize(nodeOrganisme,sPathLogo, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
		return org;
	}
	public static Organisation synchronize(
			Node nodeOrganisme, 
			String sPathLogo,
			Connection conn)
	throws SAXException, InstantiationException, IllegalAccessException, NamingException, 
	SQLException, CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	CoinDatabaseStoreException, CloneNotSupportedException 
	{
		return synchronize(nodeOrganisme, sPathLogo, null, true, false, conn);
	}
	
	/**
	 * return object if found, null if not found or throw an exception if many (>1)
	 * @return
	 * @throws CoinDatabaseLoadException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SAXException 
	 */
	public static Organisation getOrganisationByReferenceExterne(
			Node nodeOrganisme, 
			Vector<Organisation> vOrgaTotal,
			Connection conn) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, 
	SQLException, SAXException
	{
		String sReferenceExterne 
			= BasicDom.getChildNodeValueByNodeName(nodeOrganisme, "referenceExterne");
		Organisation org = null;

		/**
		 * control external reference
		 */
		if(sReferenceExterne == null 
		|| sReferenceExterne.trim().equals(""))
		{
			org = new Organisation();
			org.deserialize(nodeOrganisme, null, conn);
			throw new CoinDatabaseLoadException("Erreur synchro organisation"
					+ " pas de ref ext : '" + sReferenceExterne + "'" 
					+ " pour : " + org.getRaisonSociale() , "");	
		}	

		return getOrganisationByReferenceExterne(sReferenceExterne, vOrgaTotal, conn);
	}
	
	public static Organisation getOrganisationByReferenceExterne(
			String sReferenceExterne, 
			Vector<Organisation> vOrgaTotal,
			Connection conn) 
	throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, 
	SQLException, SAXException
	{
		Organisation org = null;
		
		Vector<Organisation> vOrga = null;
		if(vOrgaTotal == null) vOrga = getAllOrganisationByReferenceExterne(sReferenceExterne,conn);
		else vOrga = getAllOrganisationByReferenceExterne(sReferenceExterne,vOrgaTotal);
		
		
		switch(vOrga.size())
		{
		case 1:
			org = (Organisation) vOrga.firstElement() ;
			break;
		
		case 0 :
			// nothing to do
			break;
		
		default:
			throw new CoinDatabaseLoadException("Erreur dans la liste des organisations "
					+ "plusieurs références externes pour : '" + sReferenceExterne+"'", "");
			//break;
		}
		
		
		System.out.println("vOrga.size() : " + vOrga.size());
		return org;

	}
	
	public static Organisation synchronize(
			Node nodeOrganisme, 
			String sPathLogo,
			Vector<Organisation> vOrgaTotal, 
			boolean bCreateOrganizationCheckDuplicate,
			boolean bCreateParamWebServiceSync,
			Connection conn) 
	throws SAXException, InstantiationException, IllegalAccessException, NamingException,
	SQLException, CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	CoinDatabaseStoreException, CloneNotSupportedException
	{
		Organisation org = getOrganisationByReferenceExterne(nodeOrganisme, vOrgaTotal, conn);
		
		if(org != null )
		{
			/**
			 * if objects are equals don't update !
			 */
			try{
				Organisation orgaTmp = (Organisation) org.clone();
				orgaTmp.deserialize(nodeOrganisme, sPathLogo, conn);
				if(!orgaTmp.equals(org)){
					org.deserialize(nodeOrganisme, sPathLogo, conn);
					org.setCreateOrganizationCheckDuplicate(bCreateOrganizationCheckDuplicate);
					org.store(conn);
				}
			}catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			/**
			 * no organisation, create it
			 */
			Organisation orgNew = new Organisation();
			orgNew.deserialize(nodeOrganisme, sPathLogo, conn);

			/**
			 * EVOL bug #2250
			 */
			org = AddressBookMerger.mergeOrganisationPublisher(orgNew, conn);
			if(org == null){
				/**
				 * Not mergeable , so create it
				 */
				org = orgNew;
				org.setCreateOrganizationCheckDuplicate(bCreateOrganizationCheckDuplicate);
				org.create(conn);
			} else {
				/**
				 * Merge it !
				 * INFO : org.setReferenceExterne(sReferenceExterne) done in deserialize()
				 */
				org.deserialize(nodeOrganisme, sPathLogo, conn);
				org.store(conn);
				System.out.println("sync orga : merge !");
			}
		}
		
		


		/**
		 * Web Service Sync
		 */
		if(bCreateParamWebServiceSync)
		{
			OrganisationWebService.createParamSynchro(org, conn);
		}
			
		return org;
	}
	
	@Override
	protected Object clone() throws CloneNotSupportedException {
		Organisation item = new Organisation();

		item.lId = this.lId;
		item.iIdOrganisationType = this.iIdOrganisationType;
		item.iIdAdresse = this.iIdAdresse;
		item.sRaisonSociale = this.sRaisonSociale;
		item.sSiret = this.sSiret;
		item.sMailOrganisation = this.sMailOrganisation;
		item.sTelephone = this.sTelephone;
		item.sFax = this.sFax;
		item.sSiteWeb = this.sSiteWeb;
		item.sCommentaire = this.sCommentaire;
		item.iIdCodeNaf = this.iIdCodeNaf;
		item.sTvaIntra = this.sTvaIntra;
		item.iIdCategorieJuridique = this.iIdCategorieJuridique;
		item.tsDateCreation = this.tsDateCreation;
		item.tsDateModification = this.tsDateModification;
		item.sLogo = this.sLogo;
		item.sReferenceExterne = this.sReferenceExterne;
		item.iIdTypeAcheteurPublic = this.iIdTypeAcheteurPublic;
		item.iIdCreateur = this.iIdCreateur;
		item.iIdOrganisationModelePDF = this.iIdOrganisationModelePDF;
		item.sReferenceExterneAP = this.sReferenceExterneAP;
		
		return item;
	}
	
	
	@Override
	public boolean equals(Object obj) {
		Organisation item = (Organisation) obj;
		boolean bEquals = true;

		/**
		 * INFO : we don't verify ID
		 */
		if(this.iIdOrganisationType != item.iIdOrganisationType) bEquals = false;
		if(this.iIdAdresse != item.iIdAdresse) bEquals = false;
		if(!this.sRaisonSociale.equals(item.sRaisonSociale)) bEquals = false;
		if(!this.sMailOrganisation.equals(item.sMailOrganisation)) bEquals = false;
		if(!this.sFax.equals(item.sFax)) bEquals = false;
		if(!this.sSiteWeb.equals(item.sSiteWeb)) bEquals = false;
		if(!this.sCommentaire.equals(item.sCommentaire)) bEquals = false;
		if(this.iIdCodeNaf != item.iIdCodeNaf) bEquals = false;
		if(!this.sTvaIntra.equals(item.sTvaIntra)) bEquals = false;
		if(this.iIdCategorieJuridique != item.iIdCategorieJuridique) bEquals = false;

		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateCreation, item.tsDateCreation);
		}
		
		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateModification, item.tsDateModification);
		}

		if(bEquals ){
			bEquals = Outils.equalsString(this.sLogo, item.sLogo);
		}

		if(!this.sReferenceExterne.equals(item.sReferenceExterne)) bEquals = false;
		if(this.iIdTypeAcheteurPublic != item.iIdTypeAcheteurPublic) bEquals = false;
		if(this.iIdCreateur != item.iIdCreateur) bEquals = false;
		if(this.iIdOrganisationModelePDF != item.iIdOrganisationModelePDF) bEquals = false;
		if(!this.sReferenceExterneAP.equals(item.sReferenceExterneAP)) bEquals = false;

		System.out.println("ORGA bEquals : " + bEquals);
		
		return bEquals;
	}
	
	
	/**
	 * Méthode initialisant tous les champs de l'objet Organisation
	 * avec des valeurs par défaut
	 */
	public void init() {
	
		this.TABLE_NAME = "organisation";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		this.SELECT_FIELDS_NAME 
						= " id_organisation_type,"
						+ " id_adresse,"
						+ " raison_sociale," 
						+ " siret,"
						+ " mail_organisation,"
						+ " telephone,"
						+ " fax,"
						+ " site_web,"
						+ " commentaire,"
						+ " id_code_naf,"
						+ " tva_intra,"
						+ " id_categorie_juridique,"
						+ " date_creation,"
						+ " date_derniere_modification,"
						+ " nom_logo,"
						+ " reference_externe,"
						+ " id_type_acheteur_public,"
						+ " id_createur,"
						+ " id_organisation_modele_pdf,"
						+ " reference_externe_ap,"
						+ " id_object_type_owner,"
						+ " id_object_reference_owner,"
						+ " id_organisation_classe_profit";
		
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		this.iAbstractBeanIdObjectType = ObjectType.ORGANISATION;
		
		this.iIdTypeAcheteurPublic = 0;
		this.lId = 0;
		this.iIdOrganisationType = 0;
		this.iIdAdresse = 0;
		this.iIdCreateur = 0;
		this.sRaisonSociale = "";
		this.sSiret = "";
		this.sMailOrganisation = "";
		this.sTelephone = "";
		this.sFax = "";
		this.sSiteWeb = "";
		this.sCommentaire ="";
		this.iIdCodeNaf = 0;
		this.iIdCategorieJuridique = 0;
		this.sTvaIntra ="";
		this.iIdOrganisationModelePDF = OrganisationModelePDF.TYPE_DEFAUT;
		this.sReferenceExterneAP = "";
		this.lIdObjectTypeOwner = 0;
		this.lIdObjectReferenceOwner = 0;
		this.iIdOrganisationClasseProfit = 0;
		
	}

	// SETTERs

	public void setIdTypeAcheteurPublic(int i) {
		this.iIdTypeAcheteurPublic = i;
	}
	public void setIdCreateur(int i) {
		this.iIdCreateur = i;
	}
	public void setIdOrganisation(int i) {
		this.lId = i;
	}
	public void setIdOrganisationType(int i) {
		this.iIdOrganisationType = i;
	}
	public void setIdAdresse(int i) {
		this.iIdAdresse = i;
	}
	public void setIdCodeNaf(int i) {
		this.iIdCodeNaf = i;
	}
	public void setIdCategorieJuridique(int i) {
		this.iIdCategorieJuridique = i;
	}
	public void setRaisonSociale(String s) {
		this.sRaisonSociale = s;
	}
	public void setSiret(String s) {
		this.sSiret = s;
	}
	public void setMailOrganisation(String s) {
		this.sMailOrganisation = s;
	}
	public void setTelephone(String s) {
		this.sTelephone = s;
	}
	public void setFax(String s) {
		this.sFax = s;
	}
	public void setSiteWeb(String s) {
		this.sSiteWeb = s;
	}
	public void setCommentaire(String s) {
		this.sCommentaire = s;
	}
	public void setTvaIntra(String s) {
		this.sTvaIntra = s;
	}
	
	public void setDateCreation(Timestamp ts) {
		this.tsDateCreation = ts;
	}
	
	public void setDateModification(Timestamp ts) {
		this.tsDateModification = ts;
	}
	public void setIdOrganisationModelePDF(int i) {
		this.iIdOrganisationModelePDF = i;
	}
	
	public void setReferenceExterneAP(String sRef) {
		this.sReferenceExterneAP = sRef;
	}

	public void setIdObjectTypeOwner(long lIdObjectTypeOwner) {
		this.lIdObjectTypeOwner = lIdObjectTypeOwner;
	}

	public void setIdObjectReferenceOwner(long lIdObjectReferenceOwner) {
		this.lIdObjectReferenceOwner = lIdObjectReferenceOwner;
	}

	public void setIdOrganisationClasseProfit(int iIdOrganisationClasseProfit) {
		this.iIdOrganisationClasseProfit = iIdOrganisationClasseProfit;
	}
	
	// GETTERs
	public int getIdCategorieJuridique() {
		return this.iIdCategorieJuridique;
	}
	public int getIdTypeAcheteurPublic() {
		return this.iIdTypeAcheteurPublic;
	}
	public String getTvaIntra() {
		return this.sTvaIntra;
	}
	public int getIdCreateur() {
		return this.iIdCreateur;
	}
	public int getIdOrganisation() {
		return (int)this.lId;
	}
	public int getIdOrganisationType() {
		return this.iIdOrganisationType;
	}

	public int getIdAdresse() {
		return this.iIdAdresse;
	}

	public int getIdCodeNaf() {
		return this.iIdCodeNaf;
	}
	public int getIdOrganisationModelePDF() {
		return this.iIdOrganisationModelePDF;
	}
	public String getRaisonSociale() {
		return this.sRaisonSociale;
	}
	public String getSiret() {
		return this.sSiret;
	}

	public String getNomLogo() {
		return this.sLogo;
	}
	public InputStream getLogo() {
		return this.isLogo;
	}
	
	public String getReferenceExterne(){
		return this.sReferenceExterne;
	}

	public String getReferenceExterneAP(){
		return this.sReferenceExterneAP;
	}

	public long getIdObjectTypeOwner(){
		return this.lIdObjectTypeOwner;
	}

	public long getIdObjectReferenceOwner(){
		return this.lIdObjectReferenceOwner;
	}

	public int getIdOrganisationClasseProfit() {
		return this.iIdOrganisationClasseProfit;
	}
	
	public boolean isOwnerIndividual(
			long lIdIndividual)
	{
		return this.lIdObjectTypeOwner == ObjectType.PERSONNE_PHYSIQUE
		&& this.lIdObjectReferenceOwner == lIdIndividual;
	}
	
	
	public static Organisation getOrganisation (long lId )
	throws CoinDatabaseLoadException, SQLException, NamingException
	{
    	return getOrganisation(lId,true);
    }
	
	public static Organisation getOrganisation (long lId, boolean bUseHttpPrevent)
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	Organisation item = new Organisation (lId );
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load();
   		return item;
    }
	
	public static Organisation getOrganisation(
			long lId,
			Vector<Organisation> vOrganisation) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		return (Organisation)getCoinDatabaseAbstractBeanFromId(lId, vOrganisation);
	}
	
	public static Organisation getOrganisation (
			long lIdOrganisation, 
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
    	Organisation item = new Organisation (lIdOrganisation );
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
   		return item;
    }
	
	public static Organisation getOrLoadOrganisation(
			long lId,
			Vector<Organisation> vOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		try{
			return getOrganisation((int)lId, vOrganisation);
		} catch (CoinDatabaseLoadException e) {
			Organisation item =  getOrganisation((int)lId, bUseHttpPrevent, conn);
			vOrganisation.add(item);
			return item;
		}
    }
	
	
	public static Organisation getOrganisation (int iIdOrganisation,Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return getOrganisation(iIdOrganisation,true,conn);
	}

	public static Organisation getOrganisationFromReferenceExterne (
			String sReferenceExterne,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, CoinDatabaseDuplicateException,
	InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation ();
    	item.bUseHttpPrevent = bUseHttpPrevent;
		item.bUseEmbeddedConnection = true; 
		item.connEmbeddedConnection = conn; 
		Vector<Object> vParams = new Vector<Object>();
    	vParams.add(sReferenceExterne);
    	
    	return (Organisation) item.getAbstractBeanWithWhereAndOrderByClause(
    			" WHERE reference_externe=? ", 
    			"", 
    			vParams, 
    			true);
	}

	
	public static Organisation getOrganisation(
			int iId, 
			Vector<Organisation> vOrganisation) 
	throws CoinDatabaseLoadException, SQLException, NamingException  {
	    
		return (Organisation)CoinDatabaseAbstractBean.getCoinDatabaseAbstractBeanFromId(iId, vOrganisation);
	}

	public String[] getSiretDecomposition() {
		String siret = getSiret();
		String sarrSiretDecompose[] = new String[4];
		sarrSiretDecompose[0] = "";
		sarrSiretDecompose[1] = "";
		sarrSiretDecompose[2] = "";
		sarrSiretDecompose[3] = "";
		try {
			int iMaxLength = 14;
			if(siret.length()<14) iMaxLength = siret.length();
			
			sarrSiretDecompose[0] = siret.substring(0, 3);
			sarrSiretDecompose[1] = siret.substring(3, 6);
			sarrSiretDecompose[2] = siret.substring(6, 9);
			sarrSiretDecompose[3] = siret.substring(9, iMaxLength);
		} catch (Exception e)
		{
		}
		return sarrSiretDecompose;
	}
	public String getSiretValueDisplay(String sIdpays) {
		String sSiretToPrint = "";
		if(sIdpays.equalsIgnoreCase(Pays.FRANCE)){
			String sarrSiretDecomposition[] = this.getSiretDecomposition();
			sSiretToPrint = sarrSiretDecomposition[0]+" "+
	        sarrSiretDecomposition[1]+" "+
	        sarrSiretDecomposition[2]+" "+
	        sarrSiretDecomposition[3]; 
		}else{
			sSiretToPrint = this.getSiret();
		}
		return sSiretToPrint;
	}
	
	public ArrayList<HashMap<String, String>> getSiretValueForm(String sIdpays) {
		ArrayList<HashMap<String, String>> listInput = new ArrayList<HashMap<String,String>>();
		if(sIdpays.equalsIgnoreCase(Pays.FRANCE)){
			String sarrSiretDecomposition[] = this.getSiretDecomposition();
			for(int i=0;i<sarrSiretDecomposition.length;i++){
				HashMap<String, String> mapInput = new HashMap<String, String>();
				mapInput.put("name", "sSiret"+(i+1));
				mapInput.put("id", "sSiret"+(i+1));
				if(i!=3){
					mapInput.put("size", "4");
					mapInput.put("maxlength", "3");
				}else{
					mapInput.put("size", "6");
					mapInput.put("maxlength", "5");
				}
				mapInput.put("value", sarrSiretDecomposition[i]);
				listInput.add(mapInput);
			}
		}else{
			HashMap<String, String> mapInput = new HashMap<String, String>();
			mapInput.put("name", "sSiret");
			mapInput.put("id", "sSiret");
			mapInput.put("size", "30");
			mapInput.put("maxlength", "");
			mapInput.put("value", this.getSiret());
			listInput.add(mapInput);
		}
		return listInput;
	}
	
	
	public String getMailOrganisation() {
		return this.sMailOrganisation;
	}
	public String getTelephone() {
		return this.sTelephone;
	}
	public String getFax() {
		return this.sFax;
	}
	public String getSiteWeb() {
		return this.sSiteWeb;
	}
	public String getCommentaire() {
		return this.sCommentaire;
	}
	public Timestamp getDateCreation() {
		return this.tsDateCreation;
	}
	public Timestamp getDateModification() {
		return this.tsDateModification;
	}
		
	/**
	 * Détermine si l'organisation existe déjà dans la base
	 * @param sSiret - numéro de siret unique à l'entreprise
	 * @return true si doublon sinon false
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public boolean isDoublonSiret(String sSiret) throws NamingException, SQLException {
		boolean bIsDoublon = false;
		String requete = "SELECT * FROM " + this.TABLE_NAME + " WHERE siret='" + sSiret + "'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(requete);
			
			if (resultat.next())
				bIsDoublon = true;
		}finally
		{
			ConnectionManager.closeConnection(resultat,stat,conn);
		}
		
		return bIsDoublon;
	}
	
	
	/**
	 * Détermine si l'organisation existe déjà dans la base
	 * @param sSiret - numéro de siret unique à l'entreprise
	 * @return true si doublon sinon false
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public boolean isDoublonOrganisation(
			String sSiret,
			String sRaisonSociale,
			String sMailOrganisation,
			Connection conn) 
	throws NamingException, SQLException 
	{
		boolean bIsDoublon = false;
    	sRaisonSociale = Outils.replaceAll(sRaisonSociale, "'" , "\\'");
    	
		String sSqlQuery = "SELECT * FROM " + this.TABLE_NAME 
			+ " WHERE siret=? and raison_sociale=? and mail_organisation=?";
	
		Statement stat = null;
		ResultSet rs = null;
		PreparedStatement ps = null;
		
		try 
		{
			stat = conn.createStatement();
			ps = (stat.getConnection()).prepareStatement(sSqlQuery );
			ps.setString(1, sSiret);
			ps.setString(2, sRaisonSociale);
			ps.setString(3, sMailOrganisation);
			rs = ps.executeQuery();
			
			if (rs.next())
				bIsDoublon = true;
		}
		finally
		{
			ConnectionManager.closeConnection(rs,stat, ps);
		}
		
		return bIsDoublon;
	}
	/**
	 * Méthode ajoutant un enregistrement d'un objet Organisation dans la base
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseCreateException 
	 * @throws CoinDatabaseDuplicateException 
	 * @throws Exception 
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
	public void create(Connection conn) 
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, NamingException,
	SQLException, CoinDatabaseLoadException  
	{
		setDateCreation(new Timestamp(System.currentTimeMillis()));
		setDateModification(new Timestamp(System.currentTimeMillis()));
		
		if (this.bCreateOrganizationCheckDuplicate)
		{
			if(isDoublonOrganisation(
					this.sSiret,
					this.sRaisonSociale,
					this.sMailOrganisation,
				conn))
		    {
		    	throw new CoinDatabaseDuplicateException(
		    			"siret / raison sociale / mail / ref. externe",
		    				this.sSiret
			    			+ " / "+ this.sRaisonSociale
			    			+ " / " + this.sMailOrganisation
			    			+ " / " + this.sReferenceExterne,
		    			"");
		    }
		}
		
		super.create(conn);
	}
	
	public static Organisation createOrganisationCasual(
			long lIdObjectReferenceOwner,
			Connection conn)
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException, NamingException, SQLException
	{
		Adresse adrCasual = new Adresse ();
		adrCasual.create(conn);
		Organisation orgCasual = new Organisation();
		orgCasual.setRaisonSociale(""); 
		orgCasual.setIdObjectTypeOwner(ObjectType.PERSONNE_PHYSIQUE);
		orgCasual.setIdObjectReferenceOwner(lIdObjectReferenceOwner);
		orgCasual.setIdAdresse((int)adrCasual.getId());
		orgCasual.setIdOrganisationType(OrganisationType.TYPE_EXTERNAL_CASUAL);
		orgCasual.setCreateOrganizationCheckDuplicate(false);	
		orgCasual.create(conn);
		
		return orgCasual;
	}
	
	
	public void removeWithObjectAttached()
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Connection conn = getConnection();
		try{
			removeWithObjectAttached(conn) ;
		} finally {
			releaseConnection(conn);
		}
	}
	
	public void removeWithObjectAttached(
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException 
	{
		Vector<PersonnePhysique> vPP = PersonnePhysique.getAllFromIdOrganisation(
				(int)this.lId, 
				false, 
				conn);
		
		for(int i=0;i<vPP.size();i++)
		{
			try{
				vPP.get(i).removeWithObjectAttached(conn);
			}catch (Exception e) { }
		}
		
		try{
			Adresse adresse = Adresse.getAdresse(this.iIdAdresse, false, conn);
			adresse.remove(conn);
		} catch (Exception e) {}
		
		try{
			OrganisationGroupItem.removeAllFromOrganisation(this.lId, conn);
		} catch (Exception e) {}
		
		
		
		Vector<Multimedia> vMultimedia = Multimedia.getAllMultimedia(
				(int)this.lId, 
				ObjectType.ORGANISATION, 
				false, 
				conn);
		for(Multimedia m : vMultimedia)
		{
			m.remove(conn);
		}

		try{
			Vector<OrganisationService> vOrganisationService = OrganisationService.getAllFromIdOrganisation(
					(int)this.lId, 
					false, 
					conn);
			for(OrganisationService m : vOrganisationService )
			{
				/**
				 * TODO : to finish with a removeWithObjectAttached()
				 */
				m.removeWithObjectAttached(conn);
			}
		}catch(Exception e){/** there is projects don't have OrganisationService table*/}
        
		try{
			Vector<Organigram> vOrganisationOrganigramInterService
	        = Organigram.getAllFromObject(
	            ObjectType.ORGANISATION,
	            this.lId,
	            ObjectType.ORGANISATION_SERVICE,
	            false, 
	            conn);
			
	        for(Organigram o : vOrganisationOrganigramInterService)
	        {
	        	o.removeWithObjectAttached(conn);
	        }
		}catch(Exception e){/** there is projects don't have Organigram table*/}
        
		this.remove(conn);
        
	}
	

	public static InputStream getInputStreamLogo(int iIdOrganisation )
	throws SQLException, NamingException, CoinDatabaseLoadException {
		String sSqlQuery = "SELECT logo " 
					+ " FROM " + "organisation"
					+ " WHERE id_organisation=" + iIdOrganisation;
		
		return ConnectionManager.downloadInputStream(sSqlQuery);
	}

	/**
	 * Renvoie toutes les organisations de la base de données
	 * @return un tableau d'objet Organisation
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception 
	 */
	public static Vector<Organisation>  getAllOrganisations()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getOrganisationsWithWhereClause("");
	}

	/**
	 * Méthode statique permettant de savoir si la personne physique passée en paramètre
	 * est gérante d'une organisation
	 * @param iIdPersonnePhysique - identifiant de la personne physique
	 * @return l'identifiant de l'organisation gérée par la personne physique
	 * sinon -1
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public static int isCreateur(int iIdPersonnePhysique) throws NamingException, SQLException {
	    String requete = "SELECT id_organisation FROM " + "organisation"
	    				+ " WHERE id_createur='" + iIdPersonnePhysique + "'";
	    int iIdOrganisation = -1;
	    
	    try {
		    iIdOrganisation=ConnectionManager.getCountInt(requete);
	    } catch (CoinDatabaseLoadException e) {
		}
		
		return iIdOrganisation;
	}
	/**
	 * Renvoie toutes les organisations de la base de données
	 * @return un tableau d'objet Organisation
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception 
	 */
	public static Vector<Organisation> getAllOrganisationsWithIdType(int iIdOrganisationType) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getAllOrganisationsWithIdType(iIdOrganisationType,true);
	}
	
	public static Vector<Organisation> getAllOrganisationsWithIdType(
			int iIdOrganisationType,
			boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getAllOrganisationsWithIdType(iIdOrganisationType, bUseHttpPrevent, null);
	}
	
	public static Vector<Organisation> getAllOrganisationsWithIdType(
			int iIdOrganisationType,
			boolean bUseHttpPrevent ,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		int[] listType = {iIdOrganisationType};
		return getAllOrganisationsWithIdType(listType, bUseHttpPrevent, conn);
	}
	
	public static Vector<Organisation> getAllOrganisationsWithIdType(
			int[] listType,
			boolean bUseHttpPrevent ,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Organisation item = new Organisation(); 
		item.bUseHttpPrevent = bUseHttpPrevent ;
		if(conn!=null) item.setAbstractBeanConnexion(conn);
		
		CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		cw.add(listType);
		
		return item.getAllWithWhereAndOrderByClause(
				"WHERE "+cw.generateWhereClause("id_organisation_type"), 
				"ORDER BY raison_sociale ASC");
	}
	
	
	/**
	 * Renvoie toutes les organisations de la base de données
	 * @return un tableau d'objet Organisation
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception 
	 */
	public static Vector<Organisation> getOrganisationsWithWhereClause(String sWhereClause)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException  {
		Organisation org = new Organisation();
		String sSQLQuery 
			= "SELECT " + org.SELECT_FIELDS_NAME + "," + org.FIELD_ID_NAME
			+ " FROM " + org.TABLE_NAME + " "
			+ sWhereClause;
		
		return getAllOrganisations(sSQLQuery);
	}
	
	
	public static Organisation getOrganisationsWithRaisonSociale(
			String sRaisonSociale,
			Vector<Organisation> vOrganisation)
	{
		
		for (Organisation organisation : vOrganisation) {
			if (organisation.getRaisonSociale().equalsIgnoreCase(sRaisonSociale))
			{
				return organisation;
			}
		}
		return null;
	}
	
	/**
	 * Renvoie toutes les organisations de la base de données
	 * s'apparentant à la chaine de caractères sChamp en entrée
	 * @return un tableau d'objet Organisation
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception 
	 */
	public static Vector<Organisation> getOrganisationsWithRaisonSocialeLike(
			String sChaine, 
			int iLimitOffset, 
			int iLimit)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		Organisation org = new Organisation();
		String sSQLQuery 
			= "SELECT " + org.SELECT_FIELDS_NAME + "," + org.FIELD_ID_NAME
			+ " FROM " + org.TABLE_NAME + " ";
		
		if (sChaine!=null){
			vParams.add("%"+sChaine+"%");
			sSQLQuery += " WHERE raison_sociale LIKE ?";
		}
		sSQLQuery += " ORDER BY raison_sociale";
		
		if (iLimit>0){
			sSQLQuery += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		return getAllOrganisations(sSQLQuery,vParams);
	}
	
	public static Vector<Organisation> getOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		return getOrganisationsWithTypeAndRaisonSocialeLike(iIdType,sChaine,iLimitOffset,iLimit,true);
	}
	
	public static Vector<Organisation> getOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		return getOrganisationsWithTypeAndRaisonSocialeLike(iIdType, sChaine, iLimitOffset, iLimit, bUseHttpPrevent, "","");
	}
	
	public static Vector<Organisation> getOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			boolean bUseHttpPrevent,
			String sFrom,
			String sAddClause)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		return getOrganisationsWithTypeAndRaisonSocialeLike(
				iIdType, 
				sChaine, 
				iLimitOffset, 
				iLimit, 
				bUseHttpPrevent, 
				sFrom, 
				sAddClause, 
				false);
	}
	
	/**
	 * 
	 * @param iIdType
	 * @param sChaine
	 * @param iLimitOffset
	 * @param iLimit
	 * @param bUseHttpPrevent
	 * @param sFrom
	 * @param sAddClause without first AND or WHERE (it will be added in the method)
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static Vector<Organisation> getOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			boolean bUseHttpPrevent,
			String sFrom,
			String sAddClause,
			boolean bUseSelectDistinct) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		int[] listType = {iIdType};
		return getOrganisationsWithTypeAndRaisonSocialeLike(
				listType,
				sChaine, 
				iLimitOffset, 
				iLimit, 
				bUseHttpPrevent, 
				sFrom, 
				sAddClause, 
				bUseSelectDistinct);
	}
	
	/**
	 * 
	 * @param iIdType
	 * @param sChaine
	 * @param iLimitOffset
	 * @param iLimit
	 * @param bUseHttpPrevent
	 * @param sFrom
	 * @param sAddClause without first AND or WHERE (it will be added in the method)
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static Vector<Organisation> getOrganisationsWithTypeAndRaisonSocialeLike(
			int[] iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			boolean bUseHttpPrevent,
			String sFrom,
			String sAddClause,
			boolean bUseSelectDistinct) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		Organisation org = new Organisation();
			String sSQLQuery 
				= "SELECT " + org.getSelectFieldsName("organisation.") + ",organisation." + org.FIELD_ID_NAME
				+ " FROM " + org.TABLE_NAME + " "+sFrom;
			
		if (sChaine!=null){
			vParams.add("%"+sChaine+"%");
			sSQLQuery += " WHERE raison_sociale LIKE ?";
			
			CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
			cw.setParams(vParams);
			cw.add(iIdType);
			String sClauseType = cw.generateWhereClause("id_organisation_type",true);
			sSQLQuery += " AND "+sClauseType;
			
			if(!Outils.isNullOrBlank(sAddClause))
				sSQLQuery += " AND "+sAddClause;
			
		}else if(!Outils.isNullOrBlank(sAddClause)){
			sSQLQuery += " WHERE "+sAddClause;
		}
		
		if (iLimit>0){
			
			sSQLQuery = CoinDatabaseUtil.getSqlSelectWithLimit(
					sSQLQuery, 
					iLimitOffset, 
					iLimit, 
					"raison_sociale",
					"asc",
					bUseSelectDistinct);
		} else {
			sSQLQuery += " ORDER BY raison_sociale";
		}	
		return getAllOrganisations(sSQLQuery,bUseHttpPrevent,vParams);
	}
	
	public static int getCountOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit) throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getCountOrganisationsWithTypeAndRaisonSocialeLike(iIdType, sChaine, iLimitOffset, iLimit, "", "","");
	}
	
	/**
	 * 
	 * @param iIdType
	 * @param sChaine
	 * @param iLimitOffset
	 * @param iLimit
	 * @param sFrom
	 * @param sAddClause without first AND or WHERE (it will be added in the method)
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static int getCountOrganisationsWithTypeAndRaisonSocialeLike(
			int iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			String sFrom,
			String sAddClause,
			String sFieldCount) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		int[] listType = {iIdType};
		return getCountOrganisationsWithTypeAndRaisonSocialeLike(
				listType, 
				sChaine, 
				iLimitOffset,
				iLimit, 
				sFrom, 
				sAddClause,
				sFieldCount);
	}
	
	public static int getCountOrganisationsWithTypeAndRaisonSocialeLike(
			int[] iIdType, 
			String sChaine, 
			int iLimitOffset, 
			int iLimit,
			String sFrom,
			String sAddClause,
			String sFieldCount) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Object> vParams = new Vector<Object>(); 
		
		if(Outils.isNullOrBlank(sFieldCount))
			sFieldCount = "*";
		
		String sWhereClause = sFrom;
		if (sChaine!=null){
			vParams.add("%"+sChaine+"%");
			sWhereClause += " WHERE raison_sociale LIKE ?";
			
			CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
			cw.setParams(vParams);
			cw.add(iIdType);
			String sClauseType = cw.generateWhereClause("id_organisation_type",true);
			sWhereClause += " AND "+sClauseType;
			
			if(!Outils.isNullOrBlank(sAddClause))
				sWhereClause += " AND "+sAddClause;
		}else if(!Outils.isNullOrBlank(sAddClause)){
			sWhereClause += " WHERE "+sAddClause;
		}
		
		if (iLimit>0){
			sWhereClause += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		return (int)new Organisation().getCount(sFieldCount, sWhereClause,vParams);
	}
	
	public static Vector<Organisation> getAllOrganisations(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllOrganisations(sSQLQuery,true);
	}
	
	public static Vector<Organisation> getAllOrganisations(String sSQLQuery,Vector<Object> vParams) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllOrganisations(sSQLQuery,true,vParams);
	}
	
	public static Vector<Organisation> getAllOrganisations(String sSQLQuery, boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException  {
		return getAllWithSqlQueryStatic(sSQLQuery, bUseHttpPrevent);
	}
	
	public static Vector<Organisation> getAllOrganisations(String sSQLQuery, boolean bUseHttpPrevent,Vector<Object> vParams) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException  {
		return getAllWithSqlQueryStatic(sSQLQuery, bUseHttpPrevent, vParams);
	}
	
	public void setFromFormDonneesAdministratives(HttpServletRequest request, String sFormPrefix)
	{
		setFromFormDonneesAdministratives(request, Pays.FRANCE, sFormPrefix);
	}

	public void setFromFormDonneesAdministratives(HttpServletRequest request,String sIdPays, String sFormPrefix)
	{
		this.sRaisonSociale = HttpUtil.parseString(sFormPrefix + "sRaisonSociale", request, this.sRaisonSociale) ;
		
		if(sIdPays.equalsIgnoreCase(Pays.FRANCE)){
			if(request.getParameter(sFormPrefix + "sSiret1") != null
					&& request.getParameter(sFormPrefix + "sSiret2") != null
					&& request.getParameter(sFormPrefix + "sSiret3") != null
					&& request.getParameter(sFormPrefix + "sSiret4") != null)
				{
					this.sSiret = request.getParameter(sFormPrefix + "sSiret1");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret2");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret3");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret4");
				}
		}else{
			this.sSiret = HttpUtil.parseStringBlank("sSiret", request);
		}
		
		
		this.sTvaIntra = HttpUtil.parseString(sFormPrefix + "sTvaIntra", request, this.sTvaIntra) ;
		this.iIdCategorieJuridique = HttpUtil.parseInt(sFormPrefix + "iIdCategorieJuridique", request, this.iIdCategorieJuridique) ;
		this.iIdCodeNaf = HttpUtil.parseInt(sFormPrefix + "iIdCodeNaf", request, this.iIdCodeNaf) ;

		
		if(request.getParameter(sFormPrefix + "iIdCompetenceNewSelection") != null)
		{
			try{
				int[] listeCompetences = Outils.parserChaineVersEntier(sFormPrefix + request.getParameter("iIdCompetenceNewSelection"),"|");
				if (listeCompetences != null)
				{ 
					for(int iCompetence: listeCompetences){
			    		try{
			    			Vector<BoampCPFItem> vItem = BoampCPFItem
			    				.getAllFromCPFAndReferenceAndTypeObjet(
			    						iCompetence, 
			    						this.lId, 
			    						ObjectType.ORGANISATION);
			    			
			    			if(vItem == null || (vItem!=null && vItem.isEmpty()))
			    				throw new Exception("cpf org inexistant");
			    			
			    		}catch(Exception e){
			    			BoampCPFItem cpf = new BoampCPFItem();
			    			cpf.setIdOwnedObjet(iCompetence);
			    			cpf.setIdOwnerReferenceObject(this.lId);
			    			cpf.setIdOwnerTypeObject(ObjectType.ORGANISATION);
			    			cpf.create();
			    		}
					}
			    	
			    	Vector<BoampCPFItem> vItem 
			    		= BoampCPFItem.getAllFromTypeAndReferenceObjet(ObjectType.ORGANISATION, this.lId);
			    	
			    	for(BoampCPFItem cpf: vItem){
			    		boolean bFind = false;
			    		for(int iCompetence: listeCompetences){
			    			if(cpf.getIdOwnedObject() == iCompetence){
			    				bFind = true;
			    			}
			    		}
			    		if(!bFind)
			    			cpf.remove();
			    	}
				}
			}catch(Exception e){}
		}
		
		this.iIdTypeAcheteurPublic = HttpUtil.parseInt(sFormPrefix + "iIdTypeAcheteurPublic", request, this.iIdTypeAcheteurPublic) ;
		this.iIdOrganisationType = HttpUtil.parseInt(sFormPrefix + "iIdOrganisationType", request, this.iIdOrganisationType) ;
		this.sCommentaire = HttpUtil.parseString(sFormPrefix + "sCommentaire", request, this.sCommentaire) ;
		this.iIdOrganisationModelePDF = HttpUtil.parseInt(sFormPrefix + "iIdOrganisationModelePDF", request, 1) ;
	}	

	public void setFromFormCoordonnees(HttpServletRequest request, String sFormPrefix)
	{
		this.sMailOrganisation = HttpUtil.parseString(sFormPrefix + "sMailOrganisation", request, this.sMailOrganisation) ;
		this.sTelephone = HttpUtil.parseString(sFormPrefix + "sTelephone", request, this.sTelephone) ;
		this.sFax = HttpUtil.parseString(sFormPrefix + "sFax", request, this.sFax) ;
		this.sSiteWeb = HttpUtil.parseString(sFormPrefix + "sSiteWeb", request, this.sSiteWeb) ;
		this.sReferenceExterne = HttpUtil.parseString(sFormPrefix + "sReferenceExterne", request, this.sReferenceExterne) ;
		this.sReferenceExterneAP = HttpUtil.parseString(sFormPrefix + "sReferenceExterneAP", request, this.sReferenceExterneAP) ;
		this.lIdObjectTypeOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectTypeOwner", request, this.lIdObjectTypeOwner) ;
		this.lIdObjectReferenceOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectReferenceOwner", request, this.lIdObjectReferenceOwner) ;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException
	{
		setFromForm(request, Pays.FRANCE, sFormPrefix);
	}
	
	public void setFromForm(HttpServletRequest request, String sIdPays, String sFormPrefix) throws SQLException, NamingException
	{
		setFromFormDonneesAdministratives(request, sFormPrefix);
		setFromFormCoordonnees(request, sFormPrefix);
	}
	
	public void setFromFormInscription(HttpServletRequest request, String sFormPrefix)
	{
		this.sRaisonSociale = HttpUtil.parseString(sFormPrefix + "sRaisonSociale", request, this.sRaisonSociale) ;
		this.iIdTypeAcheteurPublic = HttpUtil.parseInt(sFormPrefix + "iIdTypeAcheteurPublic", request, this.iIdTypeAcheteurPublic) ;
		this.iIdOrganisationType = HttpUtil.parseInt(sFormPrefix + "iIdOrganisationType", request, this.iIdOrganisationType) ;
		this.lIdObjectTypeOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectTypeOwner", request, this.lIdObjectTypeOwner) ;
		this.lIdObjectReferenceOwner = HttpUtil.parseLong(sFormPrefix + "lIdObjectReferenceOwner", request, this.lIdObjectReferenceOwner) ;
		this.iIdCodeNaf = HttpUtil.parseInt(sFormPrefix + "iIdCodeNaf", request, this.iIdCodeNaf);
	}	
	
	public void setFromFormUpdateBoampInfo(HttpServletRequest request, String sFormPrefix) {
		
		String sIdPays = Pays.FRANCE;
        try{
            Adresse adresse = Adresse.getAdresse(this.getIdAdresse(), true);
            sIdPays = adresse.getIdPays();
        }catch(Exception e){sIdPays = Pays.FRANCE;}
        if(Outils.isNullOrBlank(sIdPays)) sIdPays = Pays.FRANCE;
		
		setFromFormUpdateBoampInfo(request, sIdPays, sFormPrefix);
	}
	
	public void setFromFormUpdateBoampInfo(HttpServletRequest request, String sIdPays, String sFormPrefix) {
		
		if(sIdPays.equalsIgnoreCase(Pays.FRANCE)){
			if(request.getParameter(sFormPrefix + "sSiret1") != null
					&& request.getParameter(sFormPrefix + "sSiret2") != null
					&& request.getParameter(sFormPrefix + "sSiret3") != null
					&& request.getParameter(sFormPrefix + "sSiret4") != null)
				{
					this.sSiret = request.getParameter(sFormPrefix + "sSiret1");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret2");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret3");
					this.sSiret += request.getParameter(sFormPrefix + "sSiret4");
				}
		}else{
			this.sSiret = HttpUtil.parseStringBlank("sSiret", request);
		}
		
		this.iIdOrganisationClasseProfit = HttpUtil.parseInt(sFormPrefix + "iIdOrganisationClasseProfit", request, this.iIdOrganisationClasseProfit);
	}
	
	public void setCompetence(HttpServletRequest request, String sFormPrefix) {
		if(request.getParameter(sFormPrefix + "iIdCompetenceNewSelection") != null)
		{
			try{
				int[] listeCompetences = Outils.parserChaineVersEntier(request.getParameter(sFormPrefix + "iIdCompetenceNewSelection"),"|");
				if (listeCompetences != null)
				{ 
					for(int iCompetence: listeCompetences){
			    		try{
			    			Vector<BoampCPFItem> vItem = BoampCPFItem
			    				.getAllFromCPFAndReferenceAndTypeObjet(
			    						iCompetence, 
			    						this.lId, 
			    						ObjectType.ORGANISATION);
			    			
			    			if(vItem == null || (vItem!=null && vItem.isEmpty()))
			    				throw new Exception("cpf org inexistant");
			    			
			    		}catch(Exception e){
			    			BoampCPFItem cpf = new BoampCPFItem();
			    			cpf.setIdOwnedObjet(iCompetence);
			    			cpf.setIdOwnerReferenceObject(this.lId);
			    			cpf.setIdOwnerTypeObject(ObjectType.ORGANISATION);
			    			cpf.create();
			    		}
					}
			    	
			    	Vector<BoampCPFItem> vItem 
			    		= BoampCPFItem.getAllFromTypeAndReferenceObjet(ObjectType.ORGANISATION, this.lId);
			    	
			    	for(BoampCPFItem cpf: vItem){
			    		boolean bFind = false;
			    		for(int iCompetence: listeCompetences){
			    			if(cpf.getIdOwnedObject() == iCompetence){
			    				bFind = true;
			    			}
			    		}
			    		if(!bFind){
			    			cpf.remove();
			    		}			    			
			    	}
				}
			}catch(Exception e){e.printStackTrace();}
		}
	}
	
	public static String getParamValue(
			ParamPart param,
			String sParamName,
			String sDefaultValue)
	{
		if (param.getName().equals(sParamName)){
			try{
				return param.getStringValue();
			}
			catch(UnsupportedEncodingException e){
				e.printStackTrace();
			}
		}
		
		return sDefaultValue;
	}	

	public static int getParamInt(
			ParamPart param,
			String sParamName,
			int iDefaultValue)
	{
		try{
			return Integer.parseInt(getParamValue(param, sParamName, "" + iDefaultValue));
		} catch (NumberFormatException e) {}
		
		return iDefaultValue;
	}
	
	public void setFromFormMultiPart(HttpServletRequest request, String sFormPrefix)
	{
		setFromFormMultiPart(request, Pays.FRANCE, sFormPrefix);
	}
	public void setFromFormMultiPart(HttpServletRequest request, String sIdPays, String sFormPrefix)
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
			/* Traitement de l'upload du fichier */
			if (part.isFile())
			{
				FilePart file = (FilePart)part;
				
				if (file.getName().equals("filePath"))
				{
				}
			}
			
			if (part.isParam())
			{
				ParamPart param = (ParamPart)part;

				this.sRaisonSociale = getParamValue(param, sFormPrefix + "sRaisonSociale", this.sRaisonSociale);
				if(sIdPays.equalsIgnoreCase(Pays.FRANCE)){
					this.sSiret = getParamValue(param, sFormPrefix + "sSiret1", this.sSiret);
					this.sSiret += getParamValue(param, sFormPrefix + "sSiret2", this.sSiret);
					this.sSiret += getParamValue(param, sFormPrefix + "sSiret3", this.sSiret);
					this.sSiret += getParamValue(param, sFormPrefix + "sSiret4", this.sSiret);
				}else{
					this.sSiret = getParamValue(param, sFormPrefix + "sSiret", this.sSiret);
				}
				
				this.sTvaIntra = getParamValue(param, sFormPrefix + "sTvaIntra", this.sTvaIntra);
				this.iIdCategorieJuridique = getParamInt(param, sFormPrefix + "iIdCategorieJuridique", this.iIdCategorieJuridique);
				this.iIdCodeNaf = getParamInt(param, sFormPrefix + "iIdCodeNaf", this.iIdCodeNaf);
				this.sMailOrganisation = getParamValue(param, sFormPrefix + "sMailOrganisation", this.sMailOrganisation);
				this.sTelephone = getParamValue(param, sFormPrefix + "sTelephone", this.sTelephone);
				this.sFax = getParamValue(param, sFormPrefix + "sFax", this.sFax);
				this.sSiteWeb = getParamValue(param, sFormPrefix + "sSiteWeb", this.sSiteWeb);
				this.iIdOrganisationType = getParamInt(param, sFormPrefix + "iIdOrganisationType", this.iIdOrganisationType);
				this.iIdOrganisationModelePDF = getParamInt(param, sFormPrefix + "iIdOrganisationModelePDF", this.iIdOrganisationModelePDF);
				this.sCommentaire = getParamValue(param, sFormPrefix + "sCommentaire", this.sCommentaire);
				this.iIdTypeAcheteurPublic = getParamInt(param, sFormPrefix + "iIdTypeAcheteurPublic", this.iIdTypeAcheteurPublic);
			}

			try {
				part = mp.readNextPart();
			}
			catch(IOException e){
				
			}
		}
	}
	
	public void setNomLogo(String sLogo) {
		this.sLogo = sLogo;
	}
	public void setLogo(File f) 
	{
		try 
		{
			FileInputStream isFile = new FileInputStream(f);
			setLogo(isFile);
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	public void setLogo(InputStream is) {
		this.isLogo = is;
	}
	public void setReferenceExterne(String sReferenceExterne){
		this.sReferenceExterne = sReferenceExterne;
	}
	
	public void storeLogo() throws SQLException, NamingException {
		String sSqlQuery = "UPDATE " + this.TABLE_NAME+ " SET "
		+ " logo=? "
		+ " WHERE " + this.FIELD_ID_NAME + "='" 
		+ this.getIdOrganisation()+ "'";
		
		
		ConnectionManager.uploadInputStream(sSqlQuery, this.isLogo);

	}
	
	public boolean isCoupDeCoeur(){
		boolean bIsCoupDeCoeur= false;
		Vector<org.coin.fr.bean.CoupCoeur> vCoupDeCoeur = null;
		try{
			vCoupDeCoeur = org.coin.fr.bean.CoupCoeur.getAllCoupCoeurFromOrganisation((int)this.lId);
		}
		catch(Exception e){}
		if (vCoupDeCoeur.size()>0) bIsCoupDeCoeur=true;
		return bIsCoupDeCoeur;
	}
	
	public boolean isClientSPQR() {
		boolean isClientSPQR = false;
		try{
		if (OrganisationParametre.getOrganisationParametreValueOptional(getIdOrganisation(),"isClientSPQR").equalsIgnoreCase("true"))
			isClientSPQR = true;
		}catch(Exception e){}
		return isClientSPQR;
	}
	
	public boolean isClientBOAMP() {
		boolean isClientBOAMP = false;
		try{
		if (OrganisationParametre.getOrganisationParametreValueOptional(getIdOrganisation(),"isClientBOAMP").equalsIgnoreCase("true"))
			isClientBOAMP = true;
		}catch(Exception e){}
		return isClientBOAMP;
	}
	
	/**
	 * Renvoi la liste des Organisations pour lesquelles au moins un Export est paramétré
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws CoinDatabaseLoadException
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static Vector<Organisation> getAllOrganisationPublication()
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllOrganisationPublication(null);
	}
	
	public static Vector<Organisation> getAllOrganisationPublication(Connection conn)
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();
		String sSQLQuery = item.getAllSelectDistinct("org.")
						 + ", coin_export export"
						 + " WHERE export.id_objet_reference_source = org.id_organisation"
						 + " AND export.id_type_objet_source = " + ObjectType.ORGANISATION
						 + " AND export.id_objet_reference_destination = org.id_organisation"
						 + " AND export.id_type_objet_destination = " + ObjectType.ORGANISATION
						 + " AND org.id_organisation_type = " + OrganisationType.TYPE_PUBLICATION;
		if(conn != null)
			return getAllWithSqlQueryStatic(sSQLQuery,true,conn);
		else
			return getAllWithSqlQueryStatic(sSQLQuery,true);
	}
	
	public static Vector<Organisation> getAllOrganisationFromTypeAndCountry(int iIdOrganisationType, String sIdPays)
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();
		String sSQLQuery = item.getAllSelect("org.")
						 + ", adresse adr"
						 + " WHERE org.id_organisation_type="+iIdOrganisationType
						 + " AND org.id_adresse = adr.id_adresse"
						 + " AND adr.id_pays = '"+sIdPays+"'";
		return getAllWithSqlQueryStatic(sSQLQuery);
	}

	public static Vector<Organisation> getAllOrganisationPublicationFromOrganisationParametreAndValue(
			String sParametre,
			String sValue)
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllOrganisationPublicationFromOrganisationParametreAndValue(sParametre,sValue,null);
	}
	public static Vector<Organisation> getAllOrganisationPublicationFromOrganisationParametreAndValue(
			String sParametre, 
			String sValue,
			Connection conn)
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();
		String sSQLQuery = item.getAllSelectDistinct("org.")
						 + ", organisation_parametre param, coin_export export"
						 + " WHERE org.id_organisation = param.id_organisation"
						 + " AND export.id_objet_reference_source = org.id_organisation"
						 + " AND export.id_type_objet_source = " + ObjectType.ORGANISATION
						 + " AND export.id_objet_reference_destination = org.id_organisation"
						 + " AND export.id_type_objet_destination = " + ObjectType.ORGANISATION
						 + " AND org.id_organisation_type = " + OrganisationType.TYPE_PUBLICATION
						 + " AND param.name='"+sParametre+"'"
						 + " AND param.value='"+sValue+"'";
		
		if(conn != null)
			return getAllWithSqlQueryStatic(sSQLQuery,true,conn);
		else
			return getAllWithSqlQueryStatic(sSQLQuery,true);
	}
	
	public String getName() {
		return getRaisonSociale();
	}

	public static Vector<Organisation> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithSqlQueryStatic(sSQLQuery, true);
	}
	
	public static Vector<Organisation> getAllWithSqlQueryStatic(String sSQLQuery, boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(bUseHttpPrevent); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<Organisation> getAllWithSqlQueryStatic(String sSQLQuery, boolean bUseHttpPrevent,Vector<Object> vParams) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(bUseHttpPrevent); 
		return getAllWithSqlQuery(sSQLQuery, vParams,item);
	}
	
	public static Vector<Organisation> getAllWithSqlQueryStatic(String sSQLQuery, boolean bUseHttpPrevent,Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(bUseHttpPrevent); 
		return getAllWithSqlQuery(sSQLQuery, item,conn);
	}
	
	public static Vector<Organisation> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause, boolean bUseHttpPrevent) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	public static Vector<Organisation> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) 
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	
	public static Vector<Organisation> getAllWithWhereAndOrderByClauseStatic(
			String sWhereClause, 
			String sOrderByClause,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Organisation item = new Organisation(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}

	public static Vector<Organisation> getAllWithAllPersonne(
			Vector<PersonnePhysique> vPersonnePhysique) throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		CoinDatabaseWhereClause wcOrganization = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		for (int i=0;i<vPersonnePhysique.size();i++){
			PersonnePhysique pp = vPersonnePhysique.get(i);
			wcOrganization.add(pp.getIdOrganisation());
		}
		
		Organisation organisation = new Organisation();	
		organisation.bUseHttpPrevent = false;
		return organisation.getAllWithWhereAndOrderByClause(
				" WHERE " + wcOrganization.generateWhereClause("id_organisation"), "");
		
	}
	
	public static Vector<Adresse> getAllAdresseWithAllOrganisation(
			Vector<Organisation> vOrganisation) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		CoinDatabaseWhereClause wcAddress = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		for (int i=0;i<vOrganisation.size();i++){
			Organisation orga = vOrganisation.get(i);
			wcAddress.add(orga .getIdAdresse());
		}
		
		Adresse adresse = new Adresse();	
		adresse.bUseHttpPrevent = false;
		return adresse.getAllWithWhereAndOrderByClause(
				" WHERE " + wcAddress.generateWhereClause("id_adresse"), "");
		
	}
	
	public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		return this.toJSONObject(true);
	}
	

	public JSONObject toJSONObject(
			boolean bAddDependObject) 
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException {
		return toJSONObject(bAddDependObject, null);
	}
	
	public JSONObject toJSONObject(
			boolean bAddDependObject,
			Vector<Adresse> vAdresse) 
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException {
		return toJSONObject(bAddDependObject, vAdresse, false, null,null);
	}
	
	public JSONObject toJSONObject(
			boolean bAddDependObject,
			Vector<Adresse> vAdresse,
			boolean bAddOrganigram,
			Vector<TreeviewNode> vItemList,
			Vector<OrganisationGroupItem> vGroupItem) 
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("tsDateCreation", this.tsDateCreation);
		item.put("tsDateModification", this.tsDateModification);
		item.put("sRaisonSociale", this.sRaisonSociale);
		
		item.put("data", this.lId);
		item.put("value", this.sRaisonSociale);

		if(bAddDependObject){
			Adresse adr = new Adresse();
			adr.setAbstractBeanConnexion(this);
			try{
				if(vAdresse != null)
				{
					adr = Adresse.getAdresse(this.iIdAdresse, vAdresse);
				} else {
					adr.setId(this.iIdAdresse);
					adr.load();
				}
			}catch(Exception e){
				adr = new Adresse();
			}
			adr.setAbstractBeanConnexion(this);
			adr.setAbstractBeanLocalization(this);
			item.put("adresse",adr.toJSONObject());
			
			if(bAddOrganigram){
				JSONObject jsonGroup = new JSONObject();
				Vector<OrganisationGroup> vTree = null;
				
				Connection conn = this.getConnection();
				try{
					if(vItemList!=null && vGroupItem != null){
						vTree = OrganisationGroup.getOrganisationGroupTreeNode(this.getId(),vItemList, vGroupItem, conn);
					}else{
						vTree = OrganisationGroup.getOrganisationGroupTreeNode(this.getId(),conn);
					}
				}catch(CoinDatabaseLoadException e){}
				finally{this.releaseConnection(conn);}
				
				if(vTree != null){
					JSONArray jsonTree = new JSONArray();
					String sExternalReference = "";
					for(OrganisationGroup node : vTree){
						jsonTree.put(node.toJSONObject());
						if(!Outils.isNullOrBlank(node.sExternalReference)){
							sExternalReference += (Outils.isNullOrBlank(sExternalReference)?"":"_")+node.sExternalReference;
						}
					}
					jsonGroup.put("tree", jsonTree);
					jsonGroup.put("sExternalReference", sExternalReference);
					item.put("group",jsonGroup);
				}

			}
		}

		return item;
	}

	public static JSONObject getJSONObject(long lId) 
	throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, 
	InstantiationException, IllegalAccessException {
		Organisation item = getOrganisation(lId, false);
		JSONObject data = item.toJSONObject();
		return data;
	}
	
	@RemoteMethod
	public static String getJSONObjectString(long lId) 
	throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, 
	InstantiationException, IllegalAccessException {
		return getJSONObject(lId).toString() ;
	}
	
	
	public String getRaisonSocialeLabel() {
		return getLocalizedLabel("sRaisonSociale");
	}
	

	public String getSiretLabel() {
		return getLocalizedLabel("sSiret");
	}

	public String getTvaIntraLabel() {
		return getLocalizedLabel("sTvaIntra");
	}
	
	public String getIdCategorieJuridiqueLabel() {
		return getLocalizedLabel("iIdCategorieJuridique");
	}

	public String getIdCodeNafLabel() {
		return getLocalizedLabel("iIdCodeNaf");
	}
	
	public String getIdOrganisationTypeLabel() {
		return getLocalizedLabel("iIdOrganisationType");
	}
	
	public String getIdTypeAcheteurPublicLabel() {
		return getLocalizedLabel("iIdTypeAcheteurPublic");
	}
	
	public String getIdOrganisationModelePDFLabel() {
		return getLocalizedLabel("iIdOrganisationModelePDF");
	}
	
	public String getMailOrganisationLabel() {
		return getLocalizedLabel("sMailOrganisation");
	}
	
	public String getTelephoneLabel() {
		return getLocalizedLabel("sTelephone");
	}
	
	public String getFaxLabel() {
		return getLocalizedLabel("sFax");
	}
		
	public String getSiteWebLabel() {
		return getLocalizedLabel("sSiteWeb");
	}
	
	public String getIdCreateurLabel (){
		return getLocalizedLabel ("iIdCreateur");
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
    
    public static void removeCreator(
    		long lIdCreator,
    		Connection conn)
    throws SQLException, NamingException{
    	Organisation item = new Organisation();
    	
    	/** on réinitialise */
    	String sSQLUpdate = "UPDATE " + item.TABLE_NAME
		+ " SET "+item.TABLE_NAME+".id_createur=0"+
        " WHERE "+item.TABLE_NAME+".id_createur="+lIdCreator;
    	
    	ConnectionManager.executeUpdate(sSQLUpdate, conn);
    }
    
    public static Vector<Organisation> getAllWithWhereClause(String sWhereClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
    	Organisation item = new Organisation();		
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "");
	}
	
	public static Vector<Organisation> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();		
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
	public static Vector<Organisation> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		return getAllWithWhereClause(sWhereClause, vParams, item);
	}
	
	public static Vector<Organisation> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		return getAllWithWhereClause(sWhereClause, vParams, item);
	}
	
	public static Vector<Organisation> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Organisation item) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
	public static Vector<Organisation> getAllByOwner(
			long lIdObjectTypeOwner,
			long lIdObjectReferenceOwner,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Organisation item = new Organisation();
		return getAllByOwner(item, lIdObjectTypeOwner, lIdObjectReferenceOwner, conn);
	}
	
	
	public static <T>Vector<T> getAllByOwner(
			CoinDatabaseAbstractBean item,
			long lIdObjectTypeOwner,
			long lIdObjectReferenceOwner,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		item.bUseHttpPrevent = false;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		
		Vector<Object> vParams = new Vector<Object>();
		vParams.add(new Long(lIdObjectTypeOwner)); 
		vParams.add(new Long(lIdObjectReferenceOwner)); 
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_object_type_owner=?"
				+ " AND id_object_reference_owner=?", 
				"", 
				vParams);
	}
	
	/** Organigram node order **/
	protected static final Map <String, Integer> organigramNodeOrder = new HashMap <String, Integer> ();
	static {
		organigramNodeOrder.put (OrganisationParametre.PARAM_VALUE_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_ALPHABETIC, ORGANIGRAM_NODE_ORDER_ALPHABETIC);
		organigramNodeOrder.put (OrganisationParametre.PARAM_VALUE_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_HIERARCHIC, ORGANIGRAM_NODE_ORDER_HIERARCHIC);
	}
	
	public int getOrganigramNodeOrder ()
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		try {
			Integer value = organigramNodeOrder.get (OrganisationParametre.getOrganisationParametreValue (
					lId, OrganisationParametre.PARAM_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_BY));
			return value == null ? ORGANIGRAM_NODE_ORDER_HIERARCHIC : value;
		} catch (Exception e){
			return ORGANIGRAM_NODE_ORDER_HIERARCHIC;
		}
	}

	/** Ordering services **/
	public Collection <OrganisationService> orderServices (
			Collection <OrganisationService> services)
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, SQLException, InstantiationException,
	IllegalAccessException, NamingException
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return orderServices(services, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	/** Ordering services **/
	public Collection <OrganisationService> orderServices (
			Collection <OrganisationService> services,
			Connection conn)
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, SQLException, InstantiationException,
	IllegalAccessException, NamingException
	{
		switch (getOrganigramNodeOrder ()){
			case ORGANIGRAM_NODE_ORDER_ALPHABETIC:
				return OrganisationService.getOrganisationServicesOrderedAlphabetically (services);
			
			case ORGANIGRAM_NODE_ORDER_HIERARCHIC:
			default:
				return OrganisationService.getOrganisationServicesOrderedHierarchically (services, conn);
		}
	}
	
	/** Ordering nodes **/
	public Vector <OrganigramNode> orderNodes (Collection <OrganigramNode> nodes)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		switch (getOrganigramNodeOrder ()){
			case ORGANIGRAM_NODE_ORDER_ALPHABETIC:
				return OrganigramNode.orderNodesAlphabetic(nodes);
			
			case ORGANIGRAM_NODE_ORDER_HIERARCHIC:
			default:
				return OrganigramNode.orderNodesHierarchic(nodes);
		}
	}
	
	public static Vector <Organisation> getAllOrganisationsWithOrganigram(Connection conn)
	throws	NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Organisation organisation = new Organisation();
		Vector <Organisation> vOrganisationOrderAlphabetic = organisation.getAllWithWhereAndOrderByClause("","ORDER BY raison_sociale" );
		Vector <Organisation> vOrganisationWithOrganigram = new Vector <Organisation>();
		for (Organisation org : vOrganisationOrderAlphabetic) {
			Vector<Organigram> vOrganisationOrganigramInterService
				= Organigram.getAllFromObject(
					ObjectType.ORGANISATION,
					org.getId(),
					ObjectType.ORGANISATION_SERVICE,
					false,
					conn);
			if (vOrganisationOrganigramInterService.size()>0){
				vOrganisationWithOrganigram.add(org);
			}
		}
	return vOrganisationWithOrganigram;
	}
}
