VAFCSB	;BIR/CMC-CONT ADT PROCESSOR TO RETRIGGER A08 or A04 MESSAGES WITH AL/AL (COMMIT/APPLICATION) ACKNOWLEDGEMENTS ; 11/26/14 12:03pm
	;;5.3;Registration;**707,756,825,876,902**;Aug 13, 1993;Build 2
	;
	;Reference to $$XAMDT^RAO7UTL1 is supported by IA #4875
	;Reference to RESUTLS^LRPXAPI is supported by IA #4245
	;
PV2()	;build pv2 segment
	N PV2,LSTA,APPT,VASD,VAIP,VARP,VAROOT
	S PV2=""
	;get next outpatient appointment
	K ^UTILITY("VASD",$J) S VASD("F")=DT D SDA^VADPT
	S APPT=$P($G(^UTILITY("VASD",$J,1,"I")),"^")
	I APPT'="" S $P(PV2,HL("FS"),9)=$$HLDATE^HLFNC(APPT)
	;GET LAST ADMISSION DATE
	K VAIP S VAIP("D")="LAST",VAIP("M")=0 D IN5^VADPT
	; **825,CR_1184: for PV2-14, it will be re-set as the 15th piece
	; in PV2 segment a few lines below
	; I VAIP(2)="1^ADMISSION" S $P(PV2,HL("FS"),15)=$$HLDATE^HLFNC($P(VAIP(3),"^"))
	I VAIP(2)="1^ADMISSION" S $P(PV2,HL("FS"),14)=$$HLDATE^HLFNC($P(VAIP(3),"^"))
	;get last registration
	S VAROOT="VARP"
	D REG^VADPT
	I $D(VARP(1,"I")),$G(VARP(1,"I"))>0 S $P(PV2,HL("FS"),46)=$$HLDATE^HLFNC($P(VARP(1,"I"),"^"),"DT"),$P(PV2,HL("FS"),24)="CR"
	;**756 ^ ONLY RETURN DATE FOR LAST REGISTRATION AS HL7 STANDARD CAN ONLY HAVE DATE
	I PV2'="" S PV2="PV2"_HL("FS")_PV2
	Q PV2
PHARA()	;build obx to show active prescriptions
	N RET S RET=""
	I '$$PATCH^XPDUTL("PSS*1.0*101") Q RET
	N PHARM,DGLIST
	S PHARM="" D PROF^PSO52API(DFN,"DGLIST")
	I +$G(^TMP($J,"DGLIST",DFN,0))>0 S PHARM="OBX"_HL("FS")_HL("FS")_"CE"_HL("FS")_"ACTIVE PRESCRIPTIONS"_HL("FS")_HL("FS")_"Y"
	;**756 CE added as the data type
	Q PHARM
SIG(DFN)	;**876 MVI_3467 (ckn) Build OBX for Self Identified Gender
	N SIG,SIGE,SIGTMP,OBX S OBX=""
	;I '$$PATCH^XPDUTL("DG*5.3*876") Q OBX
	S DIC=2,DA=DFN,DR=".024",DIQ="SIGTMP",DIQ(0)="I,E,N" D EN^DIQ1
	I '$D(SIGTMP) K DA,DR,DIQ  Q OBX
	S SIG=$G(SIGTMP(2,DFN,DR,"I")),SIGE=$G(SIGTMP(2,DFN,DR,"E"))
	S OBX="OBX"_HL("FS")_HL("FS")_"CE"_HL("FS")_"SELF ID GENDER"_HL("FS")_HL("FS")_SIG_$E(HL("ECH"),1)_SIGE
	K DA,DR,DIC,DIQ
	Q OBX
