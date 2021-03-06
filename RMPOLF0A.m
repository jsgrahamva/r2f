RMPOLF0A	;HIN CIOFO/RVD-DRIVER FOR HO LETTERS(ALL) ;06/28/99
	;;3.0;PROSTHETICS;**29,55,115,159,160**;Feb 09, 1996;Build 14
	;
	; ODJ - patch 55 - 29/1/01 - replace 121 hard coded mail code with call
	;                            to site param. extrinsic (AUG-1097-32118)
	;
	D HOME^%ZIS S RMPRIN=0
	S RMPRTFLG=1
	S Y=DT D DD^%DT S NAME=Y D TRANS^RMPRUTL1 S (RMPODT,RMPODATE)=RMPRNAME
	K ZTSAVE D FULL^VALM1
	S JOBTIM=$J_$P($H,",",2) K ^XTMP("RL",JOBTIM)
	D NOW^%DTC S RMSTART=%,^XTMP("RL",JOBTIM,0)=$$FMADD^XLFDT(RMSTART,5)_"^"_RMSTART
	M ^XTMP("RL",JOBTIM)=^TMP($J) K ^TMP($J)
PRINT	; print ALL patient letters
	S %ZIS="MQ" K IOP D ^%ZIS G EXIT:POP=1
	I $D(IO("Q")) D  D ^%ZTLOAD G EXIT
	. S ZTRTN="QUED^RMPOLF0A",ZTDESC="PRINT ALL HO LETTERS"
	. K ZTSAVE,IO("Q") S ZTIO=ION,(ZTSAVE("RMPOXITE"),ZTSAVE("RMPOLCD"),ZTSAVE("JOBTIM"),ZTSAVE("RMPODT"),ZTSAVE("RMPODATE"),ZTSAVE("RMPRNAME"))=""
	U IO
	;
QUED	;
	S (RMBLNK,RMPONAM)="",RMQUIT=0 S:'$D(ZTQUEUED) RMIOST=IOST,RMIO=ION
	F  S RMPONAM=$O(^XTMP("RL",JOBTIM,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM)) Q:RMPONAM=""!$G(RMQUIT)  D CUM
	F RI=0:0 S RI=$O(^XTMP("RL",JOBTIM,1,RI)) Q:RI'>0  S RMDFN=^XTMP("RL",JOBTIM,1,RI) D
	.I RMPOLCD="A" S $P(^RMPR(665,RMDFN,"RMPOA"),U,9)=DT,$P(^("RMPOA"),U,10)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT1") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT1",0)="^669.9002P^^^"
	.I RMPOLCD="B" S $P(^RMPR(665,RMDFN,"RMPOA"),U,11)=DT,$P(^("RMPOA"),U,12)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT2") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT2",0)="^669.972P^^^"
	.I RMPOLCD="C" S $P(^RMPR(665,RMDFN,"RMPOA"),U,13)=DT,$P(^("RMPOA"),U,14)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT3") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT3",0)="^669.974P^^^"
	;
EXIT	K LFNS,LFN,ZI,RTN,DIR,RMLET,RMPRTFLG,RMPRIN,RMIO,RMIOST,RMION,RMPONAM,HOLDJB,EOP
	K RMDAT,DFN,RMDA,RMPRFA,RMDFN,RI
	K %,%X,%Y,%ZIS,DA,DIK,POP,RMSTART,RV,TAB,VADM(5),X,ZTIO,ZTSK
	M ^TMP($J)=^XTMP("RL",JOBTIM) K ^TMP("RL",$J)
	K ^TMP($J,RMPOXITE,"RMPOLST",RMPOLCD)
	D ^%ZISC I $D(ZTQUEUED) S ZTREQ="@" K ^XTMP("RL",JOBTIM) Q
	K JOBTIM
	D CLEAN^VALM10,INIT^RMPOLT,RE^VALM4
	S VALMBCK="R"
	Q
	;
