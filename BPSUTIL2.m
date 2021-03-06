BPSUTIL2	;BHAM ISC/SS - General Utility functions ;08/01/2006
	;;1.0;E CLAIMS MGMT ENGINE;**7,8,10,11,17,19**;JUN 2004;Build 18
	;;Per VA Directive 6402, this routine should not be modified.
	;
	Q
	;
	;/**
	;Creates a new entry (or node for multiple with .01 field)
	;
	;BPFILE - file/subfile number
	;BPIEN - ien of the parent file entry in which the new subfile entry will be inserted
	;BPVAL01 - .01 value for the new entry
	;NEWRECNO -(optional) specify IEN if you want specific value
	; Note: "" then the system will assign the entry number itself.
	;BPFLGS - FLAGS parameter for UPDATE^DIE
	;LCKGL - fully specified global reference to lock
	;LCKTIME - time out for LOCK, if LOCKTIME=0 then the function will not lock the file 
	;BPNEWREC - optional, flag = if 1 then allow to create a new top level record 
	;Examples
	;top level:
	; D INSITEM(366.14,"",IBDATE,"")
	;to create with the specific ien
	; W $$INSITEM^BPSUTIL2(9002313.77,"",55555555,45555,,,,1)
	; 
	;1st level multiple:
	; subfile number = #366.141
	; parent file #366.14 entry number = 345
	; D INSITEM(366.141,345,"SUBMIT","")
	; to create multiple entry with particular entry number = 23
	; D INSITEM(366.141,345,"SUBMIT",23)
	;
	;2nd level multiple
	;parent file #366.14 entry number = 234
	;parent multiple entry number = 55
	;create multiple entry INSURANCE
	; D INSITEM(366.1412,"55,234","INS","")
	; results in :
	; ^IBCNR(366.14,234,1,55,5,0)=^366.1412PA^1^1
	; ^IBCNR(366.14,234,1,55,5,1,0)=INS
	; ^IBCNR(366.14,234,1,55,5,"B","INS",1)=
	;  (DD node for this multiple =5 ) 
	;  
	;output :
	; positive number - record # created
	; <=0 - failure
	;  See description above
INSITEM(BPFILE,BPIEN,BPVAL01,NEWRECNO,BPFLGS,LCKGL,LCKTIME,BPNEWREC)	;*/
	I ('$G(BPFILE)) Q "0^Invalid parameter"
	I +$G(BPNEWREC)=0 I $G(NEWRECNO)>0,'$G(BPIEN) Q "0^Invalid parameter"
	I $G(BPVAL01)="" Q "0^Null"
	N BPLOCK S BPLOCK=0
	;I '$G(BPFILE) Q -1
	;I '$G(BPVAL01) Q -1
	N BPSSI,BPIENS,BPFDA,BPERR
	I '$G(NEWRECNO) N NEWRECNO S NEWRECNO=$G(NEWRECNO)
	I BPIEN'="" S BPIENS="+1,"_BPIEN_"," I $L(NEWRECNO)>0 S BPSSI(1)=+NEWRECNO
	I BPIEN="" S BPIENS="+1," I $L(NEWRECNO)>0 S BPSSI(1)=+NEWRECNO
	S BPFDA(BPFILE,BPIENS,.01)=BPVAL01
	I $L($G(LCKGL)) L +@LCKGL:(+$G(LCKTIME)) S BPLOCK=$T I 'BPLOCK Q -2  ;lock failure
	D UPDATE^DIE($G(BPFLGS),"BPFDA","BPSSI","BPERR")
	I BPLOCK L -@LCKGL
	I $D(BPERR) D BMES^XPDUTL($G(BPERR("DIERR",1,"TEXT",1),"Update Error")) Q -1  ;D BMES^XPDUTL(BPERR("DIERR",1,"TEXT",1))
	Q +$G(BPSSI(1))
	;
	;fill fields
	;Input:
	;FILENO file number
	;FLDNO field number
	;RECIEN ien string 
	;NEWVAL new value to file (internal format)
	;Output:
	;0^ NEWVAL^error if failure
	;1^ NEWVAL if success
FILLFLDS(FILENO,FLDNO,RECIEN,NEWVAL)	;
	I '$G(FILENO) Q "0^Invalid parameter"
	I '$G(FLDNO) Q "0^Invalid parameter"
	I '$G(RECIEN) Q "0^Invalid parameter"
	I $G(NEWVAL)="" Q "0^Null"
	N RECIENS,FDA,ERRARR
	S RECIENS=RECIEN_","
	S FDA(FILENO,RECIENS,FLDNO)=NEWVAL
	D FILE^DIE("","FDA","ERRARR")
	I $D(ERRARR) Q "0^"_NEWVAL_"^"_ERRARR("DIERR",1,"TEXT",1)
	Q "1^"_NEWVAL
	;
	;API to return the GROUP INSURANCE PLAN associated with the
	;PRIMARY INSURANCE in the BPS TRANSACTION File
	;Input:
	;BPIEN59 = IEN of entry in BPS TRANSACTION File
	;Output:
	;IEN of GROUP INSURANCE PLAN file^INSURANCE COMPANY Name
GETPLN59(BPIEN59)	;
	N IENS,GRPNM
	S IENS=+$G(^BPST(BPIEN59,9))_","_BPIEN59_","
	S GRPNM=$$GET1^DIQ(9002313.59902,IENS,"PLAN ID:INSURANCE COMPANY")
	Q +$G(^BPST(BPIEN59,10,+$G(^BPST(BPIEN59,9)),0))_"^"_GRPNM
	;
GETPLN77(BPIEN77)	;
	N BPINSIEN,BPSINSUR,BPINSDAT
	I '$G(BPIEN77) Q 0
	S BPINSIEN=0
	;get the USED FOR THE REQUEST=1 (active) entry in the multiple
	S BPINSIEN=$O(^BPS(9002313.77,BPIEN77,5,"C",1,BPINSIEN))
	I +BPINSIEN=0 Q 0
	;get BPS IBNSURER DATA pointer
	S BPSINSUR=+$P($G(^BPS(9002313.77,BPIEN77,5,BPINSIEN,0)),U,3)
	I BPSINSUR=0 Q 0
	;get 0th node of the BPS INSURER DATA
	S BPINSDAT=$G(^BPS(9002313.78,BPSINSUR,0))
	I BPINSDAT="" Q 0
	Q $P(BPINSDAT,U,8)_"^"_$P(BPINSDAT,U,7)
	;
GETRQST(IEN59)	; Return the BPS Request IEN for a BPS Transaction record
	N BPTYPE,IEN77
	I '$G(IEN59) Q ""
	S BPTYPE=$$GET1^DIQ(9002313.59,IEN59,19,"I")
	; If reversal, return the Reversal Request field
	I BPTYPE="U" Q $$GET1^DIQ(9002313.59,IEN59,405,"I")
	; Otherwise, return the Submission Request field
	Q $$GET1^DIQ(9002313.59,IEN59,16,"I")
	;
	;Return the COB (payer sequence) by IEN of the BPS TRANSACTION file
COB59(BPSIEN59)	;
	;try to get it from 9002313.59, if it was not created yet then get it from IEN itself
	I '$G(BPSIEN59) Q ""
	Q $S($P($G(^BPST(BPSIEN59,0)),U,14):$P(^BPST(BPSIEN59,0),U,14),1:$E($P(BPSIEN59,".",2),5,5))
	;
	;Return the plan's COB (from PATIENT file) by IEN of the BPS TRANSACTION file and entry # 
PLANCOB(BPSIEN59,BPSENTRY)	;
	I +$G(BPSENTRY)=0 S BPSENTRY=1 ;the first entry by default
	Q $P($G(^BPST(BPSIEN59,10,BPSENTRY,3)),U,6)
	;
	;Return the IEN of BPS TRANSACTION file by IEN of BPS CLAIMS file
CLAIM59(BPS02)	;
	Q +$P($G(^BPSC(BPS02,0)),U,8)
	;
	;Return BPS TRANSACTIONS for associated primary and secondary claims
ALLCOB59(BP59)	;
	N BPSP,BPSS,BPRX,BPRXI,BPRXR
	S BPRX=$$RXREF^BPSSCRU2(BP59),BPRXI=$P(BPRX,U),BPRXR=$P(BPRX,U,2)
	S BPSP=$$IEN59^BPSOSRX(BPRXI,BPRXR,1),BPSS=$$IEN59^BPSOSRX(BPRXI,BPRXR,2)
	I '$D(^BPST(BPSP)) S BPSP=""
	I '$D(^BPST(BPSS)) S BPSS=""
	Q BPSP_"^"_BPSS
	;
	;input: BPS59 - ien of the BPS TRANSACTION file
	;returns three pieces:
	;COB  = Coordination Of Benefit indicator of the insurance as it is stored in (#.2) COB field of the (#.3121) insurance Type multiple of the Patient file (#2) 
	; 1- primary, 2 -secondary, 3 -tertiary
	;RXCOB =  the payer sequence indicator of the claim which was sent to the payer as a result of this call: 1- primary, 2 -secondary, 3 -tertiary
	;INSURANCE = Name of the insurance company that was billed as a result of this call
CLMINFO(BPS59)	;
	N RETV
	S $P(RETV,U,1)=$$PLANCOB(BPS59,1)
	S $P(RETV,U,2)=$$COB59(BPS59)
	S $P(RETV,U,3)=$$INSNAME^BPSSCRU6(BPS59)
	Q RETV
	;
	;to determine whether the secondary claim is payable 
	; BPSRIM59 - ien of PRIMARY claim in the BPS TRANSACTION
	;returns
	; 0 - the secondary claim doesn't exist
	; 0 - the secondary claim exists and it's not payable
	; 1 - the secondary claim exists and it's payable
PAYBLSEC(BPSRIM59)	;
	N BRXIEN,BFILL,BPSSTAT2,BPZ
	S BPZ=$$RXREF^BPSSCRU2(BPSRIM59)
	S BRXIEN=+BPZ
	S BFILL=+$P(BPZ,U,2)
	S BPSSTAT2=$P($$STATUS^BPSOSRX(BRXIEN,BFILL,0,,2),U,1)
	; check if the payer IS going to PAY according to the last response
	Q $$PAYABLE^BPSOSRX5(BPSSTAT2)
	;
	;to determine whether the primary claim is payable 
	; BPSSEC59 - ien of SECONDARY claim in the BPS TRANSACTION
	;returns
	; 0 - the primary claim doesn't exist
	; 0 - the primary claim exists and it's not payable
	; ien of 399 - the primary claim exists
PAYBLPRI(BPSSEC59)	;
	N BRXIEN,BFILL,BPSSTAT1,BPZ,BPZ1,BPSARR
	S BPZ=$$RXREF^BPSSCRU2(BPSSEC59)
	S BRXIEN=+BPZ
	S BFILL=+$P(BPZ,U,2)
	S BPSSTAT1=$P($$STATUS^BPSOSRX(BRXIEN,BFILL,0,,1),U,1)
	; check if the payer IS going to PAY according to the last response
	I +$$PAYABLE^BPSOSRX5(BPSSTAT1)=0 Q 0
	S BPZ=$$RXBILL^IBNCPUT3(BRXIEN,BFILL,"P","",.BPSARR)
	I +$P(BPZ,U,2)>0 Q +$P(BPZ,U,2)       ; latest bill in AR active status
	S BPZ1=+$O(BPSARR(999999999),-1)      ; latest bill in any status
	I BPZ1>0 Q BPZ1
	Q 0
	;
	;SLT - BPS*1.0*11
LASTDOS(BP59,FMT)	;last date of service from most recent claim
	; input:
	;   BP59 -> claim/transaction
	;   FMT  -> Date format indicator (0:MM/DD; 1:Mmm dd,yyyy)
	; output:
	;   Date of Service e.g. 06/01
	;
	N BPCLAIM,DOSDT,X,Y
	;
	I $G(FMT)="" S FMT=0
	S BPCLAIM=0,DOSDT=""
	I $D(^BPST(BP59,4)) S BPCLAIM=$P(^BPST(BP59,4),U)
	S:'BPCLAIM BPCLAIM=$P(^BPST(BP59,0),U,4)
	I BPCLAIM]"" D
	. S DOSDT=$$DOSCLM^BPSSCRLG(BPCLAIM)
	. S:FMT=0 DOSDT=$P(DOSDT,"/",1,2)
	. D:FMT=1
	. . S X=DOSDT D ^%DT
	. . I Y=-1 S DOSDT="" Q
	. . D DD^%DT S DOSDT=Y
	Q DOSDT
	;
	;Returns the latest Date Of Service for the FILL that matches the DOS the payer returns using 9002313.57
	;Both DOS and SUBMIT DATE from the payer are considered when matching
	;OUTPUT Variables
	; DOS - The latest DOS for the FILL that matches the date returned by the payer
	;INPUT Variables
	; ECME - ECME number (pointer to #52)
	; RCDATE - The DOS returned with the payment by the payer
	;
CLMECME(ECME,RCDATE)	;
	N ARY,BEFORE,BPSTL,DATE,DOS,FILL,SUBMIT
	I $G(ECME)=""!($G(RCDATE)="") Q ""
	S ECME=+$G(ECME),BEFORE=0,FILL=""
	S BPSTL="" F  S BPSTL=$O(^BPSTL("AEC",ECME,BPSTL)) Q:BPSTL=""  D  Q:BEFORE
	. I '$D(^BPSTL(BPSTL,0)) Q  ;Bad AEC entry
	. S SUBMIT=$P($P($G(^BPSTL(BPSTL,0)),U,7),"."),FILL=$P($G(^BPSTL(BPSTL,1)),U,1),DOS=$P($G(^BPSTL(BPSTL,12)),U,2)
	. I FILL=""!(DOS="") Q
	. I RCDATE<DOS S BEFORE=1 Q  ;Quit when you get to a date that is earlier than the payment date
	. S ARY("D",DOS,FILL)="",ARY("F",FILL,DOS)=""  ;Fill arrays
	. I SUBMIT,SUBMIT'=DOS S ARY("D",SUBMIT,FILL)="",ARY("F",FILL,SUBMIT)=""  ;If the submit date is different than the DOS, include array entries for it
	I '$D(ARY) Q ""  ;There were no entries in the array
	I $D(ARY("D",RCDATE)) S FILL=$O(ARY("D",RCDATE,""),-1) ;Get the fill for the matching date
	I FILL="" Q ""  ;No matching date
	Q $O(ARY("F",FILL,""),-1)  ;Return the last date for the correct fill
	;
VALECME(ECMENUM)	; Validates the ECME Number 
	; Input: ECMENUM - ECME Number to be validated
	;Output: 1: Valid ECME Number / 0: Invalid ECME Number
	;
	N NUMVAL
	S NUMVAL=+$G(ECMENUM) I 'NUMVAL!$L(NUMVAL)>12 Q 0
	Q ($D(^BPSTL("AEC",NUMVAL))>0)
