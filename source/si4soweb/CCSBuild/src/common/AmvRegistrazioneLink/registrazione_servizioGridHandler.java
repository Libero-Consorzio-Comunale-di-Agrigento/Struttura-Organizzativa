//registrazione_servizioGridHandler @2-F87F8F6A
package common.AmvRegistrazioneLink;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class registrazione_servizioGridHandler implements GridListener {
//End registrazione_servizioGridHandler

// //beforeShow @2-F81417CB

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @12-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getGrid().getAmountOfRows() == 0) {
  e.getGrid().setVisible(false);

 }

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @2-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @2-F81417CB

//beforeShowRow Head @2-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @2-A22FC256
        e.getGrid().getLink("REGISTRAZIONE").getParameter("RR").setValue(( "1" ));
//End Set values for static controls

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

//registrazione_servizioHandler Tail @2-FCB6E20C
}
//End registrazione_servizioHandler Tail

