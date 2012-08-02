
<%@ page import="modula.marche.*,org.coin.fr.bean.mail.*" %>
<%	
	String rootPath = request.getContextPath() +"/";
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_TEMPLATE,false);
%>
<%= mailType.getContenuTypeHTML() %>
<script type="text/javascript" src="<%=rootPath %>include/js/prototype.js"></script>
<script language="javascript" src="../../tiny_mce_popup.js"></script>
<script type="text/javascript" src="jscripts/embed.js"></script>
<script type="text/javascript">
tinyMCEPopup.onInit.add(function(ed) {
	var dom = tinyMCEPopup.dom;

	// Load editor content_css
	tinymce.each(ed.settings.content_css.split(','), function(u) {
		dom.loadCSS(ed.documentBaseURI.toAbsolute(u));
	});
	
	//dom.setHTML('content',sHTML );
	$("_repere_").innerHTML = ed.getContent();
});
</script>
