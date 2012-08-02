package org.coin.db;

import java.util.Vector;

import org.coin.db.CoinDatabaseAbstractBean;

public class AbstractBeanArray {
	public CoinDatabaseAbstractBean[][] table;
	public Vector<CoinDatabaseAbstractBean> vBeanAllreadyPlaced;
	public int iCurrentRow = 0;
	public int iCurrentColumn = 0;
	public int iMaxRow =0 ;
	public int iMaxColumn = 0;

	public void setAtCurrentPosition(CoinDatabaseAbstractBean bean) {
		
		//System.out.println("setAtCurrentPosition" + bean.getName());
		
		if(!isAllReadyPlaced(bean))
		{
			this.table[this.iCurrentRow] [this.iCurrentColumn] = bean;
			this.vBeanAllreadyPlaced.add(bean);
			
			/*
			System.out.println("placed at : iCurrentRow=" + this.iCurrentRow 
					+ " iCurrentColumn" + this.iCurrentColumn);
					*/
		}
		else
		{
			System.out.println("WARNING bean " + bean.getId() + " allready placed !");
		}

		if(this.iCurrentRow>this.iMaxRow) this.iMaxRow = this.iCurrentRow;
		if(this.iCurrentColumn>this.iMaxColumn) this.iMaxColumn = this.iCurrentColumn;


	}


	public boolean isAllReadyPlaced(CoinDatabaseAbstractBean bean) {

		boolean bPlaced = false;

		for (int i = 0; i < this.vBeanAllreadyPlaced.size(); i++) {
			if(bean.getId() == this.vBeanAllreadyPlaced.get(i).getId())
				return true;
		}

		return bPlaced;

	}
	public AbstractBeanArray(int iSizeRow, int iSizeColumn) {
		this.table = new  CoinDatabaseAbstractBean[iSizeRow][iSizeColumn];
		this.vBeanAllreadyPlaced = new Vector<CoinDatabaseAbstractBean>();
	}

	public Vector<CoinDatabaseAbstractBean> getUnplacedBean(Vector<CoinDatabaseAbstractBean> vBean) {
		Vector<CoinDatabaseAbstractBean> vBeanUnplaced
			= new Vector<CoinDatabaseAbstractBean>();


		for (int i = 0; i < vBean.size(); i++) {
			CoinDatabaseAbstractBean bean = vBean.get(i) ;
			if( !isAllReadyPlaced( bean ) )
			{
				vBeanUnplaced.add(bean);
			}
		}
		return vBeanUnplaced ;

	}

	public void addUnplacedBean(Vector<CoinDatabaseAbstractBean> vBean) {
		Vector<CoinDatabaseAbstractBean> vBeanUnplaced
			= getUnplacedBean(vBean);

		if(vBeanUnplaced.size() == 0 )
			return;

		// on saute une ligne pour dire que c'est les non placés
		this.iCurrentRow ++;

		for (int i = 0; i < vBeanUnplaced.size(); i++) {
			CoinDatabaseAbstractBean bean = vBean.get(i) ;
			this.iCurrentRow ++;
			this.iCurrentColumn = 0;

			setAtCurrentPosition(bean);

		}

	}


}
