//AD4_UTENTIRow: import @6-D0DEC528
package amvadm.AdmUtenteAccessi;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @6-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @6-F2860CFE
    private TextField NOMINATIVO = new TextField("NOMINATIVO", "NOMINATIVO");
    private TextField UTENTE = new TextField("UTENTE", "UTENTE");
    private TextField DSP_ID_UTENTE = new TextField("DSP_ID_UTENTE", "DSP_ID_UTENTE");
    private DateField ULTIMO_TENTATIVO = new DateField("ULTIMO_TENTATIVO", "ULTIMO_TENTATIVO");
    private TextField DSP_NUMERO_TENTATIVI = new TextField("DSP_NUMERO_TENTATIVI", "DSP_NUMERO_TENTATIVI");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
    private TextField UTENTE_AGGIORNAMENTO = new TextField("UTENTE_AGGIORNAMENTO", "UTENTE_AGGIORNAMENTO");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @6-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOMINATIVO @8-3BDE962A
    public TextField getNOMINATIVOField() {
        return NOMINATIVO;
    }

    public String getNOMINATIVO() {
        return NOMINATIVO.getValue();
    }

    public void setNOMINATIVO(String value) {
        this.NOMINATIVO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOMINATIVO

//AD4_UTENTIRow: method(s) of UTENTE @9-95517C36
    public TextField getUTENTEField() {
        return UTENTE;
    }

    public String getUTENTE() {
        return UTENTE.getValue();
    }

    public void setUTENTE(String value) {
        this.UTENTE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of UTENTE

//AD4_UTENTIRow: method(s) of DSP_ID_UTENTE @37-EA1803C2
    public TextField getDSP_ID_UTENTEField() {
        return DSP_ID_UTENTE;
    }

    public String getDSP_ID_UTENTE() {
        return DSP_ID_UTENTE.getValue();
    }

    public void setDSP_ID_UTENTE(String value) {
        this.DSP_ID_UTENTE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DSP_ID_UTENTE

//AD4_UTENTIRow: method(s) of ULTIMO_TENTATIVO @16-1A87726F
    public DateField getULTIMO_TENTATIVOField() {
        return ULTIMO_TENTATIVO;
    }

    public Date getULTIMO_TENTATIVO() {
        return ULTIMO_TENTATIVO.getValue();
    }

    public void setULTIMO_TENTATIVO(Date value) {
        this.ULTIMO_TENTATIVO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of ULTIMO_TENTATIVO

//AD4_UTENTIRow: method(s) of DSP_NUMERO_TENTATIVI @36-CC3E83A6
    public TextField getDSP_NUMERO_TENTATIVIField() {
        return DSP_NUMERO_TENTATIVI;
    }

    public String getDSP_NUMERO_TENTATIVI() {
        return DSP_NUMERO_TENTATIVI.getValue();
    }

    public void setDSP_NUMERO_TENTATIVI(String value) {
        this.DSP_NUMERO_TENTATIVI.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DSP_NUMERO_TENTATIVI

//AD4_UTENTIRow: method(s) of DATA_INSERIMENTO @38-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_INSERIMENTO

//AD4_UTENTIRow: method(s) of DATA_AGGIORNAMENTO @39-3B51FF06
    public DateField getDATA_AGGIORNAMENTOField() {
        return DATA_AGGIORNAMENTO;
    }

    public Date getDATA_AGGIORNAMENTO() {
        return DATA_AGGIORNAMENTO.getValue();
    }

    public void setDATA_AGGIORNAMENTO(Date value) {
        this.DATA_AGGIORNAMENTO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_AGGIORNAMENTO

//AD4_UTENTIRow: method(s) of UTENTE_AGGIORNAMENTO @40-87CA4B9A
    public TextField getUTENTE_AGGIORNAMENTOField() {
        return UTENTE_AGGIORNAMENTO;
    }

    public String getUTENTE_AGGIORNAMENTO() {
        return UTENTE_AGGIORNAMENTO.getValue();
    }

    public void setUTENTE_AGGIORNAMENTO(String value) {
        this.UTENTE_AGGIORNAMENTO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of UTENTE_AGGIORNAMENTO

//AD4_UTENTIRow: class tail @6-FCB6E20C
}
//End AD4_UTENTIRow: class tail

