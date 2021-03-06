XDRRMRG1	;SF-IRMFO.SEA/JLI - DUP VERIFICATION FOR ANCILLARY SERVICES ;10/21/2010
	;;7.3;TOOLKIT;**23,29,46,47,49,126**;Apr 25, 1995;Build 2
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
EN	;
	I '$D(XQADATA) Q
	N OVERWRIT,XDRDA,DFNFR,DFNTO,DFNFRX,DFNTOX,REVIEW,XDRGL,PRIFILE ; MODIFIED 03/28/00
	S REVIEW=0
	S XDRGL=$P($P($G(^VA(15,+XQADATA,0)),U),";",2) Q:XDRGL=""  S XDRGL=U_XDRGL S PRIFILE=+$P(@(XDRGL_"0)"),U,2) ; MODIFIED 03/28/00
	S XDRDA=$P(XQADATA,U)
	S DFNFR=$P(XQADATA,U,2)
	S (DFNTOX,DFNTO)=$P(DFNFR,";",2)
	S (DFNFRX,DFNFR)=$P(DFNFR,";")
	S PACKAGE=$P(XQADATA,U,3)
	S SUBFILES=$P(XQADATA,U,5)
	S SUBNAMES=$P(XQADATA,U,6)
	S XDRFILE=$P(XQADATA,U,4)
	S FILEDIC=^DIC(XDRFILE,0,"GL")_"DFN)"
	I XDRGL="^DPT(" D
	. S DFN=DFNFR D ^VADPT M DFNFR=VADM K VA,VADM
	. S DFN=DFNTO D ^VADPT M DFNTO=VADM K VA,VADM
	I XDRFILE=63 D
	. S DFNFR=$G(^DPT(DFNFR,"LR"))
	. S DFNTO=$G(^DPT(DFNTO,"LR"))
	I DFNFR'>0!(DFNTO'>0) W !,$C(7),"NO DATA TO REVIEW....",!! Q
LDATE	F XDRI=1,2 S DFN=$S(XDRI=1:DFNFR,1:DFNTO) S DFNNAM=$S(XDRI=1:"DFNFR",1:"DFNTO") D
	. S I=5 F  S I=$O(@DFNNAM@(I)) Q:I=""  K @DFNNAM@(I)
	. F ISUBS=1:1 S SUBSCR=$P(SUBFILES,";",ISUBS) Q:SUBSCR=""  D
	. . S XX=$G(^DD(XDRFILE,SUBSCR,0))
	. . I $P(XX,U,2)'["D" Q
	. . I $P($P(XX,U,4),";",2)'=0 Q
	. . S SUBSCR=$P($P(XX,U,4),";")
	. . N XDAT1 S XDAT1=0
	. . I DFN>0 F I=0:0 S I=$O(@FILEDIC@(SUBSCR,I)) Q:I'>0  D
	. . . S X=$P($G(@FILEDIC@(SUBSCR,I,0)),U)
	. . . I X<DT,X>XDAT1 S XDAT1=X
	. . S LASTNAM="LAST "_$P(SUBNAMES,";",ISUBS)
	. . S @DFNNAM@(LASTNAM)=""
	. . I XDAT1>0 S @DFNNAM@(LASTNAM)=$$FMTE^XLFDT(XDAT1\1)
	. I @DFNNAM'="",'$D(@FILEDIC) S @DFNNAM=""
	D SHOW
	S:XDRFILE'=63 DFNFR=DFNFRX,DFNTO=DFNTOX ;REM - LAB is handled differently
	I IOST'["C-" Q
	D CHK
	Q
	;
