/****************************************************************************
Studio Matamore - France 2005
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.servlet;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.sql.Connection;
import java.sql.SQLException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import modula.candidature.Candidature;
import modula.candidature.EnveloppeAPieceJointe;
import modula.candidature.EnveloppeBPieceJointe;
import modula.candidature.EnveloppeCPieceJointe;
import modula.candidature.EnveloppePieceJointe;
import modula.marche.AncienAvis;
import modula.marche.AvisAttribution;
import modula.marche.AvisRectificatif;
import modula.marche.Marche;
import modula.marche.MarchePieceJointe;
import modula.servlet.DownloadPieceMarche;

import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.bean.document.Document;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.InputStreamDownloader;
import org.coin.fr.bean.Multimedia;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.security.CertificateUtil;
import org.coin.security.HabilitationException;
import org.coin.security.Quarantaine;
import org.coin.security.SecureString;
import org.coin.util.HttpUtil;
import org.coin.util.image.conversion.ImageConversionUtil;

import com.xucia.resourceaccelerate.CacheHeadersFilter;


/**
 * Servlet permettant le telechargement d'un fichier de facon générique
 * @author julien
 *
 */
public class DownloadFile extends HttpServlet 
{
	private static final long serialVersionUID = 1L;

	protected void doGet(
		HttpServletRequest request,
		HttpServletResponse response) {
		
		int iId = Integer.parseInt(request.getParameter("iId"));
		String sName = request.getParameter("sName");
		int iIdTypeObjet = Integer.parseInt(request.getParameter("iIdTypeObjet"));

		
		String sDisposition = HttpUtil.parseString("sContentDisposition", request, "attachement" ) + ";";
		try{
			String sAction = request.getParameter("sAction");
			if(sAction.equalsIgnoreCase("view"))
				sDisposition = " ; ";
		}catch(Exception e){}
		
		String sContentType = "application/x-download";
		try{
			String sContentTypeParam = request.getParameter("sContentType");
			if(sContentTypeParam != null || !sContentTypeParam.equalsIgnoreCase(""))
				sContentType = sContentTypeParam;
		}catch(Exception e){}
		
		String sContentLength = "";
		try{
			String sContentLengthParam = request.getParameter("sContentLength");
			if(sContentLengthParam != null || !sContentLengthParam.equalsIgnoreCase(""))
				sContentLength = sContentLengthParam;
		}catch(Exception e){}
		
		try {
			getFile(request,response,iId,sName,iIdTypeObjet,sDisposition,sContentType,sContentLength);
		} catch (Exception e) {
			e.printStackTrace();
			try {
				OutputStream out = response.getOutputStream();
				out.write(e.getMessage().getBytes());
				out.flush();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			
		}
	}

	/**
	 * TODO : à faire
	 * @param request
	 * @param iId
	 * @param iIdTypeObjet
	 * @throws CoinDatabaseLoadException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static void checkHabilitation(
			HttpServletRequest request,
			int iId, 
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException
	{
/*		Connection conn = null;
		try {
			
			HttpServletRequest hsrRequest = (HttpServletRequest)request;
			HttpSession hsSession = hsrRequest.getSession();
			//User user = (User) hsSession.getAttribute("sessionUser");
			UserHabilitation userHabilitation = (UserHabilitation) hsSession.getAttribute("sessionUserHabilitation");
			
			if(userHabilitation.isSuperUser())
				return ;
			
			conn = ConnectionManager.getConnection();
			PersonnePhysique userPersonnePhysique = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);
			Organisation userOrganisation = Organisation.getOrganisation(userPersonnePhysique.getIdOrganisation(), conn);
			
			
			switch(iIdTypeObjet)
			{
			case ObjectType.ENVELOPPE_A:
				EnveloppeAPieceJointe envpjA = EnveloppeAPieceJointe.getEnveloppeAPieceJointe(iId,false);
				EnveloppeA enveloppeA = EnveloppeA.getEnveloppeA(envpjA.getIdEnveloppe());
				//Candidature candidature = Candidature.getCandidature( enveloppeA.getIdCandidature());   
				
				break;
	
			case ObjectType.ENVELOPPE_B:
				break;
	
			case ObjectType.ENVELOPPE_C:
				break;	
			}		
		} finally {
			ConnectionManager.closeConnection(conn);
		}		
	*/
	}

