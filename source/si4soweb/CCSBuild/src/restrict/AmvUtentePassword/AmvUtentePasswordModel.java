//AmvUtentePasswordModel imports @1-470CC1BA
package restrict.AmvUtentePassword;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtentePasswordModel imports

//AmvUtentePasswordModel class head @1-93820ADC
public class AmvUtentePasswordModel extends com.codecharge.components.Page {
    public AmvUtentePasswordModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtentePasswordModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtentePasswordModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtentePasswordModel class head

//page settings @1-4BC06015
        super("AmvUtentePassword", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__5 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__5.setVisible( true );
            add( AmvGuida__5 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTI record @6-5F14E244
        
        /*
            Model of AD4_UTENTI record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTI = new com.codecharge.components.Record("AD4_UTENTI");
            AD4_UTENTI.setPageModel( this );
            AD4_UTENTI.addExcludeParam( "ccsForm" );
            AD4_UTENTI.setVisible( true );
            AD4_UTENTI.setAllowInsert(false);
            AD4_UTENTI.setAllowDelete(false);
            AD4_UTENTI.setPreserveType(PreserveParameterType.GET);
            AD4_UTENTI.setReturnPage("AmvUtentePassword" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox PASSWORD_ATTUALE__22 = new com.codecharge.components.TextBox("PASSWORD_ATTUALE", "", this );
            PASSWORD_ATTUALE__22.setType( com.codecharge.components.ControlType.TEXT );
            PASSWORD_ATTUALE__22.setHtmlEncode( true );
            PASSWORD_ATTUALE__22.setCaption( "Password attuale" );
            AD4_UTENTI.add( PASSWORD_ATTUALE__22 );

            com.codecharge.components.TextBox NUOVA_PASSWORD__23 = new com.codecharge.components.TextBox("NUOVA_PASSWORD", "", this );
            NUOVA_PASSWORD__23.setType( com.codecharge.components.ControlType.TEXT );
            NUOVA_PASSWORD__23.setHtmlEncode( true );
            NUOVA_PASSWORD__23.setCaption( "Nuova password" );
            NUOVA_PASSWORD__23.addValidateHandler( new RequiredHandler( "Il valore nel campo Nuova password è richiesto." ) );
            AD4_UTENTI.add( NUOVA_PASSWORD__23 );

            com.codecharge.components.TextBox CONFERMA_PASSWORD__24 = new com.codecharge.components.TextBox("CONFERMA_PASSWORD", "", this );
            CONFERMA_PASSWORD__24.setType( com.codecharge.components.ControlType.TEXT );
            CONFERMA_PASSWORD__24.setHtmlEncode( true );
            CONFERMA_PASSWORD__24.setCaption( "Conferma nuova password" );
            CONFERMA_PASSWORD__24.addValidateHandler( new RequiredHandler( "Il valore nel campo Conferma nuova password è richiesto." ) );
            AD4_UTENTI.add( CONFERMA_PASSWORD__24 );

            com.codecharge.components.Button Button_Update__26 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__26.addExcludeParam( "ccsForm" );
            Button_Update__26.addExcludeParam( "Button_Update" );
            Button_Update__26.setOperation( "Update" );
            AD4_UTENTI.add( Button_Update__26 );

            com.codecharge.components.Button Button_Cancel__28 = new com.codecharge.components.Button("Button_Cancel", this);
            Button_Cancel__28.addExcludeParam( "ccsForm" );
            Button_Cancel__28.addExcludeParam( "Button_Cancel" );
            Button_Cancel__28.setOperation( "Cancel" );
            AD4_UTENTI.add( Button_Cancel__28 );
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI record model.
//End AD4_UTENTI record

//AmvUtentePasswordModel class tail @1-F5FC18C5
    }
}
//End AmvUtentePasswordModel class tail

