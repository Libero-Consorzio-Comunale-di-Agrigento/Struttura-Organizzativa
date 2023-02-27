//StringUtils head @0-DF5E77D0
package com.codecharge.util;

import com.codecharge.Names;
import java.util.*;
import java.io.*;
import javax.servlet.http.Cookie;

//End StringUtils head

//StringUtils head @0-81B61AD0
public class StringUtils {

    static BitSet dontNeedEncoding;
    static {
      dontNeedEncoding = new BitSet(256);
      int i;
      for (i = 'a'; i <= 'z'; i++) {
          dontNeedEncoding.set(i);
      }
      for (i = 'A'; i <= 'Z'; i++) {
          dontNeedEncoding.set(i);
      }
      for (i = '0'; i <= '9'; i++) {
          dontNeedEncoding.set(i);
      }
      dontNeedEncoding.set(' '); /* encoding a space to a + is done
                                  * in the encode() method */
      dontNeedEncoding.set('-');
      dontNeedEncoding.set('_');
      dontNeedEncoding.set('.');
      dontNeedEncoding.set('*');
    }
    static public String toURL(String strValue) {
        if ( isEmpty(strValue) ) return "";
        return java.net.URLEncoder.encode(strValue);
    }

    static public String toHtml(String value) {
        /* TODO: support i18l */
        if ( isEmpty(value) ) return "";
        value = replace(value, "&", "&amp;");
        value = replace(value, "<", "&lt;");
        value = replace(value, ">", "&gt;");
        value = replace(value, "\"", "&" + "quot;");
        return value;
    }

    /**
     Verify wether the string is empty
     @param str String to test
     @return true or false
    **/
    static public String replace( String str, String pattern, 
            String replace) {
        if (replace == null) {
            replace = "";
        }
        int s = 0, e = 0;
        StringBuffer result = new StringBuffer((int) str.length()*2);
        while ((e = str.indexOf(pattern, s)) >= 0) {
            result.append(str.substring(s, e));
            result.append(replace);
            s = e + pattern.length();
        }
        result.append(str.substring(s));
        return result.toString();
    }

    /**
     Verify wether the string is empty
     @param str String to test
     @return true or false
    **/
    public static boolean isEmpty(String str) {
        if (str == null) return true;
        str = str.trim();
        if ( str.length() == 0 ) return true;
        else return false;
    }
    
    /**
     Verify wether the string is empty
     @param str StringBuffer to test
     @return true or false
    **/
    public static boolean isEmpty(StringBuffer str) {
        if (str == null ) return true;
        String str1 = str.toString().trim();
        if ( str1.length() == 0 ) return true;
        else return false;
    }
    
    public static String getCookie( String cookieName, Cookie[] cookies ) {
        String cookieValue = "";
        if ( isEmpty( cookieName ) || cookies == null ) return cookieValue;
        for ( int i = 0; i < cookies.length; i++ ) {
            if ( cookieName.equals( cookies[i].getName() ) ) {
                cookieValue = cookies[i].getValue();
            }
        }
        return cookieValue;
    }

    /**
     Returns property of site by name
     @param propertyName name of requested property
     @return property's value or null if property is not found
    **/
    public static String getSiteProperty( String propertyName ) {
        return getSiteProperty( propertyName, null );
    }

    /**
     Returns property of site by name
     @param propertyName name of requested property
     @param defaultValue value
     @return property's value or defaultValue if property is not found or propertyName is empty or null
    **/
    public static String getSiteProperty( String propertyName, String defaultValue ) {
        String property = defaultValue;
        if ( isEmpty( propertyName ) ) {
            return defaultValue;
        }
        Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute( Names.SITE_PROPERTIES_KEY );
        if ( siteProps != null ) {
            String value = siteProps.getProperty( propertyName );
            if ( value != null ) {
                property = value;
            }
        }
        return property;
    }

    public static Enumeration splitLOV( String list ) throws IllegalArgumentException {
        return splitLOV( list, ';', '\\' );
    }

