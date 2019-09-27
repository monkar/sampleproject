package com.clinica.utils;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfImportedPage;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;
import com.lowagie.text.pdf.PdfTemplate;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.Barcode128;
import java.awt.Color;



public class ToolPdf 
{
  public ToolPdf()
  {
  }

    public static PdfPCell makeCell(String text, int vAlignment, int hAlignment, Font font, float leading, float padding, Rectangle borders, boolean ascender, boolean descender) {
        Paragraph p = new Paragraph(text, font);
        p.setLeading(leading);

        PdfPCell cell = new PdfPCell(p);
        cell.setLeading(leading, 0);
        cell.setVerticalAlignment(vAlignment);
        cell.setHorizontalAlignment(hAlignment);
        cell.cloneNonPositionParameters(borders);
        cell.setUseAscender(ascender);
        cell.setUseDescender(descender);
        cell.setUseBorderPadding(true);
        cell.setPadding(padding);
        return cell;
    } 
    
     public static PdfPCell makeCell(String text, int vAlignment, int hAlignment, Font font, float leading, float padding, Rectangle borders, 
                                     boolean ascender, boolean descender, Color color, float borderWidth) {
        Paragraph p = new Paragraph(text, font);
        p.setLeading(leading);

        PdfPCell cell = new PdfPCell(p);
        cell.setLeading(leading, 0);
        cell.setVerticalAlignment(vAlignment);
        cell.setHorizontalAlignment(hAlignment);
        cell.cloneNonPositionParameters(borders);
        cell.setUseAscender(ascender);
        cell.setUseDescender(descender);
        cell.setUseBorderPadding(true);
        cell.setPadding(padding);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(color);    
        cell.setBorderWidth(borderWidth);
        return cell;
    } 
 /* P 2012 - 0048 Codigo Barras */
  public static Barcode128 getBarCode(String pCodigo)
    {
        try
        {
            Barcode128 oBarcode128 = new Barcode128();
            oBarcode128.setCode(pCodigo);    
            return oBarcode128;            
        }
        catch (Exception ex)
        {
            return null;
        }
  
    }
 /* P 2012 - 0048 Codigo Barras */
public static PdfPCell makeCell(String pCodigo,PdfContentByte pContentByte, int vAlignment, int 
                                     hAlignment, Font font, float leading, float padding, Rectangle borders, 
                                         boolean ascender, boolean descender, Color color, float borderWidth) {
        
        PdfPCell cellImage = new PdfPCell(getBarCode(pCodigo).createImageWithBarcode(
                                                                              pContentByte,Color.BLACK,Color.WHITE));
        cellImage.setLeading(leading, 0);
        cellImage.setVerticalAlignment(vAlignment);
        cellImage.setHorizontalAlignment(hAlignment);
        cellImage.cloneNonPositionParameters(borders);
        cellImage.setUseAscender(ascender);
        cellImage.setUseDescender(descender);
        cellImage.setUseBorderPadding(true);
        cellImage.setPadding(padding);
        cellImage.setBorder(PdfPCell.BOX);
        cellImage.setBorderColor(color);    
        cellImage.setBorderWidth(borderWidth);
        return cellImage;
    }


}