SHOW	;
	N NAMIEN1,NAMIEN2
	S N1=$$COUNT^XDRRMRG2(XDRFILE,DFNFRX,DFNTOX)
	W @IOF I N1>0,PACKAGE="PRIMARY" W !,"         RECORD"_N1_" contains fewer data elements, usually this would indicate",!,"                 that this record would be merged INTO the other."
	;S LABEL(1)="NAME",LABEL(2)="SSN",LABEL(3)="BIRTH DATE"
	;S LABEL(4)="AGE",LABEL(5)="SEX",LABEL("LASTDAT")="LAST DATE"
	W !!,"Determine if these entries ARE or ARE NOT duplicates."
	W !
	;REM - Modified next three lines to include IENs by patient name.
	I XDRFILE=63 S NAMIEN1=$$LABIEN^XDRRMRG2(XDRFILE,DFNFR),NAMIEN2=$$LABIEN^XDRRMRG2(XDRFILE,DFNTO)
	;W !,?20,$S(PACKAGE="PRIMARY":"RECORD1 [#"_DFNFR_"]",PACKAGE="LABORATORY":"MERGE FROM [#"_NAMIEN1_"]",1:"MERGE FROM [#"_DFNFR_"]")
	;W ?45,$S(PACKAGE="PRIMARY":"RECORD2 [#"_DFNTO_"]",PACKAGE="LABORATORY":"MERGE TO [#"_NAMIEN2_"]",1:"MERGE TO [#"_DFNTO_"]")
	;S I="" F  S I=$O(DFNFR(I)) Q:I=""  D
	;. I DFNFR(I)=""&(DFNTO(I)="") Q
	;. S DFNFR(I)=$S($P(DFNFR(I),U,2)'="":$P(DFNFR(I),U,2),1:$P(DFNFR(I),U))
	;. S DFNTO(I)=$S($P(DFNTO(I),U,2)'="":$P(DFNTO(I),U,2),1:$P(DFNTO(I),U))
	;. W !,$S($D(LABEL(I)):LABEL(I),1:I),?20,$E(DFNFR(I),1,20),?45,$E(DFNTO(I),1,20)
	;. I I=1!(I=5) W !
	;I DFNFR=""!(DFNTO="") D
	;. I DFNFR=""&(DFNTO="") W !!,"There is NO DATA in the "_PACKAGE_" file for either entry." Q
	;. I DFNFR="" W !!,"There is NO DATA in the "_PACKAGE_" file for (",DFNFRX,")  ",DFNFR(1),"   ",DFNFR(2)
	;. I DFNTO="" W !!,"There is NO DATA in the "_PACKAGE_" file for (",DFNTOX,")  ",DFNTO(1),"   ",DFNTO(2)
	;S DIR(0)="E" D ^DIR K DIR Q:$D(DIRUT)
	;I DFNFR=""!(DFNTO="") Q
	;S DIT(1)=DFNFR,DIT(2)=DFNTO,IOP=IO(0),DFF=XDRFILE,DIC=XDRFILE
	D SHOW^XDRDSHOW(XDRFILE,DFNFR,DFNTO,.OVERWRIT,REVIEW) ;D EN^DITC K IOP
	Q
	;
CHK	;
	N DIR
CHK1	K DIR
	S DIR(0)="S^V:VERIFIED DUPLICATE;N:VERIFIED, NOT A DUPLICATE;U:UNABLE TO DETERMINE;H:HEALTH SUMMARY;R:REVIEW DATA AGAIN;S:SELECT/REVIEW OVERWRITES",DIR("A")="Select Action",DIR("B")="HEALTH SUMMARY"
	D ^DIR K DIR S XDRY=Y I $D(DIRUT) K XQAKILL Q
	I XDRY="R" S REVIEW=0 D SHOW G CHK1
	I XDRY="S" S REVIEW=1 D SHOW G CHK1
	I XDRY'="H" D  Q
	. K XQAKILL
	. I XDRY'="^" D
	. . S XQAKILL=$S(XDRY'="U":0,1:1)
	. . S XDRDIR=""
	. . I XDRY="V" D VERWARN ;p126-REM
	. . I XDRY="V",PACKAGE="PRIMARY" D
	. . . S DIR=0 F DFN=DFNFRX,DFNTOX I $D(@FILEDIC) S DIR=DIR+1
	. . . I DIR'>1 K DIR Q  ; DON'T NEED TO SELECT DIRECTION UNLESS DATA IN BOTH ENTRIES
	. . . S DIR("B")=$$COUNT^XDRRMRG2(XDRFILE,DFNFRX,DFNTOX)
	. . . S DIR("B")=$S(DIR("B")'>1:"RECORD1 INTO RECORD2",1:"RECORD2 INTO RECORD1")
	. . . I DIR("B")=0 K DIR("B")
	. . . S DIR(0)="S^1:RECORD1 INTO RECORD2;2:RECORD2 INTO RECORD1"
	. . . W !!!,?20,"RECORD1 [#"_DFNFR_"]",?45,"RECORD2 [#"_DFNTO_"]"
	. . . W !,?20,DFNFR(1),?45,DFNTO(1)
	. . . S DIR("A")="Which record (1 or 2) should be MERGED INTO the other record"
	. . . D ^DIR K DIR I Y>0 S XDRDIR=+Y
	. . . I $D(DIRUT) S XDRY="^" W !!!,$C(7),"VERIFICATION ABORTED!",! Q
	. . . I DFNFRX'=+^VA(15,XDRDA,0) S XDRDIR=$S(XDRDIR'>0:2,XDRDIR=1:2,1:1)
	. . N XDRFDA,XDRDA1
	. . S XDRDA1=$$FIND1^DIC(15.02,","_XDRDA_",","X",PACKAGE)
	. . S XDRDA1=$S(XDRDA1>0:XDRDA1_",",1:"+1,")_XDRDA_","
	. . S XDRFDA(15.02,XDRDA1,.01)=PACKAGE
	. . S XDRFDA(15.02,XDRDA1,.02)=XDRY
	. . S XDRFDA(15.02,XDRDA1,.03)=DUZ
	. . S XDRFDA(15.02,XDRDA1,.04)=$$NOW^XLFDT()
	. . I XDRDIR'="" S XDRFDA(15.02,XDRDA1,.05)=XDRDIR
	. . D UPDATE^DIE("S","XDRFDA")
	. . ;
	. . I $D(OVERWRIT)!(XDRDIR=2&(PACKAGE'="PRIMARY")) D
	. . . N I
	. . . S XDRDA1=$$FIND1^DIC(15.03,","_XDRDA_",","X",XDRFILE)
	. . . I XDRDA1'>0 D
	. . . . S XDRDA1="+1,"_XDRDA_","
	. . . . K XDRFDA,XDRDAX
	. . . . S XDRDAX(1)=XDRFILE
	. . . . S XDRFDA(15.03,XDRDA1,.01)=XDRFILE
	. . . . I XDRDIR=2,PACKAGE'="PRIMARY" D
	. . . . . S XDRFDA(15.03,XDRDA1,.02)=2
	. . . . D UPDATE^DIE("S","XDRFDA","XDRDAX")
	. . . . S XDRDA1=XDRDAX(1)
	. . . S XDRDA1="+1,"_XDRDA1_","_XDRDA_","
	. . . F I=0:0 S I=$O(OVERWRIT(I)) Q:I'>0  D
	. . . . K XDRFDA,XDRDAX
	. . . . S XDRDAX(1)=I
	. . . . S XDRFDA(15.031,XDRDA1,.01)=I
	. . . . D UPDATE^DIE("S","XDRFDA","XDRDAX")
	. I XDRY="V" D
	. . D CHEKVER
	. I XDRY="N" D
	. . S XDRAID=$G(XQAID) N XQAID,I
	. . F I=0:0 S I=$O(^VA(15.1,PRIFILE,2,I)) Q:I'>0  D  ; MODIFIED 03/28/00
	. . . S XQAID=$P(XDRAID,",",1,2)_","_I
	. . . S XQAKILL=0
	. . . D DELETEA^XQALERT
	. . N XDRFDA
	. . S XDRFDA(15,XDRDA_",",.03)="N"
	. . S XDRFDA(15,XDRDA_",",.07)=$$NOW^XLFDT()
	. . S XDRFDA(15,XDRDA_",",.11)=DUZ
	. . D UPDATE^DIE("S","XDRFDA")
	S ABORT=0 D ASK^XDRRMRG2(.QLIST,.ABORT) ;REM -Reset ABORT to 0
	;
	;For health summary, user has the option of using the Browser to view 
	;both records or use may select any other device for each record.
	;
	I '$G(ABORT) D PRINT2^XDRRMRG2
	D HOME^%ZIS
	G CHK1
	Q
	;
CHEKVER	;
	N R
	S XVER=1
	F I=0:0 S I=$O(^VA(15.1,PRIFILE,2,I)) Q:I'>0  D  Q:'XVER  ; MODIFIED 03/28/00
	. S X1=+$P(^VA(15.1,PRIFILE,2,I,0),U,2) ; MODIFIED 03/28/00
	. S XN=$P(^VA(15.1,PRIFILE,2,I,0),U) ; MODIFIED 03/28/00
	. I X1>0 D
	. . F R=1,5,6,7,0 I $O(^XMB(3.8,X1,R,0))>0 Q  ;REM -changed I to R in FOR loop 
	. . I R'>0 S X1=0
	. I X1'>0,$O(^VA(15.1,PRIFILE,2,I,1,0))'>0 Q  ; MODIFIED 03/28/00
	. S X1=$$FIND1^DIC(15.02,","_XDRDA_",","X",XN)
	. S XVER=$S(X1'>0:0,$P(^VA(15,XDRDA,2,X1,0),U,2)="V":1,$P(^(0),U,2)="D":1,1:0)
	I XVER D FINALVER^XDRVCHEK(XDRDA)
	Q
	;
SETUP(XDRDA)	;
	N XDRGRPN,XDRSSN,XDRFILE
	S X=^VA(15,XDRDA,0)
	I $P($G(^VA(15,XDRDA,2,1,0)),U,5)=2 S DFNTO=+X,DFNFR=+$P(X,U,2)
	E  S DFNFR=+X,DFNTO=+$P(X,U,2)
	S XDRFILE=$P($P(X,U),";",2),XDRFILE=+$P(@(U_XDRFILE_"0)"),U,2)
	F XDRAID=0:0 S XDRAID=$O(^VA(15.1,PRIFILE,2,XDRAID)) Q:XDRAID'>0  D  ; MODIFIED 03/28/00
	. S XDRNODE=^VA(15.1,PRIFILE,2,XDRAID,0) ; MODIFIED 03/28/00
	. S XDRNOD2=$G(^VA(15.1,PRIFILE,2,XDRAID,2)) ; MODIFIED 03/28/00
	. S XDRNAME=$P(XDRNODE,U)
	. S XDRGRP=$P(XDRNODE,U,2)
	. S:XDRGRP>0 XDRGRPN=$$GET1^DIQ(3.8,XDRGRP,.01) ;REM -8/2/96 Get the name of mail group
	. S XDRGRP=$S(XDRGRP>0:"G."_XDRGRPN,1:"")
	. S XDRFILE=$P(XDRNODE,U,3) D  Q:'$D(XDRNODE)
	. . N XDRDIC,XDRFR,XDRTO
	. . S XDRDIC=^DIC(XDRFILE,0,"GL")
	. . S XDRFR=$S(XDRFILE'=63:DFNFR,1:$G(^DPT(DFNFR,"LR")))
	. . S XDRTO=$S(XDRFILE'=63:DFNTO,1:$G(^DPT(DFNTO,"LR")))
	. . I XDRFR'>0!(XDRTO'>0) K XDRNODE
	. . I $D(XDRNODE),'$D(@(XDRDIC_XDRFR_",0)"))!'$D(@(XDRDIC_XDRTO_",0)")) K XDRNODE
	. . I '$D(XDRNODE) D
	. . . N XDRARR I $$FIND1^DIC(15.02,","_XDRDA_",","X",XDRNAME)>0 Q
	. . . S XDRARR(15.02,"+1,"_XDRDA_",",.01)=XDRNAME
	. . . S XDRARR(15.02,"+1,"_XDRDA_",",.02)="D"
	. . . D UPDATE^DIE("","XDRARR")
	. S XQADATA=XDRDA_U_DFNFR_";"_DFNTO_U_XDRNAME_U_XDRFILE_U_$P(XDRNOD2,U)_U_$P(XDRNOD2,U,2)
	. ;S R(1)=XDRDA_U_DFNFR_";"_DFNTO_U_XDRNAME_U_XDRFILE_U_$P(XDRNOD2,U)_U_$P(XDRNOD2,U,2)
	. D SETARY^XDRRMRG0 S XMTEXT="R("
	. S:XDRGRP'="" XMY(XDRGRP)=""
	. F I=0:0 S I=$O(^VA(15.1,PRIFILE,2,XDRAID,1,I)) Q:I'>0  S X=^(I,0) D
	. . S XQA(X)=""
	. D SEND^XDRRMRG0 K R
	Q
VERWARN	;Warning message when ready to Verified Dupicates; p126-REM
	W !!,"*** WARNING!!!  You have verified these two records are the SAME"
	W !,"patient.  Once these records are merged, there is no automated way to"
	W !,"""un-do"" the merge.  If you are not certain these are the same patient,"
	W !,"edit the status back to 'Potential Duplicate, Unverified' and repeat the"
	W !,"verification process.  For additional assistance, please log a NOIS/Remedy"
	W !,"ticket. ***"
	W !!
	Q
