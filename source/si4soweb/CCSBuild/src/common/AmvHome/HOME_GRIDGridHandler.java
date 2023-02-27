//HOME_GRIDGridHandler @2-CC5008C9
package common.AmvHome;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HOME_GRIDGridHandler implements GridListener {
//End HOME_GRIDGridHandler

// //beforeShow @2-F81417CB

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @6-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 		 if (e.getGrid().getAmountOfRows() == 1) {
			try {
				e.getGrid().initializeRows();
			    String url = e.getGrid().nextRow().get("HOME").toString();
				e.getPage().getResponse().sendRedirect(url);
			} catch (Exception ex)  {
				ex.printStackTrace();
			}
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

//HOME_GRIDHandler Tail @2-FCB6E20C
}
//End HOME_GRIDHandler Tail

