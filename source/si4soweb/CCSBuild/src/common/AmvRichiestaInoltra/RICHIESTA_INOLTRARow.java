//RICHIESTA_INOLTRARow: import @6-7BF4AD62
package common.AmvRichiestaInoltra;

import java.util.*;
import com.codecharge.db.*;
//End RICHIESTA_INOLTRARow: import

//RICHIESTA_INOLTRARow: class head @6-326CC0D1
public class RICHIESTA_INOLTRARow {
//End RICHIESTA_INOLTRARow: class head

//RICHIESTA_INOLTRARow: declare fiels @6-8AFEEF0B
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
    private TextField STATO_FUTURO = new TextField("STATO_FUTURO", "STATO_FUTURO");
//End RICHIESTA_INOLTRARow: declare fiels

//RICHIESTA_INOLTRARow: constructor @6-AF1B1920
    public RICHIESTA_INOLTRARow() {
    }
//End RICHIESTA_INOLTRARow: constructor

//RICHIESTA_INOLTRARow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of TITOLO

//RICHIESTA_INOLTRARow: method(s) of DATA_INSERIMENTO @39-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of DATA_INSERIMENTO

//RICHIESTA_INOLTRARow: method(s) of NOMINATIVO_AUTORE @40-5402A051
    public TextField getNOMINATIVO_AUTOREField() {
        return NOMINATIVO_AUTORE;
    }

    public String getNOMINATIVO_AUTORE() {
        return NOMINATIVO_AUTORE.getValue();
    }

    public void setNOMINATIVO_AUTORE(String value) {
        this.NOMINATIVO_AUTORE.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of NOMINATIVO_AUTORE

//RICHIESTA_INOLTRARow: method(s) of DATA_AGGIORNAMENTO @21-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of DATA_AGGIORNAMENTO

//RICHIESTA_INOLTRARow: method(s) of NOMINATIVO_AGGIORNAMENTO @22-CC248FDB
    public TextField getNOMINATIVO_AGGIORNAMENTOField() {
        return NOMINATIVO_AGGIORNAMENTO;
    }

    public String getNOMINATIVO_AGGIORNAMENTO() {
        return NOMINATIVO_AGGIORNAMENTO.getValue();
    }

    public void setNOMINATIVO_AGGIORNAMENTO(String value) {
        this.NOMINATIVO_AGGIORNAMENTO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of NOMINATIVO_AGGIORNAMENTO

//RICHIESTA_INOLTRARow: method(s) of NOTE @32-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of NOTE

//RICHIESTA_INOLTRARow: method(s) of CRONOLOGIA @31-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of CRONOLOGIA

//RICHIESTA_INOLTRARow: method(s) of NOTE_LABEL @38-2E4B73D0
    public TextField getNOTE_LABELField() {
        return NOTE_LABEL;
    }

    public String getNOTE_LABEL() {
        return NOTE_LABEL.getValue();
    }

    public void setNOTE_LABEL(String value) {
        this.NOTE_LABEL.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of NOTE_LABEL

//RICHIESTA_INOLTRARow: method(s) of REVISIONE @23-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of REVISIONE

//RICHIESTA_INOLTRARow: method(s) of ID_DOCUMENTO @14-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of ID_DOCUMENTO

//RICHIESTA_INOLTRARow: method(s) of STATO_FUTURO @48-3D20FE0C
    public TextField getSTATO_FUTUROField() {
        return STATO_FUTURO;
    }

    public String getSTATO_FUTURO() {
        return STATO_FUTURO.getValue();
    }

    public void setSTATO_FUTURO(String value) {
        this.STATO_FUTURO.setValue(value);
    }
//End RICHIESTA_INOLTRARow: method(s) of STATO_FUTURO

//RICHIESTA_INOLTRARow: class tail @6-FCB6E20C
}
//End RICHIESTA_INOLTRARow: class tail

