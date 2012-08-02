package org.coin.util;



import java.awt.Button;
import java.awt.Component;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import javax.imageio.stream.MemoryCacheImageOutputStream;
import javax.swing.JPanel;

import org.coin.util.image.filter.ImageScaleFilter;


public abstract class ImageToolKit {

	public static final void addComponentInGridBag(Component comp,
			GridBagLayout gridbag,
			GridBagConstraints c,
			JPanel panel) {
		gridbag.setConstraints(comp, c);
		panel.add(comp);
	}

	public static final void makebutton(String name,
			GridBagLayout gridbag,
			GridBagConstraints c,
			JPanel panel) {
		Button button = new Button(name);
		gridbag.setConstraints(button, c);
		panel.add(button);
	}

	public static byte[] preparePhoto( InputStream is,int iHeight  ) throws Exception
	{
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		MemoryCacheImageOutputStream mos = new MemoryCacheImageOutputStream( baos );
		ImageScaleFilter.redimensionner( is, mos,iHeight);
		return baos.toByteArray();
	}


}
