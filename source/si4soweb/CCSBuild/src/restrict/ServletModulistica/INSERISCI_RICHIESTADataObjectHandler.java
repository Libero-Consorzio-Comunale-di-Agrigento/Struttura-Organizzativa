//INSERISCI_RICHIESTADataObjectHandler head @29-002AF6EC
package restrict.ServletModulistica;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class INSERISCI_RICHIESTADataObjectHandler implements DataObjectListener {
//End INSERISCI_RICHIESTADataObjectHandler head

// //BeforeBuildSelect @29-F81417CB

//beforeBuildSelect head @29-3041BA14
    public void beforeBuildSelect( DataObjectEvent e) {
//End beforeBuildSelect head

//BeforeBuildSelect Tail @29-FCB6E20C
    }
//End BeforeBuildSelect Tail

// //beforeExecuteSelect @29-F81417CB

//beforeExecuteSelect head @29-8391D9D6
    public void beforeExecuteSelect( DataObjectEvent e) {
//End beforeExecuteSelect head

//beforeExecuteSelect Tail @29-FCB6E20C
    }
//End beforeExecuteSelect Tail

// //afterExecuteSelect @29-F81417CB

//afterExecuteSelect Head @29-0972E7FA
    public void afterExecuteSelect( DataObjectEvent e) {
//End afterExecuteSelect Head

//Event AfterExecuteSelect Action Custom Code @54-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVEXE",null);
//End Event AfterExecuteSelect Action Custom Code

//afterExecuteSelect Tail @29-FCB6E20C
    }
//End afterExecuteSelect Tail

//INSERISCI_RICHIESTADataObjectHandler Tail @29-FCB6E20C
}
//End INSERISCI_RICHIESTADataObjectHandler Tail

