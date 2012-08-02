package org.coin.signature.pdf;


import org.coin.signature.sspv.shape.SSPVTextShape;

import org.coin.util.FileUtilBasic;
import org.coin.util.image.CoinImageUtil;
import org.coin.util.pdf.pdfbox.PdfBoxImageUtil;
import org.coin.util.pdf.pdfbox.PdfBoxTextUtil;
import org.coin.util.pdf.pdfbox.PdfBoxUtil;
import org.coin.util.pdf.pdfbox.TextLocation;
import org.coin.util.pdf.pdfbox.TextLocationCreateArray;


import org.apache.pdfbox.exceptions.CryptographyException;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageNode;
import org.apache.pdfbox.pdmodel.common.PDStream;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDTrueTypeFont;
import org.apache.pdfbox.pdmodel.graphics.xobject.PDJpeg;
import org.apache.pdfbox.pdmodel.graphics.xobject.PDXObjectImage;
import org.apache.pdfbox.util.TextPosition;

import java.awt.print.PageFormat;
import java.io.File;
import java.io.IOException;

import java.util.Properties;
import java.util.Vector;


/**
 * 
 * @author David KELLER / Studio Matamore
 * 
 */
public class TextLocationFillSignature extends TextLocationCreateArray
{

	protected Vector<Signature> vSignature;
	protected Signature signatureCurrent;
	protected int iIndexCurrent ;
	
	public boolean bUseScannedSignatureRatioSignature;
	public double dScannedSignatureRatioSignature;
	public boolean bUseScannedSignatureRatioCell;
	public double dScannedSignatureRatioCell;
	

	

	public static final int MAX_SIGNATURE = 50;
	/**
	 * Default constructor.
	 * 
	 * @throws IOException If there is an error loading text stripper properties.
	 */
	public TextLocationFillSignature() throws IOException
	{
		this.vSignature = new Vector<Signature>();
		super.setSortByPosition( true );
	}

	public TextLocationFillSignature(
			Properties props) 
	throws IOException
	{
		super(props);
		super.setSortByPosition( true );
		this.vSignature = new Vector<Signature>();
	}


	

	public void addSignature(Signature signature) {
		this.vSignature.add(signature);
	}

