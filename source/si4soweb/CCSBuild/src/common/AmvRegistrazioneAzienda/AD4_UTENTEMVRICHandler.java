//AD4_UTENTEMVRICHandler Head @52-066BF631
package common.AmvRegistrazioneAzienda;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_UTENTEMVRICHandler implements ValidationListener {
//End AD4_UTENTEMVRICHandler Head

//OnValidate Head @52-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @52-FCB6E20C
    }
//End OnValidate Tail

//BeforeShow Head @52-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve Value for Control @53-FE43D1A9
        ((com.codecharge.components.Hidden) ((com.codecharge.components.Record) (e.getPage().getChild( "AD4_UTENTE" ))).getChild( "MVRIC" )).setValue( SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVRIC") );
//End Event BeforeShow Action Retrieve Value for Control

//BeforeShow Tail @52-FCB6E20C
    }
//End BeforeShow Tail

//AD4_UTENTEMVRICHandler Tail @52-FCB6E20C
}
//End AD4_UTENTEMVRICHandler Tail

