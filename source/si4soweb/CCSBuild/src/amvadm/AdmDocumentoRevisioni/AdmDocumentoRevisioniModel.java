//AdmDocumentoRevisioniModel imports @1-FF22D1E9
package amvadm.AdmDocumentoRevisioni;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmDocumentoRevisioniModel imports

//AdmDocumentoRevisioniModel class head @1-A633C2C2
public class AdmDocumentoRevisioniModel extends com.codecharge.components.Page {
    public AdmDocumentoRevisioniModel() {
        this( new CCSLocale(), null );
    }

    public AdmDocumentoRevisioniModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmDocumentoRevisioniModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmDocumentoRevisioniModel class head

//page settings @1-5DF9CB4E
        super("AdmDocumentoRevisioni", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AD4_DOCUMENTO_SEL grid @10-D82C49C0
        
        /*
            // Begin definition of AD4_DOCUMENTO_SEL grid model.
        */
        {
            com.codecharge.components.Grid AD4_DOCUMENTO_SEL = new com.codecharge.components.Grid("AD4_DOCUMENTO_SEL");
            AD4_DOCUMENTO_SEL.setPageModel( this );
            AD4_DOCUMENTO_SEL.setFetchSize(20);
            AD4_DOCUMENTO_SEL.setVisible( true );

            com.codecharge.components.Label NOME_DOCUMENTO__11 = new com.codecharge.components.Label("NOME_DOCUMENTO", "TITOLO", this );
            NOME_DOCUMENTO__11.setType( com.codecharge.components.ControlType.TEXT );
            NOME_DOCUMENTO__11.setHtmlEncode( true );
            AD4_DOCUMENTO_SEL.add(NOME_DOCUMENTO__11);

            com.codecharge.components.Label NUOVA_REV__30 = new com.codecharge.components.Label("NUOVA_REV", "NUOVA_REV", this );
            NUOVA_REV__30.setType( com.codecharge.components.ControlType.TEXT );
            AD4_DOCUMENTO_SEL.add(NUOVA_REV__30);
            add(AD4_DOCUMENTO_SEL);
        } // End definition of AD4_DOCUMENTO_SEL grid model
//End AD4_DOCUMENTO_SEL grid

//ELENCO_REVISIONI grid @2-D41C7D1E
        
        /*
            // Begin definition of ELENCO_REVISIONI grid model.
        */
        {
            com.codecharge.components.Grid ELENCO_REVISIONI = new com.codecharge.components.Grid("ELENCO_REVISIONI");
            ELENCO_REVISIONI.setPageModel( this );
            ELENCO_REVISIONI.setFetchSize(20);
            ELENCO_REVISIONI.setVisible( true );

            com.codecharge.components.Link REVISIONE__4 = new com.codecharge.components.Link("REVISIONE", "REVISIONE", this );
            REVISIONE__4.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE__4.setHtmlEncode( true );
            REVISIONE__4.setHrefSource( "HREF_SRC" );
            REVISIONE__4.setHrefType( "Database" );
            REVISIONE__4.setConvertRule("Relative");
            REVISIONE__4.setPreserveType(PreserveParameterType.GET);
            REVISIONE__4.addParameter( new LinkParameter( "ID", "ID_DOCUMENTO", ParameterSource.DATAFIELD) );
            REVISIONE__4.addParameter( new LinkParameter( "REV", "REVISIONE", ParameterSource.DATAFIELD) );
            ELENCO_REVISIONI.add( REVISIONE__4 );

            com.codecharge.components.Label STATO_DOCUMENTO__5 = new com.codecharge.components.Label("STATO_DOCUMENTO", "STATO_DOCUMENTO", this );
            STATO_DOCUMENTO__5.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(STATO_DOCUMENTO__5);

            com.codecharge.components.Label TITOLO_DOC__3 = new com.codecharge.components.Label("TITOLO_DOC", "TITOLO", this );
            TITOLO_DOC__3.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO_DOC__3.setHtmlEncode( true );
            ELENCO_REVISIONI.add(TITOLO_DOC__3);

            com.codecharge.components.Label MODIFICA__17 = new com.codecharge.components.Label("MODIFICA", "MOD_SRC", this );
            MODIFICA__17.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(MODIFICA__17);
            add(ELENCO_REVISIONI);
        } // End definition of ELENCO_REVISIONI grid model
//End ELENCO_REVISIONI grid

//AdmDocumentoRevisioniModel class tail @1-F5FC18C5
    }
}
//End AdmDocumentoRevisioniModel class tail
