//AmvServiziRichiestaModel imports @1-2C981259
package common.AmvServiziRichiesta;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziRichiestaModel imports

//AmvServiziRichiestaModel class head @1-58838504
public class AmvServiziRichiestaModel extends com.codecharge.components.Page {
    public AmvServiziRichiestaModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziRichiestaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziRichiestaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziRichiestaModel class head

//page settings @1-B4297EBD
        super("AmvServiziRichiesta", locale );
        setResponse(response);
        addPageListener(new AmvServiziRichiestaPageHandler());
        {
            com.codecharge.components.IncludePage Header__34 = new com.codecharge.components.IncludePage("Header", this );
            Header__34.setVisible( true );
            add( Header__34 );
            com.codecharge.components.IncludePage Left__35 = new com.codecharge.components.IncludePage("Left", this );
            Left__35.setVisible( true );
            add( Left__35 );
            com.codecharge.components.IncludePage AmvGuida__37 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__37.setVisible( true );
            add( AmvGuida__37 );
            com.codecharge.components.IncludePage Footer__36 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__36.setVisible( true );
            add( Footer__36 );
        } // end page
//End page settings

//AD4_UTENTEGrid grid @67-74854F2E
        
        /*
            // Begin definition of AD4_UTENTEGrid grid model.
        */
        {
            com.codecharge.components.Grid AD4_UTENTEGrid = new com.codecharge.components.Grid("AD4_UTENTEGrid");
            AD4_UTENTEGrid.setPageModel( this );
            AD4_UTENTEGrid.setFetchSize(20);
            AD4_UTENTEGrid.setVisible( true );
            AD4_UTENTEGrid.addGridListener( new AD4_UTENTEGridGridHandler() );

            com.codecharge.components.Label NOMINATIVO__68 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__68.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTEGrid.add(NOMINATIVO__68);

            com.codecharge.components.Label PASSWORD__69 = new com.codecharge.components.Label("PASSWORD", "PASSWORD", this );
            PASSWORD__69.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTEGrid.add(PASSWORD__69);

            com.codecharge.components.Label NOTIFICA__70 = new com.codecharge.components.Label("NOTIFICA", "NOTIFICA", this );
            NOTIFICA__70.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTEGrid.add(NOTIFICA__70);

            com.codecharge.components.Label INDIRIZZO_COMPLETO__78 = new com.codecharge.components.Label("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO", this );
            INDIRIZZO_COMPLETO__78.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_COMPLETO__78.setHtmlEncode( true );
            AD4_UTENTEGrid.add(INDIRIZZO_COMPLETO__78);

            com.codecharge.components.Link MODIFICA_RESIDENZA__82 = new com.codecharge.components.Link("MODIFICA_RESIDENZA", "", this );
            MODIFICA_RESIDENZA__82.setType( com.codecharge.components.ControlType.TEXT );
            MODIFICA_RESIDENZA__82.setHtmlEncode( true );
            MODIFICA_RESIDENZA__82.setHrefSourceValue( "AmvUtenteResidenza" + Names.ACTION_SUFFIX );
            MODIFICA_RESIDENZA__82.setHrefType( "Page" );
            MODIFICA_RESIDENZA__82.setConvertRule("Relative");
            MODIFICA_RESIDENZA__82.setPreserveType(PreserveParameterType.ALL);
            MODIFICA_RESIDENZA__82.addParameter( new LinkParameter( "MVPAGES", "", ParameterSource.EXPRESSION) );
            AD4_UTENTEGrid.add( MODIFICA_RESIDENZA__82 );

            com.codecharge.components.Label INDIRIZZO_WEB__79 = new com.codecharge.components.Label("INDIRIZZO_WEB", "INDIRIZZO_WEB", this );
            INDIRIZZO_WEB__79.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_WEB__79.setHtmlEncode( true );
            AD4_UTENTEGrid.add(INDIRIZZO_WEB__79);

            com.codecharge.components.Link MODIFICA_RECAPITO__83 = new com.codecharge.components.Link("MODIFICA_RECAPITO", "", this );
            MODIFICA_RECAPITO__83.setType( com.codecharge.components.ControlType.TEXT );
            MODIFICA_RECAPITO__83.setHtmlEncode( true );
            MODIFICA_RECAPITO__83.setHrefSourceValue( "AmvUtenteRecapito" + Names.ACTION_SUFFIX );
            MODIFICA_RECAPITO__83.setHrefType( "Page" );
            MODIFICA_RECAPITO__83.setConvertRule("Relative");
            MODIFICA_RECAPITO__83.setPreserveType(PreserveParameterType.ALL);
            MODIFICA_RECAPITO__83.addParameter( new LinkParameter( "MVPAGES", "", ParameterSource.EXPRESSION) );
            AD4_UTENTEGrid.add( MODIFICA_RECAPITO__83 );

            com.codecharge.components.Label TELEFONO__80 = new com.codecharge.components.Label("TELEFONO", "TELEFONO", this );
            TELEFONO__80.setType( com.codecharge.components.ControlType.TEXT );
            TELEFONO__80.setHtmlEncode( true );
            AD4_UTENTEGrid.add(TELEFONO__80);

            com.codecharge.components.Label FAX__81 = new com.codecharge.components.Label("FAX", "FAX", this );
            FAX__81.setType( com.codecharge.components.ControlType.TEXT );
            FAX__81.setHtmlEncode( true );
            AD4_UTENTEGrid.add(FAX__81);

            com.codecharge.components.Label SERVIZIO__86 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__86.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__86.setHtmlEncode( true );
            AD4_UTENTEGrid.add(SERVIZIO__86);
            add(AD4_UTENTEGrid);
        } // End definition of AD4_UTENTEGrid grid model
//End AD4_UTENTEGrid grid

//AD4_UTENTE record @2-1E3D367F
        
