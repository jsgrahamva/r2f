ICDDRG8	;ALB/GRR/EG - FIX SURGERY HIERARCHY ; 7/18/01 10:40am
	;;18.0;DRG Grouper;**1,2,10,20,24,31,77,79**;Oct 20, 2000;Build 6
	Q:$O(ICDODRG(0))'>0  K ICDJ,ICDJJ F ICDJ=0:0 S ICDJ=$O(ICDODRG(ICDJ)) Q:ICDJ'>0  S ICDJJ(ICDJ)="" D
	.I ICDDATE<3051001 D F Q
	.E  I ICDDATE<3061001 D FY2006 Q
	.E  I ICDDATE<3071001 D FY2007 Q
	.E  I ICDDATE<3081001 D FY2008 Q
	.E  D FY2015
END	S ICDJ=$O(ICDJ(0)) Q:ICDJ'>0  S ICDJ=ICDJ(ICDJ) K ICDODRG S ICDODRG(ICDJ)="" Q
F	I ICDJ=471 S ICDJ(1)=ICDJ Q
	I ICDJ=217 S ICDJ(2)=ICDJ Q
	I ICDJ=209 S ICDJ(3)=ICDJ Q
	I ICDJ=216 S ICDJ(4)=ICDJ Q
	I ICDJ=210 S ICDJ(5)=ICDJ Q
	I ICDJ=213 S ICDJ(6)=ICDJ Q
	I ICDJ=491 S ICDJ(7)=ICDJ Q
	I ICDJ=497 S ICDJ(8)=ICDJ Q
	I ICDJ=519 S ICDJ(9)=ICDJ Q
	I ICDJ=520 S ICDJ(10)=ICDJ Q
	I ICDJ=499 S ICDJ(11)=ICDJ Q
	I ICDJ=501 S ICDJ(12)=ICDJ Q
	I ICDJ=218 S ICDJ(13)=ICDJ Q
	I ICDJ=231 S ICDJ(14)=ICDJ Q
	I ICDJ=537 S ICDJ(15)=ICDJ Q
	I ICDJ=230 S ICDJ(16)=ICDJ Q
	I ICDJ=226 S ICDJ(17)=ICDJ Q
	I ICDJ=227 S ICDJ(18)=ICDJ Q
	I ICDJ=225 S ICDJ(19)=ICDJ Q
	I ICDJ=228 S ICDJ(20)=ICDJ Q
	I ICDJ=223 S ICDJ(21)=ICDJ Q
	I ICDJ=232 S ICDJ(22)=ICDJ Q
	I ICDJ=224 S ICDJ(23)=ICDJ Q
	I ICDJ=229 S ICDJ(24)=ICDJ Q
	I ICDJ=233 S ICDJ(25)=ICDJ Q
	Q
FY2006	;
	I ICDJ=496 S ICDJ(1)=ICDJ Q
	I ICDJ=546 S ICDJ(2)=ICDJ Q
	I ICDJ=497 S ICDJ(3)=ICDJ Q
	I ICDJ=498 S ICDJ(4)=ICDJ Q
	I ICDJ=471 S ICDJ(5)=ICDJ Q
	I ICDJ=217 S ICDJ(6)=ICDJ Q
	I ICDJ=545 S ICDJ(7)=ICDJ Q
	I ICDJ=544 S ICDJ(8)=ICDJ Q
	I ICDJ=519 S ICDJ(9)=ICDJ Q
	I ICDJ=520 S ICDJ(10)=ICDJ Q
	I ICDJ=216 S ICDJ(11)=ICDJ Q
	I ICDJ=213 S ICDJ(12)=ICDJ Q
	I ICDJ=210 S ICDJ(13)=ICDJ Q
	I ICDJ=211 S ICDJ(14)=ICDJ Q
	I ICDJ=212 S ICDJ(15)=ICDJ Q
	I ICDJ=491 S ICDJ(16)=ICDJ Q
	I ICDJ=501 S ICDJ(17)=ICDJ Q
	I ICDJ=502 S ICDJ(18)=ICDJ Q
	I ICDJ=503 S ICDJ(19)=ICDJ Q 
	I ICDJ=499 S ICDJ(20)=ICDJ Q
	I ICDJ=500 S ICDJ(21)=ICDJ Q
	I ICDJ=218 S ICDJ(22)=ICDJ Q
	I ICDJ=219 S ICDJ(23)=ICDJ Q
	I ICDJ=220 S ICDJ(24)=ICDJ Q
	I ICDJ=537 S ICDJ(25)=ICDJ Q
	I ICDJ=538 S ICDJ(26)=ICDJ Q
	I ICDJ=230 S ICDJ(27)=ICDJ Q
	I ICDJ=226 S ICDJ(28)=ICDJ Q
	I ICDJ=227 S ICDJ(29)=ICDJ Q
	I ICDJ=225 S ICDJ(30)=ICDJ Q
	I ICDJ=228 S ICDJ(31)=ICDJ Q
	I ICDJ=223 S ICDJ(32)=ICDJ Q
	I ICDJ=232 S ICDJ(33)=ICDJ Q
	I ICDJ=224 S ICDJ(34)=ICDJ Q
	I ICDJ=229 S ICDJ(35)=ICDJ Q
	I ICDJ=233 S ICDJ(36)=ICDJ Q
	I ICDJ=234 S ICDJ(37)=ICDJ Q
	Q
