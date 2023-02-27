//AD4_UTENTEInsertHandler Head @21-6E819433
package common.AmvRegistrazioneAzienda;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_UTENTEInsertHandler implements ButtonListener {
//End AD4_UTENTEInsertHandler Head

//onClick Head @21-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//Event OnClick Action Save Control Value @22-3114F367
        SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPAGES", ((com.codecharge.components.Hidden) ((com.codecharge.components.Record) (e.getPage().getChild( "AD4_UTENTE" ))).getChild( "MVPAGES" )).getValue() );
//End Event OnClick Action Save Control Value

//onClick Tail @21-FCB6E20C
}
//End onClick Tail

//beforeShow Head @21-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//AD4_UTENTEInsertHandler Tail @21-F5FC18C5
    }
}
//End AD4_UTENTEInsertHandler Tail

