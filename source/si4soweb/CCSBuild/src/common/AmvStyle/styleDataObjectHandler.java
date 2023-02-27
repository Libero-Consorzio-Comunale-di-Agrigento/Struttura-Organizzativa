//styleDataObjectHandler head @2-9468A8BA
package common.AmvStyle;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class styleDataObjectHandler implements DataObjectListener {
//End styleDataObjectHandler head

// //BeforeBuildSelect @2-F81417CB

//beforeBuildSelect head @2-3041BA14
    public void beforeBuildSelect( DataObjectEvent e) {
//End beforeBuildSelect head

//BeforeBuildSelect Tail @2-FCB6E20C
    }
//End BeforeBuildSelect Tail

// //beforeExecuteSelect @2-F81417CB

//beforeExecuteSelect head @2-8391D9D6
    public void beforeExecuteSelect( DataObjectEvent e) {
//End beforeExecuteSelect head

//beforeExecuteSelect Tail @2-FCB6E20C
    }
//End beforeExecuteSelect Tail

// //afterExecuteSelect @2-F81417CB

//afterExecuteSelect Head @2-0972E7FA
    public void afterExecuteSelect( DataObjectEvent e) {
//End afterExecuteSelect Head

//Event AfterExecuteSelect Action Custom Code @7-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 styleRow[] righe = ((styleDataObject) e.getDataSource()).getRows();
 DbRow record = (DbRow) e.getCommand().getRows().nextElement();
 try {
 	String stile_corrente = record.get("MVSTILE").toString();
    SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSTILE", stile_corrente);
	//e.getPage().getRequest().setAttribute("MVSTILE", stile_corrente);
	//System.out.println("stile_corrente " + stile_corrente);
 } catch (Exception exc) {
 System.out.println("Exception sul row non inizializzata");
 }
//End Event AfterExecuteSelect Action Custom Code

//afterExecuteSelect Tail @2-FCB6E20C
    }
//End afterExecuteSelect Tail

//styleDataObjectHandler Tail @2-FCB6E20C
}
//End styleDataObjectHandler Tail

