/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    01/04/2003 PM     aggiunta funzione get_value()
			rettifica attributi assegnati alla finestra LOV
 2    22/05/2003 AO     Aggiunte funzioni per richiamo della MultiLOV
 3    10/06/2003 AO     Gestione delle opzioni di apertura PopUp per Netscape ed IExplorer
******************************************************************************/

// JScript source code


var isNN = (navigator.appName.indexOf("Netscape") != -1);
var isIE = (navigator.appName.indexOf("Microsoft") != -1);

var control = 'LovObject';
var lovWin  = 'top.lovWin'+control;

// Rev.2 array per il ritorno degli n campi 
var controlArray = new Array(1);
// Rev.2 fine

function showLOV(popup_page, popup_features, form_name, form_control)
{
    disableEvents = false;

    LovObject               = new Object();
    LovObject.control       = String("document."+form_name+"."+form_control);
    LovObject.selectedValue = "";

    // Display the LOV in a new popup window
    newWinUrl      = popup_page;
    newWinName     = "lovWin";
    newWinFeatures = "dependent=yes, titlebar=no, scrollbars=yes, center=yes, help=no, resizable=yes, status=no";
    newWinFeatures += ",width=" + self.screen.width/2 + ",height=" + self.screen.height/2;
    newWinFeatures += ",left=" + self.screen.width/4 + ",top=" + self.screen.height/4;
    // Rev.3: Gestione attributi a seconda del browser 
    if (isIE) {
       newWinFeatures += ',' + popup_features;
    }
    else
    {
       newWinFeatures = popup_features + ',' +newWinFeatures;
    }
    // Rev.3 fine
    eval(lovWin + " = window.open('" + newWinUrl + "', '" + newWinName + "', '" + newWinFeatures + "');");

    //window.document.body.style.filter="alpha(opacity=30)";
}

// Rev.2 showMultiLOV 

function showMultiLOV(popup_page, popup_features, form_name, form_control) {

/*****************************************************************************************

	DESCRIZIONE:	Inserisce in controlArray i campi indicati in form_control.
		        Apre popup_page in un altro browser e 'disabilita' il browser di form_name.

	ARGOMENTI:		Nome		 Descrizione
			        ----		 -----------
                                popup_page       Nome di popup_page (può contenere anche il percorso
						 relativo della pagina, es. "../common/Page.do").           
                                popup_features   Caratteristiche di popup_page
                                form_name        Nome form che apre popup_page
                                form_control     Nomi dei campi in cui scrivere i valori restituiti da
                                                 popup_page, separati da #. Dopo l'ultimo campo non ci
						 va il #.
						
	RITORNA:			

	MODIFICHE:		Data    Sigla   Commento
				----	-----	--------
			  07/04/2003	SC	Inserito commento.

*****************************************************************************************/

    disableEvents = false;

    var nIndex = form_control.indexOf('#'); //posizione di #
    var nIndex2 = 0;                        //posizione # successivo
    var dep_form_control;                   //nome singolo campo
    var i = 0;				    

    while (nIndex > 0 || i == 0){
        if (i == 0) {
           if (nIndex > 0 ) {
              dep_form_control = form_control.substr(0, nIndex);
           }
           else {
              dep_form_control = form_control; //form_control contiene un campo solo
           }
           nIndex2 = nIndex;
        }
        else {
           nIndex2 = form_control.indexOf('#', nIndex+1);
           if (nIndex2 > 0) {
              dep_form_control = form_control.substr(nIndex+1, nIndex2-nIndex-1);
           }
           else {
              dep_form_control = form_control.substr(nIndex+1);   //nome ultimo campo
           }
        }
        controlArray.length = i+1;		//incrementa la dimensione dell'array
        controlArray[i] = new Object();
        controlArray[i].control = String("document."+form_name+"."+dep_form_control);
        controlArray[i].selectedValue = "";
        nIndex = nIndex2;
        i++;
    }

    // Display the LOV in a new popup window
    newWinUrl      = popup_page;
    newWinName     = "lovWin";
    newWinFeatures = "dependent=yes,titlebar=no,scrollbars=yes, center: yes, help: no, resizable: yes, status: no" + popup_features;
    newWinFeatures += ",width=" + self.screen.width/2 + ",height=" + (self.screen.height)*(3/4);
    newWinFeatures += ",left=" + self.screen.width/4 + ",top=" + self.screen.height/6;
    eval(lovWin + " = window.open('" + newWinUrl + "', '" + newWinName + "', '" + newWinFeatures + "');");

    //window.document.body.style.filter="alpha(opacity=30)";   //'disabilita' form_name
}
// Rev.2 fine