	/**
	 * Callback to override
	 * 
	 * @param textStart
	 * @param textEnd
	 * @throws IOException 
	 */
	protected void onFoundText( 
			TextPosition textStart,
			TextPosition textEnd) 
	throws IOException
	{
		PageFormat pageFormat = PdfBoxUtil.getPageFormat(this.pageCurrent);
		//double dPageHeight = pageFormat.getHeight();
		double dPageWidth = pageFormat.getWidth();
		double[] xy = PdfBoxTextUtil.getTextPositionXY(textStart, page);
		double x = xy[0];
		double y = xy[1];
		
		
		double dCellSizeX = getCellSizeX(dPageWidth);
		double dCellSizeY = getCellSizeY(y);
		
		
		
		
		PDXObjectImage ximage =  new PDJpeg(this.document, this.signatureCurrent.biScannedSignature );
		//PDXObjectImage ximage =  new PDPixelMap (this.document,ImageToolKit.getImageWhiteTransparency(this.signatureCurrent.biScannedSignature) );
		//PDXObjectImage ximage =  new PDJpeg (this.document,ImageToolKit.getImageWhiteTransparency(this.signatureCurrent.biScannedSignature) );
		

		/**
		 * Set the ratio of the image
		 */
		double dRatio = 1f;
		if(this.bUseScannedSignatureRatioSignature) dRatio =  this.dScannedSignatureRatioSignature;
		if(this.bUseScannedSignatureRatioCell) dRatio 
			=  (dCellSizeX * this.dScannedSignatureRatioCell) / ximage.getWidth() ;

		/**
		 * print the image in underlay mode
		 */

		this.pageUnderlay = new PDPage();
		PDPageNode rootPages = document.getDocumentCatalog().getPages();
		this.pageUnderlay.setParent(rootPages);
		this.pageUnderlay.setContents(new PDStream( document ));
		
		
		PDPageContentStream contentStream = new PDPageContentStream(this.document, this.pageCurrent, true, true);
		double width = ximage.getWidth() * dRatio;
		double height = ximage.getHeight() * dRatio; 
		
		/*
		PDPageContentStream contentStreamUnderlay = new PDPageContentStream(this.document, this.pageUnderlay, true, true);
		String objMapping = contentStream.addXObject(ximage);
		contentStreamUnderlay.setXObjectMapping(ximage, objMapping);
		contentStreamUnderlay.addXObject(ximage);
		
		PdfUtil.drawImage(
				this.pageUnderlay, 
				contentStreamUnderlay , 
				x + fCellSizeX - (ximage.getWidth() * fRatio) - 10, 
				y - fCellSizeY + 10, 
				width,
				height,
				objMapping, 
				fRatio);
		
		contentStreamUnderlay.close();
		*/
		String objMapping = contentStream.addXObject(ximage);
		
		PdfBoxImageUtil.drawImage(
				this.pageUnderlay, 
				contentStream , 
				x + dCellSizeX - (ximage.getWidth() * dRatio) - 10, 
				y - dCellSizeY + 30, 
				width,
				height,
				objMapping);
		
		/**
		 * Print the message
		 */
		String[] sarrMsg = this.signatureCurrent.sMessage.split("\n");
		double dHeight = 0;
		
		for (int i = 0; i < sarrMsg.length; i++) {
			String string = sarrMsg[i];
			//string = Outils.sansAccent(string);
			
			/**
			 * Need to insert line feed, if the text is to long
			 */
			String[] tokens = string.split(" ");
			String curString = tokens[0];
			for (int j = 1; j < tokens.length; j++) {
				String sTemp = curString;
				curString += " " + tokens[j];
				curString = curString.trim();
				
				double dCurrentSize =  PdfBoxTextUtil.getStringWidth(this.fontDefaultFont, curString) ;

				if(dCurrentSize  > dCellSizeX)
				{
					double dStringWidth =  PdfBoxTextUtil.getStringWidth(this.fontDefaultFont, sTemp) ;

					double dOffsetX 
						= PdfBoxTextUtil.getTextCellOffsetX(
							dCellSizeX, 
							this.signatureCurrent.iTextAlign, 
							dStringWidth);
					
					drawText(
							sTemp, 
							contentStream, 
							x + dOffsetX, 
							y - dHeight);
				
					dHeight += this.dDefaultFontSize ;
					curString = tokens[j];
				} 
			}
			/**
			 * Flush the end
			 */
			if(!curString.equals(""))
			{
				double dStringWidth =  PdfBoxTextUtil.getStringWidth(this.fontDefaultFont, curString) ;

				double dOffsetX 
					= PdfBoxTextUtil.getTextCellOffsetX(
						dCellSizeX, 
						this.signatureCurrent.iTextAlign, 
						dStringWidth);

				drawText(
						curString, 
						contentStream, 
						x + dOffsetX, 
						y - dHeight);
			}
			
			
			/**
			 * next line
			 */
			dHeight += this.dDefaultFontSize ;
			
		}
		
		contentStream.close();
		
		
		
		
		
		/**
		 * Update page stream, TODO .. marche pas :( !!
		 */
		
		/*
		PDStream updatedStream = new PDStream(this.document);
		OutputStream out = updatedStream.createOutputStream();
		ContentStreamWriter tokenWriter = new ContentStreamWriter(out);
		
		List pageTokens = null ;
		PDStream pdStream = this.pageCurrent.getContents();
		pageTokens = pdStream.getStream().getStreamTokens();
		if(this.pageUnderlay != null)
		{
			PDStream pdStreamUnderlay = this.pageUnderlay.getContents();
			//tokenWriter.writeTokens(pdStreamUnderlay.getStream().getStreamTokens());
			//pageTokens = pdStreamUnderlay.getStream().getStreamTokens();
			pageTokens.addAll(pdStreamUnderlay.getStream().getStreamTokens());
		} 
		
		//this.pageTokens = pdStream.getStream().getStreamTokens();
		
		tokenWriter.writeTokens(pageTokens );

		updatedStream.addCompression();
		page.setContents( updatedStream );
		*/
	}
	
	
	
	
	public void replaceAllSignature() 
	throws IOException, CryptographyException {
		findLastIndexSignature();
		this.bResetOccurrence = true;
		
		for (Signature signature : this.vSignature) {
			this.signatureCurrent = signature;
			
			String sKeyWord = getIndexName(this.iIndexCurrent) ;
			locateText(sKeyWord);
			this.iIndexCurrent++;
		}
		
	}

