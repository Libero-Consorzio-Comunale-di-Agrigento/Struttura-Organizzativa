//AdmRevisioneNuovaModel imports @1-B01B6CC9
package amvadm.AdmRevisioneNuova;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioneNuovaModel imports

//AdmRevisioneNuovaModel class head @1-CB6915B0
public class AdmRevisioneNuovaModel extends com.codecharge.components.Page {
    public AdmRevisioneNuovaModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioneNuovaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioneNuovaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioneNuovaModel class head

//page settings @1-F63137C1
        super("AdmRevisioneNuova", locale );
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

//NUOVA_REVISIONE record @6-FFD41BA8
        
        /*
            Model of NUOVA_REVISIONE record defining.
        */
        {
            com.codecharge.components.Record NUOVA_REVISIONE = new com.codecharge.components.Record("NUOVA_REVISIONE");
            NUOVA_REVISIONE.setPageModel( this );
            NUOVA_REVISIONE.addExcludeParam( "ccsForm" );
            NUOVA_REVISIONE.setVisible( true );
            NUOVA_REVISIONE.setAllowInsert(false);
            NUOVA_REVISIONE.setAllowDelete(false);
            NUOVA_REVISIONE.setPreserveType(PreserveParameterType.GET);
            NUOVA_REVISIONE.setReturnPage("AdmRevisioneNuova" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__29 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__29.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__29.setHtmlEncode( true );
            NUOVA_REVISIONE.add(TITOLO__29);

            com.codecharge.components.Label DES_TIPOLOGIA__30 = new com.codecharge.components.Label("DES_TIPOLOGIA", "DES_TIPOLOGIA", this );
            DES_TIPOLOGIA__30.setType( com.codecharge.components.ControlType.TEXT );
            DES_TIPOLOGIA__30.setHtmlEncode( true );
            NUOVA_REVISIONE.add(DES_TIPOLOGIA__30);

            com.codecharge.components.Label DES_CATEGORIA__31 = new com.codecharge.components.Label("DES_CATEGORIA", "DES_CATEGORIA", this );
            DES_CATEGORIA__31.setType( com.codecharge.components.ControlType.TEXT );
            DES_CATEGORIA__31.setHtmlEncode( true );
            NUOVA_REVISIONE.add(DES_CATEGORIA__31);

            com.codecharge.components.Label DES_ARGOMENTO__32 = new com.codecharge.components.Label("DES_ARGOMENTO", "DES_ARGOMENTO", this );
            DES_ARGOMENTO__32.setType( com.codecharge.components.ControlType.TEXT );
            DES_ARGOMENTO__32.setHtmlEncode( true );
            NUOVA_REVISIONE.add(DES_ARGOMENTO__32);

            com.codecharge.components.Label NOME_AUTORE__33 = new com.codecharge.components.Label("NOME_AUTORE", "NOME_AUTORE", this );
            NOME_AUTORE__33.setType( com.codecharge.components.ControlType.TEXT );
            NOME_AUTORE__33.setHtmlEncode( true );
            NUOVA_REVISIONE.add(NOME_AUTORE__33);

            com.codecharge.components.Label DATA_INSERIMENTO__34 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__34.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__34.setHtmlEncode( true );
            DATA_INSERIMENTO__34.setFormatPattern( "dd/MM/yyyy" );
            NUOVA_REVISIONE.add(DATA_INSERIMENTO__34);

            com.codecharge.components.Label INIZIO_PUBBLICAZIONE_LABEL__35 = new com.codecharge.components.Label("INIZIO_PUBBLICAZIONE_LABEL", "INIZIO_PUBBLICAZIONE", this );
            INIZIO_PUBBLICAZIONE_LABEL__35.setType( com.codecharge.components.ControlType.DATE );
            INIZIO_PUBBLICAZIONE_LABEL__35.setHtmlEncode( true );
            INIZIO_PUBBLICAZIONE_LABEL__35.setFormatPattern( "dd/MM/yyyy" );
            NUOVA_REVISIONE.add(INIZIO_PUBBLICAZIONE_LABEL__35);

            com.codecharge.components.Label FINE_PUBBLICAZIONE_LABEL__36 = new com.codecharge.components.Label("FINE_PUBBLICAZIONE_LABEL", "FINE_PUBBLICAZIONE", this );
            FINE_PUBBLICAZIONE_LABEL__36.setType( com.codecharge.components.ControlType.DATE );
            FINE_PUBBLICAZIONE_LABEL__36.setHtmlEncode( true );
            FINE_PUBBLICAZIONE_LABEL__36.setFormatPattern( "dd/MM/yyyy" );
            NUOVA_REVISIONE.add(FINE_PUBBLICAZIONE_LABEL__36);

            com.codecharge.components.ListBox REDAZIONE__12 = new com.codecharge.components.ListBox("REDAZIONE", "", this );
            REDAZIONE__12.setType( com.codecharge.components.ControlType.TEXT );
            REDAZIONE__12.setHtmlEncode( true );
            REDAZIONE__12.setCaption( "REDAZIONE" );
            REDAZIONE__12.setBoundColumn( "UTENTE" );
            REDAZIONE__12.setTextColumn( "NOMINATIVO" );
            REDAZIONE__12.addValidateHandler( new RequiredHandler( "Il valore nel campo REDAZIONE è richiesto." ) );
            NUOVA_REVISIONE.add( REDAZIONE__12 );

            com.codecharge.components.ListBox VERIFICA__17 = new com.codecharge.components.ListBox("VERIFICA", "", this );
            VERIFICA__17.setType( com.codecharge.components.ControlType.TEXT );
            VERIFICA__17.setHtmlEncode( true );
            VERIFICA__17.setCaption( "VERIFICA" );
            VERIFICA__17.setBoundColumn( "UTENTE" );
            VERIFICA__17.setTextColumn( "NOMINATIVO" );
            VERIFICA__17.addValidateHandler( new RequiredHandler( "Il valore nel campo VERIFICA è richiesto." ) );
            NUOVA_REVISIONE.add( VERIFICA__17 );

            com.codecharge.components.ListBox APPROVAZIONE__22 = new com.codecharge.components.ListBox("APPROVAZIONE", "", this );
            APPROVAZIONE__22.setType( com.codecharge.components.ControlType.TEXT );
            APPROVAZIONE__22.setHtmlEncode( true );
            APPROVAZIONE__22.setCaption( "APPROVAZIONE" );
            APPROVAZIONE__22.setBoundColumn( "UTENTE" );
            APPROVAZIONE__22.setTextColumn( "NOMINATIVO" );
            APPROVAZIONE__22.addValidateHandler( new RequiredHandler( "Il valore nel campo APPROVAZIONE è richiesto." ) );
            NUOVA_REVISIONE.add( APPROVAZIONE__22 );

            com.codecharge.components.TextBox INIZIO_PUBBLICAZIONE__42 = new com.codecharge.components.TextBox("INIZIO_PUBBLICAZIONE", "", this );
            INIZIO_PUBBLICAZIONE__42.setType( com.codecharge.components.ControlType.DATE );
            INIZIO_PUBBLICAZIONE__42.setHtmlEncode( true );
            INIZIO_PUBBLICAZIONE__42.setFormatPattern( "dd/MM/yyyy" );
            INIZIO_PUBBLICAZIONE__42.setCaption( "INIZIO PUBBLICAZIONE" );
            NUOVA_REVISIONE.add( INIZIO_PUBBLICAZIONE__42 );
            com.codecharge.components.DatePicker DatePicker1__44 = new com.codecharge.components.DatePicker("DatePicker1", this);
            DatePicker1__44.setControlName("INIZIO_PUBBLICAZIONE");
            DatePicker1__44.setStyleName("../Themes/AFC/Style.css");
            NUOVA_REVISIONE.add(DatePicker1__44);

            com.codecharge.components.TextBox FINE_PUBBLICAZIONE__43 = new com.codecharge.components.TextBox("FINE_PUBBLICAZIONE", "", this );
            FINE_PUBBLICAZIONE__43.setType( com.codecharge.components.ControlType.DATE );
            FINE_PUBBLICAZIONE__43.setHtmlEncode( true );
            FINE_PUBBLICAZIONE__43.setFormatPattern( "dd/MM/yyyy" );
            FINE_PUBBLICAZIONE__43.setCaption( "FINE PUBBLICAZIONE" );
            NUOVA_REVISIONE.add( FINE_PUBBLICAZIONE__43 );
            com.codecharge.components.DatePicker DatePicker2__45 = new com.codecharge.components.DatePicker("DatePicker2", this);
            DatePicker2__45.setControlName("FINE_PUBBLICAZIONE");
            DatePicker2__45.setStyleName("../Themes/AFC/Style.css");
            NUOVA_REVISIONE.add(DatePicker2__45);

            com.codecharge.components.Hidden REVISIONE__41 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__41.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__41.setHtmlEncode( true );
            REVISIONE__41.setCaption( "ID_DOCUMENTO" );
            NUOVA_REVISIONE.add( REVISIONE__41 );

            com.codecharge.components.Hidden ID_DOCUMENTO__40 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__40.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__40.setHtmlEncode( true );
            ID_DOCUMENTO__40.setCaption( "ID_DOCUMENTO" );
            NUOVA_REVISIONE.add( ID_DOCUMENTO__40 );

            com.codecharge.components.Button Button_Insert__9 = new com.codecharge.components.Button("Button_Insert", this);
            Button_Insert__9.addExcludeParam( "ccsForm" );
            Button_Insert__9.addExcludeParam( "Button_Insert" );
            Button_Insert__9.setOperation( "Insert" );
            NUOVA_REVISIONE.add( Button_Insert__9 );

            com.codecharge.components.Button Button_Update__10 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__10.addExcludeParam( "ccsForm" );
            Button_Update__10.addExcludeParam( "Button_Update" );
            Button_Update__10.setOperation( "Update" );
            NUOVA_REVISIONE.add( Button_Update__10 );

            com.codecharge.components.Button Button_Delete__11 = new com.codecharge.components.Button("Button_Delete", this);
            Button_Delete__11.addExcludeParam( "ccsForm" );
            Button_Delete__11.addExcludeParam( "Button_Delete" );
            Button_Delete__11.setOperation( "Delete" );
            NUOVA_REVISIONE.add( Button_Delete__11 );
            add(NUOVA_REVISIONE);
        } // End definition of NUOVA_REVISIONE record model.
//End NUOVA_REVISIONE record

//AdmRevisioneNuovaModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioneNuovaModel class tail
