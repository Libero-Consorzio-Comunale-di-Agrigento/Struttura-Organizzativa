//AMV_DOCUMENTO_RESPINGIRow: import @6-A3CD0A08
package common.AmvRichiestaElimina;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DOCUMENTO_RESPINGIRow: import

//AMV_DOCUMENTO_RESPINGIRow: class head @6-C5BB254F
public class AMV_DOCUMENTO_RESPINGIRow {
//End AMV_DOCUMENTO_RESPINGIRow: class head

//AMV_DOCUMENTO_RESPINGIRow: declare fiels @6-AA85562F
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField NOMINATIVO_AUTORE = new TextField("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField NOMINATIVO_AGGIORNAMENTO = new TextField("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO");
    private TextField NOTE = new TextField("NOTE", "NOTE");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField NOTE_LABEL = new TextField("NOTE_LABEL", "NOTE");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
//End AMV_DOCUMENTO_RESPINGIRow: declare fiels

//AMV_DOCUMENTO_RESPINGIRow: constructor @6-1CE8794A
    public AMV_DOCUMENTO_RESPINGIRow() {
    }
//End AMV_DOCUMENTO_RESPINGIRow: constructor

//AMV_DOCUMENTO_RESPINGIRow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of TITOLO

//AMV_DOCUMENTO_RESPINGIRow: method(s) of DATA_INSERIMENTO @39-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of DATA_INSERIMENTO

//AMV_DOCUMENTO_RESPINGIRow: method(s) of NOMINATIVO_AUTORE @40-5402A051
    public TextField getNOMINATIVO_AUTOREField() {
        return NOMINATIVO_AUTORE;
    }

    public String getNOMINATIVO_AUTORE() {
        return NOMINATIVO_AUTORE.getValue();
    }

    public void setNOMINATIVO_AUTORE(String value) {
        this.NOMINATIVO_AUTORE.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of NOMINATIVO_AUTORE

//AMV_DOCUMENTO_RESPINGIRow: method(s) of DATA_AGGIORNAMENTO @21-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of DATA_AGGIORNAMENTO

//AMV_DOCUMENTO_RESPINGIRow: method(s) of NOMINATIVO_AGGIORNAMENTO @22-CC248FDB
    public TextField getNOMINATIVO_AGGIORNAMENTOField() {
        return NOMINATIVO_AGGIORNAMENTO;
    }

    public String getNOMINATIVO_AGGIORNAMENTO() {
        return NOMINATIVO_AGGIORNAMENTO.getValue();
    }

    public void setNOMINATIVO_AGGIORNAMENTO(String value) {
        this.NOMINATIVO_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of NOMINATIVO_AGGIORNAMENTO

//AMV_DOCUMENTO_RESPINGIRow: method(s) of NOTE @32-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of NOTE

//AMV_DOCUMENTO_RESPINGIRow: method(s) of CRONOLOGIA @31-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of CRONOLOGIA

//AMV_DOCUMENTO_RESPINGIRow: method(s) of NOTE_LABEL @38-2E4B73D0
    public TextField getNOTE_LABELField() {
        return NOTE_LABEL;
    }

    public String getNOTE_LABEL() {
        return NOTE_LABEL.getValue();
    }

    public void setNOTE_LABEL(String value) {
        this.NOTE_LABEL.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of NOTE_LABEL

//AMV_DOCUMENTO_RESPINGIRow: method(s) of REVISIONE @23-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of REVISIONE

//AMV_DOCUMENTO_RESPINGIRow: method(s) of ID_DOCUMENTO @14-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_RESPINGIRow: method(s) of ID_DOCUMENTO

//AMV_DOCUMENTO_RESPINGIRow: class tail @6-FCB6E20C
}
//End AMV_DOCUMENTO_RESPINGIRow: class tail

