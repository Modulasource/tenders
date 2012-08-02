package org.coin.util;

import java.io.IOException;
import java.io.InputStream;

import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.rtf.RTFEditorKit;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFTextStripper;

public class IndexationUtil {

	public static String getTextContentFromWordDocument(InputStream stream) throws IOException{
		HWPFDocument doc = new HWPFDocument(stream);
		WordExtractor we = new WordExtractor(doc);
		return StringUtil.removeDuplicateWhitespace(we.getText());
	}
	
	public static String getTextContentFromPDFDocument(InputStream stream) throws IOException{
		PDFTextStripper ts = new PDFTextStripper();
		PDDocument doc = PDDocument.load(stream);
		return StringUtil.removeDuplicateWhitespace(ts.getText(doc));
	}
	
	public static String getTextContentFromRTFDocument(InputStream stream) throws IOException, BadLocationException{
		RTFEditorKit kit = new RTFEditorKit();
		Document doc = kit.createDefaultDocument();
		kit.read(stream, doc, 0);
		String plainText = doc.getText(0, doc.getLength());
		return StringUtil.removeDuplicateWhitespace(plainText);
	}
	
}
