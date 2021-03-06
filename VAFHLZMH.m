VAFHLZMH	;BAY/JAT,PJH - Create HL7 Military History seg. (ZMH) ; 8/14/09 3:14pm
	;;5.3;Registration;**190,314,673,797**;Aug 13, 1993;Build 24
	;
	; This routine creates HL7 VA-specific Military History ("ZMH") segments
	Q
	;
EN(DFN,VAFHMIEN,VAFSTR)	; RAI/MDS Reserved entry point!!
	; !!!!!!!!!! don't enter here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;DFN - Patient Internal Entry Number
	;VAFHMIEN - Patient Movement Internal Entry Number
	;VAFSTR - Sequence numbers to be included
	;
	N VAFHLREC,VAFHA,VAFHSUB,VAFHADD,VAFHLOC S VAFHSUB="" ;Initialize variables
	S $P(VAFHLREC,HL("FS"))="ZMH" ;Set segment ID to ZMH
	S $P(VAFHLREC,HL("FS"),2)=1 ;Set Set ID to 1
	I VAFSTR[",4," D
	.N EDATE,SDATE
	.I '$D(^DPT(DFN,.3216)) D
	..S EDATE=$$HLDATE^HLFNC($$GET1^DIQ(2,DFN,".326","I"))
	..S SDATE=$$HLDATE^HLFNC($$GET1^DIQ(2,DFN,".327","I"))
	.E  D MSDSD
	.S $P(VAFHLREC,HL("FS"),5)=EDATE_$E(HL("ECH"))_SDATE
	Q VAFHLREC ;Quit and return formatted segment
	;
MSDSD	;Returns last service separation date from ESR sourced data 
	N DA,DONE,EDATA
	S EDATE="",SDATE="",DONE=0
	F  S EDATE=$O(^DPT(DFN,.3216,"B",""),-1) Q:'EDATE  D  Q:DONE
	.S DA=$O(^DPT(DFN,.3216,"B",EDATE,0)) Q:'DA
	.S EDATA=$G(^DPT(DFN,.3216,DA,0)) Q:EDATA=""
	.S DONE=1
	;
	Q:'DONE
	S EDATE=$$HLDATE^HLFNC(EDATE)
	S SDATE=$$HLDATE^HLFNC($P(EDATA,U,2))
	Q
	;
ENTER(DFN,VAFARRAY,VAFTYPE,VAFSTR,VAFHLS,VAFHLC,VAFHLQ)	      ;
	; DFN is the only required parameter.  Defaults are used if no
	; values are passed for the other parameters.
	; Output:
	; VAFARRAY = array name to hold the "ZMH" segments.
	;            Default is ^TMP("VAFHLZMH",$J)
	; Input:
	; DFN = internal entry number (IEN) of Patient (#2) file
	; VAFTYPE = Military History type desired (separated by commas) where
	;            1=Last Service branch (SL)
	;            2=Next to last Service branch (SNL)
	;            3=Next to next to last Service branch (SNNL)
	;            4=Prisoner of War Status indicated? (POW)
	;            5=Combat Service indicated? (COMB)
	;            6=Vietnam Service indicated? (VIET)
	;            7=Lebanon Service indicated? (LEBA)
	;            8=Grenada Service indicated? (GREN)
	;            9=Panama Service indicated? (PANA)
	;           10=Persian Gulf Service indicated? (GULF)
	;           11=Somalia Service indicated? (SOMA)    
	;           12=Yugoslavia Service indicated? (YUGO)
	;           13=Purple Heart Receipient? (PH)
	;           14=Operation Enduring/Iraqi Freedom (OEIF)
	;          A range of numbers separated by colons can be sent 
	;                  (e.g. 1:4,8,10:12) 
	;          Default is all(1,2,3...)
	;
	;          OR  
	;
	;          If value '*' is passed into the routine then the default 
	;          is to return all military history and all military service
	;          episodes for the vet. Rather than using SL, SNL AND SNNL
	;          the ZMH type will be 'MSD'.
	;
	;
	; VAFSTR = Fields (sequence numbers) desired (separated by comma) where
	;          3=qualifier #1 (Service branch if VAFTYPE is 1,2 or 3
	;                         or Yes/No response if VAFTYPE is 4 thru 13)
	;            qualifier #2 (Service number if VAFTYPE is 1,2 or 3
	;                         or Location if VAFTYPE is 4 or 5)
	;                         or 
	;            qualifier #3 (Service discharge type if VAFTYPE is 1,2
	;                          or 3)
	;          4=From/To Date range for each VAFTYPE
	;          5=Service Component
	;          Default is 3,4,5
	; VAFHLS = HL7 field separator (1 character)
	;          Default is ^ (carrot)
	; VAFHLC = HL7 encoding characters (4 characters must be supplied)
	;          Default is ~|\& (tilde bar backslash ampersand)
	; VAFHLQ = HL7 null designation 
	;          Default is "" (quote quote)
	; 
	; Check input and apply default values as needed
	S VAFARRAY=$G(VAFARRAY) I VAFARRAY="" S VAFARRAY=$NA(^TMP("VAFHLZMH",$J))
	K @VAFARRAY
	S VAFTYPE=$G(VAFTYPE)
	I VAFTYPE="" S VAFTYPE="1,2,3,4,5,6,7,8,9,10,11,12,13,14"
	S VAFSTR=$G(VAFSTR) I VAFSTR="" S VAFSTR="3,4,5"
	S VAFHLS=$G(VAFHLS) I VAFHLS="" S VAFHLS="^"
	S:($L(VAFHLS)'=1) VAFHLS="^"
	S VAFHLC=$G(VAFHLC) I VAFHLC="" S VAFHLC="~|\&"
	S:($L(VAFHLC)'=4) VAFHLC="~|\&"
	S:('$D(VAFHLQ)) VAFHLQ=$C(34,34)
	I '$G(DFN) D NOGO Q
	I '$D(^DPT(DFN,0)) D NOGO Q
	S VAFSTR=$TR(VAFSTR,":",",")
	I VAFSTR'=3,VAFSTR'=4,VAFSTR'=5,VAFSTR'="3,4",VAFSTR'="3,5",VAFSTR'="4,5",VAFSTR'="3,4,5" D NOGO Q
	S VAFSTR=","_VAFSTR_","
	I VAFTYPE="*" S VAFTYPE="*,4,5,6,7,8,9,10,11,12,13,14"
	E  I '$$EDIT(VAFTYPE) D NOGO Q
	I VAFTYPE[":" D UNCRUNCH
	; it's a Go
	N VAFY,VAFX,VAFZ,VAFINDX,VAFTAG
	S VAFINDX=0
	; set all the Patient file nodes that may be needed
	N VAF32N,VAF321N,VAF322N,VAF52N,VAF53N,VAF3291N
	S VAF321N=$G(^DPT(DFN,.321)) ; used for Vietnam
	S VAF322N=$G(^DPT(DFN,.322)) ; used for minor skirmishes
	S VAF52N=$G(^DPT(DFN,.52)) ; used for POW and Combat
	S VAF53N=$G(^DPT(DFN,.53)) ;used for Purple Heart
	I '$D(^DPT(DFN,.3216)) D
	.S VAF32N=$G(^DPT(DFN,.32)) ; used for Service branches
	.S VAF3291N=$G(^DPT(DFN,.3291)) ;used for service component
	I $D(^DPT(DFN,.3216)),VAFTYPE'["*" D MSDS
	;used for Operation Enduring/Iraqi Freedom
	N VAFOPS,VAFREC,VAFSUB
	S (VAFREC,VAFSUB)=0
	;set operations into local array since there may be mult OEIF episodes
	F  S VAFREC=$O(^DPT(DFN,.3215,VAFREC)) Q:'$G(VAFREC)  D
	. S VAFSUB=VAFSUB+1
	. S VAFOPS(VAFSUB)=$G(^DPT(DFN,.3215,VAFREC,0))
	;
	D ENTER^VAFHLZM1
	;
	Q
	;
MSDS	;Returns latest service episodes from ESR sourced data
	;
	;*** the number of episodes is unlimited ****
	;
	N BRANCH,COUNT,COMP,DA,DONE,DTYP,EDATA,EDATE,SDATE,SERVNO,SUB
	S COUNT=0,EDATE="",VAF32N="",VAF3291N=""
	;Scan back for three most recent service episodes
	F  S EDATE=$O(^DPT(DFN,.3216,"B",EDATE),-1) Q:'EDATE  D  Q:COUNT'<3
	.S DA=$O(^DPT(DFN,.3216,"B",EDATE,0)) Q:'DA
	.S EDATA=$G(^DPT(DFN,.3216,DA,0)) Q:EDATA=""
	.S COUNT=COUNT+1,SDATE=$P(EDATA,U,2)
	.S BRANCH=$P(EDATA,U,3),COMP=$P(EDATA,U,4)
	.S SERVNO=$P(EDATA,U,5),DTYP=$P(EDATA,U,6)
	.;SL = 4, SNL = 9 or SNNL = 14
	.S SUB=(COUNT*5)-1
	.S $P(VAF32N,U,SUB)=DTYP
	.S $P(VAF32N,U,SUB+1)=BRANCH
	.S $P(VAF32N,U,SUB+2)=EDATE
	.S $P(VAF32N,U,SUB+3)=SDATE
	.S $P(VAF32N,U,SUB+4)=SERVNO
	.S $P(VAF3291N,U,COUNT)=COMP
	Q
	;
EDIT(X)	 ; function validates VAFTYP (returns 1 if valid)        
	N P,Q,R,CNT,Z,Z1,Z2,ERR S ERR=0
	S X=$G(X)
	I X>0,X<15,X?.N Q 1 ; only 1 number and between 1-14
	I X'[":",X'["," Q 0 ; comma not used as separator
	I X'?.NP Q 0 ; contains letters or control characters
	; contains punctuation other than comma/colon
	S P="!#$%&'()*+-./;<=>?@[\]^_`{|]~"
	F CNT=1:1 S Z=$E(X,CNT) Q:Z=""  I P[Z S ERR=1 Q
	I ERR=1 Q 0
	S Q="",R=""""
	I Q[X!R[X Q 0
	; checks that numbers are >0<15
	F CNT=1:1 S Z=$P(X,",",CNT) Q:Z=""  D
	.I Z'[":",Z>0,Z<15 Q
	.S Z1=$P(Z,":",1),Z2=$P(Z,":",2)
	.I Z1>0,Z1<15,Z2>0,Z2<15 Q
	.S ERR=1
	I ERR=1 Q 0
	Q 1
	;
UNCRUNCH	; reformat VAFTYPE by translating any range of numbers,
	; for example replace "1:3,6,9:11" by "1,2,3,6,9,10,11,"
	N X,Y,Z,A,B S Y=""
	F X=1:1 S Z=$P(VAFTYPE,",",X) Q:Z=""  D
	.I Z'[":" S Y=Y_Z_"," Q
	.S A=$P(Z,":",1),B=$P(Z,":",2)
	.S Y=Y_A_","
	.F  S A=A+1 Q:A>B  S Y=Y_A_","
	S VAFTYPE=Y
	Q
NOGO	;
	S @VAFARRAY@(1,0)="ZMH"_VAFHLS_1
	Q
