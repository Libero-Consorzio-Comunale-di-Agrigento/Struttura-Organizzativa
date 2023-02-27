//AmvUtenteRecapitoInfoModel imports @1-DC90B555
package restrict.AmvUtenteRecapitoInfo;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtenteRecapitoInfoModel imports

//AmvUtenteRecapitoInfoModel class head @1-D440238E
public class AmvUtenteRecapitoInfoModel extends com.codecharge.components.Page {
    public AmvUtenteRecapitoInfoModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtenteRecapitoInfoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtenteRecapitoInfoModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtenteRecapitoInfoModel class head

//page settings @1-4C3DEA60
        super("AmvUtenteRecapitoInfo", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__5 = new com.codecharge.components.IncludePage("Header", this );
            Header__5.setVisible( true );
            add( Header__5 );
            com.codecharge.components.IncludePage Left__2 = new com.codecharge.components.IncludePage("Left", this );
            Left__2.setVisible( true );
            add( Left__2 );
            com.codecharge.components.IncludePage AmvGuida__3 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__3.setVisible( true );
            add( AmvGuida__3 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTI record @6-A83D7A7C
        
        /*
            Model of AD4_UTENTI record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTI = new com.codecharge.components.Record("AD4_UTENTI");
            AD4_UTENTI.setPageModel( this );
            AD4_UTENTI.addExcludeParam( "ccsForm" );
            AD4_UTENTI.addExcludeParam( "INDIRIZZO_WEB" );
            AD4_UTENTI.addExcludeParam( "TELEFONO" );
            AD4_UTENTI.addExcludeParam( "FAX" );
            AD4_UTENTI.setVisible( true );
            AD4_UTENTI.setAllowInsert(false);
            AD4_UTENTI.setAllowDelete(false);
            AD4_UTENTI.setPreserveType(PreserveParameterType.ALL);
            AD4_UTENTI.setReturnPage("AmvUtenteRecapitoInfo" + Names.ACTION_SUFFIX);
            AD4_UTENTI.addRecordListener(new AD4_UTENTIRecordHandler());

            com.codecharge.components.TextBox NOMINATIVO__35 = new com.codecharge.components.TextBox("NOMINATIVO", "NOME", this );
            NOMINATIVO__35.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__35.setHtmlEncode( true );
            NOMINATIVO__35.setCaption( "NOMINATIVO" );
            AD4_UTENTI.add( NOMINATIVO__35 );

            com.codecharge.components.TextBox INDIRIZZO_WEB__22 = new com.codecharge.components.TextBox("INDIRIZZO_WEB", "INDIRIZZO_WEB", this );
            INDIRIZZO_WEB__22.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_WEB__22.setHtmlEncode( true );
            INDIRIZZO_WEB__22.setCaption( "E-MAIL" );
            AD4_UTENTI.add( INDIRIZZO_WEB__22 );

            com.codecharge.components.TextBox TELEFONO__23 = new com.codecharge.components.TextBox("TELEFONO", "TELEFONO", this );
            TELEFONO__23.setType( com.codecharge.components.ControlType.TEXT );
            TELEFONO__23.setHtmlEncode( true );
            TELEFONO__23.setCaption( "TELEFONO" );
            AD4_UTENTI.add( TELEFONO__23 );

            com.codecharge.components.TextBox FAX__24 = new com.codecharge.components.TextBox("FAX", "FAX", this );
            FAX__24.setType( com.codecharge.components.ControlType.TEXT );
            FAX__24.setHtmlEncode( true );
            FAX__24.setCaption( "FAX" );
            AD4_UTENTI.add( FAX__24 );

            com.codecharge.components.Button Button_Update__26 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__26.addExcludeParam( "ccsForm" );
            Button_Update__26.addExcludeParam( "Button_Update" );
            Button_Update__26.setOperation( "Search" );
            AD4_UTENTI.add( Button_Update__26 );

            com.codecharge.components.Hidden MVPAGES__36 = new com.codecharge.components.Hidden("MVPAGES", this);
            MVPAGES__36.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__36.setHtmlEncode( true );
            AD4_UTENTI.add( MVPAGES__36 );
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI record model.
//End AD4_UTENTI record

//AmvUtenteRecapitoInfoModel class tail @1-F5FC18C5
    }
}
//End AmvUtenteRecapitoInfoModel class tail

