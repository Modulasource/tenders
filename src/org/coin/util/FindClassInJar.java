package org.coin.util;

import java.io.File;
import java.net.URL;
import java.net.URLClassLoader;

public class FindClassInJar {
	
	
	public static void main(String[] args) {
		//String sClass= "org.jfree.chart.ChartFactory";
		//String sClass= "org.apache.tomcat.util.http.fileupload.FileItem";
		String sClass= "com.google.common.base.Function";
		

		//String sPath = "D:\\application\\apache-tomcat-6.0.24\\logs\\old_lib";
		//String sPath = "D:\\application\\apache-tomcat-6.0.24\\lib";
		String sPath = "D:\\application\\tomcat\\lib";
		
		System.out.println("Class to find : " + sClass);
		
		findClass(sClass, sPath);
	}
	
	@SuppressWarnings("rawtypes")
	public static void findClass(
			String sClass,
			String sPath) 
	{
		File path = new File(sPath);
		File[] ff = path.listFiles();
		//if(ff != null)
		for (File file : ff) {
			if(file.isDirectory()){
				findClass(sClass, file.getAbsolutePath());
			} else if(file.getName().endsWith(".jar"))
			{
				boolean bFound = false;
				try {
					//System.out.println("look in : " + file);
					URLClassLoader child = new URLClassLoader (new URL[]{file.toURI().toURL()}, null);
					Class classToLoad = Class.forName (sClass, false, child);
					if(classToLoad != null) bFound = true;
					//URL u = child.findResource(sClass);
					//if(u != null) bFound = true;
				} catch (Exception e) {
					//e.printStackTrace();
				} catch (Error e) {
					e.printStackTrace();
				}
				if(bFound){
					System.out.println(file + ": [FOUND]");
				}
			}
		}
	}
}
