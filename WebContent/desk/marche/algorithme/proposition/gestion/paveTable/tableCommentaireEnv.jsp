<%if(!eEnveloppe.getCommentaire().equalsIgnoreCase("")){%>
<table class="pave" summary="none">
<tr>
	<td class="pave_titre_gauche" colspan="2">
	Commentaire
	</td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
	<td colspan="2" style="text-align:left;"><%= eEnveloppe.getCommentaire() %></strong></td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
</table>
<%}%>