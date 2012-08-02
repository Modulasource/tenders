package org.coin.core;

import java.io.File;
import java.io.IOException;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.util.StringUtil;
import org.coin.util.FileUtil;
import org.coin.util.Outils;


public class WarGenerator {
	protected String sFilenameInputWar;
	protected String sFilenameOuputWar;
	protected File fileTempDir;
	protected Vector<String> vClassList;
	protected Vector<String> vPackageList;
	protected Vector<String> vWebContentList;

	public WarGenerator() {
		this.vClassList = new Vector<String>();
		this.vPackageList = new Vector<String>(); 
		this.vWebContentList = new Vector<String>();
	}
	
	public void setInputWar(
			String sFilename) 
	{
		this.sFilenameInputWar = sFilename;
	}

	public void setOutputWar(
			String sFilename) 
	{
		this.sFilenameOuputWar = sFilename;
	}

	public static void main(String[] args) throws IOException {
		
		WarGenerator  wg = new WarGenerator();
		wg.setInputWar("d:\\modula_dev.war");
		wg.setOutputWar("d:\\modula_core.war");

		wg.addPackage("org.coin.bean");
		wg.addClass("org.coin.fr.bean.Organisation");
		wg.addWebContent("/test/*");
		//wg.addWebContent("/test/plotr/assets/*");
		

		
		wg.generate();
	}

	public void generate() throws IOException {
		
		/**
		 * prepare temp dir
		 */
		this.fileTempDir = FileUtil.getTempDirFile();
		File fileSubDirInput = new File(fileTempDir.getAbsolutePath() 
				+ "/" + "WarGenerator_" + System.currentTimeMillis());
		
		File fileSubDirOutput = new File(fileTempDir.getAbsolutePath() 
				+ "/" + "WarGenerator_" + System.currentTimeMillis());

		//fileSubDirOutput.mkdir();
		//fileSubDirInput.mkdir();

		fileSubDirInput = new File("C:\\Users\\david\\AppData\\Local\\Temp\\WarGenerator_1246980167672");
		fileSubDirOutput = new File("C:\\Users\\david\\AppData\\Local\\Temp\\WarGenerator_1246980185097");
		
		
		/**
		 * unzip  war
		 */
		System.out.println("Unzip in : " + fileSubDirInput);
		//ZipUtils.unzipArchive(new File(this.sFilenameInputWar), fileSubDirInput);

		System.out.println("Prepare dir : " + fileSubDirOutput);

		copyStringList(fileSubDirInput, fileSubDirOutput, this.vWebContentList);
		copyStringList2(fileSubDirInput, fileSubDirOutput, this.vClassList);
		
	}

	public static void copyStringList(
			File fileSubDirInput ,
			File fileSubDirOutput,
			Vector<String> vStringList) 
	{
		for (String sWebContent : vStringList) {
			String in = fileSubDirInput + sWebContent;
			String out = fileSubDirOutput + sWebContent;
			System.out.println("Copy : " + in + "\n  to : " + out);
			try{
				FileUtil.copyDirectory(
						in,
						out,
						true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void copyStringList2(
			File fileSubDirInput ,
			File fileSubDirOutput,
			Vector<String> vStringList) 
	{
		
		for (String sClassName : vStringList) {
			
			/**
			 * sClassName = <package>.<package>.<className>
			 */
			int iIndex = sClassName.lastIndexOf(".");
			String sPackageName =  null;
			String sName = null;
			if(iIndex > 0){
				sPackageName =  StringUtils.replace(sClassName.substring(0,iIndex ), ".", "/") + "/";
				sName = sClassName.substring(iIndex + 1, sClassName.length()) + ".class";
			} else {
				sPackageName =  "";
				sName = sClassName;
			}
			String in = fileSubDirInput + "/WEB-INF/classes/" + sPackageName + sName;
			String out = fileSubDirOutput + "/WEB-INF/classes/" + sPackageName ;
			System.out.println("Copy : " + in + "\n  to : " + out);
			try{
				FileUtil.copyDirectory(
						in,
						out,
						false);
						
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}


	
	public void addWebContent(String sWebContent) {
		this.vWebContentList.add(sWebContent);
	}

	public void addClass(String sClassName) {
		this.vClassList.add(sClassName);
	}

	public void addPackage(String sPackageName) {
		this.vPackageList.add(sPackageName);
	}

}