FY2007	;
	I ICDJ=496 S ICDJ(1)=ICDJ Q
	I ICDJ=546 S ICDJ(2)=ICDJ Q
	I ICDJ=497 S ICDJ(3)=ICDJ Q
	I ICDJ=498 S ICDJ(4)=ICDJ Q
	I ICDJ=471 S ICDJ(5)=ICDJ Q
	I ICDJ=217 S ICDJ(6)=ICDJ Q
	I ICDJ=545 S ICDJ(7)=ICDJ Q
	I ICDJ=544 S ICDJ(8)=ICDJ Q
	I ICDJ=519 S ICDJ(9)=ICDJ Q
	I ICDJ=520 S ICDJ(10)=ICDJ Q
	I ICDJ=213 S ICDJ(11)=ICDJ Q
	I ICDJ=216 S ICDJ(12)=ICDJ Q
	I ICDJ=210 S ICDJ(13)=ICDJ Q
	I ICDJ=211 S ICDJ(14)=ICDJ Q
	I ICDJ=212 S ICDJ(15)=ICDJ Q
	I ICDJ=491 S ICDJ(16)=ICDJ Q
	I ICDJ=501 S ICDJ(17)=ICDJ Q
	I ICDJ=502 S ICDJ(18)=ICDJ Q
	I ICDJ=503 S ICDJ(19)=ICDJ Q 
	I ICDJ=499 S ICDJ(20)=ICDJ Q
	I ICDJ=500 S ICDJ(21)=ICDJ Q
	I ICDJ=218 S ICDJ(22)=ICDJ Q
	I ICDJ=219 S ICDJ(23)=ICDJ Q
	I ICDJ=220 S ICDJ(24)=ICDJ Q
	I ICDJ=537 S ICDJ(25)=ICDJ Q
	I ICDJ=538 S ICDJ(26)=ICDJ Q
	I ICDJ=230 S ICDJ(27)=ICDJ Q
	I ICDJ=226 S ICDJ(28)=ICDJ Q
	I ICDJ=227 S ICDJ(29)=ICDJ Q
	I ICDJ=225 S ICDJ(30)=ICDJ Q
	I ICDJ=228 S ICDJ(31)=ICDJ Q
	I ICDJ=223 S ICDJ(32)=ICDJ Q
	I ICDJ=232 S ICDJ(33)=ICDJ Q
	I ICDJ=224 S ICDJ(34)=ICDJ Q
	I ICDJ=229 S ICDJ(35)=ICDJ Q
	I ICDJ=233 S ICDJ(36)=ICDJ Q
	I ICDJ=234 S ICDJ(37)=ICDJ Q
	Q
