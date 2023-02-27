//RequestParser class @0-C59744F1
package com.codecharge.util.multipart;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;

import com.codecharge.util.*;
import com.codecharge.Names;

public class RequestParser {
    
    final static private String URL_ENCODED_KEY = "application/x-www-form-urlencoded";
    final static private String MULTIPART_ENCODED_KEY = "multipart/form-data";
    final static private String BOUNDARY_KEY = "boundary=";
    final static private int BOUNDARY_KEY_LENGTH = BOUNDARY_KEY.length();
    
    private HttpServletRequest request;
    private String contentType;
    
    private RequestParameters httpGetParameters;
    private RequestParameters httpPostParameters;
    private HashMap httpPostFiles = new HashMap();
    
    private String encoding;
    private String defaultEncoding;
    
    public RequestParser( HttpServletRequest request ) {
        this.request = request;
        this.encoding = ((CCSLocale) SessionStorage.getInstance(request).getAttribute(Names.CCS_LOCALE_KEY)).getCharacterEncoding();
        if ( this.encoding == null ) this.encoding = "UTF-8";
        this.defaultEncoding=StringUtils.getSiteProperty("requestEncoding");
        try {
            byte[] tmp = "test".getBytes( encoding); 
        } catch (java.io.UnsupportedEncodingException e) { 
            encoding="UTF-8"; 
        }
        httpGetParameters = new RequestParameters(encoding);
        httpPostParameters = new RequestParameters(encoding);
    }
    
    public RequestParser( HttpServletRequest request, String encoding ) 
            throws java.io.UnsupportedEncodingException {
        this.request = request;
        this.defaultEncoding=StringUtils.getSiteProperty("requestEncoding");
        this.encoding=encoding;
        httpGetParameters = new RequestParameters(encoding);
        httpPostParameters = new RequestParameters(encoding);
        byte[] tmp = "test".getBytes( encoding); 
    }
    
    public RequestParameters getHttpGetParameters() {
        return httpGetParameters;
    }
    
    public RequestParameters getHttpPostParameters() {
        return httpPostParameters;
    }
    
    public Collection getPostFileNames() {
        ArrayList result = new ArrayList();
        if ( httpPostFiles != null ) {
            result.addAll(httpPostFiles.keySet());
        }
        return result;
    }
    
    public UploadedFile getPostFile( String name ) {
        if ( httpPostFiles == null || name == null ) {
            return null;
        }
        return (UploadedFile) httpPostFiles.get(name);
    }
    
    public void parse() {
        String requestContentType = request.getContentType();
        String headerContentType = request.getHeader("Content-Type");
        
        if ( requestContentType == null && headerContentType != null ) {
            contentType = headerContentType;
        } else if (requestContentType != null && headerContentType == null) {
            contentType = requestContentType;
        } else if (requestContentType != null && headerContentType != null) {
            contentType = requestContentType.length() > headerContentType.length() ? 
                    requestContentType : headerContentType;
        }
        
        this.httpGetParameters.setParameters(parseUrlEncoded(request.getQueryString()));
        convertGetToArray();
        if ( "POST".equals(request.getMethod()) ) {
            if ( contentType.indexOf(RequestParser.URL_ENCODED_KEY) > -1 ) {
                fillPostParameters();
            } else if ( contentType.indexOf(RequestParser.MULTIPART_ENCODED_KEY) > -1 ) {
                parseMultipart(request);
            }
        }
        convertPostToArray();
    }
    
