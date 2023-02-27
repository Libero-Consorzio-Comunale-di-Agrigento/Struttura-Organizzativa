//AmvAttachSelectModel imports @1-F15BEB10
package common.AmvAttachSelect;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAttachSelectModel imports

//AmvAttachSelectModel class head @1-41D5142A
public class AmvAttachSelectModel extends com.codecharge.components.Page {
    public AmvAttachSelectModel() {
        this( new CCSLocale(), null );
    }

    public AmvAttachSelectModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAttachSelectModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAttachSelectModel class head

//page settings @1-471FD783
        super("AmvAttachSelect", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-AABDD1F1
        
        /*
            Model of FILE_LIST record defining.
        */
        {
            com.codecharge.components.Record FILE_LIST = new com.codecharge.components.Record("FILE_LIST");
            FILE_LIST.setPageModel( this );
            FILE_LIST.addExcludeParam( "ccsForm" );
            FILE_LIST.setVisible( true );
            FILE_LIST.setAllowInsert(false);
            FILE_LIST.setAllowUpdate(false);
            FILE_LIST.setAllowDelete(false);
            FILE_LIST.setPreserveType(PreserveParameterType.GET);
            FILE_LIST.setReturnPage("AmvAttachSelect" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.ListBox DOCUMENTO__27 = new com.codecharge.components.ListBox("DOCUMENTO", "VALORE", this );
            DOCUMENTO__27.setType( com.codecharge.components.ControlType.TEXT );
            DOCUMENTO__27.setHtmlEncode( true );
            DOCUMENTO__27.setBoundColumn( "VALORE" );
            DOCUMENTO__27.setTextColumn( "NOME" );
            FILE_LIST.add( DOCUMENTO__27 );

            com.codecharge.components.Hidden DATASOURCE__37 = new com.codecharge.components.Hidden("DATASOURCE", "", this );
            DATASOURCE__37.setType( com.codecharge.components.ControlType.TEXT );
            DATASOURCE__37.setHtmlEncode( true );
            DATASOURCE__37.addControlListener( new FILE_LISTDATASOURCEHandler());
            FILE_LIST.add( DATASOURCE__37 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Cancel" );
            FILE_LIST.add( Button_Update__6 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            FILE_LIST.add( Annulla__11 );
            add(FILE_LIST);
        } // End definition of FILE_LIST record model.
//End FILE_LIST record

//AmvAttachSelectModel class tail @1-F5FC18C5
    }
}
//End AmvAttachSelectModel class tail
