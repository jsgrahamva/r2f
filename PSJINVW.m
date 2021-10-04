PSJINVW	;BIR/CML3-INSTRUCTION HISTORY ;4:51 AM  26 Jul 2015
	;;5.0;INPATIENT MEDICATIONS;**267,275,WVEHR,LOCAL**;16 DEC 97;Build 1
	;
	;Copyright 2015 WorldVistA.
	;
	;This build is free software: you can redistribute it and/or modify it
	;under the terms of the GNU Affero General Public License as published by
	;the Free Software Foundation, either version 3 of the License, or (at your
	;option) any later version.
	;
	;This program is distributed in the hope that it will be useful, but
	;WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
	;or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public
	;License for more details.
	;
	;You should have received a copy of the GNU Affero General Public License
	;along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	; Reference to ^PS(50.7 is supported by DBIA# 2180.
	; Reference to ^PS(51.2 is supported by DBIA# 2178.
	; Reference to ^PS(55 is supported by DBIA# 2191.
	;
EN0(PSJINHIS,PSJCHTO)	;
	N PNM,PSJFULL S PSJFULL=20
	D EN2 Q
	Q
EN2	;
	I PSGORD=+PSGORD N PSGO,PSGO1 S PSGO=PSGORD,PSGO1=0 F  S PSGO1=$O(^PS(53.1,"ACX",PSGO,PSGO1)) Q:'PSGO1  Q:$G(PSGOEA)["^"  S PSGORD=PSGO1_"P" D  S PSGORD=""
	. D EN21 K CONT D  Q:$G(PSGOEA)["^"
	.. W !!,"Press RETURN to continue or '^' to exit: " S PN=$G(PN)+2 R CONT:DTIME W @IOF S:CONT["^" PSGOEA="^",PSGPR=1,PSJPR=1
	I PSGORD="" S PSGOEA="^" Q
EN21	;
	N PSIVFLG S PSIVFLG=0 I PSGORD["P" S PSIVFLG=$P(^PS(53.1,+PSGORD,0),"^",4) S PSIVFLG=$S(PSIVFLG="F":1,PSIVFLG="I":1,1:0)
	S NF=$S(PSGORD["P":1,PSGORD["N":1,1:0)
	S (FL,Y)="",$P(FL,"-",71)="",F="^PS("_$S(NF:"53.1,",(PSGORD["V"):"55,"_PSGP_",""IV"",",1:"55,"_PSGP_",5,")_+PSGORD_","
	S PNM=$G(PSGP(0)) S:PNM="" PNM=$P($G(^DPT(PSGP,0)),"^")
	Q:($G(@(F_"0)"))="")
	I $G(PSJINHIS) D PSJINHIS(1,.PSJCHTO) Q
DONE	;
	; Begin WorldVistA Change
	;WAS;K AND,D,DRG1,DRG2,AT,DO,DRG,EB,F,FD,FL,HSM,INS,LID,MR,ND4,OD,PN,PR,PSGID,PSGOD,R,SCH,SCT,SI,SIG,SM,ST,STD,UD,X,XU,Y,DONE,NF, Q
	K AND,D,DRG1,DRG2,AT,DO,DRG,EB,F,FD,FL,HSM,INS,LID,MR,ND4,OD,PN,PR,PSGID,PSGOD,R,SCH,SCT,SI,SIG,SM,ST,STD,UD,X,XU,Y,DONE,NF Q
	;End WorldVistA Change
	Q
	;
PSJINHIS(PSJINHIS,PSJCHTO)	;
	I '$G(PSJHDRF) S PSJHDRF=1 N DASH S $P(DASH,"-",75)="-" D
	.I $E(IOST)="C" D FULL^VALM1 W @IOF
	.W !?25,"Instructions History",!,DASH S PN=$G(PN)+2
	N AND,AND2,PX S PX=""
	N INDENT1,INDENT2 S INDENT1=2,INDENT2=5
	I '$G(PSJPRCOM) D GETPRCOM Q:($G(PX)["^")
	D ENA Q:($G(PX)["^")
	Q:$G(PSJCHTO)=2
	I $G(PSGORD)["V"!$G(PSIVFLG) D PSGOPI Q
	D PSGSI
	Q
	;
PSGSI	;
	N SI,Q,QQ,QQQ S SI=$S(($G(PSGORD)["P"):$P($G(^PS(53.1,+PSGORD,6)),"^"),($G(PSGORD)["U"):$P($G(^PS(55,PSGP,5,+PSGORD,6)),"^"),1:"")
	N SIL S SIL=$$GETSIOPI^PSJBCMA5(PSGP,PSGORD,1) I SIL!(SI]"") D
	.Q:($G(PX)["^")
	.I '$G(PSJCHTO) N PSJUDGL,PSJUDPH S PSJUDGL=$S($G(PSGORD)["P":"^PS(53.1,+PSGORD,",$G(PSGORD)["U":"^PS(55,PSGP,5,+PSGORD,",1:"") D
	..I '$G(AND) N AND S AND=$P(@(PSJUDGL_"0)"),"^",16) S PSJUDPH=@(PSJUDGL_"4)") S $P(AND,"^",2)=$S($P(PSJUDPH,"^",3):$P(PSJUDPH,"^",3),$P(PSJUDPH,"^",7):$P(PSJUDPH,"^",7),1:"")
	..D:$G(PN)>PSJFULL NPAGE W !!,"Date: ",$$ENDTC^PSGMI(+AND) S PN=$G(PN)+3 W ?28,"User: ",$$ENNPN^PSGMI($P(AND,"^",2)),!?INDENT1,"SPECIAL INSTRUCTIONS changed" D
	...W !?INDENT1,"From: ''",! S PSJCHTO=1 S PN=$G(PN)+2
	.I SI]"",'SIL W !?INDENT1,"To:",!?INDENT2 S PSJCHTO=2,PN=$G(PN)+2 D  Q
	..S QQQ="" F Q=1:1:$L(SI," ") S QQ=$P(SI," ",Q) W:($L(QQQ_" "_QQ)>72) ! W QQ," " S:($L(QQQ_" "_QQ)>72) QQQ="" S QQQ=QQQ_" "_QQ
	.I $G(PSJCHTO)=2,$D(TMPTO(DFN,1)) W !?INDENT1,"From: " S PSJCHTO=1,PN=$G(PN)+1 N TMPTOLN S TMPTOLN=0 F  S TMPTOLN=$O(TMPTO(DFN,TMPTOLN)) Q:'TMPTOLN!(PX["^")  W !?INDENT2,TMPTO(DFN,TMPTOLN) S PN=PN+1 D:($G(PN)>PSJFULL) NPAGE
	.Q:'$G(PSJSYSP)  N LNTXT S LNTXT=0 F  S LNTXT=$O(^TMP("PSJBCMA5",$J,PSGP,PSGORD,LNTXT)) Q:'LNTXT  D
	..I LNTXT=1 W !?INDENT1,"To:" S PSJCHTO=2 S PN=$G(PN)+1
	..W !?INDENT2,$G(^TMP("PSJBCMA5",$J,PSGP,PSGORD,LNTXT)) S PN=$G(PN)+1 K:LNTXT=1 TMPTO S TMPTO(DFN,LNTXT)=^(LNTXT)
	Q
	;
PSGOPI	;
	N DT,USR,TXTLN,POPIL,POPI S POPI=$S($G(PSGORD)["V":$P($G(^PS(55,PSGP,"IV",+PSGORD,3)),"^"),$G(PSGORD)["P":$P($G(^PS(53.1,+PSGORD,9)),"^",2),1:"")
	S POPIL=$$GETSIOPI^PSJBCMA5(PSGP,PSGORD,1) I POPIL!(POPI]"") D
	.Q:($G(PX)["^")
	.I '$G(PSJCHTO) S $P(AND,"^")=$S(PSGORD["V":$P($G(^PS(55,PSGP,"IV",+PSGORD,2,1)),"^"),PSGORD["P":$P($G(^PS(53.1,+PSGORD,0)),"^",16),1:"") D
	..S $P(AND,"^",2)=$S(PSGORD["V":$P($G(^PS(55,PSGP,"IV",+PSGORD,4)),"^",4),PSGORD["P":$P($G(^PS(53.1,+PSGORD,4)),"^",7),1:"")
	..D:($G(PN)>PSJFULL) NPAGE W !!,"Date: ",$$ENDTC^PSGMI(+AND) S PN=$G(PN)+2 W ?28,"User: ",$$ENNPN^PSGMI($P(AND,"^",2)),!,"OTHER PRINT INFO changed" D
	...W !?INDENT1,"From: ",!?INDENT2,"""""",! S PSJCHTO=1 S PN=$G(PN)+4
	.I $G(PSJCHTO)=2,$D(TMPTO(DFN,1)) W !?INDENT1,"From: " S PSJCHTO=1,PN=$G(PN)+1 N TMPTOLN S TMPTOLN=0 F  S TMPTOLN=$O(TMPTO(DFN,TMPTOLN)) Q:'TMPTOLN!(PX["^")  W !?INDENT2,TMPTO(DFN,TMPTOLN) S PN=PN+1 D:($G(PN)>PSJFULL) NPAGE
	.S TXTLN=0 F  S TXTLN=$O(^TMP("PSJBCMA5",$J,PSGP,PSGORD,TXTLN)) Q:'TXTLN!($G(PX)["^")  D
	..I (TXTLN=1) W !?INDENT1,"To:" S PN=$G(PN)+1
	..W !?INDENT2,^TMP("PSJBCMA5",$J,PSGP,PSGORD,TXTLN) S PN=$G(PN)+1,PSJCHTO=2 K:TXTLN=1 TMPTO S TMPTO(DFN,TXTLN)=^(TXTLN) D:($G(PN)>PSJFULL) NPAGE
	Q
ENA	;
	I PSGORD["U" F Q=0:0 S Q=$O(^PS(55,PSGP,5,+PSGORD,9,Q)) Q:'Q!(PX["^")  I $D(^(Q,0)) S AND=^(0) D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D AL1
	I PSGORD["P" F Q=0:0 S Q=$O(^PS(53.1,+PSGORD,"A",Q)) Q:'Q!(PX["^")  I $D(^(Q,0)) S AND=^(0) D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D AL1
	I PSGORD["V" S Q=0 F  S Q=$O(^PS(55,PSGP,"IV",+PSGORD,"A",Q)) Q:'Q!(PX["^")  D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  S AND2=$G(^(Q,1,1,0)) I ($G(AND2)["OTHER PRINT INFO") D
	.S AND=$G(^PS(55,PSGP,"IV",+PSGORD,"A",Q,0)) D:($G(PN)>PSJFULL) NPAGE D AL1
	I ($G(PX)["^") S DONE=1
	Q
AL1	; Activity Logs
	S UD=$P(AND,"^",3)
	I AND["SPECIAL INSTRUCTIONS" D  Q
	.I ($G(PSGORD)["U") D
	..N LAST,Q2 S Q2=0 F  S Q2=$O(^PS(55,DFN,5,+PSGORD,9,Q,Q2)) Q:'Q2!(PX["^")  N Q3 S Q3=0 F  S Q3=$O(^PS(55,DFN,5,+PSGORD,9,Q,Q2,Q3)) Q:'Q3!(PX["^")  D
	...S LAST=$G(LAST)+1
	...I ($G(PSJCHTO)<2),(Q3=1),(Q2=1) D
	....I '$G(PSJCHTO) D:($G(PN)>PSJFULL) NPAGE Q:($G(PX)["^")  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	....W !?INDENT1,"To:" S PN=$G(PN)+1 N TMPQ3 S TMPQ3=0 F  S TMPQ3=$O(^PS(55,DFN,5,+PSGORD,9,Q,Q2,TMPQ3)) Q:'TMPQ3!(PX["^")  W !?INDENT2,^PS(55,DFN,5,+PSGORD,9,Q,Q2,TMPQ3,0) S PN=$G(PN)+1 S PSJCHTO=2 K:TMPQ3=1 TMPTO S TMPTO(DFN,TMPQ3)=^(0)
	...Q:PX["^"  D:($G(PN)>PSJFULL) NPAGE Q:PX["^"
	...I (Q3=1),(Q2=1) D:($G(PN)>PSJFULL) NPAGE Q:($G(PX)["^")  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	...Q:($G(PX)["^")  I (Q3=1) W !?INDENT1,$S(PSJCHTO=2:"From: ",PSJCHTO=1:"To:",1:"") S PSJCHTO=$S(PSJCHTO=2:1,1:2) S PN=$G(PN)+1 D:($G(PN)>PSJFULL)
	...W !?INDENT2,^PS(55,DFN,5,+PSGORD,9,Q,Q2,Q3,0) S PN=$G(PN)+1 K:Q3=1 TMPTO S:PSJCHTO=2 TMPTO(DFN,Q3)=^(0)
	..I '$G(LAST) N Q2TM,Q0TM S Q2TM=$P($G(^PS(55,DFN,5,+PSGORD,9,Q,0)),"^"),Q0TM=$P($G(^PS(55,DFN,5,+PSGORD,9,1,0)),"^") Q:($$FMDIFF^XLFDT(Q2TM,Q0TM,2)>0)  D
	...D CPYPC(DFN,PSGORD,Q)
	.I ($G(PSGORD)["P") D
	..I '$O(^PS(53.1,+PSGORD,"A",Q,0)) D
	...D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	...N FROM S FROM=$P(AND,"^",5) W !?INDENT1,"From: " S PN=$G(PN)+1 S PSJCHTO=1 D
	....I FROM]"" W !?INDENT2,FROM S PN=$G(PN)+1 Q
	....I $D(TMPTO(DFN,1)) N TMPTOLN S TMPTOLN=0 F  S TMPTOLN=$O(TMPTO(DFN,TMPTOLN)) Q:'TMPTOLN!(PX["^")  W !?INDENT2,TMPTO(DFN,TMPTOLN) S PN=PN+1 D:($G(PN)>PSJFULL) NPAGE
	..N QB S QB=0 F  S QB=$O(^PS(53.1,+PSGORD,"A",Q,QB)) Q:'QB!(PX["^")  N Q2 S Q2=0 F  S Q2=$O(^PS(53.1,+PSGORD,"A",Q,QB,Q2)) Q:'Q2!(PX["^")  D
	...I ($G(PSJCHTO)<2),(Q2=1),(QB=1) W !?INDENT1,"To:" S PN=$G(PN)+1,PSJCHTO=2 D
	....N TMPQ2 S TMPQ2=0 F  S TMPQ2=$O(^PS(53.1,+PSGORD,"A",Q,QB,TMPQ2)) Q:'TMPQ2!(PX["^")  W !?INDENT2,^PS(53.1,+PSGORD,"A",Q,QB,TMPQ2,0) S PN=$G(PN)+1 K:TMPQ2=1 TMPTO S TMPTO(DFN,TMPQ2)=^(0)
	...Q:PX["^"
	...I (Q2=1),(QB=1) D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	...I (Q2=1) W !?INDENT1,$S(PSJCHTO=2:"From: ",PSJCHTO=2:"To:",1:"") S PSJCHTO=$S(PSJCHTO=2:1,1:2) S PN=$G(PN)+1
	...Q:PX["^"  W !?INDENT2,^PS(53.1,+PSGORD,"A",Q,QB,Q2,0) S PN=$G(PN)+1 D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  K:Q2=1 TMPTO S:PSJCHTO=2 TMPTO(DFN,Q2)=^(0)
	I $G(AND2)["OTHER PRINT INFO"!($G(AND)["OTHER PRINT INFO") S PSJIVFLG=1 D
	.I ($G(PSGORD)["V") N Q2 F Q2=2,3 Q:(PX["^")  N Q3 S Q3=0 F  S Q3=$O(^PS(55,DFN,"IV",+PSGORD,"A",Q,Q2,Q3)) Q:'Q3!(PX["^")  D
	..I ($G(PSJCHTO)=1),Q2=2,Q3=1 D
	...N TMPQ3 S TMPQ3=0 F  S TMPQ3=$O(^PS(55,DFN,"IV",+PSGORD,"A",Q,Q2,TMPQ3)) Q:'TMPQ3!(PX["^")  D
	....D:($G(PN)>PSJFULL) NPAGE W:TMPQ3=1 !?INDENT1,"To: " W !?INDENT2,^PS(55,DFN,"IV",+PSGORD,"A",Q,Q2,TMPQ3,0) K:TMPQ3=1 TMPTO S TMPTO(DFN,TMPQ3)=^(0)
	....S PN=PN+2,PSJCHTO=2 D:($G(PN)>PSJFULL) NPAGE Q:PX["^"
	..Q:PX["^"
	..I Q3=1,($G(PSJCHTO)'=1) D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D  Q:($G(PX)["^")
	...D DATUSR($P(AND,"^",5),$P(AND,"^",3),"OTHER PRINT INFO changed")
	...;W !!,"Date: ",$$ENDTC^PSGMI($P(AND,"^",5)) W ?28,"User: ",$$ENNPN^PSGMI($P(AND,"^",3)),!,"OTHER PRINT INFO changed" S PN=$G(PN)+3
	..I Q3=1,Q2=3,'$G(PSJCHTO) W !?INDENT1,"From: """"" S PSJCHTO=1,PN=$G(PN)+1
	..I Q3=1,Q2=3,PSJCHTO=2,$D(TMPTO(DFN,1)) W !?INDENT1,"From: " S PSJCHTO=1,PN=$G(PN)+1 N TMPTOLN S TMPTOLN=0 F  S TMPTOLN=$O(TMPTO(DFN,TMPTOLN)) Q:'TMPTOLN!(PX["^")  W !?INDENT2,TMPTO(DFN,TMPTOLN) S PN=PN+1 D:($G(PN)>PSJFULL) NPAGE
	..Q:(PX["^")  I Q3=1 W !?INDENT1,$S(PSJCHTO'=1:"From: ",PSJCHTO=1:"To: ",1:"") S PSJCHTO=$S(PSJCHTO=1:2,1:1) S PN=PN+1 Q:PX["^"
	..Q:PX["^"  W !?INDENT2,^PS(55,DFN,"IV",+PSGORD,"A",Q,Q2,Q3,0) K:Q3=1 TMPTO S:PSJCHTO=2 TMPTO(DFN,Q3)=^(0) S PN=PN+1 D:($G(PN)>PSJFULL) NPAGE Q:PX["^"
	.I $G(PN)>PSJFULL D NPAGE Q:(PX["^")
	.I ($G(PSGORD)["P") D:($G(PN)>PSJFULL) NPAGE Q:PX["^"  D
	..I ($G(PSJCHTO)'=1) W !,"Date: ",$$ENDTC^PSGMI(+AND) W ?28,"User: ",$$ENNPN^PSGMI($P(AND,"^",2)),!,"OTHER PRINT INFO changed" S PN=$G(PN)+2
	..I '$G(PSJCHTO) N FROM S FROM=$P(AND,"^",5),FROM=$S(FROM]"":FROM,1:"""""") W !?INDENT1,"From: ",!?INDENT2,FROM  S PSJCHTO=1,PN=$G(PN)+1
	..N QB S QB=0 F  S QB=$O(^PS(53.1,+PSGORD,"A",Q,QB)) Q:'QB!($G(PX)["^")  N Q2 S Q2=0 F  S Q2=$O(^PS(53.1,+PSGORD,"A",Q,QB,Q2)) Q:'Q2!($G(PX)["^")  D
	...I ($G(PSJCHTO)<2),(Q2=1),(QB=1) D:($G(PN)>PSJFULL) NPAGE W !?INDENT1,"To: " S PN=$G(PN)+2,PSJCHTO=2 D  W !
	....N TMPQ2 S TMPQ2=0 F  S TMPQ2=$O(^PS(53.1,+PSGORD,"A",Q,QB,TMPQ2)) Q:'TMPQ2!(PX["^")  W !?INDENT2,^PS(53.1,+PSGORD,"A",Q,QB,TMPQ2,0) S PN=$G(PN)+1 D:($G(PN)>PSJFULL) NPAGE
	...I (Q2=1),(QB=1) D DATUSR($P(AND,"^",5),$P(AND,"^",3),"OTHER PRINT INFO changed") ; W !,"Date: ",$$ENDTC^PSGMI(+AND) W:$S(UD'?4N:1,1:$E(UD,1,2)'=10) ?28,"User: ",$$ENNPN^PSGMI($P(AND,"^",2)),!,"OTHER PRINT INFO changed" S PN=$G(PN)+2
	...I (Q2=1) D:($G(PN)>PSJFULL) NPAGE W !?INDENT1,$S(QB=1:"From: ",QB=2:"To: ",1:"") S PSJCHTO=$S(QB=2:2,1:1) S PN=$G(PN)+1
	...Q:($G(PX)["^")  W !?INDENT2,^PS(53.1,+PSGORD,"A",Q,QB,Q2,0) S PN=$G(PN)+1 D:($G(PN)>PSJFULL) NPAGE Q:PX["^"
	..I ($G(PN)>PSJFULL) D NPAGE
	Q
	;
GETPRCOM	; Get provider comments
	N PROVLN
	I $G(PSGORD)["V" S PROVLN=0 F  S PROVLN=$O(^PS(55,DFN,"IV",+PSGORD,5,PROVLN)) Q:'PROVLN!($G(PX)["^")  D
	.I (PROVLN=1) S DT=$P($G(^PS(55,DFN,"IV",+PSGORD,2)),"^"),USR=$P($G(^PS(55,DFN,"IV",+PSGORD,0)),"^",6) D DATUSR(DT,USR,"PROVIDER COMMENTS:") S PSJPRCOM=1
	.W !?INDENT2,^PS(55,DFN,"IV",+PSGORD,5,PROVLN,0) S PN=$G(PN)+1 I ($G(PN)>PSJFULL) D NPAGE
	I $G(PSGORD)["U" S PROVLN=0 F  S PROVLN=$O(^PS(55,DFN,5,+PSGORD,12,PROVLN)) Q:'PROVLN!($G(PX)["^")  D
	.I (PROVLN=1) S DT=$P($G(^PS(55,DFN,5,+PSGORD,0)),"^",16),USR=$P($G(^PS(55,DFN,5,+PSGORD,0)),"^",2) D DATUSR(DT,USR,"PROVIDER COMMENTS:") S PSJPRCOM=1
	.W !?INDENT2,^PS(55,DFN,5,+PSGORD,12,PROVLN,0) S PN=$G(PN)+1 I ($G(PN)>PSJFULL) D NPAGE
	I $G(PSGORD)["P" S PROVLN=0 F  S PROVLN=$O(^PS(53.1,+PSGORD,12,PROVLN)) Q:'PROVLN!($G(PX)["^")  D
	.I (PROVLN=1) S DT=$P($G(^PS(53.1,+PSGORD,0)),"^",16),USR=$P($G(^PS(53.1,+PSGORD,0)),"^",2) D DATUSR(DT,USR,"PROVIDER COMMENTS:") S PSJPRCOM=1
	.W !?INDENT2,^PS(53.1,+PSGORD,12,PROVLN,0) S PN=$G(PN)+1 I ($G(PN)>PSJFULL) D NPAGE
	D:($G(PN)>PSJFULL) NPAGE
	Q
NPAGE	; Pause
	Q:$G(PSJPTR)
	I PN<PSJFULL F PN=PN:1:PSJFULL-1 W !
	I $E(IOST)="C" R !!,"Enter '^' to stop, or press RETURN to continue.",PX:DTIME D
	.I $G(PX)["^" S DONE=1
	.D FULL^VALM1 W @IOF
	W !?25,"Instructions History" S PN=1
	N DASH S $P(DASH,"-",75)="-" W !,DASH S PN=$G(PN)+1
	Q
	;
DATUSR(DT,USR,TXT)	;
	I $G(PN)>(PSJFULL-5) D NPAGE Q:(PX["^")
	N DAT,USER
	S DAT=$$ENDTC^PSSGMI(DT),USER=$$ENNPN^PSGMI(USR)
	W !!,"Date: ",DAT,?28,"User: ",USER,!,TXT S PN=$G(PN)+3
	Q
	;
CPYPC(DFN,PSGORD,Q)	; Handle Special Instructions copied in from Provider Comments during finishing
	Q:$O(^PS(55,DFN,5,+PSGORD,9,Q,0))
	N PS55ND0 S PS55ND0=$G(^PS(55,DFN,5,+PSGORD,0))
	N PRVORD S PRVORD=$P(PS55ND0,"^",25) Q:'PRVORD
	N PRVSI S PRVSI=$$GETSIOPI^PSJBCMA5(DFN,PRVORD,1) Q:'PRVSI
	I ($G(PSJCHTO)=2) D
	.D:($G(PN)>PSJFULL) NPAGE Q:($G(PX)["^")  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	.W !?INDENT1,"From:" S PN=$G(PN)+1 N TMPQ3 S TMPQ3=0 F  S TMPQ3=$O(^TMP("PSJBCMA5",$J,DFN,PRVORD,TMPQ3)) Q:'TMPQ3!(PX["^")  D
	..W !?INDENT2,^TMP("PSJBCMA5",$J,DFN,PRVORD,TMPQ3) S PN=$G(PN)+1 S PSJCHTO=2 K:TMPQ3=1 TMPTO S TMPTO(DFN,TMPQ3)=^TMP("PSJBCMA5",$J,DFN,PRVORD,TMPQ3)
	.S PSJCHTO=1
	Q:PX["^"  D:($G(PN)>PSJFULL) NPAGE Q:PX["^"
	D:($G(PN)>PSJFULL) NPAGE Q:($G(PX)["^")  D DATUSR(+AND,$P(AND,"^",2),"SPECIAL INSTRUCTIONS changed")
	Q:($G(PX)["^")  W !?INDENT1,$S(PSJCHTO=2:"From: ",PSJCHTO=1:"To:",1:"") S PSJCHTO=$S(PSJCHTO=2:1,1:2) S PN=$G(PN)+1
	N TOSI,FOUNDTO S TOSI=Q F  Q:$G(FOUNDTO)  S TOSI=$O(^PS(55,DFN,5,+PSGORD,9,TOSI)) Q:'TOSI  I $G(^PS(55,DFN,5,+PSGORD,9,TOSI,0))["SPECIAL INSTRUCTIONS" S FOUNDTO=TOSI
	I $G(FOUNDTO) S TOSI=0 F  S TOSI=$O(^PS(55,DFN,5,+PSGORD,9,FOUNDTO,1,TOSI)) Q:'TOSI  D
	.W !?INDENT2,^PS(55,DFN,5,+PSGORD,9,FOUNDTO,1,TOSI,0) S PN=$G(PN)+1 K:TOSI=1 TMPTO S:PSJCHTO=2 TMPTO(DFN,TOSI)=^(0)
	Q:$G(FOUNDTO)
	S TOSI=0 F  S TOSI=$O(^PS(55,DFN,5,+PSGORD,15,TOSI)) Q:'TOSI  W !?INDENT2,$G(^(TOSI,0))
	Q
