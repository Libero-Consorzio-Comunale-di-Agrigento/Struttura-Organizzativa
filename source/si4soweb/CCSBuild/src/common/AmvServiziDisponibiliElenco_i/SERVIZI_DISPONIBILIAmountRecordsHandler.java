//SERVIZI_DISPONIBILIAmountRecordsHandler Head @27-ECF9D13C
package common.AmvServiziDisponibiliElenco_i;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class SERVIZI_DISPONIBILIAmountRecordsHandler implements ControlListener {
//End SERVIZI_DISPONIBILIAmountRecordsHandler Head

//BeforeShow Head @27-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @28-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @27-FCB6E20C
    }
//End BeforeShow Tail

//SERVIZI_DISPONIBILIAmountRecordsHandler Tail @27-FCB6E20C
}
//End SERVIZI_DISPONIBILIAmountRecordsHandler Tail

