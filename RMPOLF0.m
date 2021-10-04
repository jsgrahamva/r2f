RMPOLF0	;HIN CIOFO/RVD-DRIVER FOR HO LETTERS ;06/22/99
	;;3.0;PROSTHETICS;**29,55,115,159**;Feb 09, 1996;Build 2
	;
	; ODJ - patch 55 - 1/29/01 - replace 121 hard code mail symbol with
	;                            call to site param. extrinsic
	;                            see nois AUG-1097-32118
	;
	D HOME^%ZIS S RMPRIN=0
	K VADM,^TMP("RL",$J)
	S Y=DT D DD^%DT S NAME=Y D TRANS^RMPRUTL1 S (RMPODT,RMPODATE)=RMPRNAME
	D PIKSOM Q:$$QUIT  I Y="" S VALMBCK="R" Q
	M ^TMP("RL",$J)=^TMP($J)
	S LFNS=Y I 'JOB D FULL^VALM1
	;
QUED	;
	F ZI=1:1:$L(LFNS,",")-1 D
	. S LFN=$P(LFNS,",",ZI) Q:LFN'>0
	. S RMPONAM="",CNT=0 F  S RMPONAM=$O(^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM)) Q:RMPONAM=""  D
	.. S RMPOLTR=$P(^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM),U,1)
	.. S RMPODFN=$P(^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM),U,2)
	.. S RMDA=$P(^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM),U,3)
	.. S CNT=CNT+1
	.. S:CNT=LFN ^TMP("RL",$J,RMPOXITE,"LTR",RMPONAM)=RMPODFN_"^"_RMPOLTR_"^"_RMDA
	S (RMBLNK,RMPONAM)="",RMQUIT=0
	F  S RMPONAM=$O(^TMP("RL",$J,RMPOXITE,"LTR",RMPONAM)) Q:RMPONAM=""!$G(RMQUIT)  D CUM
	;end
EXIT	;
	K LFNS,LFN,ZI,RTN,DIR,RMLET,^TMP($J)
	K %X,RMPRFFL,RMPRHED,RMPRPRIN,%Y,RMPRDEL,RMPRRVA,DIC,RMPRFA,KILL,DIE,DA
	K DR,DIK,RMPR1,RMPR2,RMPRDATE,RMPRIN,RMPRL,RMPRNAME,RMPRU,RMPRDELE,FR
	K RMPREND,VADM,VAPA,VA,NAME,RMPRGO,NAME1,RMPONAM
	K RMPRDEN,RMPRFLAG,RMPRNAM1,RMPRNAM2,RMPRFF,J,RP,RO,RZ D KVAR^VADPT
	M ^TMP($J)=^TMP("RL",$J) K ^TMP("RL",$J)
	D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q:$D(ZTQUEUED)
	D HOME^%ZIS D CLEAN^VALM10,INIT^RMPOLT S VALMBCK="R"
	Q
	;
CUM	;
	K RMPRNT S RDATA=^TMP("RL",$J,RMPOXITE,"LTR",RMPONAM)
	S DFN=$P(RDATA,U,1),RMPOLTR=$P(RDATA,U,2),RMDA=$P(RDATA,U,3)
	S RMREC=^TMP("RL",$J,RMPOXITE,"RMPODEMO",DFN)
	S RMPORX=$P(RMREC,U,6) S:RMPORX="" RMPORX="Not on file"
	S RMPORXDT=$P(RMREC,U,4)
	I RMPORXDT="" S RMPORXDT="n/a"
	E  S Y=RMPORXDT X ^DD("DD") S RMPORXDT=Y
	S RMPRFA=RMPOLTR
	D DEM^VADPT,ADD^VADPT
	F RI=1:1:21 S ^TMP($J,"DW",RI,0)=" "
HEADER1	;
	S RMPRHED=$G(^TMP("RL",$J,RMPOXITE,"HEADER",RMPOLTR))
	W @IOF I 'RMPRHED G HEADER
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
	;
	S ^TMP($J,"DW",15,0)="|TAB|"_RMBLNK_"|TAB|"_DFN
	S ^TMP($J,"DW",16,0)="|TAB|"_RMBLNK_"|TAB|Current Home Oxygen Rx#: "_RMPORX
	S ^TMP($J,"DW",17,0)="|TAB|"_RMBLNK_"|TAB|Rx Expiration Date: "_RMPORXDT
	;
	S NAME=$P(VADM(1),",")
	I $P(NAME," ",2)?1A.A D
	.S NAME1=NAME,NAME=$P(NAME," ",1) D TRANS^RMPRUTL1 S RMPRNAM1=RMPRNAME,NAME=NAME1,NAME=$P(NAME," ",2) D TRANS^RMPRUTL1 S RMPRNAM2=RMPRNAME,RMPRNAME=RMPRNAM1_" "_RMPRNAM2
	E  D TRANS^RMPRUTL1
	D NAME^RMPOLF1
	Q
QUIT()	S QUIT=$D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q QUIT
	Q
PIKSOM	; ALLOW SELECTION FROM DISPLAYED ENTRIES
	K DIR S DIR(0)="LO^"_VALMBG_":"_VALMLST D ^DIR
	Q
