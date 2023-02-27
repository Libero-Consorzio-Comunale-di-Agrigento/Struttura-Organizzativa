//MainContentModel imports @1-AA897C93
package common.MainContent;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End MainContentModel imports

//MainContentModel class head @1-A4660DFB
public class MainContentModel extends com.codecharge.components.Page {
    public MainContentModel() {
        this( new CCSLocale(), null );
    }

    public MainContentModel(CCSLocale locale) {
        this( locale, null );
    }

    public MainContentModel( CCSLocale locale, HttpServletResponse response ) {
//End MainContentModel class head

//page settings @1-765D182E
        super("MainContent", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//MainContentModel class tail @1-F5FC18C5
    }
}
//End MainContentModel class tail

