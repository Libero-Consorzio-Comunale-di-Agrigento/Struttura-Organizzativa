//AmvMainModel imports @1-DF3FC6ED
package common.AmvMain;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvMainModel imports

//AmvMainModel class head @1-B78AC2C5
public class AmvMainModel extends com.codecharge.components.Page {
    public AmvMainModel() {
        this( new CCSLocale(), null );
    }

    public AmvMainModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvMainModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvMainModel class head

//page settings @1-1211A410
        super("AmvMain", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage Header__20 = new com.codecharge.components.IncludePage("Header", this );
            Header__20.setVisible( true );
            add( Header__20 );
            com.codecharge.components.IncludePage Left__21 = new com.codecharge.components.IncludePage("Left", this );
            Left__21.setVisible( true );
            add( Left__21 );
            com.codecharge.components.IncludePage AmvNavigatore__43 = new com.codecharge.components.IncludePage("AmvNavigatore", this );
            AmvNavigatore__43.setVisible( true );
            add( AmvNavigatore__43 );
            com.codecharge.components.IncludePage AmvRegistrazioneLink__40 = new com.codecharge.components.IncludePage("AmvRegistrazioneLink", this );
            AmvRegistrazioneLink__40.setVisible( true );
            add( AmvRegistrazioneLink__40 );
            com.codecharge.components.IncludePage MainContent__42 = new com.codecharge.components.IncludePage("MainContent", this );
            MainContent__42.setVisible( true );
            add( MainContent__42 );
            com.codecharge.components.IncludePage AmvCenterMenuSezioni__41 = new com.codecharge.components.IncludePage("AmvCenterMenuSezioni", this );
            AmvCenterMenuSezioni__41.setVisible( true );
            add( AmvCenterMenuSezioni__41 );
            com.codecharge.components.IncludePage Right__36 = new com.codecharge.components.IncludePage("Right", this );
            Right__36.setVisible( true );
            add( Right__36 );
            com.codecharge.components.IncludePage Footer__22 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__22.setVisible( true );
            add( Footer__22 );
        } // end page
//End page settings

//AmvMainModel class tail @1-F5FC18C5
    }
}
//End AmvMainModel class tail
