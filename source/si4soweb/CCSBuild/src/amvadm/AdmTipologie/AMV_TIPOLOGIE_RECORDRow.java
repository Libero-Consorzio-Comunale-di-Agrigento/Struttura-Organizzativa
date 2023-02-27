//AMV_TIPOLOGIE_RECORDRow: import @22-5C42AE99
package amvadm.AdmTipologie;

import java.util.*;
import com.codecharge.db.*;
//End AMV_TIPOLOGIE_RECORDRow: import

//AMV_TIPOLOGIE_RECORDRow: class head @22-25AE53A3
public class AMV_TIPOLOGIE_RECORDRow {
//End AMV_TIPOLOGIE_RECORDRow: class head

//AMV_TIPOLOGIE_RECORDRow: declare fiels @22-C8AD99B0
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private TextField LINK = new TextField("LINK", "LINK");
    private TextField ZONA = new TextField("ZONA", "ZONA");
    private TextField ZONA_VISIBILITA = new TextField("ZONA_VISIBILITA", "ZONA_VISIBILITA");
    private TextField ZONA_FORMATO = new TextField("ZONA_FORMATO", "ZONA_FORMATO");
    private TextField IMMAGINE = new TextField("IMMAGINE", "IMMAGINE");
    private LongField MAX_VIS = new LongField("MAX_VIS", "MAX_VIS");
    private TextField ICONA = new TextField("ICONA", "ICONA");
    private LongField ID_TIPOLOGIA = new LongField("ID_TIPOLOGIA", "ID_TIPOLOGIA");
//End AMV_TIPOLOGIE_RECORDRow: declare fiels

//AMV_TIPOLOGIE_RECORDRow: constructor @22-ACD6C4BC
    public AMV_TIPOLOGIE_RECORDRow() {
    }
//End AMV_TIPOLOGIE_RECORDRow: constructor

//AMV_TIPOLOGIE_RECORDRow: method(s) of NOME @23-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of NOME

//AMV_TIPOLOGIE_RECORDRow: method(s) of DESCRIZIONE @24-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of DESCRIZIONE

//AMV_TIPOLOGIE_RECORDRow: method(s) of SEQUENZA @26-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of SEQUENZA

//AMV_TIPOLOGIE_RECORDRow: method(s) of LINK @28-E8490594
    public TextField getLINKField() {
        return LINK;
    }

    public String getLINK() {
        return LINK.getValue();
    }

    public void setLINK(String value) {
        this.LINK.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of LINK

//AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA @39-EEFA4AA2
    public TextField getZONAField() {
        return ZONA;
    }

    public String getZONA() {
        return ZONA.getValue();
    }

    public void setZONA(String value) {
        this.ZONA.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA

//AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA_VISIBILITA @43-6A19C690
    public TextField getZONA_VISIBILITAField() {
        return ZONA_VISIBILITA;
    }

    public String getZONA_VISIBILITA() {
        return ZONA_VISIBILITA.getValue();
    }

    public void setZONA_VISIBILITA(String value) {
        this.ZONA_VISIBILITA.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA_VISIBILITA

//AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA_FORMATO @40-9B65CB44
    public TextField getZONA_FORMATOField() {
        return ZONA_FORMATO;
    }

    public String getZONA_FORMATO() {
        return ZONA_FORMATO.getValue();
    }

    public void setZONA_FORMATO(String value) {
        this.ZONA_FORMATO.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of ZONA_FORMATO

//AMV_TIPOLOGIE_RECORDRow: method(s) of IMMAGINE @41-D0029DDF
    public TextField getIMMAGINEField() {
        return IMMAGINE;
    }

    public String getIMMAGINE() {
        return IMMAGINE.getValue();
    }

    public void setIMMAGINE(String value) {
        this.IMMAGINE.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of IMMAGINE

//AMV_TIPOLOGIE_RECORDRow: method(s) of MAX_VIS @42-F19BF571
    public LongField getMAX_VISField() {
        return MAX_VIS;
    }

    public Long getMAX_VIS() {
        return MAX_VIS.getValue();
    }

    public void setMAX_VIS(Long value) {
        this.MAX_VIS.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of MAX_VIS

//AMV_TIPOLOGIE_RECORDRow: method(s) of ICONA @45-51B27CAD
    public TextField getICONAField() {
        return ICONA;
    }

    public String getICONA() {
        return ICONA.getValue();
    }

    public void setICONA(String value) {
        this.ICONA.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of ICONA

//AMV_TIPOLOGIE_RECORDRow: method(s) of ID_TIPOLOGIA @33-1DBA51EF
    public LongField getID_TIPOLOGIAField() {
        return ID_TIPOLOGIA;
    }

    public Long getID_TIPOLOGIA() {
        return ID_TIPOLOGIA.getValue();
    }

    public void setID_TIPOLOGIA(Long value) {
        this.ID_TIPOLOGIA.setValue(value);
    }
//End AMV_TIPOLOGIE_RECORDRow: method(s) of ID_TIPOLOGIA

//AMV_TIPOLOGIE_RECORDRow: class tail @22-FCB6E20C
}
//End AMV_TIPOLOGIE_RECORDRow: class tail

