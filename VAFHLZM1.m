VAFHLZM1	;BAY/JAT,PJH - Create HL7 Military History segment (ZMH) Cont ; 2/3/09 3:49pm
	;;5.3;Registration;**314,673,797**;Aug 13, 1993;Build 24
	;
	; This routine creates HL7 VA-specific Military History ("ZMH") segments
	; It is a continuation of VAFHLZMH and uses those variables.
	;
	Q
ENTER	;
	N VAFSETID  ;seg setid
	S VAFSETID=0
	N VAFNUM
	;build segments as requested in VAFTYPE         
	F VAFX=1:1 S VAFZ=$P(VAFTYPE,",",VAFX) Q:VAFZ=""  D
	.S VAFY=""
	.S VAFINDX=(VAFINDX\1)+1
	.S VAFSETID=VAFSETID+1
	.S $P(VAFY,VAFHLS,1)=VAFSETID
	.S VAFTAG=$S(VAFZ="*":"MSDS",VAFZ=1:"SL",VAFZ=2:"SNL",VAFZ=3:"SNNL",VAFZ=4:"POW",VAFZ=5:"COMB",VAFZ=6:"VIET",VAFZ=7:"LEBA",VAFZ=8:"GREN",VAFZ=9:"PANA",VAFZ=10:"GULF",VAFZ=11:"SOMA",VAFZ=12:"YUGO",VAFZ=13:"PH",VAFZ=14:"OEIF",1:"NOSEG")
	.D @VAFTAG
	.;if mult episodes, add decimal to output array subscript (Ex: 14.001)
	.I $D(VAFY(2)) D
	..S VAFNUM=0
	..F  S VAFNUM=$O(VAFY(VAFNUM)) Q:'$G(VAFNUM)  D
	...S VAFINDX=VAFINDX+.001
	...;if >1 conflict then increment seg setid
	...I VAFNUM>1 S VAFSETID=VAFSETID+1 S $P(VAFY(VAFNUM),VAFHLS,1)=VAFSETID
	...S @VAFARRAY@(VAFINDX,0)="ZMH"_VAFHLS_$G(VAFY(VAFNUM))
	.;if not mult episodes
	.I '$D(VAFY(2)) S @VAFARRAY@(VAFINDX,0)="ZMH"_VAFHLS_$G(VAFY)
	.K VAFY
	Q
