//AmvModificaPasswordModel imports @1-12191B60
package common.AmvModificaPassword;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvModificaPasswordModel imports

//AmvModificaPasswordModel class head @1-66ECD19E
public class AmvModificaPasswordModel extends com.codecharge.components.Page {
    public AmvModificaPasswordModel() {
        this( new CCSLocale(), null );
    }

    public AmvModificaPasswordModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvModificaPasswordModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvModificaPasswordModel class head

//page settings @1-6CA49B99
        super("AmvModificaPassword", locale );
        setResponse(response);
        addPageListener(new AmvModificaPasswordPageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );

            com.codecharge.components.Label MSG__38 = new com.codecharge.components.Label("MSG", "", this );
            MSG__38.setType( com.codecharge.components.ControlType.TEXT );
            MSG__38.setHtmlEncode( true );
            add( MSG__38 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTI record @6-EE852295
        
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
            AD4_UTENTI.setReturnPage("AmvModificaPassword" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NUOVA_PASSWORD__23 = new com.codecharge.components.TextBox("NUOVA_PASSWORD", "", this );
            NUOVA_PASSWORD__23.setType( com.codecharge.components.ControlType.TEXT );
            NUOVA_PASSWORD__23.setHtmlEncode( true );
            NUOVA_PASSWORD__23.setCaption( "NUOVA_PASSWORD" );
            AD4_UTENTI.add( NUOVA_PASSWORD__23 );

            com.codecharge.components.TextBox CONFERMA_PASSWORD__24 = new com.codecharge.components.TextBox("CONFERMA_PASSWORD", "", this );
            CONFERMA_PASSWORD__24.setType( com.codecharge.components.ControlType.TEXT );
            CONFERMA_PASSWORD__24.setHtmlEncode( true );
            CONFERMA_PASSWORD__24.setCaption( "CONFERMA_PASSWORD" );
            AD4_UTENTI.add( CONFERMA_PASSWORD__24 );

            com.codecharge.components.Hidden UTENTE__36 = new com.codecharge.components.Hidden("UTENTE", "UTENTE", this );
            UTENTE__36.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE__36.setHtmlEncode( true );
            AD4_UTENTI.add( UTENTE__36 );

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

//AmvModificaPasswordModel class tail @1-F5FC18C5
    }
}
//End AmvModificaPasswordModel class tail
