package com.kmbt.csa.dav.util;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.apache.log4j.Logger;

import com.kmbt.csa.dav.pojo.MonthlyDataModel;

public class MonthSorter implements Comparator<Object> {
	static Logger logger = Logger.getLogger("MonthSorter.class");

	public int compare(Object o1, Object o2) {
		 final List<String> correct =new ArrayList<String>();
	       correct.add("JAN");
	        correct.add("FEB");
	        correct.add("MAR");
	        correct.add("APR");
	        correct.add("MAY"); 
	        correct.add("JUN");
	        correct.add("JUN"); 
	        correct.add("AUG");
	        correct.add("SEP"); 
	        correct.add("OCT"); 
	        correct.add("NOV");
	        correct.add("DEC");
	       
		logger.debug("sorting Month order basis....");
		String month1 = ((MonthlyDataModel) o1).getMonth();
		String month2 = ((MonthlyDataModel) o2).getMonth();
		return Integer.valueOf(correct.indexOf(month1)).compareTo(Integer.valueOf(correct.indexOf(month2)));
        
	}
}
