//AmvProfiloModel imports @1-6133611C
package restrict.AmvProfilo;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvProfiloModel imports

//AmvProfiloModel class head @1-AC62E15C
public class AmvProfiloModel extends com.codecharge.components.Page {
    public AmvProfiloModel() {
        this( new CCSLocale(), null );
    }

    public AmvProfiloModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvProfiloModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvProfiloModel class head

//page settings @1-E22579C2
        super("AmvProfilo", locale );
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

//MESSAGGIO_PASSWORD grid @42-9427C5E4
        
        /*
            // Begin definition of MESSAGGIO_PASSWORD grid model.
        */
        {
            com.codecharge.components.Grid MESSAGGIO_PASSWORD = new com.codecharge.components.Grid("MESSAGGIO_PASSWORD");
            MESSAGGIO_PASSWORD.setPageModel( this );
            MESSAGGIO_PASSWORD.setFetchSize(100);
            MESSAGGIO_PASSWORD.setVisible( true );

            com.codecharge.components.Label MESSAGGIO__43 = new com.codecharge.components.Label("MESSAGGIO", "MESSAGGIO", this );
            MESSAGGIO__43.setType( com.codecharge.components.ControlType.TEXT );
            MESSAGGIO_PASSWORD.add(MESSAGGIO__43);
            add(MESSAGGIO_PASSWORD);
        } // End definition of MESSAGGIO_PASSWORD grid model
//End MESSAGGIO_PASSWORD grid

//AD4_UTENTI record @6-E0BD7DDC
        
        /*
            Model of AD4_UTENTI record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTI = new com.codecharge.components.Record("AD4_UTENTI");
            AD4_UTENTI.setPageModel( this );
            AD4_UTENTI.addExcludeParam( "ccsForm" );
            AD4_UTENTI.setVisible( true );
            AD4_UTENTI.setAllowInsert(false);
            AD4_UTENTI.setAllowUpdate(false);
            AD4_UTENTI.setAllowDelete(false);
            AD4_UTENTI.setPreserveType(PreserveParameterType.GET);
            AD4_UTENTI.setReturnPage("AmvProfilo" + Names.ACTION_SUFFIX);
            AD4_UTENTI.addRecordListener(new AD4_UTENTIRecordHandler());

            com.codecharge.components.Label NOMINATIVO__7 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__7.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__7.setHtmlEncode( true );
            AD4_UTENTI.add(NOMINATIVO__7);

            com.codecharge.components.Label RUOLO__36 = new com.codecharge.components.Label("RUOLO", "RUOLO", this );
            RUOLO__36.setType( com.codecharge.components.ControlType.TEXT );
            RUOLO__36.setHtmlEncode( true );
            AD4_UTENTI.add(RUOLO__36);

            com.codecharge.components.Label DATA_PASSWORD__8 = new com.codecharge.components.Label("DATA_PASSWORD", "DATA_PASSWORD", this );
            DATA_PASSWORD__8.setType( com.codecharge.components.ControlType.TEXT );
            DATA_PASSWORD__8.setHtmlEncode( true );
            AD4_UTENTI.add(DATA_PASSWORD__8);

            com.codecharge.components.Hidden RINNOVO_PASSWORD_PORTALE__40 = new com.codecharge.components.Hidden("RINNOVO_PASSWORD_PORTALE", "RINNOVO_PASSWORD_PORTALE", this );
            RINNOVO_PASSWORD_PORTALE__40.setType( com.codecharge.components.ControlType.TEXT );
            RINNOVO_PASSWORD_PORTALE__40.setHtmlEncode( true );
            AD4_UTENTI.add( RINNOVO_PASSWORD_PORTALE__40 );

            com.codecharge.components.Hidden RINNOVO_PASSWORD__38 = new com.codecharge.components.Hidden("RINNOVO_PASSWORD", "RINNOVO_PASSWORD", this );
            RINNOVO_PASSWORD__38.setType( com.codecharge.components.ControlType.TEXT );
            RINNOVO_PASSWORD__38.setHtmlEncode( true );
            AD4_UTENTI.add( RINNOVO_PASSWORD__38 );

            com.codecharge.components.Button Button_Update__26 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__26.addExcludeParam( "ccsForm" );
            Button_Update__26.addExcludeParam( "Button_Update" );
            AD4_UTENTI.add( Button_Update__26 );
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI record model.
//End AD4_UTENTI record

//AmvProfiloModel class tail @1-F5FC18C5
    }
}
//End AmvProfiloModel class tail

