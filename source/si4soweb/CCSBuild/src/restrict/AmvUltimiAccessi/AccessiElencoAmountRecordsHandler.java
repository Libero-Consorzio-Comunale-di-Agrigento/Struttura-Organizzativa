//AccessiElencoAmountRecordsHandler Head @11-A597038D
package restrict.AmvUltimiAccessi;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AccessiElencoAmountRecordsHandler implements ControlListener {
//End AccessiElencoAmountRecordsHandler Head

//BeforeShow Head @11-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @12-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @11-FCB6E20C
    }
//End BeforeShow Tail

//AccessiElencoAmountRecordsHandler Tail @11-FCB6E20C
}
//End AccessiElencoAmountRecordsHandler Tail

