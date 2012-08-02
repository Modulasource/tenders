<%@ page import="java.sql.*,org.coin.util.*,java.util.*" %>   
<%
	String name="";
	String rootPath = request.getContextPath()+"/";
	if (request.getParameter("name") != null) name = request.getParameter("name");
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<%@page import="modula.graphic.Theme"%>
<html>
<head>
	<script type="text/javascript">
		if (document.all || (!document.all && parseInt(navigator.appVersion)>=5)) document.write('<link rel="stylesheet" href="<%=rootPath%>include/css/<%= Theme.getDeskCSS() %>.css">');
		function valider(jj,mm,aaaa){
		if(jj<10) jj="0"+jj;
		if(mm<10) mm="0"+mm;
		opener.parent.<%=name%>.value=jj+"/"+mm+"/"+aaaa;
		setTimeout("self.close();",500);
		}
		function recharger(){
			document.calend.submit();
		}
	</script>
<title>Calendrier</title>
</head>
<body bgcolor="#FFFFFF">
	<form name="calend" method="post" action="calendar.jsp"> 
		<input type="hidden" name="name" value="<%=name%>" />
<% 
	Timestamp tsDateAujourdhui = new Timestamp(System.currentTimeMillis());
	Calendar calendrier = Calendar.getInstance();
	String sDateString = CalendarUtil.getDateCourte(tsDateAujourdhui);
	String sDateMaintenant[] = sDateString.split("/");
	int jour=0,mois=0,annee=0;
	
	/* Récupération du jour de la semaine */
	jour = calendrier.get(Calendar.DAY_OF_WEEK) - 1;
	
	/* Récupération du mois */
	mois = calendrier.get(Calendar.MONTH);
	
	/* Récupération de l'année */
	annee = calendrier.get(Calendar.YEAR); 

	
	if (request.getParameter("mois") == null || request.getParameter("mois").equalsIgnoreCase("")) {
		try { mois = Integer.parseInt(sDateMaintenant[1]); } 
		catch (Exception e ) {
			//e.printStackTrace();
		}
	}
	else { 
		try { mois = Integer.parseInt(request.getParameter("mois")); } 
		catch (Exception e ) {
			//e.printStackTrace();
		}	

	}
	
	if (request.getParameter("annee") == null || request.getParameter("annee").equalsIgnoreCase(""))  {
		try { annee = Integer.parseInt(sDateMaintenant[2]); }
		catch (Exception e ) {
			//e.printStackTrace();
		} 
	}
	else {
		try { annee = Integer.parseInt(request.getParameter("annee")); } 
		catch (Exception e ) {
			//e.printStackTrace();
		} 
	}
	
	if (request.getParameter("jour") == null  || request.getParameter("jour").equalsIgnoreCase("")) {
		try { jour = Integer.parseInt(sDateMaintenant[0]); } 
		catch (Exception e ) {
			//e.printStackTrace();
		}
	}
	else {
		try { jour = Integer.parseInt(request.getParameter("jour")); } 
		catch (Exception e ) {
			//e.printStackTrace();
		}
	}
	
	String sdate = jour+"/"+mois+"/"+annee;
	Timestamp tsDate = CalendarUtil.getConversionSimpleTimestamp(sdate);
	calendrier.setTimeInMillis(tsDate.getTime());
	int iPremierJour = CalendarUtil.getFirstDayOfMonth(calendrier); 
	iPremierJour--;
	if (iPremierJour ==-1) iPremierJour=6;
	else if (iPremierJour == 0) iPremierJour = 7;
	int iNbJoursDuMois = calendrier.getActualMaximum(Calendar.DAY_OF_MONTH);
	String sMois[] = CalendarUtil.arrMonthNameFR;
%>
<table border="0" cellspacing="0" cellpadding="0"> 
    <tr bgcolor="#2361AA"> 
      <td> 
