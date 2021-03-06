BINFO ;IHS/CMI/MWR - VIEW PACKAGE INFORMATION.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW PACKAGE INFORMATION IN LISTMAN.  ALSO, CALLED FROM
 ;;  BIPOST, AFTER PACKAGE INSTALLATION.
 ;
 ;
 ;----------
START ;EP
 D SETVARS^BIUTL5 K ^TMP("BINFO",$J) N BITMP,DIR
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for option BI REPORT VACCINE TRANSLAT.
 D EN^VALM("BI PACKAGE INFORMATION VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 N BIDASH,BILINE,X,Y S BILINE=0
 D WH^BIW(.BILINE)
 S X="PACKAGE INFORMATION for IMMUNIZATION, Version "_$$VER^BILOGO
 S BIDASH=$L(X)+2
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=" (Immunization v"_$$VER^BILOGO_")"
 ;
 ;---> Gather text from ^BINFO( Word Processing global.
 N BILINE,N
 S BILINE=0,N=0
 F  S N=$O(^BINFO(1,1,N)) Q:'N  D
 .D WL^BIW(.BILINE,"BINFO",$G(^BINFO(1,1,N,0)))
 S VALMCNT=BILINE
 I VALMCNT>15 D
 .S VALMSG="Scroll down to view more. Type ?? for more actions."
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 W !!?5,"Use arrow keys to scroll up and down.  "
 W "Enter ?? for more actions."
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BINFO",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
