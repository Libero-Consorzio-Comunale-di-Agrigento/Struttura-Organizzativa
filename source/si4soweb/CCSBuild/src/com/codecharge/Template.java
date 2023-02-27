//Template class @0-12D21676
package com.codecharge;

import java.util.*;
import com.codecharge.util.*;
import com.codecharge.components.*;

public class Template {

  final String BEGIN_OPEN = "<!-- BEGIN ";
  final String BEGIN_CLOSE = " -->";
  final int BEGIN_OPEN_LENGTH = 11;
  final int BEGIN_CLOSE_LENGTH = 4;

  final String END_OPEN = "<!-- END ";
  final String END_CLOSE = " -->";
  final int END_OPEN_LENGTH = 8;
  final int END_CLOSE_LENGTH = 4;

  final static public int BLOCK = 0;
  final static public int VARIABLE = 1;

  final static public int IF_DOESNT_EXIST_DO_NOTHING = 1;
  final static public int IF_DOESNT_EXIST_IS_ERROR = 0;

  private CCLogger logger;
  private final int ARRAY_PATH_DEPTH = 30;
  private String[] pathList = new String[ARRAY_PATH_DEPTH];
  private int pathLength = 0;
  private String pathTo = null;
  private Page page;
  private boolean useLocalizatedTemplate = false;

  interface Item {
    final int VARIABLE = 0;
    final int BEGIN_BLOCK = 1;
    final int END_BLOCK = 2;
    final int TEXT = 3;

    final boolean VISIBLE = true;
    final boolean INVISIBLE = false;
  }

  class TemplateItem {
    String path;
    int type;
    boolean visible;
    boolean parsed;
    StringBuffer body = new StringBuffer();

    public TemplateItem ( String path, int type, boolean visible, String body ) {
      this.path = path;
      this.type = type;
      this.visible = visible;
      this.body.append(body);
    }

    public String toString() {
      return "TemplateItem\n\tpath     = "+path+"\n\ttype    = "+type+"\n\tvisible = "+visible+"\n\tbody    = "+body.toString()+"\n==============\n";
    }
  }

  class Bracket {
    String name;
    int begin;
    int end;

    public Bracket ( String name, int begin, int end ) {
      this.name  = name;
      this.begin = begin;
      this.end   = end;
    }

    public String toString() {
      return "Bracket\n\tname  = "+name+"\n\tbegin = "+begin+"\n\tend   = "+end+"\n==============\n";
    }
  }

  Hashtable indexTree = new Hashtable();
  TemplateItem[] tree;

  javax.servlet.ServletContext application;

  public Template ( javax.servlet.ServletContext app ) {
    this();
    this.application = app;
    String useLT = StringUtils.getSiteProperty("useLocalizatedTemplate", "false");
    if (! StringUtils.isEmpty(useLT)) {
        this.useLocalizatedTemplate = new Boolean(useLT).booleanValue();
    }
  }

  public Template () {
    logger = CCLogger.getInstance();
    pathLength = 0;
    pathList[pathLength++] = "main";
    getPath();
  }

  public boolean isUseLocalizatedTemplate() {
      return this.useLocalizatedTemplate;
  }

  public Page getPage() {
    return this.page;
  }

  public void setPage( Page page ) {
    this.page = page;
  }

  public void loadTemplate( String pathFile, String block, boolean useCache ) {
    java.io.FileInputStream fis = null;
    try {
      fis = new java.io.FileInputStream ( pathFile );
    }
    catch (java.io.FileNotFoundException e) {
      logger.error( "Template.loadTemplate failed. File " + pathFile + " not found." );
    }
    catch ( Exception e ) {
      logger.error( "Template.loadTemplate(\""+pathFile+"\",\""+block+"\")", e );
    }
    loadTemplate ( fis, block, useCache );
  }

  public void loadTemplate( java.io.InputStream tStream, String block, boolean useCache ) {
    try {
      buildTree ( getFileContent( tStream ) );
    }
    catch ( Exception e ) {
      logger.error( "Template.loadTemplate(\"java.io.InputStream\",\""+block+"\")", e );
    }
  }

