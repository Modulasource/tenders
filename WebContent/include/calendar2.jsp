<%@ page import="java.sql.*,org.coin.util.*,modula.*,java.util.*" %>   
<%@page import="modula.graphic.Theme"%>
<%
	String sDivToHidde="";
	String sDateFieldName="";
	String rootPath = request.getContextPath()+"/";
	if (request.getParameter("sDivToHidde") != null) sDivToHidde = request.getParameter("sDivToHidde");
	if (request.getParameter("sDateFieldName") != null) sDateFieldName = request.getParameter("sDateFieldName");
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<script type="text/javascript">
	if (document.all || (!document.all && parseInt(navigator.appVersion)>=5)) 
		document.write('<link rel="stylesheet" href="<%=rootPath%>include/css/<%= Theme.getDeskCSS() %>.css">');
	
	function valider(jj,mm,aaaa)
	{
		if(jj<10) jj="0"+jj;
		if(mm<10) mm="0"+mm;

		var wp = window.parent;
		var divParent = wp.document.getElementById('<%= sDivToHidde %>');
		
		divParent.style.display = 'none';
		divParent.style.visibility = "hidden";
		
		var divDate = wp.document.getElementById('<%= sDateFieldName %>');
		divDate.value = jj+"/"+mm+"/"+aaaa;;
		
		
	}
	
	function recharger(){
		document.calend.submit();
	}
</script>
<title>Calendrier</title>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<form name="calend" method="post"> 
		<input type="hidden" name="name" value="Cal<%=sDivToHidde%>" />
<% 
	Timestamp tsDateAujourdhui = new Timestamp(System.currentTimeMillis());
	Calendar calendrier = Calendar.getInstance();
	String sDateString = CalendarUtil.getDateCourte(tsDateAujourdhui);
	String sDateMaintenant[] = sDateString.split("/");
	int jour=0,mois=0,annee=0;

	if ( (request.getParameter("mois") == null 
	|| request.getParameter("mois").equalsIgnoreCase("") ) )
	{
		mois = Integer.parseInt(sDateMaintenant[1]);
	}
	else 
	{
		mois = Integer.parseInt(request.getParameter("mois"));
	}
	if (request.getParameter("annee") == null 
	|| request.getParameter("annee").equalsIgnoreCase("")) 
	{ 
		annee = Integer.parseInt(sDateMaintenant[2]);
	}
	else 
	{
		annee = Integer.parseInt(request.getParameter("annee"));
	}
	
	if (request.getParameter("jour") == null  
	|| request.getParameter("jour").equalsIgnoreCase("")) 
	{ 
		jour = Integer.parseInt(sDateMaintenant[0]);
	}
	else 
	{
		jour = Integer.parseInt(request.getParameter("jour"));
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
<table border="0"> 
    <tr bgcolor="#2361AA"> 
      <td> 
<%
 if(mois == 1) {
%>
<a href="calendar2.jsp?annee=<%=annee - 1%>&amp;mois=12&jour=<%=jour%>&amp;sDivToHidde=<%=sDivToHidde%>&amp;sDateFieldName=<%=sDateFieldName%>"><font color="#ff8c00"><strong>&lt;&lt;</strong></font></a>
<%
 }
 else {
%>
<a href="calendar2.jsp?annee=<%=annee%>&amp;mois=<%=mois-1%>&jour=<%=jour%>&amp;sDivToHidde=<%=sDivToHidde%>&amp;sDateFieldName=<%=sDateFieldName%>"><font color="#ff8c00"><strong>&lt;&lt;</strong></font></a>
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
		<a href="calendar2.jsp?annee=<%=annee+1%>&amp;mois=1&jour=<%=jour%>&amp;sDivToHidde=<%=sDivToHidde%>&amp;sDateFieldName=<%=sDateFieldName%>"><font color="#ff8c00"><strong>&gt;&gt;</strong></font></a>
<%
	}
	else{
%>
		<a href="calendar2.jsp?annee=<%=annee%>&amp;mois=<%=mois + 1%>&jour=<%=jour%>&amp;sDivToHidde=<%=sDivToHidde%>&amp;sDateFieldName=<%=sDateFieldName%>"><font color="#ff8c00"><strong>&gt;&gt;</strong></font></a>
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
    <tr border="2" align="center" bordercolor="#ff8c00">
<%
   j = 1;
  }

 }else{
  j++;
 }
}
	for(int i=j;i<=7;i++){ 
%>
	<td border="2" align="center" bordercolor="#ff8c00">&nbsp;</td>
<%
	}
%>
	</tr>
</table>
</form>
</body>
</html>