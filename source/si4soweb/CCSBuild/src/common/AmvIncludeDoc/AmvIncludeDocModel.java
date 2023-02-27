//AmvIncludeDocModel imports @1-5398659D
package common.AmvIncludeDoc;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvIncludeDocModel imports

//AmvIncludeDocModel class head @1-857CD7DA
public class AmvIncludeDocModel extends com.codecharge.components.Page {
    public AmvIncludeDocModel() {
        this( new CCSLocale(), null );
    }

    public AmvIncludeDocModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvIncludeDocModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvIncludeDocModel class head

//page settings @1-AC29A5E2
        super("AmvIncludeDoc", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Doc grid @3-3A64F086
        
        /*
            // Begin definition of Doc grid model.
        */
        {
            com.codecharge.components.Grid Doc = new com.codecharge.components.Grid("Doc");
            Doc.setPageModel( this );
            Doc.setFetchSize(20);
            Doc.setVisible( true );
            Doc.addGridListener( new DocGridHandler() );

            com.codecharge.components.Label LINK__14 = new com.codecharge.components.Label("LINK", "LINK", this );
            LINK__14.setType( com.codecharge.components.ControlType.TEXT );
            LINK__14.setHtmlEncode( true );
            LINK__14.addControlListener( new DocLINKHandler());
            Doc.add(LINK__14);

            com.codecharge.components.Label DOC_LINK__4 = new com.codecharge.components.Label("DOC_LINK", this);
            DOC_LINK__4.setType( com.codecharge.components.ControlType.TEXT );
            Doc.add(DOC_LINK__4);
            add(Doc);
        } // End definition of Doc grid model
//End Doc grid

//AmvIncludeDocModel class tail @1-F5FC18C5
    }
}
//End AmvIncludeDocModel class tail



