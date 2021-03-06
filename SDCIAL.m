SDCIAL	;ALB/TMP - INPATIENT APPOINTMENT LIST ;16 JAN 86
	;;5.3;Scheduling;**32,406,618**;Aug 13, 1993;Build 3
	S DIV="",SDTT=0 D DIV^SDUTL I $T S DIC("A")="INPATIENT APPOINTMENT LIST FOR WHICH DIVISION:" D ASK^SDDIV Q:Y<0
RD	R !,"FOR WARD (TYPE 'ALL' FOR ALL WARDS): ",X:DTIME Q:"^"[X  I X?.E1"?" W !,"ENTER A WARD NAME OR ALL FOR ALL WARDS"
	S X=$$UP^XLFSTR(X)
	I X="ALL" S SDW=X G RD1
	S DIC="^DIC(42,",DIC(0)="EQ"
	D ^DIC Q:X=""!(X["^")  G:Y<0 RD S SDW=+Y
RD1	D DATE^SDUTL G:POP END I BEGDATE<DT W *7,!,"Start date must be in the future" G RD1
	S VAR="DIV^SDW^BEGDATE^ENDDATE",VAL=DIV_"^"_SDW_"^"_BEGDATE_"^"_ENDDATE,PGM="START^SDCIAL"
	D ZIS^DGUTQ G:POP END
START	K ^UTILITY($J),^TMP($J,"SDAMA301"),^TMP($J,"SDAMA301C") U IO I '$D(DT) D DT^SDUTL
	N SDLIST,SDCOUNT S SDCOUNT=0
	S (SDEND,SD1)=0,SDTT=$S($E(IOST,1,2)="C-"&(IOSL<66):1,1:0)
	I SDW'="ALL" S I=$P(^DIC(42,SDW,0),"^",1) D PT D DFN D WRT Q
	S I=0 F  S I=$O(^DPT("ACN",I)) Q:I=""  D PT
	D DFN,WRT
	Q
PT	;build patient list
	S I2="" F  S I2=$O(^DPT("ACN",I,I2)) Q:I2'>0  I $D(^DPT(I2,0)) S SDLIST(I2)=""
	Q
DFN	;retrieve appt data for list of patients
	I $D(SDLIST)'>1 Q
	N SDARRAY,SDDFN,SDWARD,SDAPPT,SDCL,SDLAB,SDXRAY,SDEKG,SDOTHER,SDPNDFN
	S SDARRAY(1)=BEGDATE_";"_ENDDATE,SDARRAY(3)="I;R",SDARRAY("FLDS")="1;2;6;19;20;21",SDARRAY(4)="SDLIST("
	S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY) I SDCOUNT<1 Q
	;re-sort output by clinic, then patient
	S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301",SDDFN)) Q:SDDFN=""  D
	. S SDCL=0 F  S SDCL=$O(^TMP($J,"SDAMA301",SDDFN,SDCL)) Q:SDCL=""  D
	.. ;SD*618 Add patient's name to be one of the sort filter (Patient's name~DFN)
	.. S SDPNDFN=$P($G(^DPT(SDDFN,0)),"^",1)_"~"_SDDFN
	.. M ^TMP($J,"SDAMA301C",SDCL,SDPNDFN)=^TMP($J,"SDAMA301",SDDFN,SDCL)
	I DIV'="" D
	. ;remove appts if clinic is not in selected division
	. S SDCL=0 F  S SDCL=$O(^TMP($J,"SDAMA301C",SDCL)) Q:SDCL=""  I $P(^SC(SDCL,0),"^",15)'=DIV K ^TMP($J,"SDAMA301C",SDCL)
	;get appt data and add to ^UTILITY
	S SDCL=0 F  S SDCL=$O(^TMP($J,"SDAMA301C",SDCL)) Q:SDCL=""  D
	. S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301C",SDCL,SDDFN)) Q:SDDFN=""  D
	.. S SDAPPT=0 F  S SDAPPT=$O(^TMP($J,"SDAMA301C",SDCL,SDDFN,SDAPPT)) Q:SDAPPT=""  D
	... S SDWARD=$P($G(^DPT($P(SDDFN,"~",2),.1)),"^",1)
	... S SDLAB=$P(^TMP($J,"SDAMA301C",SDCL,SDDFN,SDAPPT),"^",21)
	... S SDXRAY=$P(^TMP($J,"SDAMA301C",SDCL,SDDFN,SDAPPT),"^",20)
	... S SDEKG=$P(^TMP($J,"SDAMA301C",SDCL,SDDFN,SDAPPT),"^",19)
	... S SDOTHER=$P($G(^TMP($J,"SDAMA301C",SDCL,SDDFN,SDAPPT,"C")),"^",1)
	... ;mimic DPT "S" node, but also add 'other' to end (6th piece) for future use:
	... I $G(SDWARD)]"" S ^UTILITY($J,SDWARD,SDAPPT\1,SDDFN,"."_$P(SDAPPT,".",2))=SDCL_"^^"_$G(SDLAB)_"^"_$G(SDXRAY)_"^"_$G(SDEKG)_"^"_$G(SDOTHER)
	Q
