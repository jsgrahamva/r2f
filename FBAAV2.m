FBAAV2	;AISC/GRR-ELECTRONICALLY TRANSMIT PHARMACY PAYMENTS ;11 Apr 2006  2:52 PM
	;;3.5;FEE BASIS;**3,89,98,116,108,123**;JAN 30, 1995;Build 51
	;;Per VA Directive 6402, this routine should not be modified.
DETP	; ENTRY FROM FBAAV0
	S FBTXT=0
	D CKB5V^FBAAV01 I $G(FBERR) K FBERR Q
	; HIPAA 5010 - line items that have 0.00 amount paid are now required togo to Central Fee
	F K=0:0 S K=$O(^FBAA(162.1,"AE",J,K)) Q:K'>0  F L=0:0 S L=$O(^FBAA(162.1,"AE",J,K,L)) Q:L'>0  S Y(0)=$G(^FBAA(162.1,K,"RX",L,0)),Y(2)=$G(^(2)),Y=$G(^FBAA(162.1,K,0)) I Y(0)]"",Y]"" D
	.S Y(6)=$G(^FBAA(162.1,K,"RX",L,6))       ; FB*3.5*123
	.N FBPICN,FBY
	.S FBPICN=K_U_L
	.S FBY=$S($P(Y,U,12):$P(Y,U,12),1:$P(Y,U,2))_U_+$P(Y(2),U,9)
	.I 'FBTXT S FBTXT=1 D NEWMSG^FBAAV01,STORE^FBAAV01,UPD^FBAAV0
	.D GOTP
	D:FBTXT XMIT^FBAAV01
	Q
	;
