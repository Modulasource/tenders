<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.fqr.*,java.util.*,modula.marche.*" %>
<%
	String sIdAffaire = null;
	Marche marche = null;
	int iIdAffaire;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire);
	marche = Marche.getMarche(iIdAffaire );
	
	String sTitle = "Toutes les questions de la FQR"; 
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<div style="text-align:right">
<button type="button" onclick="javascript:window.print();" >Imprimer</button>
</div>
<br />
<%
	FQR oTypeQR = new FQR(); 
	Vector vListeTypeQR = oTypeQR.getListeTypeQuestion() ;
	FQRTypeQuestion oListeTypeQR ;
	
	for(int k = 0; k < vListeTypeQR.size();k++)
	{
		oListeTypeQR = (FQRTypeQuestion)vListeTypeQR.elementAt(k);
		int iIdTypeQuestion = oListeTypeQR.getIdTypeQuestion() ;
		String sIdTypeQuestion = Integer.toString(iIdTypeQuestion) ;
		String sTypeQuestion = oListeTypeQR.getTypeQuestion() ;
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Catégorie : <%= sTypeQuestion%></td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" >
	<%
		FQR FQRter = new FQR(iIdAffaire) ;
		Vector CoupleQRter = new Vector() ;
		CoupleQRter = FQRter.getCoupleQR("2", sIdTypeQuestion) ;  
		FQRCoupleQR oCoupleter ;
		
		for (int j=0 ; j<CoupleQRter.size() ; j++){
			oCoupleter = (FQRCoupleQR)CoupleQRter.elementAt(j) ;
			int iIdCoupleQRter = oCoupleter.getIdCoupleQR() ;
			String sTitreter = oCoupleter.getTitreQuestion() ;
			String sQuestion = oCoupleter.getQuestion();
			String sReponse = oCoupleter.getReponseQuestion();
	%>
				<tr class="liste<%=j%2%>"
                 onmouseover="className='liste_over'" 
                 onmouseout="className='liste<%=j%2%>'" >
					<td style="text-align:left">
						<%=sQuestion%>
							<ul type="square">
								<li><%=sReponse%></li>
							</ul>
						
					</td>
				</tr>
	<%
		}
	%>
			</table>
		</td>
	</tr>
</table>
<br />
<%
}
%>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>