CUM	;
	S RMDAT=^XTMP("RL",JOBTIM,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM)
	S RMPOLTR=$P(RMDAT,U,1)
	S DFN=$P(RMDAT,U,2)
	S RMDA=$P(RMDAT,U,3)
	S RMPRFA=RMPOLTR,RMPRTFLG=1
	S RMREC=^XTMP("RL",JOBTIM,RMPOXITE,"RMPODEMO",DFN)
	S RMPORX=$P(RMREC,U,6) S:RMPORX="" RMPORX="Not on file"
	S RMPORXDT=$P(RMREC,U,4)
	I RMPORXDT="" S RMPORXDT="n/a"
	E  S Y=RMPORXDT X ^DD("DD") S RMPORXDT=Y
	D DEM^VADPT,ADD^VADPT
	F RI=1:1:21 S ^TMP($J,"DW",RI,0)=" "
HEADER1	;
	S RMPRHED=$G(^XTMP("RL",JOBTIM,RMPOXITE,"HEADER",RMPOLTR))
	I 'RMPRHED G HEADER
	S ^TMP($J,"DW",1,0)="|SETTAB(""C"")|"
	S ^TMP($J,"DW",2,0)="|TAB|Department of Veterans Affairs"
	S NAME=$P(^RMPR(669.9,RMPOXITE,2),U,4) I NAME]"" S NAME=$S($D(^DIC(5,NAME)):$P(^DIC(5,NAME,0),U),1:"STATE") S RMFXN=$$PARS^RMPRUTL1(NAME)
	S ^TMP($J,"DW",3,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,0),U)
	S ^TMP($J,"DW",4,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,2),U,2)
	S ^TMP($J,"DW",5,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,2),U,3)_", "_RMFXN_" "_$P(^RMPR(669.9,RMPOXITE,2),U,5) K RMFXN
HEADER	;
	S ^TMP($J,"DW",9,0)="|SETTAB(5,50)||TAB|"_RMPODT
	S STATNID=$P(^RMPR(669.9,RMPOXITE,0),U,2) I $D(^DIC(4,STATNID,99)) S STATNID=$P(^DIC(4,STATNID,99),U)
	S ^TMP($J,"DW",11,0)="|TAB|"_$P(VADM(1),",",2)_" "_$P(VADM(1),",",1)_"|TAB|In Reply Refer To: "_STATNID_"/"_$$ROU^RMPRUTIL(RMPOXITE)
	K STATNID
	S ^TMP($J,"DW",12,0)="|TAB|"_VAPA(1)
	I VAPA(2)]"" S ^TMP($J,"DW",13,0)="|TAB|"_VAPA(2)_"|TAB|"_VADM(1),^TMP($J,"DW",14,0)="|TAB|"_VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6)
	E  S ^TMP($J,"DW",13,0)="|TAB|"_VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6)_"|TAB|"_VADM(1)
	S ^TMP($J,"DW",16,0)="|TAB|"_RMBLNK_"|TAB|Current Home Oxygen Rx#: "_RMPORX
	S ^TMP($J,"DW",17,0)="|TAB|"_RMBLNK_"|TAB|Rx Expiration Date: "_RMPORXDT
	;
HEADER2	;
	W:$G(EOP) @IOF
	W !!,?23,"Department of Veterans Affairs"
	S NAME=$P(^RMPR(669.9,RMPOXITE,2),U,4) I NAME]"" S NAME=$S($D(^DIC(5,NAME)):$P(^DIC(5,NAME,0),U),1:"STATE") S RMFXN=$$PARS^RMPRUTL1(NAME)
	S HEADW=$P(^RMPR(669.9,RMPOXITE,0),U) W !,?(80-$L(HEADW)/2),HEADW
	S HEADW=$P(^RMPR(669.9,RMPOXITE,2),U,2) W !,?(80-$L(HEADW)/2),HEADW
	S HEADW=$P(^RMPR(669.9,RMPOXITE,2),U,3)_", "_RMFXN_" "_$P(^RMPR(669.9,RMPOXITE,2),U,5) W !,?(80-$L(HEADW)/2),HEADW K RMFXN,HEADW
