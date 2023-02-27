//AmvFileSelectModel imports @1-C2B9ECD2
package common.AmvFileSelect;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvFileSelectModel imports

//AmvFileSelectModel class head @1-83990E87
public class AmvFileSelectModel extends com.codecharge.components.Page {
    public AmvFileSelectModel() {
        this( new CCSLocale(), null );
    }

    public AmvFileSelectModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvFileSelectModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvFileSelectModel class head

//page settings @1-8A90DFD8
        super("AmvFileSelect", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-CD83A32A
        
        /*
            Model of FILE_LIST record defining.
        */
        {
            com.codecharge.components.Record FILE_LIST = new com.codecharge.components.Record("FILE_LIST");
            FILE_LIST.setPageModel( this );
            FILE_LIST.addExcludeParam( "ccsForm" );
            FILE_LIST.setVisible( true );
            FILE_LIST.setAllowInsert(false);
            FILE_LIST.setAllowDelete(false);
            FILE_LIST.setPreserveType(PreserveParameterType.GET);
            FILE_LIST.setReturnPage("AmvFileSelect" + Names.ACTION_SUFFIX);
            FILE_LIST.addRecordListener(new FILE_LISTRecordHandler());

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.Label MVWF__17 = new com.codecharge.components.Label("MVWF", "MVWF", this );
            MVWF__17.setType( com.codecharge.components.ControlType.TEXT );
            MVWF__17.setHtmlEncode( true );
            MVWF__17.addControlListener( new FILE_LISTMVWFHandler());
            FILE_LIST.add(MVWF__17);

            com.codecharge.components.Label FILE_LIST_BOX__13 = new com.codecharge.components.Label("FILE_LIST_BOX", this);
            FILE_LIST_BOX__13.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(FILE_LIST_BOX__13);

            com.codecharge.components.Label INPUT_FILE__19 = new com.codecharge.components.Label("INPUT_FILE", "INPUT_FILE", this );
            INPUT_FILE__19.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(INPUT_FILE__19);

            com.codecharge.components.Hidden MOSTRA__20 = new com.codecharge.components.Hidden("MOSTRA", "MOSTRA", this );
            MOSTRA__20.setType( com.codecharge.components.ControlType.TEXT );
            MOSTRA__20.setHtmlEncode( true );
            FILE_LIST.add( MOSTRA__20 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Update" );
            FILE_LIST.add( Button_Update__6 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            FILE_LIST.add( Annulla__11 );
            add(FILE_LIST);
        } // End definition of FILE_LIST record model.
//End FILE_LIST record

//AmvFileSelectModel class tail @1-F5FC18C5
    }
}
//End AmvFileSelectModel class tail



