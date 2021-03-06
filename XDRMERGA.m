XDRMERGA	;SF-IRMFO.SEA/JLI - START OF NON-INTERACTIVE BATCH MERGE ;01/31/2000  09:14
	;;7.3;TOOLKIT;**23,28,37,40,45,137**;Apr 25, 1995;Build 10
	;;
	Q
APPROVE	; This is the entry point for approving a duplicate pair for merge
	K DIRUT,DUOUT,DTOUT ;
	D EN^XDRVCHEK ; update verified and/or ready to merge statuses if necessary
	;
	N XDRXX,XDRYY,XDRMA,DIE,DIC,DIR,DR,ZTDTH,ZTSK
	N XDRX,XDRY,XDRFIL,XDRGLOB,X,Y,XDRNAME
	N XDRFDA,XDRIENS,XDRI,XDRJ,XDRK,DA,DIK
	;
	S XDRFIL=$$FILE^XDRDPICK() Q:XDRFIL'>0
	S XDRDIC=^DIC(XDRFIL,0,"GL")
	S XDRGLOB=$E(XDRDIC,2,999)
	S X=""
	S XNCNT=0,XNCNT0=0
	F  S X=$O(^VA(15,"AVDUP",XDRGLOB,X)) Q:X=""  S Y=$O(^(X,0)) D
	. N YVAL S YVAL=^VA(15,Y,0)
	. I $P(YVAL,U,20)>0 Q  ; ALREADY DONE OR SCHEDULED
	. I $P(YVAL,U,3)'="V" Q  ; TAKE ONLY VERIFIED
	. I $P(YVAL,U,5)'=1 Q  ; TAKE ONLY IF MARKED READY TO MERGE
	. I $P(YVAL,U,4)="" D  Q  ; MAKE SURE MERGE DIRECTION IS DEFINED
	. . W !,"Entry `",Y," DOES NOT HAVE MERGE DIRECTION DEFINED - CAN'T APPROVE"
	. . N XDRDICA S XDRDICA=U_$P($P(YVAL,U),";",2)
	. . I '$D(@(XDRDICA_(+YVAL)_",0)"))!$D(@(XDRDICA_(+YVAL)_",-9)"))!'$D(@(XDRDICA_(+$P(YVAL,U,2))_",0)"))!$D(@(XDRDICA_(+$P(YVAL,U,2))_",-9)")) D  Q
	. . . D RESET^XDRDPICK(Y)
	. I $P(YVAL,U,13)'>0 D
	. . I $P(YVAL,U,4)'=2 S XDRY(+YVAL,+$P(YVAL,U,2))=Y
	. . E  S XDRY(+$P(YVAL,U,2),+YVAL)=Y
	. . S XNCNT0=XNCNT0+1
	I XNCNT0>0 W !!,XNCNT0,"  Entries are awaiting approval for merging  Return to continue..." R X:DTIME
	I $D(XDRY) D CHKBKUP I $D(DUOUT)!$D(DTOUT) Q
	K XDRY
	Q
	;
STOP	;
	N XDRI,DIE,DA,DR,DIR,XDRC
	S XDRC=0 F XDRI=0:0 S XDRI=$O(^VA(15.2,XDRI)) Q:XDRI'>0  I $P(^(XDRI,0),U,4)="A" D
	. S XDRC=XDRC+1
	. S DIR(0)="Y",DIR("A")="Do you want to stop "_$P(^VA(15.2,XDRI,0),U)
	. D ^DIR K DIR I Y'>0 Q
	. S DIE="^VA(15.2,",DA=XDRI,DR=".09///1" D ^DIE
	. K DIE,DR
	I XDRC'>0 W !!,$C(7),"No active merge processes were found.",!!
	Q
	;
CHKBKUP	; Check if backups have been generated for outstanding pairs
	N I,J,X,Y,X1,X2,XNCNT,I,J,K,L,M,N,XX
	K DIR
	;S DIR("A")="Do you want to check pairs awaiting backups (Y/N)"
	;S DIR("?")="Indication that a backup of the data for the entries for a duplicate pair is required prior to merging the entries.  You may review entries to see if any should be marked as completed."
	;S DIR(0)="Y" D ^DIR K DIR Q:Y'>0
	S ASKNAME="ASK1" D CHECK
	Q
	;
