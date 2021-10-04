PSSOPKI1	;BIR/MHA-DEA/PKI CPRS Dosage call ;03/29/02
	;;1.0;PHARMACY DATA MANAGEMENT;**61,69,83,138**;9/30/97;Build 5
	;Reference ^PS(50.607 - DBIA 2221
	;Reference ^YSCL(603.01 - DBIA 2697
	;
DOSE(PSSX,PD,TYPE,PSSDFN)	;
	K PSSX
	; PSSX - Target array
	; PD - Orderable Item
	; TYPE - O:Outpt, U:Unit Dose, I:IV, X:Non-VA Med
	; PSSDFN - Patient
	;
	N DLOOP,DCNT1,DLOOP1,LOW,FORM,PSSOIU,PSSLOW,PSSLOW1,PSSLOW2,PSOLC,PL,PSSHOLD,PSSA,PSSZ,PSSC,PSIEN,PSSTRN,PSSDSE,PSSVERB,PSSPREP,PSSCLO,PSSDEA,PSSMAX,PSSDLP,PSNN,PSNNN,PSSREQS,PSSLOW4,PL2,PSSA1,PL3,PSSUNITX,PSSLD,PSSLD1
	N PSSDOSE,PSSUNTS,PSSUDOS,PSSQT,PSSBCM,PSSHLF
	S PSSOIU=$S(TYPE="I":1,TYPE="U":1,1:0)
	F DLOOP=0:0 S DLOOP=$O(^PSDRUG("ASP",PD,DLOOP)) Q:'DLOOP  D
	.Q:'$O(^PSDRUG(DLOOP,"DOS1",0))
	.S PSSTRN=$P($G(^PSDRUG(DLOOP,"DOS")),"^"),PSSUNITX=$P($G(^("DOS")),"^",2) Q:PSSTRN=""
	.S PSSUNITX=$S($P($G(^PS(50.607,+$G(PSSUNITX),0)),"^")'=""&($P($G(^(0)),"^")'["/"):$P($G(^(0)),"^"),1:"")
	.I $P($G(^PSDRUG(DLOOP,"I")),"^"),+$P($G(^("I")),"^")<DT Q
	.D APP Q:PSSQT
	.S PSSDSE=+$P($G(^PS(50.7,PD,0)),"^",2),PSSVERB=$P($G(^PS(50.606,PSSDSE,"MISC")),"^"),PSSPREP=$P($G(^("MISC")),"^",3)
	.K PSNNN F PSNN=0:0 S PSNN=$O(^PS(50.606,PSSDSE,"NOUN",PSNN)) Q:'PSNN!($D(PSNNN))  S:$P($G(^(PSNN,0)),"^")'="" PSNNN=$P($G(^(0)),"^")
	.I $G(PSNNN)["&" S PSLOCV=PSNNN D AMP^PSSORPH1 S PSNNN=PSLOCV
	.; possible doses
	.F DLOOP1=0:0 S DLOOP1=$O(^PSDRUG(DLOOP,"DOS1",DLOOP1)) Q:'DLOOP1  D
	..Q:'$D(^PSDRUG(DLOOP,"DOS1",DLOOP1,0))
	..I PSSOIU,$P($G(^PSDRUG(DLOOP,"DOS1",DLOOP1,0)),"^",3)'["I" Q
	..I 'PSSOIU,$P($G(^PSDRUG(DLOOP,"DOS1",DLOOP1,0)),"^",3)'["O" Q
	..S (PSSDOSE,PSSUNTS,PSSUDOS)=""
	..S PSSDOSE=$P($G(^PSDRUG(DLOOP,"DOS1",DLOOP1,0)),"^",2)
	..S PSSUNTS=$P($G(^PS(50.607,+$P($G(^PSDRUG(DLOOP,"DOS")),"^",2),0)),"^")
	..S PSSUDOS=$P($G(^PSDRUG(DLOOP,"DOS1",DLOOP1,0)),"^"),PSSBCM=$P($G(^(0)),"^",4) I PSSUDOS["." S PSSHLF(DLOOP)=""
	..I PSSDOSE]""&(PSSUDOS]"") D
	...S DCNT1=$S('$D(DCNT1):1,1:DCNT1+1)
	...S LOW(PSSDOSE,PSSUDOS,DCNT1)=""
	...S FORM(PSSDOSE,$S($P($G(^PSDRUG(DLOOP,0)),"^",9)=1:1,1:0),DCNT1)=PSSUDOS
	...D PARN
	...S PSSX(DCNT1)=PSSDOSE_"^"_PSSUNTS_"^"_$S($E($G(PSSUDOS),1)=".":"0",1:"")_PSSUDOS_"^"_$S($G(PSSNP)'="":$G(PSSNP),1:$G(PSNNN))_"^^"_DLOOP_"^"_$$PRICE^PSSUTLA1 K PSSNP
	I '$O(PSSX(0)) G DOSE2
	; delete n/f duplicate doses
	S PSSLOW="" F  S PSSLOW=$O(FORM(PSSLOW)) Q:PSSLOW=""  D
	.I $O(FORM(PSSLOW,0,0)) S PSSLOW2="" F  S PSSLOW2=$O(FORM(PSSLOW,1,PSSLOW2)) Q:PSSLOW2=""  K PSSX(PSSLOW2),LOW(PSSLOW,+$G(FORM(PSSLOW,1,PSSLOW2)),PSSLOW2)
	;Lowest UPD
	S PSSLOW="" F  S PSSLOW=$O(LOW(PSSLOW)) Q:PSSLOW=""  D
	.S PSOLC=0 S PSSLOW1="" F  S PSSLOW1=$O(LOW(PSSLOW,PSSLOW1)) Q:PSSLOW1=""  D
	..S PSOLC=PSOLC+1 S:PSOLC=1 PSSLOW4=$O(LOW(PSSLOW,PSSLOW1,0))
	..S PSSLOW2="" F  S PSSLOW2=$O(LOW(PSSLOW,PSSLOW1,PSSLOW2)) Q:PSSLOW2=""  D
	...I PSOLC>1 S PSSX(PSSLOW4,(PSOLC-1))=PSSX(PSSLOW2) K PSSX(PSSLOW2)
	K PSSHOLD S PL="" F  S PL=$O(PSSX(PL)) Q:PL=""  S PSSHOLD($P(PSSX(PL),"^"),PL)=PSSX(PL) I $O(PSSX(PL,0)) D
	.S PL2="" F  S PL2=$O(PSSX(PL,PL2)) Q:PL2=""  S PSSHOLD($P(PSSX(PL,PL2),"^"),PL,PL2)=PSSX(PL,PL2)
	K PSSX S PSSA=1,PSSZ="" F  S PSSZ=$O(PSSHOLD(PSSZ)) Q:PSSZ=""  F PSSC=0:0 S PSSC=$O(PSSHOLD(PSSZ,PSSC)) Q:'PSSC  S PSSX(PSSA)=PSSHOLD(PSSZ,PSSC) D SLS D:'$D(PSSX("DD",+$P(PSSX(PSSA),"^",6)))  D:$O(PSSHOLD(PSSZ,PSSC,0)) MULTI S PSSA=PSSA+1
	.S (PSIEN,DLOOP)=+$P(PSSX(PSSA),"^",6) K PSSMAX D:$G(TYPE)["O" MAX
	.;ELR;ADDED NEXT LINE PSS*1*83
	.D SETU
	.S PSSX("DD",PSIEN)=$P($G(^PSDRUG(PSIEN,0)),"^")_"^"_$P($G(^(660)),"^",6)_"^"_$P($G(^(0)),"^",9)_"^"_$P($G(^(660)),"^",8)_"^"_$P($G(^("DOS")),"^")
	.S PSSX("DD",PSIEN)=PSSX("DD",PSIEN)_"^"_$G(PSSUNITX)_"^"_$P($G(^PS(50.606,+$G(PSSDSE),0)),"^")_"^"_$G(PSSMAX)
	.D REQS S PSSX("DD",PSIEN)=PSSX("DD",PSIEN)_"^"_$G(PSSREQS) D DEAPKI^PSSOPKI(PSIEN)
	.S PSSX("MISC")=$G(PSSVERB)_"^"_$G(PSSPREP)_"^"_$P($G(^PS(50.606,+$G(PSSDSE),"MISC")),"^",4)
	K PSSHOLD,PSSDZUNT
	D LEAD^PSSUTLA1 D:$G(TYPE)["O" EN3^PSSUTLA1(PD,245)
	S PSSX("DEA")=$$OIDEA^PSSOPKI(PD,TYPE)
	Q
DOSE2	;Local doses
	N PSOCT,PSONDS,PSOND,PSOND1,PSONDX,PSONDU,PSODOS,PSLOC,PSLOCV,PSODUPD,PSOXDOSE
	S PSOCT=1
	S PSOXDOSE=+$P($G(^PS(50.7,PD,0)),"^",2) K PSNNN
	F DLOOP=0:0 S DLOOP=$O(^PSDRUG("ASP",PD,DLOOP)) Q:'DLOOP  D
	.I $P($G(^PSDRUG(DLOOP,"I")),"^"),+$P($G(^("I")),"^")<DT Q
	.D APP Q:PSSQT
	.Q:'$O(^PSDRUG(DLOOP,"DOS2",0))
	.S PSONDS=$P($G(^PSDRUG(DLOOP,"DOS")),"^"),PSONDU=$P($G(^("DOS")),"^",2),PSOND=$P($G(^("ND")),"^",3),PSOND1=$P($G(^("ND")),"^")
	.I PSOND,PSOND1 I PSONDS=""!('PSONDU) S PSONDX=$$DFSU^PSNAPIS(PSOND1,PSOND)
	.I PSONDS="",PSOND,PSOND1 S PSONDS=$P($G(PSONDX),"^",4) D NS
	.I 'PSONDU,PSOND,PSOND1 S PSONDU=$P($G(PSONDX),"^",5)
	.D NU
	.S PSODOS=+$P($G(^PS(50.7,PD,0)),"^",2)
	.F PSLOC=0:0 S PSLOC=$O(^PSDRUG(DLOOP,"DOS2",PSLOC)) Q:'PSLOC  D
	..S PSLOCV=$P($G(^PSDRUG(DLOOP,"DOS2",PSLOC,0)),"^"),PSSBCM=$P($G(^(0)),"^",3) Q:PSLOCV=""
	..I PSSOIU,$P($G(^PSDRUG(DLOOP,"DOS2",PSLOC,0)),"^",2)'["I" Q
	..I 'PSSOIU,$P($G(^PSDRUG(DLOOP,"DOS2",PSLOC,0)),"^",2)'["O" Q
	..D SET2
	;no doses
	K PSSBCM
	I '$O(PSSX(0)) K PSLOCV S PSOCT=1 D
	.F DLOOP=0:0 S DLOOP=$O(^PSDRUG("ASP",PD,DLOOP)) Q:'DLOOP  D
	..I $P($G(^PSDRUG(DLOOP,"I")),"^"),+$P($G(^("I")),"^")<DT Q
	..D APP Q:PSSQT
	..S PSONDS=$P($G(^PSDRUG(DLOOP,"DOS")),"^"),PSONDU=$P($G(^("DOS")),"^",2),PSOND=$P($G(^("ND")),"^",3),PSOND1=$P($G(^("ND")),"^")
	..K PSONDX I PSOND,PSOND1 I PSONDS=""!('PSONDU) S PSONDX=$$DFSU^PSNAPIS(PSOND1,PSOND)
	..I PSONDS="",PSOND,PSOND1 S PSONDS=$P($G(PSONDX),"^",4) D NS
	..I 'PSONDU,PSOND,PSOND1 S PSONDU=$P($G(PSONDX),"^",5)
	..D NU
	..S PSODOS=+$P($G(^PS(50.7,PD,0)),"^",2)
	..D SET3
	D LEAD^PSSUTLA1 D:$G(TYPE)["O" EN3^PSSUTLA1(PD,245)
	S PSSX("DEA")=$$OIDEA^PSSOPKI(PD,TYPE)
	D DUP^PSSUTLA1
	Q
SET2	;
	I $G(PSLOCV)'="",$G(PSLOCV)["&" D AMP^PSSORPH1
	K PSSUDOS S PSSX(PSOCT)="^"_$G(PSONDU)_"^^"_$G(PSNNN)_"^"_$G(PSLOCV)_"^"_DLOOP_"^"_$$PRICE^PSSUTLA1
SET3	;
	I '$D(PSSX("DD",DLOOP)) D
	.D REQS
	.K PSSMAX I $G(TYPE)["O" D MAX
	.S PSSX("DD",DLOOP)=$P($G(^PSDRUG(DLOOP,0)),"^")_"^"_$P($G(^(660)),"^",6)_"^"_$P($G(^(0)),"^",9)_"^"_$P($G(^(660)),"^",8)_"^"_$G(PSONDS)_"^"_$G(PSONDU)
	.S PSSX("DD",DLOOP)=PSSX("DD",DLOOP)_"^"_$P($G(^PS(50.606,+$G(PSODOS),0)),"^")_"^"_$G(PSSMAX)_"^"_$G(PSSREQS) D DEAPKI^PSSOPKI(DLOOP)
	.S PSSX("MISC")=$P($G(^PS(50.606,+$G(PSODOS),"MISC")),"^")_"^"_$P($G(^("MISC")),"^",3)_"^"_$P($G(^("MISC")),"^",4)
	S PSOCT=PSOCT+1
	Q
MAX	;
	K PSSMAX S PSSDEA=$P($G(^PSDRUG(DLOOP,0)),"^",3)
	I PSSDEA["1"!(PSSDEA["2") S PSSMAX=0 Q
	I PSSDEA["A",PSSDEA'["B" S PSSMAX=0 Q
	I $P($G(^PSDRUG(DLOOP,"CLOZ1")),"^")="PSOCLO1",$G(PSSDFN) D  Q
	.S PSSCLO=$O(^YSCL(603.01,"C",PSSDFN,0)) I PSSCLO,$P($G(^YSCL(603.01,+PSSCLO,0)),"^",3)="B" S PSSMAX=1 Q
	.S PSSMAX=0
	I PSSDEA["3"!(PSSDEA["4")!(PSSDEA["5") S PSSMAX=5 Q
	S PSSMAX=11
	Q
SLS	;Dosage with /
	K PSSDZUNT
	I $P($G(PSSX(PSSA)),"^",2)'["/" S $P(PSSX(PSSA),"^",5)=$P($G(PSSX(PSSA)),"^")_$P($G(PSSX(PSSA)),"^",2) Q
	N PSSF,PSSF1,PSSF2,PSSG,PSSFA,PSSFA1,PSSFB,PSSFB1,PSSDZI,PSSDZSL,PSSDZND,PSSDZSL1,PSSDZSL2,PSSDZSL3,PSSDZSL4,PSSDZSL5,PSSDZ50
	S PSSF=$P($G(PSSX(PSSA)),"^"),PSSG=$P($G(PSSX(PSSA)),"^",2)
	S PSSDZSL=0,PSSDZI=+$P($G(PSSX(PSSA)),"^",6),PSSDZ50=$P($G(^PSDRUG(PSSDZI,"DOS")),"^")
	S PSSDZND=$$PSJST^PSNAPIS(+$P($G(^PSDRUG(PSSDZI,"ND")),"^"),+$P($G(^PSDRUG(PSSDZI,"ND")),"^",3)) S PSSDZND=+$P($G(PSSDZND),"^",2) ;I $G(PSSDZND),$G(PSSDZ50),+$G(PSSDZND)'=+$G(PSSDZ50) S PSSDZSL=1
	S PSSFA=$P(PSSG,"/"),PSSFB=$P(PSSG,"/",2),PSSFA1=+$G(PSSFA),PSSFB1=+$G(PSSFB)
	I '$G(PSSDZND) S $P(PSSX(PSSA),"^",5)=$P(PSSX(PSSA),"^") G SLSQ
	S PSSDZSL2=PSSDZ50/PSSDZND,PSSDZSL3=PSSDZSL2*+$P($G(PSSX(PSSA)),"^",3) S PSSDZSL4=PSSDZSL3*$S($G(PSSFB1):PSSFB1,1:1) S PSSDZSL5=$S('$G(PSSFB1):PSSDZSL4_$G(PSSFB),1:PSSDZSL4_$P(PSSFB,PSSFB1,2))
	S PSSF2=$S('$G(PSSFA1):PSSF,1:($G(PSSFA1)*PSSF))_$S($G(PSSFA1):$P(PSSFA,PSSFA1,2),1:PSSFA)_"/"_$G(PSSDZSL5)
	S PSSDZUNT=$P(PSSG,"/")_"/"_$G(PSSDZSL4)_$S('$G(PSSFB1):$G(PSSFB),1:$P(PSSFB,PSSFB1,2)) S $P(PSSX(PSSA),"^",2)=PSSDZUNT
	S $P(PSSX(PSSA),"^",5)=PSSF2
SLSQ	Q
REQS	;
	S PSSREQS=1
	Q
MULTI	;
	S PL3="" F  S PL3=$O(PSSHOLD(PSSZ,PSSC,PL3)) Q:PL3=""  S PSSX(PSSA,PL3)=PSSHOLD(PSSZ,PSSC,PL3) D SLS^PSSUTLPR D:'$D(PSSX("DD",+$P(PSSX(PSSA,PL3),"^",4)))
	.S (PSIEN,DLOOP)=+$P(PSSX(PSSA,PL3),"^",6) K PSSMAX D:$G(TYPE)["O" MAX
	.;ELR;ADDED NEXT LINE PSS*1*83
	.D SETU
	.S PSSX("DD",PSIEN)=$P($G(^PSDRUG(PSIEN,0)),"^")_"^"_$P($G(^(660)),"^",6)_"^"_$P($G(^(0)),"^",9)_"^"_$P($G(^(660)),"^",8)_"^"_$P($G(^("DOS")),"^")
	.S PSSX("DD",PSIEN)=PSSX("DD",PSIEN)_"^"_$G(PSSUNITX)_"^"_$P($G(^PS(50.606,+$G(PSSDSE),0)),"^")_"^"_$G(PSSMAX)
	.D REQS S PSSX("DD",PSIEN)=PSSX("DD",PSIEN)_"^"_$G(PSSREQS) D DEAPKI^PSSOPKI(PSIEN)
	.S PSSX("MISC")=$G(PSSVERB)_"^"_$G(PSSPREP)_"^"_$P($G(^PS(50.606,+$G(PSSDSE),"MISC")),"^",4)
	K PSSJZUNT
	Q
PARN	;
	N PSSNPL K PSSNP
	Q:$G(PSNNN)=""
	Q:$L(PSNNN)'>3
	S PSSNPL=$E(PSNNN,($L(PSNNN)-2),$L(PSNNN))
	I $G(PSSNPL)="(S)"!($G(PSSNPL)="(s)") D
	.I $G(PSSUDOS)'>1 S PSSNP=$E(PSNNN,1,($L(PSNNN)-3))
	.I $G(PSSUDOS)>1 S PSSNP=$E(PSNNN,1,($L(PSNNN)-3))_$E(PSSNPL,2)
	Q
APP	; Checking Application Use
	N APPUSE
	S PSSQT=0,APPUSE=$P($G(^PSDRUG(DLOOP,2)),"^",3)
	I $G(TYPE)="O" S:APPUSE'["O" PSSQT=1 Q
	I $G(TYPE)="X" S:APPUSE'["X" PSSQT=1 Q
	I APPUSE'["U",APPUSE'["I" S PSSQT=1
	Q
NS	I PSONDS'?.N&(PSONDS'?.N1".".N) K PSONDS
	Q
NU	S PSONDU=$S($G(PSONDS)&($G(PSONDU)):$P($G(^PS(50.607,+$G(PSONDU),0)),"^"),1:"")
	Q
SETU	S PSSUNITX=$P($G(^PSDRUG(PSIEN,"DOS")),"^",2)
	S PSSUNITX=$S($P($G(^PS(50.607,+$G(PSSUNITX),0)),"^")'=""&($P($G(^(0)),"^")'["/"):$P($G(^(0)),"^"),1:"")
	Q
