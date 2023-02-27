//AmvIncludeServletLabel1Handler Head @2-8FDFD017
package common.AmvIncludeServlet;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
import java.io.*;
import java.net.URL;
import it.finmatica.jfc.io.*;

public class AmvIncludeServletLabel1Handler implements ControlListener {
//End AmvIncludeServletLabel1Handler Head

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @3-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 StringBuffer labelContent = new StringBuffer();
 try {
 	URL u = new URL("../amvadm/AdmMenu.do");
 	LetturaScritturaFileURL reader = new LetturaScritturaFileURL(u);
	InputStream writer = reader.leggiFile();
		
} catch (Exception exc) {
	System.out.println("Eccez. in lettura servlet");
}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @2-FCB6E20C
    }
//End BeforeShow Tail

//AmvIncludeServletLabel1Handler Tail @2-FCB6E20C
}
//End AmvIncludeServletLabel1Handler Tail