    public static Enumeration splitLOV( String list, char delimiter, char escapeChar ) throws IllegalArgumentException {
        Vector elms = new Vector();
        if ( list == null || list.length() == 0 ) {
            return elms.elements();
        }
        if ( delimiter == escapeChar ) {
            throw new IllegalArgumentException( "StringUtils.split: the delimiter cannot be equal to escapeChar" );
        }

        int posEscape = 0;
        int posDelimiter = 0;
        int prevPos = 0;
        double countToken = 0;
        String copy = new String(list);
        int listLength = list.length();
        String token = null;
        boolean isDelimiter = true;
        posDelimiter = copy.indexOf( delimiter );
        posEscape = copy.indexOf( escapeChar );
        while ( posDelimiter != -1 ) {
            isDelimiter = true;
            if ( posEscape > -1 && posDelimiter > posEscape ) {
                posDelimiter = posEscape + 1;
                isDelimiter = false;
            }
            if ( isDelimiter ) {
                if ( prevPos == 0 && posDelimiter == 0 ) {
                    token = "";
                } else {
                    token = copy.substring( prevPos, posDelimiter );
                }
                elms.add( removeEscapeChar( token, escapeChar ) );
                countToken++;
                prevPos = posDelimiter + 1;
            }
            if ( posDelimiter <= listLength ) {
                posEscape = copy.indexOf( escapeChar, posDelimiter + 1 );
                posDelimiter = copy.indexOf( delimiter, posDelimiter + 1 );
            } else {
                posDelimiter = -1;
            }
        } // end of while
        elms.add( removeEscapeChar( copy.substring( prevPos ), escapeChar ) );
        countToken++;
        double result = countToken/2.0;
        if ( (int) result != result ) {
            throw new IllegalArgumentException( "StringUtils.split: number of tokens in the list cannot be odd" );
        }
        return elms.elements();
    }

    public static Enumeration split( String list ) throws IllegalArgumentException {
        return split( list, ';', '\\' );
    }

    public static Enumeration split( String list, char delimiter ) throws IllegalArgumentException {
        return split( list, delimiter, '\\' );
    }

    public static Enumeration split( String list, char delimiter, char escapeChar ) throws IllegalArgumentException {
        Vector elms = new Vector();
        if ( list == null || list.length() == 0 ) {
            return elms.elements();
        }
        if ( delimiter == escapeChar ) {
            throw new IllegalArgumentException( "StringUtils.split: the delimiter cannot be equal to escapeChar" );
        }

        int posEscape = 0;
        int posDelimiter = 0;
        int prevPos = 0;
        double countToken = 0;
        String copy = new String(list);
        int listLength = list.length();
        String token = null;
        boolean isDelimiter = true;
        posDelimiter = copy.indexOf( delimiter );
        posEscape = copy.indexOf( escapeChar );
        while ( posDelimiter != -1 ) {
            isDelimiter = true;
            if ( posEscape > -1 && posDelimiter > posEscape ) {
                posDelimiter = posEscape + 1;
                isDelimiter = false;
            }
            if ( isDelimiter ) {
                if ( prevPos == 0 && posDelimiter == 0 ) {
                    token = "";
                } else {
                    token = copy.substring( prevPos, posDelimiter );
                }
                elms.add( removeEscapeChar( token, escapeChar ) );
                countToken++;
                prevPos = posDelimiter + 1;
            }
            if ( posDelimiter <= listLength ) {
                posEscape = copy.indexOf( escapeChar, posDelimiter + 1 );
                posDelimiter = copy.indexOf( delimiter, posDelimiter + 1 );
            } else {
                posDelimiter = -1;
            }
        } // end of while
        elms.add( removeEscapeChar( copy.substring( prevPos ), escapeChar ) );
        countToken++;
        double result = countToken/2.0;
        return elms.elements();
    }