  private String getFileContent(java.io.InputStream tStream ) throws java.io.IOException {
    if ( tStream == null ) {
      logger.error("Template.getFileContent() : java.io.InputStream tStream is null");
      return "";
    }
    String encoding = page.getCharacterEncoding();
    java.io.BufferedReader bf = null;
    if (encoding != null && encoding.length() != 0) {
        try {
            byte[] tmp = "test".getBytes(encoding); 
        } catch (java.io.UnsupportedEncodingException uee) {
            encoding = "ISO-8859-1";
        }
    } else {
        encoding = "ISO-8859-1";
    }
    bf = new java.io.BufferedReader(new java.io.InputStreamReader(tStream, encoding));
    StringBuffer lines = new StringBuffer();
    while (bf.ready()) {
      String line = bf.readLine();
      if ( line != null ) { lines.append( line + "\n"); }
    }
    bf.close();
    return lines.toString();
  }

  public void buildTree( String fileContent ) {
    int currentPos = 0, counter = 0, count = 0;
//   brackets - array which contains the position of brackets.
//   0 - Curly brackets - variables of template
//   1 - Angle brackets <!-- BEGIN smth --> - begin tag of block
//   2 - Angle brackets <!-- END smth --> - end tag of block
//   Elements of the bracket arrays:
//      0 - Array of names
//      1 - Begins of the brackets
//      2 - Ends of the brackets
//      3 - Amount of the template elements

    Bracket[][] brackets = new Bracket[3][];
    int[] values   = new int[3];
    int[] counters = new int[3];
    int type;
    Vector tmpTree = new Vector();

    String[] denyVar = {":",";","(",")"," ","}","<", "=", "[", "]", "\"", "\n", "\t"};
    String[] denyBlock = {"-"};
    brackets[Item.VARIABLE] = getElements( "{", "}", denyVar, fileContent );
    brackets[Item.BEGIN_BLOCK] = getElements( BEGIN_OPEN, BEGIN_CLOSE, denyBlock, fileContent );
    brackets[Item.END_BLOCK] = getElements( END_OPEN, END_CLOSE, denyBlock, fileContent );

    for ( counter = 0; counter < brackets.length; counter++ ) {
      if ( brackets[counter].length > 0 ) {
        values[counter] = brackets[counter][0].begin;
      }
      else {
        values[counter] = -1;
      }
      counters[counter] = 0;
    }

    tmpTree.add( new TemplateItem( this.pathTo +"/*", Item.BEGIN_BLOCK, Item.VISIBLE, ""));

    type = minOf3(values);
    while ( type != -1 ) {
      if (( brackets[type][counters[type]].begin - currentPos) > 0 ) {
        tmpTree.add( new TemplateItem( this.pathTo + "/@text", Item.TEXT
                , Item.VISIBLE
                , fileContent.substring(currentPos, brackets[type][counters[type]].begin )));
      }
      currentPos = brackets[type][counters[type]].end + 1;

      switch ( type ) {
        case Item.VARIABLE :
          tmpTree.add( new TemplateItem(this.pathTo + "/" +
                              getName(brackets[type][counters[type]].name, type)+"/*",
                              Item.VARIABLE, Item.INVISIBLE, ""));
          break;
        case Item.BEGIN_BLOCK :
          pathList[pathLength++] = getName(brackets[type][counters[type]].name, type);
          getPath();
          tmpTree.add( new TemplateItem(this.pathTo + "/*", type, Item.INVISIBLE, ""));
          break;
        case Item.END_BLOCK :
          tmpTree.add( new TemplateItem(this.pathTo + "/*", type, Item.INVISIBLE, ""));
          pathList[--pathLength] = null;
          getPath();
          break;
      }

      counters[type]++;
      if  ( counters[type] == brackets[type].length ) {
        values[type] = -1;
      }
      else {
        values[type] = brackets[type][counters[type]].begin;
      }
      type = minOf3(values);
    } // End while

    if ( currentPos < fileContent.length() ) {
      tmpTree.add( new TemplateItem(this.pathTo + "/@text", Item.TEXT
                 , Item.INVISIBLE, fileContent.substring( currentPos )));
    }

    tmpTree.add(new TemplateItem(this.pathTo + "/*", Item.END_BLOCK, Item.VISIBLE, ""));
    tree = new TemplateItem[tmpTree.size()];
    String shortPath = null;
    String mediumPath = null;
    String thirdPath = null;
    String forthPath = null;
    int sPos2=0;
    for ( count = 0; count < tmpTree.size(); count++ ) {
      shortPath = null;
      mediumPath = null;
      thirdPath = null;
      forthPath = null;
      tree[count] = (TemplateItem)tmpTree.get(count);

      int sPos = tree[count].path.lastIndexOf("/");
      if ( sPos > 0 ) {
        shortPath = tree[count].path.substring(sPos);
        if ( "/*".equals(shortPath)) {
          int sPos1 = tree[count].path.lastIndexOf("/", sPos-1);
          if ( sPos1 > -1 ) {
            shortPath = tree[count].path.substring(sPos1);
            if ( sPos1 > 0 ) {
              sPos2 = tree[count].path.lastIndexOf("/", sPos1-1);
              if ( sPos2 > -1 ) {
                mediumPath = tree[count].path.substring(sPos2);
              }
            }
          }
        }
        else {
          shortPath = tree[count].path.substring(sPos);
          if ( sPos > 0 ) {
            sPos2 = tree[count].path.lastIndexOf("/", sPos-1);
            if ( sPos2 > -1 ) {
              mediumPath = tree[count].path.substring(sPos2);
            }
          }
        }
      }
      int sPos3 = -1;
      if ( mediumPath != null && ! mediumPath.equals(tree[count].path)) {
        if ( sPos2 > 0 ) {
          sPos3 = tree[count].path.lastIndexOf("/", sPos2-1);
          if ( sPos3 > -1 ) {
            thirdPath = tree[count].path.substring(sPos3);
          }
        }
      }
      if ( thirdPath != null && ! thirdPath.equals(tree[count].path)) {
        if ( sPos3 > 0 ) {
          int sPos4 = tree[count].path.lastIndexOf("/", sPos3-1);
          if ( sPos4 > -1 ) {
            forthPath = tree[count].path.substring(sPos4);
          }
        }
      }

      Vector items = (Vector) indexTree.get(tree[count].path);
      if ( items == null ) {
        items = new Vector();
      }
      items.add(new Integer(count));
      indexTree.put( ((TemplateItem)tmpTree.get(count)).path, items );

      if ( shortPath != null && ! shortPath.equals(tree[count].path)) {
        items = (Vector) indexTree.get(shortPath);
        if ( items == null ) {
          items = new Vector();
        }
        items.add(new Integer(count));
        indexTree.put( shortPath, items );
      }
      if ( mediumPath != null && ! mediumPath.equals(tree[count].path)) {
        items = (Vector) indexTree.get(mediumPath);
        if ( items == null ) {
          items = new Vector();
        }
        items.add(new Integer(count));
        indexTree.put( mediumPath, items );
      }
      if ( thirdPath != null && ! thirdPath.equals(tree[count].path)) {
        items = (Vector) indexTree.get(thirdPath);
        if ( items == null ) {
          items = new Vector();
        }
        items.add(new Integer(count));
        indexTree.put( thirdPath, items );
      }
      if ( forthPath != null && ! forthPath.equals(tree[count].path)) {
        items = (Vector) indexTree.get(forthPath);
        if ( items == null ) {
          items = new Vector();
        }
        items.add(new Integer(count));
        indexTree.put( forthPath, items );
      }

    }
/*
    Enumeration keys = indexTree.keys();
    String vals="";
    while ( keys.hasMoreElements() ){
      String key = (String) keys.nextElement();
      Vector v = (Vector) indexTree.get(key);
      vals="";
      for ( int i=0; i<v.size(); i++ ) {
        vals += " "+((Integer)v.get(i));
      }
      logger.debug("Template.buildTree() :"+key+" => "+vals);
    }
*/
  }

