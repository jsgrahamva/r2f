DGPTAE01	;ALB/MTC,HIOFO/FT - Miss. Austin Edit Checks ;11/13/14 2:22pm
	;;5.3;Registration;**58,342,466,664,867,884**;Aug 13, 1993;Build 31
	;
	;no external references
	;
INC	; VERIFY INCOME DATA
	I DGPTINC'?." "1.6N." " S DGPTERC=120
	Q
	;
STATE	;state
	Q:$$FOR^DGADDUTL(DGPTCTRY)>0
	Q:DGPTSTE["X"
	S DGPTSTE=+DGPTSTE I DGPTSTE="" S DGPTERC=117 Q
	I DGPTSTE'?1.2N S DGPTERC=117 Q
	Q
	;
ZIP	;zip code
	Q:$$FOR^DGADDUTL(DGPTCTRY)>0
	I DGPTZIP'?5N&(DGPTZIP'="XXXXX") S DGPTERC=118 Q
	Q
	;
CNTY	;county
	Q:$$FOR^DGADDUTL(DGPTCTRY)>0
	I DGPTCTY'?1.3N S DGPTERC=117 Q
	Q
	;
AGO	;agent orange
	I " 12345"'[DGPTEXA S DGPTERC=115 Q
	I "35"[DGPTEXA&(DGPTPOS2'=7) S DGPTERC=133 Q
	Q
IRAD	;ionizing radiation
	I "024578"'[DGPTPOS2&(DGPTEXI'=" ") S DGPTEXI=" " Q
	I "024578"[DGPTPOS2&("1234 "'[DGPTEXI) S DGPTERC=116 Q
	I DGPTPOS2="Z"&((DGPTEXI=" ")!("1234"'[DGPTEXI)) S DGPTERC=134 Q
	Q
	;
DB	; DATE OF BIRTH EDITS
	;
	I $E(DGPTDOB,1,2)="00" S DGPTDOB="01"_$E(DGPTDOB,3,8)
	I $E(DGPTDOB,3,4)="00" S DGPTDOB=$E(DGPTDOB,1,2)_"01"_$E(DGPTDOB,5,8)
	S DGPTFMDB=($E(DGPTDOB,5,6)-17)_$E(DGPTDOB,7,8)_$E(DGPTDOB,1,4)
	S X=DGPTFMDB,%DT="X" D ^%DT I Y<0 S DGPTERC=113 Q
	D DD^%DT S DGPTORBD=$E(Y,5,6)_"-"_$E(Y,1,3)_"-"_$E(Y,9,12) I DGPTORBD'?1.2N1"-"3U1"-"4N S DGPTERC=113 Q
	I $E(DGPTDOB,5,8)<1857 S DGPTERC=113 Q
	S X1=+DGPTDTS,X2=DGPTFMDB D ^%DTC I X<0 S DGPTERC=113 Q
	S DGPTAGE=X\365 I DGPTAGE>124 S DGPTERC=113 Q   ;BL;NEWBORN CLAIMS DG*5.3*867;Removed check for age less than 1 year
DBQ	;
	K X,X1,X2,Y
	Q
	;
MT	; Means test edits and consistency check
	;
	I DGPTSTTY["^30^" S DGPTMTC="  " Q
	D EDIT Q:DGPTERC
	D CONSIS Q:DGPTERC
	Q
EDIT	;
	D NUMACT^DGPTSUF(30) I DGANUM>0 F I=1:1:DGANUM I $E(DGPTFAC,4,6)[DGSUFNAM(I) S:DGPTMTC'="X " DGPTMTC="X " K DGANUM,DGSUFNAM,I Q
	I "ABCGNXU"'[$E(DGPTMTC) S DGPTERC=119 Q
	I $E(DGPTMTC,1)="A"&("SN"'[$E(DGPTMTC,2)) S DGPTERC=119 Q
	I $E(DGPTMTC,2)=" "&("BCGNXU"'[$E(DGPTMTC)) S DGPTERC=119 Q
	Q
CONSIS	;check for invalid means test indicator
	I DGPTMTC="X "&(+DGPTTY'<2860701) S DGPTERC="119" Q
	Q
	;
PSE	;-- check for pseudo ssn
	S DGPTALF="ABC^DEF^GHI^JKL^MNO^PQR^STU^VWX^YZ^ "
FI	;patient's first initial
	I DGPTFI=" "&($E(DGPTSSN,1)=0) G MI
	I $P(DGPTALF,U,$E(DGPTSSN,1))'[DGPTFI S DGPTERC=130 G PSEQ
MI	;patient's middle initial
	I DGPTMI=" "&($E(DGPTSSN,2)=0) G LN
	I $P(DGPTALF,U,$E(DGPTSSN,2))'[DGPTMI S DGPTERC=130 G PSEQ
LN	;patient's last name
	I $P(DGPTALF,U,$E(DGPTSSN,3))'[$E(DGPTLN,1) S DGPTERC=130 G PSEQ
COMP	;check pseudo ssn, name and dob for consistency
	I $E(DGPTDOB,1,4)_$E(DGPTDOB,7,8)'=$E(DGPTSSN,4,9) S DGPTERC=130
	Q
PSEQ	;
	K DGPTALF
	Q
MST	;military sexual trauma
	I "YNDU "'[DGPTMST S ERR=152
	Q
CV	;combat veteran
	I "12 "'[DGPTCOMVET S ERR=155
	Q
CVDATE	;combat veteran date
	N X,Y
	Q:DGPTCOMVETDT?6" "
	S X=DGPTCOMVETDT,%DT="X" D ^%DT I Y<0 S DGPTERC=154
	Q
SHAD	;shipboard hazard and defense
	I "10 "'[DGPTSHAD S ERR=156
	Q
