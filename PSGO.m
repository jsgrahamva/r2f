PSGO	;BIR/CML3,MV-PRINTS PATIENT'S ORDERS ;10 Feb 98 / 1:32 PM
	;;5.0;INPATIENT MEDICATIONS;**4,58,110,181,275**;16 DEC 97;Build 157
	;
	; Reference to ^PS(55 is supported by DBIA #2191.
	;
	K ^TMP("PSJON",$J),PSGONF S PSGOH="U N I T   D O S E   P R O F I L E" D ENGORD^PSGOU
	;
EN	;
	N TF2 S TF2=""
	S CML=IO'=IO(0)!($E(IOST,1,2)'="C-"),NP="" N RB
	U IO D GET I '$D(^TMP("PSG",$J)) W !,SLS,SLS,$E(SLS,1,24),!?22,"NO ORDERS FOUND" W:"SL"[PSGOL " FOR A ",$S(PSGOL="S":"SHORT",1:"LONG")," PROFILE."
	G:NP["^" DONE
	E  S (C,DRG)="",LD=0
	E  D DRG G:NP["^" DONE
	I CML,$S('$D(PSGPRP):1,1:PSGPRP="P") D BOT
	;
DONE	;
	I $S('$D(PSGPRP):1,1:PSGPRP="P") K ^TMP("PSG",$J)
	S PSGON=$S('CML:ON,1:0) K:'$D(PSGVBW) PSGODT
	;
D1	;
	K C,CML,DN,DO,DRG,F,GIVE,HDT,LN2,NF,ND,ND4,ND6,NP,O,ON,PF,PG,PSGHD,PSGOH,PSJTEAM,RCT,RF,RTE,S,SCH,SD,SLS,SM,ST,STS,TF,UDU,V,WD,WS,WT Q
	;
DRG	;
	I PSGOL'="N" F  S C=$O(^TMP("PSG",$J,C)) Q:C=""!(NP["^")  D:$S(($P(C,"^")="Cz")&(TF2'=$P(C,"^",2)):1,C="BA":1,C="CC":1,C="CD":1,C["C":TF,1:1) TF F ST="C","O","OC","P","R","z" D
	.F  S DRG=$O(^TMP("PSG",$J,C,ST,DRG)) Q:DRG=""!(NP["^")  S NF=^(DRG),O=$P(DRG,"^",2),DN=$P(DRG,"^") D:$Y+4>IOSL NP Q:NP["^"  D P
	I PSGOL="N" F  S LD=$O(^TMP("PSG",$J,LD)) Q:'LD  S X=^(LD),NF=$P(X,U),C=$P(X,U,2),ST=$P(X,U,3),DN=$P(X,U,4),O=$P(LD,U,2) D P
	Q
	;
P	;Display drug data stored in ^TMP("PSG",$J
	I $G(O)["U"&($P(C,"^",4)="A") N F S F="^PS(55,PSGP,5,"
	S ON=ON+1 I 'CML D
	.N PSJOSUFX I ($P(C,"^")="Cz") S PSJOSUFX=$S(($P(C,"^",4))["CD":"",($P(C,"^",4)["C"):"P",($P(C,"^",4)["BD"):"",($P(C,"^",4)["B"):"P",1:"U")
	.I ($P(C,"^")'="Cz") S PSJOSUFX=$S(C["CD":"",C["C":"P",C["BD":"",C["B":"P",1:"U")
	.S ^TMP("PSJON",$J,ON)=+O_PSJOSUFX
	.S:(C'["O"&($P(C,"^")'="Cz")) PSGONC=ON S:($P(C,"^")="Cz"&($P(C,"^",4)'["O")) PSGONC=ON
	Q:PSGOL="N"
	W !,$J(ON,4),?5
	I (C["CD"&($P(C,"^")'="Cz"))!($P(C,"^",4)["CD") N PSJO,OO S PSJO=O,OO=0 F  S OO=$O(^PS(53.1,"ACX",PSJO,OO)) Q:'OO  S O=OO D P2 W !
	I (C["BD"&($P(C,"^")'="Cz"))!($P(C,"^",4)["BD") N PSJO,OO S PSJO=O,OO=0 F  S OO=$O(^PS(53.1,"ACX",PSJO,OO)) Q:'OO  S O=OO D P2 W !
	Q:(C["BD"&($P(C,"^")'="Cz"))  Q:(C["CD"&($P(C,"^")'="Cz"))  Q:($P(C,"^",4)["BD")  Q:($P(C,"^",4)["CD")
	; naked references below refer to full reference inside indirection @(F_+O_".0)" for either file 53.1 or 55
P2	S ND=$G(@(F_+O_",0)")),SCH=$G(^(2)),ND4=$G(^(4)),ND6=$G(^(6)),DO=$G(^(.2))
	I (C="A"!($P(C,"^",4)="A")),PSJSYSU,'$P(ND4,"^",+PSJSYSU),$P(ND4,"^",+PSJSYSU=1+9) S PSGONV=ON
	I (C="A"!(C="O"))!(($P(C,"^",4)="A")!($P(C,"^",4)="O")) S:$P(ND,"^",9)'="H"&'CML PSGONR=ON D
	.S V='$P(ND4,"^",UDU),V=$S(+PSJSYSU=1&V:1,+PSJSYSU=3&V:1,1:0)
	.W $S(ND4="":" ",$P(ND4,"^",12):"D",V!$P(ND4,"^",19)&$P(ND4,"^",18):"H",V!$P(ND4,"^",23)&$P(ND4,"^",22):"H",V!$P(ND4,"^",16)&$P(ND4,"^",15):"R",1:" ")
	.W $S($P(DO,U,4)="D":"d",1:" ")_$S(V:"->",1:"  ")
	I ($P(C,"^")="Cz")&(($P(C,"^",4)="CA")!($P(C,"^",4)["B")) W $S($P(ND4,"^",12):"D",1:" ") I ($P(C,"^",4)["B") S PSGONF=$S('$G(PSGONF):ON_U_ON,1:+PSGONF_U_ON)
	I ($P(C,"^")'="Cz") I C="CA"!(C["B") W $S($P(ND4,"^",12):"D",1:" ") I C["B" S PSGONF=$S('$G(PSGONF):ON_U_ON,1:+PSGONF_U_ON)
	S SM=2-$S('$P(ND,"^",5):2,1:$P(ND,"^",6)),STS=$S($P(ND,U,28)]"":$P(ND,U,28),$P(ND,"^",9)]"":$P(ND,"^",9),1:"NF"),PF=$E("*",$P(ND,"^",20)>0),PSGID=$P(SCH,"^",2),SD=$P(SCH,"^",4) D
	.I ($P(C,"^")["C"&($P(C,"^")'["z"))!($P(C,"^",4)["C") S (PSGID,SD)="",PSGOD="********"
	I STS="A",($P(ND,U,27)="R") S STS="R"
	S WS=0,PSGOD=$$ENDTC^PSGMI(PSGID)
	S:PSJPWD WS=$$WS^PSJO(PSJPWD,PSGP,F,+O)
	NEW MARX
	S PSJORFLG=""
	S:($P(C,"^")'="Cz") PSJORFLG=+O_$S(C["B":"P",C["C":"P",1:"U") S:($P(C,"^")="Cz") PSJORFLG=+O_$S($P(C,"^",4)["B":"P",$P(C,"^",4)["C":"P",1:"U")
	D DRGDISP^PSJLMUT1(PSGP,PSJORFLG,40,54,.MARX,0)
	NEW X F X=0:0 S X=$O(MARX(X)) Q:'X  W @($S(X=1:"?9",1:"!?11")) W MARX(X) D:X=1
	. N RNDT,O2 S O2=O S:+O2=O O2=O2_"P" S RNDT=$$LASTREN^PSJLMPRI(PSGP,O2) I RNDT]"" S RNDT=$E($$ENDTC^PSGMI(RNDT),1,5)
	. I ($P(C,"^")'="Cz") W ?50,$S(C["C":"?",ST'="z":ST,1:"?"),?53,$E(PSGOD,1,5)
	. I ($P(C,"^")="Cz") W ?50,$S($P(C,"^",4)["C":"?",ST'="z":ST,1:"?"),?53,$E(PSGOD,1,5)
	. S SD=$$ENDTC^PSGMI(SD) W ?60,$E(SD,1,5),?67,STS
	. I NF!WS!SM!PF!RNDT W ?71 W:NF "NF " W:WS "WS " W:RNDT RNDT_" " W:SM $E("HSM",SM,3) W:PF ?79,"*"
	I ND6]"" S Y=$$ENSET^PSGSICHK($P(ND6,"^")) W !?11 F X=1:1:$L(Y," ") S V=$P(Y," ",X) W:$L(V)+$X>66 !?11 W V_" "
	K PSJORFLG
	Q
	;
TF	;
	NEW SLS S SLS="",$P(SLS," -",40)=""
	I $P(C,"^")="Cz" Q:(TF2=$P(C,"^",2))  S TF2=$P(C,"^",2)
	S LN2=$S(($P(C,"^")="Cz"):$$TXT^PSJO(C),C="A":$$TXT^PSJO("A"),C["CC":$$TXT^PSJO("PR"),C["CD":$$TXT^PSJO("PC"),C["C":$$TXT^PSJO("P"),C["BD":$$TXT^PSJO("NC"),C["B":$$TXT^PSJO("N"),C="DF":$$TXT^PSJO("DF"),1:$$TXT^PSJO("NA"))
	W:$D(^TMP("PSG",$J,C)) !,$E($E(SLS,1,(80-$L(LN2))/2)_" "_LN2_$E(SLS,1,(80-$L(LN2))/2),1,80)
	I $P(C,"^")'="Cz" S F="^PS("_$S(C["C":"53.1,",C["B":"53.1,",1:"55,"_PSGP_",5,",1:"53.1,") S TF=$S(C["C":0,1:TF)
	I $P(C,"^")="Cz" N CCL S CCL=$P(C,"^",4) S F="^PS("_$S(CCL["C":"53.1,",CCL["B":"53.1,",1:"55,"_PSGP_",5,",1:"53.1,") S TF=$S(CCL["C":0,1:TF)
	Q
	;
GET	;
	S $P(LN2,"-",81)="",PG=$D(PSGVWA),(ON,PSGONC,PSGONR,PSGONV,SLS)="",$P(SLS," -",15)="",TF=1,RB=$S(PSJPRB]"":PSJPRB,1:"*NF*"),WD=$S(PSJPWDN]"":PSJPWDN,PSJPWD:PSJPWD_";DIC(42,",1:"*NF*")
	;
NP	I ON,'CML W $C(7) R !," '^' TO QUIT ",NP:DTIME W:'$T $C(7) S:'$T NP="^" W:NP'["^" $C(13),"                     ",$C(13),# Q
	I ON,CML D BOT
	Q:$G(PSGOL)="N"
	;
HEADER	;
	S PG=PG+1
	S:'$D(PSJOPC) PSJOPC=1 S PSJTEAM=$S($D(PSJSEL("TM")):1,1:0)
	D ENTRY^PSJHEAD(PSGP,PSJOPC,PG,$G(PSJNARC),PSJTEAM)
	W:PG>1 !,$E(LN2,1,80) Q
	;
BOT	;
	F Q=$Y:1:IOSL-4 W !
	W !,?2,$P(PSGP(0),"^"),?40,PSJPPID,?70,$E($P(PSJPDOB,"^",2),1,8) Q
	;
ENHEAD	;
	K LN2,PSGPR,PSGPRP D NOW^%DTC S HDT=$$ENDTC^PSGMI(+$E(%,1,12)),PSGVWA=1,PSGOH="U N I T   D O S E   P R O F I L E" D GET
	D D1 K PSGONC,PSGONR,PSGONV,PSGVWA Q
	;
ENVBW	;
	S PSGOH=$S(PSGVBWTO=1:"N O N - V E R I F I E D   O R D E R S",PSGVBWTO=2:"P E N D I N G   O R D E R S",1:"N O N - V E R I F I E D / P E N D I N G   O R D E R S")
	D EN Q
ENPR	;
	S PSGOH="U N I T  D O S E  P R O F I L E" G GET
	Q
