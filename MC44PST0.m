MC44PST0	;ALB/JAM - MEDICAL DIAGNOSES UPDATE WITH ICD10 CODES ;3/26/12  15:45
	;;2.3;Medicine;**44**;09/13/1996;Build 9
	;
	;This post install routine(s) contain ICD10 codes that will be mapped to medical diagnosis text in file #697.5
	;
EN	;Patch entry point
	N ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTREQ,ZTSAVE
	D MES^XPDUTL(" ")
	D BMES^XPDUTL("This patch updates entries in the MEDICAL DIAGNOSIS/ICD CODES File (#697.5) with")
	D MES^XPDUTL("ICD10 codes.")
	D MES^XPDUTL(" ")
	D MES^XPDUTL("A MailMan message will be generated after the update is done and a report will")
	D MES^XPDUTL("be sent to the installer.")
	D MES^XPDUTL(" ")
	;
	S ZTRTN="RPT^MC44PST0",ZTDESC="Medical Diagnosis ICD10 update MC*2.3*44",ZTIO=""
	S ZTDTH=$H,ZTREQ="@",ZTSAVE("ZTREQ")="" D ^%ZTLOAD
	Q
	;
RPT	;Queue entry point for Medical Diagnosis ICD10 update 
	N COU,MCRTN,CNT,CNTD,TXT
	K ^TMP($J,"MCP44")
	L +^MCAR(697.5):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) I '$T D  Q
	.S TXT="The MEDICAL DIAGNOSIS/ICD CODES File (#697.5) is Being Edited by Another User" D LINE(TXT)
	.S TXT="Try installing the patch later." D LINE(TXT) D MAIL K ^TMP($J,"MCP44")
	D DEL
	S (CNT,CNTD)=0
	S TXT="" D LINE(TXT)
	S TXT="Medical Diagnosis                    ICD10 Code  Error Message" D LINE(TXT)
	S TXT="-----------------                    ----------  -------------" D LINE(TXT)
	F COU=0:1:9 S MCRTN="^MC44PST"_COU D ADDX W "."
	F COU=10:1:22 S MCRTN="^MC44PS"_COU D ADDX W "."
	S TXT="" D LINE(TXT)
	S TXT="Total Number of Errors: "_(CNT-4) D LINE(TXT)
	S TXT="" D LINE(TXT)
	S TXT="Total ICD10 Codes mapped: "_CNTD D LINE(TXT)
	D MAIL
	L -^MCAR(697.5)
	K ^TMP($J,"MCP44")
	Q
	;
DEL	;Remove ICD-10 codes that are no longer valid, if patch was installed before
	N XX,YY,STR,ARY,DEL,RESLT
	; Check if patch was installed before and delete all ICD-10 codes
	S DEL=$$INSTALDT^XPDUTL("MC*2.3*44",.RESLT)
	I '+DEL Q
	S XX=$O(RESLT("")) I XX="" Q
	S STR=RESLT(XX) I STR>3 Q
	; if test version is less than or up to 3, remove ICD-10 codes
	S XX="" F  S XX=$O(^MCAR(697.5,XX)) Q:XX=""  D
	.S YY=0 F  S YY=$O(^MCAR(697.5,XX,2,YY)) Q:'YY  D
	..S DX=+$G(^MCAR(697.5,XX,2,YY,0)) Q:'DX
	..I $$CSI^ICDEX(80,DX)'=30 Q
	..S DA(1)=XX,DA=YY
	..S DIK="^MCAR(697.5,"_DA(1)_",2,"
	..D ^DIK
	; remove invalid codes T40.1X5A and T40.8X5A
	S ARY("ADV EFF MEDICAL/BIOLOGICAL SUBSTANCES NOS")="",ARY("DRUG RELATED LUPUS ERYTHEMATOSUS")=""
	S ARY("DRUG RELATED RHEUMATIC SYNDROMES")=""
	S XX="" F  S XX=$O(^MCAR(697.5,XX)) Q:XX=""  D
	.S STR=$P($G(^MCAR(697.5,XX,0)),"^") Q:STR=""
	.Q:'$D(ARY(STR))
	.S YY=0 F  S YY=$O(^MCAR(697.5,XX,2,YY)) Q:'YY  D
	..S DX=+$G(^MCAR(697.5,XX,2,YY,0)) Q:'DX
	..I +$$CODEC^ICDEX(80,DX)'=-1 Q
	..S DA(1)=XX,DA=YY
	..S DIK="^MCAR(697.5,"_DA(1)_",2,"
	..D ^DIK
	Q
	;