        /*
            Model of AD4_UTENTE record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTE = new com.codecharge.components.Record("AD4_UTENTE");
            AD4_UTENTE.setPageModel( this );
            AD4_UTENTE.addExcludeParam( "ccsForm" );
            AD4_UTENTE.addExcludeParam( "RR,MODULO,ISTANZA" );
            AD4_UTENTE.setVisible( true );
            AD4_UTENTE.setAllowInsert(false);
            AD4_UTENTE.setAllowDelete(false);
            AD4_UTENTE.setPreserveType(PreserveParameterType.ALL);
            AD4_UTENTE.setReturnPage("AmvServiziRichiesta" + Names.ACTION_SUFFIX);

            com.codecharge.components.Button Update__25 = new com.codecharge.components.Button("Update", this);
            Update__25.addExcludeParam( "ccsForm" );
            Update__25.addExcludeParam( "Update" );
            Update__25.setOperation( "Update" );
            AD4_UTENTE.add( Update__25 );

            com.codecharge.components.Hidden ISTANZA__52 = new com.codecharge.components.Hidden("ISTANZA", "ISTANZA", this );
            ISTANZA__52.setType( com.codecharge.components.ControlType.TEXT );
            ISTANZA__52.setHtmlEncode( true );
            ISTANZA__52.setCaption( "ISTANZA" );
            AD4_UTENTE.add( ISTANZA__52 );

            com.codecharge.components.Hidden MODULO__51 = new com.codecharge.components.Hidden("MODULO", "MODULO", this );
            MODULO__51.setType( com.codecharge.components.ControlType.TEXT );
            MODULO__51.setHtmlEncode( true );
            MODULO__51.setCaption( "MODULO" );
            AD4_UTENTE.add( MODULO__51 );

            com.codecharge.components.Hidden MVPAGES__44 = new com.codecharge.components.Hidden("MVPAGES", "REDIRECTION", this );
            MVPAGES__44.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__44.setHtmlEncode( true );
            MVPAGES__44.setCaption( "MVPAGES" );
            AD4_UTENTE.add( MVPAGES__44 );
            add(AD4_UTENTE);
        } // End definition of AD4_UTENTE record model.
//End AD4_UTENTE record

//AmvServiziRichiestaModel class tail @1-F5FC18C5
    }
}
//End AmvServiziRichiestaModel class tail

