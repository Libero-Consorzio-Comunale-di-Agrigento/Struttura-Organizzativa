//AdmContenutiElencoModel imports @1-00FAF114
package amvadm.AdmContenutiElenco;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmContenutiElencoModel imports

//AdmContenutiElencoModel class head @1-F45B6ABA
public class AdmContenutiElencoModel extends com.codecharge.components.Page {
    public AdmContenutiElencoModel() {
        this( new CCSLocale(), null );
    }

    public AdmContenutiElencoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmContenutiElencoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmContenutiElencoModel class head

//page settings @1-4A9D5506
        super("AdmContenutiElenco", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AD4_SEZIONE_SEL grid @10-C381CBC3
        
        /*
            // Begin definition of AD4_SEZIONE_SEL grid model.
        */
        {
            com.codecharge.components.Grid AD4_SEZIONE_SEL = new com.codecharge.components.Grid("AD4_SEZIONE_SEL");
            AD4_SEZIONE_SEL.setPageModel( this );
            AD4_SEZIONE_SEL.setFetchSize(20);
            AD4_SEZIONE_SEL.setVisible( true );

            com.codecharge.components.Label NOME_SEZIONE__11 = new com.codecharge.components.Label("NOME_SEZIONE", "NOME", this );
            NOME_SEZIONE__11.setType( com.codecharge.components.ControlType.TEXT );
            NOME_SEZIONE__11.setHtmlEncode( true );
            AD4_SEZIONE_SEL.add(NOME_SEZIONE__11);

            com.codecharge.components.Label RICERCA__32 = new com.codecharge.components.Label("RICERCA", "RICERCA", this );
            RICERCA__32.setType( com.codecharge.components.ControlType.TEXT );
            AD4_SEZIONE_SEL.add(RICERCA__32);

            com.codecharge.components.Label NUOVA_PAGINA__26 = new com.codecharge.components.Label("NUOVA_PAGINA", "NUOVA_PAGINA", this );
            NUOVA_PAGINA__26.setType( com.codecharge.components.ControlType.TEXT );
            AD4_SEZIONE_SEL.add(NUOVA_PAGINA__26);
            add(AD4_SEZIONE_SEL);
        } // End definition of AD4_SEZIONE_SEL grid model
//End AD4_SEZIONE_SEL grid

//ELENCO_REVISIONI grid @2-3F238332
        
        /*
            // Begin definition of ELENCO_REVISIONI grid model.
        */
        {
            com.codecharge.components.Grid ELENCO_REVISIONI = new com.codecharge.components.Grid("ELENCO_REVISIONI");
            ELENCO_REVISIONI.setPageModel( this );
            ELENCO_REVISIONI.setFetchSize(20);
            ELENCO_REVISIONI.setVisible( true );
            ELENCO_REVISIONI.addGridListener( new ELENCO_REVISIONIGridHandler() );
            com.codecharge.components.Sorter Titolo = new com.codecharge.components.Sorter("Titolo", ELENCO_REVISIONI, this);
            Titolo.setColumn("TITOLO");
            ELENCO_REVISIONI.add(Titolo);
            com.codecharge.components.Sorter Riferimento = new com.codecharge.components.Sorter("Riferimento", ELENCO_REVISIONI, this);
            Riferimento.setColumn("DATA_RIFERIMENTO");
            ELENCO_REVISIONI.add(Riferimento);

            com.codecharge.components.Link TITOLO_DOC__3 = new com.codecharge.components.Link("TITOLO_DOC", "TITOLO", this );
            TITOLO_DOC__3.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO_DOC__3.setHrefSource( "HREF_SRC" );
            TITOLO_DOC__3.setHrefType( "Database" );
            TITOLO_DOC__3.setConvertRule("Relative");
            TITOLO_DOC__3.setPreserveType(PreserveParameterType.NONE);
            ELENCO_REVISIONI.add( TITOLO_DOC__3 );

            com.codecharge.components.Label DATA_RIFERIMENTO__21 = new com.codecharge.components.Label("DATA_RIFERIMENTO", "DATA_RIFERIMENTO", this );
            DATA_RIFERIMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_RIFERIMENTO__21.setHtmlEncode( true );
            DATA_RIFERIMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            ELENCO_REVISIONI.add(DATA_RIFERIMENTO__21);

            com.codecharge.components.Label ID_DOCUMENTO__30 = new com.codecharge.components.Label("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__30.setType( com.codecharge.components.ControlType.TEXT );
            ID_DOCUMENTO__30.setHtmlEncode( true );
            ELENCO_REVISIONI.add(ID_DOCUMENTO__30);

            com.codecharge.components.Label REVISIONE__4 = new com.codecharge.components.Label("REVISIONE", "REVISIONE", this );
            REVISIONE__4.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE__4.setHtmlEncode( true );
            ELENCO_REVISIONI.add(REVISIONE__4);

            com.codecharge.components.Label STATO_DOCUMENTO__5 = new com.codecharge.components.Label("STATO_DOCUMENTO", "STATO_DOCUMENTO", this );
            STATO_DOCUMENTO__5.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(STATO_DOCUMENTO__5);

            com.codecharge.components.Label STORICO__20 = new com.codecharge.components.Label("STORICO", "STORICO_SRC", this );
            STORICO__20.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(STORICO__20);

            com.codecharge.components.Label REVISIONA__14 = new com.codecharge.components.Label("REVISIONA", "REV_SRC", this );
            REVISIONA__14.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(REVISIONA__14);

            com.codecharge.components.Label MODIFICA__17 = new com.codecharge.components.Label("MODIFICA", "MOD_SRC", this );
            MODIFICA__17.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(MODIFICA__17);

            com.codecharge.components.Label AFCNavigator__31 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__31.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(AFCNavigator__31);
            add(ELENCO_REVISIONI);
        } // End definition of ELENCO_REVISIONI grid model
//End ELENCO_REVISIONI grid

//AdmContenutiElencoModel class tail @1-F5FC18C5
    }
}
//End AdmContenutiElencoModel class tail
