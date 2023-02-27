//AdmRichiestaModel imports @1-EABCB7E0
package amvadm.AdmRichiesta;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRichiestaModel imports

//AdmRichiestaModel class head @1-BA48BABE
public class AdmRichiestaModel extends com.codecharge.components.Page {
    public AdmRichiestaModel() {
        this( new CCSLocale(), null );
    }

    public AdmRichiestaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRichiestaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRichiestaModel class head

//page settings @1-5E9B1B18
        super("AdmRichiesta", locale );
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

//AD4_RICHIESTE_ABILITAZIONEGrid grid @30-BC4ACFB3
        
        /*
            // Begin definition of AD4_RICHIESTE_ABILITAZIONEGrid grid model.
        */
        {
            com.codecharge.components.Grid AD4_RICHIESTE_ABILITAZIONEGrid = new com.codecharge.components.Grid("AD4_RICHIESTE_ABILITAZIONEGrid");
            AD4_RICHIESTE_ABILITAZIONEGrid.setPageModel( this );
            AD4_RICHIESTE_ABILITAZIONEGrid.setFetchSize(20);
            AD4_RICHIESTE_ABILITAZIONEGrid.setVisible( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.addGridListener( new AD4_RICHIESTE_ABILITAZIONEGridGridHandler() );

            com.codecharge.components.Label DATA__57 = new com.codecharge.components.Label("DATA", "DATA", this );
            DATA__57.setType( com.codecharge.components.ControlType.TEXT );
            DATA__57.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(DATA__57);

            com.codecharge.components.Label SERVIZIO__34 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__34.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__34.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(SERVIZIO__34);

            com.codecharge.components.Link RICHIEDENTE__35 = new com.codecharge.components.Link("RICHIEDENTE", "RICHIEDENTE", this );
            RICHIEDENTE__35.setType( com.codecharge.components.ControlType.TEXT );
            RICHIEDENTE__35.setHtmlEncode( true );
            RICHIEDENTE__35.addControlListener( new AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler());
            RICHIEDENTE__35.setHrefSourceValue( "AdmUtenteDatiInfo" + Names.ACTION_SUFFIX );
            RICHIEDENTE__35.setHrefType( "Page" );
            RICHIEDENTE__35.setConvertRule("Relative");
            RICHIEDENTE__35.setPreserveType(PreserveParameterType.NONE);
            RICHIEDENTE__35.addParameter( new LinkParameter( "MVVC", "", ParameterSource.EXPRESSION) );
            AD4_RICHIESTE_ABILITAZIONEGrid.add( RICHIEDENTE__35 );

            com.codecharge.components.Hidden UTENTE__55 = new com.codecharge.components.Hidden("UTENTE", "UTENTE", this );
            UTENTE__55.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE__55.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add( UTENTE__55 );

            com.codecharge.components.Label STATO__37 = new com.codecharge.components.Label("STATO", "STATO", this );
            STATO__37.setType( com.codecharge.components.ControlType.TEXT );
            STATO__37.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(STATO__37);

            com.codecharge.components.Hidden COD_STATO__63 = new com.codecharge.components.Hidden("COD_STATO", "COD_STATO", this );
            COD_STATO__63.setType( com.codecharge.components.ControlType.TEXT );
            COD_STATO__63.setHtmlEncode( true );
            COD_STATO__63.addControlListener( new AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler());
            AD4_RICHIESTE_ABILITAZIONEGrid.add( COD_STATO__63 );

            com.codecharge.components.Label NOTIFICATA__58 = new com.codecharge.components.Label("NOTIFICATA", "NOTIFICATA", this );
            NOTIFICATA__58.setType( com.codecharge.components.ControlType.TEXT );
            NOTIFICATA__58.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(NOTIFICATA__58);

            com.codecharge.components.Hidden COD_NOTIFICATA__66 = new com.codecharge.components.Hidden("COD_NOTIFICATA", "COD_NOTIFICATA", this );
            COD_NOTIFICATA__66.setType( com.codecharge.components.ControlType.TEXT );
            COD_NOTIFICATA__66.setHtmlEncode( true );
            COD_NOTIFICATA__66.addControlListener( new AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler());
            AD4_RICHIESTE_ABILITAZIONEGrid.add( COD_NOTIFICATA__66 );

            com.codecharge.components.Label TIPO_NOTIFICA__38 = new com.codecharge.components.Label("TIPO_NOTIFICA", "TIPO_NOTIFICA", this );
            TIPO_NOTIFICA__38.setType( com.codecharge.components.ControlType.TEXT );
            TIPO_NOTIFICA__38.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(TIPO_NOTIFICA__38);

            com.codecharge.components.Label INDIRIZZO_NOTIFICA__39 = new com.codecharge.components.Label("INDIRIZZO_NOTIFICA", "INDIRIZZO_NOTIFICA", this );
            INDIRIZZO_NOTIFICA__39.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_NOTIFICA__39.setHtmlEncode( true );
            AD4_RICHIESTE_ABILITAZIONEGrid.add(INDIRIZZO_NOTIFICA__39);

            com.codecharge.components.Link MODIFICA_NOTIFICA__51 = new com.codecharge.components.Link("MODIFICA_NOTIFICA", "", this );
            MODIFICA_NOTIFICA__51.setType( com.codecharge.components.ControlType.TEXT );
            MODIFICA_NOTIFICA__51.setHtmlEncode( true );
            MODIFICA_NOTIFICA__51.setHrefSourceValue( "AdmRichiestaNotifica" + Names.ACTION_SUFFIX );
            MODIFICA_NOTIFICA__51.setHrefType( "Page" );
            MODIFICA_NOTIFICA__51.setConvertRule("Relative");
            MODIFICA_NOTIFICA__51.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTE_ABILITAZIONEGrid.add( MODIFICA_NOTIFICA__51 );
            add(AD4_RICHIESTE_ABILITAZIONEGrid);
        } // End definition of AD4_RICHIESTE_ABILITAZIONEGrid grid model
//End AD4_RICHIESTE_ABILITAZIONEGrid grid

//AD4_RICHIESTE_ABILITAZIONERecord record @7-F02B13C0
        
        /*
            Model of AD4_RICHIESTE_ABILITAZIONERecord record defining.
        */
        {
            com.codecharge.components.Record AD4_RICHIESTE_ABILITAZIONERecord = new com.codecharge.components.Record("AD4_RICHIESTE_ABILITAZIONERecord");
            AD4_RICHIESTE_ABILITAZIONERecord.setPageModel( this );
            AD4_RICHIESTE_ABILITAZIONERecord.addExcludeParam( "ccsForm" );
            AD4_RICHIESTE_ABILITAZIONERecord.addExcludeParam( "STATO" );
            AD4_RICHIESTE_ABILITAZIONERecord.setVisible( true );
            AD4_RICHIESTE_ABILITAZIONERecord.setAllowInsert(false);
            AD4_RICHIESTE_ABILITAZIONERecord.setAllowDelete(false);
            AD4_RICHIESTE_ABILITAZIONERecord.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTE_ABILITAZIONERecord.setReturnPage("AdmRichiesta" + Names.ACTION_SUFFIX);

            com.codecharge.components.Link REVISIONE_PARAMETRI__56 = new com.codecharge.components.Link("REVISIONE_PARAMETRI", "REVISIONE_PARAMETRI", this );
            REVISIONE_PARAMETRI__56.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE_PARAMETRI__56.setHtmlEncode( true );
            REVISIONE_PARAMETRI__56.setHrefSource( "REVISIONE_PARAMETRI_HREF" );
            REVISIONE_PARAMETRI__56.setHrefType( "Database" );
            REVISIONE_PARAMETRI__56.setConvertRule("Relative");
            REVISIONE_PARAMETRI__56.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTE_ABILITAZIONERecord.add( REVISIONE_PARAMETRI__56 );

            com.codecharge.components.Link REVISIONE_COMPETENZA__48 = new com.codecharge.components.Link("REVISIONE_COMPETENZA", "REVISIONE_COMPETENZA", this );
            REVISIONE_COMPETENZA__48.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE_COMPETENZA__48.setHtmlEncode( true );
            REVISIONE_COMPETENZA__48.setHrefSource( "REVISIONE_COMPETENZA_HREF" );
            REVISIONE_COMPETENZA__48.setHrefType( "Database" );
            REVISIONE_COMPETENZA__48.setConvertRule("Relative");
            REVISIONE_COMPETENZA__48.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTE_ABILITAZIONERecord.add( REVISIONE_COMPETENZA__48 );

            com.codecharge.components.Button Annulla__46 = new com.codecharge.components.Button("Annulla", this);
            Annulla__46.addExcludeParam( "ccsForm" );
            Annulla__46.addExcludeParam( "Annulla" );
            Annulla__46.addExcludeParam( "MOD" );
            Annulla__46.addExcludeParam( "IST" );
            Annulla__46.setOperation( "Cancel" );
            AD4_RICHIESTE_ABILITAZIONERecord.add( Annulla__46 );

            com.codecharge.components.Button Respingi__26 = new com.codecharge.components.Button("Respingi", this);
            Respingi__26.addButtonListener(new AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler());
            Respingi__26.addExcludeParam( "ccsForm" );
            Respingi__26.addExcludeParam( "Respingi" );
            Respingi__26.setOperation( "Update" );
            AD4_RICHIESTE_ABILITAZIONERecord.add( Respingi__26 );

            com.codecharge.components.Button Approva__9 = new com.codecharge.components.Button("Approva", this);
            Approva__9.addButtonListener(new AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler());
            Approva__9.addExcludeParam( "ccsForm" );
            Approva__9.addExcludeParam( "Approva" );
            Approva__9.setOperation( "Update" );
            AD4_RICHIESTE_ABILITAZIONERecord.add( Approva__9 );

            com.codecharge.components.Button Convalida__59 = new com.codecharge.components.Button("Convalida", this);
            Convalida__59.addButtonListener(new AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler());
            Convalida__59.addExcludeParam( "ccsForm" );
            Convalida__59.addExcludeParam( "Convalida" );
            Convalida__59.setOperation( "Update" );
            AD4_RICHIESTE_ABILITAZIONERecord.add( Convalida__59 );

            com.codecharge.components.Button Notifica__61 = new com.codecharge.components.Button("Notifica", this);
            Notifica__61.addButtonListener(new AD4_RICHIESTE_ABILITAZIONERecordNotificaHandler());
            Notifica__61.addExcludeParam( "ccsForm" );
            Notifica__61.addExcludeParam( "Notifica" );
            Notifica__61.setOperation( "Update" );
            AD4_RICHIESTE_ABILITAZIONERecord.add( Notifica__61 );
            add(AD4_RICHIESTE_ABILITAZIONERecord);
        } // End definition of AD4_RICHIESTE_ABILITAZIONERecord record model.
//End AD4_RICHIESTE_ABILITAZIONERecord record

//AdmRichiestaModel class tail @1-F5FC18C5
    }
}
//End AdmRichiestaModel class tail

