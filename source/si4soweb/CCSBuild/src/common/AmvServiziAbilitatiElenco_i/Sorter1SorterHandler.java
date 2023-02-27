//Sorter1SorterHandler @39-707A7023
package common.AmvServiziAbilitatiElenco_i;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Sorter1SorterHandler implements ControlListener {
//End Sorter1SorterHandler

// //beforeShow @39-F81417CB

//BeforeShow Head @39-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @43-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 System.out.println("Pagina del sorter " + e.getSorter().getPage().getName());
 System.out.println("Pagina parent " + e.getPage().getParent().getName());

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @39-FCB6E20C
    }
//End BeforeShow Tail

//Sorter1NavigatorHandler Tail @39-FCB6E20C
}
//End Sorter1NavigatorHandler Tail

