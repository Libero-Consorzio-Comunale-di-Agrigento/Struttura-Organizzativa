//AmvImagesHandler imports @1-FCC0B4E8
package common.AmvImages;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvImagesHandler imports

//AmvImagesHandler Head @1-E16F04A1
public class AmvImagesPageHandler implements PageListener {
//End AmvImagesHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//OnInitializeView Tail @1-FCB6E20C
    }
//End OnInitializeView Tail

//BeforeShow Head @1-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @17-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	String nomeImmagine =  (String)SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("varImm");
	((com.codecharge.components.TextBox) ((com.codecharge.components.Record) (e.getPage().getChild( "RecordImage" ))).getChild( "nomeImmagine")).setValue( nomeImmagine );

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//Event BeforeUnload Action Custom Code @18-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  	  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("varImm", "");

//End Event BeforeUnload Action Custom Code

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//AmvImagesHandler Tail @1-FCB6E20C
}
//End AmvImagesHandler Tail