    private void fillPostParameters() {
        final String EMPTY = "";
        recodeNeeded = true;
        setRequestEncoding(request, encoding);
        defaultEncoding = request.getCharacterEncoding();
        Enumeration paramNames = request.getParameterNames();
        while ( paramNames.hasMoreElements() ) {
//          String name = recode((String) paramNames.nextElement());
        String name = (String) paramNames.nextElement();
            String[] vals = httpGetParameters.getParameterValues( name );
            String[] reqVals = request.getParameterValues( name );
            // TODO: handle national character sets [request.setCharacterEncoding()]
            if ( vals == null && reqVals != null ) {
                ArrayList items = null;
                int k = 0;
                for ( int i = 0; i < reqVals.length; i++ ) {
                    if ( ( items = (ArrayList) httpPostParameters.parameters.get( name )) == null ) {
                        items = new ArrayList();
                    }
                    items.add(recode(reqVals[i]));
                    httpPostParameters.parameters.put( name, items );
                }
            } else if ( vals != null && reqVals != null && vals.length < reqVals.length ) {
                ArrayList items = null;
                int k = 0;
                for ( int i = 0; i < reqVals.length; i++ ) {
                    boolean found = false;
                    String reqVal = recode(reqVals[i]);
                    for ( int j = k; j < vals.length; j++ ) {
                        if ( reqVal.equals( vals[j] ) ) {
                            found = true;
                            vals[j] = null;
                            break;
                        }
                    }
                    if ( ! found ) {
                        if ( ( items = (ArrayList) httpPostParameters.parameters.get( name )) == null ) {
                            items = new ArrayList();
                        }
                        items.add(reqVal);
                        httpPostParameters.parameters.put( name, items );
                    }
                }
            }
        }
    }
    private boolean recodeNeeded = true;
    /** Use default encoding as a base for other encodings.
        Useful in cases we do not know or cannot change default encoding.
        Caution: doesn't work with multibyte encodings (such as big5). */
    private String recode(String value) {
        if (!recodeNeeded || encoding.equals(defaultEncoding)) return value;
        String result = "";
        try {
            result = new String( value.getBytes(defaultEncoding), encoding);
        } catch ( java.io.UnsupportedEncodingException e ) {
            result = value;
        }
        return result;
    }
    /** Try to set request Encoding (Servlet 2.3 feature), but use recode method if Servlet 2.3 is not available. */
    private void setRequestEncoding(HttpServletRequest request, String encoding) {
        try {
            java.lang.reflect.Method m = request.getClass().getMethod("setCharacterEncoding", new Class[] {String.class});
            m.invoke(request, new String[] {encoding});
            recodeNeeded = false;
        } catch (NoSuchMethodException noMethodE) {
        } catch (IllegalAccessException accessE) {
        } catch (IllegalArgumentException argumentE) {
        } catch (java.lang.reflect.InvocationTargetException invocationE) {
        }
    }

    private void convertGetToArray() {
        Enumeration params = this.httpGetParameters.getParameterNames();
        while (params.hasMoreElements()) {
            String name = (String) params.nextElement();
            ArrayList avalues = (ArrayList) this.httpGetParameters.parameters.get(name);
            String[] values = new String[avalues.size()];
            values = (String[]) avalues.toArray(values);
            this.httpGetParameters.parameters.put(name, values);
        }
    }
    
    private void convertPostToArray() {
        Enumeration params = this.httpPostParameters.getParameterNames();
        while (params.hasMoreElements()) {
            String name = (String) params.nextElement();
            ArrayList avalues = (ArrayList) this.httpPostParameters.parameters.get(name);
            if (avalues != null) {
                String[] values = new String[avalues.size()];
                values = (String[]) avalues.toArray(values);
                this.httpPostParameters.parameters.put(name, values);
            } else {
                this.httpPostParameters.parameters.remove(name);
            }
        }
    }

    private Hashtable parseUrlEncoded(String urlEncodedParameters) {
        Hashtable parameters = null;
        if (urlEncodedParameters != null && urlEncodedParameters.length() > 0) {
            parameters = new Hashtable();
            final String EMPTY = "";
            
            StringTokenizer st = new StringTokenizer( urlEncodedParameters, "&" );
            while ( st.hasMoreTokens() ) {
              String token = st.nextToken();
              int pos = token.indexOf( "=" );
              String value = EMPTY;
              if ( pos > -1 ) {
                value = token.substring( pos + 1 );
                try {
                  value = StringUtils.decodeURL(value, encoding);
                } catch (java.io.UnsupportedEncodingException e) {}
                token = token.substring( 0, pos );
                try {
                  token = StringUtils.decodeURL(token, encoding);
                } catch (java.io.UnsupportedEncodingException e) {}
              }
              ArrayList values = null;
              if ( ( values = (ArrayList) parameters.get( token )) == null ) {
                values = new ArrayList();
              }
              values.add( value );
              parameters.put( token, values );
            } // End of while st.hasMoreTokens()
        }
        return parameters;
    }   
    
