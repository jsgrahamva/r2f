PRSAENT1	;HISC/MGD-Entitlement String ;10/19/04
	;;4.0;PAID;**96,130,135,138,141**;Sep 21, 1995;Build 3
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	Q
	;
HYBRID(IEN)	;
	;----------------------------------------------------------------------
	; The following code was added to address Public Law 
	; P.L. 107-135 which adds mandatory Saturday (SP/SQ) and Sunday 
	; (SA/SE) Premium Pay for all "Hybrid" title 38 employees.
	;
	; Input Vars:
	;  IEN - the ien number of the employee in the PAID EMPLOYEE (#450)
	;        file.
	;
	; Local Vars:
	;     C0 - the 0 node of the employee from the PAID EMPLOYEE (#450)
	;          file.
	; HYBRID - Is the employee a Hybrid that qualifies for Saturday and
	;          Sunday premium pay after the passing of Public Law
	;          P.L. 107-135.
	;          1 : Entitled to Saturday or Sunday Premium pay.
	;          0 : Not Entitled to Saturday or Sunday Premium pay.
	;  OCODE - The employee's OCCUPATION SERIES & TITLE code.
	;
	; Output: HYBRID
	; 
	;----------------------------------------------------------------------
	;
	N C0,HYBRID,OCODE,PREM
	S (HYBRID,PREM)=0
	;
	Q:'+IEN HYBRID  ; Quit if no IEN passed in.
	;
	S C0=$G(^PRSPC(IEN,0))
	Q:C0="" HYBRID  ; Quit if no 0 node in 450
	;
	S PREM=$P($G(^PRSPC(IEN,"PREMIUM")),U,6)
	I "^E^F^"[("^"_PREM_"^") S PREM=1
	;
	; Check for Pay Plan A and Type of Appointment 5 or 6
	I $P(C0,U,21)="A","^5^6^"[(U_$P(C0,U,43)_U),'PREM D
	.;Check Occupational Series Code and Title Code.
	. S OCODE=$P(C0,U,17)
	. Q:OCODE=""
	. ;
	. ; For any OCC codes applicable to Hybrid employees translate any
	. ; 6th position Alphas in the Title Code to its corresponding
	. ; numerical equivalent before making the final comparison.
	. ;
	. ;I "^0080^0081^0083^0085^0086^0301^0303^0350^3566^4805^7304^7305^"[$E(OCODE,1,4) D  ;PRS*4*138
	. ;. S $E(OCODE,6)=$TR($E(OCODE,6),"ABCDEFGHIJKLMNOPQR","123456789123456789")
	. ;I "^7404^7408^5406^4742^5415^5309^5402^5703^4801^5306^1046^1001^"[$E(OCODE,1,4) D  ;PRS*4*138
	. ;. S $E(OCODE,6)=$TR($E(OCODE,6),"ABCDEFGHIJKLMNOPQR","123456789123456789")
	. I "^0101^0180^0185^0601^0620^0621^0630^0631^0633^0635^0636^"[$E(OCODE,1,4) D  ;PRS*4*130 and PRS*4*138
	. . S $E(OCODE,6)=$TR($E(OCODE,6),"ABCDEFGHIJKLMNOPQR","123456789123456789")
	. I "^0640^0644^0647^0648^0649^0660^0661^0665^0667^"[$E(OCODE,1,4) D
	. . S $E(OCODE,6)=$TR($E(OCODE,6),"ABCDEFGHIJKLMNOPQR","123456789123456789")
	. I "^0669^0672^0675^0679^0681^0682^0685^"[$E(OCODE,1,4) D  ;PRS*4*135
	. . S $E(OCODE,6)=$TR($E(OCODE,6),"ABCDEFGHIJKLMNOPQR","123456789123456789")
	. ;
	. ; Check individual OCC codes
	. ;
	. ;I $E(OCODE,1,4)="0080" D       ; Security Officer
	. ;. I "^02^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="0081" D       ; Firefighter
	. ;. I "^03^04^05^07^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="0083" D       ; Detective
	. ;. I "^02^03^05^"[(U_$E(OCODE,5,6)_U) S HYBRID=1  ;PRS*4*138
	. ;I $E(OCODE,1,4)="0085" D       ; Security Guard
	. ;. I "^04^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="0086" D       ; Security Clerk
	. ;. I "^01^02^04^"[(U_$E(OCODE,5,6)_U) S HYBRID=1  ;PRS*4*138
	. ;I $E(OCODE,1,4)="0301" D       ; Patient Representative
	. ;. I "^68^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="0303" D       ; Medical Admin Assistant
	. ;. I "^03^04^16^19^45^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="0350" D       ; X-Ray Film Proc Equ
	. ;. I "^09^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. I $E(OCODE,1,4)="0101" D       ; Marriage Family Therapist, Licensed Mental Health Provider
	. . I "^06^17^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. I $E(OCODE,1,4)="0180" D       ; Psychologist
	. . I "^02^03^04^05^07^10^11^26^85^86^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. . I "^87^92^95^96^97^98^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0185" D       ; Social Worker
	. . I "^02^03^04^05^10^51^57^58^59^61^62^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. . I "^63^64^66^71^72^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0601" D       ; Registered Respiratory Therapist
	. . I "^22^23^25^31^43^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0601" D       ; Nuclear Med Technologist
	. . I "^08^13^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0601" D       ; Vist Coordinator
	. . I "^67^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*141
	. I $E(OCODE,1,4)="0601" D       ; Blind Rehab Specialist
	. . I "^68^69^71^72^73^74^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*141
	. I $E(OCODE,1,4)="0620" D       ; Vocational/Practical Nurse
	. . I "^01^02^03^04^05^06^12^13^14^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0621" D       ; Nursing Assistant
	. . I "^02^05^08^14^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0630" D       ; Dietitian
	. . I "^09^10^18^20^59^61^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0631" D       ; Occupational Therapist
	. . I "^04^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0633" D       ; Physical Therapist
	. . I "^02^15^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*141
	. I $E(OCODE,1,4)="0635" D       ; Corrective Therapist
	. . I "^02^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0636" D       ; Therapy Assistant
	. . I "^15^16^17^18^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0640" D       ;Certified Respiratory Therapy Tech
	. . I "^75^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0644" D       ; Medical Technologist
	. . I "^02^03^05^10^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0647" D       ; Diagnostic Radiologic
	. . I "^11^12^13^14^15^16^17^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. . I "^19^21^22^23^24^25^26^27^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0648" D       ; Therapeutic Radiologic
	. . I "^14^15^16^17^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0649" D       ; Medical Instrument Technician
	. . I "^15^16^17^18^19^21^22^23^24^25^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. . I "^27^28^32^33^34^35^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. . I "^36^37^38^39^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*141
	. I $E(OCODE,1,4)="0660" D       ; Pharmacist
	. . I "^02^03^04^05^08^09^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. . I "^10^13^15^20^21^41^50^70^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. . I "^16^17^18^19^81^82^83^84^86^87^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*141
	. I $E(OCODE,1,4)="0661" D       ; Pharmacy Aid/Technician
	. . I "^03^04^06^08^09^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0665" D       ; Audiologist/Speech
	. . I "^02^04^05^06^07^08^12^15^18^65^68^75^82^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0667" D       ; Orthotist
	. . I "^02^12^22^23^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0669" D       ; Medical Records Administration
	. . I "^03^04^05^07^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0672" D       ; Prosthetic
	. . I "^05^06^07^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0675" D       ; Medical Records Technician
	. . I "^01^02^04^05^06^07^08^09^11^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*130
	. I $E(OCODE,1,4)="0679" S HYBRID=1    ;Medical Support Assistant   ;PRS*4*135
	. I $E(OCODE,1,4)="0681" D       ; Dental Assistant
	. . I "^03^05^06^07^09^42^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0682" D       ; Dental Hygienist
	. . I "^02^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. I $E(OCODE,1,4)="0858" D       ; Biomedical Engineer
	. . I "^02^03^04^"[(U_$E(OCODE,5,6)_U) S HYBRID=1
	. ;I $E(OCODE,1,4)="3566" D       ; Housekeeping Aid
	. ;. I "^10^30^40^60^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="4805" D       ; Medical Equipment
	. ;. I "^10^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="7304" D       ; Laundry Worker
	. ;. I "^10^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="7305" D       ; Laundry Machine Operator
	. ;. I "^50^60^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="7404" D       ; Cook
	. ;. I "^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="7408" D       ; Food Service Worker
	. ;. I "^10^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="5406" D       ; Utility Systems Operator
	. ;. I "^30^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ;PRS*4*138
	. ;I $E(OCODE,1,4)="4742" S HYBRID=1     ; Utility Systems Operator ; PRS*4*138
	. ;I $E(OCODE,1,4)="5415" D       ; Air Conditioning Equipment Operator
	. ;. I "^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="5309" D       ; Boiler Plant Equipment Mechanic
	. ;. I "^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="5402" D       ; Boiler Plant Operator
	. ;. I "^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="5703" D       ; Motor Vehicle Operator
	. ;. I "^60^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="4801" S HYBRID=1     ; Lead Equipment Servicer ; PRS*4*138
	. ;I $E(OCODE,1,4)="5306" D       ; Air Conditioning Equipment Mechanic
	. ;. I "^20^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="1046" D       ; Clerk Translator
	. ;. I "^02^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	. ;I $E(OCODE,1,4)="1001" D       ; Interpreter
	. ;. I "^11^"[(U_$E(OCODE,5,6)_U) S HYBRID=1 ; PRS*4*138
	;
	Q HYBRID  ; Return whether or not the employee qualifies.
