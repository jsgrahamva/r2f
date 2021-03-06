ICDDRGX	;ALB/EG/MRY/ADL/KUM/JDG - GROUPER PROCESS ;08/04/2015
	;;18.0;DRG Grouper;**1,2,5,7,10,14,20,24,27,31,64,82**;Oct 20, 2000;Build 21
	;
CKHIV	;MDC25 grouping
	N ICDI
	I ICDDATE>3070930.9 G CKHIV^ICDDRGXM ;MS-DRG
	;Q:ICDP25=""
	I ICDPD'["h"&(ICDSD'["h") Q
	S ICDRG=$S(ICDOR["x":488,ICDPD["i"&($D(ICDS25(1))):490,1:ICDRG)
	S ICDGH=$S("488^489^490"[ICDRG:1,1:0),ICDORNI=$S(ICDOCNT>0:ICDORNI,1:0),ICDORNA=$F(ICDORNI,"O",$F(ICDORNI,"O"))
	S:ICDORNI="" ICDORNI=ICDOR
	S ICDRG=$S(ICDP25=1&(ICDORNA>0):488,1:ICDRG) I 'ICDGH&(ICDRG=488) Q
	S:(ICDOCNT>0) ICDRG=$S(ICDP25>1&(ICDORNA>0)&($D(ICDS25(1))):488,1:ICDRG) I 'ICDGH&(ICDRG=488) Q
	I ICDOPCT>0 D  I ICDRG=488 Q
	.;count the non-extensive "z" vs the "O"
	.N K1,K2,I
	.S (K1,K2)=0
	.F I=1:1:$L(ICDORNI) S:$E(ICDORNI,I,I)="z" K1=K1+1 S:$E(ICDORNI,I,I)="O" K2=K2+1
	.I ICDP25=1!(ICDP25>1&($D(ICDS25)>0)) D
	..I K1<K2&(K1<ICDOPCT) D
	...S ICDRG=488 Q
	..I ICDOPCT=1&(ICDORNI'["z") D
	...S ICDRG=488 Q
	S ICDRG=$S(ICDP25=1&('$D(ICDS25))&('$$EXIST^ICDEX(ICDDX(1),30)):490,1:ICDRG) I 'ICDGH&(ICDRG=490) Q
	S ICDRG=$S(ICDP25=1&($D(ICDS25(2))):489,ICDP25=1&($D(ICDS25(3))):490,1:ICDRG) I 'ICDGH&((ICDRG=489)!(ICDRG=490)) Q
	S ICDRG=$S(ICDP25=2&($D(ICDS25(1))):489,ICDP25=3&($D(ICDS25(1))):490,1:ICDRG) I 'ICDGH&((ICDRG=489)!(ICDRG=490)) Q
	S ICDRG=$S((ICDP25&(ICDOCNT=0)&('$D(ICDS25))):490,1:ICDRG) I 'ICDGH&(ICDRG=490) Q
	S:(ICDRG=488)!(ICDRG=489)!(ICDRG=490) ICDRTC=0
	K ICDGH,ICDP25,ICDS25,ICDORNA Q
CKMST	;MDC24 grouping; MS-DRG additions
	S ICDAJ=0 F ICDS24K=1:1 S ICDAJ=$O(ICDS24(ICDAJ)) Q:ICDAJ=""
	S ICDS24K=ICDS24K-1,ICDS24L=0 F ICDI=1:1:8 S:$D(ICDS24(ICDI))&(ICDI'=ICDP24) ICDS24L=$S($D(ICDS24(ICDI)):1,1:0)
	I ICDOR["u" S ICDS24K=ICDS24K+1
	G:((ICDP24=0)&(ICDS24K<2))!((ICDP24>0)&('ICDS24L)) CKMSTE
	N CKMST S CKMST=0
	I ICDDATE>3070930.9 D  Q:CKMST  ;MS-DRG
	. S ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(1))):955,ICDP24>0&($D(ICDO24(1)))&(ICDS24L):955,1:ICDRG) I ICDRG=955 D CKMSTE S CKMST=1 Q
	. S:ICDRG'=955 ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(2))):956,ICDP24>0&($D(ICDO24(2)))&(ICDS24L):956,1:ICDRG) I ICDRG=956 D CKMSTE S CKMST=1 Q
	. S:ICDRG'=956 ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(3))):959,ICDP24>0&($D(ICDO24(3)))&(ICDS24L):959,1:ICDRG) I ICDRG=959 D CKMSTE S CKMST=1 Q
	. S ICDRG=$S(ICDP24=0&(ICDS24K>1):965,ICDP24>0&ICDS24L:965,1:ICDRG)
	. S:(ICDRG>954)&(ICDRG<966) ICDRTC=0
	E  D  Q:CKMST  ;CMS-DRG
	. S ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(1))):483,ICDP24>0&($D(ICDO24(1)))&(ICDS24L):483,1:ICDRG) I ICDRG=483 D CKMSTE S CKMST=1 Q
	. S:ICDRG'=483 ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(2))):485,ICDP24>0&($D(ICDO24(2)))&(ICDS24L):485,1:ICDRG) I ICDRG=485 D CKMSTE S CKMST=1 Q
	. S:ICDRG'=485 ICDRG=$S(ICDP24=0&(ICDS24K>1)&($D(ICDO24(3))):486,ICDP24>0&($D(ICDO24(3)))&(ICDS24L):486,1:ICDRG) I ICDRG=486 D CKMSTE S CKMST=1 Q
	. S ICDRG=$S(ICDP24=0&(ICDS24K>1):487,ICDP24>0&ICDS24L:487,1:ICDRG)
	. S:(ICDRG>482)&(ICDRG<488) ICDRTC=0
CKMSTE	K ICDAJ,ICDP24,ICDS24,ICDO24,ICDS24K,ICDO24,ICDS24L
	Q
CKNMDC	;non MDC drg's
	I ICDDATE>3070930.9 G CKNMDC^ICDDRGXM ;MS-DRG
	S:(ICDRG>479)&(ICDRG<483) ICDRG=470
	; ICD*18*1 - reorder drg 103 higher than all Pre-MDCs 480-83 & 495
	I ICDRG=103 S ICDRTC=0 Q
	S ICDCDSY=$S(ICDDATE'<$$IMPDATE^LEXU("10D"):30,1:1)
	;use FY logic to resolve DRG if no FY defined user current FY
	N ICDDXFY S ICDDXFY=""
	I ICDDATE>3040930.9 D  I ICDRG=541!(ICDRG=542) S ICDRTC=0 Q  ;Use DRG FY 05 logic
	.;S ICDRG=$S($D(ICDOP(" 31.1"))!($D(ICDOP(" 31.21")))!($D(ICDOP(" 31.29")))&(($P($$ICDDX^ICDCODE(ICDDX(1),ICDDATE),"^",3)'["Y")!($D(ICDOP(" 96.72")))):541,1:ICDRG)
	.;I ICDRG=541&(($P($$ICDDX^ICDCODE(ICDDX(1),ICDDATE),"^",3))["Y") S ICDRG=542 S ICDRTC=0
	.I $D(ICDOP(" 39.65")) S ICDRG=541 Q
	.I $D(ICDOP(" 31.1"))!($D(ICDOP(" 31.21")))!($D(ICDOP(" 31.29"))) I $TR($P($$ICDDX^ICDEX(ICDDX(1),ICDDATE,ICDCDSY,"I"),"^",3),";","")'["Y"!(($D(ICDOP(" 96.72")))) S ICDRG=542
	.I $D(ICDOP(" 31.1"))!($D(ICDOP(" 31.21")))!($D(ICDOP(" 31.29"))) I $TR($P($$ICDDX^ICDEX(ICDDX(1),ICDDATE,ICDCDSY,"I"),"^",3),";","")'["Y"!(($D(ICDOP(" 96.72")))) I ICDOR["O"&(ICDOR'["z")&(ICDOR'["y") S ICDRG=541
	I ICDDATE<3041001 D  Q:ICDRG=483  ;Use DRG FY 04 logic
	.S ICDRG=$S($D(ICDOP(" 31.1"))!($D(ICDOP(" 31.21")))!($D(ICDOP(" 31.29")))&(($TR($P($$ICDDX^ICDEX(ICDDX(1),ICDDATE,ICDCDSY,"I"),"^",3),";","")'["Y")!($D(ICDOP(" 96.72")))):483,1:ICDRG) I ICDRG=483 S ICDRTC=0
	S ICDRG=$S(ICDOR["l":480,1:ICDRG) I ICDRG=480 S ICDRTC=0 Q
	I ICDRG=512!(ICDRG=513) S ICDRTC=0 Q
	S ICDRG=$S(ICDOR["r":495,1:ICDRG) I ICDRG=495 S ICDRTC=0 Q  ;check for lung tx
	S ICDRG=$S(ICDOR["q":103,1:ICDRG) I ICDRG=103 S ICDRTC=0 Q  ;check for heart tx
	S ICDRG=$S(ICDOR["B":481,1:ICDRG) I ICDRG=481 S ICDRTC=0 Q
	S ICDRG=$S($D(ICDOP(" 30.3"))!$D(ICDOP(" 30.4")):482,1:ICDRG) I ICDRG=482 S ICDRTC=0 Q
	S ICDRG=$S(ICDOR["t"&($TR($P($$ICDDX^ICDEX(ICDDX(1),ICDDATE,ICDCDSY,"I"),"^",3),";","")["Y"):482,1:ICDRG) I ICDRG=482 S ICDRTC=0 Q
	Q
	;
	;
CHKMDC4	;MDC 4 drg's
	I ICDDATE>3070930.9 D  ;MS-DRG
	. I (ICDMDC=4!(ICDMDC=98)),(ICDOR["f") S ICDRG=168
	. I ICDDRG=983,$G(ICDMDC)=5,$D(ICDOP(" 86.06")) S ICDRG=264
	. I ICDDRG=983,$G(ICDMDC)=5,$D(ICDOP(" 92.27")),ICDNOR=1 S ICDRG=264 ;ICD*18*5
	E  D  ;CMS-DRG
	. I (ICDMDC=4!(ICDMDC=98)),(ICDOR["f") S ICDRG=76
	. I ICDDRG=468,$G(ICDMDC)=5,$D(ICDOP(" 86.06")) S ICDRG=120
	. I ICDDRG=468,$G(ICDMDC)=5,$D(ICDOP(" 92.27")),ICDNOR=1 S ICDRG=120 ;ICD*18*5
	Q
