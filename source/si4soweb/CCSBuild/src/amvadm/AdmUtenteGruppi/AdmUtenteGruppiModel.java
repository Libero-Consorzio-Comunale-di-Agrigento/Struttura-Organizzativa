//AdmUtenteGruppiModel imports @1-FDC316EA
package amvadm.AdmUtenteGruppi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtenteGruppiModel imports

//AdmUtenteGruppiModel class head @1-48056672
public class AdmUtenteGruppiModel extends com.codecharge.components.Page {
    public AdmUtenteGruppiModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtenteGruppiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtenteGruppiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtenteGruppiModel class head

//page settings @1-C82C9F0E
        super("AdmUtenteGruppi", locale );
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
            com.codecharge.components.IncludePage AmvUtenteNominativo_i__67 = new com.codecharge.components.IncludePage("AmvUtenteNominativo_i", this );
            AmvUtenteNominativo_i__67.setVisible( true );
            add( AmvUtenteNominativo_i__67 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//DISPONIBILI record @70-8A5E5969
        
        /*
            Model of DISPONIBILI record defining.
        */
        {
            com.codecharge.components.Record DISPONIBILI = new com.codecharge.components.Record("DISPONIBILI");
            DISPONIBILI.setPageModel( this );
            DISPONIBILI.addExcludeParam( "ccsForm" );
            DISPONIBILI.setVisible( true );
            DISPONIBILI.setAllowInsert(false);
            DISPONIBILI.setPreserveType(PreserveParameterType.GET);
            DISPONIBILI.setReturnPage("AdmUtenteGruppi" + Names.ACTION_SUFFIX);

            com.codecharge.components.ListBox GRUPPO_D__71 = new com.codecharge.components.ListBox("GRUPPO_D", "", this );
            GRUPPO_D__71.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPO_D__71.setHtmlEncode( true );
            GRUPPO_D__71.setBoundColumn( "GRUPPO" );
            GRUPPO_D__71.setTextColumn( "NOME_GRUPPO" );
            DISPONIBILI.add( GRUPPO_D__71 );

            com.codecharge.components.Button Tutti__93 = new com.codecharge.components.Button("Tutti", this);
            Tutti__93.addExcludeParam( "ccsForm" );
            Tutti__93.addExcludeParam( "Tutti" );
            Tutti__93.setOperation( "Delete" );
            DISPONIBILI.add( Tutti__93 );

            com.codecharge.components.Button Uno__73 = new com.codecharge.components.Button("Uno", this);
            Uno__73.addExcludeParam( "ccsForm" );
            Uno__73.addExcludeParam( "Uno" );
            Uno__73.setOperation( "Update" );
            DISPONIBILI.add( Uno__73 );
            add(DISPONIBILI);
        } // End definition of DISPONIBILI record model.
//End DISPONIBILI record

//ASSEGNATI record @76-36A87833
        
        /*
            Model of ASSEGNATI record defining.
        */
        {
            com.codecharge.components.Record ASSEGNATI = new com.codecharge.components.Record("ASSEGNATI");
            ASSEGNATI.setPageModel( this );
            ASSEGNATI.addExcludeParam( "ccsForm" );
            ASSEGNATI.setVisible( true );
            ASSEGNATI.setAllowInsert(false);
            ASSEGNATI.setPreserveType(PreserveParameterType.GET);
            ASSEGNATI.setReturnPage("AdmUtenteGruppi" + Names.ACTION_SUFFIX);

            com.codecharge.components.ListBox GRUPPO_A__77 = new com.codecharge.components.ListBox("GRUPPO_A", "", this );
            GRUPPO_A__77.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPO_A__77.setHtmlEncode( true );
            GRUPPO_A__77.setBoundColumn( "GRUPPO" );
            GRUPPO_A__77.setTextColumn( "NOME_GRUPPO" );
            ASSEGNATI.add( GRUPPO_A__77 );

            com.codecharge.components.Button Uno__81 = new com.codecharge.components.Button("Uno", this);
            Uno__81.addExcludeParam( "ccsForm" );
            Uno__81.addExcludeParam( "Uno" );
            Uno__81.setOperation( "Update" );
            ASSEGNATI.add( Uno__81 );

            com.codecharge.components.Button Tutti__94 = new com.codecharge.components.Button("Tutti", this);
            Tutti__94.addExcludeParam( "ccsForm" );
            Tutti__94.addExcludeParam( "Tutti" );
            Tutti__94.setOperation( "Delete" );
            ASSEGNATI.add( Tutti__94 );
            add(ASSEGNATI);
        } // End definition of ASSEGNATI record model.
//End ASSEGNATI record

//AdmUtenteGruppiModel class tail @1-F5FC18C5
    }
}
//End AdmUtenteGruppiModel class tail

