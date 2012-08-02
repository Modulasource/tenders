package org.coin.util;

import java.util.Collection;
import java.util.LinkedList;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

/**
 * Tiny MultiMap
 * 
 * @author Juan José A. Paz
 *
 * @param <Key>
 * @param <Value>
 */
public class MultiMap <Key, Value> {
	Map <Key, LinkedList <Value>> map = new TreeMap <Key, LinkedList <Value>> ();
	
	public MultiMap <Key, Value> put (Key key, Value value){
		LinkedList <Value> list = map.get(key);
		if (list == null){
			list = new LinkedList <Value> ();
			map.put (key, list);
		}
		list.add(value);
		return this;
	}
	
	public MultiMap <Key, Value> insertTo (Collection <Value> collection){
		for (LinkedList <Value> list : map.values ())
			collection.addAll (list);
		return this;
	}
	
	public Vector <Value> toVector (){
		Vector <Value> vOrdered = new Vector <Value> ();
		insertTo (vOrdered);
		return vOrdered;
	}
	
	public Collection <LinkedList <Value>> getValues (){
		return map.values ();
	}
}
