LRMISR1	;DALOI/STAFF - INPUT TRANSFORM FOR ANTIBIOTIC SENSITIVITIES ;Sep 23, 2008
	;;5.2;LAB SERVICE;**350**;Sep 27, 1994;Build 230
	;
STAR	; from LRMISR
	I $P(X,"*",3,4)["*" K X Q
	S LRSCREEN=$P(X,"*",3),LRISR=$P(X,"*",2),X=$P(X,"*") I '$L(X) K X Q
	I '$D(^LAB(62.06,C6,1,"B",X))!(LRSCREEN=""&LRISR="") K X Q
	S LRBN=+$P(DQ(DQ),U,4) Q:'LRBN
	I LRISR'="",'$D(^LAB(62.06,"AJ",$P($P(DQ(DQ),U,4),";"),LRISR)) K X Q
	I LRSCREEN'="",LRSCREEN'?1(1"A",1"R",1"N") K X Q
	I LRISR="" S LRR=X D INTRP
	I LRSCREEN="" D SCREEN
	Q
	;
	;
IS	; from LRMISR
	D INTRP,SCREEN
	Q
	;
	;
INTRP	; from LRMISR
	S LRISR=$G(^LAB(62.06,"AI",LRBN,LRR)) Q:'$D(LRBG1)!'$D(LRSPEC)!('$L(LRISR))
	I $O(^LAB(62.06,"AI",LRBN,LRR,0))="" Q
	I $D(^LAB(62.06,"AI",LRBN,LRR,+LRBG1)) S C2=+LRBG1 D SPEC Q
	I $P(^LAB(61.2,+LRBG1,0),U,3)="P",$D(^LAB(62.06,"AI",LRBN,LRR,"GRAM POS")) S C2="GRAM POS" D SPEC Q
	I $P(^LAB(61.2,+LRBG1,0),U,3)="N",$D(^LAB(62.06,"AI",LRBN,LRR,"GRAM NEG")) S C2="GRAM NEG" D SPEC Q
	I $D(^LAB(62.06,"AI",LRBN,LRR,"ANY")) S C2="ANY" D SPEC
	Q
	;
	;
SPEC	;
	I $D(^LAB(62.06,"AI",LRBN,LRR,C2,LRSPEC)) S C4=LRSPEC D ALT Q
	I $D(^LAB(62.06,"AI",LRBN,LRR,C2,"ANY")) S C4="ANY" D ALT
	Q
	;
	;
ALT	;
	S LRISR=$P(^LAB(62.06,"AI",LRBN,LRR,C2,C4),U)
	Q
	;
	;
SCREEN	;
	S LRSCREEN=^LAB(62.06,"AS",LRBN) Q:'$D(LRBG1)!'$D(LRSPEC)
	I $O(^LAB(62.06,"AS",LRBN,0))="" Q
	I $D(^LAB(62.06,"AS",LRBN,+LRBG1)) S C2=+LRBG1 D SSPEC Q
	I $P(^LAB(61.2,+LRBG1,0),U,3)="P",$D(^LAB(62.06,"AS",LRBN,"GRAM POS")) S C2="GRAM POS" D SSPEC Q
	I $P(^LAB(61.2,+LRBG1,0),U,3)="N",$D(^LAB(62.06,"AS",LRBN,"GRAM NEG")) S C2="GRAM NEG" D SSPEC Q
	I $D(^LAB(62.06,"AS",LRBN,"ANY")) S C2="ANY" D SSPEC
	Q
	;
	;
SSPEC	;
	I $D(^LAB(62.06,"AS",LRBN,C2,LRSPEC)) S C4=LRSPEC D SALT Q
	I $D(^LAB(62.06,"AS",LRBN,C2,"ANY")) S C4="ANY" D SALT
	Q
	;
	;
SALT	;
	S LRSCREEN=^LAB(62.06,"AS",LRBN,C2,C4)
	Q