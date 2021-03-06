PSJINHIS	;BIR/MLM-PRINT HISTORY LOG ;23 SEP 97 / 1:10 PM 
	;;5.0;INPATIENT MEDICATIONS;**267**;16 DEC 97;Build 158
	;
	; Reference to ^PS(55 is supported by DBIA 2191.
	; Reference to ^%ZTLOAD is supported by DBIA 10063.
	; Reference to ^%DTC is supported by DBIA 10000.
	; Reference to ^%ZIS is supported by DBIA 10086.
	; Reference to ^%ZISC is supported by DBIA 10089.
	; Reference to ^DIR is supported by DBIA 10026.
	;
ENHIS(DFN,PSJHON,PSJHT)	; History log from beginning.
	N POP,X,ZTIO,ZTRTN
	W ! K IO("Q"),%ZIS,IOP S %ZIS="QM" D ^%ZIS I POP W !,"NO DEVICE SELECTED OR REPORT PRINTED" G K
	G:'$D(IO("Q")) DEQ K IO("Q"),ZTDTH,ZTSAVE,ZTSK S ZTIO=ION,ZTRTN="DEQ^PSJINHIS" F X="DFN","PSJHON","PSJHT","PSJORD","PSJSYSU","PSJSYSP" S ZTSAVE(X)="",ZTDESC="INPATIENT HISTORY LOG"
	D ^%ZTLOAD W:$D(ZTSK) !,"Queued."
	D HOME^%ZIS
	Q
	;
DEQ	; Entry from queue.
	N DIR,DONE,DTOUT,DUOUT,HDT,ON,ON55,P,PG,PPAGE,PSGORD,PSIVAC,PSJACNWP,PSJNEW,PSJPTR,UL80,PSJCHTO,PSJPR,PSJPRCOM,TMPTO,PN,PSJHDRF,%,ZTREQ,ZTQUEUED S PN=0
	S PSJCHTO="" S PSGP=DFN,PSJACNWP=1 D ENBOTH^PSJAC,NOW^%DTC S UL80="",$P(UL80,"-",80)="",HDT=$$ENDTC^PSGMI(%),PSJPTR=$E(IOST)'="C",PG=0,ON=PSJHON,PSIVAC="PH" U IO
	D RELATE,ENHEAD:PSJPTR W:'PSJPTR&($Y) @IOF I '$L(PSJOLD_PSJNEW) I $G(PSJORD) N PSGORD S PSGORD=PSJORD D EN0^PSJINVW(1,.PSJCHTO) G K
	S:'PSJOLD PSJOLD=PSJHON F  S ON=PSJOLD D RELATE Q:PSJOLD=""
	F  D DISPLAY,RELATE S ON=PSJNEW Q:PSJNEW=""!$D(DONE)
	;
K	; Kill and exit.
	K DFN,PSJHON,PSJHT,TMPTO
	W:$G(PSJPTR)&($Y) @IOF S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC
	W !!
	Q
	;
DISPLAY	; Display order.
	S PSGORD=ON N PSJLM D EN0^PSJINVW(1,.PSJCHTO)
	Q
	;
PAUSE	; Hold screen.
	K DIR S DIR(0)="E" D ^DIR S:$D(DTOUT)!($D(DUOUT)) DONE=1
	Q
RELATE	; Get related order.
	I ON["U"!(ON["A")!(ON["O") S PSJOLD=$P($G(^PS(55,DFN,5,+ON,0)),U,25),PSJNEW=$P($G(^(0)),U,26) Q
	I ON["V" S PSJOLD=$P($G(^PS(55,DFN,"IV",+ON,2)),U,5),PSJNEW=$P($G(^(2)),U,6) Q
	S PSJOLD=$P($G(^PS(53.1,+ON,0)),U,25),PSJNEW=$P($G(^(0)),U,26) I PSJNEW=ON S PSJNEW=""
	Q
	;
ENHEAD	; Header for Inpatient History log.
	S PPAGE=0 NEW PSJNEW D ENTRY^PSJHEAD(PSGP,0,0,0,0)
	Q