    public static List splitToList( String list, char delimiter, char escapeChar ) throws IllegalArgumentException {
        ArrayList elms = new ArrayList();
        if ( list == null || list.length() == 0 ) {
            return elms;
        }
        if ( delimiter == escapeChar ) {
            throw new IllegalArgumentException( "StringUtils.split: the delimiter cannot be equal to escapeChar" );
        }

        int posEscape = 0;
        int posDelimiter = 0;
        int prevPos = 0;
        double countToken = 0;
        String copy = new String(list);
        int listLength = list.length();
        String token = null;
        boolean isDelimiter = true;
        posDelimiter = copy.indexOf( delimiter );
        posEscape = copy.indexOf( escapeChar );
        while ( posDelimiter != -1 ) {
            isDelimiter = true;
            if ( posEscape > -1 && posDelimiter > posEscape ) {
                posDelimiter = posEscape + 1;
                isDelimiter = false;
            }
            if ( isDelimiter ) {
                if ( prevPos == 0 && posDelimiter == 0 ) {
                    token = "";
                } else {
                    token = copy.substring( prevPos, posDelimiter );
                }
                elms.add( removeEscapeChar( token, escapeChar ) );
                countToken++;
                prevPos = posDelimiter + 1;
            }
            if ( posDelimiter <= listLength ) {
                posEscape = copy.indexOf( escapeChar, posDelimiter + 1 );
                posDelimiter = copy.indexOf( delimiter, posDelimiter + 1 );
            } else {
                posDelimiter = -1;
            }
        } // end of while
        elms.add( removeEscapeChar( copy.substring( prevPos ), escapeChar ) );
        return elms;
    }

    public static String escape(String value) {
        if (StringUtils.isEmpty(value)) return "";        
        String result = StringUtils.replace(value,"\\","\\\\");
        return StringUtils.replace(result,";","\\;");
    }

