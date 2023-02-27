//AD4_RICHIESTE_ABILITAZIONEAmountRecordsHandler Head @74-DFD2DDEF
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONEAmountRecordsHandler implements ControlListener {
//End AD4_RICHIESTE_ABILITAZIONEAmountRecordsHandler Head

//BeforeShow Head @74-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @75-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @74-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_ABILITAZIONEAmountRecordsHandler Tail @74-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEAmountRecordsHandler Tail

