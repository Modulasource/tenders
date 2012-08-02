<%@page import="org.coin.bean.accountancy.Currency"%>

<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveGestionLotsTitre = "Gestion des lots";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());

%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveGestionLots.jspf" %>
<%
if(vLots != null )
{
	if(vLots.size() > 1)
	{
		for (int i = 0; i < vLots.size(); i++)
		{
						
			MarcheLot lot = vLots.get(i);

			String sPaveDefinitionLotsTitre = "Description du lot " + lot.getNumero();
			sFormPrefix = "";
			
			
			MarcheLotDetail marcheLotDetail = null;
			try {
				marcheLotDetail = MarcheLotDetail.getMarcheLotDetailFormIdMarcheLot(lot.getId());
			} catch (Exception e) {
				marcheLotDetail = new MarcheLotDetail();
			}
			
			Currency currency = null;
			try {
				currency = Currency.getCurrency(marcheLotDetail.getIdCurrencyCoutEstime());
			} catch (Exception e) {
				currency = new Currency ("EUR");
			}
			
			
			%>
			<%@ include file="paveCreationLots.jspf" %>
			<%
				String sPaveNomenclatureLotTitre = "Nomenclature du lot " + lot.getNumero();
				sFormPrefix = "";
			%>
			<%@ include file="paveNomenclatureLots.jspf" %>
			<%
		}			
	}
}
%>
