<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@ page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.coin.servlet.DownloadLocalizationExcelFileServlet"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.coin.util.Outils"%>
<%
	String sTitle = "Localize matrix";
	String LOCALIZED_MATRIX[][][] = null;
	String LOCALIZED_MATRIX_OLD[][][] = null;
	
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
	JSONArray jsonLangageSelected = new JSONArray();
	
	boolean bOnlyDisplay = false;
    long lIdCaptionCategory = -1;
    FileItem fileItem =  null;
    String sFileName = "";
    Connection conn = ConnectionManager.getConnection();
	Localize.reloadMatrix(conn);

    /**
	 * look for a uploaded file
	 */
	try{
		fileItem = HttpUtil.getFirstFileItem(request);
		if(fileItem != null) {
			
			sFileName = fileItem.getName();
			InputStream is = fileItem.getInputStream();
			POIFSFileSystem fs = new POIFSFileSystem(is);
		
			// ne marche que pour Execel 2000(pas Excel 5.0)
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			
			LOCALIZED_MATRIX = DownloadLocalizationExcelFileServlet.prepareLocalizedMatrix(wb, conn);
			LOCALIZED_MATRIX_OLD = Localize.LOCALIZED_MATRIX; 
			vLanguageSelected = DownloadLocalizationExcelFileServlet.getAllLanguageSelectedFromWorkbook(wb,conn);
			lIdCaptionCategory = DownloadLocalizationExcelFileServlet.getIdCaptionCategoryFromWorkbook(wb);
			
			try {
				is.close();
			} catch (Exception e ) {}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	ConnectionManager.closeConnection(conn);

	
	
	if(fileItem == null)
	{
		
		LOCALIZED_MATRIX = Localize.LOCALIZED_MATRIX; 
		
	    if(request.getParameter( "form_display") != null)
	        bOnlyDisplay = true;
		
	    lIdCaptionCategory = HttpUtil.parseLong("lIdCaptionCategory", request);
	    
	    for(Language l : vLanguage)
	    {
	        if(request.getParameter( "language_" + l.getId()) != null)
	        {
	            vLanguageSelected.add(l);
	            jsonLangageSelected.put(l.toJSONObject());
	        }
	    }
	}
	
	CaptionCategory category = CaptionCategory.getCaptionCategory(lIdCaptionCategory);
    
%>
<script type="text/javascript">
<!--
onPageLoad = function(){
	<% if(!bOnlyDisplay){ %>
	var jsonLangageSelected = <%= jsonLangageSelected %>;
	var size = $("tableLoc").getElementsByTagName("tr").length-1;
	$("addLoc").onclick = function(){
	    size++;
	    var tr = document.createElement("tr");
	    var tdIndex = document.createElement("td");
	    var inputIndex = document.createElement("input");
	    inputIndex.type="text";
	    inputIndex.name="new_captionindex_<%= lIdCaptionCategory %>_"+size;
	    inputIndex.value = size;
	    inputIndex.size = 5;
	    tdIndex.appendChild(inputIndex);
	    tr.appendChild(tdIndex);
	    jsonLangageSelected.each(function(lang){
		    var tdLang = document.createElement("td");
		    var input = document.createElement("input");
		    input.type="text";
		    input.name="new_captionvalue_"+lang.lId+"_<%= lIdCaptionCategory %>_"+size;
	        input.value = "";
	        input.size=40;
	        input.style.backgroundColor = "#FDF";
	        tdLang.appendChild(input);
	        tr.appendChild(tdLang);
	    });
	    $("tableLoc").appendChild(tr);
	}
	<% }%>
}
//-->
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

<form action="<%= response.encodeURL("modifyAllCaption.jsp") %>" 
	method="post" 
	accept-charset="UTF-8" >    
<input type="hidden" name="lIdCaptionCategory" value="<%= lIdCaptionCategory %>" />
<input type="hidden" name="System_bUsePreventInjectionFilter" value="false" />

<%
    for (Language lang : vLanguageSelected) {
%>  
<input type="hidden" name="<%= "language_" + lang.getId() %>" />
<%
    }   
%>  

    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr >
            <td style="text-align:right;width:30%">Caption category : </td>
            <td><%= category.getName() %></td>
        </tr>
        <tr >
            <td style="text-align:right;width:30%">Action : </td>
            <td>
                <% if(!bOnlyDisplay){ %>
                <button type="button" id="addLoc">Add</button>
                <button type="submit" >Submit</button>
                <% } %>
                <button type="button" onclick="doUrl('<%= response.encodeURL("admin.jsp")
                		%>')" ><%= localizeButton.getValueCancel() %></button>
             </td>
        </tr>
        </table>
    </div>

    <br/>
    <br/>
    
	<div class="dataGridHolder fullWidth">
		<table id="tableLoc" class="dataGrid fullWidth">
		<tr class="header">
		    <td>Index</td>
<%
	
	for (Language lang : vLanguageSelected) {
%>	
			<td><%= lang.getName() %></td>
<%
	}	
%>
		</tr>
<%
		
	int iMAX = Localize.MAX_CAPTION_VALUE_INDEX;
	for (int k = 1; k <=iMAX; k++) 
	{
		/**
		 * pour l'instant c'est un peu crado
		 * on boucle sur tous les langages pour savoir si on l'affiche ou non
		 */
		boolean bContinue = false;
		for (Language lang : vLanguageSelected) {
			String sTestVal = null;
			try {
				sTestVal = LOCALIZED_MATRIX[(int)lang.getId()][(int)lIdCaptionCategory][k];
				//System.out.println("sTestVal:"+sTestVal);
				
				/** la valeur n'est pas renseignee dans le fichier, on va chercher dans la base */
				if(fileItem != null && Outils.isNullOrBlank(sTestVal)) throw new Exception("");
			} catch (Exception e ) {
				if(LOCALIZED_MATRIX_OLD!=null){
					try{
						sTestVal = LOCALIZED_MATRIX_OLD[(int)lang.getId()][(int)lIdCaptionCategory][k];
						//System.out.println("sTestVal2:"+sTestVal);
					}catch (Exception e1 ) {
						// on a atteint le max
						break;
					}
				}else{
					// on a atteint le max
					break;
				}
			}
			if(sTestVal != null) bContinue = true;
		}		
		
		if(!bContinue) break;
		
		%>
	<tr>
		<%
		ArrayList<HashMap<String, Object>> listCaption = new ArrayList<HashMap<String, Object>>();
		boolean bIsNewValCaption = false;
		for (Language lang : vLanguageSelected) {
			String sValue = "";
			String sCellStyle = "";
			
			String sVal = null;
			try {sVal = LOCALIZED_MATRIX[(int)lang.getId()][(int)lIdCaptionCategory][k];}
			catch (Exception e ) {}
			
			String sValOld = null;
			try{
				if(LOCALIZED_MATRIX_OLD != null)
					sValOld = LOCALIZED_MATRIX_OLD[(int)lang.getId()][(int)lIdCaptionCategory][k];
			}catch(Exception e){}
			
			boolean bIsNewVal = false;
			if(sVal != null && !sVal.equals(""))
			{
				sValue =  sVal;
				if(LOCALIZED_MATRIX_OLD != null && Outils.isNullOrBlank(sValOld)){
					sCellStyle = " style='background-color:#FDF' ";
					bIsNewVal = true;
				}else if(sValOld!=null && !sValue.equals(sValOld)){
					sCellStyle = " style='background-color:#99CE8F' ";
				}
			} else if(LOCALIZED_MATRIX_OLD != null && !Outils.isNullOrBlank(sValOld)){
				sValue = sValOld;
			} else {
				sValue = "";
				sCellStyle = " style='background-color:#FDF' ";
				bIsNewVal = true;
			}
			HashMap<String, Object> mapCaption = new HashMap<String, Object>();
			mapCaption.put("bIsNewVal",bIsNewVal);
			mapCaption.put("sValue",sValue);
			mapCaption.put("sCellStyle",sCellStyle);
			mapCaption.put("lang",lang);
			listCaption.add(mapCaption);
			if(bIsNewVal) bIsNewValCaption = true;
		}
		%>
		<td>
			<%if(bIsNewValCaption){ %>
			<input size="5" name="new_captionindex_<%= lIdCaptionCategory %>_<%= k %>" type="text" value="<%= k %>">
			<%}else{ %>
			<%= k %>
			<%} %>
		</td>
		<% for(HashMap<String, Object> mapCaption : listCaption){ %>
		<td>
		<% if(bOnlyDisplay){ %>
		<label><%= mapCaption.get("sValue") %></label>
		<%}else{ %>
		<input type="text" name="<%= 
			(((Boolean)mapCaption.get("bIsNewVal"))?"new_captionvalue_":"caption_") + ((Language)mapCaption.get("lang")).getId() + "_" + lIdCaptionCategory + "_" + k 
			%>" value="<%= mapCaption.get("sValue") %>" <%= mapCaption.get("sCellStyle") %> size="40" /> 
	    <%} %>
		</td>
		<%} %>
	</tr>
	<%
	}
%>
	</table>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>