//AdmDocumentoModel imports @1-F0A53E4C
package amvadm.AdmDocumento;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmDocumentoModel imports

//AdmDocumentoModel class head @1-38BDAAB5
public class AdmDocumentoModel extends com.codecharge.components.Page {
    public AdmDocumentoModel() {
        this( new CCSLocale(), null );
    }

    public AdmDocumentoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmDocumentoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmDocumentoModel class head

//page settings @1-5E5206EC
        super("AdmDocumento", locale );
        setResponse(response);
        addPageListener(new AdmDocumentoPageHandler());
        {
            com.codecharge.components.IncludePage Header__141 = new com.codecharge.components.IncludePage("Header", this );
            Header__141.setVisible( true );
            add( Header__141 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_DOCUMENTI record @5-9E0F5E09
        
        /*
            Model of AMV_DOCUMENTI record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTI = new com.codecharge.components.Record("AMV_DOCUMENTI");
            AMV_DOCUMENTI.setPageModel( this );
            AMV_DOCUMENTI.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTI.setVisible( true );
            AMV_DOCUMENTI.setPreserveType(PreserveParameterType.GET);
            AMV_DOCUMENTI.setReturnPage("AdmDocumento" + Names.ACTION_SUFFIX);
            AMV_DOCUMENTI.addRecordListener(new AMV_DOCUMENTIRecordHandler());

            com.codecharge.components.Label RECORD_TITLE__142 = new com.codecharge.components.Label("RECORD_TITLE", "", this );
            RECORD_TITLE__142.setType( com.codecharge.components.ControlType.TEXT );
            RECORD_TITLE__142.setHtmlEncode( true );
            AMV_DOCUMENTI.add(RECORD_TITLE__142);

            com.codecharge.components.Hidden ID_DOCUMENTO__60 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__60.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__60.setHtmlEncode( true );
            AMV_DOCUMENTI.add( ID_DOCUMENTO__60 );

            com.codecharge.components.Hidden REVISIONE__131 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__131.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__131.setHtmlEncode( true );
            AMV_DOCUMENTI.add( REVISIONE__131 );

            com.codecharge.components.Hidden STATO__157 = new com.codecharge.components.Hidden("STATO", "STATO", this );
            STATO__157.setType( com.codecharge.components.ControlType.TEXT );
            STATO__157.setHtmlEncode( true );
            AMV_DOCUMENTI.add( STATO__157 );

            com.codecharge.components.TextBox TITOLO__17 = new com.codecharge.components.TextBox("TITOLO", "TITOLO", this );
            TITOLO__17.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__17.setHtmlEncode( true );
            TITOLO__17.setCaption( "TITOLO" );
            TITOLO__17.addValidateHandler( new RequiredHandler( "Il valore nel campo TITOLO è richiesto." ) );
            AMV_DOCUMENTI.add( TITOLO__17 );

            com.codecharge.components.Label REVISIONE_LABEL__138 = new com.codecharge.components.Label("REVISIONE_LABEL", "REVISIONE", this );
            REVISIONE_LABEL__138.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE_LABEL__138.setHtmlEncode( true );
            AMV_DOCUMENTI.add(REVISIONE_LABEL__138);

            com.codecharge.components.Label STATO_DOCUMENTO__130 = new com.codecharge.components.Label("STATO_DOCUMENTO", "STATO_DOCUMENTO", this );
            STATO_DOCUMENTO__130.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTI.add(STATO_DOCUMENTO__130);

            com.codecharge.components.Label FLUSSO__155 = new com.codecharge.components.Label("FLUSSO", "FLUSSO", this );
            FLUSSO__155.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTI.add(FLUSSO__155);

            com.codecharge.components.TextBox DATA_INSERIMENTO__88 = new com.codecharge.components.TextBox("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__88.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__88.setHtmlEncode( true );
            DATA_INSERIMENTO__88.setFormatPattern( "dd/MM/yyyy" );
            DATA_INSERIMENTO__88.setCaption( "DATA INSERIMENTO" );
            AMV_DOCUMENTI.add( DATA_INSERIMENTO__88 );

            com.codecharge.components.TextBox AUTORE__92 = new com.codecharge.components.TextBox("AUTORE", "NOME_AUTORE", this );
            AUTORE__92.setType( com.codecharge.components.ControlType.TEXT );
            AUTORE__92.setHtmlEncode( true );
            AUTORE__92.setCaption( "AUTORE" );
            AMV_DOCUMENTI.add( AUTORE__92 );

            com.codecharge.components.TextBox DATA_AGGIORNAMENTO__27 = new com.codecharge.components.TextBox("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__27.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__27.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__27.setFormatPattern( "dd/MM/yyyy" );
            DATA_AGGIORNAMENTO__27.setCaption( "DATA AGGIORNAMENTO" );
            AMV_DOCUMENTI.add( DATA_AGGIORNAMENTO__27 );

            com.codecharge.components.TextBox UTENTE_AGGIORNAMENTO__87 = new com.codecharge.components.TextBox("UTENTE_AGGIORNAMENTO", "NOME_UTENTE", this );
            UTENTE_AGGIORNAMENTO__87.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE_AGGIORNAMENTO__87.setHtmlEncode( true );
            UTENTE_AGGIORNAMENTO__87.setCaption( "UTENTE AGGIORNAMENTO" );
            AMV_DOCUMENTI.add( UTENTE_AGGIORNAMENTO__87 );

            com.codecharge.components.Label CRONOLOGIA__139 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__139.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__139.setHtmlEncode( true );
            AMV_DOCUMENTI.add(CRONOLOGIA__139);

            com.codecharge.components.Label NOTE__140 = new com.codecharge.components.Label("NOTE", "NOTE", this );
            NOTE__140.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__140.setHtmlEncode( true );
            AMV_DOCUMENTI.add(NOTE__140);

            com.codecharge.components.ListBox ID_AREA__105 = new com.codecharge.components.ListBox("ID_AREA", "ID_AREA", this );
            ID_AREA__105.setType( com.codecharge.components.ControlType.INTEGER );
            ID_AREA__105.setHtmlEncode( true );
            ID_AREA__105.setCaption( "AREA DI ACCESSO" );
            ID_AREA__105.setBoundColumn( "ID_AREA" );
            ID_AREA__105.setTextColumn( "NOME" );
            ID_AREA__105.addValidateHandler( new RequiredHandler( "Il valore nel campo AREA DI ACCESSO è richiesto." ) );
            AMV_DOCUMENTI.add( ID_AREA__105 );

            com.codecharge.components.Hidden ID_AREA_SEL__166 = new com.codecharge.components.Hidden("ID_AREA_SEL", "ID_AREA_SEL", this );
            ID_AREA_SEL__166.setType( com.codecharge.components.ControlType.TEXT );
            ID_AREA_SEL__166.setHtmlEncode( true );
            AMV_DOCUMENTI.add( ID_AREA_SEL__166 );

            com.codecharge.components.ListBox ID_TIPOLOGIA__103 = new com.codecharge.components.ListBox("ID_TIPOLOGIA", "ID_TIPOLOGIA", this );
            ID_TIPOLOGIA__103.setType( com.codecharge.components.ControlType.INTEGER );
            ID_TIPOLOGIA__103.setHtmlEncode( true );
            ID_TIPOLOGIA__103.setCaption( "TIPOLOGIA" );
            ID_TIPOLOGIA__103.setBoundColumn( "ID_TIPOLOGIA" );
            ID_TIPOLOGIA__103.setTextColumn( "NOME" );
            ID_TIPOLOGIA__103.addValidateHandler( new RequiredHandler( "Il valore nel campo TIPOLOGIA è richiesto." ) );
            AMV_DOCUMENTI.add( ID_TIPOLOGIA__103 );

            com.codecharge.components.ListBox ID_CATEGORIA__102 = new com.codecharge.components.ListBox("ID_CATEGORIA", "ID_CATEGORIA", this );
            ID_CATEGORIA__102.setType( com.codecharge.components.ControlType.INTEGER );
            ID_CATEGORIA__102.setHtmlEncode( true );
            ID_CATEGORIA__102.setCaption( "CATEGORIA" );
            ID_CATEGORIA__102.setBoundColumn( "ID_CATEGORIA" );
            ID_CATEGORIA__102.setTextColumn( "NOME" );
            ID_CATEGORIA__102.addValidateHandler( new RequiredHandler( "Il valore nel campo CATEGORIA è richiesto." ) );
            AMV_DOCUMENTI.add( ID_CATEGORIA__102 );

            com.codecharge.components.ListBox ID_ARGOMENTO__101 = new com.codecharge.components.ListBox("ID_ARGOMENTO", "ID_ARGOMENTO", this );
            ID_ARGOMENTO__101.setType( com.codecharge.components.ControlType.INTEGER );
            ID_ARGOMENTO__101.setHtmlEncode( true );
            ID_ARGOMENTO__101.setCaption( "ARGOMENTO" );
            ID_ARGOMENTO__101.setBoundColumn( "ID_ARGOMENTO" );
            ID_ARGOMENTO__101.setTextColumn( "NOME" );
            ID_ARGOMENTO__101.addValidateHandler( new RequiredHandler( "Il valore nel campo ARGOMENTO è richiesto." ) );
            AMV_DOCUMENTI.add( ID_ARGOMENTO__101 );

            com.codecharge.components.ListBox ID_SEZIONE__134 = new com.codecharge.components.ListBox("ID_SEZIONE", "ID_SEZIONE", this );
            ID_SEZIONE__134.setType( com.codecharge.components.ControlType.INTEGER );
            ID_SEZIONE__134.setHtmlEncode( true );
            ID_SEZIONE__134.addControlListener( new AMV_DOCUMENTIID_SEZIONEHandler());
            ID_SEZIONE__134.setCaption( "SEZIONE" );
            ID_SEZIONE__134.setBoundColumn( "ID_SEZIONE" );
            ID_SEZIONE__134.setTextColumn( "NOME" );
            AMV_DOCUMENTI.add( ID_SEZIONE__134 );

            com.codecharge.components.ListBox ID_RILEVANZA__100 = new com.codecharge.components.ListBox("ID_RILEVANZA", "ID_RILEVANZA", this );
            ID_RILEVANZA__100.setType( com.codecharge.components.ControlType.INTEGER );
            ID_RILEVANZA__100.setHtmlEncode( true );
            ID_RILEVANZA__100.setCaption( "RILEVANZA" );
            ID_RILEVANZA__100.setBoundColumn( "ID_RILEVANZA" );
            ID_RILEVANZA__100.setTextColumn( "NOME" );
            ID_RILEVANZA__100.addValidateHandler( new RequiredHandler( "Il valore nel campo RILEVANZA è richiesto." ) );
            AMV_DOCUMENTI.add( ID_RILEVANZA__100 );

            com.codecharge.components.TextBox SEQUENZA__173 = new com.codecharge.components.TextBox("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__173.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__173.setHtmlEncode( true );
            AMV_DOCUMENTI.add( SEQUENZA__173 );

            com.codecharge.components.TextBox DATA_RIFERIMENTO__21 = new com.codecharge.components.TextBox("DATA_RIFERIMENTO", "DATA_RIFERIMENTO", this );
            DATA_RIFERIMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_RIFERIMENTO__21.setHtmlEncode( true );
            DATA_RIFERIMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            DATA_RIFERIMENTO__21.setCaption( "DATA RIFERIMENTO" );
            DATA_RIFERIMENTO__21.addValidateHandler( new RequiredHandler( "Il valore nel campo DATA RIFERIMENTO è richiesto." ) );
            AMV_DOCUMENTI.add( DATA_RIFERIMENTO__21 );
            com.codecharge.components.DatePicker DatePicker3__115 = new com.codecharge.components.DatePicker("DatePicker3", this);
            DatePicker3__115.setControlName("DATA_RIFERIMENTO");
            DatePicker3__115.setStyleName("../Themes/AFC/Style.css");
            AMV_DOCUMENTI.add(DatePicker3__115);

            com.codecharge.components.TextBox INIZIO_PUBBLICAZIONE__22 = new com.codecharge.components.TextBox("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE", this );
            INIZIO_PUBBLICAZIONE__22.setType( com.codecharge.components.ControlType.DATE );
            INIZIO_PUBBLICAZIONE__22.setHtmlEncode( true );
            INIZIO_PUBBLICAZIONE__22.setFormatPattern( "dd/MM/yyyy" );
            INIZIO_PUBBLICAZIONE__22.setCaption( "INIZIO PUBBLICAZIONE" );
            AMV_DOCUMENTI.add( INIZIO_PUBBLICAZIONE__22 );
            com.codecharge.components.DatePicker DatePicker1__135 = new com.codecharge.components.DatePicker("DatePicker1", this);
            DatePicker1__135.setControlName("INIZIO_PUBBLICAZIONE");
            DatePicker1__135.setStyleName("../Themes/AFC/Style.css");
            AMV_DOCUMENTI.add(DatePicker1__135);

            com.codecharge.components.TextBox FINE_PUBBLICAZIONE__23 = new com.codecharge.components.TextBox("FINE_PUBBLICAZIONE", "FINE_PUBBLICAZIONE", this );
            FINE_PUBBLICAZIONE__23.setType( com.codecharge.components.ControlType.DATE );
            FINE_PUBBLICAZIONE__23.setHtmlEncode( true );
            FINE_PUBBLICAZIONE__23.setFormatPattern( "dd/MM/yyyy" );
            FINE_PUBBLICAZIONE__23.setCaption( "FINE PUBBLICAZIONE" );
            AMV_DOCUMENTI.add( FINE_PUBBLICAZIONE__23 );
            com.codecharge.components.DatePicker DatePicker2__136 = new com.codecharge.components.DatePicker("DatePicker2", this);
            DatePicker2__136.setControlName("FINE_PUBBLICAZIONE");
            DatePicker2__136.setStyleName("../Themes/AFC/Style.css");
            AMV_DOCUMENTI.add(DatePicker2__136);

            com.codecharge.components.RadioButton TIPO_TESTO__118 = new com.codecharge.components.RadioButton("TIPO_TESTO", "TIPO_TESTO", this );
            TIPO_TESTO__118.setType( com.codecharge.components.ControlType.TEXT );
            TIPO_TESTO__118.setCaption( "Testo/HTML" );
            TIPO_TESTO__118.addValidateHandler( new RequiredHandler( "Il valore nel campo Testo/HTML è richiesto." ) );
            AMV_DOCUMENTI.add( TIPO_TESTO__118 );

            com.codecharge.components.TextArea TESTO__170 = new com.codecharge.components.TextArea("TESTO", "TESTO", this );
            TESTO__170.setType( com.codecharge.components.ControlType.MEMO );
            TESTO__170.setHtmlEncode( true );
            AMV_DOCUMENTI.add( TESTO__170 );

            com.codecharge.components.TextArea TESTOXQUERY__167 = new com.codecharge.components.TextArea("TESTOXQUERY", "TESTO", this );
            TESTOXQUERY__167.setType( com.codecharge.components.ControlType.MEMO );
            TESTOXQUERY__167.setHtmlEncode( true );
            TESTOXQUERY__167.setCaption( "TESTO" );
            AMV_DOCUMENTI.add( TESTOXQUERY__167 );

            com.codecharge.components.TextBox LINKURL__20 = new com.codecharge.components.TextBox("LINKURL", "LINKURL", this );
            LINKURL__20.setType( com.codecharge.components.ControlType.TEXT );
            LINKURL__20.setHtmlEncode( true );
            LINKURL__20.setCaption( "URL" );
            AMV_DOCUMENTI.add( LINKURL__20 );

            com.codecharge.components.Hidden CR__137 = new com.codecharge.components.Hidden("CR", "CR", this );
            CR__137.setType( com.codecharge.components.ControlType.TEXT );
            CR__137.setHtmlEncode( true );
            AMV_DOCUMENTI.add( CR__137 );

            com.codecharge.components.Hidden LINK__159 = new com.codecharge.components.Hidden("LINK", "", this );
            LINK__159.setType( com.codecharge.components.ControlType.TEXT );
            LINK__159.setHtmlEncode( true );
            AMV_DOCUMENTI.add( LINK__159 );

            com.codecharge.components.TextArea XML__169 = new com.codecharge.components.TextArea("XML", "XML", this );
            XML__169.setType( com.codecharge.components.ControlType.MEMO );
            XML__169.setHtmlEncode( true );
            XML__169.setCaption( "XSL" );
            AMV_DOCUMENTI.add( XML__169 );

            com.codecharge.components.TextArea ABSTRACT__145 = new com.codecharge.components.TextArea("ABSTRACT", "ABSTRACT", this );
            ABSTRACT__145.setType( com.codecharge.components.ControlType.MEMO );
            ABSTRACT__145.setHtmlEncode( true );
            ABSTRACT__145.setCaption( "Testo breve" );
            AMV_DOCUMENTI.add( ABSTRACT__145 );

            com.codecharge.components.TextBox LINKMR__153 = new com.codecharge.components.TextBox("LINKMR", "LINKMR", this );
            LINKMR__153.setType( com.codecharge.components.ControlType.TEXT );
            LINKMR__153.setHtmlEncode( true );
            LINKMR__153.setCaption( "Modello Richiesta" );
            AMV_DOCUMENTI.add( LINKMR__153 );

            com.codecharge.components.TextBox LINKMA__158 = new com.codecharge.components.TextBox("LINKMA", "LINKMA", this );
            LINKMA__158.setType( com.codecharge.components.ControlType.TEXT );
            LINKMA__158.setHtmlEncode( true );
            LINKMA__158.setCaption( "Modello Approvazione" );
            AMV_DOCUMENTI.add( LINKMA__158 );

            com.codecharge.components.RadioButton LINK_ITER__161 = new com.codecharge.components.RadioButton("LINK_ITER", "LINK_ITER", this );
            LINK_ITER__161.setType( com.codecharge.components.ControlType.TEXT );
            LINK_ITER__161.setCaption( "Iter Approvazione" );
            AMV_DOCUMENTI.add( LINK_ITER__161 );

            com.codecharge.components.RadioButton LINK_INOLTRO__164 = new com.codecharge.components.RadioButton("LINK_INOLTRO", "LINK_INOLTRO", this );
            LINK_INOLTRO__164.setType( com.codecharge.components.ControlType.TEXT );
            LINK_INOLTRO__164.setHtmlEncode( true );
            AMV_DOCUMENTI.add( LINK_INOLTRO__164 );

            com.codecharge.components.TextBox LINKDATASOURCE__168 = new com.codecharge.components.TextBox("LINKDATASOURCE", "LINKDATASOURCE", this );
            LINKDATASOURCE__168.setType( com.codecharge.components.ControlType.TEXT );
            LINKDATASOURCE__168.setHtmlEncode( true );
            LINKDATASOURCE__168.setCaption( "Modello Approvazione" );
            AMV_DOCUMENTI.add( LINKDATASOURCE__168 );

            com.codecharge.components.TextBox IMMAGINE__147 = new com.codecharge.components.TextBox("IMMAGINE", "IMMAGINE", this );
            IMMAGINE__147.setType( com.codecharge.components.ControlType.TEXT );
            IMMAGINE__147.setHtmlEncode( true );
            AMV_DOCUMENTI.add( IMMAGINE__147 );

            com.codecharge.components.TextBox ICONA__171 = new com.codecharge.components.TextBox("ICONA", "ICONA", this );
            ICONA__171.setType( com.codecharge.components.ControlType.TEXT );
            ICONA__171.setHtmlEncode( true );
            ICONA__171.setCaption( "ICONA" );
            AMV_DOCUMENTI.add( ICONA__171 );

            com.codecharge.components.Label ALLEGATI__148 = new com.codecharge.components.Label("ALLEGATI", "ALLEGATI", this );
            ALLEGATI__148.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTI.add(ALLEGATI__148);

            com.codecharge.components.Label FILE_UPLOAD__149 = new com.codecharge.components.Label("FILE_UPLOAD", "", this );
            FILE_UPLOAD__149.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTI.add(FILE_UPLOAD__149);

            com.codecharge.components.ListBox ALLEGATO__150 = new com.codecharge.components.ListBox("ALLEGATO", "", this );
            ALLEGATO__150.setType( com.codecharge.components.ControlType.TEXT );
            ALLEGATO__150.setHtmlEncode( true );
            ALLEGATO__150.setBoundColumn( "ID_BLOB" );
            ALLEGATO__150.setTextColumn( "NOME" );
            AMV_DOCUMENTI.add( ALLEGATO__150 );

            com.codecharge.components.Button Insert__6 = new com.codecharge.components.Button("Insert", this);
            Insert__6.addExcludeParam( "ccsForm" );
            Insert__6.addExcludeParam( "Insert" );
            Insert__6.setOperation( "Insert" );
            AMV_DOCUMENTI.add( Insert__6 );

            com.codecharge.components.Button Update__7 = new com.codecharge.components.Button("Update", this);
            Update__7.addExcludeParam( "ccsForm" );
            Update__7.addExcludeParam( "Update" );
            Update__7.setOperation( "Update" );
            AMV_DOCUMENTI.add( Update__7 );

            com.codecharge.components.Button Delete__8 = new com.codecharge.components.Button("Delete", this);
            Delete__8.addExcludeParam( "ccsForm" );
            Delete__8.addExcludeParam( "Delete" );
            Delete__8.setOperation( "Delete" );
            AMV_DOCUMENTI.add( Delete__8 );

            com.codecharge.components.Button Cancel__9 = new com.codecharge.components.Button("Cancel", this);
            Cancel__9.addExcludeParam( "ccsForm" );
            Cancel__9.addExcludeParam( "Cancel" );
            Cancel__9.setOperation( "Cancel" );
            AMV_DOCUMENTI.add( Cancel__9 );
            add(AMV_DOCUMENTI);
        } // End definition of AMV_DOCUMENTI record model.
//End AMV_DOCUMENTI record

//AdmDocumentoModel class tail @1-F5FC18C5
    }
}
//End AdmDocumentoModel class tail
