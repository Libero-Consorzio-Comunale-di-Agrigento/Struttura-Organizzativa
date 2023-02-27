//AdmSezioniModel imports @1-84580E53
package amvadm.AdmSezioni;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmSezioniModel imports

//AdmSezioniModel class head @1-FAF5DCC7
public class AdmSezioniModel extends com.codecharge.components.Page {
    public AdmSezioniModel() {
        this( new CCSLocale(), null );
    }

    public AdmSezioniModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmSezioniModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmSezioniModel class head

//page settings @1-43698EF9
        super("AdmSezioni", locale );
        setResponse(response);
        addPageListener(new AdmSezioniPageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage AdmSezione__22 = new com.codecharge.components.IncludePage("AdmSezione", this );
            AdmSezione__22.setVisible( true );
            add( AdmSezione__22 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//Albero grid @6-5B40AEA3
        
        /*
            // Begin definition of Albero grid model.
        */
        {
            com.codecharge.components.Grid Albero = new com.codecharge.components.Grid("Albero");
            Albero.setPageModel( this );
            Albero.setFetchSize(300);
            Albero.setVisible( true );

            com.codecharge.components.Label MENU__7 = new com.codecharge.components.Label("MENU", "TABELLA", this );
            MENU__7.setType( com.codecharge.components.ControlType.TEXT );
            Albero.add(MENU__7);
            add(Albero);
        } // End definition of Albero grid model
//End Albero grid

//AdmSezioniModel class tail @1-F5FC18C5
    }
}
//End AdmSezioniModel class tail
