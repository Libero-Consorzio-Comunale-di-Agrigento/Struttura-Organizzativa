//AD4_RICHIESTE_FALLITEAmountRecordsHandler Head @113-86BB3B42
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_FALLITEAmountRecordsHandler implements ControlListener {
//End AD4_RICHIESTE_FALLITEAmountRecordsHandler Head

//BeforeShow Head @113-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @114-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @113-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_FALLITEAmountRecordsHandler Tail @113-FCB6E20C
}
//End AD4_RICHIESTE_FALLITEAmountRecordsHandler Tail