DODF(DFN)	;**902 MVI_4898 (ckn) Build OBX for DOD fields
	N DODTMP,DODEB,DODLEB,DODSRC,DODLUPD,DODSRCI,DODSRCE,CS,DODLNAM
	N DODFNAM,DODMNAM,DODEBE,DODEBI,DODLEBE,DODLEBI
	S CS=$E(HL("ECH")),SC=$E(HL("ECH"),4)
	S DIC=2,DA=DFN,DR=".352;.353;.354;.355",DIQ="DODTMP",DIQ(0)="I,E,N" D EN^DIQ1
	S DODSRCI=$G(DODTMP(2,DFN,.353,"I")),DODSRCE=$G(DODTMP(2,DFN,.353,"E")),DODSRC=HL("Q")
	I DODSRCE'="" S DODSRC=DODSRCI_CS_DODSRCE_CS_"L"
	S DODLUPD=$G(DODTMP(2,DFN,.354,"I")) S DODLUPD=$S(DODLUPD="":HL("Q"),1:$$HLDATE^HLFNC(DODLUPD))
	;If LAST EDITED BY field(#.355) have value, use it to populate sequence 16 of OBX
	;If LAST EDITED BY field(#.355) does not have value, use DEATH ENTERED BY field(#.352) to populate sequence 16 of OBX
	;If both fields empty, send double quotes in sequence 16 of OBX
	S DODLEB=HL("Q") ;Default seq 16
	S DODEBE=$G(DODTMP(2,DFN,.352,"E")),DODEBI=$G(DODTMP(2,DFN,.352,"I")) ;DOD Entered by
	S DODLEBE=$G(DODTMP(2,DFN,.355,"E")),DODLEBI=$G(DODTMP(2,DFN,.355,"I")) ;DOD Last Edited By
	I DODLEBE'="" D
	.S DODLEBE=$$HLNAME^HLFNC(DODLEBE,CS),DODLNAM=$S($P(DODLEBE,CS)="":HL("Q"),1:$P(DODLEBE,CS)),DODFNAM=$S($P(DODLEBE,CS,2)="":HL("Q"),1:$P(DODLEBE,CS,2)),DODMNAM=$S($P(DODLEBE,CS,3)="":HL("Q"),1:$P(DODLEBE,CS,3))
	.S DODLEB=$S(DODLEBI="":HL("Q"),1:DODLEBI)_CS_DODLNAM_CS_DODFNAM_CS_DODMNAM_CS_CS_CS_CS_CS_"USVHA"_SC_SC_"0363"_CS_"L"_CS_CS_CS_"PN"_CS_"VA FACILITY ID"_SC_$P($$SITE^VASITE(),"^",3)_SC_"L"
	I DODLEBE="",(DODEBE'="") D
	.S DODEBE=$$HLNAME^HLFNC(DODEBE,CS),DODLNAM=$S($P(DODEBE,CS)="":HL("Q"),1:$P(DODEBE,CS)),DODFNAM=$S($P(DODEBE,CS,2)="":HL("Q"),1:$P(DODEBE,CS,2)),DODMNAM=$S($P(DODEBE,CS,3)="":HL("Q"),1:$P(DODEBE,CS,3))
	.S DODLEB=$S(DODEBI="":HL("Q"),1:DODEBI)_CS_DODLNAM_CS_DODFNAM_CS_DODMNAM_CS_CS_CS_CS_CS_"USVHA"_SC_SC_"0363"_CS_"L"_CS_CS_CS_"PN"_CS_"VA FACILITY ID"_SC_$P($$SITE^VASITE(),"^",3)_SC_"L"
	S OBX="OBX"_HL("FS")_HL("FS")_"CE"_HL("FS")_"DATE OF DEATH DATA"_HL("FS")_HL("FS")_DODSRC_HL("FS")_HL("FS")_HL("FS")_HL("FS")_HL("FS")_HL("FS")_"R"_HL("FS")_HL("FS")_HL("FS")_DODLUPD_HL("FS")_HL("FS")_$G(DODLEB)
	K DA,DR,DIC,DIQ
	Q OBX
NAMEOBX(DFN)	;**876,MVI_3453 (mko): Build OBX for Patient .01 and Name Components
	N FS
	S FS=HL("FS")
	Q "OBX"_FS_FS_"CE"_FS_"NAME COMPONENTS"_FS_FS_$$NAMECOMP(DFN,$E(HL("ECH")))
NAMEERR(DFN)	;**876,MVI_3453 (mko): Build ERR for Patient .01 and Name Components
	N CS,SC
	S CS=$E(HL("ECH")),SC=$E(HL("ECH"),4)
	Q "ERR"_HL("FS")_CS_CS_CS_SC_$$NAMECOMP(DFN,SC)
NAMECOMP(DFN,DELIM)	;**876,MVI_3453 (mko): Return Patient .01 and Name Components
	N DIHELP,DIMSG,DIERR,MSG,NC,NCIEN,NCIENS,NCPTR,TARG
	S NC=$P($G(^DPT(DFN,0)),"^")
	S NCPTR=$P($G(^DPT(DFN,"NAME")),"^") Q:'NCPTR NC
	S NCIEN=$$FIND1^DIC(20,"","","`"_NCPTR,"","","MSG") Q:'NCIEN NC
	S NCIENS=NCIEN_","
	D GETS^DIQ(20,NCIENS,"1:5","","TARG","MSG") Q:$G(DIERR) NC
	S NC=NC_DELIM_TARG(20,NCIENS,1)_DELIM_TARG(20,NCIENS,2)_DELIM_TARG(20,NCIENS,3)_DELIM_TARG(20,NCIENS,5)_DELIM_TARG(20,NCIENS,4)
	Q NC
LABE()	;BUILD OBX FOR LAST LAB TEST DATE
	N OBX S OBX=""
	I '$$PATCH^XPDUTL("LR*5.2*295") Q OBX
	N LAB,LAB2,EN
	S LAB="" K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"C")
	S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB=$P($G(^TMP("DGLAB",$J,EN)),"^")
	K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"A")
	S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB2=$P($G(^TMP("DGLAB",$J,EN)),"^") I LAB2>LAB S LAB=LAB2
	K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"M")
	S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB2=$P($G(^TMP("DGLAB",$J,EN)),"^") I LAB2>LAB S LAB=LAB2
	I LAB'="" D
	.S $P(OBX,HL("FS"),2)="TS" ;**756 added the data type
	.S $P(OBX,HL("FS"),3)="LAST LAB TEST DATE/TIME"
	.S $P(OBX,HL("FS"),11)="F"
	.S $P(OBX,HL("FS"),14)=$$HLDATE^HLFNC(LAB)
	.S OBX="OBX"_HL("FS")_OBX
	Q OBX
