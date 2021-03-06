BIREPA1 ;IHS/CMI/MWR - REPORT, VAC ACCOUNTABILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT VACCINE ACCOUNTABILITY REPORT.
 ;
 ;
 ;----------
START(BIX) ;EP
 ;---> Prepare and display or print Vaccine Accountability Report.
 ;---> Parameters:
 ;     1 - BIX    (req) If BIX="PRINT", then print Report.
 ;                      If BIX="VIEW", then view Report (default).
 ;                      If BIX="LOTS", then view Report by individual lot numbers.
 ;---> Variables:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     8 - BIVT    (req) Visit Type array.
 ;     9 - BIPOP   (ret) BIPOP=1 if error.
 ;
 ;---> Check for required Variables.
 I '$G(BIBEGDT) D ERROR(626) D RESET^BIREPA Q
 I '$G(BIENDDT) D ERROR(627) D RESET^BIREPA Q
 I '$D(BICC) D ERROR(614) D RESET^BIREPA Q
 I '$D(BIHCF) D ERROR(625) D RESET^BIREPA Q
 I '$D(BICM) D ERROR(615) D RESET^BIREPA Q
 I '$D(BIBEN) D ERROR(662) D RESET^BIREPA Q
 I '$D(BIHIST) D ERROR(663) D RESET^BIREPA Q
 I '$D(BIVT) D ERROR(664) D RESET^BIREPA Q
 I '$D(BIDLOT) S BIDLOT=0
 ;
 D SETVARS^BIUTL5
 N VALMCNT
 I $G(BIX)="PRINT" D PRINT,RESET^BIREPA Q
 D EN
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Main entry point for printing the Quarterly Immunization Report.
 D DEVICE(.BIPOP)
 Q:$G(BIPOP)
 ;
 D:$G(IO)'=$G(IO(0))
 .W !!?10,"This may take some time.  Please hold on...",!
 ;
 ;---> Prepare report.
 K VALMHDR,^TMP("BIREPA1",$J)
 N VALM,VALMHDR
 D HDR
 D GET^BIREPA2(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT,BIDLOT)
 ;
 D PRTLST^BIUTL8("BIREPA1")
 D EXIT,RESET^BIREPA
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT QUARTERLY IMM1.
 D EN^VALM("BI REPORT ACCOUNTABILITY1")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 D HEAD^BIREPA2(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=$$LMVER^BILOGO
 W !!?10,"This may take some time.  Please hold on...",!
 D GET^BIREPA2(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT,BIDLOT)
 ;---> Set up ZTSAVE in case user Queues from PL in List.
 D ZSAVES^BIUTL3
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
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the report, or"
 W !?5,"type ""??"" for more actions, such as Search and Print List."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP("BIREPA1",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIREPA1"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Prepare and print Quarterly Report.
 K VALMHDR,^TMP("BIREPA1",$J)
 D HDR
 D GET^BIREPA2(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT,BIDLOT)
 D PRTLST^BIUTL8("BIREPA1"),EXIT
 Q
 ;
 ;
 ;----------
ERROR(BIERR) ;EP
 ;---> Report error, either to screen or print.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 D ERRCD^BIUTL2($G(BIERR),,1) S BIPOP=1
 Q
