//AMV_RILEVANZE_RECORDRow: import @14-FDC91A5C
package amvadm.AdmRilevanze;

import java.util.*;
import com.codecharge.db.*;
//End AMV_RILEVANZE_RECORDRow: import

//AMV_RILEVANZE_RECORDRow: class head @14-F9879DAE
public class AMV_RILEVANZE_RECORDRow {
//End AMV_RILEVANZE_RECORDRow: class head

//AMV_RILEVANZE_RECORDRow: declare fiels @14-D80B7723
    private TextField NOME = new TextField("NOME", "NOME");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private TextField ZONA = new TextField("ZONA", "ZONA");
    private TextField ZONA_VISIBILITA = new TextField("ZONA_VISIBILITA", "ZONA_VISIBILITA");
    private TextField ZONA_FORMATO = new TextField("ZONA_FORMATO", "ZONA_FORMATO");
    private TextField IMMAGINE = new TextField("IMMAGINE", "IMMAGINE");
    private LongField MAX_VIS = new LongField("MAX_VIS", "MAX_VIS");
    private TextField IMPORTANZA = new TextField("IMPORTANZA", "IMPORTANZA");
    private TextField ICONA = new TextField("ICONA", "ICONA");
    private LongField ID_RILEVANZA = new LongField("ID_RILEVANZA", "ID_RILEVANZA");
//End AMV_RILEVANZE_RECORDRow: declare fiels

//AMV_RILEVANZE_RECORDRow: constructor @14-B3C5359F
    public AMV_RILEVANZE_RECORDRow() {
    }
//End AMV_RILEVANZE_RECORDRow: constructor

//AMV_RILEVANZE_RECORDRow: method(s) of NOME @21-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of NOME

//AMV_RILEVANZE_RECORDRow: method(s) of SEQUENZA @23-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of SEQUENZA

//AMV_RILEVANZE_RECORDRow: method(s) of ZONA @26-EEFA4AA2
    public TextField getZONAField() {
        return ZONA;
    }

    public String getZONA() {
        return ZONA.getValue();
    }

    public void setZONA(String value) {
        this.ZONA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of ZONA

//AMV_RILEVANZE_RECORDRow: method(s) of ZONA_VISIBILITA @30-6A19C690
    public TextField getZONA_VISIBILITAField() {
        return ZONA_VISIBILITA;
    }

    public String getZONA_VISIBILITA() {
        return ZONA_VISIBILITA.getValue();
    }

    public void setZONA_VISIBILITA(String value) {
        this.ZONA_VISIBILITA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of ZONA_VISIBILITA

//AMV_RILEVANZE_RECORDRow: method(s) of ZONA_FORMATO @27-9B65CB44
    public TextField getZONA_FORMATOField() {
        return ZONA_FORMATO;
    }

    public String getZONA_FORMATO() {
        return ZONA_FORMATO.getValue();
    }

    public void setZONA_FORMATO(String value) {
        this.ZONA_FORMATO.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of ZONA_FORMATO

//AMV_RILEVANZE_RECORDRow: method(s) of IMMAGINE @28-D0029DDF
    public TextField getIMMAGINEField() {
        return IMMAGINE;
    }

    public String getIMMAGINE() {
        return IMMAGINE.getValue();
    }

    public void setIMMAGINE(String value) {
        this.IMMAGINE.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of IMMAGINE

//AMV_RILEVANZE_RECORDRow: method(s) of MAX_VIS @29-F19BF571
    public LongField getMAX_VISField() {
        return MAX_VIS;
    }

    public Long getMAX_VIS() {
        return MAX_VIS.getValue();
    }

    public void setMAX_VIS(Long value) {
        this.MAX_VIS.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of MAX_VIS

//AMV_RILEVANZE_RECORDRow: method(s) of IMPORTANZA @22-B2F8E335
    public TextField getIMPORTANZAField() {
        return IMPORTANZA;
    }

    public String getIMPORTANZA() {
        return IMPORTANZA.getValue();
    }

    public void setIMPORTANZA(String value) {
        this.IMPORTANZA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of IMPORTANZA

//AMV_RILEVANZE_RECORDRow: method(s) of ICONA @32-51B27CAD
    public TextField getICONAField() {
        return ICONA;
    }

    public String getICONA() {
        return ICONA.getValue();
    }

    public void setICONA(String value) {
        this.ICONA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of ICONA

//AMV_RILEVANZE_RECORDRow: method(s) of ID_RILEVANZA @20-5CCE130A
    public LongField getID_RILEVANZAField() {
        return ID_RILEVANZA;
    }

    public Long getID_RILEVANZA() {
        return ID_RILEVANZA.getValue();
    }

    public void setID_RILEVANZA(Long value) {
        this.ID_RILEVANZA.setValue(value);
    }
//End AMV_RILEVANZE_RECORDRow: method(s) of ID_RILEVANZA

//AMV_RILEVANZE_RECORDRow: class tail @14-FCB6E20C
}
//End AMV_RILEVANZE_RECORDRow: class tail

