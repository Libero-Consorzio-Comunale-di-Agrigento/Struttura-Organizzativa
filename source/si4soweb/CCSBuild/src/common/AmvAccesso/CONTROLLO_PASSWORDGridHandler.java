//CONTROLLO_PASSWORDGridHandler @9-C7B3888C
package common.AmvAccesso;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class CONTROLLO_PASSWORDGridHandler implements GridListener {
//End CONTROLLO_PASSWORDGridHandler

// //beforeShow @9-F81417CB

//BeforeShow Head @9-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @18-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	String is_pwd_valida = "1";
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVABILITAZIONI","SI");
	if (e.getGrid().getAmountOfRows() > 0) {
		try {
		    e.getGrid().initializeRows();			
			is_pwd_valida = e.getGrid().nextRow().get("PWD").toString();
			} catch (Exception ex)  {
			ex.printStackTrace();
		}
	}

	try {
		String url;
	    if (is_pwd_valida.equals("1")) {
			url = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVCONTEXT").toString();
			if (e.getPage().getRequest().getParameter("MVURL")  != null)  {
				url = e.getPage().getRequest().getParameter("MVURL");
        	}
		} else {
			url = "../restrict/AmvProfilo.do"; 
		} 
		e.getPage().getResponse().sendRedirect(url);
	} catch (Exception ex)  {
		ex.printStackTrace();
	}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @9-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @9-F81417CB

//beforeShowRow Head @9-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @9-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @9-F81417CB

//BeforeSelect Head @9-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @9-FCB6E20C
    }
//End BeforeSelect Tail

//CONTROLLO_PASSWORDHandler Tail @9-FCB6E20C
}
//End CONTROLLO_PASSWORDHandler Tail

