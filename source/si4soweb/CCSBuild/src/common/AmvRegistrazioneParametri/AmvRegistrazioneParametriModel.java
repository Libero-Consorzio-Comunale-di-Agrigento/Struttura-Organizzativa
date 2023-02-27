//AmvRegistrazioneParametriModel imports @1-E9487EB6
package common.AmvRegistrazioneParametri;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRegistrazioneParametriModel imports

//AmvRegistrazioneParametriModel class head @1-11490932
public class AmvRegistrazioneParametriModel extends com.codecharge.components.Page {
    public AmvRegistrazioneParametriModel() {
        this( new CCSLocale(), null );
    }

    public AmvRegistrazioneParametriModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRegistrazioneParametriModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRegistrazioneParametriModel class head

//page settings @1-939A4883
        super("AmvRegistrazioneParametri", locale );
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

//PARAMETRI EditGrid @6-FA6A038B
        
        /*
            // Begin definition of PARAMETRI editable grid model.
        */
        {
            com.codecharge.components.EditableGrid PARAMETRI = new com.codecharge.components.EditableGrid("PARAMETRI");
            PARAMETRI.setPageModel( this );
            PARAMETRI.addExcludeParam( "ccsForm" );
            PARAMETRI.setFetchSize(20);
            PARAMETRI.setAllowInsert(false);
            PARAMETRI.setAllowDelete(false);
            PARAMETRI.setVisible( true );
            PARAMETRI.setPreserveType(PreserveParameterType.GET);
            PARAMETRI.setNumberEmptyRows( 1 );
            PARAMETRI.setDeleteControlName( "CheckBox_Delete" );

            PARAMETRI.addEditableGridListener( new PARAMETRIEditableGridHandler() );

            com.codecharge.components.Label NOME__11 = new com.codecharge.components.Label("NOME", "TITOLO", this );
            NOME__11.setType( com.codecharge.components.ControlType.TEXT );
            NOME__11.setHtmlEncode( true );
            PARAMETRI.addRowControl( "NOME" );
            PARAMETRI.add(NOME__11);

            com.codecharge.components.TextBox VALORE__7 = new com.codecharge.components.TextBox("VALORE", "VALORE", this );
            VALORE__7.setType( com.codecharge.components.ControlType.TEXT );
            VALORE__7.setHtmlEncode( true );
            PARAMETRI.addRowControl( "VALORE" );
            PARAMETRI.add( VALORE__7 );

            com.codecharge.components.Hidden NOME_PAR__8 = new com.codecharge.components.Hidden("NOME_PAR", "NOME_PAR", this );
            NOME_PAR__8.setType( com.codecharge.components.ControlType.TEXT );
            NOME_PAR__8.setHtmlEncode( true );
            PARAMETRI.addRowControl( "NOME_PAR" );
            PARAMETRI.add( NOME_PAR__8 );

            com.codecharge.components.Hidden ID_RIC__12 = new com.codecharge.components.Hidden("ID_RIC", "ID_RIC", this );
            ID_RIC__12.setType( com.codecharge.components.ControlType.TEXT );
            ID_RIC__12.setHtmlEncode( true );
            PARAMETRI.addRowControl( "ID_RIC" );
            PARAMETRI.add( ID_RIC__12 );

            com.codecharge.components.CheckBox CheckBox_Delete__9=  new com.codecharge.components.CheckBox( "CheckBox_Delete", this );
            CheckBox_Delete__9.setType( com.codecharge.components.ControlType.BOOLEAN );
            CheckBox_Delete__9.setCheckedValue( true );
            CheckBox_Delete__9.setUncheckedValue( false );
            PARAMETRI.add(CheckBox_Delete__9);

            com.codecharge.components.Button Button_Submit__10 = new com.codecharge.components.Button("Button_Submit", this);
            Button_Submit__10.addExcludeParam( "ccsForm" );
            Button_Submit__10.addExcludeParam( "Button_Submit" );
            Button_Submit__10.setOperation( "Submit" );
            PARAMETRI.add( Button_Submit__10 );
            add(PARAMETRI);
        } // End definition of PARAMETRI editable grid model
//End PARAMETRI EditGrid

//AmvRegistrazioneParametriModel class tail @1-F5FC18C5
    }
}
//End AmvRegistrazioneParametriModel class tail
