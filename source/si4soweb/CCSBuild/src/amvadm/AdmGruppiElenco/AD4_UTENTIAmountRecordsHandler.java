//AD4_UTENTIAmountRecordsHandler Head @59-C5820536
package amvadm.AdmGruppiElenco;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_UTENTIAmountRecordsHandler implements ControlListener {
//End AD4_UTENTIAmountRecordsHandler Head

//BeforeShow Head @59-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @60-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @59-FCB6E20C
    }
//End BeforeShow Tail

//AD4_UTENTIAmountRecordsHandler Tail @59-FCB6E20C
}
//End AD4_UTENTIAmountRecordsHandler Tail

