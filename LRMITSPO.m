LRMITSPO	;DALOI/STAFF - MICRO TREND PROCESS ORGANISMS ;Dec 20, 2008
	;;5.2;LAB SERVICE;**96,116,350**;Sep 27, 1994;Build 230
	;
	; from LRMITSPE
	;
	; bacteria
	I $D(LROTYPE("B")),+$G(^LR(LRDFN,"MI",LRIDT,1)),$O(^(3,0)) D
	. S LROTYPE="B",LRSUBN=0
	. F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,3,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D
	. . ; if specific organisms required and not valid quit
	. . I $D(LRSORG),'$D(LRSORG(LROTYPE,LRORGN)) Q
	. . S LRORGNM=$E($P($G(^LAB(61.2,+LRORGN,0)),U),1,30)
	. . I LRORGNM="" S LRORGNM=LRUNK
	. . ; if antibiotic pattern required and not valid quit
	. . I $D(LRAP) D  Q:'LROK
	. . . S LROK=1,LRDN=0
	. . . F  S LRDN=$O(LRAP(LRDN)) Q:LRDN=""  S LRX=$G(^LR(LRDFN,"MI",LRIDT,3,LRSUBN,LRDN)) D  Q:'LROK
	. . . . S LRX=$$SENS(LRDN,LRX)
	. . . . I LRX="" S LROK=0 Q
	. . . . I LRX'=LRAP(LRDN) S LROK=0
	. . K LRANTIM
	. . S LRDN=2
	. . F  S LRDN=$O(^LR(LRDFN,"MI",LRIDT,3,LRSUBN,LRDN)) Q:LRDN<2!(LRDN=3)  S LRX=$G(^(LRDN)) I LRX'="" D
	. . . S LRINTERP=$$SENS(LRDN,LRX)
	. . . I LRINTERP'="" S LRANTIM(LRDN)=LRINTERP_U_LRX
	. . S LRORGNM="("_LROTYPE_") "_LRORGNM
	. . D ^LRMITSPS
	K LRANTIM
	;
	; fungus
	I $D(LROTYPE("F")),+$G(^LR(LRDFN,"MI",LRIDT,8)),$O(^(9,0)) D
	. S LROTYPE="F",LRSUBN=0
	. F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,9,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D SETUP
	;
	; mycobacteria
	I $D(LROTYPE("M")),+$G(^LR(LRDFN,"MI",LRIDT,11)),$O(^(12,0)) D
	. S LROTYPE="M",LRSUBN=0
	.  F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,12,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D
	. . K LRTB
	. . S LRDN=2
	. . F  S LRDN=$O(^LR(LRDFN,"MI",LRIDT,12,LRSUBN,LRDN)) Q:LRDN=""  S LRTB(LRDN)=$P(^(LRDN),U)
	. . D SETUP
	K LRTB
	;
	; parasite
	I $D(LROTYPE("P")),+$G(^LR(LRDFN,"MI",LRIDT,5)),$O(^(6,0)) D
	. S LROTYPE="P",LRSUBN=0
	. F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,6,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D SETUP
	;
	; virus
	I $D(LROTYPE("V")),+$G(^LR(LRDFN,"MI",LRIDT,16)),$O(^(17,0)) D
	. S LROTYPE="V",LRSUBN=0
	. F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,17,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D SETUP
	;
	; Expanded Search
	I '$D(LROTYPE("B")),+$G(^LR(LRDFN,"MI",LRIDT,0)),$O(^(3,0)) D
	. S LROTYPE=$S($D(LROTYPE("V")):"V",$D(LROTYPE("P")):"P",$D(LROTYPE("F")):"F",$D(LROTYPE("M")):"M",1:"")
	. Q:LROTYPE=""
	. S LRSUBN=0
	. F  S LRSUBN=$O(^LR(LRDFN,"MI",LRIDT,3,LRSUBN)) Q:LRSUBN<1  S LRORGN=+^(LRSUBN,0) D:LROTYPE=$P(^LAB(61.2,+LRORGN,0),U,5) SETUP
	Q
	;
	;
SETUP	; if specific organisms are required, do not setup unless valid organism
	I $D(LRSORG),'$D(LRSORG(LROTYPE,LRORGN)) Q
	S LRORGNM=$E($P($G(^LAB(61.2,+LRORGN,0)),U),1,30) I LRORGNM="" S LRORGNM=LRUNK
	S LRORGNM="("_LROTYPE_") "_LRORGNM
	; setup data on isolate
	D ^LRMITSPS
	Q
	;
	;
SENS(DRUGNODE,VALUES)	; $$(antibiotic,susceptibility) -> "S","R" or ""
	N INTERP,RESULT
	S INTERP=$P(VALUES,U,2),RESULT=$P(VALUES,U)
	I INTERP="",RESULT'="" S INTERP=$G(^LAB(62.06,"AI",DRUGNODE,RESULT))
	I INTERP="" S INTERP=RESULT
	I INTERP="" Q ""
	I $D(LRSUSS(INTERP)) Q "S"
	I $D(LRSUSR(INTERP)) Q "R"
	I INTERP["S" Q "S"
	Q ""
