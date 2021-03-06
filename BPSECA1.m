BPSECA1	;BHAM ISC/FCS/DRS/VA/DLF - Assemble formatted claim ;05/14/2004
	;;1.0;E CLAIMS MGMT ENGINE;**1,5,8,10,15,19**;JUN 2004;Build 18
	;;Per VA Directive 6402, this routine should not be modified.
	;
	;----------------------------------------------------------------------
	; Assemble ASCII formatted claim submission record
	;
	; Input Variables:
	;  CLAIMIEN - pointer into 9002313.02
	;  MSG - Array passed by reference - This will have the claim packet
	;
	;    5.1 had 14 claim segments (Header, Patient, Insurance, Claim
	;                                Pharmacy Provider, Prescriber,
	;                                COB, Workers Comp, DUR, Pricing,
	;                                Coupon, Compound, Prior Auth,
	;                                Clinical)
	;
	;    D.0 added 3 new request segments (Additional Documentation,
	;                                       Facility, Narrative)
	;
	;    D.1 - D.9 introduces Alphanumeric NCPDP numbers and new
	;                              Purchase and Provider segments
	;
	;    E.0 - E.6 added 2 new request segments (Intermediary, Last
	;                                             Known 4RX)
	;
	;    5.1/D.0 requires field identifiers and separators on all fields
	;        other than the header
	;    5.1/D.0 segment separators are required prior to each segment
	;        following the header
	;    5.1/D.0 group separators appear at the end of each
	;        transaction (prescription)
	;
ASCII(CLAIMIEN,MSG)	;EP - from BPSOSQG
	N IEN,RECORD,BPS,UERETVAL,DET51,WP
	;
	; Quit if no Claim IEN
	I '$G(CLAIMIEN) Q
	I '$D(^BPSC(CLAIMIEN,0)) Q
	;
	; Setup IEN variables (used when executing format code)
	S IEN(9002313.02)=CLAIMIEN
	;
	; Get Payer Sheet pointer
	S IEN(9002313.92)=$P($G(^BPSC(IEN(9002313.02),0)),U,2)
	;
	; Quit if the payer sheet pointer is missing
	I 'IEN(9002313.92) Q
	;
	; Quit if the payer sheet does not exist
	I '$D(^BPSF(9002313.92,+IEN(9002313.92),0)) Q
	;
	; Retrieve claim submission record (used when executing format code)
	D GETBPS2^BPSECX0(IEN(9002313.02),.BPS)
	;
	; Assemble required claim header and optional format sections
	S RECORD=""
	;
	; Do non-repeating claim segments
	D XLOOP^BPSOSH2("100^110^120",.IEN,.BPS,.RECORD)
	;
	; Set list of repeating claim segments
	S DET51="130^140^150^160^170^180^190^200^210^220^230^240^250^260^270^280^290^300"
	;
	; Loop through prescription multiple and get create repeating segments
	S IEN(9002313.0201)=0
	F  S IEN(9002313.0201)=$O(^BPSC(IEN(9002313.02),400,IEN(9002313.0201))) Q:'IEN(9002313.0201)  D
	. ;
	. ;Retrieve prescription information (used when executing format code)
	. K BPS(9002313.0201)
	. D GETBPS3^BPSECX0(IEN(9002313.02),IEN(9002313.0201),.BPS)
	. ;
	. ; Handle the DUR repeating flds
	. D DURVALUE
	. ;
	. ; Handle the COB flds
	. D COBFLDS
	. ;
	. ; If not eligibility verification transmission, append group separator character
	. I $G(BPS(9002313.02,+$G(IEN(9002313.02)),103,"I"))'="E1" S RECORD=RECORD_$C(29)
	. ;
	. ; Assemble claim information required and optional sections
	. D XLOOP^BPSOSH2(DET51,.IEN,.BPS,.RECORD)
	;
	; Need to store by segment due to HL7 constraints.  Had to change field, group,
	; and segment separators to control characters for Vitria/AAC processing as well as
	; shortening the length of the xmit.
	; DMB 11/27/2006 - If the first NNODES has $C(30), this will bomb since OREC will not 
	;   have a value.  Need to look into this.
	N NNODES,INDEX,ONE,TWO,OREC
	S NNODES=0 F  S NNODES=$O(RECORD(NNODES)) Q:NNODES=""  D
	. I RECORD(NNODES)[$C(30) D
	.. S ONE=$P(RECORD(NNODES),($C(30)_$C(28)),1),TWO=$P(RECORD(NNODES),($C(30)_$C(28)),2)
	.. S RECORD(OREC)=RECORD(OREC)_ONE_$C(30)_$C(28),RECORD(NNODES)=TWO
	. S OREC=NNODES
	;
	; Put claim packet into local array to be passed back to calling routine
	S NNODES=""
	S INDEX=1 F  S NNODES=$O(RECORD(NNODES)) Q:NNODES=""  D
	. S MSG("HLS",INDEX)=RECORD(NNODES)
	. S WP(INDEX/100+1,0)=RECORD(NNODES)
	. S INDEX=INDEX+1
	S MSG("HLS",0)=INDEX-1
	;
	; Store raw data into the BPS Claims record
	D WP^DIE(9002313.02,CLAIMIEN_",",9999,"","WP")
	Q
	;
	; DURVALUE - This subroutine will loop through the DUR/PPS repeating
	; fields and load their values into the BPS array for the claim
	; generation process
DURVALUE	;
	N DURCNT,DUR
	;
	K BPS(9002313.1001)
	;
	; Get the number of DUR records
	S DURCNT=$P($G(^BPSC(IEN(9002313.02),400,IEN(9002313.0201),473.01,0)),U,4)
	;
	; Loop through DURS and get the data
	F DUR=1:1:DURCNT  D
	. D GETBPS4^BPSECX0(IEN(9002313.02),IEN(9002313.0201),DUR,.BPS)
	Q
	; COBFLDS - This subroutine will loop through the COB OTHER PAYMENTS repeating
	; fields and load their values into the BPS array for the claim
	; generation process
COBFLDS	;
	N BPCOBCNT,BPSCOB
	;
	K BPS(9002313.0401)
	;
	; Get the number of COB records
	S BPCOBCNT=$P($G(^BPSC(IEN(9002313.02),400,IEN(9002313.0201),337,0)),U,4)
	;
	; Loop through COB and get the data
	F BPSCOB=1:1:BPCOBCNT  D
	. D GETBPS5^BPSECX0(IEN(9002313.02),IEN(9002313.0201),BPSCOB,.BPS)
	Q
