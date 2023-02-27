//SimpleMailer class @0-9A9A8467
package com.codecharge.util;

import java.io.*;
import java.net.Socket;
import com.codecharge.util.CCLogger;

public class SimpleMailer {

   public static void sendEmail(String from, String to, String subject, 
            String body, boolean allowHTML) {
       sendEmail( from, to, subject, body, allowHTML, "localhost" );
   }

   public static void sendEmail(String from, String to, String subject, 
            String body, boolean allowHTML, String smtpHost ) {
        try {
          Socket MS = new Socket( smtpHost, 25);
          BufferedReader IConn = new BufferedReader(new InputStreamReader(MS.getInputStream()));
          PrintStream OConn = new PrintStream(MS.getOutputStream());
          String s1 = IConn.readLine();
          OConn.print("helo me\r\n");
          s1 = IConn.readLine();
          OConn.print("mail from: "+from+"\r\n");
          s1 = IConn.readLine();
          OConn.print("rcpt to: "+to+"\r\n");
          s1 = IConn.readLine();
          OConn.print("data\r\n");
          s1 = IConn.readLine();
          OConn.print("Subject: " + subject + "\r\n" );
          OConn.print("From: "+from + "\r\n" );
          OConn.print("To: "+to+"\r\n");
          if ( allowHTML ) {
             OConn.print("Content-Type: text/html;\r\n");
          }
          OConn.print("\r\n" + body + "\r\n");
          OConn.print("\r\n.\r\n");
          s1 = IConn.readLine();
          OConn.println("quit\r\n");
          IConn.close();
          OConn.close();
          MS.close();
        
        } 
        catch (Exception e) { CCLogger.getInstance().debug("Unable send email", e); }
   }
}
//End SimpleMailer class

