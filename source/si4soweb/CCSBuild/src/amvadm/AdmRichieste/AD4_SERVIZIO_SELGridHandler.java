//AD4_SERVIZIO_SELGridHandler @98-D1B125FD
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AD4_SERVIZIO_SELGridHandler implements GridListener {
//End AD4_SERVIZIO_SELGridHandler

// //beforeShow @98-F81417CB

//BeforeShow Head @98-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @153-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getGrid().getAmountOfRows() == 0) {
  e.getGrid().setVisible(false);
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @98-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @98-F81417CB

//beforeShowRow Head @98-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @98-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @98-F81417CB

//BeforeSelect Head @98-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @98-FCB6E20C
    }
//End BeforeSelect Tail

//AD4_SERVIZIO_SELHandler Tail @98-FCB6E20C
}
//End AD4_SERVIZIO_SELHandler Tail

