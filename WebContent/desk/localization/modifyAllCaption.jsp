<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.*" %>
<%@page import="org.coin.util.HttpUtil"%>
<%
	Connection conn = ConnectionManager.getConnection();
	CaptionValue[][][] mcv = Localize.getMatrixCaptionValue(conn);

	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
    long lIdCaptionCategory = -1;
    lIdCaptionCategory = HttpUtil.parseLong("lIdCaptionCategory", request);
    
    for(Language l : vLanguage)
    {
        if(request.getParameter( "language_" + l.getId()) != null)
        {
            vLanguageSelected.add(l);
        }
    }
	
    boolean bUsePrevent = false;
    boolean bStripSlashes = false;
	
    /**
     * treat existing caption
     */ 
	for (int k = 1; k <=Localize.MAX_CAPTION_VALUE_INDEX; k++) 
	{
		/**
		 * pour l'instant c'est un peu crado
		 * on boucle sur tous les langages pour savoir si on l'affiche ou non
		 */
		boolean bContinue = false;
		for (Language lang : vLanguageSelected) {
			String sTestVal = null;
			try {
				sTestVal = Localize.LOCALIZED_MATRIX[(int)lang.getId()][(int)lIdCaptionCategory][k];
			} catch (Exception e ) {
				// on a atteint le max
				break;
			}
			if(sTestVal != null) bContinue = true;
		}		
		
		if(!bContinue) break;

		for (Language lang : vLanguageSelected) {
			CaptionValue cv = null;
			
			try {
				cv = mcv[(int)lang.getId()][(int)lIdCaptionCategory][k];
			} catch (Exception e ) {
			}
	
			String sName = "caption_" + lang.getId() + "_" + lIdCaptionCategory + "_" + k ;
			String sValue = request.getParameter(sName);
			if(bUsePrevent) sValue = PreventInjection.preventStore(sValue);
			if(bStripSlashes) sValue = Outils.stripSlashes(sValue);

			if(sValue != null && !sValue.equals("") )
			{
				if(cv != null )
				{
					cv.setValueWithEncoding(sValue);
					cv.store(conn);
				} else {
					cv = new CaptionValue();
					cv.setValueWithEncoding(sValue);
					cv.setIdCaptionCategory(lIdCaptionCategory);
					cv.setIdLanguage(lang.getId());
					cv.setIndexValue(k);
					cv.create(conn);
				}
			} else {
				if(cv != null && Outils.isNullOrBlank(sValue) )
				{
					//System.out.println("remove");
					cv.remove(conn);
				}
			}
		}
	}
	
	/** NEW CAPTION */
	Enumeration enumeration = request.getParameterNames();
	while (enumeration.hasMoreElements()) { 
        String param = (String) enumeration.nextElement(); 
        if(param.startsWith("new_captionindex_"+lIdCaptionCategory+"_")){
        	String sIdentifier = param.substring(("new_captionindex_"+lIdCaptionCategory+"_").length(),param.length());
        	
        	for (Language lang : vLanguageSelected) {
                CaptionValue cvNew = new CaptionValue();
                cvNew.setIdCaptionCategory(lIdCaptionCategory);
                cvNew.setIdLanguage(lang.getId());
                cvNew.setIndexValue(Integer.parseInt(sIdentifier));
                
                String sName = "new_captionvalue_" + lang.getId() + "_" + lIdCaptionCategory+ "_" +sIdentifier;
                String sValue = request.getParameter(sName);
                
                if(!Outils.isNullOrBlank(sValue)){
	                if(bUsePrevent) sValue = PreventInjection.preventStore(sValue);
	                if(bStripSlashes) sValue = Outils.stripSlashes(sValue);
	                cvNew.setValueWithEncoding(sValue);
	                
	                if(bUsePrevent) sIdentifier = PreventInjection.preventStore(sIdentifier);
	                if(bStripSlashes) sIdentifier = Outils.stripSlashes(sIdentifier);

		            cvNew.create(conn);
		            //System.out.println("create new "+sName+" for idx "+sIdentifier+" : "+sValue);
                }
            }
        }
	}

	Localize.reloadMatrix(conn);
	ConnectionManager.closeConnection(conn);

	response.sendRedirect(
			response.encodeRedirectURL(
					"admin.jsp"));

%>