	public int findLastIndexSignature() 
	throws IOException, CryptographyException {
		
		
		for (int i=1; i < MAX_SIGNATURE; i++) {
			String sKeyWord = getIndexName(i) ;
			if(TextLocation.contains( sKeyWord, this.document))
			{
				this.iIndexCurrent = i;
				return this.iIndexCurrent ;
			}
		}
		
		return -1;
	}

	public  void setStaticKeyword(
			String sKeyword) 
	{
		this.bUseStaticKeyword = true;
		this.sStaticKeyword= sKeyword;
	}
	
	public  void initStandard(String sFontPathFilename) throws IOException 
	{
		this.sPrefixOccurence = "#cellule_sign_" ;
		this.sSuffixOccurence = "#" ;
		this.fontDefaultFont = 
			PDTrueTypeFont.loadTTF(this.document, sFontPathFilename);

		this.iRow = 2;
		this.iColumn = 3;
		this.dCellSizeXMin = 150;
		this.dCellSizeYMin = 70;
		this.dMargeX= 10;
		this.dMargeY = 5;
		this.bForceCellSizeY = true;
		this.dCellSizeY = 100;

		this.dDefaultFontSize = 10;
		this.bUseScannedSignatureRatioCell= true;
		this.dScannedSignatureRatioCell = 0.8f;
	}
	
	public static void main(String[] args) throws Exception {
		String sPath = "C:\\PDF\\3172\\PDF\\";
		//String sPathImage = "C:\\PDF\\signatures\\";

		
		String  sFilename = sPath+ "test_tableau_signature4_out.PDF";
		//String  sFilename = sPath+ "test_tableau_cell_signature.PDF";
		//String  sFilenameImage = sPathImage+ "Test_dk.jpg";
		String  sFilenameImage =  "C:\\PDF\\transform\\signature2.jpg";
		
		String  sFilenameOut = FileUtilBasic.changeExtension(sFilename, "_out.pdf") ;
		
		//System.out.println("contains : " + TextLocation.contains( "#cellule_sign_1#", sFilename));
		
		
		File file = new File(sFilename);

		TextLocationFillSignature tl = new TextLocationFillSignature();


		for (int i = 0; i < 4; i++) {
			Signature signature = new Signature();

			signature.sMessage = "Le 13 juin à Paris\nLe directeur général adjoint au"
				+ " département des affaires sanitaires et sociales\n\n\n\nPablo VIDAL";
			signature.biScannedSignature = CoinImageUtil.getBufferedImageFromFile(sFilenameImage);
			signature.iTextAlign = SSPVTextShape.TEXT_ALIGN_CENTER;

			tl.addSignature(signature);
		}

		


		tl.document = PDDocument.load( file);

		tl.initStandard("C:\\PDF\\Resources\\ttf\\ArialMT.ttf");
		
		tl.replaceAllSignature();

		System.out.println("sFilenameOut=" + sFilenameOut);
		tl.document.save(sFilenameOut);
		tl.document.close();

	}


}