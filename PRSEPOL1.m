PRSEPOL1 ;HISC/DAD,MD-OLDE TRAINING CODING REPORT ;8/26/94  09:34
 ;;4.0;PAID;**18**;Sep 21, 1995
ENTSK ;
 K ^TMP("PRSE",$J)
 S PRSEDATE=YRST-.0000001
 F  S PRSEDATE=$O(^PRSE(452,"H",PRSEDATE)) Q:PRSEDATE'>0!(PRSEDATE>YREND)  D
 . S PRSED0=0
 . F  S PRSED0=$O(^PRSE(452,"H",PRSEDATE,PRSED0)) Q:PRSED0'>0  D
 .. S PRSE=$G(^PRSE(452,PRSED0,0))
 .. S PRSE200=+PRSE,PRSESSN=$P(PRSE,U,11) Q:PRSE200'>0!(PRSESSN="")
 .. I PRSESEL="S",$D(PRSEXMY(+$$EN13^PRSEUTL3(PRSE200)))#2 D  Q
 ... S ^TMP("PRSE",$J,PRSESSN,PRSED0)=""
 ... Q
 .. I PRSESEL="A",($$EN2^PRSEUTL4(+$$EN13^PRSEUTL3(PRSE200))=PSPC("TX")!PSP) D  Q
 ... S ^TMP("PRSE",$J,PRSESSN,PRSED0)=""
 ... Q
 .. Q
 . Q
 S PRSEQUIT=0,PRSEPAGE=1,PRSEUNDL="",$P(PRSEUNDL,"-",81)=""
 S Y=DT D DD^%DT S PRSENOW=Y
 K PRSETXT
 F PRSE=1:1 S PRSETXT=$P($T(DATA+PRSE),";",3) Q:PRSETXT=""  D
 . S PRSETXT(PRSE)=PRSETXT_":"
 . Q
 U IO D HEADER
 S (PRSESSN,PRSEPRNT)=0
 F  S PRSESSN=$O(^TMP("PRSE",$J,PRSESSN)) Q:PRSESSN'>0!PRSEQUIT  D
 . S PRSED0=0
 . F  S PRSED0=$O(^TMP("PRSE",$J,PRSESSN,PRSED0)) Q:PRSED0'>0!PRSEQUIT  D GETDATA
 . Q
 I PRSEPRNT'>0 W !!,"No data found for this report"
 Q
GETDATA ;
 K PRSEDATA
 S PRSE(0)=$G(^PRSE(452,PRSED0,0)),PRSE(2)=$G(^(2)),PRSE(6)=$G(^(6))
 I $P(PRSE(0),U,12)'="Y" Q  ; *** 'CODE FOR OLDE' not set to 'YES'
 S PRSETYED=$P(PRSE(0),U,21) I "^C^M^O^"'[(U_PRSETYED_U) Q  ; Type=C/M/O
 S PRSEDATA(1)=$P(PRSE(0),U,11)
 S PRSEDATA(1)=$E("000000000",1,9-$L(PRSEDATA(1)))_PRSEDATA(1)
 S (Y,PRSEY)=$P(PRSE(0),U),C=$P(^DD(452,.01,0),U,2)
 I Y]"" D Y^DIQ I Y]"" D
 . S X=$P($G(^PRSP(454.1,+$$EN3^PRSEUTL3(+PRSEY),0)),U)
 . S PRSEDATA(2)=Y_" - "_$S(X]"":X,1:"UNKNOWN")
 . Q
 S (PRSEDATA,Y)=$P(PRSE(0),U,22),C=$P(^DD(452,15,0),U,2)
 I Y]"" D Y^DIQ I Y]"" S PRSEDATA(3)=PRSEDATA_" ("_Y_")"
 S Y=$P(PRSE(2),U)
 S X=$G(^PRSE(452.51,+Y,0)),X(1)=$P(X,U),X(2)=$P(X,U,2)
 I X(1)]"",X(2)]"" S PRSEDATA(4)=X(2)_" ("_X(1)_")"
 S (PRSEDATA,Y)=$P(PRSE(0),U,7),C=$P(^DD(452,6,0),U,2)
 I Y]"" D Y^DIQ I Y]"" S PRSEDATA(5)=PRSEDATA_" ("_Y_")"
 S Y=$P(PRSE(0),U,5)
 S X=$G(^PRSE(452.4,+Y,0)),X(1)=$P(X,U),X(2)=$P(X,U,2)
 I X(1)]"",X(2)]"" S PRSEDATA(6)=X(2)_" ("_X(1)_")"
 S Y=$P(PRSE(0),U,2),C=$P(^DD(452,1,0),U,2)
 I Y]"" D Y^DIQ I Y]"" S PRSEDATA(7)=Y_" ("_PRSETYED_")"
 S Y=$P(PRSE(0),U,14)
 S PRSEDATA(8)=$S(Y:$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3),1:"")
 S PRSEDATA(9)=$P(PRSE(0),U,23)
 I PRSEDATA(9)]"" S PRSEDATA(9)=$J($FN(PRSEDATA(9),","),5)
 S PRSEDATA(10)=$P(PRSE(0),U,24)
 I PRSEDATA(10)]"" S PRSEDATA(10)=$J($FN(PRSEDATA(10),","),5)
 S Y=$P(PRSE(0),U,4),PRSEY=$TR(Y,"NR","AB"),C=$P(^DD(452,20,0),U,2)
 I Y]"" D Y^DIQ I Y]"" S PRSEDATA(11)=PRSEY_" ("_Y_")"
 S Y=$P(PRSE(0),U,19) I $P(PRSE(6),U)="L",PRSETYED="C" S Y=+Y
 I Y]"" S PRSEDATA(12)=$J($FN(Y,",",2),8)
 S Y=$P(PRSE(0),U,20) I $P(PRSE(6),U)="L",PRSETYED="C" S Y=+Y
 I Y]"" S PRSEDATA(13)=$J($FN(Y,",",2),8)
 S Y=$P(PRSE(0),U,8) I $P(PRSE(6),U)="L",PRSETYED="C" S Y=+Y
 I Y]"" S PRSEDATA(14)=$J($FN(Y,",",2),8)
 S Y=$P(PRSE(0),U,9),C=$P(^DD(452,8,0),U,2)
 I Y]"" D Y^DIQ I Y]"" S PRSEDATA(15)=Y
 S PRSEDATA(16)=$P(PRSE(0),U,10)
 I PRSEDATA(16)]"" S PRSEDATA(16)=$J($FN(PRSEDATA(16),",",2),8)