function showCalendar(form_name, form_control)
{
    disableEvents = false;

    LovObject               = new Object();
    LovObject.control       = String("document."+form_name+"."+form_control);
    LovObject.selectedValue = "";

    // Display the LOV in a new popup window
    newWinUrl      = "../common/AmvCalendario.do";
    newWinName     = "lovWin";
    newWinFeatures = "dependent=yes,titlebar=no,scrollbars=no, center=yes, help=no, resizable=no, status=no";
    newWinFeatures += ",width=300,height=280";
    newWinFeatures += ",left=" + self.screen.width/4 + ",top=" + self.screen.height/4;
    eval(lovWin + " = window.open('" + newWinUrl + "', '" + newWinName + "', '" + newWinFeatures + "');");

    //window.document.body.style.filter="alpha(opacity=30)";
}

var skipFocusLov = false;
var skipCloseLov = false;

function focusLOV()
{
    if (!skipFocusLov){
      window.focus(); 
    }
    timerLOV()
}
function timerLOV()
{
    LovTimer = setTimeout('focusLOV()', 500);
}
function filterLOV()
{
    window.document.body.style.filter=null;
}

function onLoadLOV()
{
    timerLOV()
    //centerLOV();
}
function onUnLoadLOV()
{
  if (skipCloseLov==false) {
    top.opener.closeLOV();
  }
}
function onFocusLOV()
{
    skipFocusLov = true;
    skipCloseLov = true;
}
function onBlurLOV()
{
    skipFocusLov = false;
    skipCloseLov = true;
}

function returnLOV(value)
{
    disableEvents = true;

    // Assign the incoming field object to a global variable
    callField = eval(eval(control+'.control'));

    // Set the value of the field that was passed to the LOV
    callField.value = String(value).replace(/\s*$/, "");

    // Give focus back to the lov field
    callField.focus();

    filterLOV();

    // Close the LOV window
    eval(lovWin + ".close();");
}

// Rev.2 returnMultiLOV 

function returnMultiLOV(value) {
/*****************************************************************************************

	DESCRIZIONE:	Scrive nei campi memorizzati in controlArray i valori restituiti.
		        Chiude la popup_page e 'riabilita' il browser di partenza.

	ARGOMENTI:		Nome		 Descrizione
			        ----		 -----------
                                value            valori da inserire nei campi elencati in
                                                 showMultiLOV elencati nello stesso ordine e
					         sepaarati da #. Dopo l'ultimo campo non ci
						 va il #.
						
	RITORNA:			

	MODIFICHE:		Data	Sigla   Commento
				----	-----	--------
			  07/04/2003	SC	Inserito commento.

*****************************************************************************************/

    disableEvents = true;

    dep_value = String(value).replace(/\s*$/, "");
    dep_value = String(value).replace(/@+/, "\n");
    var nIndex = dep_value.indexOf('#');
    var nIndex2 = 0;
    var i = 0;

    while (nIndex > 0 || i == 0) {

       callField = eval(controlArray[i].control);
        if (i == 0) {
           if (nIndex > 0) {
              callField.value = dep_value.substr(0, nIndex);
           }
           else {
              callField.value = dep_value;       //un solo valore
           }
           nIndex2=nIndex;
        }
        else {
           nIndex2 = dep_value.indexOf('#', nIndex+1);
           if (nIndex2 != -1) {
              callField.value = dep_value.substr(nIndex+1, nIndex2-nIndex-1);
           }
           else {
              callField.value = dep_value.substr(nIndex+1);  //ultimo valore
           }
        }
        nIndex = nIndex2;        
        i++;
    }


    // Give focus back to the lov field
    callField.focus();			// da il focus all'ultimocampo di controlArray

    filterLOV();

    // Close the LOV window
    eval(lovWin + ".close();");
}
// Rev.2 fine



function closeLOV()
{
    disableEvents = true;

    filterLOV();

    // Close the LOV window
    eval(lovWin + ".close();");
}
function get_value() {
   // restituisce il valore di partenza del campo passato alla LOV
   callField = eval(eval(control+'.control'));
   return callField.value;
}

