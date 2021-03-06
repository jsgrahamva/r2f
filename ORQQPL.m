ORQQPL	; ISL/CLA,REV,JER,TC - RPCs to return problem list data ;12/05/13  13:15
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**9,10,85,173,306,361,385**;Dec 17, 1997;Build 12
	;
	;  External References:
	;  $$CODECS^ICDEX          ICR #5747
	;  $$STATCHK^ICDXCODE      ICR #5699
	;  $$STATCHK^LEXSRC2       ICR #4083
	;
LIST(ORPY,DFN,STATUS)	 ;return pt's problem list in format: ien^description^
	; ICD^onset^last modified^SC^SpExp
	; STATUS = status of problems to return: (A)CTIVE, (I)NACTIVE, ("")ALL
	Q:'+DFN
	N ORGMPL,I,DETAIL,ORIDT,IMPLDT
	S IMPLDT=$$IMPDATE^LEXU("10D")
	S ORIDT=$S($P(DFN,U,2)]"":$P(DFN,U,2),1:DT)
	S:ORIDT'>0 ORIDT=DT
	S DFN=+DFN
	I $L($T(LIST^GMPLUTL2))>0 D
	.D LIST^GMPLUTL2(.ORGMPL,DFN,STATUS)
	.Q:'$D(ORGMPL(0))
	.S DETAIL=$$DETAIL^ORWCV1(10)
	.F I=1:1:ORGMPL(0) D
	..N LEX,X
	..S X=ORGMPL(I)
	..S ORPY(I)=$P(X,U)_U_$P(X,U,3)_U_$P(X,U,2)_U_$P(X,U,4)_U_$P(X,U,5)_U_$P(X,U,6)_U_$P(X,U,7)_U_$P(X,U,8)_U_$P(X,U,10)_U_$P(X,U,9)_U_U_DETAIL_U_U_$P(X,U,11)_U_$P(X,U,12)_U_$P(X,U,13)
	..I (ORIDT<IMPLDT),(+$$STATCHK^ICDXCODE($P(ORPY(I),U,16),$P(ORPY(I),U,4),ORIDT)'=1) D  I 1
	...S $P(ORPY(I),U,13)="#",$P(ORPY(I),U,9)="#"
	..E  I $L($P(ORPY(I),U,14)),(+$$STATCHK^LEXSRC2($P(ORPY(I),U,14),ORIDT,.LEX)'=1) S $P(ORPY(I),U,13)="$",$P(ORPY(I),U,9)="#"
	.S:+$G(ORPY(1))<1 ORPY(1)="^No problems found."
	I $L($T(LIST^GMPLUTL2))<1 S ORPY(1)="^Problem list not available.^"
	K X
	Q
DETAIL(Y,DFN,PROBIEN,ID)	 ; RETURN DETAILED PROBLEM DATA
	N ORGMPL,ORIDT,GMPDT,ORICDLBL
	S ORIDT=$S($P(DFN,U,2)]"":$P(DFN,U,2),1:DT)
	S DFN=+DFN
	S:ORIDT'>0 ORIDT=DT
	I $L($T(DETAIL^GMPLUTL2))>0 D
	.N CR,I,J,T,LEX S CR=$CHAR(13),I=1
	.D DETAIL^GMPLUTL2(PROBIEN,.ORGMPL)
	.S ORICDLBL=$P($$CODECS^ICDEX(ORGMPL("DIAGNOSIS"),80,ORGMPL("DTINTEREST")),U,2)
	.S Y(I)=ORGMPL("NARRATIVE"),I=I+1
	.I '+$$STATCHK^ICDXCODE(ORGMPL("CSYS"),ORGMPL("DIAGNOSIS"),ORIDT) D  I 1
	..S Y(I)="*** The "_ORICDLBL_" code "_ORGMPL("DIAGNOSIS")_" is currently inactive. ***",I=I+1
	.I +$G(ORGMPL("SCTC")),(+$$STATCHK^LEXSRC2($G(ORGMPL("SCTC")),ORIDT,.LEX)'=1) D
	..S Y(I)="*** The SNOMED-CT code "_ORGMPL("SCTC")_" is currently inactive. ***",I=I+1
	.I $L($G(ORGMPL("SCTC")))!$L($G(ORGMPL("SCTD"))) D  I 1
	..I $P(ORGMPL("NARRATIVE")," (SCT")'=ORGMPL("SCTT") S Y(I)="         SNOMED-CT: "_ORGMPL("SCTT"),I=I+1
	..I $L($G(ORGMPL("DIAGNOSIS")))&$L($G(ORGMPL("ICDD"))) S Y(I)=$S(ORGMPL("CSYS")="10D":" Primary ",1:"  Primary ")_ORICDLBL_": "_$G(ORGMPL("DIAGNOSIS"))_$$PAD^ORUTL($G(ORGMPL("DIAGNOSIS")),6)_" ["_$G(ORGMPL("ICDD"))_"]",I=I+1
	.E  I $L($G(ORGMPL("ICDD"))) D
	..N ICDD,J S ICDD=$$WRAP^ORU2($G(ORGMPL("ICDD")),65)
	..F J=1:1:$L(ICDD,"|") S Y(I)=$S(J=1:ORICDLBL_" TEXT: ",1:"              ")_$P(ICDD,"|",J),I=I+1
	.I ORGMPL("ICD9MLTP")'="" F T=1:1:ORGMPL("ICD9MLTP") D
	..N ORMELBL S ORMELBL=$S($P($G(ORGMPL("ICD9MLTP",T)),U,3)="10D":"ICD-10-CM",1:"ICD-9-CM")
	..S Y(I)=$S(T=1:"Secondary "_ORMELBL_": ",T>1:"                  : ")_$P($G(ORGMPL("ICD9MLTP",T)),U)_$$PAD^ORUTL($P($G(ORGMPL("ICD9MLTP",T)),U),6)_" ["_$P($G(ORGMPL("ICD9MLTP",T)),U,2)_"]",I=I+1
	.S Y(I)=" ",I=I+1
	.S Y(I)="        Onset: "_ORGMPL("ONSET"),I=I+1
	.S Y(I)="       Status: "_ORGMPL("STATUS")
	.S Y(I)=Y(I)_$S(ORGMPL("PRIORITY")="ACUTE":"/ACUTE",ORGMPL("PRIORITY")="CHRONIC":"/CHRONIC",1:""),I=I+1
	.S Y(I)="      SC Cond: "_ORGMPL("SC"),I=I+1
	.S Y(I)="     Exposure: "_$S($G(ORGMPL("EXPOSURE"))>0:ORGMPL("EXPOSURE",1),1:"None"),I=I+1
	.I $G(ORGMPL("EXPOSURE"))>1 F J=2:1:ORGMPL("EXPOSURE")  D
	..S Y(I)="               "_ORGMPL("EXPOSURE",J),I=I+1
	.S Y(I)=" ",I=I+1
	.S Y(I)="     Provider: "_ORGMPL("PROVIDER"),I=I+1
	.S Y(I)="       Clinic: "_ORGMPL("CLINIC"),I=I+1
	.S Y(I)=" ",I=I+1
	.S Y(I)="     Recorded: "_$P(ORGMPL("RECORDED"),U)_", by "_$P(ORGMPL("RECORDED"),U,2),I=I+1
	.S Y(I)="      Entered: "_$P(ORGMPL("ENTERED"),U)_", by "_$P(ORGMPL("ENTERED"),U,2),I=I+1
	.S Y(I)="      Updated: "_ORGMPL("MODIFIED"),I=I+1
	.S Y(I)=" ",I=I+1
	.;S Y(I)=" Comment: "_$S($G(ORGMPL("COMMENT"))>0:ORGMPL("COMMENT"),1:"")
	.I $G(ORGMPL("COMMENT"))>0 D
	..S Y(I)="----------- Comments -----------",I=I+1
	..;F J=ORGMPL("COMMENT"):-1:1  D
	..;.S Y(I)=ORGMPL("COMMENT",J)
	..;.S Y(I)=$P(Y(I),U)_" by "_$P(Y(I),U,2)_": "_$P(Y(I),U,3),I=I+1
	..F J=1:1:ORGMPL("COMMENT")  D
	...S Y(I)=ORGMPL("COMMENT",J)
	...S Y(I)=$P(Y(I),U)_" by "_$P(Y(I),U,2)_": "_$P(Y(I),U,3),I=I+1
	.S Y(I)=" ",I=I+1
	.D HIST^ORQQPL2(.GMPDT,PROBIEN)
	.I $G(GMPDT(0))>0 D
	..S Y(I)="----------- Audit History -----------",I=I+1
	..F J=1:1:GMPDT(0)  S Y(I)=$P(GMPDT(J),U)_":  "_$P(GMPDT(J),U,2),I=I+1
	I $L($T(DETAIL^GMPLUTL2))<1 S Y(1)="Problem list not available."
	Q
HASPROB(ORDFN,ORPROB)	;extrinsic function returns 1^problem text;ICD9 if
	;pt has an active problem which contains any piece of ORPROB
	;ORDFN   patient DFN
	;ORPROB  problems to check vs. active prob list in format: PROB1TEXT;PROB1ICD^PROB2TEXT;PROB2ICD^PROB3...
	;if ICD includes "." an exact match will be sought
	;if not, a match of general ICD category will be sought
	;Note: All ICD codes passed must be preceded with ";"
	Q:+$G(ORDFN)<1 "0^Patient not identified."
	Q:'$L($G(ORPROB)) "0^Problem not identified."
	N ORQAPL,ORQY,ORI,ORJ,ORCNT,ORQPL,ORQICD,ORQRSLT
	D LIST(.ORQY,ORDFN,"A")
	Q:$P(ORQY(1),U)="" "0^No active problems found."
	S ORQRSLT="0^No matching problems found."
	S ORCNT=$L(ORPROB,U)
	S ORI=0 F  S ORI=$O(ORQY(ORI)) Q:ORI<1  D
	.S ORQAPL=ORQY(ORI)
	.F ORJ=1:1:ORCNT D
	..S ORQPL=$P($P(ORPROB,U,ORJ),";"),ORQICD=$P($P(ORPROB,U,ORJ),";",2)
	..;if problem text and pt's problem contains problem text passed:
	..I $L(ORQPL),($P(ORQAPL,U,2)[ORQPL) D
	...S ORQRSLT="1^"_$P(ORQAPL,U,2)_";"_$P(ORQAPL,U,4)
	..;
	..;if specific ICD (contains ".") and pt's ICD equals ICD passed:
	..I $L(ORQICD),(ORQICD["."),($P(ORQAPL,U,4)=ORQICD) D
	...S ORQRSLT="1^"_$P(ORQAPL,U,2)_";"_$P(ORQAPL,U,4)
	..;
	..;if non-specific ICD and pt's ICD category equals ICD category passed:
	..I $L(ORQICD),(ORQICD'["."),($P($P(ORQAPL,U,4),".")=ORQICD) D
	...S ORQRSLT="1^"_$P(ORQAPL,U,2)_";"_$P(ORQAPL,U,4)
	Q ORQRSLT