  public String printBlocks() {
    String result = "<table border>";
    for ( int count = 0; count < tree.length; count ++ ) {
      result += "<tr><td>" + tree[count].path + "</td><td>" + tree[count].type
              + "</td><td>" + java.net.URLEncoder.encode(tree[count].body.toString())
              + "</td></tr>";
    }
    return result + "</table>";
  }

    public void setVar( String name, String value, int mode ) {
        if ( name == null || name.length() == 0 ) {
            logger.error("call with null name => Template.setVar(\""+name+"\", \""+value+"\", "+mode+")");
            return;
        }
        Vector items = (Vector) indexTree.get( "/" + name + "/*" );
        if ( items == null && mode == Template.IF_DOESNT_EXIST_DO_NOTHING ) return;
        if ( items == null ) {
            logger.error("Template.setVar(\""+name+"\", \""+value+"\", "+mode+") => variable '"+name+"' does not exist");
        }
        for ( int i = 0; i < items.size(); i++ ) {
            int pointer = ((Integer) items.get(i)).intValue();
            tree[pointer].body = new StringBuffer( value == null ? "" : value );
            tree[pointer].parsed = true;
        }
    }

    public void setTag( String pathTo, String varName, String value, int mode ) {
        if ( pathTo == null || pathTo.length() == 0 || varName == null || varName.length() == 0 ) {
            logger.error("call with null name => Template.setVar(\""+pathTo+", \""+varName+"\", \""+value+"\", "+mode+")");
            return;
        }
        Vector items = (Vector) indexTree.get( "/" + varName + "/*" );
        if ( items == null && mode == Template.IF_DOESNT_EXIST_DO_NOTHING ) return;
        if ( items == null ) {
            logger.error("Template.setTag(\""+pathTo+varName+"\", \""+value+"\", "+mode+") => variable '"+varName+"' does not exist");
        }
        for ( int i = 0; i < items.size(); i++ ) {
            int pointer = ((Integer) items.get(i)).intValue();
            if ( tree[pointer].path.startsWith("/"+pathTo) ) {
                tree[pointer].body = new StringBuffer( value == null ? "" : value );
                tree[pointer].parsed = true;
            }
        }
    }

