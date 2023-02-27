//AD4_PARAMETRI_RICHIESTAGridRow: import @40-3B54D52A
package amvadm.AdmRichiesta;

import java.util.*;
import com.codecharge.db.*;
//End AD4_PARAMETRI_RICHIESTAGridRow: import

//AD4_PARAMETRI_RICHIESTAGridRow: class head @40-FA97F30E
public class AD4_PARAMETRI_RICHIESTAGridRow {
//End AD4_PARAMETRI_RICHIESTAGridRow: class head

//AD4_PARAMETRI_RICHIESTAGridRow: declare fiels @40-39969DE4
    private TextField PARAMETRO = new TextField("PARAMETRO", "PARAMETRO");
    private TextField VALORE = new TextField("VALORE", "VALORE");
//End AD4_PARAMETRI_RICHIESTAGridRow: declare fiels

//AD4_PARAMETRI_RICHIESTAGridRow: constructor @40-8679B74C
    public AD4_PARAMETRI_RICHIESTAGridRow() {
    }
//End AD4_PARAMETRI_RICHIESTAGridRow: constructor

//AD4_PARAMETRI_RICHIESTAGridRow: method(s) of PARAMETRO @-E0500EC9
    public TextField getPARAMETROField() {
        return PARAMETRO;
    }

    public String getPARAMETRO() {
        return PARAMETRO.getValue();
    }

    public void setPARAMETRO(String value) {
        this.PARAMETRO.setValue(value);
    }
//End AD4_PARAMETRI_RICHIESTAGridRow: method(s) of PARAMETRO

//AD4_PARAMETRI_RICHIESTAGridRow: method(s) of VALORE @-BC514AA0
    public TextField getVALOREField() {
        return VALORE;
    }

    public String getVALORE() {
        return VALORE.getValue();
    }

    public void setVALORE(String value) {
        this.VALORE.setValue(value);
    }
//End AD4_PARAMETRI_RICHIESTAGridRow: method(s) of VALORE

//AD4_PARAMETRI_RICHIESTAGridRow: class tail @40-FCB6E20C
}
//End AD4_PARAMETRI_RICHIESTAGridRow: class tail

