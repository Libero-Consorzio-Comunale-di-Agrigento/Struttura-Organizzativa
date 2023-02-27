//AD4_SEZIONE_SELRow: import @10-F8A201D2
package amvadm.AdmDocumentoRevisioni;

import java.util.*;
import com.codecharge.db.*;
//End AD4_SEZIONE_SELRow: import

//AD4_SEZIONE_SELRow: class head @10-334317EC
public class AD4_SEZIONE_SELRow {
//End AD4_SEZIONE_SELRow: class head

//AD4_SEZIONE_SELRow: declare fiels @10-EB748338
    private TextField NOME_DOCUMENTO = new TextField("NOME_DOCUMENTO", "TITOLO");
    private TextField Label1 = new TextField("Label1", "NEW_PAGE");
//End AD4_SEZIONE_SELRow: declare fiels

//AD4_SEZIONE_SELRow: constructor @10-2FF009FD
    public AD4_SEZIONE_SELRow() {
    }
//End AD4_SEZIONE_SELRow: constructor

//AD4_SEZIONE_SELRow: method(s) of NOME_DOCUMENTO @11-FF4A20D7
    public TextField getNOME_DOCUMENTOField() {
        return NOME_DOCUMENTO;
    }

    public String getNOME_DOCUMENTO() {
        return NOME_DOCUMENTO.getValue();
    }

    public void setNOME_DOCUMENTO(String value) {
        this.NOME_DOCUMENTO.setValue(value);
    }
//End AD4_SEZIONE_SELRow: method(s) of NOME_DOCUMENTO

//AD4_SEZIONE_SELRow: method(s) of Label1 @30-6401A877
    public TextField getLabel1Field() {
        return Label1;
    }

    public String getLabel1() {
        return Label1.getValue();
    }

    public void setLabel1(String value) {
        this.Label1.setValue(value);
    }
//End AD4_SEZIONE_SELRow: method(s) of Label1

//AD4_SEZIONE_SELRow: class tail @10-FCB6E20C
}
//End AD4_SEZIONE_SELRow: class tail

