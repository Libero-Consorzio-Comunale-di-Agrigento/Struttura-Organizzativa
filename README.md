# Struttura-Organizzativa
SO4 - Struttura organizzativa
 
## Descrizione
Applicativo per la gestione di componenti, unità e ruoli di una struttura organizzativa.

## Struttura del Repository

Il repository è suddiviso nelle seguente cartelle:
- __source__ contiene il codice sorgente e le risorse statiche incluse nella webapp.
- __scriptDB__ contiene gli script PL/SQL per la creazione della struttura dello schema database.

## Prerequisiti e dipendenze

### Prerequisiti
- Java JDK versione 5 o superiore
- Database Oracle versione 10 o superiore
- Apache Tomcat 7.0 dalla minor 47 alla 109

### Dipendenze
- Apache ANT versione 1.5 o superiore per la compilazione dei sorgenti
- Libreria _finmatica-jfcccs.jar_ di Finmatica che contiene utility varie
- Libreria _ojdbc.jar_ driver oracle per Java di Oracle

## Istruzioni per l’installazione:

- Lanciare gli script della cartella _scriptDB/Schema_ per generare lo schema
- Lanciare gli script della cartella _scriptDB/Data_ per inserire i dati basilari
- Lanciare il comando _ant.bat -buildfile "PATH\CCSBuild\build.xml" -logfile "PATH\CCSBuild\build.log"_  per generare la webapp _si4soweb_ e copiare i file nel contesto di tomcat.

## Stato del progetto 
Stabile

## Amministrazione committente
Libero Consorzio Comunale di Agrigento

## Incaricati del mantenimento del progetto open source
Finmatica S.p.A. 
Via della Liberazione, 15
40128 Bologna

## Indirizzo e-mail a cui inviare segnalazioni di sicurezza 
sicurezza@ads.it