TYPE ;
 S PRSENODE="1^2^3^4^5^6^7^8^9^10"
 I $P(PRSE(0),U,16)<8 S PRSENODE=PRSENODE_"^11"
 I PRSETYED="C" S PRSENODE=PRSENODE_"^12^13^14^15^16"
 S PRSETYPE(0)="C"
 F PRSEI=1:1 S PRSE=$P(PRSENODE,U,PRSEI) Q:PRSE'>0!(PRSETYPE(0)="I")  D
 . I $G(PRSEDATA(PRSE))="" S PRSETYPE(0)="I"
 . Q
PRINT ;
 I PRSETYPE=PRSETYPE(0) D
 . W !
 . F PRSEI=1:1 S PRSE=$P(PRSENODE,U,PRSEI) Q:PRSE'>0!PRSEQUIT  D
 .. I PRSETYPE="C" D WRITE
 .. E  I $G(PRSEDATA(PRSE))=""!(U_1_U_2_U_7_U_8_U[(U_PRSE_U)) D WRITE
 .. I $Y>(IOSL-5),$S(PRSEI<$L(PRSENODE,U):1,$O(^TMP("PRSE",$J,PRSESSN,PRSED0))]"":1,$O(^TMP("PRSE",$J,PRSESSN))]"":1,1:0) D PAUSE,HEADER
 .. Q
 . Q
 Q
WRITE ;
 W !,PRSETXT(PRSE),?21,$G(PRSEDATA(PRSE)) S PRSEPRNT=1
 Q
PAUSE ;
 I $E(IOST)'="C" Q
 K DIR S DIR(0)="E" D ^DIR S PRSEQUIT=$S(Y'>0:1,1:0)
 Q
HEADER ;
 I PRSEQUIT Q
 I ($E(IOST)="C")!(PRSEPAGE>1) W @IOF
 W !?26,"OLDE TRAINING CODING REPORT",?68,PRSENOW
 S X=$S(PRSETYPE="C":"COMPLETE",1:"INCOMPLETE")_" DATA FOR "
 S X=X_$S(TYP="C":"CALENDAR YEAR",TYP="F":"FISCAL YEAR",1:"DATE RANGE")
 S X=X_" "_$S((TYP="C")!(TYP="F"):PYR,1:YRST(1)_" - "_YREND(1))
 W !?80-$L(X)/2,X,?68,"PAGE: ",PRSEPAGE,!,PRSEUNDL
 S PRSEPAGE=PRSEPAGE+1
 Q
DATA ;;
 ;;SSN
 ;;Student Name
 ;;Govt Funded
 ;;Purpose of Training
 ;;Source of Training
 ;;Prg/Cls Category
 ;;Prg/Cls Title
 ;;Date Prg/Cls Ended
 ;;Cls Hrs On Duty
 ;;Cls Hrs Off Duty
 ;;Routine/Non-Routine
 ;;Direct Cost
 ;;Indirect Cost
 ;;Student Expense
 ;;Accrediting Org
 ;;Contact Hours