RADE()	;BUILD OBX FOR LAST RADIOLOGY TEST DATE
	N RET S RET=""
	I '$$PATCH^XPDUTL("RA*5.0*76") Q RET
	N RAD,RADE
	S RAD="",RADE=$$XAMDT^RAO7UTL1(DFN) I +RADE<1 Q RAD
	I +RADE>0 D
	.S $P(OBX,HL("FS"),2)="TS" ;**756 added the data type
	.S $P(RAD,HL("FS"),3)="LAST RADIOLOGY EXAM DATE/TIME"
	.S $P(RAD,HL("FS"),11)="F"
	.S $P(RAD,HL("FS"),14)=$$HLDATE^HLFNC(RADE)
	.S RAD="OBX"_HL("FS")_RAD
	Q RAD
PD1()	;BUILD PD1 segment
	;PREFERRED FACILITY -- NOT GOING TO BE PASSED PER IMDQ 9/7/06
	N TEAM,PD1
	S PD1=""
	;S TEAM=$$PREF^DGENPTA(DFN)
	;I TEAM'="" S PD1="PD1"_HL("FS")_HL("FS")_HL("FS")_$$STA^XUAF4(TEAM)
	Q PD1
PV1()	;BUILD PV1 SEGMENT
	;CURRENTLY ADMITTED?
	N PV1,VAINDT
	S PV1=""
	S VAINDT=DT
	D INP^VADPT
	I $G(VAIN(1))'="" S $P(PV1,HL("FS"),44)=$$HLDATE^HLFNC($P(VAIN(7),"^")),PV1="PV1"_HL("FS")_PV1
	K VAIN
	Q PV1