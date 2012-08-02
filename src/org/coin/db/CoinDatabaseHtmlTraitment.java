package org.coin.db;

import java.util.Vector;


public class CoinDatabaseHtmlTraitment {
	
	public Object context1;
	public Object context2;
	public Object context3;
	public String sDisable = "";
	public String sTdRightEndItem = "";
	public String sTdLeftStyle = " style='text-align:right;vertical-align:top;' ";
	public String sTdRightStyle = " style='text-align:left' ";
			
	public boolean bItemCheckedDefautValue = true;
	public int iColumn= 1;
	public boolean bDisplayId = false;
	public boolean bIsForm = true;
	public boolean bDisplayItemUnchecked = true;
	public double dFactorItemCheckbox = 0.15; 
	
	public CoinDatabaseHtmlTraitment() {
		
	}
	
	public boolean isItemChecked(CoinDatabaseAbstractBean item)
	{
		return bItemCheckedDefautValue;
	}
	
	public String getHtmlTableInput(
			Vector<CoinDatabaseAbstractBean> vBeans, 
			String sFormSelectName, 
			String sInputType)
	{
		return getHtmlTableInput(vBeans, sFormSelectName, sInputType, iColumn, true);
	}
	
	
	public String getHtmlTableInput(
			Vector<CoinDatabaseAbstractBean> vBeans, 
			String sFormSelectName, 
			String sInputType,
			int iColumn)
	{
		return getHtmlTableInput(vBeans, sFormSelectName, sInputType, iColumn, true);
	}
	
	
	public String getHtmlTableInput(
			Vector<CoinDatabaseAbstractBean> vBeans, 
			String sFormSelectName, 
			String sInputType,
			int iColumn,
			boolean bDisplayId)
	{
		StringBuffer sbListe = new StringBuffer ("");
		sbListe.append("<table width='100%' >\n<tr>");
		
		/**
		 * Pour que les colonnes aient toutes la même taille
		 */
		int iWidth = 50 / iColumn;
		
		
		for(int i=0; i < vBeans.size() ; i++)
		{
			CoinDatabaseAbstractBean item = vBeans.get(i);
			String sChecked = "";
			if(isItemChecked(item))
			{
				sChecked = " checked='checked' ";
			} else {
				if(!bDisplayItemUnchecked && !bIsForm) continue;
			}
			
			sbListe.append("<td "+ sTdLeftStyle + " width='" + (iWidth * (dFactorItemCheckbox)) +  "%' >");
			
			sbListe.append("<input name='");
			sbListe.append(sFormSelectName + "_" + item.getId());
			sbListe.append("' ");
			sbListe.append(sChecked);
			if(this.bIsForm)
			{
				sbListe.append(this.sDisable);
			} else {
				sbListe.append(" disabled='disabled' ");
			}
			sbListe.append(" type='");
			sbListe.append(sInputType);
			sbListe.append("' />");
			
			sbListe.append("</td>");
			sbListe.append("<td "+ sTdRightStyle + " width='" + (iWidth * (1 - dFactorItemCheckbox)) +  "%'>");
			onDisplayName(sbListe, item);
			sbListe.append(sTdRightEndItem +  "</td>");

			if( ((i+1) % iColumn) == 0 )
			{
				// un saut de ligne
				sbListe.append("</tr>\n<tr>");
			}
		}
		sbListe.append("</tr>\n</table>\n");

		return sbListe.toString();
	}

	public void onDisplayName(StringBuffer sbListe, CoinDatabaseAbstractBean item) {
		if(this.bDisplayId) sbListe.append(item.getId() + " - " );
		sbListe.append(item.getName() );

	}
}
