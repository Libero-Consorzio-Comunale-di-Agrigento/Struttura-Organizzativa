//DefaultFileFilter class @0-1A9C668E
package com.codecharge.util.multipart;

import java.io.FileFilter;
import java.util.*;
import com.codecharge.util.*;

public class DefaultFileFilter implements FileFilter {
    private ArrayList whiteList = new ArrayList();
    private ArrayList blackList = new ArrayList();
    private boolean allAllowed = false;
    private boolean allDisallowed = false;
    
    private boolean debug = false;
    
    public DefaultFileFilter() {
    }
    
    public DefaultFileFilter(String whiteList, String blackList) {
        setWhiteList(whiteList);
        setBlackList(blackList);
    }
    
    public boolean accept(java.io.File file) {
        boolean result = false;
        if (file==null) return true;
        String fullName = file.getName();
        String fname = getFileName(fullName); 
        if (allDisallowed) return false;
        if (!allAllowed) { 
            for (int i = 0; i < whiteList.size(); i++) {
                result = match(fname, (String) whiteList.get(i));
                if (result) {
                    break;
                }
            }
        } else {
            result = true;
        }
        if (result) {
            for (int i = 0; i < blackList.size(); i++) {
                if (match(fname, (String) blackList.get(i))) {
                    result = false;
                    break;
                }
            }
        }
        return result;
    }
    
    protected String getFileName(final String origFileName) {
        int index = origFileName.indexOf('.');
        String result = null;
        if (index==-1) {
            result = origFileName;
        } else {
            result = origFileName.substring(index+1);
        }
        return result; 
    }
    
	/**
	 *@param listOfMasks
	 */
	public void setWhiteList(String listOfMasks) {
        Enumeration masks = StringUtils.split(listOfMasks);
        while (masks.hasMoreElements()) {
            String mask = (String) masks.nextElement();
            whiteList.add(mask);
            if ("*".equals(mask)) {
                allAllowed = true;
                break;
            }
        }
	}
	/**
	 *@param listOfMasks
	 *@return 
	 */
	public void setBlackList(String listOfMasks) {
        Enumeration masks = StringUtils.split(listOfMasks);
        while (masks.hasMoreElements()) {
            String mask = (String) masks.nextElement();
            blackList.add(mask);
            if ("*".equals(mask)) {
                allAllowed = false;
                allDisallowed = true;
                break;
            }
        }
	}
/*
    private ArrayList subtractBlackList() {
        ArrayList result = whiteList.clone();
        for (int i = 0; i < blackList.size(); i++ ) {
            for (int j=0; j < result.size(); j++) {
                if ( ((String) result.get(j) ).equals((String) blackList.get(i)) ) {
                    result.remove(j);
                    j--;
                }
            }
        }
        return result;
    }
*/    
    private boolean match(String strOrig, String maskOrig) {
        boolean result = true;
        String str = strOrig.toLowerCase();
        String mask = maskOrig.toLowerCase();
        int curPos = 0;
        int strLength = 0;
        int lastChar = ' ';
debugMes("str: "+str+" mask: "+mask);        
        if ( ! StringUtils.isEmpty(str) && ! StringUtils.isEmpty(mask) ) {
            if ("*".equals(mask)) {
                return result;
            }
            int maskLength = mask.length();
            strLength = str.length();
            for (int i = 0; i < maskLength; i++) {
debugMes("i: "+i+" curPos: "+curPos);                        
                char maskChar = mask.charAt(i); 
if(curPos<strLength) debugMes("maskChar: "+maskChar+" str.charAt(curPos): "+str.charAt(curPos));                
                switch (maskChar) {
                    case '*':
                        lastChar = '*';
                        i++;
                        int posAst = mask.indexOf("*",i);
                        int posQue = mask.indexOf("?",i);
                        int pos = -1;
                        if (posAst == -1) {
                            pos = posQue;
                        } else if (posQue == -1) {
                            pos = posAst;
                        } else {
                            pos = Math.min(posAst,posQue);
                        }
debugMes("pos: "+pos);                        
                        if (pos == -1) {
                            if (i==maskLength) {
                                break;
                            }
                        }
                        String token = "";
                        if (pos == -1) {
                            token = mask.substring(i);
                        } else {
                            token = mask.substring(i,pos);
                        }
debugMes("token: "+token+" i: "+i+" curPos: "+curPos);                        
                        if ("".equals(token)) {
                            if (pos==posQue) {
                                int queLength = 0;
                                int ii = -1;
                                for (ii = posQue; ii < mask.length(); ii++) {
                                    if (mask.charAt(ii)!='?')
                                        break;
                                    queLength++;    
                                }
debugMes("queLength: "+queLength);
                                if (queLength > 0) {       
                                    posAst = mask.indexOf("*",ii);
                                    posQue = mask.indexOf("?",ii);
                                    int posIi = -1;
                                    if (posAst == -1) {
                                        posIi = posQue;
                                    } else if (posQue == -1) {
                                        posIi = posAst;
                                    } else {
                                        posIi = Math.min(posAst,posQue);
                                    }
                                    if (posIi == -1) {
                                        posIi = maskLength-1;
                                    }
debugMes("posIi: "+posIi);
                                    if (pos+queLength>=maskLength) {
                                        i = maskLength;
                                        break;
                                    }
                                    token = mask.substring(pos+queLength,posIi);
debugMes("token: "+token);
                                    int newPos = str.indexOf(token,curPos+queLength);
                                    debugMes("newPos: "+newPos);
                                    if (newPos==-1) {
                                        result = false;
                                    } else {
                                        curPos = newPos;
                                        i = posIi - 1;
                                    }
                                    break;
                                }
                            } else {
                                i--;
                                curPos++;
                            }
                            break;
                        }
                        pos = str.indexOf(token, curPos);
debugMes("pos: "+pos);                        
                        if (pos == -1) {
                            result = false;
                            break;
                        }
                        curPos = pos + token.length();
                        i+=token.length()-1;
debugMes("i: "+i+" curPos: "+curPos);                        
                        break;
                    case '?':
                        lastChar = '?';
                        curPos++;
                        if (curPos > strLength) {
                            result = false;
                        }
                        break;
                    default:
                        lastChar = ' ';
                        if (curPos >= strLength) {
                            result = false;
                            break;
                        }
                        if (maskChar != str.charAt(curPos++)) {
                            result = false;
                        }
                }
                if (! result) {
                    break;
                }
            }
        }
        if (lastChar=='?' && curPos < strLength) {
            result = false;
        }
        return result;
    }
    
    private void debugMes(String message) {
        if (debug)
            System.out.println(message);
    }
    
    public static void main(String[] args) {
        DefaultFileFilter filter = new DefaultFileFilter();
        filter.debug = true;
/*
        String wList = "*fg.jpg;fgh??fg.gif";
        String bList = "*.html;*.js;*.exe;*.com";
        
        filter.setWhiteList(wList);
        filter.setBlackList(bList);
        for (int j=0; j < filter.whiteList.size(); j++) {
            System.out.println("mask_"+j+": "+filter.whiteList.get(j));
        }
        for (int j=0; j < filter.blackList.size(); j++) {
            System.out.println("mask_"+j+": "+filter.blackList.get(j));
        }
*/        

        String str = "khoda.jpeg";
        String mask = "*.???";
        System.out.println("str: "+str+" mask: "+mask+" result is "+filter.match(str,mask));
    }
    
}

//End DefaultFileFilter class

