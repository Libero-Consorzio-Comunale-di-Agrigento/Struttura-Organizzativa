//AccessiDettaglioAmountRecordsHandler Head @18-55987A02
package restrict.AmvUltimiAccessi;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AccessiDettaglioAmountRecordsHandler implements ControlListener {
//End AccessiDettaglioAmountRecordsHandler Head

//BeforeShow Head @18-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @19-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @18-FCB6E20C
    }
//End BeforeShow Tail

//AccessiDettaglioAmountRecordsHandler Tail @18-FCB6E20C
}
//End AccessiDettaglioAmountRecordsHandler Tail

