BPSRPT8	;BHAM ISC/BEE - ECME REPORTS ;14-FEB-05
	;;1.0;E CLAIMS MGMT ENGINE;**1,3,5,7,8,10,11,19**;JUN 2004;Build 18
	;;Per VA Directive 6402, this routine should not be modified.
	;
	;Reference to IB NCPCP NON-BILLABLE STATUS REASONS (#366.17) supported by ICR 6136
	;
	Q
	;
	;Routine to Display the Reports in Excel
	;
	;Print Report Line 1
	;
	; Input Variable -> BPRTYPE,BPDIV,BPGRPLAN,BPDFN,BPRX,BPREF,BPX,BPSRTDT
	;                   BPBIL,BPINS,BPCOLL
	; 
WRLINE1(BPRTYPE,BPREC,BPDIV,BPGRPLAN,BPDFN,BPRX,BPREF,BPX,BPSRTDT,BPBIL,BPINS,BPCOLL,BPPSEQ)	;
	;
	N BP59,BP02,BP03
	S BP59=$P(BPX,U,3)
	S BP02=+$P($G(^BPST(BP59,0)),U,4)
	S BP03=+$P($G(^BPST(BP59,0)),U,5)
	;Division
	S BPREC=$S(BPDIV=0:"BLANK",$$DIVNAME^BPSSCRDS(BPDIV)]"":$$DIVNAME^BPSSCRDS(BPDIV),1:BPDIV)_U
	;Insurance
	I BPRTYPE'=5,BPRTYPE'=6 S BPREC=BPREC_$E(BPGRPLAN,1,90)_U
	S BPREC=BPREC_$$PATNAME^BPSRPT6(BPDFN)_U  ;Patient Name
	S BPREC=BPREC_"("_$$SSN4^BPSRPT6(BPDFN)_")"_U ;L4SSN
	;
	I (BPRTYPE=1)!(BPRTYPE=4) D  Q
	. N PTRESP
	. S BPREC=BPREC_$$ELIGCODE^BPSSCR05($P(BPX,U,3))_U ;Eligibility
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(BPSRTDT)_U  ;Date
	. S BPREC=BPREC_$$INGRCST^BPSSCRLG(BP02)_U  ;Ingredient Cost
	. S BPREC=BPREC_$$DISPFEE^BPSSCRLG(BP02)_U  ;Dispensing Fee
	. S BPREC=BPREC_$TR($J(BPBIL,10,2)," ")_U ;$Billed
	. S BPREC=BPREC_$$ICPAID^BPSSCRLG(BP03)_U  ;Ingredient Cost Paid
	. S BPREC=BPREC_$$DFPAID^BPSSCRLG(BP03)_U  ;Dispensing Fee Paid
	. S PTRESP=$$PTRESP^BPSSCRLG(BP03) S BPREC=BPREC_$S('PTRESP:PTRESP,1:"-"_PTRESP)_U  ;Patient Pay Amount
	. S BPREC=BPREC_$TR($J(BPINS,10,2)," ")_U ;$Ins. Paid
	. S BPREC=BPREC_$S(BPCOLL]"":$TR($J(BPCOLL,10,2)," "),1:"")_U ;$Collected
	;
	I BPRTYPE=2 D  Q
	. S BPREC=BPREC_$$ELIGCODE^BPSSCR05($P(BPX,U,3))_U ;Eligibility
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(BPSRTDT)_U ;Date
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(+BPX)_U  ;Released On
	. ;RX INFO
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_U  ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. S BPREC=BPREC_$$RXCOB($G(BPPSEQ))_U
	. S BPREC=BPREC_$S($$CLOSED02^BPSSCR03($P(^BPST($P(BPX,U,3),0),U,4))=1:"C",1:"O")_U ;Open/Closed
	;
	I BPRTYPE=3 D  Q
	. N PTRESP
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(BPSRTDT)_U ;Date
	. S BPREC=BPREC_$$INGRCST^BPSSCRLG(BP02)_U  ;Ingredient Cost
	. S BPREC=BPREC_$$DISPFEE^BPSSCRLG(BP02)_U  ;Dispensing Fee
	. S BPREC=BPREC_$TR($J(BPBIL,10,2)," ")_U ;$Billed
	. S BPREC=BPREC_$$ICPAID^BPSSCRLG(BP03)_U  ;Ingredient Cost Paid
	. S BPREC=BPREC_$$DFPAID^BPSSCRLG(BP03)_U  ;Dispensing Fee Paid
	. S PTRESP=$$PTRESP^BPSSCRLG(BP03) S BPREC=BPREC_$S('PTRESP:PTRESP,1:"-"_PTRESP)_U  ;Patient Pay Amount
	. S BPREC=BPREC_$TR($J(BPINS,10,2)," ")_U ;Insurance Response
	;
	I BPRTYPE=5 D  Q
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$DATTIM^BPSRPT1($$TRANDT^BPSRPT2($P(BPX,U,3),1))_U ;Completed
	. S BPREC=BPREC_$$TTYPE^BPSRPT7($P(BPX,U,4),$P(BPX,U,5),BPPSEQ)_U ;Trans Type
	. S BPREC=BPREC_$$RESPONSE^BPSRPT7($P(BPX,U,4),$P(BPX,U,5),BPPSEQ)_U ;Payer Response
	. S BPREC=BPREC_$$RXCOB($G(BPPSEQ))_U ;RX COB
	;
	I BPRTYPE=7 D  Q
	. ;RX INFO
	. S BPREC=BPREC_$$ELIGCODE^BPSSCR05($P(BPX,U,3))_U ;Eligibility
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_U ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. S BPREC=BPREC_$S($P(BPX,U,13):"REJ",1:"")_U
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),32)_U ;Drug
	. S BPREC=BPREC_$TR($$GETNDC^BPSRPT6(BPRX,BPREF),"-")_U
	;
	I (BPRTYPE=8) D  Q
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_"/"_$$ECMENUM^BPSRPT1($P(BPX,U,3))_U ;Refill/ECME Number
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(BPSRTDT)_U  ;Date
	. S BPREC=BPREC_$TR($J(BPBIL,10,2)," ")_U ;$Billed
	. S BPREC=BPREC_$TR($J(BPINS,10,2)," ")_U ;$Ins. Paid
	. S BPREC=BPREC_$S(BPCOLL]"":$TR($J(BPCOLL,10,2)," "),1:"")_U ;$Collected
	;
	I BPRTYPE=9 D  Q
	. N ELGCD S ELGCD=$P(BPX,U,1)
	. S BPREC=BPREC_$S(ELGCD="V":"VET",ELGCD="T":"TRI",ELGCD="C":"CVA",1:"UNK")_U
	. S BPREC=BPREC_$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)_U ;RX Number
	. S BPREC=BPREC_BPREF_U                      ;Refill
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(BPSRTDT)_U  ;Date
	. S BPREC=BPREC_$S($P(BPX,U,2)]"":$TR($J($P(BPX,U,2),10,2)," "),1:"")_U ;$Drug Cost
	Q
	;
	;Print Report Line 2
	;
	; Input Variable -> BPRTYPE,BPX,BPRX,BPREF,BPBIL,BPGRPLAN
	; 
