//AmvPageTemplateModel imports @1-0B9CD2AE
package common.AmvPageTemplate;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvPageTemplateModel imports

//AmvPageTemplateModel class head @1-BDE1EC56
public class AmvPageTemplateModel extends com.codecharge.components.Page {
    public AmvPageTemplateModel() {
        this( new CCSLocale(), null );
    }

    public AmvPageTemplateModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvPageTemplateModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvPageTemplateModel class head

//page settings @1-AC8412A3
        super("AmvPageTemplate", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvPageTemplateModel class tail @1-F5FC18C5
    }
}
//End AmvPageTemplateModel class tail

