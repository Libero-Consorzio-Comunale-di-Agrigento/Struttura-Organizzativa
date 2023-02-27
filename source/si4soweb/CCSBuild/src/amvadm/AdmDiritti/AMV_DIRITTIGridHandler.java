//AMV_DIRITTIGridHandler @5-CA280720
package amvadm.AdmDiritti;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AMV_DIRITTIGridHandler implements GridListener {
//End AMV_DIRITTIGridHandler

// //beforeShow @5-F81417CB

//BeforeShow Head @5-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @5-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @5-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @5-F81417CB

//beforeShowRow Head @5-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Event BeforeShowRow Action Custom Code @51-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  String area = (String) e.getPage().getRequest().getAttribute("header_area");
  if ( area == null ) {
    area = "";
  }
  if (area.equals(e.getGrid().getControl("HEADER_AREA").getValue()) ) {
    e.getGrid().getControl("HEADER_AREA").setVisible(false);
  } else {
    e.getGrid().getControl("HEADER_AREA").setVisible(true);
    e.getPage().getRequest().setAttribute("header_area", e.getGrid().getControl("HEADER_AREA").getValue());
  }

//End Event BeforeShowRow Action Custom Code

//beforeShowRow Tail @5-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @5-F81417CB

//BeforeSelect Head @5-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//Event BeforeSelect Action Custom Code @52-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 Integer num;
 if (!StringUtils.isEmpty(e.getPage().getHttpGetParams().getParameter("s_DISPLAY"))) {
 	num = Integer.decode(e.getPage().getHttpGetParams().getParameter("s_DISPLAY"));
 	e.getGrid().setFetchSize(num.intValue());
 }

//End Event BeforeSelect Action Custom Code

//BeforeSelect Tail @5-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_DIRITTIHandler Tail @5-FCB6E20C
}
//End AMV_DIRITTIHandler Tail