WRLINE2(BPRTYPE,BPREC,BPX,BPRX,BPREF,BPBIL,BPGRPLAN,BPPSEQ)	;
	N BP59,BP02
	S BP59=$P(BPX,U,3)
	S BP02=+$P($G(^BPST(BP59,0)),U,4)
	;
	I (BPRTYPE=1)!(BPRTYPE=4) D  Q
	. ;Drug, Released On
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),32)_U_$TR($$GETNDC^BPSRPT6(BPRX,BPREF),"-")_U
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(+BPX)_U
	. ;RX INFO
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_U ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. I BPRTYPE=4 S BPREC=BPREC_$$RXCOB($G(BPPSEQ))_U
	. S BPREC=BPREC_$S($P(BPX,U,13):"REJ",1:"")
	. I BPRTYPE=1 S BPREC=BPREC_U_$$BILL^BPSRPT6(BPRX,BPREF,BPPSEQ)_U_$$RXCOB($G(BPPSEQ)) ;Bill # and RX COB
	;
	I BPRTYPE=2 D  Q
	. S BPREC=BPREC_$E($$CRDHLDID^BPSRPT2(+$P(BPX,U,3)),3,23)_U ;Cardholder ID
	. S BPREC=BPREC_$E($$GRPID^BPSRPT2(+$P(BPX,U,3)),3,10)_U ;Group ID
	. S BPREC=BPREC_$$INGRCST^BPSSCRLG(BP02)_U  ;Ingredient Cost
	. S BPREC=BPREC_$$DISPFEE^BPSSCRLG(BP02)_U  ;Dispensing Fee
	. S BPREC=BPREC_$TR($J(BPBIL,10,2)," ")_U ;$Billed
	. S BPREC=BPREC_$$QTY^BPSRPT6($P(BPX,U,3))_U ;Qty
	. S BPREC=BPREC_$$GETNDC^BPSRPT6(BPRX,BPREF)_U ;NDC#
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),32)_U ;Drug
	;
	I BPRTYPE=3 D  Q
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),32)_U ;Drug
	. S BPREC=BPREC_$TR($$GETNDC^BPSRPT6(BPRX,BPREF),"-")_U
	. ;RX INFO
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_U ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. S BPREC=BPREC_$$RXCOB($G(BPPSEQ))_U
	. S BPREC=BPREC_$S($P(BPX,U,13):"REJ",1:"")
	;
	I BPRTYPE=5 D  Q
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),32)_U ;Drug
	. S BPREC=BPREC_$TR($$GETNDC^BPSRPT6(BPRX,BPREF),"-")_U
	. ;RX INFO
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_U ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. S BPREC=BPREC_$S($P(BPX,U,13):"REJ",1:"")_U
	. I $P(BPGRPLAN,U,2)]"" S BPREC=BPREC_$E($P(BPGRPLAN,U,2),1,30) ;Insurance
	. S BPREC=BPREC_U_$$ELAPSE^BPSRPT6($P(BPX,U,3))  ;Elapsed Time
	;
	I BPRTYPE=7 D  Q
	. S BPREC=BPREC_$E($$CRDHLDID^BPSRPT2(+$P(BPX,U,3)),3,23)_U ;Cardholder ID
	. S BPREC=BPREC_$E($$GRPID^BPSRPT2(+$P(BPX,U,3)),3,10)_U  ;Group ID
	. S BPREC=BPREC_$$DATTIM^BPSRPT1(+$$CLOSEDT^BPSRPT2(+$P(BPX,U,3)))_U ;Close Dt/Time
	. S BPREC=BPREC_$E($$CLSBY^BPSRPT6(+$P(BPX,U,3)),1,25)_U ;Close By
	. S BPREC=BPREC_$E($P($$CLRSN^BPSRPT7(+$P(BPX,U,3)),U,2),1,30)_U ;Close Reason
	;
	I BPRTYPE=8 D  Q
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,14),27)_U ;Drug
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_" " ;Fill Location
	. S BPREC=BPREC_$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))_" " ;Fill Type
	. S BPREC=BPREC_$$RXSTATUS^BPSRPT6($P(BPX,U,3)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U):"/R",1:"/N")_U ;RL/NR
	. S BPREC=BPREC_$TR($E($$GRPID^BPSRPT2(+$P(BPX,U,3)),3,10)," ","")_U  ;Group ID
	. S BPREC=BPREC_$E(BPGRPLAN,1,30)_U ;Insurance
	. S BPREC=BPREC_$$BILL^BPSRPT6(BPRX,BPREF,BPPSEQ)_U ;Bill#
	;
	I BPRTYPE=9 D  Q
	. S BPREC=BPREC_$$DRGNAM^BPSRPT6($P(BPX,U,4),32)_U  ;Drug
	. S BPREC=BPREC_$TR($$GETNDC^BPSRPT6(BPRX,BPREF),"-")_U ;NDC
	. S BPREC=BPREC_$$DATTIM^BPSRPT1($P(BPX,U,5))_U  ;Release Date
	. S BPREC=BPREC_$$MWC^BPSRPT6(BPRX,BPREF)_U      ;Fill Location
	. S BPREC=BPREC_$$RXSTANAM^BPSSCRU2($P(BPX,U,6)) ;Status
	. S BPREC=BPREC_$S($P(BPX,U,5):"/R",1:"/N")_U    ;RL/NR
	. S BPREC=BPREC_$$GET1^DIQ(366.17,$P(BPX,U,7),.01,"E")  ;Non-Billable Status Reason - ICR 6136
	Q
	;
	;Print Report Line 3
	;
	; Input Variable -> BPRTYPE,BPX
	; 
