QAMAUTO7 ;HISC/DAD-AUTO ENROLL PROCESS FALLOUTS ;8/26/93  13:21
 ;;1.0;Clinical Monitoring System;;09/13/1993
 S DUPLICAT(0)=0,^UTILITY($J,"QAM FALL OUT",QAMD0,QAMDFN,QAMEVENT)=""
 I $D(^QA(743.1,"AA",QAMD0,QAMEVENT,QAMDFN)) S DUPLICAT(0)=1
 I 'DUPLICAT F QAMDT=(QAMSTART-.0000001):0 S QAMDT=$O(^QA(743.1,"AB",QAMD0,QAMDFN,QAMDT)) Q:QAMDT'>0!(QAMDT>(QAMEND+.9999999))  S DUPLICAT(0)=1 Q
 I 'DUPLICAT S X=$O(^UTILITY($J,"QAM FALL OUT",QAMD0,QAMDFN,0)) I X,X-QAMEVENT S DUPLICAT(0)=1
 S ^UTILITY($J,"QAM FALL OUT",QAMD0,QAMDFN,QAMEVENT)=$S(DUPLICAT(0):"*",1:"")
 I 'DUPLICAT(0) S QAMFALL=QAMFALL+1 D DATAELEM
EXIT ;
 Q
DATAELEM ; *** PROCESS OTHER DATA TO CAPTURE
 F QAME1=0:0 S QAME1=$O(^QA(743,QAMD0,"DAT",QAME1)) Q:QAME1'>0  F QAME0=0:0 S QAME0=$O(^QA(743,QAMD0,"COND",QAME0)) Q:QAME0'>0  D DE1
 Q
DE1 S COND=$S($D(^QA(743,QAMD0,"COND",QAME0,0))#2:+^(0),1:0),ELEM=$S($D(^QA(743,QAMD0,"DAT",QAME1,0))#2:+^(0),1:0)
 Q:(COND'>0)!(ELEM'>0)!($O(^QA(743.3,COND,"ELEM","B",ELEM,0))'>0)
 F QAMWHEN=0:0 S QAMWHEN=$O(^UTILITY($J,"QAM CONDITION",QAME0,QAMDFN,QAMWHEN)) Q:QAMWHEN'>0  D DE2
 Q
DE2 I QAMCND=QAME0,QAMWHEN'=QAMEVENT Q
 K DA,DIC,DIQ,DR,QAM,QAMELEM S DIC=$S($D(^QA(743.4,ELEM,0))#2:+$P(^(0),"^",3),1:0) Q:DIC'>0  S DIQ(0)="E",DIQ="QAMELEM"
 S QA(0)=^UTILITY($J,"QAM CONDITION",QAME0,QAMDFN,QAMWHEN) F QA=1:1 S X=$P(QA(0),"^",QA) Q:X'>0  S QAM(QA)=X
 Q:$D(QAM)<10  S MAX=0
 F QAME2=0:0 S QAME2=$O(^QA(743.4,ELEM,"DD",QAME2)) Q:QAME2'>0  S X=^QA(743.4,ELEM,"DD",QAME2,0),QAMDD=+X,QAMFLD=+$P(X,"^",2),QAMLEVL=+$P(X,"^",3) D DE3
 D EN^DIQ1 ; *** S QAMELEM(file#,DA,field#,"E") = EXTERNAL DATA FORMAT
 S X=$S($D(QAMELEM(QAMDD("MAX"),QAMDA("MAX"),QAMFLD("MAX"),"E"))#2:QAMELEM(QAMDD("MAX"),QAMDA("MAX"),QAMFLD("MAX"),"E"),1:"")
 I X]"",$S($D(^DD(QAMDD("MAX"),QAMFLD("MAX"),0))#2:$P(^(0),"^",2),1:"")["D" K %DT S %DT="ST" D ^%DT X ^DD("DD") S X=Y ; *** REFORMAT DATE
 ;  NEW STUFF :X]""
 I $D(^UTILITY($J,"QAM FALL OUT",QAMD0,QAMDFN,QAMEVENT,ELEM))[0 S ^(ELEM)=X
 E  S:X]"" ^UTILITY($J,"QAM FALL OUT",QAMD0,QAMDFN,QAMEVENT,ELEM)=X
 Q
DE3 I QAMLEVL=1 S (DA,QADA)=$S($D(QAM(QAMLEVL))#2:QAM(QAMLEVL),1:0),DR=QAMFLD
 E  S (DA(QAMDD),QADA)=$S($D(QAM(QAMLEVL))#2:QAM(QAMLEVL),1:0),DR(QAMDD)=QAMFLD
 I QAMLEVL>MAX S QAMFLD("MAX")=QAMFLD,QAMDA("MAX")=QADA,QAMDD("MAX")=QAMDD,MAX=QAMLEVL
 Q
