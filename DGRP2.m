DGRP2	;ALB/MRL,BRM - REGISTRATION SCREEN 2/CONTACT INFORMATION ;6:20 AM  16 Aug 2015
	;;5.3;Registration;**415,545,638,677,760,867,WVEHR,LOCAL**;Aug 13, 1993;Build 1
	;
	; Copyright 2015 WorldVistA.
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	;
	D NEWB
	S DGRPS=2 D H^DGRPU F I=0,.24,57,1010.15 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
	S DGRPX=DGRP(0)
	S (Z,DGRPW)=1 D WW^DGRPV W "  Marital: " S Z=$S($D(^DIC(11,+$P(DGRPX,"^",5),0)):$E($P(^(0),"^",1),1,28),1:DGRPU),Z1=30 D WW1^DGRPV
	;S (Z,DGRPW)=1 D WW^DGRPV W "     Sex: " S X=$P(DGRP(0),"^",2),Z=$S(X="M":"MALE",X="F":"FEMALE",1:DGRPU),Z1=31 D WW1^DGRPV
	S DGD=$$DISP^DG1010P0(DGRP(0),11,0,1),DGNOCITY=DGUNK,DGD1=$$POINT^DG1010P0(DGRP(0),12,5,1,0,1)
	W ?41,"POB: ",$E($S((DGNOCITY&DGUNK):"UNANSWERED",1:DGD_$S(($L(DGD)):", ",1:"")_DGD1),1,29)
	;S DGRPX=DGRP(0)
	W !?4,"Religion: ",$S($D(^DIC(13,+$P(DGRPX,"^",8),0)):$P(^(0),"^",1),1:DGRPU),?41,"Father: ",$S($P(DGRP(.24),"^",1)]"":$E($P(DGRP(.24),"^",1),1,29),1:DGRPU)
	S X=$P(DGRP(57),"^",4),X=$S(X']"":DGRPU,X="X":"NOT APPLICABLE",X=1:"PARA,",X=2:"QUAD,",X=3:"PARA,NON",1:"QUAD,NON"),X=$S("QP"[$E(X):X_"TRAUMATIC",1:X) W !?9,"SCI: ",X
	W ?41,"Mother: ",$S($P(DGRP(.24),"^",2)]"":$E($P(DGRP(.24),"^",2),1,29),1:DGRPU)
	W !,?35,"Mom's Maiden: ",$S($P(DGRP(.24),"^",3)]"":$E($P(DGRP(.24),"^",3),1,29),1:DGRPU)
	;Begin WorldVistA change
	;WAS;W ! S Z=2 D WW^DGRPV W " Previous Care Date      Location of Previous Care",!?4,"------------------      -------------------------" S DGRPX=DGRP(1010.15) I $P(DGRPX,"^",5)'="Y" S X="NONE INDICATED" W !?4,X,?28,X
	I $G(DUZ("AG"))="V" D
	. W ! S Z=2 D WW^DGRPV W " Previous Care Date      Location of Previous Care",!?4,"------------------      -------------------------" S DGRPX=DGRP(1010.15) I $P(DGRPX,"^",5)'="Y" S X="NONE INDICATED" W !?4,X,?28,X
	I $G(DUZ("AG"))="E" D
	. W !?4,"Veteran: ",$$GET1^DIQ(2,DFN,19902)
	. W !,"Interpreter Language: "
	. N IL S IL=""
	. N I F I=1:1 S IL=$O(^DPT(DFN,19901,"B",IL)) Q:IL=""  D
	. . I I'=1 W ","
	. . W $$GET1^DIQ(.85,IL,1)
	;WAS;E  F I=1:1:4 S I1=$P(DGRPX,"^",I) X "I I#2 S Y=I1 X:Y]"""" ^DD(""DD"") W !?4,$S(Y]"""":Y,1:DGRPU)" I '(I#2) W ?28,$S($D(^DIC(4,+I1,0)):$P(^(0),"^",1),1:DGRPU)
	E  I $G(DUZ("AG"))="V" D
	. F I=1:1:4 S I1=$P(DGRPX,"^",I) X "I I#2 S Y=I1 X:Y]"""" ^DD(""DD"") W !?4,$S(Y]"""":Y,1:DGRPU)" I '(I#2) W ?28,$S($D(^DIC(4,+I1,0)):$P(^(0),"^",1),1:DGRPU)
	;End WorldVistA change
	W ! S Z=3 D WW^DGRPV W " Ethnicity: " D
	.I '$O(^DPT(DFN,.06,0)) W "UNANSWERED" Q
	.N NODE,NUM,ETHNIC
	.S I=0
	.F NUM=0:1 S I=+$O(^DPT(DFN,.06,I)) Q:'I  D
	..S NODE=$G(^DPT(DFN,.06,I,0))
	..S X=$P($G(^DIC(10.2,+NODE,0)),"^",1)
	..S ETHNIC=$S(X="":"?????",1:X)
	..S X=$P($G(^DIC(10.3,+$P(NODE,"^",2),0)),"^",2)
	..S ETHNIC=ETHNIC_" ("_$S(X="":"?",1:X)_")"
	..I NUM S ETHNIC=", "_ETHNIC
	..I ($X+$L(ETHNIC))>IOM D  W !?15
	...F  S X=$P(ETHNIC," ",1)_" " Q:($X+$L(X))>IOM  W X S ETHNIC=$P(ETHNIC," ",2,999)
	..W ETHNIC
	W !?9,"Race: " D
	.I '$O(^DPT(DFN,.02,0)) W "UNANSWERED" Q
	.N NODE,NUM,RACE
	.S I=0
	.F NUM=0:1 S I=+$O(^DPT(DFN,.02,I)) Q:'I  D
	..S NODE=$G(^DPT(DFN,.02,I,0))
	..S X=$P($G(^DIC(10,+NODE,0)),"^",1)
	..S RACE=$S(X="":"?????",1:X)
	..S X=$P($G(^DIC(10.3,+$P(NODE,"^",2),0)),"^",2)
	..S RACE=RACE_" ("_$S(X="":"?",1:X)_")"
	..I NUM S RACE=", "_RACE
	..I ($X+$L(RACE))>IOM D  W !?15
	...F  S X=$P(RACE," ",1)_" " Q:($X+$L(X))>IOM  W X S RACE=$P(RACE," ",2,999)
	..W RACE
	D GETS^DIQ(2,DFN_",",".351;.353;.354;.355","E","PDTHINFO")
	W !!
	W "<4> Date of Death Information"
	W !,?5,"Date of Death: ",$G(PDTHINFO(2,DFN_",",.351,"E"))
	W ?41,"Source of Notification: ",$G(PDTHINFO(2,DFN_",",.353,"E"))
	W !,?5,"Updated Date/Time: ",$G(PDTHINFO(2,DFN_",",.354,"E"))
	W ?41,"Last Edited By: ",$G(PDTHINFO(2,DFN_",",.355,"E")),!
	K PDTHINFO
	;
	;Emergency Response Indicator
	N DGEMRES S DGEMRES=$P($G(^DPT(DFN,.18)),"^")
	S Z=5 D WW^DGRPV W " Emergency Response: "_$$EXTERNAL^DILFD(2,.181,,DGEMRES)
	G ^DGRPP
	;
	Q
NEWB	;-- check patient DOB, if DOB<365 days, set marital status to "never married"
	N DOB,NOW
	S DOB=$P(^DPT(DFN,0),"^",3)
	D NOW^%DTC S NOW=X
	I $$FMDIFF^XLFDT(NOW,DOB,1)>365 Q  ;patient is not a newborn
	S $P(^DPT(DFN,0),"^",5)=6 ;patient is a newborn
	Q
