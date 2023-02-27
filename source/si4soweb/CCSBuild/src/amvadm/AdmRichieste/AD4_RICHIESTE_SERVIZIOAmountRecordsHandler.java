//AD4_RICHIESTE_SERVIZIOAmountRecordsHandler Head @160-2C1368E1
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_SERVIZIOAmountRecordsHandler implements ControlListener {
//End AD4_RICHIESTE_SERVIZIOAmountRecordsHandler Head

//BeforeShow Head @160-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @161-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @160-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_SERVIZIOAmountRecordsHandler Tail @160-FCB6E20C
}
//End AD4_RICHIESTE_SERVIZIOAmountRecordsHandler Tail

