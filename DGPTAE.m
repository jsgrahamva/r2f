DGPTAE	;ALB/MTC,HIOFO/FT - Austin Edit Checks Driver ;4/8/15 11:23am
	;;5.3;Registration;**58,415,884**;Aug 13, 1993;Build 31
	;
	; VALM APIs - #10118
	;
	; Check for 101, 501, 701; Route processing by type; call DRG and output routine
EN	;
	N DGPTERP,DGPTERC,DGPRS,DGPTEDFL,DGPTNOW,DGPTFAC
	S (DGPTEDFL,DGPTERP)=0,DGPRS="N101^N501^N601^N701^N702^N703^N401^N402^N403^N535^"
	D NOW^%DTC S DGPTNOW=+X
	;-- check if record available to process
	I '$D(^TMP("AEDIT")) G EXIT
	;-- check if all nodes are present
	S DGPTERC=$$PRES() I DGPTERC D WRTERR(DGPTERC,"N101",1) G EXIT
	;-- process record
	D ALLPR
	;-- if errors
	D ERROR
	;-- exit
	D EXIT
	Q
	;
ALLPR	;-- process all records types
	N ERROR,NODE,SEQ
	S ERROR=0
	;
	D FAC
	;
	S NODE="" F  S NODE=$O(^TMP("AEDIT",$J,NODE)) Q:NODE=""!(ERROR)  D
	. S SEQ=0 F  S SEQ=$O(^TMP("AEDIT",$J,NODE,SEQ)) Q:SEQ=""  D RTE
	;
	Q
	;
EXIT	;-- clean-up
	K ^TMP("AEDIT",$J),^TMP("AERROR",$J),^TMP("AD",$J)
	K DGPTDTS,DGPTPS,DGPTSSN,DGPTDTA,DGPTFAC,DGPTLN,DGPTFI,DGPTMI
	K DGPTSRA,DGPTTF,DGPTSRP,DGPTPOW,DGPTMRS,DGPTGEN,DGPTDOB,DGPTPOS1,DGPTPOS2,DGPTEXA,DGPTEXI,DGPTSTE,DGPTCTY,DGPTZIP,DGPTMTC,DGPTBY,DGPTINC
	K DGPTDDTD,DGPTDDS,DGPTDSP,DGPTDTY,DGPTDOP,DGPTDVA,DGPTDPD,DGPTDRF,DGPTDAS,DGPTDCP,DGPTDDXE,DGPTDDXO,DGPTDLR,DGPTDLC,DGPTDSC
	K DGPT70LG,DGPT70SU,DGPT70DR,DGPT70X4,DGPTDXV1,DGPTDXV2,DGPT70AO,DGPT70COMVET,DGPT70ETHNIC,DGPT70HNC,DGPT70IR,DGPT70MST,DGPTTOD,DGPTDOD
	K DGPTMSR,DGPTMSC,DGPTMLD,DGPTMPD,DGPTMSI,DGPTMD1,DGPTMD11,DGPTMD2,DGPTMD3,DGPTMD4,DGPTMD5,DGPTMXX,DGPTMLR,DGPTMLC,DGPTMBS
	K DGPTMLG,DGPTMSU,DGPTMDG,DGPTMXIV,DGPTMXV1,DGPTMXV2,DGPT50SR,DGPT70RACE,DGPT70RACE1,DGPT70RACE2,DGPT70RACE3,DGPT70RACE4,DGPT70RACE5,DGPT70RACE6
	K DGACNT,DGPT7X51,DGPT7X52,DGPTADT,DGPTAGE,DGPTAL7,DGPTBYR,DGPTDIA,DGPTDIA1,DGPTDIA2,DGPTDIAR,DGPTELP,DGPTFEF,DGPTFMDB,DGPTGEN1,DGPTL3,DGPTL4,DGPTMSX,DGPTS1,DGPTS2,DGPTSTTY,DGPTTY,DGPTXTTY,DGSCDT,DGPTPRAR,DGPTOPAR,DGSCDT,DGPTOC
	K DGFNUM,DGLAST,DGMVT,DGOUT,DGPTF,DGPTOPP,DGSCDT,DGSPEC,DGLAST,DGFNUM,DGPT70SHAD,DGPT70SWA,DGPT70TSC,DGPTOD,DGPTDXLSPOA,DGPTGD1
	K DGPTMPOA1,DGPTMPOA10,DGPTMPOA11,DGPTMPOA12,DGPTMPOA13,DGPTMPOA14,DGPTMPOA15,DGPTMPOA16,DGPTMPOA17,DGPTMPOA18,DGPTMPOA19,DGPTMPOA2
	K DGPTMPOA20,DGPTMPOA21,DGPTMPOA22,DGPTMPOA23,DGPTMPOA24,DGPTMPOA25,DGPTMPOA3,DGPTMPOA4,DGPTMPOA5,DGPTMPOA6,DGPTMPOA7,DGPTMPOA8,DGPTMPOA9
	Q
	;
RTE	;route processing
	N DGFL2,I,J
	S DGFL2=0 F I=1:1:10 S:NODE=$P(DGPRS,U,I) DGFL2=1 Q:(DGFL2)!($P(DGPRS,U,I)']"")
	I 'DGFL2 S ERROR=101 Q
	Q:NODE="N701"
	;
	D @("^DGPT"_$S($E(NODE,2)=4:"401",1:$E(NODE,2,4)))
RTN	;
	Q
	;
PRES()	;-- check if required pieces are present
	N I,ERROR
	S ERROR=0
	F I="N101","N501","N701" I '$D(^TMP("AEDIT",$J,I)) S ERROR=188 Q
	Q ERROR
	;
WRTERR(ERROR,NODE,SEQ)	;-- This function will write out errors to the ^TMP("AERROR"
	; global.
	;  INPUT :  ERROR - code of Austin's error
	;           NODE  - node error occurred on
	;           SEQ   - sequence in ^TMP("AEDIT",
	;
	I '$D(ERROR) G WRTQ
	S DGPTERP=DGPTERP+1,^TMP("AERROR",$J,SEQ,NODE,DGPTERP)=ERROR
	I DGPTERP>12 S DGPTEDFL=1
WRTQ	Q
	;
FAC	;-- check facility id; get station type
	N SUFFIX,SOA,STATION,STTY
	S DGPTSTTY="",X=$G(^TMP("AEDIT",$J,"N101",1)),DGPTFAC=$E(X,25,30),SUFFIX=$E(X,29,30),SOA=$E(X,45,46)
	I SOA="  " D WRTERR(107) G FACQ
	I DGPTFAC'="      ",'DGPTFAC D WRTERR(108,"101") G FACQ
	I SUFFIX]"" I $D(^DIC(45.81,"D1",SUFFIX)) S DGPTSTTY=$O(^(SUFFIX,0)) S:DGPTSTTY DGPTSTTY=U_DGPTSTTY_U
	S X=$O(^DIC(45.1,"B",$E(X,45,46),0))
	S STATION="",STTY=0 F  S STTY=$O(^DIC(45.1,X,"ST",STTY)) Q:'STTY  S STATION=STATION_"^"_STTY
	S STATION=STATION_"^"
	I $P(DGPTSTTY,U,2),STATION'[DGPTSTTY D WRTERR(135,"101") G FACQ
	S DGPTSTTY=STATION
FACQ	Q
	;
ERROR	;-- this routine will process the error detected during close-out
	G:'$D(^TMP("AERROR",$J)) ERRQ
	S DGERR=1
	D EN^VALM("DGPT CLOSE-OUT ERROR")
ERRQ	Q
	;