WRLINE3(BPRTYPE,BPREC,BPX)	N BP59,BPSARR,BPRJCNT,BPZZ,BPRICE
	S BP59=+$P(BPX,U,3)
	;
	I (",2,7,")[BPRTYPE D  Q
	.S BPREC=BPREC_$$CLAIMID^BPSRPT2(BP59)_U ;Claim ID
	.S BPRJCNT=$$REJTEXT^BPSRPT2(BP59,.BPSARR)
	.F BPZZ=1:1:BPRJCNT S:BPZZ'=1 BPREC=BPREC_"," S BPREC=BPREC_$P(BPSARR(BPZZ),":")
	.;
	.;Write one record per reject/close code
	.S:+BPRJCNT=0 BPRJCNT=1
	.F BPZZ=1:1:BPRJCNT W !,$G(BPREC),U,$P($G(BPSARR(BPZZ)),":"),U,$P($G(BPSARR(BPZZ)),":",2)
	;
	I BPRTYPE=4 D
	. ;Method
	. I $$AUTOREV^BPSRPT1(BP59) S BPREC=BPREC_U_"AUTO"_U
	. E  S BPREC=BPREC_U_"REGULAR"_U
	. ;Return Status
	. I $P(BPX,U,15)["ACCEPTED" S BPREC=BPREC_"ACCEPTED"_U
	. E  S BPREC=BPREC_"REJECTED"_U
	. ;Reason
	. S BPREC=BPREC_$$RVSRSN^BPSRPT7(+$P(BPX,U,3))
	;
	I BPRTYPE=8 D
	. S BPRICE=$$PRICEVAL^BPSRPT5(BP59)
	. S BPREC=BPREC_$P($G(BPRICE),U,3)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,4)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,5)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,6)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,7)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,2)_U
	. S BPREC=BPREC_$P($G(BPRICE),U,1)_U
	;Write the record
	W !,$G(BPREC)
	Q
	;
	;Print Excel Header
	;
