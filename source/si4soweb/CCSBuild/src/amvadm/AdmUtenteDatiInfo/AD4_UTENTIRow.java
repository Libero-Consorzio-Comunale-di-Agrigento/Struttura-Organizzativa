//AD4_UTENTIRow: import @59-E30E135C
package amvadm.AdmUtenteDatiInfo;

import java.util.*;
import com.codecharge.db.*;
//End AD4_UTENTIRow: import

//AD4_UTENTIRow: class head @59-D8604D31
public class AD4_UTENTIRow {
//End AD4_UTENTIRow: class head

//AD4_UTENTIRow: declare fiels @59-EBCAAC41
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField SESSO = new TextField("SESSO", "SESSO");
    private TextField CODICE_FISCALE = new TextField("CODICE_FISCALE", "CODICE_FISCALE");
    private TextField DATA_NASCITA = new TextField("DATA_NASCITA", "DATA_NASCITA");
    private TextField DES_COMUNE_NAS = new TextField("DES_COMUNE_NAS", "DES_COMUNE_NAS");
    private TextField DES_PROVINCIA_NAS = new TextField("DES_PROVINCIA_NAS", "DES_PROVINCIA_NAS");
    private TextField INDIRIZZO_COMPLETO = new TextField("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO");
    private TextField INDIRIZZO_WEB = new TextField("INDIRIZZO_WEB", "INDIRIZZO_WEB");
    private TextField TELEFONO = new TextField("TELEFONO", "TELEFONO");
    private TextField FAX = new TextField("FAX", "FAX");
    private DateField DATA_PASSWORD = new DateField("DATA_PASSWORD", "DATA_PASSWORD");
    private TextField RINNOVO_PASSWORD = new TextField("RINNOVO_PASSWORD", "RINNOVO_PASSWORD");
    private DateField ULTIMO_TENTATIVO = new DateField("ULTIMO_TENTATIVO", "ULTIMO_TENTATIVO");
    private TextField STATO = new TextField("STATO", "STATO");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private DateField DATA_AGGIORNAMENTO = new DateField("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO");
//End AD4_UTENTIRow: declare fiels

//AD4_UTENTIRow: constructor @59-A3432298
    public AD4_UTENTIRow() {
    }
//End AD4_UTENTIRow: constructor

//AD4_UTENTIRow: method(s) of NOME @76-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of NOME

//AD4_UTENTIRow: method(s) of SESSO @87-A1140636
    public TextField getSESSOField() {
        return SESSO;
    }

    public String getSESSO() {
        return SESSO.getValue();
    }

    public void setSESSO(String value) {
        this.SESSO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of SESSO

//AD4_UTENTIRow: method(s) of CODICE_FISCALE @88-3FE2CCFC
    public TextField getCODICE_FISCALEField() {
        return CODICE_FISCALE;
    }

    public String getCODICE_FISCALE() {
        return CODICE_FISCALE.getValue();
    }

    public void setCODICE_FISCALE(String value) {
        this.CODICE_FISCALE.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of CODICE_FISCALE

//AD4_UTENTIRow: method(s) of DATA_NASCITA @89-2B992BC2
    public TextField getDATA_NASCITAField() {
        return DATA_NASCITA;
    }

    public String getDATA_NASCITA() {
        return DATA_NASCITA.getValue();
    }

    public void setDATA_NASCITA(String value) {
        this.DATA_NASCITA.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_NASCITA

//AD4_UTENTIRow: method(s) of DES_COMUNE_NAS @90-3656702C
    public TextField getDES_COMUNE_NASField() {
        return DES_COMUNE_NAS;
    }

    public String getDES_COMUNE_NAS() {
        return DES_COMUNE_NAS.getValue();
    }

    public void setDES_COMUNE_NAS(String value) {
        this.DES_COMUNE_NAS.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DES_COMUNE_NAS

//AD4_UTENTIRow: method(s) of DES_PROVINCIA_NAS @91-33748940
    public TextField getDES_PROVINCIA_NASField() {
        return DES_PROVINCIA_NAS;
    }

    public String getDES_PROVINCIA_NAS() {
        return DES_PROVINCIA_NAS.getValue();
    }

    public void setDES_PROVINCIA_NAS(String value) {
        this.DES_PROVINCIA_NAS.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DES_PROVINCIA_NAS

//AD4_UTENTIRow: method(s) of INDIRIZZO_COMPLETO @92-92DA0D53
    public TextField getINDIRIZZO_COMPLETOField() {
        return INDIRIZZO_COMPLETO;
    }

    public String getINDIRIZZO_COMPLETO() {
        return INDIRIZZO_COMPLETO.getValue();
    }

    public void setINDIRIZZO_COMPLETO(String value) {
        this.INDIRIZZO_COMPLETO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of INDIRIZZO_COMPLETO

//AD4_UTENTIRow: method(s) of INDIRIZZO_WEB @77-F718DE73
    public TextField getINDIRIZZO_WEBField() {
        return INDIRIZZO_WEB;
    }

    public String getINDIRIZZO_WEB() {
        return INDIRIZZO_WEB.getValue();
    }

    public void setINDIRIZZO_WEB(String value) {
        this.INDIRIZZO_WEB.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of INDIRIZZO_WEB

//AD4_UTENTIRow: method(s) of TELEFONO @78-E71ADE24
    public TextField getTELEFONOField() {
        return TELEFONO;
    }

    public String getTELEFONO() {
        return TELEFONO.getValue();
    }

    public void setTELEFONO(String value) {
        this.TELEFONO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of TELEFONO

//AD4_UTENTIRow: method(s) of FAX @79-AF87E71F
    public TextField getFAXField() {
        return FAX;
    }

    public String getFAX() {
        return FAX.getValue();
    }

    public void setFAX(String value) {
        this.FAX.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of FAX

//AD4_UTENTIRow: method(s) of DATA_PASSWORD @62-BF7CC2DA
    public DateField getDATA_PASSWORDField() {
        return DATA_PASSWORD;
    }

    public Date getDATA_PASSWORD() {
        return DATA_PASSWORD.getValue();
    }

    public void setDATA_PASSWORD(Date value) {
        this.DATA_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of DATA_PASSWORD

//AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD @84-280CE65F
    public TextField getRINNOVO_PASSWORDField() {
        return RINNOVO_PASSWORD;
    }

    public String getRINNOVO_PASSWORD() {
        return RINNOVO_PASSWORD.getValue();
    }

    public void setRINNOVO_PASSWORD(String value) {
        this.RINNOVO_PASSWORD.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of RINNOVO_PASSWORD

//AD4_UTENTIRow: method(s) of ULTIMO_TENTATIVO @80-1A87726F
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

//AD4_UTENTIRow: method(s) of STATO @81-B34568E8
    public TextField getSTATOField() {
        return STATO;
    }

    public String getSTATO() {
        return STATO.getValue();
    }

    public void setSTATO(String value) {
        this.STATO.setValue(value);
    }
//End AD4_UTENTIRow: method(s) of STATO

//AD4_UTENTIRow: method(s) of DATA_INSERIMENTO @82-7D376105
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

//AD4_UTENTIRow: method(s) of DATA_AGGIORNAMENTO @83-3B51FF06
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

//AD4_UTENTIRow: class tail @59-FCB6E20C
}
//End AD4_UTENTIRow: class tail

