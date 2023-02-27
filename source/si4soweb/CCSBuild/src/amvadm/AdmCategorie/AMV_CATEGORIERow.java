//AMV_CATEGORIERow: import @2-DD4D1B0C
package amvadm.AdmCategorie;

import java.util.*;
import com.codecharge.db.*;
//End AMV_CATEGORIERow: import

//AMV_CATEGORIERow: class head @2-92A1AE14
public class AMV_CATEGORIERow {
//End AMV_CATEGORIERow: class head

//AMV_CATEGORIERow: declare fiels @2-82C3FAB6
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ID = new TextField("ID", "ID_CATEGORIA");
    private TextField ID_CATEGORIA = new TextField("ID_CATEGORIA", "ID_CATEGORIA");
//End AMV_CATEGORIERow: declare fiels

//AMV_CATEGORIERow: constructor @2-7EB4B2CA
    public AMV_CATEGORIERow() {
    }
//End AMV_CATEGORIERow: constructor

//AMV_CATEGORIERow: method(s) of NOME @6-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_CATEGORIERow: method(s) of NOME

//AMV_CATEGORIERow: method(s) of DESCRIZIONE @8-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_CATEGORIERow: method(s) of DESCRIZIONE

//AMV_CATEGORIERow: method(s) of AFCNavigator @26-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End AMV_CATEGORIERow: method(s) of AFCNavigator

//AMV_CATEGORIERow: method(s) of ID @7-2B895796
    public TextField getIDField() {
        return ID;
    }

    public String getID() {
        return ID.getValue();
    }

    public void setID(String value) {
        this.ID.setValue(value);
    }
//End AMV_CATEGORIERow: method(s) of ID

//AMV_CATEGORIERow: method(s) of ID_CATEGORIA @7-6DE73DA9
    public TextField getID_CATEGORIAField() {
        return ID_CATEGORIA;
    }

    public String getID_CATEGORIA() {
        return ID_CATEGORIA.getValue();
    }

    public void setID_CATEGORIA(String value) {
        this.ID_CATEGORIA.setValue(value);
    }
//End AMV_CATEGORIERow: method(s) of ID_CATEGORIA

//AMV_CATEGORIERow: class tail @2-FCB6E20C
}
//End AMV_CATEGORIERow: class tail