CHECK	;
	W @IOF
	S XNCNT=0
	F I=0:0 S I=$O(XDRY(I)) Q:I'>0  D  Q:$D(DUOUT)!$D(DTOUT)
	. F J=0:0 S J=$O(XDRY(I,J)) Q:J'>0  D  Q:$D(DUOUT)!$D(DTOUT)
	. . S X01=$G(@(XDRDIC_I_",0)")),X1=$P(X01,U),X1S=$P(X01,U,9),X1S=$E(X1S,1,3)_"-"_$E(X1S,4,5)_"-"_$E(X1S,6,15)
	. . S X02=$G(@(XDRDIC_J_",0)")),X2=$P(X02,U),X2S=$P(X02,U,9),X2S=$E(X2S,1,3)_"-"_$E(X2S,4,5)_"-"_$E(X2S,6,15)
	. . I X1=""!(X2="") K XDRY(I,J) Q
	. . F  Q:X1'["MERGING INTO"  S X1=$P($P(X1,"(",2,10),")",1,$L(X1,")")-1)
	. . S XNCNT=XNCNT+1,XX(XNCNT)=I_U_J
	. . W !!,$J(XNCNT,3),"  ",?8,X1,?42,X1S,?60,"[",I,"]"
	. . W !,?8,X2,?42,X2S,?60,"[",J,"]"
	. . S ^TMP("XDR",$J,XNCNT)=X1_U_X1S_U_I_U_X2_U_X2S_U_J ;LLS 07-NOV-2013 - save for possible verification prompt
	. . I '(XNCNT#6) D @ASKNAME Q:$D(DUOUT)!$D(DTOUT)  W @IOF
	I '($D(DUOUT)!$D(DTOUT)) D @ASKNAME
	Q
	;
ASK1	;
	W ! S DIR(0)="LO^1:"_XNCNT,DIR("A")="Select entries to approve them for merging"
	;W !,"TEST"
	D ^DIR K DIR K DIRUT Q:$D(DUOUT)!$D(DTOUT)
	S K="" F  S K=$O(Y(K)) Q:K=""  S Y=Y(K) K Y(K) D
	. F M=1:1 S N=$P(Y,",",M) Q:N=""  D
	. . S N1=+XX(N),N2=$P(XX(N),U,2)
	. . I $$TESTPAT^VADPT(N1)=1,$$TESTPAT^VADPT(N2)'=1 D  Q:Y'=1  ;LLS - trying to merge test patient into real patient
	. . . N XDRFLDI,XDRPC
	. . . F XDRFLDI=1:1:6 S XDRPC(XDRFLDI)=$P(^TMP("XDR",$J,XNCNT),U,XDRFLDI) ;LLS 07-NOV-2013
	. . . W !!,$J(N,3),"  ",?8,XDRPC(1),?42,XDRPC(2),?60,"[",XDRPC(3),"]" ;LLS 07-NOV-2013
	. . . W !,?8,XDRPC(4),?42,XDRPC(5),?60,"[",XDRPC(6),"]" ;LLS 07-NOV-2013
	. . . W !!!! S DIR(0)="Y^"_XNCNT,DIR("A")="Merge the above pair (a test patient into a real patient) SURE" ;LLS 07-NOV-2013
	. . . D ^DIR K DIR ;LLS 07-NOV-2013
	. . . I Y'=1 W !!,"*****[",XDRPC(3),"] WILL NOT BE MERGED INTO [",XDRPC(6),"]" ;LLS 07-NOV-2013
	. . S (DA,XDRX(N1,N2))=XDRY(N1,N2)
	. . N I,J,K,M,N,N1,N2,X1,X2,X,DIE,DR,Y
	. . S DIE="^VA(15,"
	. . S X=DT,X=$$FMTE^XLFDT(X,"2D")
	. . S X=$P($P(^VA(200,DUZ,0),U),",",2)_" "_$P($P(^(0),U),",")_" (DUZ="_DUZ_") "_X
	. . S DR=".13///1;.14///"_X
	. . D ^DIE
	Q
	;