<%
 if(mois == 1) {
%>
	<a href="calendar.jsp?annee=<%=annee - 1%>&amp;mois=12&amp;jour=<%=jour%>&amp;name=<%=name%>"><font color="#ff8c00"><strong>&lt;&lt;</strong></font></a>
<%
 }
 else {
%>
	<a href="calendar.jsp?annee=<%=annee%>&amp;mois=<%=mois-1%>&amp;jour=<%=jour%>&amp;name=<%=name%>"><font color="#ff8c00"><strong>&lt;&lt;</strong></font></a>
<%
 }
%>
		</td>
		<td>
		<div style="text-align:center">
        	<select name="mois" onChange="recharger()" style="min-width:100px;max-width:100px;width:100px;">
<%
		for(int i=0;i<sMois.length;i++){

			if(mois == i+1 ) {
%>			
				<option value="<%=i+1%>" selected='selected'><%=sMois[i]%></option>		
<%			} 
			else{
%>
				<option value="<%=i+1%>"><%=sMois[i]%></option>		
<%			}
		}
		
%>        
        
        	</select>
       		<select name="annee" onChange="recharger()" style="min-width:100px;max-width:100px;width:100px;">
<%
		  		int decenie= annee;
				while ((decenie%10)!=0){
					decenie--;
				}
				for(int i=decenie-50;i<decenie;i+=10){
%>
					<option value="<%=i%>">Ann&eacute;es <%=i%></option>
<%
				}
%>
					<option value="<%=annee%>">---</option>
<%
				for(int i=decenie;i<annee;i++){
%>
					<option value="<%=i%>"><%=i%></option>
<%
				}
%>					
					<option value="<%=annee%>" selected='selected'><%=annee%></option>
<%				for(int i=annee+1;i<decenie+10;i++){
%>
					<option value="<%=i%>"><%=i%></option>
<%
				}
%>
					<option value="<%=annee%>">---</option>
<%				
				for(int i=decenie+10;i<decenie+60;i+=10){
%>
					<option value="<%=i%>">Ann&eacute;es <%=i%></option>
<%
				}
%>
        	</select> 
		</div>
		</td>
		<td>
		<div align="right">
<%
	if(mois == 12){
%>
		<a href="calendar.jsp?annee=<%=annee+1%>&amp;mois=1&amp;jour=<%=jour%>&amp;name=<%=name%>"><font color="#ff8c00"><strong>&gt;&gt;</strong></font></a>
<%
	}
	else{
%>
		<a href="calendar.jsp?annee=<%=annee%>&amp;mois=<%=mois + 1%>&amp;jour=<%=jour%>&amp;name=<%=name%>"><font color="#ff8c00"><strong>&gt;&gt;</strong></font></a>
<%
	}
%>
		</div>
		</td>
	</tr>
</table>
<table align="center" border="2">
	<tr bgcolor="#EEEEEE" align="center"> 
      <td style="width:50px"><strong>Lu</strong></td>
      <td style="width:50px"><strong>Ma</strong></td>
      <td style="width:50px"><strong>Me</strong></td>
      <td style="width:50px"><strong>Je</strong></td>
      <td style="width:50px"><strong>Ve</strong></td>
      <td style="width:50px"><strong>Sa</strong></td>
	  <td style="width:50px"><strong>Di</strong></td>
    </tr>
	<tr align="center">
<%
	for(int i = 1; i < iPremierJour ; i++){
%>
	<td>&nbsp;</td>
<%
	}
int j = iPremierJour;
for(int i=1 ; i <= iNbJoursDuMois ;i++){
 if(i == jour)
 {
%>
	<td bgcolor="#EEEEEE"><a href="javascript:valider('<%=i%>','<%=mois%>','<%=annee%>')"> 
        <b><%=i%></b></a> 
<%	
 }	
 else
 {
%>
	<td>
        <a href="javascript:valider('<%=i%>','<%=mois%>','<%=annee%>')"> 
        <%=i%></a> 
<%
 }
 %>
	</td>
<%
 if(j == 7)
 {
  if(i < iNbJoursDuMois)
  {
%>
	</tr>
    <tr align="center">
<%
   j = 1;
  }

 }else{
  j++;
 }
}
	for(int i=j;i<=7;i++){ 
%>
	<td align="center">&nbsp;</td>
<%
	}
%>
	</tr>
</table>
</form>
</body>
</html>