    private static String removeEscapeChar( String token, char escapeChar ) {
        StringBuffer sb = new StringBuffer( token );
        int posToken = -1;
        int posSb = -1;
        int delCount = 0;
        while ( ( posToken = token.indexOf( escapeChar, posToken + 1 ) ) != -1 ) {
            sb.deleteCharAt( posToken - delCount );
            posToken++; // skip next simbol
            delCount++;
        }
        return sb.toString();
    }
    

//End StringUtils head

//StringUtils: getAllEntriesPositions @0-05C1C1A6
    public static int[] getAllEntriesPositions(String str, String pattern) {
        if (isEmpty(str) || isEmpty(pattern)) return null;
        ArrayList positions = new ArrayList();
        int pos = str.indexOf(pattern);
        while (pos > -1) {
            positions.add(new Integer(pos));
            pos = str.indexOf(pattern, pos+1);
        }
        int[] result = new int[positions.size()];
        for (int i = 0; i < positions.size(); i++ ) {
            result[i] = ((Integer) positions.get(i)).intValue();
        }
        return result;
    }

//End StringUtils: getAllEntriesPositions

//StringUtils: encodeURL @0-C0E41429
  public static String encodeURL(String s, String enc) throws UnsupportedEncodingException {
    int caseDiff = ('a' - 'A');
    boolean needToChange = false;
    boolean wroteUnencodedChar = false; 
    int maxBytesPerChar = 10; // rather arbitrary limit, but safe for now
        StringBuffer out = new StringBuffer(s.length());
    ByteArrayOutputStream buf = new ByteArrayOutputStream(maxBytesPerChar);

    BufferedWriter writer = 
        new BufferedWriter(new OutputStreamWriter(buf, enc));

    for (int i = 0; i < s.length(); i++) {
        int c = (int) s.charAt(i);
        //System.out.println("Examining character: " + c);
        if (dontNeedEncoding.get(c)) {
        if (c == ' ') {
            c = '+';
            needToChange = true;
        }
        //System.out.println("Storing: " + c);
        out.append((char)c);
        wroteUnencodedChar = true;
        } else {
        // convert to external encoding before hex conversion
        try {
            if (wroteUnencodedChar) { // Fix for 4407610
                writer = new BufferedWriter(new OutputStreamWriter(buf, enc));
            wroteUnencodedChar = false;
            }
            writer.write(c);
            /*
             * If this character represents the start of a Unicode
             * surrogate pair, then pass in two characters. It's not
             * clear what should be done if a bytes reserved in the 
             * surrogate pairs range occurs outside of a legal
             * surrogate pair. For now, just treat it as if it were 
             * any other character.
             */
            if (c >= 0xD800 && c <= 0xDBFF) {
            /*
              System.out.println(Integer.toHexString(c) 
              + " is high surrogate");
            */
            if ( (i+1) < s.length()) {
                int d = (int) s.charAt(i+1);
                /*
                  System.out.println("\tExamining " 
                  + Integer.toHexString(d));
                */
                if (d >= 0xDC00 && d <= 0xDFFF) {
                /*
                  System.out.println("\t" 
                  + Integer.toHexString(d) 
                  + " is low surrogate");
                */
                writer.write(d);
                i++;
                }
            }
            }
            writer.flush();
        } catch(IOException e) {
            buf.reset();
            continue;
        }
        byte[] ba = buf.toByteArray();
        for (int j = 0; j < ba.length; j++) {
            out.append('%');
            char ch = Character.forDigit((ba[j] >> 4) & 0xF, 16);
            // converting to use uppercase letter as part of
            // the hex value if ch is a letter.
            if (Character.isLetter(ch)) {
            ch -= caseDiff;
            }
            out.append(ch);
            ch = Character.forDigit(ba[j] & 0xF, 16);
            if (Character.isLetter(ch)) {
            ch -= caseDiff;
            }
            out.append(ch);
        }
        buf.reset();
        needToChange = true;
        }
    }

    return (needToChange? out.toString() : s);
  }

//End StringUtils: encodeURL

//StringUtils: decodeURL @0-0D043CBA
  public static String decodeURL(String s, String enc) throws UnsupportedEncodingException{
    
    boolean needToChange = false;
    StringBuffer sb = new StringBuffer();
    int numChars = s.length();
    int i = 0;

    if (enc.length() == 0) {
        throw new UnsupportedEncodingException ("URLDecoder: empty string enc parameter");
    }

    while (i < numChars) {
            char c = s.charAt(i);
            switch (c) {
        case '+':
        sb.append(' ');
        i++;
        needToChange = true;
        break;
        case '%':
        /*
         * Starting with this instance of %, process all
         * consecutive substrings of the form %xy. Each
         * substring %xy will yield a byte. Convert all
         * consecutive  bytes obtained this way to whatever
         * character(s) they represent in the provided
         * encoding.
         */

        try {

            // (numChars-i)/3 is an upper bound for the number
            // of remaining bytes
            byte[] bytes = new byte[(numChars-i)/3];
            int pos = 0;
            
            while ( ((i+2) < numChars) && 
                (c=='%')) {
            bytes[pos++] = 
                (byte)Integer.parseInt(s.substring(i+1,i+3),16);
            i+= 3;
            if (i < numChars)
                c = s.charAt(i);
            }

            // A trailing, incomplete byte encoding such as
            // "%x" will cause an exception to be thrown

            if ((i < numChars) && (c=='%'))
            throw new IllegalArgumentException(
                 "URLDecoder: Incomplete trailing escape (%) pattern");
            
            sb.append(new String(bytes, 0, pos, enc));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "URLDecoder: Illegal hex characters in escape (%) pattern - " 
            + e.getMessage());
        }
        needToChange = true;
        break;
        default: 
        sb.append(c); 
        i++;
        break; 
            }
        }

        return (needToChange? sb.toString() : s);
    }

//End StringUtils: decodeURL

//StringUtils tail @0-FCB6E20C
}
//End StringUtils tail

