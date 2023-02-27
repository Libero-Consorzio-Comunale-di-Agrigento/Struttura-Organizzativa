//AdmRichiestaNotificaModel imports @1-1C7AA342
package amvadm.AdmRichiestaNotifica;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRichiestaNotificaModel imports

//AdmRichiestaNotificaModel class head @1-89E2ED1C
public class AdmRichiestaNotificaModel extends com.codecharge.components.Page {
    public AdmRichiestaNotificaModel() {
        this( new CCSLocale(), null );
    }

    public AdmRichiestaNotificaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRichiestaNotificaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRichiestaNotificaModel class head

//page settings @1-BF5FAB07
        super("AdmRichiestaNotifica", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__4 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__4.setVisible( true );
            add( Guida__4 );
            com.codecharge.components.IncludePage Footer__5 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__5.setVisible( true );
            add( Footer__5 );
        } // end page
//End page settings

//AD4_RICHIESTE_ABILITAZIONE record @6-4761F274
        
        /*
            Model of AD4_RICHIESTE_ABILITAZIONE record defining.
        */
        {
            com.codecharge.components.Record AD4_RICHIESTE_ABILITAZIONE = new com.codecharge.components.Record("AD4_RICHIESTE_ABILITAZIONE");
            AD4_RICHIESTE_ABILITAZIONE.setPageModel( this );
            AD4_RICHIESTE_ABILITAZIONE.addExcludeParam( "ccsForm" );
            AD4_RICHIESTE_ABILITAZIONE.setVisible( true );
            AD4_RICHIESTE_ABILITAZIONE.setAllowInsert(false);
            AD4_RICHIESTE_ABILITAZIONE.setAllowDelete(false);
            AD4_RICHIESTE_ABILITAZIONE.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTE_ABILITAZIONE.setReturnPage("AdmRichiestaNotifica" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox SERVIZIO__7 = new com.codecharge.components.TextBox("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__7.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__7.setHtmlEncode( true );
            SERVIZIO__7.setCaption( "SERVIZIO" );
            AD4_RICHIESTE_ABILITAZIONE.add( SERVIZIO__7 );

            com.codecharge.components.ListBox TIPO_NOTIFICA__8 = new com.codecharge.components.ListBox("TIPO_NOTIFICA", "TIPO_NOTIFICA", this );
            TIPO_NOTIFICA__8.setType( com.codecharge.components.ControlType.TEXT );
            TIPO_NOTIFICA__8.setHtmlEncode( true );
            TIPO_NOTIFICA__8.setCaption( "TIPO_NOTIFICA" );
            AD4_RICHIESTE_ABILITAZIONE.add( TIPO_NOTIFICA__8 );

            com.codecharge.components.TextBox INDIRIZZO_NOTIFICA__9 = new com.codecharge.components.TextBox("INDIRIZZO_NOTIFICA", "INDIRIZZO_NOTIFICA", this );
            INDIRIZZO_NOTIFICA__9.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_NOTIFICA__9.setHtmlEncode( true );
            INDIRIZZO_NOTIFICA__9.setCaption( "INDIRIZZO_NOTIFICA" );
            AD4_RICHIESTE_ABILITAZIONE.add( INDIRIZZO_NOTIFICA__9 );

            com.codecharge.components.Button Button_Update__11 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__11.addExcludeParam( "ccsForm" );
            Button_Update__11.addExcludeParam( "Button_Update" );
            Button_Update__11.setOperation( "Update" );
            AD4_RICHIESTE_ABILITAZIONE.add( Button_Update__11 );

            com.codecharge.components.Button Button_Cancel__12 = new com.codecharge.components.Button("Button_Cancel", this);
            Button_Cancel__12.addExcludeParam( "ccsForm" );
            Button_Cancel__12.addExcludeParam( "Button_Cancel" );
            Button_Cancel__12.setOperation( "Cancel" );
            AD4_RICHIESTE_ABILITAZIONE.add( Button_Cancel__12 );
            add(AD4_RICHIESTE_ABILITAZIONE);
        } // End definition of AD4_RICHIESTE_ABILITAZIONE record model.
//End AD4_RICHIESTE_ABILITAZIONE record

//AdmRichiestaNotificaModel class tail @1-F5FC18C5
    }
}
//End AdmRichiestaNotificaModel class tail


