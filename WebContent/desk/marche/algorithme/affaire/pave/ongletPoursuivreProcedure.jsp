<%
String rootPath = request.getContextPath()+"/";
%>
<br/>
<div class="center">
	Pour terminer la phase de gestion des publications et passer � l'�tape suivante, cliquez sur le bouton ci-dessous. 
</div>
<br/>
<div class="center" id="poursuivreProcedure">
	<img style="cursor:pointer" src="<%=rootPath%>images/icons/36x36/next.gif" alt="Valider l'envoi des publications (Poursuivre la proc�dure)" title="Valider l'envoi des publications (Poursuivre la proc�dure)" onclick="$('formPoursuivre').submit();"/>
</div>