	public static String getSecureTransactionStringFullJspPage(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, 
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException 
	{
		return getSecureTransactionStringFullJspPage(request, iId, iIdTypeObjet, true);
	}
	public static String getSecureTransactionStringFullJspPage(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet,
			boolean bCurrentTimeMillis) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, 
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, 
	InvalidAlgorithmParameterException
	{
		return  getSecureTransactionStringFull(
				request,
				iId,
				iIdTypeObjet,
				"&amp;",
				bCurrentTimeMillis);

	}

	public static String getSecureTransactionStringFull(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet,
			String sDelimiter)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException,
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		return getSecureTransactionStringFull(request, iId, iIdTypeObjet, sDelimiter, true);
	}
	
	public static String getSecureTransactionStringFull(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet,
			String sDelimiter,
			boolean bCurrentTimeMillis)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException,
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, 
	InvalidAlgorithmParameterException 
	{
		return "iId=" + iId 
			+ sDelimiter + "iIdTypeObjet=" + iIdTypeObjet
			+ sDelimiter + getSecureTransactionString(request, iId, iIdTypeObjet, bCurrentTimeMillis);
	}

	public static String getSecureTransactionString(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException,
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, 
	InvalidAlgorithmParameterException 
	{
		return getSecureTransactionString(request, iId, iIdTypeObjet, true);
	}
	public static String getSecureTransactionString(
			HttpServletRequest request,
			long iId,
			long iIdTypeObjet,
			boolean bCurrentTimeMillis) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, 
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, 
	InvalidAlgorithmParameterException
	{
		HttpServletRequest hsrRequest = (HttpServletRequest)request;
		HttpSession session = hsrRequest.getSession();
		String sSTS = "" + (bCurrentTimeMillis?System.currentTimeMillis():0 )+ ";" + iId + ";" + iIdTypeObjet; 
		return "sts=" + SecureString.getSessionSecureString(sSTS, session );
	}
	
	public static void getFile(
			HttpServletRequest request,
			HttpServletResponse response,
			int iId,
			String sName, 
			int iIdTypeObjet) 
	throws HabilitationException, NamingException, SQLException
	{
		getFile(request,response,iId,sName,iIdTypeObjet,"attachement;","application/x-download","");
	}
	
	public static void getFile(
			HttpServletRequest request,
			HttpServletResponse response,
			int iId,
			String sName, 
			int iIdTypeObjet, 
			String sDisposition, 
			String sContentType, 
			String sContentLength)
	throws HabilitationException, NamingException, SQLException
	{
		HttpServletRequest hsrRequest = (HttpServletRequest)request;
		HttpSession session = hsrRequest.getSession();
		String sSecureTransactionString = request.getParameter("sts");
		/**
		 * la chaine contient : timestamp en ms + id + idTypeObjet
		 */
		int iEvaluedId = -1;
		int iEvaluedIdTypeObjet = -1;
		if(sSecureTransactionString != null)
		{
			
			try {
				String sarr[] = SecureString.getSessionPlainString(sSecureTransactionString, session).split(";");
				Long.parseLong(sarr[0]);
				iEvaluedId = Integer.parseInt(sarr[1]);
				iEvaluedIdTypeObjet = Integer.parseInt(sarr[2]);
			} catch (Exception e) {
				e.printStackTrace();
				throw new HabilitationException("not allowed");
			}
			
			if(iEvaluedId != iId || iEvaluedIdTypeObjet != iIdTypeObjet) {
				throw new HabilitationException("not allowed");
			}
			
		}
		else throw new HabilitationException("not allowed");
		
		Connection conn  = ConnectionManager.getConnection();
		InputStream in = null;
		InputStreamDownloader inputStreamDownloader = null;
		
		try
		{
			switch(iIdTypeObjet)
			{
				case ObjectType.DOCUMENT:
					in = Document.getFile(iId);
					sName = Document.getDocument(iId,false).getFileName();
					break;
					
				case ObjectType.MARCHE_PIECE_JOINTE:
					in = MarchePieceJointe.getPieceJointe(iId);
					sName = MarchePieceJointe.getMarchePieceJointe(iId,false).getNomPieceJointe();
					break;
					
				case ObjectType.AAPC:
					Marche marche = Marche.getMarche(iId,conn,false);
					in = Marche.getAAPC(iId);
					sName = marche.getNomAAPC();
					
					String sSimulateDCE = HttpUtil.parseStringBlank("dce", request);
					if(sSimulateDCE.equalsIgnoreCase("1")){
						User sessionUser = (User)session.getAttribute("sessionUser");
						Candidature oCandidature;
						try {
							oCandidature = Candidature.getCandidature(iId,sessionUser.getIdIndividual());
							if(oCandidature == null){
								throw new Exception("nouvelle candidature");
							}
						} catch (Exception e3) {
							PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
							oCandidature = new Candidature();
							oCandidature.setIdMarche(iId);
							oCandidature.setIdOrganisation(candidat.getIdOrganisation());
							oCandidature.setIdPersonnePhysique((int)candidat.getId());
							oCandidature.create(conn);
						}
						marche.setDCEDisponible(true);
						DownloadPieceMarche.updateMarcheStatut(hsrRequest, response, marche, null, conn);
					} 
					
					if(Boolean.valueOf(request.getParameter("bHorsIdentification"))) {
						DownloadPieceMarche.updateMarcheStatut(hsrRequest, response, marche, null, conn);
						marche.store();						
					}
					break;
					
				case ObjectType.AATR:
					in = AvisAttribution.getAATRFromIdAatr(iId);
					sName = AvisAttribution.getAvisAttribution(iId,false).getNomAATR();
					break;	
					
				case ObjectType.ENVELOPPE_A:
					EnveloppeAPieceJointe envpjA = EnveloppeAPieceJointe.getEnveloppeAPieceJointe(iId,false);
					sName = envpjA.getNomPieceJointe();
					sContentLength = Integer.toString(Math.round(envpjA.getTailleFichier()));
					if(envpjA.getChiffrage() == 0)
					{
						in = EnveloppeAPieceJointe.getPieceJointeClair(iId);
					} else {
						in = EnveloppeAPieceJointe.getPieceJointe(iId);
					}
					break;
					
				case ObjectType.ENVELOPPE_B:
					EnveloppeBPieceJointe envpjB = EnveloppeBPieceJointe.getEnveloppeBPieceJointe(iId,false);
					sName = envpjB.getNomPieceJointe();
					sContentLength = Integer.toString(Math.round(envpjB.getTailleFichier()));
					if(envpjB.getChiffrage() == 0)
					{
						in = EnveloppeBPieceJointe.getPieceJointeClair(iId);
					} else {
						in = EnveloppeBPieceJointe.getPieceJointe(iId);
					}
					break;
					
				case ObjectType.ENVELOPPE_C:
					EnveloppeCPieceJointe envpjC = EnveloppeCPieceJointe.getEnveloppeCPieceJointe(iId,false);
					sName = envpjC.getNomPieceJointe();
					in = EnveloppeCPieceJointe.getPieceJointe(iId);
					sContentLength = Integer.toString(Math.round(envpjC.getTailleFichier()));
					if(envpjC.getChiffrage() == 0)
					{
						in = EnveloppeCPieceJointe.getPieceJointeClair(iId);
					} else {
						in = EnveloppeCPieceJointe.getPieceJointe(iId);
					}
					break;
					
				case ObjectType.ENVELOPPE_A_PJ_CERT:
					EnveloppeAPieceJointe envAPJ = EnveloppeAPieceJointe.getEnveloppeAPieceJointe(iId,false);
					ByteArrayInputStream bisA = new ByteArrayInputStream(envAPJ.getCertificatPublic());
				    X509Certificate oX509CertificateA = null;
				    try 
				    {
				    	CertificateFactory cf = CertificateFactory.getInstance("X.509");
				    	oX509CertificateA = (X509Certificate) cf.generateCertificate(bisA);
					} 
				    catch (CertificateException e) {}		
				    sName = CertificateUtil.getCertificateSubjectInfoCN(oX509CertificateA);
				    sName = sName.toLowerCase();
				    sName = sName.replaceFirst(" ",".");
				    sName = sName.trim()+".crt";
					in = new ByteArrayInputStream(envAPJ.getCertificatPublic());
					break;
					
				case ObjectType.ENVELOPPE_B_PJ_CERT:
					EnveloppeBPieceJointe envBPJ = EnveloppeBPieceJointe.getEnveloppeBPieceJointe(iId,false);
					ByteArrayInputStream bisB = new ByteArrayInputStream(envBPJ.getCertificatPublic());
				    X509Certificate oX509CertificateB = null;
				    try 
				    {
				    	CertificateFactory cf = CertificateFactory.getInstance("X.509");
				    	oX509CertificateB = (X509Certificate) cf.generateCertificate(bisB);
					} 
				    catch (CertificateException e) {}		
				    sName = CertificateUtil.getCertificateSubjectInfoCN(oX509CertificateB);
				    sName = sName.toLowerCase();
				    sName = sName.replaceFirst(" ",".");
				    sName = sName.trim()+".crt";
					in = new ByteArrayInputStream(envBPJ.getCertificatPublic());					
					break;
					
				case ObjectType.ENVELOPPE_C_PJ_CERT:
					EnveloppeCPieceJointe envCPJ = EnveloppeCPieceJointe.getEnveloppeCPieceJointe(iId,false);
					ByteArrayInputStream bisC = new ByteArrayInputStream(envCPJ.getCertificatPublic());
				    X509Certificate oX509CertificateC = null;
				    try 
				    {
				    	CertificateFactory cf = CertificateFactory.getInstance("X.509");
				    	oX509CertificateC = (X509Certificate) cf.generateCertificate(bisC);
					} 
				    catch (CertificateException e) {}		
				    sName = CertificateUtil.getCertificateSubjectInfoCN(oX509CertificateC);
				    sName = sName.toLowerCase();
				    sName = sName.replaceFirst(" ",".");
				    sName = sName.trim()+".crt";
					in = new ByteArrayInputStream(envCPJ.getCertificatPublic());
					break;
					
				case ObjectType.MULTIMEDIA:
					inputStreamDownloader = Multimedia.getInputStreamDownloaderMultimediaFile(iId, conn);
					in = inputStreamDownloader.is;
					//in = Multimedia.getInputStreamMultimediaFile(iId);
					sName = Multimedia.getMultimedia(iId,false).getFileName();
					
					if(request.getParameter("bShowText")!=null
							&& request.getParameter("bShowText").equals("true"))
					{
						int iSignatureRatio = 100;
						if(request.getParameter("iSignatureRatio")!=null)
						{
							iSignatureRatio = Integer.parseInt(request.getParameter("iSignatureRatio"));
						}
						
						int iTextPosX = 0;
						int iTextPosY = 0;
						if(request.getParameter("iTextPosX")!=null
								|| request.getParameter("iTextPosY")!=null)
						{
							iTextPosX = Integer.parseInt(request.getParameter("iTextPosX"));
							iTextPosY = Integer.parseInt(request.getParameter("iTextPosY"));
							
						}
						in = ImageConversionUtil.showSignatureImageAndText(in, iSignatureRatio, iTextPosX, iTextPosY);
					}
					
					
					/**
					 * On ajoute une date d'expiration à 5 jours, c'est très 
					 * utile pour les logos sur le publisher.
					 * Cela évite de les charger à chaque consultations
					 */
					CacheHeadersFilter.setCacheHeader(response, 86400000 * 5);
					break;
					
				case ObjectType.QUARANTAINE:
					in = Quarantaine.getFile(iId);
					sName = Quarantaine.getQuarantaine(iId,false).getFileName();
					break;
					
				case ObjectType.QUARANTAINE_RAPPORT:
					in = Quarantaine.getRapportFile(iId);
					sName = "rapport.txt";
					break;
					
				case ObjectType.ANCIEN_AVIS:
					in = AncienAvis.getAncienAvisFile(iId);
					sName = AncienAvis.getAncienAvis(iId,false).getAncienAvisFilename();
					break;
					
				case ObjectType.AVIS_RECTIFICATIF:
					in = AvisRectificatif.getAvisRectificatifFile(iId);
					sName = AvisRectificatif.getAvisRectificatif(iId,false).getPieceJointeNom();
					break;
					
				case ObjectType.ENVELOPPE_A_PJ:
					String sTypeSignatureA = request.getParameter("sTypeSignature");

					EnveloppePieceJointe pjA = null;
					byte[] bytesSignatureA = null;
					//X509Certificate oX509Certificate = null;
					try	{pjA = EnveloppeAPieceJointe.getEnveloppeAPieceJointe(iId,false);}
					catch(Exception e){e.printStackTrace();}
						
					//ByteArrayInputStream bCertif = new ByteArrayInputStream(envAPJ.getCertificatPublic());
				    //CertificateFactory cf;
				    try 
				    {
						//cf = CertificateFactory.getInstance("X.509");
						//oX509Certificate = (X509Certificate) cf.generateCertificate(bCertif);
						
						if(sTypeSignatureA.equals("clair"))
							bytesSignatureA = pjA.getSignatureClair(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureClair());
						if(sTypeSignatureA.equals("chiffre"))
							bytesSignatureA = pjA.getSignatureChiffre(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureChiffre());
					} 
				    catch (Exception e) {}		

					in = new ByteArrayInputStream(CertificateUtil.getHexaStringValue( bytesSignatureA ).getBytes());
					sName = pjA.getNomPieceJointe()+".sign";
					break;
					
				case ObjectType.ENVELOPPE_B_PJ:
					String sTypeSignatureB = request.getParameter("sTypeSignature");

					EnveloppePieceJointe pjB = null;
					byte[] bytesSignatureB = null;
					//X509Certificate oX509Certificate = null;
					try	{pjB = EnveloppeBPieceJointe.getEnveloppeBPieceJointe(iId,false);}
					catch(Exception e){e.printStackTrace();}
						
					//ByteArrayInputStream bCertif = new ByteArrayInputStream(envAPJ.getCertificatPublic());
				    //CertificateFactory cf;
				    try 
				    {
						//cf = CertificateFactory.getInstance("X.509");
						//oX509Certificate = (X509Certificate) cf.generateCertificate(bCertif);
						
						if(sTypeSignatureB.equals("clair"))
							bytesSignatureB = pjB.getSignatureClair(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureClair());
						if(sTypeSignatureB.equals("chiffre"))
							bytesSignatureB = pjB.getSignatureChiffre(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureChiffre());
					} 
				    catch (Exception e) {}		

					in = new ByteArrayInputStream(CertificateUtil.getHexaStringValue( bytesSignatureB ).getBytes());
					sName = pjB.getNomPieceJointe()+".sign";
					break;
					
				case ObjectType.ENVELOPPE_C_PJ:
					String sTypeSignatureC = request.getParameter("sTypeSignature");

					EnveloppePieceJointe pjC = null;
					byte[] bytesSignatureC = null;
					//X509Certificate oX509Certificate = null;
					try	{pjC = EnveloppeCPieceJointe.getEnveloppeCPieceJointe(iId,false);}
					catch(Exception e){e.printStackTrace();}
						
					//ByteArrayInputStream bCertif = new ByteArrayInputStream(envAPJ.getCertificatPublic());
				    //CertificateFactory cf;
				    try 
				    {
						//cf = CertificateFactory.getInstance("X.509");
						//oX509Certificate = (X509Certificate) cf.generateCertificate(bCertif);
						
						if(sTypeSignatureC.equals("clair"))
							bytesSignatureC = pjC.getSignatureClair(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureClair());
						if(sTypeSignatureC.equals("chiffre"))
							bytesSignatureC = pjC.getSignatureChiffre(); //Crypto.asymRecoverSignNoPaddingWithBCProvider(oX509Certificate.getPublicKey(), envAPJ.getSignatureChiffre());
					} 
				    catch (Exception e) {}		

					in = new ByteArrayInputStream(CertificateUtil.getHexaStringValue( bytesSignatureC ).getBytes());
					sName = pjC.getNomPieceJointe()+".sign";
					break;
			}

			response.setContentType(sContentType);
			response.setHeader("Content-Disposition", sDisposition+" filename=\"" + sName+"\"");
			if(sContentLength != null && !sContentLength.equalsIgnoreCase(""))
				response.addHeader("length-file",sContentLength);
			OutputStream out = response.getOutputStream();

			HttpUtil.returnFile(in, out);
		}
		catch(Exception e){
			e.printStackTrace();
		} finally{
			if(inputStreamDownloader != null)
				inputStreamDownloader.close();
			
			ConnectionManager.closeConnection(conn);
		}
	}
	
	protected void doPost(
		HttpServletRequest request,
		HttpServletResponse response) {
		doGet(request, response);
	}
	

}
