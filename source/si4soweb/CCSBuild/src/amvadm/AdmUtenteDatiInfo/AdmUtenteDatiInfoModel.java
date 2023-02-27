//AdmUtenteDatiInfoModel imports @1-DA1FBDE1
package amvadm.AdmUtenteDatiInfo;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtenteDatiInfoModel imports

//AdmUtenteDatiInfoModel class head @1-9AED022A
public class AdmUtenteDatiInfoModel extends com.codecharge.components.Page {
    public AdmUtenteDatiInfoModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtenteDatiInfoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtenteDatiInfoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtenteDatiInfoModel class head

//page settings @1-6B2E5729
        super("AdmUtenteDatiInfo", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__58 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__58.setVisible( true );
            add( Guida__58 );
            com.codecharge.components.IncludePage AmvUtenteNominativo_i__85 = new com.codecharge.components.IncludePage("AmvUtenteNominativo_i", this );
            AmvUtenteNominativo_i__85.setVisible( true );
            add( AmvUtenteNominativo_i__85 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTI record @59-6E0C232B
        
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
            AD4_UTENTI.setReturnPage("AdmUtenteDatiInfo" + Names.ACTION_SUFFIX);
            AD4_UTENTI.addRecordListener(new AD4_UTENTIRecordHandler());

            com.codecharge.components.Label NOME__76 = new com.codecharge.components.Label("NOME", "NOME", this );
            NOME__76.setType( com.codecharge.components.ControlType.TEXT );
            NOME__76.setHtmlEncode( true );
            AD4_UTENTI.add(NOME__76);

            com.codecharge.components.Label SESSO__87 = new com.codecharge.components.Label("SESSO", "SESSO", this );
            SESSO__87.setType( com.codecharge.components.ControlType.TEXT );
            SESSO__87.setHtmlEncode( true );
            AD4_UTENTI.add(SESSO__87);

            com.codecharge.components.Label CODICE_FISCALE__88 = new com.codecharge.components.Label("CODICE_FISCALE", "CODICE_FISCALE", this );
            CODICE_FISCALE__88.setType( com.codecharge.components.ControlType.TEXT );
            CODICE_FISCALE__88.setHtmlEncode( true );
            AD4_UTENTI.add(CODICE_FISCALE__88);

            com.codecharge.components.Label DATA_NASCITA__89 = new com.codecharge.components.Label("DATA_NASCITA", "DATA_NASCITA", this );
            DATA_NASCITA__89.setType( com.codecharge.components.ControlType.TEXT );
            DATA_NASCITA__89.setHtmlEncode( true );
            AD4_UTENTI.add(DATA_NASCITA__89);

            com.codecharge.components.Label DES_COMUNE_NAS__90 = new com.codecharge.components.Label("DES_COMUNE_NAS", "DES_COMUNE_NAS", this );
            DES_COMUNE_NAS__90.setType( com.codecharge.components.ControlType.TEXT );
            DES_COMUNE_NAS__90.setHtmlEncode( true );
            AD4_UTENTI.add(DES_COMUNE_NAS__90);

            com.codecharge.components.Label DES_PROVINCIA_NAS__91 = new com.codecharge.components.Label("DES_PROVINCIA_NAS", "DES_PROVINCIA_NAS", this );
            DES_PROVINCIA_NAS__91.setType( com.codecharge.components.ControlType.TEXT );
            DES_PROVINCIA_NAS__91.setHtmlEncode( true );
            AD4_UTENTI.add(DES_PROVINCIA_NAS__91);

            com.codecharge.components.Label INDIRIZZO_COMPLETO__92 = new com.codecharge.components.Label("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO", this );
            INDIRIZZO_COMPLETO__92.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_COMPLETO__92.setHtmlEncode( true );
            AD4_UTENTI.add(INDIRIZZO_COMPLETO__92);

            com.codecharge.components.Label INDIRIZZO_WEB__77 = new com.codecharge.components.Label("INDIRIZZO_WEB", "INDIRIZZO_WEB", this );
            INDIRIZZO_WEB__77.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_WEB__77.setHtmlEncode( true );
            AD4_UTENTI.add(INDIRIZZO_WEB__77);

            com.codecharge.components.Label TELEFONO__78 = new com.codecharge.components.Label("TELEFONO", "TELEFONO", this );
            TELEFONO__78.setType( com.codecharge.components.ControlType.TEXT );
            TELEFONO__78.setHtmlEncode( true );
            AD4_UTENTI.add(TELEFONO__78);

            com.codecharge.components.Label FAX__79 = new com.codecharge.components.Label("FAX", "FAX", this );
            FAX__79.setType( com.codecharge.components.ControlType.TEXT );
            FAX__79.setHtmlEncode( true );
            AD4_UTENTI.add(FAX__79);

            com.codecharge.components.Label DATA_PASSWORD__62 = new com.codecharge.components.Label("DATA_PASSWORD", "DATA_PASSWORD", this );
            DATA_PASSWORD__62.setType( com.codecharge.components.ControlType.DATE );
            DATA_PASSWORD__62.setHtmlEncode( true );
            DATA_PASSWORD__62.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(DATA_PASSWORD__62);

            com.codecharge.components.Label RINNOVO_PASSWORD__84 = new com.codecharge.components.Label("RINNOVO_PASSWORD", "RINNOVO_PASSWORD", this );
            RINNOVO_PASSWORD__84.setType( com.codecharge.components.ControlType.TEXT );
            RINNOVO_PASSWORD__84.setHtmlEncode( true );
            AD4_UTENTI.add(RINNOVO_PASSWORD__84);

            com.codecharge.components.Label ULTIMO_TENTATIVO__80 = new com.codecharge.components.Label("ULTIMO_TENTATIVO", "ULTIMO_TENTATIVO", this );
            ULTIMO_TENTATIVO__80.setType( com.codecharge.components.ControlType.DATE );
            ULTIMO_TENTATIVO__80.setHtmlEncode( true );
            ULTIMO_TENTATIVO__80.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(ULTIMO_TENTATIVO__80);

            com.codecharge.components.Label STATO__81 = new com.codecharge.components.Label("STATO", "STATO", this );
            STATO__81.setType( com.codecharge.components.ControlType.TEXT );
            STATO__81.setHtmlEncode( true );
            AD4_UTENTI.add(STATO__81);

            com.codecharge.components.Label DATA_INSERIMENTO__82 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__82.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__82.setHtmlEncode( true );
            DATA_INSERIMENTO__82.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(DATA_INSERIMENTO__82);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__83 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__83.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__83.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__83.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(DATA_AGGIORNAMENTO__83);
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI record model.
//End AD4_UTENTI record

//AdmUtenteDatiInfoModel class tail @1-F5FC18C5
    }
}
//End AdmUtenteDatiInfoModel class tail




