<%@page import="java.util.logging.Level" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.applet.AppletJarVersion"%>
<%
	String rootPath = request.getContextPath() +"/";
	
	//String sLocalApplicationSubDir = AppletJarVersion.getLocalApplicationSubDir();
	String sLocalApplicationSubDir = ".dropnsign";
	String sJarPath = AppletJarVersion.getJarPath(rootPath);
	StringBuilder sbArchives = AppletJarVersion.getAppletContainerVersion(sJarPath);
	String sLibListCommon = AppletJarVersion.getSignatureAppletVersion();
	sLibListCommon += ";org-modula-applet-file-sync-0.0.1.jar";
	
	String sUrlDownloadRepository
	= HttpUtil.getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			rootPath + "CoinJarDownloaderServlet?sContext=AppletContainer&sJarName=",
	        request , response);

	String sLocalDir = "d:\\dropnsign";

%>
<div id="progressBarDiv" style="display:none;text-align: center;padding: 5px;color:#99f;" >
	<style type="text/css">
	 #progressBarApplet_percentText{
	  margin-left:5px;
	 }
	</style>
	<span id="progressBarAppletMessage"></span>
	<span class="progressBar" id="progressBarApplet">0%</span>
</div>

<script type="text/javascript">
<!--

//Update progress bar
function updateProgression(jsonProgressionBean) {
	try{
    	jsonProgressionBean = jsonProgressionBean.evalJSON();
    	
		if((""+jsonProgressionBean.percent).isNumber()) {
			myJsProgressBarHandler.setPercentage("progressBarApplet",jsonProgressionBean.percent);
			$("progressBarAppletMessage").innerHTML = jsonProgressionBean.message;
		}

    	if(jsonProgressionBean.percent<100){
    		Element.show("progressBarDiv");
    	}else{
    		window.setTimeout("Element.hide('progressBarDiv');", 500);
    	}
    } catch(e){}
}

function updateLocalFileList(joFileList)
{
	try {
		joFileList = joFileList.evalJSON();
	    joFileList.each(function(item){
			var divFile = document.createElement("div");
			if(item.bIsDirectory) {
				divFile.innerHTML = item.sName + "/";
			} else {
				$("divDocumentList").appendChild(createDivDocument(item.sName));
			}
		    
	    });
	} catch(e) {
		alert(e);
	}

}

function createDivDocument(sName)
{
	var divDoc = document.createElement("div");
	var divDocName = document.createElement("div");
	var divImg = document.createElement("img");

	//divDoc.style = "float: left;padding: 15px;";
	divDoc.style.cssFloat = "left"
	divDoc.style.padding = "15px";
	divImg.src = "<%= rootPath + "images/dropnsign/64x64/document.png" %>";
	divImg.style.cursor = "pointer";
	divDoc.appendChild(divImg); 

	divDocName.innerHTML = sName;
	divDocName.style.textAlign = "center";
	divDoc.appendChild(divDocName);

	return divDoc;
}


function readLocal()
{
	document.myAppletInstance.readLocal();
	//$("myAppletInstance").downloadFile();
}

//-->
</script>


<applet
	code="org.modula.common.util.applet.AppletContainer.class"
	codebase="<%= sJarPath %>"
	archive="<%= sbArchives.toString() %>"               
	width ="150"
	height="50"
	name="myAppletInstance" 
	id="myAppletInstance"
	mayscript="mayscript"  
	scriptable="true"
	alt="Applet de Signature">
	<param name="Container_sAppletChildName" value="org.modula.applet.file.sync.AppletFileSync" />
	<param name="Container_sUrlDownloadRepository" value="<%= sUrlDownloadRepository %>" />
	<param name="Container_sLibListCommon" value="<%= sLibListCommon %>" />
	<param name="Container_sLocalApplicationSubDir" value="<%= sLocalApplicationSubDir %>" />
	<param name="Container_sLoggingLevel" value="<%= Level.ALL.toString() %>" /> 

	<param name="sFilePath" value="<%= sLocalDir %>" /> 

</applet>
Local dir: <%= sLocalDir %>