    private void parseMultipart(HttpServletRequest request) {
        HashMap parameters = null;
        HashMap files = null;
        String boundary = null;
        int boundaryOffset = -1;
        if ( (boundaryOffset = contentType.indexOf(RequestParser.BOUNDARY_KEY)) > -1 ) {
            boundary = contentType.substring(boundaryOffset+RequestParser.BOUNDARY_KEY_LENGTH);
        }
        if ( boundary != null && boundary.length() > 0 ) {
            boundary = "--" + boundary;
            try {
                ServletInputStream in = request.getInputStream();
                String line = null;
                while ((line = readLine(in)) != null ) {
                    if (line.startsWith(boundary)) {
                        while(readPart(in, boundary));
                    }
                }
                                        
                //in.close();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }
    
    private boolean readPart(ServletInputStream in, String boundary) {
        ArrayList headers = new ArrayList();
        String line = readLine(in);
        if (line == null || line.equals(boundary+"--")) {
            return false;
        }
        boolean result = true;
        
        StringBuffer sb = new StringBuffer();
        while (line != null && ! "".equals(line)) {
            if ( !(line.startsWith(" ") || line.startsWith("\t")) && sb.length() > 0 ) {
                headers.add(sb.toString());
                sb.setLength(0);
            }
            sb.append(line);
            line = readLine(in);
        }
        headers.add(sb.toString());
        
        String name = null;
        String fileName = null;
        String originalName = null;
        String partContentType = "text/plain";
        
        for ( Iterator it = headers.iterator(); it.hasNext(); ) {
            line = (String) it.next();
            if (line.toLowerCase().startsWith("content-disposition:")) {
                String[] info = extractDispositionInfo(line);
                name = info[0];
                fileName = info[1];
                originalName = info[2];
            } else if (line.toLowerCase().startsWith("content-type:")) {
                partContentType = extractContentType(line);
            }
        }
        if ( fileName == null ) {
            byte[] avalue = getPartContent(in, boundary);
            String value = "";
            if (avalue != null) {
                try {
                    value = new String(avalue, encoding);
                } catch (UnsupportedEncodingException uee) {
                    
                }
            }
            ArrayList values = null;
            if ( ( values = (ArrayList) httpPostParameters.parameters.get(name) ) == null ) {
                values = new ArrayList();
            }
            values.add( value );
            httpPostParameters.parameters.put( name, values );
        } else {
            if ( ! "".equals(fileName)) {
                byte[] content = null;
                content = getPartContent(in, boundary);
                UploadedFile ufile = new UploadedFile(fileName, content);
                ufile.setOriginalName(originalName);
                httpPostFiles.put(name, ufile);
                
            } else {
                readLine(in);
            }
            ArrayList values = null;
            if ( ( values = (ArrayList) httpPostParameters.parameters.get(name) ) == null ) {
                values = new ArrayList();
            }
            values.add( fileName );
            httpPostParameters.parameters.put( name, values );
        }
        return result;
    } 
    
    private String readLine(ServletInputStream in) {
        StringBuffer sb = new StringBuffer();
        byte[] buff = new byte[1024];
        int length = -1;
        do {
            try {
                length = in.readLine(buff,0,buff.length);
            } catch (IOException ioe) {
                ioe.printStackTrace();
                length = -1;
            }
            if ( length > -1 ) {
                try {
                    sb.append(new String(buff,0, length, encoding)); 
                } catch (UnsupportedEncodingException uee) {
                    /* TODO: handle error */
                    System.out.println(uee);
                }
            }
        } while ( length == buff.length );
        if ( sb.length() == 0 ) {
            return null;
        }
        
        length = sb.length();
        if ( length > 1 ) {
            if (sb.charAt(length-2) == '\r') {
                sb.setLength(length-2);
            } else if (sb.charAt(length-1) == '\n') {
                sb.setLength(length-1);
            }
        }
        return sb.toString();
    }
    
    private String[] extractDispositionInfo(String dispositionLine) {
        String[] info = new String[3];
        String line = dispositionLine.toLowerCase();
        
        if ( ! line.startsWith("content-disposition:") ) {
            // ERROR !!!
            return info;
        }
        int position = line.indexOf("form-data");
        if ( position == -1 ) {
            //ERROR
            return info;
        }
        int semicolon = line.indexOf(";", position);
        position = line.indexOf("name=\"");
        int closeQuot = line.indexOf("\"; ", position);
        if ( closeQuot == -1 ) {
            closeQuot = line.lastIndexOf("\"");
        }
        info[0] = dispositionLine.substring(position+6, closeQuot);
        position = line.indexOf("filename=\"", closeQuot);
        int end = line.lastIndexOf("\"");
        
        if ( position > -1 ) {
            info[2] = dispositionLine.substring(position+10, end);
            position = Math.max(info[2].lastIndexOf("/", end), info[2].lastIndexOf("\\", end));
            if ( position > -1 ) {
                info[1] = info[2].substring(position+1);
            } else {
                info[1] = info[2];
            }
        }
        return info;
    }
    
    private String extractContentType(String contentTypeLine) {
        String result = null;
        String line = contentTypeLine.toLowerCase();
        if ( ! line.startsWith("content-type:") ) {
            // ERROR !!!
        }
        int position = line.indexOf(";");
        if ( position > -1 ) {
            result = contentTypeLine.substring(13,position).trim();
        } else {
            result = contentTypeLine.substring(13).trim();
        }   
        return result;
    }
    
    private byte[] getPartContent(ServletInputStream in, String boundary) {
        byte[] content = null;
        final int bufferLength = 64*1024;
        byte[] buffer = new byte[bufferLength];
        ArrayList buffers = new ArrayList();
        ArrayList sizes = new ArrayList();
        boolean eof = false;
        int boundaryLength = boundary.length();
        int maxRead = bufferLength - boundaryLength - 2;// -2 is for \r\n
        
        int count = 0;
        int total = 0;
        int read = 0;
        try {
            while ( ! eof ) {
                read=0;
                while (count < maxRead) {
                    // read a line
                    read = ((ServletInputStream)in).readLine(buffer, count, maxRead - count);
                    // check for eof and boundary
                    if (read == -1) {
                        throw new IOException("unexpected end of part");
                    } else {
                        
                        if (read >= boundaryLength) {
                            eof = true;
                            for (int i=0; i < boundaryLength; i++) {
                                if (boundary.charAt(i) != buffer[count + i]) {
                                    // Not the boundary!
                                    eof = false;
                                    break;
                                }
                            }
                            if (eof) {
                                break;
                            }
                        }
                    }
                  // success
                  count += read;
                  total += read;
                } // end while (count < maxRead)
                buffers.add(buffer);
                sizes.add(new Integer(count));
                if (! eof) {
                    buffer = new byte[64*1024];
                    count = 0;
                }
            } // end while ( ! eof )
        } catch (IOException ioe) {
            return null;
        }
        total -= 2;
        count -= 2;
        if (total > 0) {        
            content = new byte[total];
            if (total < maxRead) {
                System.arraycopy(buffer,0,content,0,total);
            } else {
                int cnt = 0;                    
                for (int i = 0; i < buffers.size(); i++) {
                    buffer = (byte[]) buffers.get(i);
                    int size = ((Integer) sizes.get(i)).intValue();
                    if ( i == (buffers.size() - 1)) {
                        System.arraycopy(buffer,0,content,cnt,count);
                        cnt += count;
                    } else {
                        System.arraycopy(buffer,0,content,cnt,maxRead);
                        cnt += maxRead;
                    }
                }
            }
        }
        return content;
    }

}

//End RequestParser class

