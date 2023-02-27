//AMV_VISTA_DOCUMENTIAmountRecordsHandler Head @59-24456B44
package common.AmvDocumenti;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AMV_VISTA_DOCUMENTIAmountRecordsHandler implements ControlListener {
//End AMV_VISTA_DOCUMENTIAmountRecordsHandler Head

//BeforeShow Head @59-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve number of records @60-9D59B397
        ((Control) e.getSource()).setValue( ((Grid) e.getParent()).getAmountOfRows());
//End Event BeforeShow Action Retrieve number of records

//BeforeShow Tail @59-FCB6E20C
    }
//End BeforeShow Tail

//AMV_VISTA_DOCUMENTIAmountRecordsHandler Tail @59-FCB6E20C
}
//End AMV_VISTA_DOCUMENTIAmountRecordsHandler Tail

