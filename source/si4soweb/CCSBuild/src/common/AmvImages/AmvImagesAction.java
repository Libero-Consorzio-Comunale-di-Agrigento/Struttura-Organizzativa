//AmvImagesAction imports @1-4E790960
package common.AmvImages;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvImagesAction imports

//AmvImagesAction class @1-589676E6
public class AmvImagesAction extends Action {

//End AmvImagesAction class

//AmvImagesAction: method perform @1-1D6B7680
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvImagesModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvImagesModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvImagesAction: method perform

//AmvImagesAction: call children actions @1-E8EB7ECD
        if (result == null) {
            RecordImageClass RecordImage = new RecordImageClass();
            if ( ( redirect = RecordImage.perform( page.getRecord("RecordImage")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvImagesAction: call children actions

//RecordImage Record @2-24815F03
    final class RecordImageClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End RecordImage Record

//RecordImage Record: method perform @2-2188D0D0
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "Immagini" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Button_Insert" ).setVisible( false );
//End RecordImage Record: method perform

//RecordImage Record: children actions @2-876E8B78
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("RecordImage".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Button1") != null) {
                        if (validate()) {
                            Button1Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button2") != null) {
                        if (validate()) {
                            Button2Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Button_Insert") != null) {
                        if (validate()) {
                            Button_InsertAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button1") != null) {
                        if (validate()) {
                            Button1Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button2") != null) {
                        if (validate()) {
                            Button2Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End RecordImage Record: children actions

//RecordImage Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End RecordImage Record: method perform tail

//Button_Insert Button @5-9B60DDE6
        void Button_InsertAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvImages" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Button_Insert Button

//Button1 Button @9-B39F1A82
        void Button1Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button1");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "Immagini" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button1 Button

//Button2 Button @20-DCAFEA0E
        void Button2Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button2");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "Immagini" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button2 Button

void read() { //RecordImage Record: method read @2-7F8AAE5A

//RecordImage Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End RecordImage Record: method read head

} //RecordImage Record: method read tail @2-FCB6E20C

void InsertAction() { //RecordImage Record: method insert @2-11643485

//RecordImage Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End RecordImage Record: method insert head

//RecordImage Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End RecordImage Record: components insert actions

} //RecordImage Record: method insert tail @2-FCB6E20C

void UpdateAction() { //RecordImage Record: method update @2-5771D0AA

//RecordImage Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End RecordImage Record: method update head

//RecordImage Record: components update actions @2-68525650
            if (! model.hasErrors()) {
            }
//End RecordImage Record: components update actions

} //RecordImage Record: method update tail @2-FCB6E20C

void DeleteAction() { //RecordImage Record: method delete @2-11FC2E1E

//RecordImage Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End RecordImage Record: method delete head

//RecordImage Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End RecordImage Record: components delete actions

} //RecordImage Record: method delete tail @2-FCB6E20C

//RecordImage Record: method validate @2-A8FFD717
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End RecordImage Record: method validate

//RecordImage Record Tail @2-FCB6E20C
    }
//End RecordImage Record Tail

//AmvImages Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvImages Page: method validate

//AmvImagesAction Tail @1-FCB6E20C
}
//End AmvImagesAction Tail

