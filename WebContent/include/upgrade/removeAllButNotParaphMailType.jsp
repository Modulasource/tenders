
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.mail.MailType"%>
<%

	Vector<MailType> vMailType = MailType.getAllMailType(false);

	long[] larrIdArrMailToKeep = new long[]{94,67,19, 20,24, 26, 28, 29, 30, 44, 2037, 54, 2038, 53, 2039, 83, 100};
	String[] sarrReference = {"PARAPH"};

	
%>
<table>

<%	
	for(MailType mail : vMailType)
	{
		boolean bToKeep = false;

		
		for(long l : larrIdArrMailToKeep )
		{
			if(l == mail.getId())
			{
				bToKeep = true;
			}
		}

		
		for(String s : sarrReference )
		{
			System.out.println("s : " + s);
			if(s != null 
			&& mail.getReference() != null 
			&& mail.getReference().contains(s) )
			{
				bToKeep = true;
			}
		}
		
		
		
%>
<tr>
<td>
<input type="checkbox" <%= bToKeep?"checked='checked'":"" %>/>
</td>
<td>
<%= mail.getId() %>
</td>
<td>
<%= bToKeep?"<b>":"" %>
<%= mail.getReference() %>
<%= bToKeep?"</b>":"" %>
</td>
<td>
<%= bToKeep?"<b>":"" %>
<%= mail.getName() %>
<%= bToKeep?"</b>":"" %>
</td>
</tr>
<%		
	}
%>
</table>