GOTP	; process a B5 line item
	N DFN,FBADJ,FBADJA1,FBADJA2,FBADJR1,FBADJR2,FBIENS,FBPNAMX,FBVY0,FBX
	N FBNPI,FBEDIF,FBIA,FBDODINV
	;
	S FBIENS=$P(FBPICN,U,2)_","_$P(FBPICN,U,1)_","
	S FBPAYT=$P(Y(0),"^",20),FBPAYT=$S(FBPAYT]"":FBPAYT,1:"V")
	S FBINVN=$P(Y,"^"),FBINVN=$E("000000000",$L(FBINVN)+1,9)_FBINVN
	S FBEDIF=$S($P(Y,"^",13)]"":"Y",1:" ") ; EDI flag
	S FBDIN=$$AUSDT^FBAAV3($P(Y,"^",2))
	;
	S FBVFN=$P(Y,"^",4)
	S FBNPI=$$EN^FBNPILK(FBVFN)
	S FBVY0=$G(^FBAAV(FBVFN,0)) ; vendor 0 node
	;
	S FBIA=+$P(Y,U,23)                                      ; IPAC agreement ptr
	S FBIA=$S(FBIA:$P($G(^FBAA(161.95,FBIA,0)),U,1),1:"")   ; IPAC external agreement ID# or ""
	S FBIA=$$LJ^XLFSTR(FBIA,"10T")                          ; format to 10 characters
	S FBDODINV=$P(Y(6),U,1)                                 ; DoD invoice#
	S FBDODINV=$$LJ^XLFSTR(FBDODINV,"22T")                  ; format to 22 characters
	;
	S FBVID=$P(FBVY0,U,2),FBVID=$E(FBVID,1,9)_$E(PAD,$L(FBVID)+1,9)
	S FBCSN=$S($P(FBVY0,U,2)]"":$P(FBVY0,U,10),1:"")
	S FBCSN=$E("0000",$L(FBCSN)+1,4)_FBCSN
	I FBPAYT="R" S FBVID=$E(PAD,1,9),FBCSN=$E(PAD,1,4)
	K FBVY0
	;
	S FBRX=$P(Y(0),"^",1),FBRX=$E("00000000",$L(FBRX)+1,8)_FBRX
	I '$L($G(FBAASN)) D STATION^FBAAUTL
	S FBPSA=$$PSA^FBAAV5(+$P(Y(2),U,5),+FBAASN) I $L(+FBPSA)'=3 S FBPSA=999
	S FBTD=$$AUSDT^FBAAV3($P(Y(0),"^",3))
	S FBSUSP=$P(Y(0),"^",8),FBSUSP=$S(FBSUSP="":" ",$D(^FBAA(161.27,+FBSUSP,0)):$P(^(0),"^"),1:" ")
	S FBAC=$$AUSAMT^FBAAV3($P(Y(0),"^",4),8)
	S FBAP=$$AUSAMT^FBAAV3($P(Y(0),"^",16),8)
	I FBAC=FBAP S FBAP="        "
	S DFN=$P(Y(0),"^",5)
	Q:'DFN
	Q:'$D(^DPT(DFN,0))
	; Note: Prior to the following line Y(0) = the 0 node of subfile 161.11
	;After the line Y(0) will be the 0 node of file #2
	S VAPA("P")="",Y(0)=^DPT(DFN,0) D PAT^FBAAUTL2,ADD^VADPT
	S FBPNAMX=$$HL7NAME^FBAAV2(DFN)
	S FBST=$S($P(VAPA(5),"^")="":"  ",$D(^DIC(5,$P(VAPA(5),"^"),0)):$P(^(0),"^",2),1:"  ")
	I $L(FBST)>2 S FBST="**"
	S:$L(FBST)'=2 FBST=$E(PAD,$L(FBST)+1,2)_FBST
	S FBCTY=$S($P(VAPA(7),"^")="":"   ",FBST="  ":"   ",$D(^DIC(5,$P(VAPA(5),"^"),1,$P(VAPA(7),"^"),0)):$P(^(0),"^",3),1:"   ")
	I $L(FBCTY)'=3 S FBCTY=$E("000",$L(FBCTY)+1,3)_FBCTY
	S FBZIP=$S('+$G(VAPA(11)):VAPA(6),+VAPA(11):$P(VAPA(11),U),1:VAPA(6)),FBZIP=$TR(FBZIP,"-","")_$E("000000000",$L(FBZIP)+1,9)
	;
	; get and format adjustment reason codes and amounts (if any)
	D LOADADJ^FBRXFA(FBIENS,.FBADJ)
	S FBX=$$ADJL^FBUTL2(.FBADJ)
	S FBADJR1=$$RJ^XLFSTR($P(FBX,U,1),5," ")
	S FBADJA1=$$AUSAMT^FBAAV3($P(FBX,U,3),9,1)
	S FBADJR2=$$RJ^XLFSTR($P(FBX,U,4),5," ")
	S FBADJA2=$$AUSAMT^FBAAV3($P(FBX,U,6),9,1)
	K FBADJ,FBX
	;
	; build 1st line
	S FBSTR=5_FBAASN_FBSSN_FBPAYT_FBPNAMX_FBVID_FBCSN_FBAC_FBAP_FBAAON
	S FBSTR=FBSTR_FBSUSP_FBTD_FBRX_FBDIN_FBINVN
	S FBSTR=FBSTR_$E(PAD,1,33)_FBST_FBCTY_FBZIP ; reserved for foreign addr
	S FBSTR=FBSTR_$E(FBPSA,1,3)_$P(FBY,U,2)_$E(PAD,1,8)
	S FBSTR=FBSTR_$$PADZ^FBAAV01(FBPICN,30)_$$AUSDT^FBAAV3(+FBY)_"~"
	D STORE^FBAAV01
	;
	; build 2nd line
	S FBSTR=FBADJR1_FBADJR2_FBADJA1_FBADJA2_FBNPI_FBEDIF
	S FBSTR=FBSTR_FBIA_FBDODINV_"~$"                          ; IPAC data from FB*3.5*123
	D STORE^FBAAV01
	Q
	;
HL7NAME(FBDFN)	; return patient name formatted in a 35 character length string
	N FBAR,FBNM
	S FBAR("FILE")=2,FBAR("IENS")=FBDFN,FBAR("FIELD")=.01
	S FBNM=$$HLNAME^XLFNAME(.FBAR,"L35","|")
	Q $$LRJ^FBAAV4(FBNM,35)