SL	; last Service branch
	S $P(VAFY,VAFHLS,2)="SL"
	N VAF325,VAF328,VAF324,VAF326,VAF327,VAFSCL
	I VAFSTR[",3," D
	.S VAF325=$P(VAF32N,U,5) S VAF325=$S(VAF325:$P($G(^DIC(23,VAF325,0)),U),1:VAFHLQ)
	.S VAF328=$P(VAF32N,U,8) I VAF328="" S VAF328=VAFHLQ
	.S VAF324=$P(VAF32N,U,4) S VAF324=$S(VAF324:$P($G(^DIC(25,VAF324,0)),U),1:VAFHLQ)
	.; Service branch~Service number~Service discharge type
	.S $P(VAFY,VAFHLS,3)=VAF325_$E(VAFHLC)_VAF328_$E(VAFHLC)_VAF324
	I VAFSTR[",4," D
	.S VAF326=$P(VAF32N,U,6) S VAF326=$S(VAF326:$$HLDATE^HLFNC(VAF326),1:VAFHLQ)
	.S VAF327=$P(VAF32N,U,7) S VAF327=$S(VAF327:$$HLDATE^HLFNC(VAF327),1:VAFHLQ)
	.; Service entry date~Service separation date
	.S $P(VAFY,VAFHLS,4)=VAF326_$E(VAFHLC)_VAF327
	I VAFSTR[",5," D
	.; Service Component [L]
	.S VAFSCL=$P(VAF3291N,U,1) I VAFSCL="" S VAFSCL=VAFHLQ
	.S $P(VAFY,VAFHLS,5)=VAFSCL
	Q
SNL	; next to last Service branch
	S $P(VAFY,VAFHLS,2)="SNL"
	N VAF3291,VAF3294,VAF329,VAF3292,VAF3293,VAFSCNL
	I VAFSTR[",3," D
	.S VAF3291=$P(VAF32N,U,10) S VAF3291=$S(VAF3291:$P($G(^DIC(23,VAF3291,0)),U),1:VAFHLQ)
	.S VAF3294=$P(VAF32N,U,13) I VAF3294="" S VAF3294=VAFHLQ
	.S VAF329=$P(VAF32N,U,9) S VAF329=$S(VAF329:$P($G(^DIC(25,VAF329,0)),U),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,3)=VAF3291_$E(VAFHLC)_VAF3294_$E(VAFHLC)_VAF329
	I VAFSTR[",4," D
	.S VAF3292=$P(VAF32N,U,11) S VAF3292=$S(VAF3292:$$HLDATE^HLFNC(VAF3292),1:VAFHLQ)
	.S VAF3293=$P(VAF32N,U,12) S VAF3293=$S(VAF3293:$$HLDATE^HLFNC(VAF3293),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF3292_$E(VAFHLC)_VAF3293
	I VAFSTR[",5," D
	.; Service Component [NL]
	.S VAFSCNL=$P(VAF3291N,U,2) I VAFSCNL="" S VAFSCNL=VAFHLQ
	.S $P(VAFY,VAFHLS,5)=VAFSCNL
	Q
SNNL	; next to next to last Service branch
	S $P(VAFY,VAFHLS,2)="SNNL"
	N VAF3296,VAF3299,VAF3295,VAF3297,VAF3298,VAFSCNNL
	I VAFSTR[",3," D
	.S VAF3296=$P(VAF32N,U,15) S VAF3296=$S(VAF3296:$P($G(^DIC(23,VAF3296,0)),U),1:VAFHLQ)
	.S VAF3299=$P(VAF32N,U,18) I VAF3299="" S VAF3299=VAFHLQ
	.S VAF3295=$P(VAF32N,U,14) S VAF3295=$S(VAF3295:$P($G(^DIC(25,VAF3295,0)),U),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,3)=VAF3296_$E(VAFHLC)_VAF3299_$E(VAFHLC)_VAF3295
	I VAFSTR[",4," D
	.S VAF3297=$P(VAF32N,U,16) S VAF3297=$S(VAF3297:$$HLDATE^HLFNC(VAF3297),1:VAFHLQ)
	.S VAF3298=$P(VAF32N,U,17) S VAF3298=$S(VAF3298:$$HLDATE^HLFNC(VAF3298),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF3297_$E(VAFHLC)_VAF3298
	I VAFSTR[",5," D
	.; Service Component [NNL]
	.S VAFSCNNL=$P(VAF3291N,U,3) I VAFSCNNL="" S VAFSCNNL=VAFHLQ
	.S $P(VAFY,VAFHLS,5)=VAFSCNNL
	Q
POW	; Prisoner of War
	S $P(VAFY,VAFHLS,2)="POW"
	N VAF525,VAF526,VAF527,VAF528
	I VAFSTR[",3," D
	.S VAF525=$P(VAF52N,U,5) I VAF525="" S VAF525=VAFHLQ
	.;S VAF526=$P(VAF52N,U,6) S VAF526=$S(VAF526:$P($G(^DIC(22,VAF526,0)),U),1:VAFHLQ)
	.; translate pointer to coded value for VA0023 table
	.S VAF526=$P(VAF52N,U,6) S VAF526=$S(VAF526>0&(VAF526<7):VAF526+3,VAF526>6&(VAF526<9):$C(VAF526+58),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,3)=VAF525_$E(VAFHLC)_VAF526
	I VAFSTR[",4," D
	.S VAF527=$P(VAF52N,U,7) S VAF527=$S(VAF527:$$HLDATE^HLFNC(VAF527),1:VAFHLQ)
	.S VAF528=$P(VAF52N,U,8) S VAF528=$S(VAF528:$$HLDATE^HLFNC(VAF528),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF527_$E(VAFHLC)_VAF528
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
COMB	; Combat
	S $P(VAFY,VAFHLS,2)="COMB"
	N VAF5291,VAF5292,VAF5293,VAF5294
	I VAFSTR[",3," D
	.S VAF5291=$P(VAF52N,U,11) I VAF5291="" S VAF5291=VAFHLQ
	.S VAF5292=$P(VAF52N,U,12) S VAF5292=$S(VAF5292:$P($G(^DIC(22,VAF5292,0)),U),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,3)=VAF5291_$E(VAFHLC)_VAF5292
	I VAFSTR[",4," D
	.S VAF5293=$P(VAF52N,U,13) S VAF5293=$S(VAF5293:$$HLDATE^HLFNC(VAF5293),1:VAFHLQ)
	.S VAF5294=$P(VAF52N,U,14) S VAF5294=$S(VAF5294:$$HLDATE^HLFNC(VAF5294),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF5293_$E(VAFHLC)_VAF5294
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
VIET	; Vietnam
	S $P(VAFY,VAFHLS,2)="VIET"
	N VAF32101,VAF32104,VAF32105
	I VAFSTR[",3," D
	.S VAF32101=$P(VAF321N,U) I VAF32101="" S VAF32101=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF32101
	I VAFSTR[",4," D
	.S VAF32104=$P(VAF321N,U,4) S VAF32104=$S(VAF32104:$$HLDATE^HLFNC(VAF32104),1:VAFHLQ)
	.S VAF32105=$P(VAF321N,U,5) S VAF32105=$S(VAF32105:$$HLDATE^HLFNC(VAF32105),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF32104_$E(VAFHLC)_VAF32105
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
LEBA	; Lebanon
	S $P(VAFY,VAFHLS,2)="LEBA"
	N VAF3221,VAF3222,VAF3223
	I VAFSTR[",3," D
	.S VAF3221=$P(VAF322N,U) I VAF3221="" S VAF3221=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF3221
	I VAFSTR[",4," D
	.S VAF3222=$P(VAF322N,U,2) S VAF3222=$S(VAF3222:$$HLDATE^HLFNC(VAF3222),1:VAFHLQ)
	.S VAF3223=$P(VAF322N,U,3) S VAF3223=$S(VAF3223:$$HLDATE^HLFNC(VAF3223),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF3222_$E(VAFHLC)_VAF3223
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
GREN	; Grenada
	S $P(VAFY,VAFHLS,2)="GREN"
	N VAF3224,VAF3225,VAF3226
	I VAFSTR[",3," D
	.S VAF3224=$P(VAF322N,U,4) I VAF3224="" S VAF3224=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF3224
	I VAFSTR[",4," D
	.S VAF3225=$P(VAF322N,U,5) S VAF3225=$S(VAF3225:$$HLDATE^HLFNC(VAF3225),1:VAFHLQ)
	.S VAF3226=$P(VAF322N,U,6) S VAF3226=$S(VAF3226:$$HLDATE^HLFNC(VAF3226),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF3225_$E(VAFHLC)_VAF3226
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
PANA	; Panama
	S $P(VAFY,VAFHLS,2)="PANA"
	N VAF3227,VAF3228,VAF3229
	I VAFSTR[",3," D
	.S VAF3227=$P(VAF322N,U,7) I VAF3227="" S VAF3227=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF3227
	I VAFSTR[",4," D
	.S VAF3228=$P(VAF322N,U,8) S VAF3228=$S(VAF3228:$$HLDATE^HLFNC(VAF3228),1:VAFHLQ)
	.S VAF3229=$P(VAF322N,U,9) S VAF3229=$S(VAF3229:$$HLDATE^HLFNC(VAF3229),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VAF3228_$E(VAFHLC)_VAF3229
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
GULF	; Persian Gulf
	S $P(VAFY,VAFHLS,2)="GULF"
	N VAF32201,VA322011,VA322012
	I VAFSTR[",3," D
	.S VAF32201=$P(VAF322N,U,10) I VAF32201="" S VAF32201=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF32201
	I VAFSTR[",4," D
	.S VA322011=$P(VAF322N,U,11) S VA322011=$S(VA322011:$$HLDATE^HLFNC(VA322011),1:VAFHLQ)
	.S VA322012=$P(VAF322N,U,12) S VA322012=$S(VA322012:$$HLDATE^HLFNC(VA322012),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VA322011_$E(VAFHLC)_VA322012
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
SOMA	; Somalia
	S $P(VAFY,VAFHLS,2)="SOMA"
	N VA322016,VA322017,VA322018
	I VAFSTR[",3," D
	.S VA322016=$P(VAF322N,U,16) I VA322016="" S VA322016=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VA322016
	I VAFSTR[",4," D
	.S VA322017=$P(VAF322N,U,17) S VA322017=$S(VA322017:$$HLDATE^HLFNC(VA322017),1:VAFHLQ)
	.S VA322018=$P(VAF322N,U,18) S VA322018=$S(VA322018:$$HLDATE^HLFNC(VA322018),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VA322017_$E(VAFHLC)_VA322018
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
YUGO	; Yugoslavia
	S $P(VAFY,VAFHLS,2)="YUGO"
	N VA322019,VA32202,VA322021
	I VAFSTR[",3," D
	.S VA322019=$P(VAF322N,U,19) I VA322019="" S VA322019=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VA322019
	I VAFSTR[",4," D
	.S VA32202=$P(VAF322N,U,20) S VA32202=$S(VA32202:$$HLDATE^HLFNC(VA32202),1:VAFHLQ)
	.S VA322021=$P(VAF322N,U,21) S VA322021=$S(VA322021:$$HLDATE^HLFNC(VA322021),1:VAFHLQ)
	.S $P(VAFY,VAFHLS,4)=VA32202_$E(VAFHLC)_VA322021
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
PH	; Purple Heart Recipent
	S $P(VAFY,VAFHLS,2)="PH"
	N VAF531,VAF532,VAF533
	I VAFSTR[",3," D
	.S VAF531=$P(VAF53N,U,1) I VAF531="" S VAF531=VAFHLQ
	.S VAF532=$P(VAF53N,U,2) I VAF532="" S VAF532=VAFHLQ
	.S VAF533=$P(VAF53N,U,3) I VAF533="" S VAF533=VAFHLQ
	.S $P(VAFY,VAFHLS,3)=VAF531_$E(VAFHLC)_VAF532_$E(VAFHLC)_VAF533
	I VAFSTR[",4," D
	.S $P(VAFY,VAFHLS,4)=VAFHLQ
	I VAFSTR[",5," S $P(VAFY,VAFHLS,5)=VAFHLQ
	Q
OEIF	;build Operation Enduring/Iraqi Freedom segments
	D OEIF^VAFHLZM2
	Q
NOSEG	;
	D NOSEG^VAFHLZM2
	Q
	;
MSDS	;build new ZMH format for MSDS records
	D MSDS^VAFHLZM2
	Q