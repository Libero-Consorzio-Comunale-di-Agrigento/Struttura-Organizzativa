function createCookie(name,value,days)
{
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	var ck = name+"="+value+expires+"; path=/";
//	if (days != -1) alert('Cookie\n' + ck + '\ncreated');
	document.cookie = ck;
}

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i<ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name)
{
	createCookie(name,"",-1);
}


/* Some extra functions. They're only here to allow me to add some
	alerts to the example */

function saveIt(name)
{
	var x = document.forms[0].cookievalue.value;
	if (!x)
		alert('Please fill in a value in the input box.');
	else
		createCookie(name,x,7);
}

function readIt(name)
{
	alert('The value of the cookie is ' + readCookie(name));
}

function eraseIt(name)
{
	eraseCookie(name);
	alert('Cookie erased');
}

function checkForCookie()
{
	for (var i=1;i<3;i++)
	{
		var x = readCookie('ppkcookie' + i);
		if (x) alert('Cookie ppkcookie' + i + '\nthat you set on a previous visit, is still active.\nIts value is ' + x);
	}
}