RESTART	;  Entry point to restart non-completed merges
	N NC,N S NC=0
	F XDRFDA=0:0 S XDRFDA=$O(^VA(15.2,XDRFDA)) Q:XDRFDA'>0  D
	. S X=$P(^VA(15.2,XDRFDA,0),U,4) I X="C"!(X="A") S N=1 D  Q:N=1
	. . F J=0:0 S J=$O(^VA(15.2,XDRFDA,3,J)) Q:J'>0  I "CA"'[$P(^(J,0),U,3) S N=0 Q
	. S NC=NC+1
	. S DIR(0)="Y",DIR("A")="Do you want to RESTART merge process "_$P(^VA(15.2,XDRFDA,0),U),DIR("B")="NO"
	. D ^DIR K DIR Q:Y'>0
	. S ZTRTN="DQ^XDRMERG0",ZTSAVE("XDRFDA")="",ZTIO="NULL"
	. D ^%ZTLOAD I '$D(ZTSK) W !!,$C(7),"RESTART **NOT** QUEUED" Q
	. S $P(^VA(15.2,XDRFDA,0),U,8,9)=ZTSK_U ; SET TASK NUMBER AND REMOVE HALT FLAG IF SET
	. W !,"Restart queued as task ",ZTSK,!
	I NC'>0 W !!,$C(7),"No merge processes found that needed restarting.",!!
	Q
	;
	;
DOSUBS(XDRFROM,XDRTO,IENTOSTR,XDRDASEQ)	;
	N NODEA,SFILE,VALUE,XVALUE,XDRXX,XDRYY,YVALUE,XENTOSTR
	N XDRAA,XDRZZ ; DEBUG STATEMENT
	N XDRALY1,XDRALY2,XDRALY1,XDRALY2,XDRALY1A,XDRALY2A,XDRDUPAF,XDRDUPAT,XDRALYSS,XDRALYNM,XDR1,NODEB ;;LLS 17-OCT-2013 - my new arrays and NODEB was not NEWed and thought it should be
	S SFILE=+$P($G(@(XDRFROM_"0)")),U,2)
	I SFILE'>0 Q  ; NO FILE NUMBER, NOT FILE MANAGER COMPATIBLE
	;
	;LLS 17-OCT-2013 added this section to setup arrays for fix duplicate (same Name & Social Security Number) aliases being merged:
	I $G(FILE)=2,SFILE="2.01" D
	. D GETS^DIQ(FILE,$P(XDRGID,U,2)_",","1*","","XDRALY1") ;Put 'FROM' patient ALIAS data into XDRALY1 array
	. M XDRALY1A=XDRALY1(SFILE) ;strip first subscript
	. D GETS^DIQ(FILE,$P(XDRGID,U,3)_",","1*","","XDRALY2") ;Put 'TO' patient ALIAS data into XDRALY2 array
	. M XDRALY2A=XDRALY2(SFILE) ;strip first subscript
	. S XDR1="" F  S XDR1=$O(XDRALY1A(XDR1)) Q:XDR1=""  D  ;Create new 'FROM' patient alias array subscripted by NAME^SSN
	. . S XDRALYSS=XDRALY1A(XDR1,1),XDRALYNM=XDRALY1A(XDR1,.01)
	. . S XDRDUPAF(XDRALYNM_U_XDRALYSS)=$P(XDR1,",",1) ;'FROM' array format: XDRDUPAF(NAME^SSN)=node
	. S XDR1="" F  S XDR1=$O(XDRALY2A(XDR1)) Q:XDR1=""  D  ;Create new 'TO' patient alias array subscripted by NAME^SSN
	. . S XDRALYSS=XDRALY2A(XDR1,1),XDRALYNM=XDRALY2A(XDR1,.01)
	. . S XDRDUPAT(XDRALYNM_U_XDRALYSS)=$P(XDR1,",",1) ;'TO' array format: XDRDUPAT(NAME^SSN)=node 
	;LLS 17-OCT-2013 end of added section
	;
	I $P($G(^DD(SFILE,.01,0)),U,2)["W" D  Q  ; HANDLE WORD PROCESSING FIELDS
	. N XF,XT S XT=$E(XDRTO,1,$L(XDRTO)-1)_")"
	. I '$D(@XT) D
	. . S XF=$E(XDRFROM,1,$L(XDRFROM)-1)_")"
	. . M @XT=@XF
	. . Q
	. Q
	F NODEA=0:0 S NODEA=$O(@(XDRFROM_NODEA_")")) Q:NODEA'>0  D
	. ;LLS 17-OCT-2013 - the following line of code was added to check patient alias multiple (file #2.01) and
	. ;           skip moving this alias because it already exists in the 'merge to' patient file.
	. ;           XDRDUPAF array contains 'FROM' file aliases and XDRDUPAT contains 'TO' file aliases
	. I SFILE=2.01,$D(XDRDUPAF($P($G(@(XDRFROM_NODEA_",0)"),"*"),U,1,2))),$D(XDRDUPAT($P($G(@(XDRFROM_NODEA_",0)"),"*"),U,1,2))) Q  ;LLS 17-OCT-2013 - added
	. S VALUE=$P($G(@(XDRFROM_NODEA_",0)")),U) ; GET .01 VALUE
	. N XDRDT S XDRDT=^DD(SFILE,.01,0)
	. I $P(XDRDT,U,2)["D" S XDRDT=$P(XDRDT,U,5,999),XDRDINUM=$S(XDRDT["DINUM":1,1:0) I XDRDINUM S XDRDT=0 D DINUMDAT Q:XDRDT  ; HANDLE DINUMED DATES BY SIMPLY MOVING THEM
	. S YVALUE=0,XVALUE=0 I $D(^DD(SFILE,.001,0)) S YVALUE=NODEA I $D(@(XDRTO_NODEA_")")) S XVALUE=YVALUE
	. I XVALUE=0,$P(^DD(SFILE,.01,0),U,5,99)["DINUM",$D(@(XDRTO_NODEA_")")) S XVALUE=NODEA
	. I XVALUE=0 S XVALUE=+$$FIND1^DIC(SFILE,(","_IENTOSTR),"Q",VALUE) ; FIND CURRENT ENTRY NUMBER, IF PRESENT
	. I XVALUE>0 D  Q  ; SUBFILE EXISTS IN IENTO, CHECK FOR LOWER SUBFILES
	. . N X,X1,NODE,NEWFROM,NEWTO,NEWTOIEN
	. . S NODE=""
	. . F  S NODE=$O(@(XDRFROM_NODEA_","""_NODE_""")")) Q:NODE=""  D
	. . . I $D(@(XDRFROM_NODEA_","""_NODE_""")"))'>1 Q
	. . . S NEWFROM=XDRFROM_NODEA_","""_NODE_""","
	. . . S NEWTO=XDRTO_XVALUE_","""_NODE_""","
	. . . S NEWTOIEN=XVALUE_","_IENTOSTR
	. . . D DOSUBS(NEWFROM,NEWTO,NEWTOIEN,(XVALUE_U_XDRDASEQ))
	. K XDRYY I YVALUE>0 S XDRYY(1)=YVALUE
	. S XENTOSTR="+1,"_IENTOSTR
	. S XDRFILTY=$P($G(^DD(SFILE,.01,0)),U,2)
	. I XDRFILTY["P" S VALUE="`"_VALUE
	. I XDRFILTY["V" D
	. . N Y S Y=$P(VALUE,";",2) Q:Y=""
	. . S Y=$P($G(@("^"_Y_"0)")),U) Q:Y=""
	. . S VALUE=Y_".`"_(+VALUE)
	. . Q
	. I SFILE=70.03 S XDRFILTY="D" ;use internal data for file 70.03
	. I XDRFILTY'["P"&(XDRFILTY'["V"),XDRFILTY'["D" S VALUE=$$GETEXT(XDRFROM,NODEA,SFILE)
	. S XDRXX(SFILE,XENTOSTR,.01)=VALUE
	. I $O(^DD(SFILE,0,"ID",0))>0  D
	. . ;CODE FOR ADDING IDENTIFIERS
	. . N I,N,XDRFROM1,IENFR
	. . S N=0,I=SFILE F  S I=$G(^DD(I,0,"UP")) Q:I'>0  S N=N+1
	. . S XDRFROM1=$P(XDRFROM,"(",2,99),IENFR=NODEA_","
	. . F I=$L(XDRFROM1,",")-2:-2 Q:N'>0  S IENFR=IENFR_$P(XDRFROM1,",",I)_",",N=N-1
	. . ;
	. . F XDRID=0:0 S XDRID=$O(^DD(SFILE,0,"ID",XDRID)) Q:XDRID'>0  D
	. . . S N=$$GET1^DIQ(SFILE,IENFR,XDRID)
	. . . I N'="" S XDRXX(SFILE,XENTOSTR,XDRID)=N
	. . . Q
	. . Q
	. ;
	. K XDRAA,XDRZZ I $D(XDRTESTK) M XDRAA=XDRXX ; DEBUG STATEMENT
	. ; DATES THAT ARE DINUMED HAVE BEEN HANDLED ABOVE, SO CAN PASS A DATE IN AS AN INTERNAL VALUE
	. D UPDATE^DIE($S(XDRFILTY["D":"",1:"E"),"XDRXX","XDRYY","XDRZZ") ; CREATE A NEW ENTRY IN IENTO FOR VALUE
	. I $D(XDRZZ),$D(XDRTESTK),SFILE'=2.0361 S XDRTESTK=XDRTESTK+1 M ^XTMP("XDRTESTK",$$NOW^XLFDT(),XDRTESTK,"XX")=XDRAA,^("ZZ")=XDRZZ ; DEBUG STATEMENT
	. S NODEB=$G(XDRYY(1)) I NODEB'>0 Q
	. M @(XDRTO_NODEB_")")=@(XDRFROM_NODEA_")")
	. S DIK=XDRTO,DA=NODEB D
	. . F I=1:1 S DA(I)=$P(XDRDASEQ,U,I) I DA(I)="" K DA(I) Q
	. I SFILE=55.06 N DIU S DIU(0)=1 F DIK(1)=".01^B","10^AUDS","34^AUD","64^AUDDD","7^ACR1" D EN1^DIK
	. I SFILE'=55.06 N DIU S DIU(0)=1 D IX^DIK
	Q
	;
GETEXT(DICA,DA,FILNUM)	; GET EXTERNAL VALUE FOR .01 FIELD
	N DIC,DIQ,DR,XDRQ
	S DIC=DICA,DIC("P")=FILNUM,DR=.01,DIQ="XDRQ",DIQ(0)="E"
	D EN^DIQ1
	Q $G(XDRQ(FILNUM,DA,.01,"E"))
	;
DINUMDAT	; PROCESS ENTRIES WITH SAMPLE DATE/TIMES WITH SECONDS, NEEDS DINUM
	N NEWVAL,NODETO
	S NODETO=NODEA
	I $D(@(XDRTO_NODEA_")")) Q:(SFILE'=63.04)  D
	. S NEWVAL=VALUE
	. F  Q:'$D(@(XDRTO_NODETO_")"))  S NODETO=NODETO-.000001,NEWVAL=NEWVAL+.000001
	M @(XDRTO_NODETO_")")=@(XDRFROM_NODEA_")")
	I $D(NEWVAL) S $P(@(XDRTO_NODETO_",0)"),U)=NEWVAL
	S DIK=XDRTO,DA=NODEA D  D IX^DIK
	. F I=1:1 S DA(I)=$P(XDRDASEQ,U,I) I DA(I)="" K DA(I) Q
	S XDRDT=1
	Q
	;
DODIS	; CODE TO HANDLE DISPOSITION ENTRIES IN PATIENT FILE
	N XDRI,DA,DIK
	F XDRI=0:0 S XDRI=$O(@(XDRDIC_IENFROM_",""DIS"","_XDRI_")")) Q:XDRI'>0  D
	. I $D(@(XDRDIC_IENTO_",""DIS"","_XDRI_")")) Q
	. M @(XDRDIC_IENTO_",""DIS"","_XDRI_")")=@(XDRDIC_IENFROM_",""DIS"","_XDRI_")")
	. S DA=XDRI,DA(1)=IENTO,DIK=XDRDIC_IENTO_",""DIS""," D IX^DIK
	. Q
	Q
	;
