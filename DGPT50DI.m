DGPT50DI	;ALB/MTC/ADL,HIOFO/FT - Edit diagnoses-Check ICD DIAGNOSES, current, gender correct ;2/20/15 12:19pm
	;;5.3;Registration;**510,850,884**;Aug 13, 1993;Build 31
	;;ADL;Updated for CSV project;;Mar 24, 2003
	;
	; ICDEX APIs - #5747
	; ICDXCODE APIs - #5699
	;
EN	;
	I DGPTFMT=2 F I=1:1:5 S DGPTDIB=$P(@("DGPTMD"_I)," ",1) S DGPTERC=0 D DIAG(I) I DGPTERC D ERR G:DGPTEDFL EXIT
	I DGPTFMT=3 F I=1:1:25 S DGPTDIB=$P(@("DGPTMD"_I)," ",1),DGPTPOAI=@("DGPTMPOA"_I) D  I DGPTERC D ERR G:DGPTEDFL EXIT
	.I DGPTDIB="",DGPTPOAI'=" " S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) D ERR ;should not have a poa if the dx is null. using invalid dx error code
	.I "YNUW "'[DGPTPOAI S DGPTREC=$S(I<6:509+I,I<20:510+I,1:538+I) D ERR ;Y,N,U,W or space only
	.S DGPTERC=0 D DIAG(I)
	D EXIT
	Q
DIAG(I)	;
	Q:DGPTDIB=""
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	S SYS=$$SYS^ICDEX("DIAG",EFFDATE)
	I SYS=1 I $E(DGPTDIB,1)="E" S DGPTERC=0 D DIAGE Q
	I SYS=1 I $E(DGPTDIB,1)="V" S DGPTERC=0 D DIAGV Q
	S DGPTDIB1=$E(DGPTDIB_"     ",1,3)_"."_$E(DGPTDIB_"     ",4,7)_" "
	I +$$CODEN^ICDEX(DGPTDIB1,80)>0 S DGPTERC=0 D GEN(I) Q
	Q
ERR	;
	D WRTERR^DGPTAE(DGPTERC,NODE,SEQ)
	Q
EXIT	;
	K DGPTDIB,DGPTDIB1,DGPTDIB2,I,DGPTPOAI
	Q
	;note: E and V codes were eliminated in ICD-10 and incorporated into the main code set.
DIAGE	;Supplementary Classification of Factors Influencing Health Status
	; and Contact with Health Services.
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	Q:$E(DGPTDIB)'="E"
	I I=1 S DGPTERC=550 Q
	S DGPTDIB1=$E(DGPTDIB,1,4)_"."_$E(DGPTDIB,5,$L(DGPTDIB))_" "
	S X=+$$CODEN^ICDEX(DGPTDIB1,80) I X<1 S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	S DGPTTMP=$$ICDDATA^ICDXCODE("DIAG",X,EFFDATE)
	I DGPTTMP=-1!('$P(DGPTTMP,U,10)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	I ($P(DGPTTMP,U,10)=0)&($E(DGPTMDTS,1,7)>$P(DGPTTMP,U,12)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	;I ($P(DGPTTMP,U,11)]"")&(DGPTGEN'=$P(DGPTTMP,U,11)) S DGPTERC=791+I Q  ;ft 12/1/14 791 didn't exist before patch 884
	S @("DGPTMD"_I)=$P(DGPTDIB1," ",1)
	Q
DIAGV	; DIAG CODES = "V##.0-2# "
	;Supplementary Classification of External Causes of Inquiry and Poisoning
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	Q:$E(DGPTDIB)'="V"
	S DGPTDIB1=$E(DGPTDIB,1,3)_"."_$E(DGPTDIB,4,$L(DGPTDIB))_" "
	I +$$CODEN^ICDEX(DGPTDIB1,80)<1 S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	S X=+$$CODEN^ICDEX(DGPTDIB1,80) I X<1 S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	S DGPTTMP=$$ICDDATA^ICDXCODE("DIAG",X,EFFDATE)  ;use date of movement if defined, else today
	I DGPTTMP=-1!('$P(DGPTTMP,U,10)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	I ($P(DGPTTMP,U,10)=0)&($E(DGPTMDTS,1,7)>$P(DGPTTMP,U,12)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	I ($P(DGPTTMP,U,11)]"")&(DGPTGEN'=$P(DGPTTMP,U,11)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	S @("DGPTMD"_I)=$P(DGPTDIB1," ",1)
	Q
GEN(I)	;gender check - 884 no longer flags a gender error
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	S DGPTDIB2=+$$CODEN^ICDEX(DGPTDIB1,80) I DGPTDIB2<1 S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	S DGPTTMP=$$ICDDATA^ICDXCODE("DIAG",DGPTDIB2,EFFDATE)
	I DGPTTMP=-1!('$P(DGPTTMP,U,10)) S DGPTERC=$S(I<6:509+I,I<20:510+I,1:538+I) Q
	;I $P(DGPTTMP,U,11)]""&(DGPTGEN'=$P(DGPTTMP,U,11)) S DGPTERC=551 Q
	S @("DGPTMD"_I)=$P(DGPTDIB1," ",1)
	Q