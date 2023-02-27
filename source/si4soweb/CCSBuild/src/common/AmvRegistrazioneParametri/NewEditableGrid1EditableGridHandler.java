//NewEditableGrid1GridHandler @6-FA205A7E
package common.AmvRegistrazioneParametri;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class NewEditableGrid1EditableGridHandler implements EditableGridListener {
//End NewEditableGrid1GridHandler

// //beforeSelect @6-F81417CB

//BeforeSelect Head @6-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @6-FCB6E20C
    }
//End BeforeSelect Tail

// //beforeShow @6-F81417CB

//BeforeShow Head @6-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//EditableGrid NewEditableGrid1: Set values for static controls @6-74B25F03
        if (! e.getEditableGrid().isProcessed()) {
        }
//End EditableGrid NewEditableGrid1: Set values for static controls

//BeforeShow Tail @6-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @6-F81417CB

//beforeShowRow Head @6-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//EditableGrid NewEditableGrid1: Set values for row controls @6-CC299837
if (e.getEditableGrid().isShowEmptyRow()) {
}
        if (! e.getEditableGrid().isProcessed()) {
            if (e.getEditableGrid().isShowEmptyRow()) {
            }
        }
//End EditableGrid NewEditableGrid1: Set values for row controls

//beforeShowRow Tail @6-FCB6E20C
    }
//End beforeShowRow Tail

//OnValidate Head @6-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @6-FCB6E20C
    }
//End OnValidate Tail

//BeforeUpdate Head @6-9D1B8475
    public void beforeSubmit(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @6-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @6-9ED73E93
    public void afterSubmit(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @6-FCB6E20C
    }
//End AfterUpdate Tail

//NewEditableGrid1Handler Tail @6-FCB6E20C
}
//End NewEditableGrid1Handler Tail