HDR(BPRTYPE)	;
	;
	;Check if header already printed
	I $G(BPSDATA) Q
	S BPSDATA=1
	;
	;Division
	W !,"DIVISION",U
	;
	I BPRTYPE'=5,BPRTYPE'=6 W "INSURANCE",U
	;
	I (",1,2,3,4,5,7,8,9,")[BPRTYPE W "PATIENT NAME",U,"Pt.ID",U
	;
	I (BPRTYPE=1)!(BPRTYPE=4) D  Q
	. W "ELIGIBILITY",U
	. W "RX#",U
	. W "REF/ECME#",U
	. W "DATE",U
	. W "VA INGREDIENT COST",U
	. W "VA DISPENSING FEE",U
	. W "$BILLED",U
	. W "INGREDIENT COST PAID",U
	. W "DISPENSING FEE PAID",U
	. W "PATIENT RESP (INS)",U
	. W "$INS RESPONSE",U
	. W "$COLLECT",U
	. W "DRUG",U
	. W "NDC",U
	. W "RELEASED ON",U
	. W "FILL LOCATION",U
	. W "FILL TYPE",U
	. W "STATUS",U
	. I BPRTYPE=4 W "RX COB",U
	. W "REJECTED"
	. I BPRTYPE=1 W U,"BILL#",U,"RX COB"
	. I BPRTYPE=4 W U,"REVERSAL METHOD",U,"RETURN STATUS",U,"REASON"
	;
	I BPRTYPE=2 D  Q
	. W "ELIGIBILITY",U
	. W "RX#",U
	. W "REF/ECME#",U
	. W "DATE",U
	. W "RELEASED ON",U
	. W "FILL LOCATION",U
	. W "FILL TYPE",U
	. W "STATUS",U
	. W "RX COB",U
	. W "OPEN/CLOSED",U
	. W "CARDHOLD.ID",U
	. W "GROUP ID",U
	. W "VA INGREDIENT COST",U
	. W "VA DISPENSING FEE",U
	. W "$BILLED",U
	. W "QTY",U
	. W "NDC#",U
	. W "DRUG",U
	. W "CLAIM ID",U
	. W "REJECT CODE(S)",U
	. W "REJECT CODE",U
	. W "REJECT EXPLANATION"
	;
	I BPRTYPE=3 D  Q
	. W "RX#",U
	. W "REF/ECME#",U
	. W "DATE",U
	. W "VA INGREDIENT COST",U
	. W "VA DISPENSING FEE",U
	. W "$BILLED",U
	. W "INGREDIENT COST PAID",U
	. W "DISPENSING FEE PAID",U
	. W "PATIENT RESP (INS)",U
	. W "$INS RESPONSE",U
	. W "DRUG",U
	. W "NDC",U
	. W "FILL LOCATION",U
	. W "FILL TYPE",U
	. W "STATUS",U
	. W "RX COB",U
	. W "REJECTED"
	;
	I BPRTYPE=5 D  Q
	. W "RX#",U
	. W "REF/ECME#",U
	. W "COMPLETED",U
	. W "TRANS TYPE",U
	. W "PAYER RESPONSE",U
	. W "RX COB",U
	. W "DRUG",U
	. W "NDC",U
	. W "FILL LOCATION",U
	. W "FILL TYPE",U
	. W "STATUS",U
	. W "REJECTED",U
	. W "INSURANCE",U
	. W "ELAP TIME IN SECONDS"
	;
	I BPRTYPE=6 D  Q
	.W "DATE",U
	.W "#CLAIMS",U
	.W "AMOUNT SUBMITTED",U
	.W "RETURNED REJECTED",U
	.W "RETURNED PAYABLE",U
	.W "AMOUNT TO RECEIVE",U
	.W "DIFFERENCE"
	;
	I BPRTYPE=7 D  Q
	. W "ELIGIBILITY",U
	. W "RX#",U
	. W "REF/ECME#",U
	. W "FILL LOCATION",U
	. W "FILL TYPE",U
	. W "STATUS",U
	. W "REJECTED",U
	. W "DRUG",U
	. W "NDC",U
	. W "CARDHOLD.ID",U
	. W "GROUP ID",U
	. W "CLOSE DATE/TIME",U
	. W "CLOSED BY",U
	. W "CLOSE REASON",U
	. W "CLAIM ID",U
	. W "REJECT CODE(S)",U
	. W "REJECT CODE",U
	. W "REJECT EXPLANATION"
	;
	I BPRTYPE=8 D  Q
	. W "RX#",U
	. W "REF/ECME#",U
	. W "DATE",U
	. W "$BILLED",U
	. W "$INS RESPONSE",U
	. W "$COLLECT",U
	. W "DRUG",U
	. W "RX INFO",U
	. W "INS GROUP#",U
	. W "INS GROUP NAME",U
	. W "BILL#",U
	. W "$PROVIDER NETWORK",U
	. W "$BRAND DRUG",U
	. W "$NON-PREF FORM",U
	. W "$BRAND NON-PREF FORM",U
	. W "$COVERAGE GAP",U
	. W "$HEALTH ASST",U
	. W "$SPEND ACCT REMAINING",U
	;
	I BPRTYPE=9 D  Q
	. W "ELIGIBILITY",U
	. W "RX#",U
	. W "REF",U
	. W "DATE",U
	. W "$DRUG COST",U
	. W "DRUG",U
	. W "NDC",U
	. W "RELEASED ON",U
	. W "FILL LOCATION",U
	. W "STATUS",U
	. W "NON-BILLABLE STATUS REASON"
	Q
	;return RX COB as the 1st letter of the RX COB indicator
RXCOB(BPPSEQ)	;
	Q $S(BPPSEQ=1:"p",BPPSEQ=2:"s",1:"")
	;BPSRPT8