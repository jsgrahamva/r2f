LRAPBR	;DALOI/WTY - AP Browser Print/TIU TMP Global;11/21/12  15:12
	;;5.2;LAB SERVICE;**259,427**;Sep 27, 1994;Build 33
	;
	;Reference to ^DPT supported by IA #918
	;
INIT(LRAA,LRSS,LRI,LRDFN,LRAA1,LRAU,LRTIU,LRNTIME)	;
	;Define variables and arrays used for report display
	N LRIENS,LCT,LREFLG,LRPRAC
	S:'$D(LRTIU) LRTIU=0
	;KLL-Change all "-" and "=" to "- " and "=-"
	S $P(LR("%"),"- ",IOM/2)="- "
	I $L(LR("%"))>(IOM-1) S LR("%")=$E(LR("%"),1,(IOM-1))
	S $P(LR("%1"),"=-",IOM/2)="=-"
	I $L(LR("%1"))>(IOM-1) S LR("%1")=$E(LR("%1"),1,(IOM-1))
	S LRQ(8)=$S($D(^LRO(69.2,LRAA,0)):$P(^(0),"^",8),1:"")
	S LRQ=0,LRQ(1)=$$INS^LRU
	I LRAU D
	.S LRS="W",LRAP=LRDFN,LRXR="A"_LRSS,LRXREF=LRXR_"A"
	.S LR(.21)=+$G(^LRO(69.2,LRAA,.2)),LRS(5)=1
	.D EN^LRUA
	.D ^LRUP
	I 'LRAU D
	.D SET^LRUA
	.S LRA=1
	.S LRS(5)=1,LRQ(2)=1
	.S LR("DIWF")=$S($P(^LRO(69.2,LRAA,0),"^",6)="D":"D",1:"")_"W"
MAIN	;Main Subroutine
	K ^UTILITY($J)
	D:'LRAU ENTER^LRAPBR1
	D:LRAU ENTER^LRAPBR4
	I 'LRAU,'LRTIU D
	.D POW,^LRAPBR2
	.I $D(^LR(LRDFN,"AU")),$P(^LR(LRDFN,"AU"),"^") D ^LRAPBR5
	I LRTIU,'LRAU D ESIGLN^LRAPBR1
	D:'LRAU PPL^LRAPBR1
	D:'LRAU FOOTER^LRAPBR1
	D:'LRTIU BROWSER
	D END
	Q
POW	;Determine POW or Persian Gulf status
	I $P($G(^LR(LRDFN,0)),"^",2)=2 D
	.S LRPOW=0
	.I $D(^DPT(DFN,.52)) S:$P(^(.52),U,5)="Y" LRPOW=1
	.I $D(^DPT(DFN,.322)) S:$P($G(^(.322)),"^",10)="Y" LRPOW=1
	.D ^LRAPBRPW
	.K LRPOW
	Q
FINAL	;Final Section
	;Print text in field SNOMED & TC CODING (#10) of the LAB SECTION
	;PRINT FILE (#69.2)
	Q:'$P($G(^LRO(69.2,LRAA,10,0)),"^",4)
	K LRTMP,^UTILITY($J,"W")
	S LRFILE=69.2,LRFLD=10,LRIENS=LRAA_","
	N X,DIWR,DIWL
	S X=$$GET1^DIQ(LRFILE,LRIENS,LRFLD,"","LRTMP")
	S DIWR=IOM-5,DIWL=5,DIWF=""
	S X=+$$GET1^DID(LRFILE,LRFLD,"","SPECIFIER")
	I $$GET1^DID(X,.01,"","SPECIFIER")["L" S DIWF="N"
	S A=0 F  S A=$O(LRTMP(A)) Q:'A  S X=LRTMP(A) D ^DIWP
	S A=0 F  S A=$O(^UTILITY($J,"W",DIWL,A)) Q:'A  D
	.D GLENTRY^LRAPBR1(^UTILITY($J,"W",DIWL,A,0),DIWL,1)
	K ^UTILITY($J,"W")
	Q
BROWSER	;
	;SET LRW(1)=2-DIGIT YEAR OF AUTOPSY DATE
	I LRAU,LRQ(8)'="" S LRW(1)=$E(+$$GET1^DIQ(63,LRDFN,11,"I"),2,3)
	S LRTITLE=$S(LRQ(8)'="":LRQ(8)_LRW(1)_" "_LRAC,1:LRAC)_" - "_LRP
	S LRROOT="^TMP(""LRAPBR"",$J)"
	D BROWSE^DDBR(LRROOT,"",LRTITLE)
	Q
END	;
	K LRSR1,LRSR2,LRTEXT,LRTIU,LRTITLE,LRROOT
	Q
