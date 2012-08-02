package org.coin.db;

import java.util.Comparator;

import org.coin.util.StringUtilBasic;




public class CoinDatabaseAbstractBeanComparator implements Comparator<Object> {

	public static final int ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING = 1;
	public static final int ORDERBY_LEXICOGRAPHIC_NAME_DESCENDING = 2;
	public static final int ORDERBY_LEXICOGRAPHIC_ID_ASCENDING = 3;
	public static final int ORDERBY_LEXICOGRAPHIC_ID_DESCENDING = 4;
	
	public int iOrderBy  ;
	
	public CoinDatabaseAbstractBeanComparator() {
		super();
		this.iOrderBy = ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING ;
	}
	
	public CoinDatabaseAbstractBeanComparator(
			int iOrderBy)
	{
		this.iOrderBy = iOrderBy;
	}
	
	public int compare(Object o1, Object o2) {
		CoinDatabaseAbstractBean a1 = (CoinDatabaseAbstractBean)o1;
		CoinDatabaseAbstractBean a2 = (CoinDatabaseAbstractBean)o2;
		
		int ret = 0;
		switch(this.iOrderBy)
		{
		case ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING:
		case ORDERBY_LEXICOGRAPHIC_NAME_DESCENDING:
			ret = StringUtilBasic.stripAccents(a1.getName())
				.compareTo(StringUtilBasic.stripAccents(a2.getName()));
			if(iOrderBy == ORDERBY_LEXICOGRAPHIC_NAME_DESCENDING)
				ret = -ret;
			break;
		case ORDERBY_LEXICOGRAPHIC_ID_ASCENDING:
		case ORDERBY_LEXICOGRAPHIC_ID_DESCENDING:
			ret = StringUtilBasic.stripAccents(a1.getIdToString())
				.compareTo(StringUtilBasic.stripAccents(a2.getIdToString()));
			if(iOrderBy == ORDERBY_LEXICOGRAPHIC_ID_DESCENDING)
				ret = -ret;
			break; 		
		}

		return ret;
	}

}
