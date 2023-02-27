//ServletModulisticaViewModel imports @1-C27B7E78
package restrict.ServletModulisticaView;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End ServletModulisticaViewModel imports

//ServletModulisticaViewModel class head @1-127D4D59
public class ServletModulisticaViewModel extends com.codecharge.components.Page {
    public ServletModulisticaViewModel() {
        this( new CCSLocale(), null );
    }

    public ServletModulisticaViewModel(CCSLocale locale) {
        this( locale, null );
    }

    public ServletModulisticaViewModel( CCSLocale locale, HttpServletResponse response ) {
//End ServletModulisticaViewModel class head

//page settings @1-DB584E5A
        super("ServletModulisticaView", locale );
        setResponse(response);
        addPageListener(new ServletModulisticaViewPageHandler());
        {

            com.codecharge.components.Label corpoHtml__83 = new com.codecharge.components.Label("corpoHtml", "", this );
            corpoHtml__83.setType( com.codecharge.components.ControlType.TEXT );
            add( corpoHtml__83 );
        } // end page
//End page settings

//ServletModulisticaViewModel class tail @1-F5FC18C5
    }
}
//End ServletModulisticaViewModel class tail
