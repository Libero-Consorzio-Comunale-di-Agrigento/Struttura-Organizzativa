//AdmRichiestaParametriModel imports @1-5B49FB04
package amvadm.AdmRichiestaParametri;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRichiestaParametriModel imports

//AdmRichiestaParametriModel class head @1-62B3CCEF
public class AdmRichiestaParametriModel extends com.codecharge.components.Page {
    public AdmRichiestaParametriModel() {
        this( new CCSLocale(), null );
    }

    public AdmRichiestaParametriModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRichiestaParametriModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRichiestaParametriModel class head

//page settings @1-6EAAE4B3
        super("AdmRichiestaParametri", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__4 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__4.setVisible( true );
            add( Guida__4 );
            com.codecharge.components.IncludePage Footer__5 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__5.setVisible( true );
            add( Footer__5 );
        } // end page
//End page settings

//PARAMETRI EditGrid @6-F4239651
        
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

            com.codecharge.components.Label NOME__7 = new com.codecharge.components.Label("NOME", "TITOLO", this );
            NOME__7.setType( com.codecharge.components.ControlType.TEXT );
            NOME__7.setHtmlEncode( true );
            PARAMETRI.addRowControl( "NOME" );
            PARAMETRI.add(NOME__7);

            com.codecharge.components.TextBox VALORE__8 = new com.codecharge.components.TextBox("VALORE", "VALORE", this );
            VALORE__8.setType( com.codecharge.components.ControlType.TEXT );
            VALORE__8.setHtmlEncode( true );
            PARAMETRI.addRowControl( "VALORE" );
            PARAMETRI.add( VALORE__8 );

            com.codecharge.components.Hidden NOME_PAR__9 = new com.codecharge.components.Hidden("NOME_PAR", "NOME_PAR", this );
            NOME_PAR__9.setType( com.codecharge.components.ControlType.TEXT );
            NOME_PAR__9.setHtmlEncode( true );
            PARAMETRI.addRowControl( "NOME_PAR" );
            PARAMETRI.add( NOME_PAR__9 );

            com.codecharge.components.Hidden ID_RIC__10 = new com.codecharge.components.Hidden("ID_RIC", "ID_RIC", this );
            ID_RIC__10.setType( com.codecharge.components.ControlType.TEXT );
            ID_RIC__10.setHtmlEncode( true );
            PARAMETRI.addRowControl( "ID_RIC" );
            PARAMETRI.add( ID_RIC__10 );

            com.codecharge.components.CheckBox CheckBox_Delete__11=  new com.codecharge.components.CheckBox( "CheckBox_Delete", this );
            CheckBox_Delete__11.setType( com.codecharge.components.ControlType.BOOLEAN );
            CheckBox_Delete__11.setCheckedValue( true );
            CheckBox_Delete__11.setUncheckedValue( false );
            PARAMETRI.add(CheckBox_Delete__11);

            com.codecharge.components.Button Button_Submit__12 = new com.codecharge.components.Button("Button_Submit", this);
            Button_Submit__12.addExcludeParam( "ccsForm" );
            Button_Submit__12.addExcludeParam( "Button_Submit" );
            Button_Submit__12.setOperation( "Submit" );
            PARAMETRI.add( Button_Submit__12 );
            add(PARAMETRI);
        } // End definition of PARAMETRI editable grid model
//End PARAMETRI EditGrid

//AdmRichiestaParametriModel class tail @1-F5FC18C5
    }
}
//End AdmRichiestaParametriModel class tail

