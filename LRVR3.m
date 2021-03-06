LRVR3	;DALOI/STAFF - LAB ROUTINE DATA VERIFICATION ;5/31/12  9:39
	;;5.2;LAB SERVICE;**42,121,153,286,291,350**;Sep 27, 1994;Build 230
	;
	D V1
	I $D(LRLOCKER)#2 L -@(LRLOCKER) K LRLOCKER
	K LRSA,LRSB,LRNOVER,LRSBCOM,LRLKOK
	; Leave LRVR3, back to LRVR2
	Q
	;
	;
V1	;
	;
	; Warn and prompt if it appears user is entering reference lab result and message came from auto instrument (UI type=1)
	I $G(LRDUZ(2)),LRDUZ(2)'=DUZ(2),$P($G(^LAH(LRLL,1,LRSQ,0)),"^",12)=1,'$$UICHK Q
	;
	;
	S LRTN=1
	I $D(LRLOCKER)#2 L -@(LRLOCKER)
	S LRLOCKER="^LR("_LRDFN_","""_LRSS_""","_LRIDT_")"
	L +@(LRLOCKER):DILOCKTM
	I '$T W !," This entry is being edited by someone else." Q
	; LRNOVER set in LRVR2
	K LRLKOK D LINK Q:'$D(LRLKOK)  K LRLKOK D LKCHK Q:'$D(LRLKOK)
	K LRSA,LRSB,LRSBCOM,LRSBEPR
	;
	; Calculate days back for delta check based on specimen collection date/time.
	S LRTM60=$$LRTM60^LRVR(LRCDT)
	;
	S LRCMTDSP=$$CHKCDSP^LRVERA
	N LRX
	S LRX=1
	F  S LRX=$O(^LAH(LRLL,1,LRSQ,LRX)) Q:LRX<1  D
	. S LRSB(LRX)=^LAH(LRLL,1,LRSQ,LRX)
	. I $D(LRNOVER),$D(LRVTS(LRX)),$D(^TMP("LR",$J,"TMP",LRX)) S LRNOVER(LRX)=""
	; Copy comments from LAH
	S LRX=0
	F  S LRX=$O(^LAH(LRLL,1,LRSQ,1,LRX)) Q:LRX=""  S LRSBCOM(LRX)=^(LRX)
	;
	; Copy filler id associated with each dataname from LAH.
	M LRSBEPR=^LAH(LRLL,1,LRSQ,.1,"OBR","FID")
	;
	;
EDIT	;
	I $D(^LAH(LRLL,1,LRSQ,0)) D
	. N X
	. S LREDIT=1
	. F LRX=0,.1,.3 M X(LRX)=^LAH(LRLL,1,LRSQ,LRX)
	. K ^LAH(LRLL,1,LRSQ),LRNUF
	. F LRX=0,.1,.3 M ^LAH(LRLL,1,LRSQ,LRX)=X(LRX) K X(LRX)
	. D ^LRVR4
	. F LRX=1:0 S LRX=$O(LRSB(LRX)) Q:LRX<1  S ^LAH(LRLL,1,LRSQ,LRX)=LRSB(LRX)
	I $O(^LAH(LRLL,1,LRSQ,1))<1 W !,"NO DATA TO APPROVE" Q
	Q:$D(LRGVP)
	;
	N LRI
	S LRI=1
	F  S LRI=$O(LRNOVER(LRI)) Q:LRI=""  D
	. N LRX,LRERR
	. S LRX="Test Not Reviewed: "_$$GET1^DID(63.04,LRI,"","LABEL","","LRERR")
	. I $G(LRERR("DIERR",1)) W !,"For DATANAME "_LRI_" - "_LRERR("DIERR",1,"TEXT",1) Q
	. W !,LRX
	. I $D(LRSB(LRI))#2 W " = "_$P(LRSB(LRI),U)_" "_$P(LRSB(LRI),U,2)
	I $O(LRNOVER(0)) W !,"Have not been reviewed and have data.  Not approved." QUIT
	;
	I '$P($G(LRLABKY),U) W !,$C(7),"ENTERED BUT NOT APPROVED" QUIT
	;
	N CNT S CNT=1
	;
AGAIN	;
	R !,"Approve for release by entering your initials: ",LRINI:DTIME
	I $E(LRINI)="^" W !!?5,$C(7),"Nothing verified!" D READ Q
	I LRINI'=LRUSI,$$UP^XLFSTR(LRINI)=$$UP^XLFSTR(LRUSI) S LRINI=LRUSI
	I $S($E(LRINI)="?":1,LRINI'=LRUSI&(CNT<2):1,1:0) W !,$C(7),"Please enter your correct initials" S:$E(LRINI)="?" CNT=0 S CNT=CNT+1 G AGAIN
	I LRINI'=LRUSI W !!?5,$C(7),"Nothing verified!" D READ Q
	;
	D V11
	D ASKXQA^LRVER3
	Q
	;
	;
V11	; Still locked from V1 L ^LR(LRDFN,LRSS,LRIDT)
	;   Set filler id as external package reference for each data name
	N LRCORECT,LRNOW,LRX
	S (LRCORECT,LRX)=0,LRNOW=$$NOW^XLFDT
	F  S LRX=$O(^TMP("LR",$J,"TMP",LRX)) Q:LRX<1  I $D(LRVTS(LRX)),$D(LRSB(LRX)),$D(^(LRX)) D
	. K ^LAH(LRLL,1,LRSQ,LRX)
	. I $P(LRSB(LRX),"^")="" Q
	. S $P(LRSB(LRX),U,6)=LRNOW
	. S ^LR(LRDFN,LRSS,LRIDT,LRX)=LRSB(LRX)
	. S:'$D(^LRO(68,"AC",LRDFN,LRIDT,LRX)) ^(LRX)="" I LRVF S ^(LRX)=""
	. I $G(LRSBEPR(LRX))="" Q
	. N LRDATA,LRSITE
	. S LRSITE=$G(LRDUZ(2))
	. I LRSITE="" S LRSITE=$P(LRSB(LRX),"^",9)
	. S LRDATA(.01)=LRDFN_","_LRSS_","_LRIDT_","_LRX,LRDATA(.02)=4,LRDATA(1)=LRSBEPR(LRX)
	. I LRSITE'="" S LRDATA(.03)=LRSITE_";DIC(4,"
	. D SETREF^LRUEPR(LRDFN,LRDATA(.01),.LRDATA,1)
	;
A3	; Called from LRVRPOC
	;
	; Set reporting site in file #63.
	D SETRL^LRVERA(LRDFN,LRSS,LRIDT,DUZ(2))
	;
	I +LRDPF=2&($G(LRSS)'="BB")&('$$CHKINP^LRBEBA4(LRDFN,LRODT)) D
	. D BAWRK^LRBEBA(LRODT,LRSN,1,.LRBEY,.LRBETST)
	;
	D VER^LRVER3A ;unlocked in LRVER
	;
	; Check for LEDI and return results
	I $P($G(LRORU3),U,3),$O(LRSB(0)) D LRORU3^LRVER3
	;
	K LRSBCOM
	D:$P(LRPARAM,U,14)&($P($G(^LRO(68,LRAA,0)),U,16)) LOOK^LRCAPV1
	;
	; Check for LEDI tests not reviewed
	I $G(LRDUZ(2)),LRDUZ(2)'=DUZ(2),LRSS="CH",'$D(ZTQUEUED) D TNR
	;
	I +$O(^LAH(LRLL,1,LRSQ,1))<1 D ZAPALL(LRLL,LRSQ)
	I $D(LRPRGSQ),'$D(ZTQUEUED) D
	. W !,"Purge data from sequence number(s): "
	. F I=0:0 S I=$O(LRPRGSQ(I)) Q:I<1  W " ",I
	. S %=2 D YN^DICN Q:%'=1
	. N LAIEN
	. S LAIEN=0
	. F  S LAIEN=$O(LRPRGSQ(LAIEN)) Q:LAIEN<1  D ZAPALL(LRLL,LAIEN)
	Q
	;
	;
ZAP	; from LRLLS3
	D ZAPALL(LRLL,I)
	Q
	;
	;
LINK	; Check and save link
	D LKCHK Q:$D(LRLKOK)
	S X=$S($D(^LRO(68,+$P(LRLK,U,3),1,+$P(LRLK,U,4),1,+$P(LRLK,U,5),0)):+^(0),1:"") G LINKOK:+X=LRDFN
	S S1=PNM,S2=SSN,S3=LRDPF
	;
	W !,$C(7),"WARNING - NO MATCHING ACCESSION WAS FOUND."
	W !,"You may need to Clear instrument/worklist data,"
	W !,"or correctly identify the sample to the system."
	;
	I X S LRDPF=$P(^LR(X,0),U,2),DFN=$P(^(0),U,3) D PT^LRX W !,PNM,?30,SSN,!,$C(7) S PNM=S1,SSN=S2,LRDPF=S3
	K S1,S2,S3
	Q:$D(LRGVP)
	W !,"ARE YOU SURE THIS IS THE CORRECT DATA" S %=2 D YN^DICN Q:%'=1
	;
LINKOK	;
	K:$P(LRLK,U,5) ^LAH(LRLL,1,"C",+$P(LRLK,U,5),LRSQ)
	S ^LAH(LRLL,1,"C",LRAN,LRSQ)="",$P(^LAH(LRLL,1,LRSQ,0),U,3,5)=LRAA_U_LRAD_U_LRAN,LRLKOK=1
	Q
	;
LKCHK	S LRLK=$S($D(^LAH(LRLL,1,LRSQ,0)):^(0),1:"") I $P(LRLK,U,3)=LRAA&($P(LRLK,U,4)=LRAD)&($P(LRLK,U,5)=LRAN) S LRLKOK=1
	Q
	;
	;
ZAP2	;Clear ^LAH(
	D ZAPALL(LRLL,I)
	Q
	;
	;
ZAPALL(LRLL,LAIEN)	;Clean up
	N I,NODE,SEG,SUB
	Q:'$G(LRLL)!('$G(LAIEN))
	;
	S NODE=$G(^LAH(LRLL,1,LAIEN,0))
	K ^LAH(LRLL,1,"B",+$P(NODE,U)_";"_+$P(NODE,U,2),LAIEN)
	K ^LAH(LRLL,1,"C",+$P(NODE,U,5),LAIEN)
	K ^LAH(LRLL,1,"D",+$P(NODE,U,6),LAIEN)
	K ^LAH(LRLL,1,"E",+$P(NODE,U,8),LAIEN)
	;
	S NODE("U")=$P($G(^LAH(LRLL,1,LAIEN,.3)),U)
	I NODE("U")'="" D
	. K ^LAH(LRLL,1,"U",NODE("U"),LAIEN)
	. S I=0
	. F  S I=$O(^LAH("LA7 AMENDED RESULTS",NODE("U"),I)) Q:'I  D
	. . K ^LAH("LA7 AMENDED RESULTS",NODE("U"),I,LRLL,LAIEN)
	;
	S SEG=""
	F  S SEG=$O(^LAH(LRLL,1,LAIEN,.1,SEG)) Q:SEG=""  D
	. S SEGID=""
	. F  S SEGID=$O(^LAH(LRLL,1,LAIEN,.1,SEG,SEGID)) Q:SEGID=""  D
	. . S SUB=$P($G(^LAH(LRLL,1,LAIEN,.1,SEG,SEGID)),U)
	. . I SUB'="" K ^LAH(LRLL,1,"A"_SEGID,SUB,LAIEN)
	;
	K ^LAH(LRLL,1,LAIEN)
	;
	; Reset counter if loadlist is clear.
	I '$O(^LAH(LRLL,1,0)) D
	. L +^LAH(LRLL):DILOCKTM Q:'$T
	. S ^LAH(LRLL)=0
	. L -^LAH(LRLL)
	;
	Q
	;
	;
TNR	; List tests not reviewed and ask if user wants to delete.
	;
	N DIR,DIROUT,DIRUT,DUOUT,LR60,I,X,Y
	;
	; Check if these results have already been verified
	S I=1
	F  S I=$O(^LAH(LRLL,1,LRSQ,I)) Q:'I  D
	. S X=^LAH(LRLL,1,LRSQ,I)
	. I $P(X,"^")=$P($G(^LR(LRDFN,LRSS,LRIDT,I)),"^") K ^LAH(LRLL,1,LRSQ,I)
	;
	; Quit if no unreviewed results
	I +$O(^LAH(LRLL,1,LRSQ,1))'>1 Q
	;
	W !,"Test(s) Not Reviewed:",!
	S I=1
	F  S I=$O(^LAH(LRLL,1,LRSQ,I)) Q:'I  D
	. S X=^LAH(LRLL,1,LRSQ,I)
	. S LR60=+$O(^LAB(60,"C","CH;"_I_";1",0))
	. I LR60 W $$GET1^DIQ(60,LR60_",",.01)
	. E  W $$GET1^DID(63.04,I,"","LABEL")
	. W " = "_$P(X,"^")_" "_$P(X,"^",2)_"  "_$P($P(X,"^",5),"!",7),!
	;
	S DIR(0)="Y",DIR("A")="Purge these test results",DIR("B")="NO"
	S DIR("?",1)="Answer 'NO' if you want to keep these results for later verification."
	S DIR("?",2)="You may need to add these tests to the loadlist profile you are using"
	S DIR("?")="and/or add these tests to the accession you are verifying."
	D ^DIR Q:$D(DIRUT)
	;
	I Y=1 D ZAPALL(LRLL,LRSQ)
	Q
	;
	;
READ	;
	N X W !!,"Press ENTER or RETURN to continue: " R X:DTIME
	Q
	;
	;
UICHK()	; Confirm that user wants to process UI type results as reference lab results.
	;
	N DIR,DIRUT,DTOUT,DUOUT,LROK,X,Y
	;
	S LROK=0
	S DIR(0)="YO",DIR("B")="NO"
	S DIR("A",1)="These results were received via an automated instrument interface and you've"
	S DIR("A",2)="indicated you're processing reference lab results. If you continue processing"
	S DIR("A",3)="then only units and reference ranges received from the instrument will be"
	S DIR("A",4)="stored. This could result in the report lacking units, reference ranges,"
	S DIR("A",5)="abnormality flags and designating an incorrect performing lab."
	S DIR("A",6)=" "
	S DIR("A",7)="Contact your local LIM or Lab ADPAC with any questions."
	S DIR("A",8)=" "
	S DIR("A")="Sure you want to continue"
	D ^DIR
	I Y=1 S LROK=1
	;
	Q LROK
