DGENRPC2 ;ALB/CJM -Enrollees by Status, Priority, Preferred Facility Report - Continued; May 12, 1999
 ;;5.3;Registration;**147,232,306**;Aug 13,1993
 ;
PRINT ;
 N STATS,CRT,QUIT,PAGE,SECTION
 K ^TMP($J)
 S QUIT=0
 S PAGE=0
 S CRT=$S($E(IOST,1,2)="C-":1,1:0)
 ;
 D GETPAT
 U IO
 I CRT,PAGE=0 W @IOF
 S PAGE=1
 S SECTION="SUMMARY"
 D HEADER
 D SUMMARY
 I DGENRP("LIST") D
 .S SECTION="PATIENTS"
 .D HEADER
 .D PATIENTS
 I CRT,'QUIT D PAUSE
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^%ZISC
 K ^TMP($J)
 Q
LINE(LINE) ;
 ;Description: prints a line. First prints header if at end of page.
 ;
 I CRT,($Y>(IOSL-4)) D
 .D PAUSE
 .Q:QUIT
 .W @IOF
 .D HEADER
 .W LINE
 ;
 E  I ('CRT),($Y>(IOSL-2)) D
 .W @IOF
 .D HEADER
 .W LINE
 ;
 E  W !,LINE
 Q
 ;
GETPAT ;
 ;Description: Gets patients to include in the report
 ;for that reason 
 ;
 N DFN,STATUS
 S STATUS=0
 F  S STATUS=$O(^DPT("AENRC",STATUS)) Q:'STATUS  D
 .S DFN=0
 .F  S DFN=$O(^DPT("AENRC",STATUS,DFN)) Q:'DFN  D
 ..N DGINST,DGPFH,PREFAC,DGENRIEN,DGENR,EFFDATE,FACNAME,PATNAME,CATEGORY,PRISUB
 ..S FACNAME=" "
 ..S DGENRIEN=$$FINDCUR^DGENA(DFN)
 ..S CATEGORY=$$CATEGORY^DGENA4(DFN,STATUS)
 ..Q:'$$GET^DGENA(DGENRIEN,.DGENR)
 ..Q:DGENR("STATUS")'=STATUS
 ..S PATNAME=$$NAME^DGENPTA(DFN)
 ..S DGENR("SUBGRP")=$$EXT^DGENU("SUBGRP",DGENR("SUBGRP"))
 ..Q:(PATNAME="")
 ..;
 ..S PREFAC=$$PREF^DGENPTA(DFN)
 ..I PREFAC S DGPFH("PREFAC")=PREFAC,DGPFH("EFFDATE")=""
 ..I PREFAC,'$$GETINST^DGENU($G(DGPFH("PREFAC")),.DGINST) S PREFAC=""
 ..I (DGENRP("FACILITY","ALL")!$D(DGENRP("FACILITY",+PREFAC))) D
 ...S PRISUB=+DGENR("PRIORITY")_DGENR("SUBGRP")
 ...S:PREFAC FACNAME=$$LJ($G(DGINST("STANUM")),10)_$$LJ($G(DGINST("NAME")),45)
 ...S ^TMP($J,FACNAME,CATEGORY,DGENR("STATUS"))=$G(^TMP($J,FACNAME,CATEGORY,DGENR("STATUS")))+1
 ...S ^TMP($J,FACNAME,CATEGORY,DGENR("STATUS"),PRISUB)=$G(^TMP($J,FACNAME,CATEGORY,DGENR("STATUS"),PRISUB))+1
 ...I DGENRP("LIST"),DGENRP("STATUS","ALL")!$D(DGENRP("STATUS",STATUS)),DGENRP("PRIORITY","ALL")!$D(DGENRP("PRIORITY",+DGENR("PRIORITY"))) D
 ....S ^TMP($J,FACNAME,"PATIENT",CATEGORY,DGENR("STATUS"),PRISUB,$E(PATNAME,1,45),+DGENR("DATE"),+DGENR("DFN"))=DGENRIEN_"^"_$G(DGINST("STANUM"))_"^"_$G(DGPFH("EFFDATE"))
 Q
 ;
HEADER ;
 ;Description: Prints the report header.
 ;
 N LINE
 I $Y>1 W @IOF
 W !,"Enrollments by Status, Priority, and Preferred Facility"
 W ?100,"Page ",PAGE
 S PAGE=PAGE+1
 ;
 W !
 W $S(SECTION="SUMMARY":"  <<< SUMMARY STATISTICS >>>",1:"  <<< PATIENT LISTING >>>")
 W ?100,"Run Date: "_$$FMTE^XLFDT(DT)
 W !
 I SECTION="PATIENTS",DGENRP("LIST") D
 .W !,"Selection Criteria for Patient Listing: "
 .W !?5,"Enrollment Statuses: "
 .I DGENRP("STATUS","ALL") D
 ..W "ALL"
 .E  D
 ..N STATUS
 ..S STATUS=""
 ..F  S STATUS=$O(DGENRP("STATUS",STATUS)) Q:'STATUS  W $$EXT^DGENU("STATUS",STATUS)_","
 .;
 .W !?5,"Enrollment Priorities: "
 .I DGENRP("PRIORITY","ALL") D
 ..W "ALL"
 .E  D
 ..N PRIORITY
 ..S PRIORITY=""
 ..F  S PRIORITY=$O(DGENRP("PRIORITY",PRIORITY)) Q:'PRIORITY  W PRIORITY_", "
 W:(SECTION="PATIENTS") !,"Name",?39,"PatientID",?54,"DOB",?67,"Status",?86,"Priority",?101,"EnrollDate",?114,"EndDate",?129
 S $P(LINE,"-",132)="-"
 W !,LINE,!
 Q
 ;
PAUSE ;
 ;Description: Screen pause.  Sets QUIT=1 if user decides to quit.
 ;
 N DIR,X,Y
 F  Q:$Y>(IOSL-3)  W !
 S DIR(0)="E"
 D ^DIR
 I ('(+Y))!$D(DIRUT) S QUIT=1
 Q
 ;
SUMMARY ;
 ;Description: Prints the summary statistics
 ;
 N PREFAC,LINE,PRIORITY,STATUS,TOTAL,COUNT,GRNDTOTL
 S PREFAC=""
 S GRNDTOTL=0
 F  S PREFAC=$O(^TMP($J,PREFAC)) Q:PREFAC=""  D  Q:QUIT
 .D LINE("  ") Q:QUIT
 .D LINE($$LJ(" ",40)_"PREFERRED FACILITY: "_$S(PREFAC=" ":"none",1:PREFAC)_"  "_$G(^TMP($J,PREFAC))) Q:QUIT
 .D LINE($$LJ(" ",55)_"Enr. Category") Q:QUIT
 .S TOTAL=0
 .S CATEGORY=""
 .F  S CATEGORY=$O(^TMP($J,PREFAC,CATEGORY)) Q:CATEGORY=""  D  Q:QUIT
 ..D LINE($$LJ(" ",58)_$$EXTCAT^DGENA4(CATEGORY))
 ..S STATUS=""
 ..F  S STATUS=$O(^TMP($J,PREFAC,CATEGORY,STATUS)) Q:'STATUS  D  Q:QUIT
 ...S COUNT=$G(^TMP($J,PREFAC,CATEGORY,STATUS))
 ...S TOTAL=TOTAL+COUNT
 ...D LINE("      "_$$LJ($$STATUS(STATUS),18)_"  "_$J(COUNT,7))
 ...Q:QUIT
 ...S PRIORITY=""
 ...F  S PRIORITY=$O(^TMP($J,PREFAC,CATEGORY,STATUS,PRIORITY)) Q:(PRIORITY="")  D  Q:QUIT
 ....S COUNT=$G(^TMP($J,PREFAC,CATEGORY,STATUS,PRIORITY))
 ....I $L(PRIORITY)=2 D LINE("          Priority "_+PRIORITY_$E(PRIORITY,2)_"     "_$J(COUNT,7)) Q
 ....D LINE("          "_$S(PRIORITY:"Priority "_PRIORITY_"      ",1:"No Priority     ")_$J(COUNT,7))
 ...Q:QUIT
 ...D LINE(" ")
 ..Q:QUIT
 .Q:QUIT
 .S GRNDTOTL=GRNDTOTL+TOTAL
 .D:(PREFAC=" ") LINE(" TOTAL (NO FACILITY)     "_$J(TOTAL,8))
 .D:(PREFAC'=" ") LINE("     FACILITY TOTAL      "_$J(TOTAL,8))
 .Q:QUIT
 Q:QUIT
 W !!
 D LINE(" TOTAL FOR ALL SELECTED FACILITIES:   "_$J(GRNDTOTL,8))
 Q:QUIT
 Q
 ;
PATIENTS ;
 ;Description: Prints list of patients
 ;
 N PREFAC,DGENRIEN,DGENR,DGPAT,LINE,NODE,PATNAME,STATUS,PRIORITY,ENRDATE,DFN,CATEGORY,I
 ;
 S PREFAC=""
 ;
 F  S PREFAC=$O(^TMP($J,PREFAC)) Q:PREFAC=""  D  Q:QUIT
 .D LINE("  ") Q:QUIT
 .D LINE($$LJ(" ",40)_"PREFERRED FACILITY: "_$S(PREFAC=" ":"none",1:PREFAC)_"  "_$G(^TMP($J,PREFAC))) Q:QUIT
 .S CATEGORY=""
 .F I=1:1 S CATEGORY=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY)) Q:CATEGORY=""  D  Q:QUIT
 ..D:I>1 LINE("  ") Q:QUIT
 ..D LINE($$LJ(" ",40)_"ENROLLMENT CATEGORY: "_$$EXTCAT^DGENA4(CATEGORY))
 ..D LINE("  ") Q:QUIT
 ..S STATUS=""
 ..F  S STATUS=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS)) Q:'STATUS  D  Q:QUIT
 ...S PRIORITY=""
 ...F  S PRIORITY=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS,PRIORITY)) Q:(PRIORITY="")  D  Q:QUIT
 ....S PATNAME=0
 ....F  S PATNAME=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS,PRIORITY,PATNAME)) Q:(PATNAME="")  D  Q:QUIT
 .....S ENRDATE=""
 .....F  S ENRDATE=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS,PRIORITY,PATNAME,ENRDATE)) Q:ENRDATE=""  D  Q:QUIT
 ......S DFN=0
 ......F  S DFN=$O(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS,PRIORITY,PATNAME,ENRDATE,DFN)) Q:'DFN  D  Q:QUIT
 .......;
 .......S NODE=$G(^TMP($J,PREFAC,"PATIENT",CATEGORY,STATUS,PRIORITY,PATNAME,ENRDATE,DFN))
 .......S DGENRIEN=$P(NODE,"^")
 .......Q:'DGENRIEN
 .......Q:'$$GET^DGENA(DGENRIEN,.DGENR)
 .......Q:'$$GET^DGENPTA(DGENR("DFN"),.DGPAT)
 .......S LINE=$$LJ(DGPAT("NAME"),37)_" "_$$LJ(DGPAT("PID"),15)_" "
 .......S LINE=LINE_$$LJ($$DATE(DGPAT("DOB")),12)_"  "
 .......S LINE=LINE_$$LJ($$EXT^DGENU("STATUS",DGENR("STATUS")),17)_" "
 .......S LINE=LINE_$$LJ("     "_DGENR("PRIORITY")_$S(DGENR("SUBGRP"):$$EXT^DGENU("SUBGRP",DGENR("SUBGRP")),1:""),15)_" "
 .......S LINE=LINE_$$LJ($$DATE(DGENR("DATE")),12)_" "
 .......S LINE=LINE_$$LJ($$DATE(DGENR("END")),12)_" "
 .......D LINE(LINE)
 .......Q:QUIT
 .Q:QUIT
 Q
 ;
STATUS(STATUS) ;
 ;Description: Returns status name.
 ;
 Q:'STATUS "No Status"
 Q $$LOWER^VALM1($$EXT^DGENU("STATUS",STATUS))
 ;
DATE(DATE) ;
 Q $$FMTE^XLFDT(DATE,"1")
 ;
LJ(STRING,LENGTH) ;
 Q $$LJ^XLFSTR($E(STRING,1,LENGTH),LENGTH)
