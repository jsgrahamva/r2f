VAFCTFU3	;BHM/RGY-Utilities for the Treating Facility file 391.91, CONTINUED ; 5/2/13
	;;5.3;Registration;**863**;Aug 13, 1993;Build 2
TFL(LIST,DFN)	;for dfn get list of treating facilities 
	;NO SCREENS, to include ALL TF entries, including entries without DFN
	;cloned from VAFCTFU1
	NEW X,ICN,DA,DR,VAFCTFU3,DIC,DIQ,VAFC
	S X="MPIF001" X ^%ZOSF("TEST") I '$T S LIST(1)="-1^MPI Not Installed" Q
	S DR=".01;13;99",DIC=4,DIQ(0)="E",DIQ="VAFCTFU3" ;**448
	S ICN=$$GETICN^MPIF001(DFN)
	I ICN<0 S LIST(1)=ICN Q
	S X=$$QUERYTF($P(ICN,"V"),"LIST",0)
	I $P(X,U)="1" S LIST(1)="-1"_U_$P(X,U,2) Q
	F VAFC=0:0 S VAFC=$O(LIST(VAFC)) Q:VAFC=""  D
	.K VAFCTFU3
	.S DA=+LIST(VAFC)
	.D EN^DIQ1
	.S LIST(VAFC)=VAFCTFU3(4,+LIST(VAFC),99,"E")_"^"_VAFCTFU3(4,+LIST(VAFC),.01,"E")_"^"_$P(LIST(VAFC),"^",2)_"^"_$P(LIST(VAFC),"^",3)_"^"_VAFCTFU3(4,+LIST(VAFC),13,"E") ;**448
	.Q
	Q
	;
SET(TFIEN,ARY,CTR)	;This sets the array with the treating facility list.
	; Returns: treating facility ^ treatment date ^ event reason (if any)
	; *261 gjc@120899 (formerly part of VAFCTFU prior to DG*5.3*261)
	N DGCN,INSTIEN,LSTA S DGCN(0)=$G(^DGCN(391.91,TFIEN,0))
	S INSTIEN=$P($G(DGCN(0)),"^",2),LSTA=$$STA^XUAF4(INSTIEN)
	S CTR=CTR+1,@ARY@(CTR)=$P(DGCN(0),U,2,3)_U_$P(DGCN(0),U,7)
	Q
	;
QUERYTF(PAT,ARY,INDX)	;a query for Treating Facility.
	;INPUT   PAT - The patient's ICN
	;        ARY - The array in which to return the Treating facility info.
	;        INDX (optional) - the index to $O through.  APAT for patient
	;        information linked to treating facilities, AEVN for patient
	;        info linked with an event reason.  INDX=1 if AEVN is used,
	;        else APAT is used. *261 gjc@120399
	;
	;OUTPUT  A list of the Treating Facilities in the array provided from
	;        the parameter.  It will be in the structure of x(1), x(2) etc.
	;  Ex  X(1)=500^2960101^ptr to ADT/HL7 Event Reason file (if exists)
	;    Where the first piece is the IEN of the institution, the second
	;    piece is the current date on record for that institution and the
	;    third piece is the event reason (if it exists).  Note: A04 & A08
	;    events do not file an event reason when adding to the TREATING
	;    FACILITY LIST (#391.91) file, thus returning null in the third
	;    piece. *261 gjc@120199
	;
	;    This is also a function call.  If there is an error then a 
	;    1^error description will be returned. 
	;
	;  *** If no data is found the array will not be populated and
	;  a 1^error description will be returned.
	;
	N PDFN,VAFCER,LP,CTR,ZTFIEN,ZDLT,ZTDLT
	I '$G(PAT)!('$D(ARY)) S VAFCER="1^Parameter missing." G QUERYTFQ
	S VAFCER=0,CTR=0,INDX=$G(INDX)
	S X="MPIF001" X ^%ZOSF("TEST") I '$T G QUERYTFQ
	S PDFN=$$GETDFN^MPIF001(PAT)
	I PDFN<0 S VAFCER="1^No patient DFN." G QUERYTFQ
	; determine the index to $O through, based on the value of INDX
	;I 'INDX F LP=0:0 S LP=$O(^DGCN(391.91,"APAT",PDFN,LP)) Q:'LP  S TFIEN=$O(^(LP,"")) D SET(TFIEN,ARY,.CTR)
	;**856 - MVI 1371 (ckn)
	;Now that Treating Facility file can have multiple entries for
	;one site, enhanced the code to loop through all TFIENs for each SITE
	;and return the record which have latest Date Last Treated. If none
	;of the entries have DLT populated, return the first record for site.
	I 'INDX F LP=0:0 S LP=$O(^DGCN(391.91,"APAT",PDFN,LP)) Q:'LP  D
	.S ZTDLT=0,ZTFIEN=$O(^DGCN(391.91,"APAT",PDFN,LP,"")) Q:'ZTFIEN
	.S TFIEN=0 F  S TFIEN=$O(^DGCN(391.91,"APAT",PDFN,LP,TFIEN)) Q:'TFIEN  D
	..S ZDLT=$P(^DGCN(391.91,TFIEN,0),"^",3) ;Date last treated
	..I ZDLT>ZTDLT S ZTDLT=ZDLT,ZTFIEN=TFIEN
	.D SET(ZTFIEN,ARY,.CTR)
	I INDX S LP=0 F  S LP=$O(^DGCN(391.91,"AEVN",PDFN,LP)) Q:'LP  D
	.; please note the following: the AEVN xref is subscripted by pat. dfn
	.; event reason ptr, and the ien of the TFL file.  It is possible
	.; that a patient may have numerous admission/discharges at different
	.; treating facilities, thus the looping through the TFIEN (TFL ien)
	.; subscript. *261 gjc@120399
	.S TFIEN=0 F  S TFIEN=$O(^DGCN(391.91,"AEVN",PDFN,LP,TFIEN)) Q:'TFIEN  D SET(TFIEN,ARY,.CTR)
	.Q
	I $D(@ARY)'>9 S VAFCER="1^Could not find Treating Facilities"
QUERYTFQ	Q VAFCER