    public void setVar( String name ) {
        setVar( name, "", Template.IF_DOESNT_EXIST_DO_NOTHING );
    }

    public void setTag( String pathTo, String varName ) {
        setTag( pathTo, varName, "", Template.IF_DOESNT_EXIST_DO_NOTHING );
    }

    public void setVar( String name, String value ) {
        setVar( name, value, Template.IF_DOESNT_EXIST_DO_NOTHING );
    }

    public void setTag( String pathTo, String varName, String value ) {
        setTag( pathTo, varName, value, Template.IF_DOESNT_EXIST_DO_NOTHING );
    }

    public void setVar( String name, int mode ) {
        setVar( name, "", mode );
    }

    public void setTag( String pathTo, String varName, int mode ) {
        setTag( pathTo, varName, "", mode );
    }


  public String renderBlock( String pathTo, String blockName, boolean accumulate, String target, int mode) {
    if ( blockName == null || blockName.length() == 0 ) {
      logger.error("call with null name => Template.parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+")");
      return "";
    }
    Vector items = (Vector) indexTree.get ( "/" + blockName + "/*" );
    if ( items == null && mode == Template.IF_DOESNT_EXIST_DO_NOTHING ) {
      return "";
    } else if ( items == null ) {
      logger.error("Template.renderBlock(\""+pathTo+"/"+blockName+"\", "+accumulate+", \""+target+"\", "+mode+") => block '"+blockName+"' does not exist.");
    }

    String body = "";
    for ( int i = 0; i < items.size(); i+=2 ) {
        int pointer = ((Integer) items.get(i)).intValue();
        if ( tree[pointer].path.startsWith("/"+pathTo) ) {
            body = renderBlock(tree[pointer].path.substring(1,tree[pointer].path.length()-2), accumulate, target, mode);
            tree[pointer].parsed = true;
        }
    }
    return body;
  }

