<%@ page import="com.oreilly.servlet.multipart.*,org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%

	String sFileName = "";	
	String sContentType = "";	
	X509Certificate certToAdd= null;
	
	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("sFilePath"))
			{
				sFileName = file.getFileName(); 
				sContentType = file.getContentType(); 
			 
				CertificateFactory cf = CertificateFactory.getInstance("X.509");
				certToAdd = (X509Certificate)cf.generateCertificate(file.getInputStream());
				
			}
		}
	}
	
	if(AutoriteCertificationRacine.isCertificateInBase(certToAdd ))
	{
		throw new Exception ("Certificat déja en Base !");
	}

	try {
		// on teste si c'est un certificat ROOT
		certToAdd .verify(certToAdd .getPublicKey() ) ; 
	
		AutoriteCertificationRacine oDBCertificate = new AutoriteCertificationRacine ();
		oDBCertificate.setCertificate(certToAdd );
		oDBCertificate.setFilename(sFileName);
		oDBCertificate.create();
		
	} catch (Exception e)
	{
		// c'est un certificat intermédiaire, il faut que le certificat root soit déja en base
		AutoriteCertificationRacine.getChainedCertificate(certToAdd);
	
		AutoriteCertificationIntermediaire oDBCertificate = new AutoriteCertificationIntermediaire();
		oDBCertificate.setCertificate(certToAdd);
		oDBCertificate.setFilename(sFileName);
		oDBCertificate.create();
	}
		
	String sUrlRedirect = "afficherToutesAutoriteCertification.jsp?nonce=" + System.currentTimeMillis();
	response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
%>
