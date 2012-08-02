<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@ page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%
	String sTitle = "Localization";
	
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	String sSelectLang = "";
    for (Language lang : vLanguage) {
    	sSelectLang+="<tr>"+
            "<td style=\"text-align:right;\">"+
                "<input type=\"checkbox\" "+
                    "name=\"language_" + lang.getId()+"\" "+
                    " />"+
            "</td>"+
            "<td>"+lang.getName()+"</td>"+
       "</tr>";
    }   
	Vector<ObjectType> vObjectType = ObjectType.getAllStaticMemory();
	Vector<CaptionCategory> vCaptionCategory = CaptionCategory.getAllStaticMemory();
%>
<script type="text/javascript">
onPageLoad = function(){
   $("localization_form").onsubmit = function(){
       var url = $("localization_method").value;
       if(isNotNull(url))
        this.action = url;
       else return false; 
   }
   
   $("localization_method").onchange = function(){
        switch(this.value){
            case "<%= response.encodeURL("modifyAllCaptionForm.jsp") %>":
            case "<%= response.encodeURL(
	    		rootPath + "desk/DownloadLocalizationExcelFileServlet?sLocalizationType=caption") %>":
            Element.show("select_category");
            Element.hide("select_object");
            break;
            
            default:
            Element.show("select_object");
            Element.hide("select_category");
            break;
        }
   }
   
   Element.hide("select_category");
   
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

<form action="" method="post" id="localization_form">
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td colspan="2">Localization Request</td>
        </tr>
        <tr>
        <td style="text-align:right;">Select localization method</td>
        <td>
            <select id="localization_method">
	            <option value="<%= response.encodeURL("modifyAllObjectLocalizationForm.jsp") %>">objects</option>
	            <option value="<%= response.encodeURL("modifyAllObjectAttributeLocalizationForm.jsp") %>">attribute's object</option>
	            <option value="<%= response.encodeURL("modifyAllCaptionForm.jsp") %>">caption</option>
	            <option value="">method's object</option>
	            <option value="<%= response.encodeURL(
	            		rootPath + "desk/DownloadLocalizationExcelFileServlet?sLocalizationType=object_attribute") 
	            		%>">export excel file object attribute</option>
	             <option value="<%= response.encodeURL(
	            		rootPath + "desk/DownloadLocalizationExcelFileServlet?sLocalizationType=object") 
	            		%>">export excel file object</option>
	             <option value="<%= response.encodeURL(
	            		rootPath + "desk/DownloadLocalizationExcelFileServlet?sLocalizationType=caption") 
	            		%>">export excel file caption</option>
            </select>
            <input type="checkbox" name="form_display"/> Only display
        </td>
        </tr>
        <tr id="select_object">
        <td style="text-align:right;">Select object</td>
        <td><%=CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("lIdTypeObject",1,(Vector)vObjectType,0,"",false,false)%></td>
        </tr>
        <tr id="select_category">
        <td style="text-align:right;">Select category</td>
        <td><%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("lIdCaptionCategory",1,(Vector)vCaptionCategory,0,"",false,false)%></td>
        </tr>
        <%= sSelectLang %>
        <tr>
            <td style="text-align:center;" colspan="2">
                <button type="submit">Submit</button>
            </td>
        </tr>
    </table>
    </div>
</form>


<br/>
<br/>
<form action="<%= response.encodeURL("modifyAllCaptionForm.jsp") %>" 
	enctype="multipart/form-data" 
	method="post"
	name="importCaption" >
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td colspan="2">Localization caption</td>
        </tr>
        <tr>
	        <td style="text-align:right;">Select file to upload</td>
	        <td>
				<input type="file" size="60" name="importFile">
			</td>
		</tr>
		<tr>
	        <td ></td>
	        <td>
				<button type="submit" >Submit</button>
			</td>
		</tr>
	</table>
	</div>
</form>


<br/>
<br/>
<form action="<%= response.encodeURL("modifyAllObjectLocalizationForm.jsp") %>" 
	enctype="multipart/form-data" 
	method="post"
	name="importLocalization" >
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td colspan="2">Localization object</td>
        </tr>
        <tr>
	        <td style="text-align:right;">Select file to upload</td>
	        <td>
				<input type="file" size="60" name="importFile">
			</td>
		</tr>
		<tr>
	        <td ></td>
	        <td>
				<button type="submit" >Submit</button>
			</td>
		</tr>
	</table>
	</div>
</form>



<br/>
<br/>
<form action="<%= response.encodeURL("modifyAllObjectAttributeLocalizationForm.jsp") %>" 
	enctype="multipart/form-data" 
	method="post"
	name="importLocalizationObjectAttibute" >
    <div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td colspan="2">Localization object's atribute</td>
        </tr>
        <tr>
	        <td style="text-align:right;">Select file to upload</td>
	        <td>
				<input type="file" size="60" name="importFile">
			</td>
		</tr>
		<tr>
	        <td ></td>
	        <td>
				<button type="submit" >Submit</button>
			</td>
		</tr>
	</table>
	</div>
</form>

</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
</html>