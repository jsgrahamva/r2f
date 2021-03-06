IBCEOB1	;ALB/TMP/PJH - 835 EDI EOB MSG PROCESSING ; 7/13/10 5:32pm
	;;2.0;INTEGRATED BILLING;**137,135,155,296,356,349,431,488**;21-MAR-94;Build 184
	;;Per VHA Directive 2004-038, this routine should not be modified.
	Q
	;
STORE(A,IB0,IBEOB,LEVEL)	;
	; A = the string of data to extract and try to store
	;       each ^ piece is a field to store
	;         within each ^ piece, there are 5 ';' pieces:
	;            1 = piece to extract from the data string;
	;            2 = field to update;
	;            3 = flag for dollar amt (1=YES);
	;            4 = flag for 4-slash stuff without transform (1=YES);
	;            5 = flag for numeric/non-dollar amt (1=Yes, 0=No,
	;                 Dn = the field is numeric with 'n' decimal places
	; IB0 = the record being processed
	; IBEOB = the ien of the EOB entry in file 361.1
	; LEVEL = the array that contains the DIE and DA values if stuffing at a
	;         level other than the top level
	;
	N B,IBPC,IBFLD,DA,DR,DIE,X,Y
	S DR=";"
	;
	I '$G(LEVEL) S DIE="^IBM(361.1,",DA=IBEOB
	;
	I $G(LEVEL) D
	. N Q
	. S DIE=$G(LEVEL("DIE"))
	. S Q=0 F  S Q=$O(LEVEL(Q)) Q:'Q  S DA(Q)=LEVEL(Q)
	. S DA=LEVEL(0)
	;
	I $G(DA) F B=1:1:$L(A,U) D
	. S IBPC=$P(A,U,B),IBFLD=$P(IBPC,";",2)
	. I $P(IB0,U,+IBPC)'="",IBFLD D
	.. N VAL
	.. ; For dollar amts, add full cents; For numerics, strip leading
	.. ;   0's; For non-numeric/non-dollar amts, make any ; in data into |
	.. S VAL=$S($P(IBPC,";",3):$$DOLLAR^IBCEOB($P(IB0,U,+IBPC)),$P(IBPC,";",5):+$P(IB0,U,+IBPC),$P($P(IBPC,";",5),"D",2):$P(IB0,U,+IBPC)/(10**$P($P(IBPC,";",5),"D",2)),1:$TR($P(IB0,U,+IBPC),";","|"))
	.. I $P(IBPC,";",3),VAL S VAL=$P(VAL,".")_"."_$E($P(VAL,".",2)_"00",1,2)
	.. S DR=DR_IBFLD_"///"_$S($P(IBPC,";",4):"/",1:"")_VAL_";"
	;
	S DR=$P(DR,";",2,$L(DR,";")-1)
	I DR'="" D ^DIE
	Q ($D(Y)=0) ;Successfully stored all the data it was sent if $D(Y)=0
	;
HDR(IB0,IBEGBL,IBEOB,HIPAA)	; Store header data for EOB
	; IB0 = the record being processed from the msg
	; IBEOB = the ien of the EOB entry in file 361.1
	;
	N IBDT,IBDTP,DA,DR,DIE,X,Y
	K IBXSAVE("XTRA"),IBZSAVE
	;
	S HIPAA=+$P(IB0,U,16) ;HIPAA Version code
	S IBDT=$P(IB0,U,3),IBDT=$E(IBDT,1,4)-1700_$E(IBDT,5,8)_"."_$P(IB0,U,4)
	S IBDTP=$P(IB0,U,9)
	I IBDTP S IBDTP=$E(IBDTP,1,4)-1700_$E(IBDTP,5,8)
	S DR=$S($P(IB0,U,7)'="":".03////"_$P(IB0,U,7)_";",1:"")_".05////"_IBDT_";.04////"_($P(IB0,U,5)="Y")_";.15///"_$$COBN^IBCEF(+$G(^IBM(361.1,IBEOB,0)))_";.07///"_$P(IB0,U,8)_$S(IBDTP:";.06////"_IBDTP,1:"")
	S DIE="^IBM(361.1,",DA=IBEOB
	D ^DIE
	I $D(Y)'=0 D
	. S ^TMP(IBEGBL,$J,+$O(^TMP(IBEGBL,$J,""),-1)+1)="Bad header data"
	Q ($D(Y)=0)
	;
FINDLN(IB0,IBEOB,IBZDATA,PLREF,ERRCOD)	; Find corresponding billed line for the adj
	; IB0 = the record being processed
	;       NOTE: pieces 3,4,16 are already reformatted
	; IBEOB = the ien of the EOB entry in file 361.1
	; IBZDATA = the array from the output formatter containing line
	;           items for the bill.  This is passed in so this data only has
	;           to be extracted once for each bill (the first time in, it
	;           will be undefined)
	; PLREF = Provider Line Reference
	; OUTPUT = Line # in the original bill that this adjustment relates to
	;          ^ paid procedure code if different from original procedure OR
	;            paid rev code if different from original and no proc code
	; ERRCOD = Contains any error condition that may have been encountered
	;            while conducting the field matching tests.
	;
	N IBLN,IBLN1,IBBNDL,OCHG,OCHG2,OPROC,OREVCD,IBIFN,IBXARRAY,IBXARRY
	N IBXERR,UNITS,UNITS2,UNITS3,IBMOD,Z,Z0,EOBCHG,IBZVLA,IBAMIN,MATCHED,MOD837S
	;
	S (IBLN,IBLN1)="",IBIFN=+$G(^IBM(361.1,IBEOB,0)),(ERRCOD,MATCHED)=0
	S EOBCHG=+$$DOLLAR^IBCEOB($P(IB0,U,15))   ; charges on EOB 40 record
	;
	; if original procedure exists and is different than the 835 procedure,
	; the procedure or revenue code originally billed will be in piece 10
	; of the '40' record of the 835 flat file.  Otherwise, pc 10 is null.
	S IBBNDL=$S($P(IB0,U,10)'="":1,1:0)
	;
	; If this is a split MRA, build array of Vista line#'s from other split MRA's
	I $P($G(^IBM(361.1,IBEOB,0)),U,4)=1,$$SPLIT^IBCEMU1(IBEOB) D
	. N IEN S IEN=0
	. F  S IEN=$O(^IBM(361.1,"B",IBIFN,IEN)) Q:'IEN  I IEN'=IBEOB D
	.. I $P($G(^IBM(361.1,IEN,0)),U,4)'=1 Q    ; not an MRA
	.. I '$$SPLIT^IBCEMU1(IEN) Q               ; not a split EOB
	.. M IBZVLA=^IBM(361.1,IEN,15,"AC")
	.. Q
	. Q
	;
	I $P($G(^DGCR(399,IBIFN,0)),U,19)=3 D  G FINDLNX     ; UB-04 format
	. I '$D(IBZDATA) D F^IBCEF("N-UB-04 SERVICE LINE (EDI)","IBZDATA",,IBIFN)
	. ; Quit if a Line Item CTRL # exist, skip mismatching process.
	. I +PLREF,$D(IBZDATA(+PLREF)) S IBLN=+PLREF_U_$P(IB0,U,10) Q
	. ;
	. S Z=0 F  S Z=$O(IBZDATA(Z)) Q:'Z  D  Q:+MATCHED
	.. ; Quit if processing an MRA and this VistA line# has already been filed
	.. I $P($G(^IBM(361.1,IBEOB,0)),U,4)=1,$D(^IBM(361.1,IBEOB,15,"AC",Z)) Q
	.. ; Quit if split MRA and this VistA line# has already been filed
	.. I $D(IBZVLA(Z)) Q
	.. I $G(IBZDATA(Z))="" Q
	.. ;
	.. ; CHECKING FOR A MATCHING RECORD ON FIRST PASS.
	.. D GTPRCD(IBBNDL,.OPROC,.OREVCD,IBZDATA(Z))      ; Get the Procedure Code values.
	.. ; if not bundled/unbundled
	.. I 'IBBNDL D  Q
	... I OPROC="",OREVCD,OREVCD'=$P(IB0,U,4) Q      ; revenue code
	... I OPROC'="",OPROC'=$P(IB0,U,3) Q             ; procedure code
	... S MATCHED=Z
	.. ;
	.. ; if bundled/unbundled
	.. I IBBNDL D  Q
	... I OPROC="",OREVCD,OREVCD'=+$P(IB0,U,10) Q    ; revenue code
	... I OPROC'="",OPROC'=$P(IB0,U,10) Q            ; procedure code
	... S MATCHED=Z
	.. Q
	. ;
	. I 'MATCHED D  Q
	.. D GTPRCD(IBBNDL,.OPROC,.OREVCD,IBZDATA(1))  ; Due to no matches, get the info from the 1st line item.
	.. I 'IBBNDL D  Q
	... I OPROC="",OREVCD,OREVCD'=$P(IB0,U,4) S ERRCOD=1 Q      ; revenue code
	... I OPROC'="",OPROC'=$P(IB0,U,3) S ERRCOD=2 Q             ; procedure code
	.. I IBBNDL D  Q
	... I OPROC="",OREVCD,OREVCD'=+$P(IB0,U,10) S ERRCOD=1 Q    ; revenue code
	... I OPROC'="",OPROC'=$P(IB0,U,10) S ERRCOD=2 Q            ; procedure code
	.. Q
	. ;
	. ; FOUND A MATCHING PROCEDURE CODE...SO LET'S SEE IF EVERYTHING ELSE MATCHES.
	. S Z=MATCHED
	. D GTPRCD(IBBNDL,.OPROC,.OREVCD,IBZDATA(Z))      ; Get the Procedure Code values.
	. S OCHG=$P(IBZDATA(Z),U,3)*$P(IBZDATA(Z),U,4) ; Total charge from bill
	. S OCHG2=+$P(IBZDATA(Z),U,5)
	. I OCHG'=EOBCHG,OCHG2=EOBCHG S OCHG=OCHG2     ; update OCHG
	. ;
	. ; if not bundled/unbundled
	. I 'IBBNDL D  Q
	.. I +$P(IBZDATA(Z),U,4)'=$P(IB0,U,16) S ERRCOD=3 Q        ; original units
	.. I +OCHG'=EOBCHG S ERRCOD=4 Q                            ; original charges
	.. I '$$MODMATCH($P(IBZDATA(Z),U,9),$P(IB0,U,5,8),.MOD837S),'$$MODMATCH($P($P(IBZDATA(Z),U,9),",",1),$P(IB0,U,5),.MOD837S) S ERRCOD=5_U_MOD837S Q    ; modifiers
	.. S IBLN=Z
	.. Q
	. ;
	. ; if bundled/unbundled
	. I IBBNDL D  Q
	.. I +$P(IBZDATA(Z),U,4)'=$P(IB0,U,16) S ERRCOD=3 Q        ; original units
	.. I +OCHG'=EOBCHG S ERRCOD=4 Q                            ; original charges
	.. I '$$MODMATCH($P(IBZDATA(Z),U,9),$P(IB0,U,11,14),.MOD837S),'$$MODMATCH($P($P(IBZDATA(Z),U,9),",",1),$P(IB0,U,11),.MOD837S) S ERRCOD=5_U_MOD837S Q    ; modifiers
	.. S IBLN=Z_U_$S(OPROC'="":OPROC,1:OREVCD)
	.. Q
	. ; When dealing with Inpatient UB-04's, check for revenue code roll-ups
	. I 'IBLN,$$INPAT^IBCEF(IBIFN,1) D RCRU^IBCEOB00(.IBZDATA,IB0,.IBLN)
	. ; If only 1 rev code and charges are the same, assume a match
	. I 'IBLN,'$P($G(^IBM(361.1,IBEOB,0)),U,4),$O(IBZDATA(""),-1)=$O(IBZDATA("")),+OCHG=EOBCHG S IBLN=+$O(IBZDATA(""))_U_OREVCD
	;
	; At this point, we can assume the claim is CMS-1500 format
	I '$D(IBZDATA) D F^IBCEF("N-HCFA 1500 SERVICE LINE (EDI)","IBZDATA",,IBIFN)
	I +PLREF,$D(IBZDATA(+PLREF)) S IBLN=PLREF_U_$P(IB0,U,10) G FINDLNX   ; If a Line Item CTRL # exist, skip mismatching process.
	;
	S Z=0 F  S Z=$O(IBZDATA(Z)) Q:'Z  D  Q:+MATCHED
	. ; Quit if processing an MRA and this VistA line# has already been filed
	. I $P($G(^IBM(361.1,IBEOB,0)),U,4)=1,$D(^IBM(361.1,IBEOB,15,"AC",Z)) Q
	. ; Quit if split MRA and this VistA line# has already been filed
	. I $D(IBZVLA(Z)) Q
	. I $G(IBZDATA(Z))="" Q
	. ;
	. ; CHECKING FOR A MATCHING RECORD ON FIRST PASS.
	. D GTPRCD(IBBNDL,.OPROC,.OREVCD,IBZDATA(Z))      ; Get the Procedure Code values.
	. I OPROC'=$S('IBBNDL:$P(IB0,U,3),1:$P(IB0,U,10)) Q   ;procedure code.
	. S MATCHED=Z
	. Q
	;
	I 'MATCHED D  G FINDLNX
	. D GTPRCD(IBBNDL,.OPROC,.OREVCD,IBZDATA(1))  ; Because no matches, get the information from the 1st line item.
	. I OPROC'=$S('IBBNDL:$P(IB0,U,3),1:$P(IB0,U,10)) S ERRCOD=2   ; Mis-matched Proc Code.
	;
	; FOUND A MATCHING PROCEDURE CODE...SO LET'S SEE IF EVERYTHING ELSE MATCHES.
	S Z=MATCHED
	; Quit if processing an MRA and this VistA line# has already been filed
	I $P($G(^IBM(361.1,IBEOB,0)),U,4)=1,$D(^IBM(361.1,IBEOB,15,"AC",Z)) G FINDLNX
	; Quit if split MRA and this VistA line# has already been filed
	I $D(IBZVLA(Z)) G FINDLNX
	I $G(IBZDATA(Z))="" G FINDLNX
	;
	S OCHG=$P(IBZDATA(Z),U,8)*$P(IBZDATA(Z),U,9) ; charge from bill
	S IBAMIN=""
	I $P(IBZDATA(Z),U,12)'="" S IBAMIN=$P(IBZDATA(Z),U,12)  ;anesthesia minutes
	S UNITS=$S('IBAMIN:$P(IBZDATA(Z),U,9),1:IBAMIN/15)
	; original units from bill or anesthesia minutes calculation
	I $P(UNITS,".",2) S UNITS=$FN(UNITS,"",1)    ; round to a single decimal place for fractional units
	I $P($P(IB0,U,16),".",2) S $P(IB0,U,16)=$FN($P(IB0,U,16),"",1)
	S UNITS2=$P(IBZDATA(Z),U,9)     ; just the units
	; UNITS3 is the number of anesthesia minutes divided by 10, or nil.
	; Solution to get around the Trailblazers bug for MRAs
	S UNITS3=""
	I IBAMIN'=0 S UNITS3=IBAMIN/10
	;
	I UNITS'=$P(IB0,U,16),UNITS2'=$P(IB0,U,16),UNITS3'=$P(IB0,U,16),IBAMIN'=$P(IB0,U,16) S ERRCOD=3 G FINDLNX  ; Original units
	I $$DOLLAR^IBCEFG1(OCHG)'=+$P(IB0,U,15) S ERRCOD=4 G FINDLNX  ; original charges.
	I $S($P(IB0,U,19):$P(IB0,U,19)=$P(IBZDATA(Z),U),1:1) D  G:+ERRCOD FINDLNX
	. ;Original procedure/chg/units/date have matched in order to get here
	. ;Check matching original modifiers
	. I '$$MODMATCH($$MODLST^IBEFUNC2($P(IBZDATA(Z),U,10)),$S('IBBNDL:$P(IB0,U,5,8),1:$P(IB0,U,11,14)),.MOD837S) S ERRCOD=5_U_MOD837S Q   ; modifiers.
	. S IBLN=Z_$S(IBBNDL:U_OPROC,1:"")
	I 'IBLN,IBLN1 S IBLN=IBLN1
	;
FINDLNX	;
	Q IBLN
	;
GTPRCD(IBBNDL,OPROC,OREVCD,IBZREC)	; Set up the Procedure Code/Revenue Code fields.
	N CPT
	;
	I $P($G(^DGCR(399,IBIFN,0)),U,19)=3 D  Q   ; For UB-04s
	. S CPT=$P(IBZREC,U,2)                        ; proc from bill
	. I CPT'?.N,CPT'="" S CPT=$O(^ICPT("B",CPT,""))   ; non-numeric proc
	. S OPROC=$$PRCD^IBCEF1(+CPT_";ICPT(")            ; ext proc code
	. S OREVCD=+$P($G(^DGCR(399.2,+IBZREC,0)),U)  ; Rev cd from bill
	;
	; For CMS-1500s
	S CPT=$P(IBZREC,U,5)        ; proc from bill
	I CPT'?.N,CPT'="" S CPT=$O(^ICPT("B",CPT,""))   ; non-numeric proc
	S OPROC=$$PRCD^IBCEF1(+CPT_";ICPT(")            ; ext proc code
	Q
	;
MODMATCH(IB,MODLST,MOD837S)	; Match modifiers
	; IB = the list of modifiers iens from the bill, comma delimited
	; MODLST = the 4 '^' pieces of the reported modifiers
	;
	N MODOK,Q,Z0,IBMOD,MMOD
	S MODOK=1,MOD837S=""
	I $TR(IB,",")'="" F Q=1:1:$L(IB,",") S Z0=$P(IB,",",Q) I Z0'="" D
	. S IBMOD(Z0)=$G(IBMOD(Z0))+1
	. I '$L(MOD837S) S MOD837S=Z0 Q
	. S MOD837S=MOD837S_","_Z0
	I $TR(MODLST,U)="",$O(IBMOD(""))="" G MODQ ; No modifiers used
	;
	; No match if no VistA modifiers, but there are MRA modifiers
	I $TR(MODLST,U)'="",$O(IBMOD(""))="" S MODOK=0 G MODQ
	;
	; Evaluate each MRA modifier
	F Z0=1:1:4 D
	. S MMOD=$P(MODLST,U,Z0) Q:MMOD=""     ; individual MRA modifier
	. I '$D(IBMOD(MMOD)) Q                 ; not in array so just quit
	. S IBMOD(MMOD)=IBMOD(MMOD)-1          ; decrement array counter
	. I 'IBMOD(MMOD) KILL IBMOD(MMOD)      ; if 0, then kill array entry
	. Q
	;
	I $O(IBMOD(""))'="" S MODOK=0 ; All submitted mods not matched
MODQ	Q MODOK
	;
