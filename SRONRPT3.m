SRONRPT3	;BIR/ADM - NURSE INTRAOP REPORT ;10/05/2011
	;;3.0;Surgery;**100,176,182,184**;24 Jun 93;Build 35
	;** NOTICE: This routine is part of an implementation of a nationally
	;**         controlled procedure.  Local modifications to this routine
	;**         are prohibited.
	;
	S SRLF=1,MOOD=$P(SR(.8),"^"),CONS=$P(SR(.8),"^",10),INTEG=$P(SR(.7),"^",6),COLOR=$P(SR(.7),"^",7)
	S MOOD=$S(MOOD:$P(^SRO(135.3,MOOD,0),"^"),1:"N/A"),CONS=$S(CONS:$P(^SRO(135.4,CONS,0),"^"),1:"N/A"),INTEG=$S(INTEG:$P(^SRO(135.2,INTEG,0),"^"),1:"N/A")
	S Y=COLOR,C=$P(^DD(130,.77,0),"^",2) D:Y'="" Y^DIQ S COLOR=$S(Y="":"N/A",1:Y)
	I 'SRALL,MOOD="N/A" G CONS
	D LINE(1) S @SRG@(SRI)="Postoperative Mood:",@SRG@(SRI)=@SRG@(SRI)_$$SPACE(30)_MOOD
CONS	I 'SRALL,CONS="N/A" G INTEG
	D LINE(1) S @SRG@(SRI)="Postoperative Consciousness:  "_CONS
INTEG	I 'SRALL,INTEG="N/A" G COLOR
	D LINE(1) S @SRG@(SRI)="Postoperative Skin Integrity: "_INTEG
COLOR	I 'SRALL,COLOR="N/A" G NEXT
	D LINE(1) S @SRG@(SRI)="Postoperative Skin Color:     "_COLOR
NEXT	D LASER^SRONRPT4
	S Y=$P(SR(.7),"^",3) I 'SRALL,Y="" G CS
	S Y=$S(Y="Y":"YES",Y="N":"NO",1:"N/A") D LINE(2) S @SRG@(SRI)="Sequential Compression Device: "_Y
CS	S SRLF=1,SRLINE="Cell Saver(s): " I '$O(^SRF(SRTN,45,0)),SRALL D LINE(1) S @SRG@(SRI)=SRLINE_"N/A"
	I $O(^SRF(SRTN,45,0)) D LINE(1) S @SRG@(SRI)=SRLINE D SAVE
	S X=$P($G(^SRF(SRTN,46)),"^") S:X="" X="N/A" I 'SRALL,X="N/A" S SRLF=0 G FLASH
	D LINE(2) S @SRG@(SRI)="Devices: "_X
	D ORGDNR^SRONRPT4
FLASH	S SRLF=1,SRLINE="Immediate Use Steam Sterilization Episodes: " I '$D(^SRF(SRTN,52)) D LINE(1) S @SRG@(SRI)=SRLINE_"N/A"
	I $D(^SRF(SRTN,52)) D LINE(1) S @SRG@(SRI)=SRLINE S X=$G(^SRF(SRTN,52)) D
	.D LINE(1) S @SRG@(SRI)="   Contamination:                       "_$P(X,"^")
	.D LINE(1) S @SRG@(SRI)="   SPS Processing/OR Management Issues: "_$P(X,"^",2)
	.D LINE(1) S @SRG@(SRI)="   Emergency Case:                      "_$P(X,"^",3)
	.D LINE(1) S @SRG@(SRI)="   No Better Option:                    "_$P(X,"^",4)
	.D LINE(1) S @SRG@(SRI)="   Loaner or Short Notice Instrument:   "_$P(X,"^",5)
	.D LINE(1) S @SRG@(SRI)="   Decontamination of Instruments Contaminated During the Case: "_$P(X,"^",6)
NCC	S SRLINE="Nursing Care Comments: " D LINE(2) S @SRG@(SRI)=SRLINE D
	.I '$O(^SRF(SRTN,7,0)) S @SRG@(SRI)=@SRG@(SRI)_"NO COMMENTS ENTERED" Q
	.S SRLINE=0 F  S SRLINE=$O(^SRF(SRTN,7,SRLINE)) Q:'SRLINE  S X=^SRF(SRTN,7,SRLINE,0) D COMM(X,2)
	Q