HEADERB	;
	W !!!,RMPODT
	S STATNID=$P(^RMPR(669.9,RMPOXITE,0),U,2) I $D(^DIC(4,STATNID,99)) S STATNID=$P(^DIC(4,STATNID,99),U)
	W !!,$P(VADM(1),",",2)_" "_$P(VADM(1),",",1),?43,"In Reply Refer To: "_STATNID_"/"_$$ROU^RMPRUTIL(RMPOXITE)
	K STATNID
	W !,VAPA(1)
	I VAPA(2)]"" W !,VAPA(2),?43,VADM(1),!,VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6)
	E  W !,VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6),?43,VADM(1)
	W !!,?43,DFN
	W !,?43,"Current Home Oxygen Rx#: "_RMPORX
	W !,?43,"Rx Expiration Date: "_RMPORXDT
	;
	S NAME=$P(VADM(1),",")
	I $P(NAME," ",2)?1A.A D
	.S NAME1=NAME,NAME=$P(NAME," ",1) D TRANS^RMPRUTL1 S RMPRNAM1=RMPRNAME,NAME=NAME1,NAME=$P(NAME," ",2) D TRANS^RMPRUTL1 S RMPRNAM2=RMPRNAME,RMPRNAME=RMPRNAM1_" "_RMPRNAM2
	E  D TRANS^RMPRUTL1
NAME	;
	S RMPRNAME=$P(RMPRNAME," ",1,2) K RMPRVIEW,RMPRPRIN
	I $P(VADM(5),U)["M" W !!,"Dear Mr. "_RMPRNAME_":" S ^TMP($J,"DW",19,0)="|TAB|"_"Dear Mr. "_RMPRNAME_":"
	E  W !!,"Dear Ms. "_RMPRNAME_":" S ^TMP($J,"DW",19,0)="|TAB|"_"Dear Ms. "_RMPRNAME_":"
	W !!
	S RV=21 F RI=0:0 S RI=$O(^RMPR(665.2,RMPRFA,1,RI)) Q:RI'>0  Q:^(RI,0)'=" "
	S RI=RI-1 F  S RI=$O(^RMPR(665.2,RMPRFA,1,RI)) Q:RI'>0  S TAB=$S($P(^RMPR(665.2,RMPRFA,1,RI,0),U)["|TAB|":"",1:"|TAB|") S ^TMP($J,"DW",RV,0)=TAB_^(0),RV=RV+1
	S RI=0 F  S RI=$O(^RMPR(665.2,RMPRFA,1,RI)) Q:RI'>0  D
	. ;I $Y>60 W @IOF W !!!!!!
	. W !,$G(^RMPR(665.2,RMPRFA,1,RI,0))
	S EOP=1
SETALL	K DIC S DIC="^RMPR(665.4,",DIC(0)="L",X=DFN,DLAYGO=665.4 K DD,DO,DINUM D FILE^DICN K DLAYGO
	G:Y<0 EXIT^RMPOLF1
	S RMPRIN=+Y,$P(^RMPR(665.4,RMPRIN,0),U,2)=RMPRFA,$P(^(0),U,3)=DT,$P(^(0),U,4)=DUZ,$P(^RMPR(665.4,RMPRIN,0),U,5)=$P(^RMPR(665.2,RMPRFA,0),U,2),$P(^RMPR(665.4,RMPRIN,0),U,6)=RMPOXITE S DIK=DIC,DA=RMPRIN D IX1^DIK
	S %X="^TMP($J,""DW"",",%Y="^RMPR(665.4,+Y,1," D %XY^%RCR
	S ^TMP("RL",JOBTIM,1,RMPRIN)=DFN
	Q
QUEUE(ZTDESC,ZTRTN,ZTSAVE)	; Queue print 
	D ^%ZTLOAD
	I '$D(ZTSK) W !!,?5,"Report Cancelled!",! Q 0
	E  W !!,?5,"Print queued!",! Q 1
	Q
