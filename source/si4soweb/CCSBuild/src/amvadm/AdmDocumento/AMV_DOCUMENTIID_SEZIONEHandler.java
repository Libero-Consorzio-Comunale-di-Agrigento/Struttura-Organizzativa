//AMV_DOCUMENTIID_SEZIONEHandler Head @134-9D221F60
package amvadm.AdmDocumento;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AMV_DOCUMENTIID_SEZIONEHandler implements ValidationListener, ListDataObjectListener {
//End AMV_DOCUMENTIID_SEZIONEHandler Head

//OnValidate Head @134-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @134-FCB6E20C
    }
//End OnValidate Tail

//BeforeShow Head @134-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @144-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getPage().getRequest().getParameter("MVSZ")  != null) {
 	e.getControl().setValue(e.getPage().getRequest().getParameter("MVSZ"));
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @134-FCB6E20C
    }
//End BeforeShow Tail

//BeforeBuildSelect Head @134-3041BA14
    public void beforeBuildSelect( DataObjectEvent e ) {
//End BeforeBuildSelect Head

//BeforeBuildSelect Tail @134-FCB6E20C
    }
//End BeforeBuildSelect Tail

//BeforeExecuteSelect Head @134-8391D9D6
    public void beforeExecuteSelect( DataObjectEvent e ) {
//End BeforeExecuteSelect Head

//BeforeExecuteSelect Tail @134-FCB6E20C
    }
//End BeforeExecuteSelect Tail

//AfterExecuteSelect Head @134-0972E7FA
    public void afterExecuteSelect( DataObjectEvent e ) {
//End AfterExecuteSelect Head

//AfterExecuteSelect Tail @134-FCB6E20C
    }
//End AfterExecuteSelect Tail

//AMV_DOCUMENTIID_SEZIONEHandler Tail @134-FCB6E20C
}
//End AMV_DOCUMENTIID_SEZIONEHandler Tail