ADDX	;* add ICD10 diagnosis code
	N MCX,MCTAG,MCXY,MCXX,MCDXT,ERRTXT,DX,SPACE
	S $P(SPACE," ",60)=""
	F MCX=1:1 S MCTAG="CODES+"_MCX_MCRTN,MCXY=$P($T(@MCTAG),";;",2) Q:MCXY=""  D
	.S MCXX=$P(MCXY,"^"),DX=$$UP^XLFSTR($P(MCXY,"^",2))
	.S MCDXT=$$FIND1^DIC(697.5,"","X",MCXX) I +MCDXT<1 D  Q
	..S ERRTXT="Medical Diagnosis not on File" D ERRSET(ERRTXT)
	.D FILICD
	Q
	;
FILICD	;File ICD10 codes in File 697.5
	N DXIEN,MCFDA,MCERR,ERRTXT
	I DX="" D  Q
	.S ERRTXT="Missing ICD10 code" D ERRSET(ERRTXT)
	I $$CODECS^ICDEX(DX,80)'["ICD-10" D  Q
	.S ERRTXT="Invalid ICD-10 code" D ERRSET(ERRTXT)
	S DXIEN=+$$CODEN^ICDEX(DX)
	;check if ICD10 code already on file
	I $D(^MCAR(697.5,MCDXT,2,"B",DXIEN)) Q
	S MCFDA(697.51,"+2,"_MCDXT_",",.01)=DXIEN
	D UPDATE^DIE("","MCFDA","","MCERR")
	I $D(MCERR) S ERRTXT="Error while attempting to file ICD10 code" D ERRSET(ERRTXT) Q
	S CNTD=CNTD+1
	Q
ERRSET(ERRMSG)	; set string with error
	N STR
	S STR=$E(MCXX,1,38)_$E(SPACE,1,38-$L(MCXX))_DX_$E(SPACE,1,11-$L(DX))_ERRMSG
	D LINE(STR)
	Q
LINE(TEXT)	; Add line to message global
	S CNT=CNT+1,^TMP($J,"MCP44",CNT)=TEXT
	Q
	;
MAIL	; Send message
	N XMDUZ,XMY,XMTEXT,XMSUB
	S XMY(DUZ)="",XMDUZ=.5
	S XMSUB="Medical Diagnoses ICD10 Codes Mapping Report"
	S XMTEXT="^TMP($J,""MCP44"","
	D ^XMD
	Q 
	;
