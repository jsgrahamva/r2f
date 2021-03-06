DGMSCK	;ALB/PJR,LBD - CONSISTENCY API'S FROM DGRPC3 ; 5/20/09 5:33pm
	;;5.3;Registration;**451,797**;Mar 12, 2004;Build 24
0	Q  ;; Must be called at a tag (API)
	;;
MSCK(MSECHK)	;; Check MSE API
	N I1,I2,MSE
	S (MSERR,MSDATERR)=0,ANYMSE=""
	;Use MSE data in DGPMSE array, if it exists (DG*5.3*797)
	I $D(DGPMSE) D  Q 1
	.S I1=0 F  S I1=$O(DGPMSE(I1)) Q:'I1  D
	..S ANYMSE=ANYMSE_I1
	..I $P(DGPMSE(I1),U,7) Q  ;Don't check MSE verified by HEC
	..;Check if service dates are missing
	..I $P(DGPMSE(I1),U)=""!($P(DGPMSE(I1),U,2)="") S (MSERR,MSDATERR)=1 Q
	..;Check if service dates are inexact
	..I $E($P(DGPMSE(I1),U),4,7)="0000"!($E($P(DGPMSE(I1),U,2),4,7)="0000") S (MSERR,MSDATERR)=1 Q
	..;Check if branch of service or service discharge type are missing
	..I $P(DGPMSE(I1),U,3)=""!($P(DGPMSE(I1),U,6)="") S MSERR=1
	;Otherwise use MSE data in DGP(.32)
	F I1=1:1:3 S ANYMSE(I1)=0
	F MSE="4;5;6;7","9;10;11;12","14;15;16;17" D ANY
	;; ANYMSE Saved for use with checks 79 through 82
	S ANYMSE="" F I1=1:1:3 I ANYMSE(I1) S ANYMSE=ANYMSE_I1
	Q 1
ANY	S ANYMSE=0 F I2=1:1:4 I $P(DGP(.32),"^",$P(MSE,";",I2))]"" S ANYMSE=1 Q
	I 'ANYMSE Q
	S ANYMSE(MSE+1\5)=1 ;; Set ANY Data found for Last, NTL, and NNTL
	F I2=1:1:4 I $P(DGP(.32),"^",$P(MSE,";",I2))']"" S MSERR=1 S:I2>2 MSDATERR=1
	I MSDATERR Q
	F I2=3,4 I $E($P(DGP(.32),"^",$P(MSE,";",I2)),4,7)="0000" S (MSERR,MSDATERR)=1 Q
	Q
CNCK(CONCHK)	;; Check Conflicts API
	N I1,I2,DATA,DATE,FROMPC,LOC,NODE,TOPC,YESNO
	S CONERR=0 F I1=1:1:7 S I2=$T(CNFLT+I1) D LOC
	Q 1
LOC	;;
	S LOC=$P(I2,";;",2),DATA=$P(I2,";;",3),CONSPEC(LOC)=DATA
	S NODE=$P(DATA,",",1),YESNO=$P(DATA,",",2)
	S FROMPC=$P(DATA,",",3),TOPC=$P(DATA,",",4)
	S CONARR(LOC)=0 I $P(DGP(NODE),"^",YESNO)'="Y" Q
	S CONARR(LOC)=1
	F I2=FROMPC,TOPC S DATE=$P(DGP(NODE),"^",I2) I 'DATE!($E(DATE,4,7)="0000") S CONERR=1,CONARR(LOC)=2 Q
	Q
RANGE(RANSET)	;; Set Conflict Date Ranges
	N I1,I2,I3
	S I1="WWI,WWIIE,WWIIP,KOR,VIET,LEB,GREN,PAN,GULF,SOM,YUG,OTHER"
	F I2=1:1:12 S I3=$P(I1,",",I2),RANGE(I3)=$$GETCNFDT^DGRPDT(I3)
	Q 1
MSFROMTO(MSESET)	;; Set first and last overall MSE from/to dates
	N MSEFROM,MSETO,I1,I2,I3
	S MSEFROM=9999999,MSETO=0 ;; Initialize from/to dates
	;;
	;; Find first MSE FROM Date and last MSE TO date
	I $G(ANYMSE) D
	.;Use MSE data in DGPMSE array, if it exists
	.I $D(DGPMSE) D  Q
	..S I1=0
	..F  S I1=$O(DGPMSE(I1)) Q:'I1  S I2=$P(DGPMSE(I1),U),I3=$P(DGPMSE(I1),U,2) S:I2<MSEFROM MSEFROM=I2 S:I3>MSETO MSETO=I3
	.;Otherwise, use MSE data from DGP(.32)
	.F I1=6,11,16 S I2=$P(DGP(.32),"^",I1) I I2,I2<MSEFROM S MSEFROM=I2
	.F I1=7,12,17 S I2=$P(DGP(.32),"^",I1) I I2,I2>MSETO S MSETO=I2
	Q MSEFROM_"^"_MSETO
	;;
CNFLT	;;
	;;SOM;;.322,16,17,18
	;;YUG;;.322,19,20,21
	;;PAN;;.322,7,8,9
	;;GREN;;.322,4,5,6
	;;LEB;;.322,1,2,3
	;;VIET;;.321,1,4,5
	;;GULF;;.322,10,11,12
