//ListBox component @0-84AEF488
package com.codecharge.components;

import java.util.Enumeration;

/**
A List Box is used to present a list of options from which the user can select one. The user clicks on the dropdown arrow to view all the options available. Using its format properties, a List Box can be configured to display more that one value at a time as well as allow the user to select multiple values. 

The values displayed in the List Box can come from database content or be specified manually using a semicolon separated list of values. List boxes are often used when displaying database tables which are related to other tables. The properties for a List Box can be configured to display content from a database table whose primary key is related to a field in the form where the List Box is placed.
*/
public class ListBox extends List {

    public ListBox(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    public ListBox(String name, Page page) {
        super(name, page);
    }

    /** Prepare HTML output for ListBox. The output consists of list of html option elements ready for output.
        @return HTML representation of ListBox component. */
    public String getOptionsString() {
        StringBuffer result = new StringBuffer();
        Enumeration enumeration = getFormattedOptions();

        while ( enumeration.hasMoreElements() ) {
            String[] option = (String[]) enumeration.nextElement();

            if (option[List.SELECTED] != null) {
                result.append( "<OPTION VALUE=\"" + option[List.BOUND_COLUMN] + 
                        "\" SELECTED>" + option[List.TEXT_COLUMN] + 
                        "</OPTION>\n" );
            } else {
                result.append( "<OPTION VALUE=\"" + option[List.BOUND_COLUMN] + 
                        "\">" + option[List.TEXT_COLUMN] + "</OPTION>\n" );
            }
        }
        return result.toString();
    }

}
//End ListBox component

