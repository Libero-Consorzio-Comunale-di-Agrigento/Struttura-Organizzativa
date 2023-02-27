//AmvFooterModel imports @1-E128ACAA
package common.AmvFooter;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvFooterModel imports

//AmvFooterModel class head @1-70AD492C
public class AmvFooterModel extends com.codecharge.components.Page {
    public AmvFooterModel() {
        this( new CCSLocale(), null );
    }

    public AmvFooterModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvFooterModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvFooterModel class head

//page settings @1-B99E6463
        super("AmvFooter", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvStyle__9 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__9.setVisible( true );
            add( AmvStyle__9 );
            com.codecharge.components.IncludePage Versione__8 = new com.codecharge.components.IncludePage("Versione", this );
            Versione__8.setVisible( true );
            add( Versione__8 );
            com.codecharge.components.IncludePage AmvVersione__7 = new com.codecharge.components.IncludePage("AmvVersione", this );
            AmvVersione__7.setVisible( true );
            add( AmvVersione__7 );
        } // end page
//End page settings

//copyright grid @2-DA307532
        
        /*
            // Begin definition of copyright grid model.
        */
        {
            com.codecharge.components.Grid copyright = new com.codecharge.components.Grid("copyright");
            copyright.setPageModel( this );
            copyright.setFetchSize(20);
            copyright.setVisible( true );
            copyright.addGridListener( new copyrightGridHandler() );

            com.codecharge.components.Label MESSAGGIO__3 = new com.codecharge.components.Label("MESSAGGIO", "MESSAGGIO", this );
            MESSAGGIO__3.setType( com.codecharge.components.ControlType.TEXT );
            copyright.add(MESSAGGIO__3);

            com.codecharge.components.Label MVDIRUPLOAD__11 = new com.codecharge.components.Label("MVDIRUPLOAD", "MVDIRUPLOAD", this );
            MVDIRUPLOAD__11.setType( com.codecharge.components.ControlType.TEXT );
            MVDIRUPLOAD__11.setHtmlEncode( true );
            MVDIRUPLOAD__11.addControlListener( new copyrightMVDIRUPLOADHandler());
            copyright.add(MVDIRUPLOAD__11);
            add(copyright);
        } // End definition of copyright grid model
//End copyright grid

//AmvFooterModel class tail @1-F5FC18C5
    }
}
//End AmvFooterModel class tail

