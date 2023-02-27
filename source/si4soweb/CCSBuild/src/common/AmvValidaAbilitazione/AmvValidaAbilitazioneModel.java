//AmvValidaAbilitazioneModel imports @1-2B1242BD
package common.AmvValidaAbilitazione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvValidaAbilitazioneModel imports

//AmvValidaAbilitazioneModel class head @1-21A00196
public class AmvValidaAbilitazioneModel extends com.codecharge.components.Page {
    public AmvValidaAbilitazioneModel() {
        this( new CCSLocale(), null );
    }

    public AmvValidaAbilitazioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvValidaAbilitazioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvValidaAbilitazioneModel class head

//page settings @1-C241C347
        super("AmvValidaAbilitazione", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//RICHIESTA grid @22-E2D0D32E
        
        /*
            // Begin definition of RICHIESTA grid model.
        */
        {
            com.codecharge.components.Grid RICHIESTA = new com.codecharge.components.Grid("RICHIESTA");
            RICHIESTA.setPageModel( this );
            RICHIESTA.setFetchSize(20);
            RICHIESTA.setVisible( true );

            com.codecharge.components.Label NOMINATIVO__27 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__27.setType( com.codecharge.components.ControlType.TEXT );
            RICHIESTA.add(NOMINATIVO__27);

            com.codecharge.components.Label SERVIZIO__28 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__28.setType( com.codecharge.components.ControlType.TEXT );
            RICHIESTA.add(SERVIZIO__28);
            add(RICHIESTA);
        } // End definition of RICHIESTA grid model
//End RICHIESTA grid

//GESTISCI_RICHIESTA record @7-E7AB118F
        
        /*
            Model of GESTISCI_RICHIESTA record defining.
        */
        {
            com.codecharge.components.Record GESTISCI_RICHIESTA = new com.codecharge.components.Record("GESTISCI_RICHIESTA");
            GESTISCI_RICHIESTA.setPageModel( this );
            GESTISCI_RICHIESTA.addExcludeParam( "ccsForm" );
            GESTISCI_RICHIESTA.setVisible( true );
            GESTISCI_RICHIESTA.setAllowInsert(false);
            GESTISCI_RICHIESTA.setAllowDelete(false);
            GESTISCI_RICHIESTA.setPreserveType(PreserveParameterType.NONE);
            GESTISCI_RICHIESTA.setReturnPage("AmvValidaAbilitazione" + Names.ACTION_SUFFIX);

            com.codecharge.components.Button Indietro__18 = new com.codecharge.components.Button("Indietro", this);
            Indietro__18.addExcludeParam( "ccsForm" );
            Indietro__18.addExcludeParam( "Indietro" );
            GESTISCI_RICHIESTA.add( Indietro__18 );

            com.codecharge.components.Button Update__12 = new com.codecharge.components.Button("Update", this);
            Update__12.addButtonListener(new GESTISCI_RICHIESTAUpdateHandler());
            Update__12.addExcludeParam( "ccsForm" );
            Update__12.addExcludeParam( "Update" );
            Update__12.addExcludeParam( "ccsForm" );
            Update__12.setOperation( "Update" );
            GESTISCI_RICHIESTA.add( Update__12 );

            com.codecharge.components.Button Fine__19 = new com.codecharge.components.Button("Fine", this);
            Fine__19.addButtonListener(new GESTISCI_RICHIESTAFineHandler());
            Fine__19.addExcludeParam( "ccsForm" );
            Fine__19.addExcludeParam( "Fine" );
            GESTISCI_RICHIESTA.add( Fine__19 );
            add(GESTISCI_RICHIESTA);
        } // End definition of GESTISCI_RICHIESTA record model.
//End GESTISCI_RICHIESTA record

//AmvValidaAbilitazioneModel class tail @1-F5FC18C5
    }
}
//End AmvValidaAbilitazioneModel class tail


