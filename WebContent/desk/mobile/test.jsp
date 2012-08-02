<%@ include file="/mobile/include/header.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<jsp:include page="/desk/mobile/include/headerHTML.jsp" flush="true" />

<link rel="stylesheet" type="text/css" href="<%=rootPath%>include/paraph/css/main.css?v=1.0.1" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/js/shadedborder.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/fastinit.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/run.js?v=1.4.0"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/scriptaculous/effects.js"></script>

<script type="text/javascript" src="<%=rootPath%>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/livepipe/window.js"></script>

<style>
html{
	height: auto;
}
body {
	overflow:auto;
}

</style>

<script>







function showModalFrame(url, w, h) {
	var sHTML = 
		'<table class="facebox">'+
			'<tr>'+
				'<td class="tl"/><td class="b"/><td class="tr"/>'+
			'</tr>'+
			'<tr>'+
				'<td class="b"/>'+
				'<td class="body">'+
					'<div class="content">'+
					'<iframe frameBorder="0" border="0" align="top" style="width:100%;'+((h)?'height:'+h+'px;':'')+'border:0;margin:0" src="'+url+'"></iframe>'+
					'</div>'+
				'</td>'+
				'<td class="b"/>'+
			'</tr>'+
			'<tr>'+
				'<td class="bl"/><td class="b"/><td class="br"/>'+
			'</tr>'+
		'</table>';


		var relative = new Control.Window(false,{
			//position: 'relative',
			/*className: 'simple_window',*/
			width:w
			//closeOnClick: true
			
		});

		var div = document.createElement("div");
		div.innerHTML = sHTML;		
		relative.container.insert(div);
		relative.open();

		/*
	var container = document.createElement("div");
	container.appendChild(sHTML);
	
	document.body.appenChild(container);
	
	var modal = new Control.Window(container,{width: w});
		*/
	
}

function popup(){

	mt.utils.displayModal({title:"toto", content:"robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>robert<br/>"}, 600, 400);
	
	
}

</script>


<button onclick="popup()">ROBERT</button>

TOTO <br/>
TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>
TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>
TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>TOTO <br/>

<jsp:include page="/desk/mobile/include/footerHTML.jsp" flush="true" />