CODES	;
	;;MYOCARDIAL INFARCTION - TRANSMURAL Q WAVE^I25.2
	;;SUSPECTED CAD^I25.3
	;;SUSPECTED CAD^R94.31
	;;SUSPECTED CAD^I20.8
	;;SUSPECTED CAD^I20.8
	;;SUSPECTED CAD^I20.9
	;;SUSPECTED CAD^I25.111
	;;SUSPECTED CAD^I25.118
	;;SUSPECTED CAD^I25.119
	;;SUSPECTED CAD^I25.701
	;;SUSPECTED CAD^I25.708
	;;SUSPECTED CAD^I25.709
	;;SUSPECTED CAD^I25.711
	;;SUSPECTED CAD^I25.718
	;;SUSPECTED CAD^I25.719
	;;SUSPECTED CAD^I25.721
	;;SUSPECTED CAD^I25.728
	;;SUSPECTED CAD^I25.729
	;;SUSPECTED CAD^I25.731
	;;SUSPECTED CAD^I25.738
	;;SUSPECTED CAD^I25.739
	;;SUSPECTED CAD^I25.751
	;;SUSPECTED CAD^I25.758
	;;SUSPECTED CAD^I25.759
	;;SUSPECTED CAD^I25.761
	;;SUSPECTED CAD^I25.768
	;;SUSPECTED CAD^I25.769
	;;SUSPECTED CAD^I25.791
	;;SUSPECTED CAD^I25.798
	;;SUSPECTED CAD^I25.799
	;;SUSPECTED CAD^I25.2
	;;SUSPECTED CAD^I25.10
	;;SUSPECTED CAD^I70.8
	;;SUSPECTED CAD^I24.1
	;;SUSPECTED CAD^R07.82
	;;SUSPECTED CAD^R07.89
	;;SUSPECTED CAD^R07.9
	;;SUSPECTED CAD^I25.5
	;;SUSPECTED CAD^I25.6
	;;SUSPECTED CAD^I25.89
	;;SUSPECTED CAD^I25.9
	;;SUSPECTED CAD^I51.9
	;;SUSPECTED CAD^I52.
	;;SUSPECTED CAD^I51.89
	;;SUSPECTED CAD^I51.5
	;;SUSPECTED CAD^I72.8
	;;SUSPECTED CAD^I72.9
	;;SUSPECTED CAD^I46.2
	;;SUSPECTED CAD^I46.8
	;;SUSPECTED CAD^I46.9
	;;SUSPECTED CAD^R57.0
	;;SUSPECTED CAD^I50.1
	;;SUSPECTED CAD^I23.4
	;;SUSPECTED CAD^I51.1
	;;ANGINA PECTORIS - STABLE^I20.8
	;;ANGINA PECTORIS - STABLE^I20.9
	;;ANGINA PECTORIS - STABLE^I25.111
	;;ANGINA PECTORIS - STABLE^I25.118
	;;ANGINA PECTORIS - STABLE^I25.119
	;;ANGINA PECTORIS - STABLE^I25.701
	;;ANGINA PECTORIS - STABLE^I25.708
	;;ANGINA PECTORIS - STABLE^I25.709
	;;ANGINA PECTORIS - STABLE^I25.711
	;;ANGINA PECTORIS - STABLE^I25.718
	;;ANGINA PECTORIS - STABLE^I25.719
	;;ANGINA PECTORIS - STABLE^I25.721
	;;ANGINA PECTORIS - STABLE^I25.728
	;;ANGINA PECTORIS - STABLE^I25.729
	;;ANGINA PECTORIS - STABLE^I25.731
	;;ANGINA PECTORIS - STABLE^I25.738
	;;ANGINA PECTORIS - STABLE^I25.739
	;;ANGINA PECTORIS - STABLE^I25.751
	;;ANGINA PECTORIS - STABLE^I25.758
	;;ANGINA PECTORIS - STABLE^I25.759
	;;ANGINA PECTORIS - STABLE^I25.761
	;;ANGINA PECTORIS - STABLE^I25.768
	;;ANGINA PECTORIS - STABLE^I25.769
	;;ANGINA PECTORIS - STABLE^I25.791
	;;ANGINA PECTORIS - STABLE^I25.798
	;;ANGINA PECTORIS - STABLE^I25.799
	;;ANGINA PECTORIS - STABLE^I20.1
	;;ANGINA PECTORIS - STABLE^I20.8
	;;ANGINA PECTORIS - STABLE^R07.9
	;;ANGINA PECTORIS - STABLE^I25.9
	;;ANGINA PECTORIS - STABLE^I25.5
	;;ANGINA PECTORIS - STABLE^I25.6
	;;ANGINA PECTORIS - STABLE^I25.89
	;;ANGINA PECTORIS - UNSTABLE^I20.8
	;;ANGINA PECTORIS - UNSTABLE^I20.9
	;;ANGINA PECTORIS - UNSTABLE^I25.111
	;;ANGINA PECTORIS - UNSTABLE^I25.118
	;;ANGINA PECTORIS - UNSTABLE^I25.119
	;;ANGINA PECTORIS - UNSTABLE^I25.701
	;;ANGINA PECTORIS - UNSTABLE^I25.708
	;;ANGINA PECTORIS - UNSTABLE^I25.709
	;;ANGINA PECTORIS - UNSTABLE^I25.711
	;;ANGINA PECTORIS - UNSTABLE^I25.718
	;;ANGINA PECTORIS - UNSTABLE^I25.719
	;;ANGINA PECTORIS - UNSTABLE^I25.721
	;;ANGINA PECTORIS - UNSTABLE^I25.728
	;;ANGINA PECTORIS - UNSTABLE^I25.729
	;;ANGINA PECTORIS - UNSTABLE^I25.731
	;;ANGINA PECTORIS - UNSTABLE^I25.738
	;;ANGINA PECTORIS - UNSTABLE^I25.739
	;;ANGINA PECTORIS - UNSTABLE^I25.751
	;;ANGINA PECTORIS - UNSTABLE^I25.758
	;;ANGINA PECTORIS - UNSTABLE^I25.759
	;;ANGINA PECTORIS - UNSTABLE^I25.761
	;;ANGINA PECTORIS - UNSTABLE^I25.768
	;;ANGINA PECTORIS - UNSTABLE^I25.769
	;;ANGINA PECTORIS - UNSTABLE^I25.791
	;;ANGINA PECTORIS - UNSTABLE^I25.798
	;;ANGINA PECTORIS - UNSTABLE^I25.799
	;;ANGINA PECTORIS - UNSTABLE^I20.1
	;;ANGINA PECTORIS - UNSTABLE^I20.8
	;;ANGINA PECTORIS - UNSTABLE^R07.9
	;;ANGINA PECTORIS - UNSTABLE^I25.5
	;;ANGINA PECTORIS - UNSTABLE^I25.6
	;;ANGINA PECTORIS - UNSTABLE^I25.89
	;;ANGINA PECTORIS - UNSTABLE^I25.9
	;;MYOCARDITIS^I40.0
	;;MYOCARDITIS^I40.1
	;;MYOCARDITIS^I40.8
	;;MYOCARDITIS^I40.9
	;;MYOCARDITIS^A36.81
	;;MYOCARDITIS^B33.22
	;;MYOCARDITIS^A39.52
	;;MYOCARDITIS^I09.0
	;;MYOCARDITIS^I40.0
	;;MYOCARDITIS^A52.06
	;;MYOCARDITIS^I40.8
	;;HYPERTENSIVE HEART DISEASE^A18.84
	;;HYPERTENSIVE HEART DISEASE^D15.1
	;;HYPERTENSIVE HEART DISEASE^I10.
	;;HYPERTENSIVE HEART DISEASE^I11.0
	;;HYPERTENSIVE HEART DISEASE^I11.9
	;;HYPERTENSIVE HEART DISEASE^I15.0
	;;HYPERTENSIVE HEART DISEASE^I15.1
	;;HYPERTENSIVE HEART DISEASE^I15.2
	;;HYPERTENSIVE HEART DISEASE^I15.8
	;;HYPERTENSIVE HEART DISEASE^I15.9
	;;HYPERTENSIVE HEART DISEASE^I43.
	;;HYPERTENSIVE HEART DISEASE^N26.2
	;;HCM - OBSTRUCTIVE^A18.84
	;;HCM - OBSTRUCTIVE^I43.
	;;HCM - NON-OBSTRUCTIVE^A18.84
	;;HCM - NON-OBSTRUCTIVE^I43.
	;;HCM - PROVOCABLE OBSTRUCTION^A18.84
	;;HCM - PROVOCABLE OBSTRUCTION^I43.
	;;CARDIOMYOPATHY - DILATED^A18.84
	;;CARDIOMYOPATHY - DILATED^I43.
	;;CARDIOMYOPATHY - DILATED^I42.6
	;;CARDIOMYOPATHY - DILATED^I51.7
	;;CARDIOMYOPATHY - INFILTRATIVE/RESTRICTIVE^A18.84
	;;CARDIOMYOPATHY - INFILTRATIVE/RESTRICTIVE^I43.
	;;MITRAL STENOSIS^I05.0
	;;MITRAL STENOSIS^Q23.2
	;;MITRAL STENOSIS^I08.0
	;;MITRAL STENOSIS^I08.0
	;;MITRAL STENOSIS^I05.2
	;;MITRAL STENOSIS^I05.8
	;;MITRAL STENOSIS^I05.9
	;;MITRAL STENOSIS^I34.0
	;;MITRAL STENOSIS^I34.1
	;;MITRAL STENOSIS^I34.2
	;;MITRAL STENOSIS^I34.8
	;;MITRAL STENOSIS^I34.9
	;;MITRAL STENOSIS^I08.9
	;;MITRAL STENOSIS^I09.9
