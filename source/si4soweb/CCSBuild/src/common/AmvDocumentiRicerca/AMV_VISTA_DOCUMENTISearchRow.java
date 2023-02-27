//AMV_VISTA_DOCUMENTISearchRow: import @6-296D8861
package common.AmvDocumentiRicerca;

import java.util.*;
import com.codecharge.db.*;
//End AMV_VISTA_DOCUMENTISearchRow: import

//AMV_VISTA_DOCUMENTISearchRow: class head @6-C6175280
public class AMV_VISTA_DOCUMENTISearchRow {
//End AMV_VISTA_DOCUMENTISearchRow: class head

//AMV_VISTA_DOCUMENTISearchRow: declare fiels @6-9FDC8CDE
    private TextField s_TESTO = new TextField("s_TESTO", "");
    private TextField s_CERCA_TESTO = new TextField("s_CERCA_TESTO", "");
    private TextField s_DISPLAY = new TextField("s_DISPLAY", "");
    private LongField s_ID_SEZIONE = new LongField("s_ID_SEZIONE", "");
    private LongField s_ID_TIPOLOGIA = new LongField("s_ID_TIPOLOGIA", "TIPOLOGIA");
    private LongField s_ID_CATEGORIA = new LongField("s_ID_CATEGORIA", "");
    private LongField s_ID_ARGOMENTO = new LongField("s_ID_ARGOMENTO", "");
//End AMV_VISTA_DOCUMENTISearchRow: declare fiels

//AMV_VISTA_DOCUMENTISearchRow: constructor @6-F5225B22
    public AMV_VISTA_DOCUMENTISearchRow() {
    }
//End AMV_VISTA_DOCUMENTISearchRow: constructor

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_TESTO @10-8A65CBD6
    public TextField getS_TESTOField() {
        return s_TESTO;
    }

    public String getS_TESTO() {
        return s_TESTO.getValue();
    }

    public void setS_TESTO(String value) {
        this.s_TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_TESTO

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_CERCA_TESTO @73-21CB0B28
    public TextField getS_CERCA_TESTOField() {
        return s_CERCA_TESTO;
    }

    public String getS_CERCA_TESTO() {
        return s_CERCA_TESTO.getValue();
    }

    public void setS_CERCA_TESTO(String value) {
        this.s_CERCA_TESTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_CERCA_TESTO

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_DISPLAY @75-CC538B96
    public TextField getS_DISPLAYField() {
        return s_DISPLAY;
    }

    public String getS_DISPLAY() {
        return s_DISPLAY.getValue();
    }

    public void setS_DISPLAY(String value) {
        this.s_DISPLAY.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_DISPLAY

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_SEZIONE @72-848EB380
    public LongField getS_ID_SEZIONEField() {
        return s_ID_SEZIONE;
    }

    public Long getS_ID_SEZIONE() {
        return s_ID_SEZIONE.getValue();
    }

    public void setS_ID_SEZIONE(Long value) {
        this.s_ID_SEZIONE.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_SEZIONE

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_TIPOLOGIA @8-732B6FDD
    public LongField getS_ID_TIPOLOGIAField() {
        return s_ID_TIPOLOGIA;
    }

    public Long getS_ID_TIPOLOGIA() {
        return s_ID_TIPOLOGIA.getValue();
    }

    public void setS_ID_TIPOLOGIA(Long value) {
        this.s_ID_TIPOLOGIA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_TIPOLOGIA

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_CATEGORIA @90-BCA3E21C
    public LongField getS_ID_CATEGORIAField() {
        return s_ID_CATEGORIA;
    }

    public Long getS_ID_CATEGORIA() {
        return s_ID_CATEGORIA.getValue();
    }

    public void setS_ID_CATEGORIA(Long value) {
        this.s_ID_CATEGORIA.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_CATEGORIA

//AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_ARGOMENTO @91-F421BE82
    public LongField getS_ID_ARGOMENTOField() {
        return s_ID_ARGOMENTO;
    }

    public Long getS_ID_ARGOMENTO() {
        return s_ID_ARGOMENTO.getValue();
    }

    public void setS_ID_ARGOMENTO(Long value) {
        this.s_ID_ARGOMENTO.setValue(value);
    }
//End AMV_VISTA_DOCUMENTISearchRow: method(s) of s_ID_ARGOMENTO

//AMV_VISTA_DOCUMENTISearchRow: class tail @6-FCB6E20C
}
//End AMV_VISTA_DOCUMENTISearchRow: class tail

