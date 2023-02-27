//AD4_DOCUMENTO_SELRow: import @10-F8A201D2
package amvadm.AdmDocumentoRevisioni;

import java.util.*;
import com.codecharge.db.*;
//End AD4_DOCUMENTO_SELRow: import

//AD4_DOCUMENTO_SELRow: class head @10-C2280B65
public class AD4_DOCUMENTO_SELRow {
//End AD4_DOCUMENTO_SELRow: class head

//AD4_DOCUMENTO_SELRow: declare fiels @10-4C8FF878
    private TextField NOME_DOCUMENTO = new TextField("NOME_DOCUMENTO", "TITOLO");
    private TextField NUOVA_REV = new TextField("NUOVA_REV", "NUOVA_REV");
//End AD4_DOCUMENTO_SELRow: declare fiels

//AD4_DOCUMENTO_SELRow: constructor @10-34F3C410
    public AD4_DOCUMENTO_SELRow() {
    }
//End AD4_DOCUMENTO_SELRow: constructor

//AD4_DOCUMENTO_SELRow: method(s) of NOME_DOCUMENTO @11-FF4A20D7
    public TextField getNOME_DOCUMENTOField() {
        return NOME_DOCUMENTO;
    }

    public String getNOME_DOCUMENTO() {
        return NOME_DOCUMENTO.getValue();
    }

    public void setNOME_DOCUMENTO(String value) {
        this.NOME_DOCUMENTO.setValue(value);
    }
//End AD4_DOCUMENTO_SELRow: method(s) of NOME_DOCUMENTO

//AD4_DOCUMENTO_SELRow: method(s) of NUOVA_REV @30-BBB9CD73
    public TextField getNUOVA_REVField() {
        return NUOVA_REV;
    }

    public String getNUOVA_REV() {
        return NUOVA_REV.getValue();
    }

    public void setNUOVA_REV(String value) {
        this.NUOVA_REV.setValue(value);
    }
//End AD4_DOCUMENTO_SELRow: method(s) of NUOVA_REV

//AD4_DOCUMENTO_SELRow: class tail @10-FCB6E20C
}
//End AD4_DOCUMENTO_SELRow: class tail

