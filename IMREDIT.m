IMREDIT ;HCIOFO/FAI - PT LOOKUP IN IMR FILE ;11/07/01  10:46;
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**9,5,13,17,16**;Feb 09, 1998;
EDIT ; [IMR ENTER/EDIT DATA] - Enter/Edit Basic Patient Data
EDIT1 D KILL
 S IMRNEW=1 D CHK K IMRNEW G:DA'>0 EXIT
 K IMRCD4,IMRCDC,IMRCD4D,IMRCD4X,IMRCD,IMRLCD,IMRLCDD,IMRCDX,IMRCDXD,IMRED1
 S IMRFN=DA,DFN=+Y,IMRTSTLR=$P($G(^DPT(DFN,"LR")),U,1)
FILO S IMRANS="" D ^IMRLTST W !! D EDIT^IMRCD4 ;list and edit CD4 values
 I IMRANS="^" D KILL G EDIT1
 K DR,IMRPN S DIE=158,DR="[IMR EDIT1]" D ^DIE ;edit station,patient status country of birth,...etc)
 K IMRCD4,IMRCD4D,IMRCD4X,IMRLCD,IMRLCDD,IMRCDX,IMRCDXD,IMRED1
 S:$D(IMRDFN) DFN=IMRDFN
 S DIR(0)="Y",DIR("A")="Do you want to Enter/Edit CDC form data now"
 D ^DIR K DIR
 I Y D CDC1^IMRCDCED
 I $G(IMRNEW)'="" D FINCHK
 D KILL G EDIT1
CHK ; Check Station
 I '$D(^XUSEC("IMRA",DUZ)) S:'$D(IMRLOC) IMRLOC="IMREDIT" D ACESSERR^IMRERR,H^XUS K IMRLOC
 D:'$D(IMRSTN) IMROPN^IMRXOR
ASK ; Select Patient
 S:'$D(IMRNEW) IMRNEW=0
 W !! K DIC S DIC=2,DIC(0)="AEQM" D ^DIC S (X,DA)=+Y Q:Y'>0
 D ^IMRXOR
 I '$D(^IMR(158,"B",X)) S DA=-1 I IMRNEW S DA=+Y D NEW I '$D(X) G ASK
 I DA'>0 W !,$C(7),"This patient must be entered into the Immunology Case Study file using",!,"The Enter/Edit option first.",!! G ASK
 S Y=DA,DA=+$O(^IMR(158,"B",X,0)) G:DA'>0 ASK
 Q
NEW ; add new entry to ICR database
 R !?5,"Is this patient REALLY supposed to be in your database (Y/N)?",Y:DTIME
 G:'$T!(Y["U") EXIT
 I "YyNn"'[$E(Y) W $C(7),"  ??" G NEW
 I "Nn"[$E(Y) K X S DA=-1 Q
 S IMRX=X,(NPFN,IMRDFN,DFN)=DA,IMRTSTLR=$P($G(^DPT(DFN,"LR")),U,1) D DEM^VADPT
 S X=IMRX,DIC=158,DIC(0)="L",DLAYGO=158 D ^DIC K DLAYGO S IMNN=+Y G:Y'>0 EXIT
 S X=$P($G(VADM(8)),U) I X>0 S X=$S($D(^DIC(10,X,0)):$P(^(0),U,2),1:0) I X>0 S $P(^IMR(158,+Y,0),U,2)=$S(X=1:3,X=2:3,X=3:5,X=4:2,X=5:4,X=6:1,1:9)
 S ^IMR(158,+Y,101)="" I $P($G(^IMR(158.9,1,0)),U,7)>0 S ^IMR(158,+Y,103)=DA ; set active name pointer
 S X=IMRX
 S IMRFN=+Y,IMRP103=DFN,IMRTSTLR=$P($G(^DPT(NPFN,"LR")),U,1)
 S Y=DA,DA=+$O(^IMR(158,"B",X,0)) G:DA'>0 ASK
 G FILO
 Q
FINCHK W !!,"Are you sure, "_$P($G(^DPT(IMRDFN,0)),U,1)_" should be"
 R " in your database (Y/N)?",Y:DTIME
 G:'$T!(Y["U") EXIT
 I "YyNn"'[$E(Y) W $C(7),"  ??" G FINCHK
 I "Nn"[$E(Y) S DIK="^IMR(158,",DA=IMRX D ^DIK K DIK D KILL G EDIT
 W !!,?5,"Sending the past 365 days of data to the HIV National Database..",!! H 1
 D ^IMRBPT
 S IMRTSTLR=$P($G(^DPT(NPFN,"LR")),U,1)
 Q
EXIT D KILL
 Q
KILL K %ZIS,DA,DIC,DIE,IMRCD,IMRCD4,IMRCDC,IMRFLG,IMRL,IMRN1,IMRN2,IMRN3,IMRP103,IMRX,I,J,POP,X,Y,Y1,Y2,IMRPT,IMRSTN,Y0,IMRDFN,IMREDIT,IMRXCAT,IMRCD4E,D0,DI,DIPGM,DR,VAERR,CNUM,CPTC,CPTREC,D2,DDER,DDH,DGMT,DGMTE,DGNOCOPF,DGWRT,IMNN,IMRFB,IMRFLAG
 K %,%DT,%X,%Y,C,CDAR,CDP,D0,D1,DA,D,DIC,DIE,DNAM,DQ,DR,DTAA,DTR1,DTR2,DTRC,DTRD,HVR,ILR,IMDATE,IMLM,IMLO,IMRANS,IMRANS,IMRCD,IMRDFN,IMRFN,IMRLNODE,IMRLTEST,IMRNEW,IMRSTN,IMRTSTI,IMRTSTII,IMRTSTLR,IMRVLIEN,IMS,IMWK,IMRPR4,IMRPRC,IMRY1
 K IMRNEW,IMRSTN,DFN,LCDD,LDAT,LDO,LDT,LGN,LIG,LL,LLOC,LNM,LOWP,LRES,MDT,PLOW,RC,TNN,UNN,UNS,IMRI,IMRLABTR,IMRSUF,IPC,NPFN,SDCNT
 Q
IMRDEV ; Select Device from ALLOWABLE PRINTER multiple in File 158.9
 ; If no allowable printers select any printer
 ; If a slave device is selected, then don't display the entries
 ; from the ALLOWABLE PRINTER multiple
IMRDEV1 ;
 S IMRFLG=0
 I $O(^IMR(158.9,1,7,0))'>0 S IOP="Q",%ZIS="MPQ" D ^%ZIS Q:POP  S IMRFLG=1
 I $D(IO("S")) S IMRFLG=1 ; check if slave device chosen
 I 'IMRFLG W !!,$C(7),"Select *SECURE* ALLOWABLE PRINTERS (Field 7) from ICR Site Parameters File:",!?5,"HOME" F I=0:0 S I=$O(^IMR(158.9,1,7,I)) Q:I'>0  I $D(^(I,0)) S X=+^(0) I $D(^%ZIS(1,X,0)) W !?5,$P(^(0),U)
 I 'IMRFLG W ! S IOP="Q",%ZIS="MPQ" D ^%ZIS Q:POP  S IMRFLG=1 I IO'=IO(0) S IMRFLG=0 F I=0:0 S I=$O(^IMR(158.9,1,7,I)) Q:I'>0  I $D(^(I,0)) S X=+^(0) I $D(^%ZIS(1,X,0)) I $P(ION,";",1)=$P(^(0),U) S IMRFLG=1 Q
 I 'IMRFLG W !,"Select one of the valid devices",$C(7),! G IMRDEV1
 Q