WRT	I SDCOUNT<0 W @IOF,?29,"INPATIENT APPOINTMENT LIST",! X "F A=1:1:IOM W ""-""" W !!,$$SDAPIERR^SDAMUTDT() D END Q
	S I="" I $O(^UTILITY($J,I))']"" W @IOF,?29,"INPATIENT APPOINTMENT LIST",! X "F A=1:1:IOM W ""-""" W !!,"NO MATCHES FOUND!" G END
	S (SDPG,I)=0 F  S I=$O(^UTILITY($J,I)) Q:I=""!(SDEND)  D HD Q:SDEND  S I2=0 F  S I2=$O(^UTILITY($J,I,I2)) Q:I2=""  D:($Y+4)>IOSL HD Q:SDEND  D APPT Q:SDEND
	G END
APPT	W:SD2 !! D:($Y+6)>IOSL HD Q:SDEND  S Y=I2 D DTS^SDUTL W !,Y S SD2=1
	;SD*618 I3=Patient's Name~DFN
	S I3=0 F  S I3=$O(^UTILITY($J,I,I2,I3)) Q:I3=""!(SDEND)  D:($Y+5)>IOSL HD Q:SDEND  W !,?2,$P(I3,"~",1),?34,$P(^DPT($P(I3,"~",2),0),"^",9) S I4=0 F  S I4=$O(^UTILITY($J,I,I2,I3,I4)) Q:I4=""  D WRTC Q:SDEND
	Q
WRTC	S SDY=$G(^UTILITY($J,I,I2,I3,I4)) I ($Y+4)>IOSL D HD Q:SDEND  W !,?2,$P(I3,"~",1),?34,$P(^DPT($P(I3,"~",2),0),"^",9)," (CONTINUED)"
	W !,?5,$P(^SC(+SDY,0),"^",1) S Y=I4,SD2=1 D AT^SDUTL W ?37,$J(Y,8) S SDB=50 F A=3:1:5 S Y="."_$P($P(SDY,"^",A),".",2) D AT^SDUTL W ?SDB,$J(Y,8) S SDB=SDB+10
	;comments/other
	I $P($G(^UTILITY($J,I,I2,I3,I4)),"^",6)]"" W !,?15,$P(^(I4),"^",6) Q
	Q
HD	I SD1,SDTT D OUT^SDUTL Q:SDEND
	S SDPG=SDPG+1,SD1=1 W !,@IOF,!,?29,"INPATIENT APPOINTMENT LIST",?69,"PAGE: ",SDPG,! S SDOS=(77-$L(I))\2 W ?SDOS,"WARD: ",I S Y=DT D DTS^SDUTL W !,?31,"DATE PRINTED: ",Y,!!
	W !!,"APPOINTMENT DATE",!,?2,"PATIENT NAME",?34,"SSN",!,?38,"APPOINT",?52,"LAB",?62,"XRAY",?72,"EKG",!,?5,"CLINIC",?38,"TIME" F A=52:10:72 W ?A,"TIME"
	W !,?15,"OTHER INFORMATION",! F A=1:1:80 W "-"
	S SD2=0 Q
END	S:'$D(IOF) IOF="#" W ! W:'SDTT @IOF
	K ^TMP($J,"SDAMA301"),^TMP($J,"SDAMA301C")
	K ALL,DIV,POP,SDT1,%DT,A,BEGDATE,DFN,DIC,DIV,ENDDATE,I,I1,I2,I3,I4
	K II,SD1,SDB,SDEND,SDOS,SDPG,SDSC,SDTT,SDW,SDXX,SDY,X,Y,SDPNDFN,PGM
	K VAR,VAL,SD2
	D CLOSE^DGUTQ,SDIAL^SDKILL
	Q
