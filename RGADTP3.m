RGADTP3	;BIR/CMC-RGADTP2 - CONTINUED ;21 May 2015  5:10 PM
	;;1.0;CLINICAL INFO RESOURCE NETWORK;**48,59,63**;30 Apr 99;Build 1
	;
	;MOVED CHKPVT AND DIFF FROM RGADTP2 DUE TO ROUTINE SIZE ISSUE
	Q
CHKPVT(ARRAY)	;CHECKS TO SEE IF OUTSTANDING IDENTITY EDIT IS WAITING TO BE SENT IN THE ADT/HL7 PIVOT FILE
	;**44 CREATED - ARRAY CONTAINS THE ARRAY ELEMENTS NEEDED TO FIND THE PATIENT IN THE ADT/HL7 PIVOT FILE
	;RETURNED IS -1^EDIT PENDING IN PIVOT FILE OR 0 IF THERE ISN'T ONE
	I '$D(^VAT(391.71,"C",ARRAY("DFN"))) Q 0
	N PIV,FIELDS
	S PIV=$O(^VAT(391.71,"C",ARRAY("DFN"),"A"),-1) ;get last entry in the pivot file for this patient
	I '$D(^VAT(391.71,"AXMIT",4,PIV))&('$D(^VAT(391.71,"AXMIT",3,PIV))) Q 0
	S FIELDS=$$GET1^DIQ(391.71,PIV_",",2.1,"I")
	I FIELDS[".01;"!(FIELDS[".02;")!(FIELDS[".03;")!(FIELDS[".09;")!(FIELDS[".0906;")!(FIELDS[".2403;")!(FIELDS["994;") Q "-1^DFN "_ARRAY("DFN")_":  Edits made to identity fields waiting to come to MPI, MPI update not processed as of yet."
	Q 0
	;
DIFF(ARRAY,RGRSDFN,DR,ARAY)	; are there fields to update? **47
	N NAME,SSN,PDOB,SEX,SID,MMN,OLDNAME,OLDHLNAM,OLDMMN,OLDHLMMN,HLNAME,HLMMN,SSNV,MBI,PSNR
	S DR="",NAME=$$GET1^DIQ(2,+RGRSDFN_",",.01,"I"),HLNAME=ARRAY("NAME")
	;**48 remove name standardization check
	;D STDNAME^XLFNAME(.NAME,"F",.OLDNAME) S HLNAME=ARRAY("NAME") D STDNAME^XLFNAME(.HLNAME,"F",.OLDHLNAM)
	I NAME'=$G(HLNAME) S DR=DR_".01;",ARAY(2,.01)=ARRAY("NAME")
	S PDOB=$$GET1^DIQ(2,+RGRSDFN_",",.03,"I") I PDOB'=ARRAY("MPIDOB") S DR=DR_".03;",ARAY(2,.03)=ARRAY("MPIDOB")
	S SSN=$$GET1^DIQ(2,+RGRSDFN_",",.09,"I") D
	.I SSN["P",ARRAY("SSN")=""!(ARRAY("SSN")="@") Q
	.; ^ treat pseudos and null/@ as the same
	.; **47 if incoming SSN value is null/@ and existing SSN isn't a pseudo create a new pseudo SSN
	.I SSN'["P" I ARRAY("SSN")="@"!(ARRAY("SSN")="") S ARRAY("SSN")="P"
	.I SSN'=ARRAY("SSN"),ARRAY("SSN")'="" S DR=DR_".09;",ARAY(2,.09)=ARRAY("SSN")
	S SEX=$$GET1^DIQ(2,+RGRSDFN_",",.02,"I") D
	.I SEX=""&(ARRAY("SEX")="@") Q
	.; ^ treat null and @ as same
	.I SEX'=ARRAY("SEX") S DR=DR_".02;",ARAY(2,.02)=ARRAY("SEX")
	;**63 Story 174247: Self-ID Gender
	S SID=$$GET1^DIQ(2,+RGRSDFN_",",.024,"I") D
	.I SID="",$G(ARRAY(.024))="@" Q
	.I SID'=$G(ARRAY(.024)) S DR=DR_".024;",ARAY(2,.024)=$G(ARRAY(".024"))
	S SSNV=$$GET1^DIQ(2,+RGRSDFN_",",.0907,"I") I SSNV="" S SSNV="@"
	;if SSN VERIFICATION STATUS field has been added to the DD then attempt to set it
	N ERROR,LABEL D FIELD^DID(2,.0907,"","LABEL","LABEL","ERROR") I '$D(ERROR("DIERR"))&$D(LABEL("LABEL")) D
	.I SSNV'=ARRAY(.0907) S ARAY(2,.0907)=$G(ARRAY(.0907)),DR=DR_".0907;"
	S PSNR=$$GET1^DIQ(2,+RGRSDFN_",",.0906,"I") I PSNR="" S PSNR="@"
	;if Pseudo SSN Reason field has been added to the DD then attempt to set it
	N ERROR,LABEL D FIELD^DID(2,.0906,"","LABEL","LABEL","ERROR") I '$D(ERROR("DIERR"))&$D(LABEL("LABEL")) D
	.I PSNR'=ARRAY(.0906) S ARAY(2,.0906)=$G(ARRAY(.0906)),DR=DR_".0906;"
	; **59, MVI_881 start
	; S MBI=$$GET1^DIQ(2,+RGRSDFN_",",994,"I") I MBI="" S MBI="@"
	; I MBI="@"&(ARRAY("MBI")="") Q
	; ^ treat @ and null as the same
	; I MBI'=ARRAY("MBI") S DR=DR_"994;",ARAY(2,994)=ARRAY("MBI")
	; S MMN=$$GET1^DIQ(2,+RGRSDFN_",",.2403,"I") I MMN="" S MMN="@"
	; D STDNAME^XLFNAME(.MMN,"F",.OLDMMN) S HLMMN=ARRAY("MMN") D STDNAME^XLFNAME(.HLMMN,"F",.OLDHLMMN)
	; I MMN="@"&($G(HLMMN)="") Q
	; ^ treat @ and null as same
	; I MMN'=$G(HLMMN) S DR=DR_".2403;",ARAY(2,.2403)=ARRAY("MMN")
	I $G(ARRAY("MBI"))'="" D
	. S MBI=$$GET1^DIQ(2,+RGRSDFN_",",994,"I") S:MBI="" MBI="@"
	. ; ^ treat @ and null as the same
	. I MBI'=ARRAY("MBI") S DR=DR_"994;",ARAY(2,994)=ARRAY("MBI")
	S HLMMN=$G(ARRAY("MMN"))
	I HLMMN'="" D
	. S MMN=$$GET1^DIQ(2,+RGRSDFN_",",.2403,"I") S:MMN="" MMN="@"
	. I MMN'="@" D STDNAME^XLFNAME(.MMN,"F",.OLDMMN)
	. I HLMMN'="@" D STDNAME^XLFNAME(.HLMMN,"F",.OLDHLMMN)
	. ; ^ treat @ and null as same
	. I MMN'=HLMMN S DR=DR_".2403;",ARAY(2,.2403)=ARRAY("MMN")
	; update TIN and FIN fields
	N TIN,FIN
	I $G(ARRAY("TIN"))'="" D
	. S TIN=$$GET1^DIQ(2,+RGRSDFN_",",991.08,"I") S:TIN="" TIN="@"
	. I TIN'=ARRAY("TIN") S DR=DR_"991.08;",ARAY(2,991.08)=ARRAY("TIN")
	I $G(ARRAY("FIN"))'="" D
	. S FIN=$$GET1^DIQ(2,+RGRSDFN_",",991.09,"I") S:FIN="" FIN="@"
	. I FIN'=ARRAY("FIN") S DR=DR_"991.09;",ARAY(2,991.09)=ARRAY("FIN")
	; **59, MVI_881 end
	I $D(ARRAY("ALIAS")) S DR=DR_"1;"
	Q
