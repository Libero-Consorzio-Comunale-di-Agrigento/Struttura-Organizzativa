//AdmUtentiGruppoAggiornaModel imports @1-D07C8B9D
package amvadm.AdmUtentiGruppoAggiorna;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtentiGruppoAggiornaModel imports

//AdmUtentiGruppoAggiornaModel class head @1-CAA2A7AF
public class AdmUtentiGruppoAggiornaModel extends com.codecharge.components.Page {
    public AdmUtentiGruppoAggiornaModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtentiGruppoAggiornaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtentiGruppoAggiornaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtentiGruppoAggiornaModel class head

//page settings @1-5E688B22
        super("AdmUtentiGruppoAggiorna", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//UTENTI_GRUPPO record @2-59750285
        
        /*
            Model of UTENTI_GRUPPO record defining.
        */
        {
            com.codecharge.components.Record UTENTI_GRUPPO = new com.codecharge.components.Record("UTENTI_GRUPPO");
            UTENTI_GRUPPO.setPageModel( this );
            UTENTI_GRUPPO.addExcludeParam( "ccsForm" );
            UTENTI_GRUPPO.setVisible( true );
            UTENTI_GRUPPO.setAllowInsert(false);
            UTENTI_GRUPPO.setAllowDelete(false);
            UTENTI_GRUPPO.setPreserveType(PreserveParameterType.GET);
            UTENTI_GRUPPO.setReturnPage("AdmUtentiGruppoAggiorna" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox UTENTE__3 = new com.codecharge.components.TextBox("UTENTE", "P_UTENTE", this );
            UTENTE__3.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE__3.setHtmlEncode( true );
            UTENTE__3.setCaption( "UTENTE" );
            UTENTI_GRUPPO.add( UTENTE__3 );

            com.codecharge.components.TextBox P_GRUPPO__4 = new com.codecharge.components.TextBox("P_GRUPPO", "P_GRUPPO", this );
            P_GRUPPO__4.setType( com.codecharge.components.ControlType.TEXT );
            P_GRUPPO__4.setHtmlEncode( true );
            P_GRUPPO__4.setCaption( "P_GRUPPO" );
            UTENTI_GRUPPO.add( P_GRUPPO__4 );

            com.codecharge.components.Button Button_Insert__7 = new com.codecharge.components.Button("Button_Insert", this);
            Button_Insert__7.addExcludeParam( "ccsForm" );
            Button_Insert__7.addExcludeParam( "Button_Insert" );
            Button_Insert__7.setOperation( "Insert" );
            UTENTI_GRUPPO.add( Button_Insert__7 );

            com.codecharge.components.Button Button_Update__8 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__8.addExcludeParam( "ccsForm" );
            Button_Update__8.addExcludeParam( "Button_Update" );
            Button_Update__8.setOperation( "Update" );
            UTENTI_GRUPPO.add( Button_Update__8 );

            com.codecharge.components.Button Button_Delete__9 = new com.codecharge.components.Button("Button_Delete", this);
            Button_Delete__9.addExcludeParam( "ccsForm" );
            Button_Delete__9.addExcludeParam( "Button_Delete" );
            Button_Delete__9.setOperation( "Delete" );
            UTENTI_GRUPPO.add( Button_Delete__9 );
            add(UTENTI_GRUPPO);
        } // End definition of UTENTI_GRUPPO record model.
//End UTENTI_GRUPPO record

//AdmUtentiGruppoAggiornaModel class tail @1-F5FC18C5
    }
}
//End AdmUtentiGruppoAggiornaModel class tail

