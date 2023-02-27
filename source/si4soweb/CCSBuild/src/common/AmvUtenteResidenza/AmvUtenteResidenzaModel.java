//AmvUtenteResidenzaModel imports @1-DF7038D2
package common.AmvUtenteResidenza;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtenteResidenzaModel imports

//AmvUtenteResidenzaModel class head @1-9C314B84
public class AmvUtenteResidenzaModel extends com.codecharge.components.Page {
    public AmvUtenteResidenzaModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtenteResidenzaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtenteResidenzaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtenteResidenzaModel class head

//page settings @1-8C9848D6
        super("AmvUtenteResidenza", locale );
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

//AD4_UTENTE record @6-543BC5DA
        
        /*
            Model of AD4_UTENTE record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTE = new com.codecharge.components.Record("AD4_UTENTE");
            AD4_UTENTE.setPageModel( this );
            AD4_UTENTE.addExcludeParam( "ccsForm" );
            AD4_UTENTE.setVisible( true );
            AD4_UTENTE.setAllowInsert(false);
            AD4_UTENTE.setAllowDelete(false);
            AD4_UTENTE.setPreserveType(PreserveParameterType.ALL);
            AD4_UTENTE.setReturnPage("AmvUtenteResidenza" + Names.ACTION_SUFFIX);
            AD4_UTENTE.addRecordListener(new AD4_UTENTERecordHandler());

            com.codecharge.components.TextBox NOMINATIVO__47 = new com.codecharge.components.TextBox("NOMINATIVO", "NOME", this );
            NOMINATIVO__47.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__47.setHtmlEncode( true );
            NOMINATIVO__47.setCaption( "NOMINATIVO" );
            AD4_UTENTE.add( NOMINATIVO__47 );

            com.codecharge.components.TextBox INDIRIZZO_COMPLETO__48 = new com.codecharge.components.TextBox("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO", this );
            INDIRIZZO_COMPLETO__48.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_COMPLETO__48.setHtmlEncode( true );
            INDIRIZZO_COMPLETO__48.setCaption( "NOMINATIVO" );
            AD4_UTENTE.add( INDIRIZZO_COMPLETO__48 );

            com.codecharge.components.ListBox VIA__14 = new com.codecharge.components.ListBox("VIA", "", this );
            VIA__14.setType( com.codecharge.components.ControlType.TEXT );
            VIA__14.setHtmlEncode( true );
            VIA__14.setCaption( "VIA" );
            AD4_UTENTE.add( VIA__14 );

            com.codecharge.components.TextBox INDIRIZZO__15 = new com.codecharge.components.TextBox("INDIRIZZO", "", this );
            INDIRIZZO__15.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO__15.setHtmlEncode( true );
            INDIRIZZO__15.setCaption( "INDIRIZZO" );
            AD4_UTENTE.add( INDIRIZZO__15 );

            com.codecharge.components.TextBox NUM__16 = new com.codecharge.components.TextBox("NUM", "", this );
            NUM__16.setType( com.codecharge.components.ControlType.TEXT );
            NUM__16.setHtmlEncode( true );
            NUM__16.setCaption( "NUM" );
            AD4_UTENTE.add( NUM__16 );

            com.codecharge.components.ListBox PROVINCIA__17 = new com.codecharge.components.ListBox("PROVINCIA", "", this );
            PROVINCIA__17.setType( com.codecharge.components.ControlType.INTEGER );
            PROVINCIA__17.setHtmlEncode( true );
            PROVINCIA__17.setCaption( "PROVINCIA" );
            PROVINCIA__17.setBoundColumn( "PROVINCIA" );
            PROVINCIA__17.setTextColumn( "DENOMINAZIONE" );
            AD4_UTENTE.add( PROVINCIA__17 );

            com.codecharge.components.ListBox COMUNE__18 = new com.codecharge.components.ListBox("COMUNE", "", this );
            COMUNE__18.setType( com.codecharge.components.ControlType.INTEGER );
            COMUNE__18.setHtmlEncode( true );
            COMUNE__18.setCaption( "COMUNE" );
            COMUNE__18.setBoundColumn( "COMUNE" );
            COMUNE__18.setTextColumn( "DENOMINAZIONE" );
            AD4_UTENTE.add( COMUNE__18 );

            com.codecharge.components.TextBox CAP__21 = new com.codecharge.components.TextBox("CAP", "", this );
            CAP__21.setType( com.codecharge.components.ControlType.TEXT );
            CAP__21.setHtmlEncode( true );
            CAP__21.setCaption( "CAP" );
            AD4_UTENTE.add( CAP__21 );

            com.codecharge.components.Hidden MVPAGES__52 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__52.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__52.setHtmlEncode( true );
            AD4_UTENTE.add( MVPAGES__52 );

            com.codecharge.components.Button Button_Update__22 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__22.addExcludeParam( "ccsForm" );
            Button_Update__22.addExcludeParam( "Button_Update" );
            Button_Update__22.setOperation( "Update" );
            AD4_UTENTE.add( Button_Update__22 );

            com.codecharge.components.Button Button_Cancel__23 = new com.codecharge.components.Button("Button_Cancel", this);
            Button_Cancel__23.addExcludeParam( "ccsForm" );
            Button_Cancel__23.addExcludeParam( "Button_Cancel" );
            Button_Cancel__23.setOperation( "Cancel" );
            AD4_UTENTE.add( Button_Cancel__23 );
            add(AD4_UTENTE);
        } // End definition of AD4_UTENTE record model.
//End AD4_UTENTE record

//AmvUtenteResidenzaModel class tail @1-F5FC18C5
    }
}
//End AmvUtenteResidenzaModel class tail