  public String renderBlock( String blockName, boolean accumulate, String target, int mode) {
    if ( blockName == null || blockName.length() == 0 ) {
      logger.error("call with null name => Template.parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+")");
      return "";
    }
    StringBuffer block = new StringBuffer();
    int depth = 0;
//logger.debug("parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+")");
    Vector items = (Vector) indexTree.get ( "/" + blockName + "/*" );
    if ( items == null && mode == Template.IF_DOESNT_EXIST_DO_NOTHING ) {
      return "";
    }
    if ( items == null ) {
      logger.error("Template.renderBlock(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+") => block '"+blockName+"' does not exist.");
    }
    if ( items.size() != 2 ) {
      logger.error( "Template.renderBlock : Parsing function: Block '" + blockName + "' cannot be found or selected." );
    }

    int beginBlock = ((Integer) items.get(0)).intValue();
    int endBlock = ((Integer) items.get(1)).intValue();

    for ( int i = beginBlock + 1; i < endBlock; i++ ) {
      if ( tree[i].type == Item.BEGIN_BLOCK ) {
        depth++;
        if ( depth == 1 ) { 
            if ( page.getBlock(tree[i].path).isVisible() ) {
                if ( tree[i].parsed ) {
                    block.append( tree[i].body.toString() ); 
                } else {
                    block.append( parse(tree[i].path.substring( 1, tree[i].path.length()-2 ), false) ); 
                }
            }
            tree[i].parsed = false;
        }
      } else if ( tree[i].type == Item.END_BLOCK ) {
        depth--;
      } else if ( depth == 0 ) {
        if ( tree[i].type == Item.TEXT ) {
          block.append( tree[i].body.toString() );
        } else if ( tree[i].parsed ) {
          block.append( tree[i].body.toString() );
        } else {
          if ( page.getVariable(tree[i].path).isVisible() ) {
            block.append( page.getVariable(tree[i].path).getValue() );
          }
        }
      }
    }

    int pointTarget = 0;
    if ( target == null ) {
      pointTarget = beginBlock;
    } else {
      items = (Vector) indexTree.get ( "/" + target + "/*" );
      if ( items != null && items.size() > 0 ) {
        pointTarget = ((Integer) items.get(0)).intValue();
      } else {
        logger.error( "Template.parseAndPrint: target '"+target+"' not found." );
      }
    }

    if ( accumulate ) {
      tree[pointTarget].body.append(block.toString());
    } else {
      tree[pointTarget].body = new StringBuffer( block.toString() );
    }
    tree[pointTarget].parsed = true;
    return tree[pointTarget].body.toString();
  }


  public String parseAndPrint( String blockName, boolean accumulate, String target, int mode) {
    if ( blockName == null || blockName.length() == 0 ) {
      logger.error("call with null name => Template.parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+")");
      return "";
    }
    StringBuffer block = new StringBuffer();
    int depth = 0;
//logger.debug("parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+")");
    Vector items = (Vector) indexTree.get ( "/" + blockName + "/*" );
    if ( items == null && mode == Template.IF_DOESNT_EXIST_DO_NOTHING ) {
      return "";
    }
    if ( items == null ) {
      logger.error("Template.parseAndPrint(\""+blockName+"\", "+accumulate+", \""+target+"\", "+mode+") => block '"+blockName+"' does not exist.");
    }
    if ( items.size() != 2 ) {
      logger.error( "Template.parseAndPrint : Parsing function: Block '" + blockName + "' cannot be found or selected." );
    }

    int beginBlock = ((Integer) items.get(0)).intValue();
    int endBlock = ((Integer) items.get(1)).intValue();

    for ( int i = beginBlock + 1; i < endBlock; i++ ) {
      if ( tree[i].type == Item.BEGIN_BLOCK ) {
        depth++;
        if ( depth == 1 ) { block.append( tree[i].body.toString() ); }
      }
      else if ( tree[i].type == Item.END_BLOCK ) {
        depth--;
      }
      else if ( depth == 0 ) {
        block.append( tree[i].body.toString() );
      }
    }

    int pointTarget = 0;
    if ( target == null ) {
      pointTarget = beginBlock;
    }
    else {
      items = (Vector) indexTree.get ( "/" + target + "/*" );
      if ( items.size() > 0 ) {
        pointTarget = ((Integer) items.get(0)).intValue();
      }
      else {
        logger.error( "Template.parseAndPrint: target '"+target+"' not found." );
      }
    }

    if ( accumulate ) {
      tree[pointTarget].body.append(block.toString());
    }
    else {
      tree[pointTarget].body = new StringBuffer( block.toString() );
    }
    tree[pointTarget].parsed = true;
    return tree[pointTarget].body.toString();
  }


