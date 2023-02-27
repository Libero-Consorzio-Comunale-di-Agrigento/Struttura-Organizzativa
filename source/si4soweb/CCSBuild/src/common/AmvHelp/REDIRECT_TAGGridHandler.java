//REDIRECT_TAGGridHandler @2-1BDD24C1
package common.AmvHelp;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class REDIRECT_TAGGridHandler implements GridListener {
//End REDIRECT_TAGGridHandler

// //beforeShow @2-F81417CB

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @13-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
//		 System.out.println("amount of rows? " + e.getGrid().getAmountOfRows());
		/* if (e.getGrid().getAmountOfRows() == 1) {
			try {
				e.getGrid().initializeRows();
			    String url = e.getGrid().nextRow().get("Redirection").toString();
				String[] par_exclude = new String[6];
				par_exclude[0]= "MVPAGES";
				par_exclude[1]= "MVPAGETYPE";
				par_exclude[2]= "MVPAGEINDEX";
				par_exclude[3]= "MVPAGESURL";
				par_exclude[4]= "MVPAGETYPEURL";
				par_exclude[5]= "MVPAGEINDEXURL";
				String par = e.getPage().getHttpGetParams().toString(par_exclude);
				url = url.replace('*','&');
                if ( url.indexOf('?') > 0 && par.length() > 0 ) {
                   url = url + '&' + par;
				}
                else {
                   url = url + '?' + par;
				}
				e.getPage().getResponse().sendRedirect(url);
			} catch (Exception ex)  {
				ex.printStackTrace();
				System.out.println("eccezione, guarda stderr!");
			}
		}*/
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

//REDIRECT_TAGHandler Tail @2-FCB6E20C
}
//End REDIRECT_TAGHandler Tail