SAVE	; cell saver(s)
	N C,DISP,DNM,ID,INF,LOT,OP,SAL,SAV,SRCT,QTY,X,Y
	S SAV=0 F  S SAV=$O(^SRF(SRTN,45,SAV)) Q:'SAV  D
	.S X=^SRF(SRTN,45,SAV,0),ID=$P(X,"^"),SAL=$P(X,"^",3),INF=$P(X,"^",4),Y=$P(X,"^",2),C=$P(^DD(130.013,1,0),"^",2) D:Y Y^DIQ S OP=$S(Y'="":Y,1:"N/A")
	.D LINE(1) S @SRG@(SRI)="  "_ID,@SRG@(SRI)=@SRG@(SRI)_$$SPACE(40)_"Amount Salvaged:  "_$S(SAL:SAL_" ml",1:"N/A")
	.D LINE(1) S @SRG@(SRI)="    Operator:"_OP,@SRG@(SRI)=@SRG@(SRI)_$$SPACE(40)_"Amount Reinfused: "_$S(INF:INF_" ml",1:"N/A")
	.I $O(^SRF(SRTN,45,SAV,1,0)) D LINE(1) S @SRG@(SRI)="    Disposables:",DISP=0 F  S DISP=$O(^SRF(SRTN,45,SAV,1,DISP)) Q:'DISP  D
	..S X=^SRF(SRTN,45,SAV,1,DISP,0),DNM=$P(X,"^"),LOT=$P(X,"^",2),QTY=$P(X,"^",3) D LINE(1) S @SRG@(SRI)="      "_DNM
	..D LINE(1) S @SRG@(SRI)=$$SPACE(8)_"Lot: "_LOT,@SRG@(SRI)=@SRG@(SRI)_$$SPACE(40)_"Quantity: "_QTY
	.S (SRCT,SRLINE)=0 F  S SRLINE=$O(^SRF(SRTN,45,SAV,2,SRLINE)) Q:'SRLINE  S SRCT=SRCT+1
	.Q:'SRCT  D LINE(1) S SRLINE=0,SRL=4,SRLINE=$O(^SRF(SRTN,45,SAV,2,SRLINE)),X=^SRF(SRTN,45,SAV,2,SRLINE,0)
	.I SRCT=1,$L(X)<67 S @SRG@(SRI)="    Comments: "_X Q
	.S @SRG@(SRI)="    Comments:" D COMM(X,SRL)
	.F  S SRLINE=$O(^SRF(SRTN,45,SAV,2,SRLINE)) Q:'SRLINE  S X=^SRF(SRTN,45,SAV,2,SRLINE,0) D COMM(X,SRL)
	Q
N(SRL)	N SRN I $L(Y)>SRL S SRN=$P(Y,",")_","_$E($P(Y,",",2))_".",Y=SRN
	Q
COMM(X,NUM)	; output text
	; X = line of text to be processed
	; NUM = left margin
	N I,J,K,Y,SRL S SRL=80-NUM
	I $L(X)<(SRL+1)!($E(X,1,SRL)'[" ") D LINE(1) S @SRG@(SRI)=$$SPACE(NUM)_X Q
	S K=1 F  D  I $L(X)<SRL+1 S X(K)=X Q
	.F I=0:1:SRL-1 S J=SRL-I,Y=$E(X,J) I Y=" " S X(K)=$E(X,1,J-1),X=$E(X,J+1,$L(X)) S K=K+1 Q
	F I=1:1:K D LINE(1) S @SRG@(SRI)=$$SPACE(NUM)_X(I)
	Q
SPACE(NUM)	; create spaces
	;pass in position returns number of needed spaces
	I '$D(@SRG@(SRI)) S @SRG@(SRI)=""
	Q $J("",NUM-$L(@SRG@(SRI)))
LINE(NUM)	; create carriage returns
	I $G(SRLF) S NUM=NUM+1,SRLF=0
	F J=1:1:NUM S SRI=SRI+1,@SRG@(SRI)=""
	Q