  public String parse( String blockName, boolean accumulate, String target, int mode ) {
    return parseAndPrint ( blockName, accumulate, target, mode );
  }

  public String parse( String blockName, boolean accumulate, String target ) {
    return parseAndPrint ( blockName, accumulate, target, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String parse( String blockName, boolean accumulate ) {
    return parseAndPrint ( blockName, accumulate, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String parse( String blockName ) {
    return parseAndPrint ( blockName, true, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String parse( String blockName, boolean accumulate, int mode ) {
    return parseAndPrint ( blockName, accumulate, null, mode );
  }

  public String parse( String blockName, int mode ) {
    return parseAndPrint ( blockName, true, null, mode );
  }

  public String render( String blockName, boolean accumulate, String target, int mode ) {
    return renderBlock( blockName, accumulate, target, mode );
  }

  public String render( String pathTo, String blockName, boolean accumulate, String target, int mode ) {
    return renderBlock( pathTo, blockName, accumulate, target, mode );
  }

  public String render( String blockName, boolean accumulate, String target ) {
    return renderBlock( blockName, accumulate, target, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String render( String blockName, boolean accumulate ) {
    return renderBlock( blockName, accumulate, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String render( String pathTo, String blockName, boolean accumulate ) {
    return renderBlock( pathTo, blockName, accumulate, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String render( String blockName ) {
    return renderBlock( blockName, true, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String render( String pathTo, String blockName ) {
    return renderBlock( pathTo, blockName, true, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String render( String pathTo, String blockName, boolean accumulate, int mode ) {
    return renderBlock( pathTo, blockName, accumulate, null, mode );
  }

  public String render( String blockName, boolean accumulate, int mode ) {
    return renderBlock( blockName, accumulate, null, mode );
  }

  public String render( String blockName, int mode ) {
    return renderBlock( blockName, true, null, mode );
  }

  public boolean isExists( String blockName, int type ) {
    if ( blockName == null || blockName.length() == 0 ) {
      logger.error("call with name is null => Template.isExists(\""+blockName+"\", "+type+")");
      return false;
    }
    boolean result = false;
    Vector items = (Vector) indexTree.get ( "/" + blockName + "/*" );
    // problem: condition below is not right. they is emulation right work only :(
    result = (items != null);
/*
    switch ( type ) {
      case Template.BLOCK :
        if ( items.size() > 1 ) result = true;
        break;
      case Template.VARIABLE :
        if ( items.size() > 0 ) result = true;
        break;
      default :
        logger.error ( "Template.IsExists function: The parameter type is wrong.");
    }
*/
    return result;
  }

  public void hideBlock( String blockName ) {
    setVar ( blockName, "" );
  }

  public String pParse( String blockName, boolean accumulate) {
    return parseAndPrint ( blockName, accumulate, null, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  public String parseTo( String blockName, boolean accumulate, String target) {
    return parseAndPrint ( blockName, accumulate, target, Template.IF_DOESNT_EXIST_IS_ERROR );
  }

  private StringBuffer sbPath = new StringBuffer("/");
  private void getPath() {
    sbPath.setLength(1);
    int i=0;
    for ( i=0; i < pathLength-1; i++ ) {
        sbPath.append ( pathList[i] + "/" );
    }
    sbPath.append(pathList[i]);
    this.pathTo = sbPath.toString();
  }

  public String getFormattedTree() {
    String result = "";
    for ( int i = 0; i < tree.length; i++ ) {
      if ( tree[i].path != null ) {
        result += tree[i].path + "&nbsp;";
      }
      else  {
        result += "&nbsp;";
      }
    }
    return result;
  }

  /**
    * Extract name of block or variable
    * @param String object which contains variable (with {} ) or begin/end tag of block
    * @return String object which contains variable name or block
    *         or null if error
    */
  private String getName(String node, int type) {
    String result = null;
    switch (type) {
      case Item.VARIABLE:
        result = "@" + node.substring( 1, node.length()-1 );
        break;
      case Item.BEGIN_BLOCK:
        result = node.substring ( BEGIN_OPEN_LENGTH, node.length() - BEGIN_CLOSE_LENGTH );
        break;
      case Item.END_BLOCK:
        result = node.substring ( END_OPEN_LENGTH, node.length() - END_CLOSE_LENGTH );
        break;
    }
    return result;
  }
/*
  public String getFormattedList( String name, arrArrays, intCount)
    Dim strResult : strResult = "<h3>" & strName & "</h3>Total : " & intCount & "<table>"
    Dim strLines(3)
    Dim intCounter, intInner

    For intCounter = 0 To intCount - 1
      For intInner = 0 To 2
        strLines(intInner) = strLines(intInner)
                           & Server.HTMLEncode(arrArrays(intInner)(intCounter)) & "</td><td>"
      Next
    Next
    For intInner = 0 To 3
      strResult = strResult & "<tr><td>" & strLines(intInner) & "</td></tr>"
    Next
    strResult = strResult & "</table>"
    GetFormattedList = strResult
  End Function
*/
  public int minOf3( int[] values ) {
    int result = 0;
    if ( values[Item.VARIABLE] == -1 ) {
      result = minOf2 ( values[Item.BEGIN_BLOCK], Item.BEGIN_BLOCK, values[Item.END_BLOCK], Item.END_BLOCK );
    }
    else if ( values[Item.BEGIN_BLOCK] == -1 ) {
      result = minOf2 ( values[Item.VARIABLE], Item.VARIABLE, values[Item.END_BLOCK], Item.END_BLOCK );
    }
    else if ( values[Item.END_BLOCK] == -1 ) {
      result = minOf2 ( values[Item.VARIABLE], Item.VARIABLE, values[Item.BEGIN_BLOCK], Item.BEGIN_BLOCK );
    }
    else if ( values[Item.VARIABLE] > values[Item.BEGIN_BLOCK] ) {
      if ( values[Item.BEGIN_BLOCK] > values[Item.END_BLOCK] ) { result = Item.END_BLOCK; }
      else { result = Item.BEGIN_BLOCK; }
    }
    else {
      if ( values[Item.VARIABLE] > values[Item.END_BLOCK] ) { result = Item.END_BLOCK; }
      else { result = Item.VARIABLE; }
    }
    return result;
  }

  public int minOf2(int a, int indexA, int b, int indexB) {
    int result = -1;
    if ( a == -1 ) {
      if ( b > -1 ) { result = indexB; }
    }
    else if ( b == -1 ) {
      result = indexA;
    }
    else if ( a < b ) {
      result = indexA;
    }
    else {
      result = indexB;
    }
    return result;
  }

  private Bracket[] getElements ( String start, String end, String[] denySymb, String template ) {
    Vector el = new Vector();
    if ( template != null ) {
      int s = 0, e = 0;
      while ( (s = template.indexOf( start, e ) ) >= 0 ) {
        if (( e = template.indexOf( end, s )) >= 0 ) {
          String str = template.substring( s + start.length(), e );
          int res = 0;
          for ( int i=0; i<denySymb.length; i++ ) {
            res += str.indexOf(denySymb[i]);
          }
          if ( res == -(denySymb.length) ) {
            Bracket b = new Bracket ( start + str + end, s, e + end.length() - 1 );
            el.add(b);
          } else {
            e = s + 1;
          }
        }
      }
    }
    Bracket[] brackets = new Bracket[el.size()];
    for ( int i=0; i<el.size(); i++ ) {
      brackets[i] = (Bracket) el.get(i);
    }
    return brackets;
  }
}
//End Template class

