//AmvRegistrazioneLinkModel imports @1-13FAB288
package common.AmvRegistrazioneLink;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRegistrazioneLinkModel imports

//AmvRegistrazioneLinkModel class head @1-F8D7949A
public class AmvRegistrazioneLinkModel extends com.codecharge.components.Page {
    public AmvRegistrazioneLinkModel() {
        this( new CCSLocale(), null );
    }

    public AmvRegistrazioneLinkModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRegistrazioneLinkModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRegistrazioneLinkModel class head

//page settings @1-94B5847A
        super("AmvRegistrazioneLink", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//registrazione_servizio grid @2-A90BA5C4
        
        /*
            // Begin definition of registrazione_servizio grid model.
        */
        {
            com.codecharge.components.Grid registrazione_servizio = new com.codecharge.components.Grid("registrazione_servizio");
            registrazione_servizio.setPageModel( this );
            registrazione_servizio.setFetchSize(20);
            registrazione_servizio.setVisible( true );
            registrazione_servizio.addGridListener( new registrazione_servizioGridHandler() );

            com.codecharge.components.Label SERVIZIO__6 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__6.setType( com.codecharge.components.ControlType.TEXT );
            registrazione_servizio.add(SERVIZIO__6);

            com.codecharge.components.Label NOMINATIVO__7 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__7.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__7.setHtmlEncode( true );
            registrazione_servizio.add(NOMINATIVO__7);

            com.codecharge.components.Link REGISTRAZIONE__3 = new com.codecharge.components.Link("REGISTRAZIONE", "RICHIESTA", this );
            REGISTRAZIONE__3.setType( com.codecharge.components.ControlType.TEXT );
            REGISTRAZIONE__3.setHrefSourceValue( "/common/AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            REGISTRAZIONE__3.setHrefType( "Page" );
            REGISTRAZIONE__3.setConvertRule("Relative");
            REGISTRAZIONE__3.setPreserveType(PreserveParameterType.NONE);
            REGISTRAZIONE__3.addParameter( new LinkParameter( "MODULO", "MODULO", ParameterSource.DATAFIELD) );
            REGISTRAZIONE__3.addParameter( new LinkParameter( "ISTANZA", "ISTANZA", ParameterSource.DATAFIELD) );
            REGISTRAZIONE__3.addParameter( new LinkParameter( "RR", "", ParameterSource.EXPRESSION) );
            registrazione_servizio.add( REGISTRAZIONE__3 );
            add(registrazione_servizio);
        } // End definition of registrazione_servizio grid model
//End registrazione_servizio grid

//AmvRegistrazioneLinkModel class tail @1-F5FC18C5
    }
}
//End AmvRegistrazioneLinkModel class tail

