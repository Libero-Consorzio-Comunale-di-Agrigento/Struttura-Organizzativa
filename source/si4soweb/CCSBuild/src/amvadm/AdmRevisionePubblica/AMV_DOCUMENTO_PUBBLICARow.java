//AMV_DOCUMENTO_PUBBLICARow: import @6-649C8B7E
package amvadm.AdmRevisionePubblica;

import java.util.*;
import com.codecharge.db.*;
//End AMV_DOCUMENTO_PUBBLICARow: import

//AMV_DOCUMENTO_PUBBLICARow: class head @6-EB8AC607
public class AMV_DOCUMENTO_PUBBLICARow {
//End AMV_DOCUMENTO_PUBBLICARow: class head

//AMV_DOCUMENTO_PUBBLICARow: declare fiels @6-43F5C77E
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField MVPAGES = new TextField("MVPAGES", "MVPAGES");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private TextField NOMINATIVO_AUTORE = new TextField("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField NOMINATIVO_AGGIORNAMENTO = new TextField("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO");
    private DateField INIZIO_PUBBLICAZIONE = new DateField("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE");
    private DateField FINE_PUBBLICAZIONE = new DateField("FINE_PUBBLICAZIONE", "FINE_PUBBLICAZIONE");
    private TextField CRONOLOGIA = new TextField("CRONOLOGIA", "CRONOLOGIA");
    private TextField NOTE = new TextField("NOTE", "NOTE");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
//End AMV_DOCUMENTO_PUBBLICARow: declare fiels

//AMV_DOCUMENTO_PUBBLICARow: constructor @6-46EC0509
    public AMV_DOCUMENTO_PUBBLICARow() {
    }
//End AMV_DOCUMENTO_PUBBLICARow: constructor

//AMV_DOCUMENTO_PUBBLICARow: method(s) of TITOLO @7-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of TITOLO

//AMV_DOCUMENTO_PUBBLICARow: method(s) of MVPAGES @38-59C95F0B
    public TextField getMVPAGESField() {
        return MVPAGES;
    }

    public String getMVPAGES() {
        return MVPAGES.getValue();
    }

    public void setMVPAGES(String value) {
        this.MVPAGES.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of MVPAGES

//AMV_DOCUMENTO_PUBBLICARow: method(s) of DATA_INSERIMENTO @36-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of DATA_INSERIMENTO

//AMV_DOCUMENTO_PUBBLICARow: method(s) of NOMINATIVO_AUTORE @37-5402A051
    public TextField getNOMINATIVO_AUTOREField() {
        return NOMINATIVO_AUTORE;
    }

    public String getNOMINATIVO_AUTORE() {
        return NOMINATIVO_AUTORE.getValue();
    }

    public void setNOMINATIVO_AUTORE(String value) {
        this.NOMINATIVO_AUTORE.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of NOMINATIVO_AUTORE

//AMV_DOCUMENTO_PUBBLICARow: method(s) of DATA_AGGIORNAMENTO @21-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of DATA_AGGIORNAMENTO

//AMV_DOCUMENTO_PUBBLICARow: method(s) of NOMINATIVO_AGGIORNAMENTO @22-CC248FDB
    public TextField getNOMINATIVO_AGGIORNAMENTOField() {
        return NOMINATIVO_AGGIORNAMENTO;
    }

    public String getNOMINATIVO_AGGIORNAMENTO() {
        return NOMINATIVO_AGGIORNAMENTO.getValue();
    }

    public void setNOMINATIVO_AGGIORNAMENTO(String value) {
        this.NOMINATIVO_AGGIORNAMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of NOMINATIVO_AGGIORNAMENTO

//AMV_DOCUMENTO_PUBBLICARow: method(s) of INIZIO_PUBBLICAZIONE @30-EA180E25
    public DateField getINIZIO_PUBBLICAZIONEField() {
        return INIZIO_PUBBLICAZIONE;
    }

    public Date getINIZIO_PUBBLICAZIONE() {
        return INIZIO_PUBBLICAZIONE.getValue();
    }

    public void setINIZIO_PUBBLICAZIONE(Date value) {
        this.INIZIO_PUBBLICAZIONE.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of INIZIO_PUBBLICAZIONE

//AMV_DOCUMENTO_PUBBLICARow: method(s) of FINE_PUBBLICAZIONE @31-3D89441A
    public DateField getFINE_PUBBLICAZIONEField() {
        return FINE_PUBBLICAZIONE;
    }

    public Date getFINE_PUBBLICAZIONE() {
        return FINE_PUBBLICAZIONE.getValue();
    }

    public void setFINE_PUBBLICAZIONE(Date value) {
        this.FINE_PUBBLICAZIONE.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of FINE_PUBBLICAZIONE

//AMV_DOCUMENTO_PUBBLICARow: method(s) of CRONOLOGIA @26-8D9E08CB
    public TextField getCRONOLOGIAField() {
        return CRONOLOGIA;
    }

    public String getCRONOLOGIA() {
        return CRONOLOGIA.getValue();
    }

    public void setCRONOLOGIA(String value) {
        this.CRONOLOGIA.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of CRONOLOGIA

//AMV_DOCUMENTO_PUBBLICARow: method(s) of NOTE @34-3CDD33C5
    public TextField getNOTEField() {
        return NOTE;
    }

    public String getNOTE() {
        return NOTE.getValue();
    }

    public void setNOTE(String value) {
        this.NOTE.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of NOTE

//AMV_DOCUMENTO_PUBBLICARow: method(s) of REVISIONE @23-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of REVISIONE

//AMV_DOCUMENTO_PUBBLICARow: method(s) of ID_DOCUMENTO @14-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End AMV_DOCUMENTO_PUBBLICARow: method(s) of ID_DOCUMENTO

//AMV_DOCUMENTO_PUBBLICARow: class tail @6-FCB6E20C
}
//End AMV_DOCUMENTO_PUBBLICARow: class tail

