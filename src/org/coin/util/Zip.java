package org.coin.util;

import java.util.zip.*;
import java.util.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Zip
{
	//Nom du fichier
	private String fichier;
	//Liste des fichiers contenus dans le zip
	@SuppressWarnings("unchecked")
	private Vector<ZipEntry> liste=new Vector();
	private static final char separ=File.separatorChar;
	public static final int placeNom=0;

	public static final int placeTaille=1;

	public static final int placeCompression=2;

	public static final int placeDate=3;

	public static final int placeCommentaire=4;

	public Zip(String fichier) throws Exception
	{
		this.fichier=fichier;
		File f=new File(fichier);
		if(f.exists())
			f.delete();
	}

	public void setNom(String nom)
	{
		fichier=nom;
	}

	public static Vector<String> getTitre()
	{
		Vector<String> titre=new Vector<String>();
		titre.addElement("Nom");
		titre.addElement("Taille");
		titre.addElement("Compression");
		titre.addElement("Date");
		titre.addElement("Commentaire");
		return titre;
	}

	public Vector<Vector<String>> contenu()
	{
		int nb=liste.size();
		Vector<Vector<String>> donnees=new Vector<Vector<String>>();
		for(int i=0;i<nb;i++)
		{
			Vector<String> ligne=new Vector<String>();
			ZipEntry entre=(ZipEntry)liste.elementAt(i);
			ligne.addElement(entre.getName());
			ligne.addElement(""+entre.getSize());
			long j=entre.getCompressedSize();
			if(j>=0)
				ligne.addElement(""+j);
			else
				ligne.addElement("");
			Date date=new Date(entre.getTime());
			Calendar calendrier=Calendar.getInstance();
			calendrier.setTime(date);
			ligne.addElement(
					calendrier.get(Calendar.HOUR_OF_DAY)+"h"+
					calendrier.get(Calendar.MINUTE)+"m"+
					calendrier.get(Calendar.SECOND)+"s le "+
					calendrier.get(Calendar.DAY_OF_MONTH)+"/"+
					calendrier.get(Calendar.MONTH)+"/"+
					calendrier.get(Calendar.YEAR));
			ligne.addElement(entre.getComment());
			donnees.addElement(ligne);
		}
		return donnees;
	}

	public String get(int place,int numero)
	{
		ZipEntry entre=(ZipEntry)liste.elementAt(numero);
		switch(place)
		{
		case placeCommentaire :
			return entre.getComment();
		case placeCompression :
			long j=entre.getCompressedSize();
			if(j>=0)
				return ""+j;
			return "";
		case placeDate :
			Date date=new Date(entre.getTime());
			Calendar calendrier=Calendar.getInstance();
			calendrier.setTime(date);
			return calendrier.get(Calendar.HOUR_OF_DAY)+"h"+
				calendrier.get(Calendar.MINUTE)+"m"+
				calendrier.get(Calendar.SECOND)+"s le "+
				calendrier.get(Calendar.DAY_OF_MONTH)+"/"+
				calendrier.get(Calendar.MONTH)+"/"+
				calendrier.get(Calendar.YEAR);
		case placeNom :
			return entre.getName();
		case placeTaille :
			return ""+entre.getSize();
		}
		return "";
	}

	public void ajouteFichier(File fichier)
	{
		ajouteFichier(fichier,null);
	}

	public void ajouteFichier(File fichier,String commentaire)
	{
		ZipEntry entre=new ZipEntry(fichier.getName());
		entre.setSize(fichier.length());
		entre.setTime(fichier.lastModified());
		if(commentaire!=null)
			entre.setComment(commentaire);
		liste.addElement(entre);
	}

	public void retire(File fichier)
	{
		String s=fichier.getAbsolutePath().substring(3).replace(separ,'/').toUpperCase();
		int rang=-1;
		int nb=liste.size();
		for(int i=0;(i<nb)&&(rang<0);i++)
		{
			ZipEntry entre=(ZipEntry)liste.elementAt(i);
			if(entre.getName().toUpperCase().equals(s))
				rang=i;
		}
		if(rang>=0)
			liste.removeElementAt(rang);
	}

	public int getNombreFichier()
	{
		return liste.size();
	}

	public void retire(int numero)
	{
		liste.removeElementAt(numero);
	}

	public void ziper() throws Exception
	{
		File f=new File(fichier);
		if(!f.exists())
			f.createNewFile();
		ZipOutputStream zos=new ZipOutputStream(new FileOutputStream(fichier));
		int nb=liste.size();
		for(int i=0;i<nb;i++)
		{
			ZipEntry entre=(ZipEntry)liste.elementAt(i);
			String nom=entre.getName();
			zos.putNextEntry(entre);
			FileInputStream fis=new FileInputStream(nom);
			byte[] tab=new byte[4096];
			int lu=-1;
			do
			{
				lu=fis.read(tab);
				if(lu>0)
					zos.write(tab,0,lu);
			}while(lu>0);
			//Fermer l'entrée
			fis.close();
		}
		zos.flush();
		zos.close();
	}

	public static void inflate(String sPathToInflate, String sZipFile) 
	throws IOException 
	{
	    ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(sZipFile)); 
	    inflateRecusive(sPathToInflate, "", zos); 
	    zos.close(); 		
	}
	
	public static void inflateRecusive(
			String sRootPath,
			String sPathToInflate, 
			ZipOutputStream zos) 
	throws IOException 
	{ 
		File zipDir;
		zipDir = new File(sRootPath); 
		String[] dirList = zipDir.list(); 
		byte[] readBuffer = new byte[2156]; 
		int bytesIn = 0; 
		if(dirList == null) return;
		for(int i=0; i<dirList.length; i++) 
		{ 
			File f = new File(zipDir, dirList[i]); 
			if(f.isDirectory()) 
			{ 
				String filePath = f.getPath(); 
				
				String sPathToInflateTemp ;
				if(!sPathToInflate.equals("")) sPathToInflateTemp = sPathToInflate+"/"+f.getName();
				else sPathToInflateTemp = f.getName();
				
				/**
				 * Recursive
				 */
				inflateRecusive(filePath, sPathToInflateTemp,  zos); 
				continue; 
			} 
			FileInputStream fis = new FileInputStream(f); 
			ZipEntry anEntry = new ZipEntry(sPathToInflate + "/" +  f.getName()); 
			zos.putNextEntry(anEntry); 
			while((bytesIn = fis.read(readBuffer)) != -1) 
			{ 
				zos.write(readBuffer, 0, bytesIn); 
			} 
			fis.close(); 
		} 
	} 

	
	
	public static void implode(String srcFolder, String zipFile) throws IOException {
		implode(new File(srcFolder),new File(zipFile));
	}

	public static void implode(File srcFolder, File zipFile) throws IOException {
		ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipFile));
		try{
			File f[] = srcFolder.listFiles();
			for(int i=0;i<f.length;i++){
				CRC32 crc = new CRC32();
				byte buffer[] = new byte[(int)f[i].length()];
				FileInputStream fis = new FileInputStream(f[i]);
				fis.read(buffer);
				crc.update(buffer);           
				ZipEntry ze = new ZipEntry(f[i].getName());
				ze.setCrc(crc.getValue());
				ze.setSize(buffer.length);
				ze.setTime(f[i].lastModified());
				zos.putNextEntry(ze);
				zos.write(buffer);
			}
		}finally{
			zos.close();
		}
	}
	public void deziper(File dossier) throws Exception
	{
		ZipInputStream zis=new ZipInputStream(new FileInputStream(fichier));
		ZipEntry ze=zis.getNextEntry();
		while(ze!=null)
		{
			File f=new File(dossier.getAbsolutePath()+separ+ze.toString().replace('/',separ));
			f.getParentFile().mkdirs();
			FileOutputStream fos=new FileOutputStream(f);
			int lu=-1;
			byte[] tampon=new byte[4096];
			do
			{
				lu=zis.read(tampon);
				if(lu>0)
					fos.write(tampon,0,lu);
			} while(lu>0);
			fos.flush();
			fos.close();
			ze=zis.getNextEntry();
		}
		zis.close();
	}

	public void setCommentaire(int numero,String commentaire)
	{
		ZipEntry entre=(ZipEntry)liste.elementAt(numero);
		entre.setComment(commentaire);
	}
}