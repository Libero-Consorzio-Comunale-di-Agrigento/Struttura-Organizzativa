//SERVIZI_DISPONIBILIRow: import @16-98CFC4AB
package common.AmvServiziDisponibiliElenco_i;

import java.util.*;
import com.codecharge.db.*;
//End SERVIZI_DISPONIBILIRow: import

//SERVIZI_DISPONIBILIRow: class head @16-3AEA3A02
public class SERVIZI_DISPONIBILIRow {
//End SERVIZI_DISPONIBILIRow: class head

//SERVIZI_DISPONIBILIRow: declare fiels @16-9478FC83
    private TextField SERVIZIO = new TextField("SERVIZIO", "SERVIZIO");
    private TextField RICHIESTA = new TextField("RICHIESTA", "RICHIESTA");
    private TextField AFCNavigator = new TextField("AFCNavigator", "AFCNavigator");
    private TextField ISTANZA = new TextField("ISTANZA", "ISTANZA");
    private TextField MODULO = new TextField("MODULO", "MODULO");
//End SERVIZI_DISPONIBILIRow: declare fiels

//SERVIZI_DISPONIBILIRow: constructor @16-2B455B35
    public SERVIZI_DISPONIBILIRow() {
    }
//End SERVIZI_DISPONIBILIRow: constructor

//SERVIZI_DISPONIBILIRow: method(s) of SERVIZIO @17-6655FB9B
    public TextField getSERVIZIOField() {
        return SERVIZIO;
    }

    public String getSERVIZIO() {
        return SERVIZIO.getValue();
    }

    public void setSERVIZIO(String value) {
        this.SERVIZIO.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of SERVIZIO

//SERVIZI_DISPONIBILIRow: method(s) of RICHIESTA @18-8A5214D9
    public TextField getRICHIESTAField() {
        return RICHIESTA;
    }

    public String getRICHIESTA() {
        return RICHIESTA.getValue();
    }

    public void setRICHIESTA(String value) {
        this.RICHIESTA.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of RICHIESTA

//SERVIZI_DISPONIBILIRow: method(s) of AFCNavigator @39-B6FE7CCE
    public TextField getAFCNavigatorField() {
        return AFCNavigator;
    }

    public String getAFCNavigator() {
        return AFCNavigator.getValue();
    }

    public void setAFCNavigator(String value) {
        this.AFCNavigator.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of AFCNavigator

//SERVIZI_DISPONIBILIRow: method(s) of ISTANZA @32-CC23EEBF
    public TextField getISTANZAField() {
        return ISTANZA;
    }

    public String getISTANZA() {
        return ISTANZA.getValue();
    }

    public void setISTANZA(String value) {
        this.ISTANZA.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of ISTANZA

//SERVIZI_DISPONIBILIRow: method(s) of MODULO @33-D7A676D3
    public TextField getMODULOField() {
        return MODULO;
    }

    public String getMODULO() {
        return MODULO.getValue();
    }

    public void setMODULO(String value) {
        this.MODULO.setValue(value);
    }
//End SERVIZI_DISPONIBILIRow: method(s) of MODULO

//SERVIZI_DISPONIBILIRow: class tail @16-FCB6E20C
}
//End SERVIZI_DISPONIBILIRow: class tail

