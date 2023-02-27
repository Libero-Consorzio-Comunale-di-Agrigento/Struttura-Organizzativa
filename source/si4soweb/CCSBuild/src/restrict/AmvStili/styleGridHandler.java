//styleGridHandler @3-44BD8983
package restrict.AmvStili;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class styleGridHandler implements GridListener {
//End styleGridHandler

// //beforeShow @3-F81417CB

//BeforeShow Head @3-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @3-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @3-F81417CB

//beforeShowRow Head @3-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @3-19A5A648
        e.getGrid().getControl("STILE").setValue(dirList(e));
//End Set values for static controls

//beforeShowRow Tail @3-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @3-F81417CB

//BeforeSelect Head @3-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @3-FCB6E20C
    }
//End BeforeSelect Tail
public String dirList(Event e) {
// custom AFC
    String path = "/";
    String realPath = e.getPage().getRequest().getRealPath(path);
    String dirName = realPath   + File.separator + "Themes";
	StringBuffer labelContents = new StringBuffer();

    File f = new File(dirName);
    if (f.exists()) {
    	if (f.isDirectory()) {				  
        File[] list = f.listFiles();
		labelContents.append("<table class=\"AFCFormTable\" width=\"100%\"><tr><td class=\"AFCColumnTD\">Stile</td></tr>");
        for (int i = 0; i < list.length; i++) {
			// verifico esistenza del file di versione V2004.txt
			File ver = new File(dirName + File.separator + list[i].getName() + File.separator + "V2004.txt");
			if (list[i].isDirectory() && ver.exists()) {
	  		labelContents.append("<tr><td class=\"AFCDataTD\">");
			labelContents.append("<a href=\"../restrict/AmvPreferenzeStile.do?STYLE=" + list[i].getName() + "&MVID=3&MVID1=1\" >");
			labelContents.append(list[i].getName());
			labelContents.append("</a></td></tr>");
          }
        }
		labelContents.append("<tr><td class=\"AFCFooterTD\" width=\"100%\">&nbsp;</td></tr>");
		labelContents.append("</table>");

      }
    }

    return (labelContents.toString());
}


//styleHandler Tail @3-FCB6E20C
}
//End styleHandler Tail

