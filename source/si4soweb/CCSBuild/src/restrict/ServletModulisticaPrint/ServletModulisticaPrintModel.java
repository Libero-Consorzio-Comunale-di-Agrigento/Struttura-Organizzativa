//ServletModulisticaPrintModel imports @1-6191215F
package restrict.ServletModulisticaPrint;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End ServletModulisticaPrintModel imports

//ServletModulisticaPrintModel class head @1-FAAFFA6D
public class ServletModulisticaPrintModel extends com.codecharge.components.Page {
    public ServletModulisticaPrintModel() {
        this( new CCSLocale(), null );
    }

    public ServletModulisticaPrintModel(CCSLocale locale) {
        this( locale, null );
    }

    public ServletModulisticaPrintModel( CCSLocale locale, HttpServletResponse response ) {
//End ServletModulisticaPrintModel class head

//page settings @1-41A18778
        super("ServletModulisticaPrint", locale );
        setResponse(response);
        addPageListener(new ServletModulisticaPrintPageHandler());
        {

            com.codecharge.components.Label corpoHtml__83 = new com.codecharge.components.Label("corpoHtml", "", this );
            corpoHtml__83.setType( com.codecharge.components.ControlType.TEXT );
            add( corpoHtml__83 );
        } // end page
//End page settings

//ServletModulisticaPrintModel class tail @1-F5FC18C5
    }
}
//End ServletModulisticaPrintModel class tail
