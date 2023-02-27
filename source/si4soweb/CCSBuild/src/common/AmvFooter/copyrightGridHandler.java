//copyrightGridHandler @2-35DDE690
package common.AmvFooter;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class copyrightGridHandler implements GridListener {
//End copyrightGridHandler

// //beforeShow @2-F81417CB

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @10-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
		try {
			e.getGrid().initializeRows();
			String mvDirUpload = e.getGrid().nextRow().get("MVDIRUPLOAD").toString();
		    SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVDIRUPLOAD",mvDirUpload);
		} catch (Exception ex)  {
			ex.printStackTrace();
		}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @2-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @2-F81417CB

//beforeShowRow Head @2-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @2-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @2-F81417CB

//BeforeSelect Head @2-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @2-FCB6E20C
    }
//End BeforeSelect Tail

//copyrightHandler Tail @2-FCB6E20C
}
//End copyrightHandler Tail

