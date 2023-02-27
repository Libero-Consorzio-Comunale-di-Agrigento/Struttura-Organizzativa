//SERVIZI_ABILITATIAmountRecordsHandler Head @25-8975D7A2
package common.AmvServiziAbilitatiElenco_i;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class SERVIZI_ABILITATIAmountRecordsHandler implements ControlListener {
//End SERVIZI_ABILITATIAmountRecordsHandler Head

//BeforeShow Head @25-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @26-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @25-FCB6E20C
    }
//End BeforeShow Tail

//SERVIZI_ABILITATIAmountRecordsHandler Tail @25-FCB6E20C
}
//End SERVIZI_ABILITATIAmountRecordsHandler Tail