FY2008	;
	I ICDJ=455 S ICDJ(1)=ICDJ Q
	I ICDJ=458 S ICDJ(2)=ICDJ Q
	I ICDJ=460 S ICDJ(3)=ICDJ Q
	I ICDJ=462 S ICDJ(4)=ICDJ Q
	I ICDJ=465 S ICDJ(5)=ICDJ Q
	I ICDJ=468 S ICDJ(6)=ICDJ Q
	I ICDJ=470 S ICDJ(7)=ICDJ Q
	I ICDJ=473 S ICDJ(8)=ICDJ Q
	I ICDJ=476 S ICDJ(9)=ICDJ Q
	I ICDJ=479 S ICDJ(10)=ICDJ Q
	I ICDJ=482 S ICDJ(11)=ICDJ Q
	I ICDJ=484 S ICDJ(12)=ICDJ Q
	I ICDJ=487 S ICDJ(13)=ICDJ Q
	I ICDJ=489 S ICDJ(14)=ICDJ Q
	I ICDJ=491 S ICDJ(15)=ICDJ Q
	I ICDJ=494 S ICDJ(16)=ICDJ Q
	I ICDJ=497 S ICDJ(17)=ICDJ Q
	I ICDJ=499 S ICDJ(18)=ICDJ Q
	I ICDJ=502 S ICDJ(19)=ICDJ Q 
	I ICDJ=505 S ICDJ(20)=ICDJ Q
	I ICDJ=506 S ICDJ(21)=ICDJ Q
	I ICDJ=508 S ICDJ(22)=ICDJ Q
	I ICDJ=509 S ICDJ(23)=ICDJ Q
	I ICDJ=512 S ICDJ(24)=ICDJ Q
	I ICDJ=514 S ICDJ(25)=ICDJ Q
	I ICDJ=517 S ICDJ(26)=ICDJ Q
	Q
FY2015	;
	I ICDJ=455 S ICDJ(1)=ICDJ Q
	I ICDJ=458 S ICDJ(2)=ICDJ Q
	I ICDJ=460 S ICDJ(3)=ICDJ Q
	I ICDJ=462 S ICDJ(4)=ICDJ Q
	I ICDJ=465 S ICDJ(5)=ICDJ Q
	I ICDJ=468 S ICDJ(6)=ICDJ Q
	I ICDJ=470 S ICDJ(7)=ICDJ Q
	I ICDJ=473 S ICDJ(8)=ICDJ Q
	I ICDJ=476 S ICDJ(9)=ICDJ Q
	I ICDJ=479 S ICDJ(10)=ICDJ Q
	I ICDJ=482 S ICDJ(11)=ICDJ Q
	I ICDJ=483 S ICDJ(12)=ICDJ Q
	I ICDJ=487 S ICDJ(13)=ICDJ Q
	I ICDJ=489 S ICDJ(14)=ICDJ Q
	I ICDJ=520 S ICDJ(15)=ICDJ Q
	I ICDJ=494 S ICDJ(16)=ICDJ Q
	I ICDJ=497 S ICDJ(17)=ICDJ Q
	I ICDJ=499 S ICDJ(18)=ICDJ Q
	I ICDJ=502 S ICDJ(19)=ICDJ Q 
	I ICDJ=505 S ICDJ(20)=ICDJ Q
	I ICDJ=506 S ICDJ(21)=ICDJ Q
	I ICDJ=508 S ICDJ(22)=ICDJ Q
	I ICDJ=509 S ICDJ(23)=ICDJ Q
	I ICDJ=512 S ICDJ(24)=ICDJ Q
	I ICDJ=514 S ICDJ(25)=ICDJ Q
	I ICDJ=517 S ICDJ(26)=ICDJ Q
	Q
EN1	; paired spinal fusion codes
	S ICDCC3=0
	;I $D(ICDOP(" 81.02"))!$D(ICDOP(" 81.04"))!$D(ICDOP(" 81.06"))&($D(ICDOP(" 81.03"))!$D(ICDOP(" 81.05"))!$D(ICDOP(" 81.08"))) S ICDCC3=1
	N ICDA,ICDB S (ICDA,ICDB)=0
	I $D(ICDOP(" 81.02"))!$D(ICDOP(" 81.04"))!$D(ICDOP(" 81.06"))!$D(ICDOP(" 81.32"))!$D(ICDOP(" 81.34"))!$D(ICDOP(" 81.36")) S ICDA=1
	I $D(ICDOP(" 81.03"))!$D(ICDOP(" 81.05"))!$D(ICDOP(" 81.07"))!$D(ICDOP(" 81.08"))!$D(ICDOP(" 81.33"))!$D(ICDOP(" 81.35"))!$D(ICDOP(" 81.37"))!$D(ICDOP(" 81.38")) S ICDB=1
	I ICDA&ICDB S ICDCC3=1
	Q
