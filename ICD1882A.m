ICD1882A	;ALB/JDG - POST INSTALL ROUTINE;8/1/2015
	;;18.0;DRG Grouper;**82**;Oct 20, 2000;Build 21
	;
	Q
	;
PRE	;delete data
	;if previously installed then delete files 80.5,80.6,82.11,82.12
	D DELFILES^ICD1882B
	Q
	;
POST	;
	N ICDX,ICDY,ICDHIST,ICDCSYS,ICDIEN,ICDPRE,ICDST,ICDCODE,ICDR,ICDEFF,ICDDX9,ICDDTTX,ICDF,ICDMDCF,ICDVAR,ICDCC
	N ICDSTA,ICDI,ICDMIEN,ICDRGIEN,ICDFN,ICDDESC,ICDIX,ICDSTOP,ICDFILE,ICDFILE2,ICDAIDA,ICDMULT,ICDDAP,ICDCCMCC,ICDCCIEN
	N ICDPDX,ICD103,ICD40,ICD14,ICD40IEN,ICD73IEN,ICD82,ICD821,ICD82T,ICDA,ICDB,ICDBLIEN,ICDBLK,ICDC,ICDCT,ICDDA,ICDDRGS,ICDDXCC
	N ICDDXIEN,ICDEXCL,ICDEXIEN,ICDF2,ICDFI,ICDFILE,ICDFILE1,ICDFILE2,ICDFILE3,ICDFILE4,ICDFLAG,ICDFR,ICDFT,ICDMAC,ICDIEN2
	N ICDLET,ICDMDDRG,ICDMDIEN,ICDONEI,ICDORCD,ICDOWN,ICDPCS,ICDPRIEN,ICDPRIM,ICDREC,ICDTO,ICDTY,ICDWIDTH,ICDXIEN,ICDYES,ICDWITH
	N ICDN,ICDX,ICDIEN,ICDIEN9,ICDDX,ICDDAIEN,ICDFDA,ICDERR,ICDI,ICDDRG,ICDMDC,ICDBAD,ICDIDEN,ICDDX9,ICDMDC,ICDMDC24,ICDMDC25,ICDDRGN
	N ICDORD,ICDDRG,ICDCC,ICDHAC,ICDA,ICDSUM,ICD73,DIK,ICDNODE
	S U="^"
	I $G(XPDQUES("POS1"))=0 S XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*82")=1 D BMES^XPDUTL("Load was aborted by the user.") Q
	I $G(XPDQUES("POS3"))=0 S XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*82")=1 D BMES^XPDUTL("DRG load was aborted by the user.") Q
	D BMES^XPDUTL("Starting DRG update...")
	D UPDATING
	D CLEANUP^ICD1882B
	D BMES^XPDUTL("DRG data has been loaded. Messages are in the file #9.7 IEN "_XPDA)
	Q
	;
UPDATING	;
	;
	S ICDN=0,DIK="^ICDID(" F  S ICDN=$O(^ICDID(ICDN)) Q:'ICDN  S DA=ICDN D ^DIK
	S ICDN=0,DIK="^ICDIP(" F  S ICDN=$O(^ICDIP(ICDN)) Q:'ICDN  S DA=ICDN D ^DIK
	K ^TMP("ICDLD82",$J),ICDSUM
	S ICDEFF=$$IMPDATE^LEXU("10D") I $P(ICDEFF,U,1)=-1 D BMES^XPDUTL("Bad Implementation Date: "_ICDEFF_" Aborting.") Q
	D UP82^ICD1882B
	D UP82ADD^ICD1882B
	D UP80
	D UP801
	D UPID10
	D UP802
	D UP805
	D UP806
	D UP8211^ICD1882B
	D UP8211B^ICD1882B
	D UP8213^ICD1882B
	D MAJOROR^ICD1882B
	K ^TMP("ICDLD82",$J)
	Q
	;
UP80	;
	;Load file #80 - Appendix B
	D BMES^XPDUTL("Starting File #80 "_$$DTTIME)
	S ICDN="",U="^"
	F  S ICDN=$O(^ICDLD82(80,"A",ICDN)) Q:ICDN=""  S ICDX=^ICDLD82(80,"A",ICDN),ICDDX=$P(ICDX,U,1),ICDIEN=$O(^ICD9("BA",ICDDX_" ","")) Q:'ICDIEN  D
	.S ICD73=0 F  S ICD73=$O(^ICD9(ICDIEN,73,ICD73)) Q:'ICD73  K DA S DA=ICD73,DA(1)=ICDIEN,DIK="^ICD9("_DA(1)_",73," D ^DIK
	.S ICDNODE=0 F  S ICDNODE=$O(^ICD9(ICDIEN,3,ICDNODE)) Q:'ICDNODE  K DA S DA=ICDNODE,DA(1)=ICDIEN,DIK="^ICD9("_DA(1)_",3," D ^DIK
	.S ICDNODE=0 F  S ICDNODE=$O(^ICD9(ICDIEN,4,ICDNODE)) Q:'ICDNODE  K DA S DA=ICDNODE,DA(1)=ICDIEN,DIK="^ICD9("_DA(1)_",4," D ^DIK
	.S ICDNODE=0 F  S ICDNODE=$O(^ICD9(ICDIEN,69,ICDNODE)) Q:'ICDNODE  K DA S DA=ICDNODE,DA(1)=ICDIEN,DIK="^ICD9("_DA(1)_",69," D ^DIK
	S ICDN="",U="^"
	F  S ICDN=$O(^ICDLD82(80,"A",ICDN)) Q:ICDN=""  S ICDX=^ICDLD82(80,"A",ICDN),ICDDX=$P(ICDX,U,1),ICDIEN=$O(^ICD9("BA",ICDDX_" ","")) D
	.I ICDIEN="" D BMES^XPDUTL("ICD Code: "_ICDDX_" not in file #80") S ICDSUM(80,"B")=$G(ICDSUM(80,"B"))+1 Q
	.I '$D(^ICD9(ICDIEN,0)) D BMES^XPDUTL("ICD Code: "_ICDDX_" bad x-ref IEN: "_ICDIEN) S ICDSUM(80,"B")=$G(ICDSUM(80,"B"))+1 Q
	.S ^TMP("ICDLD82",$J)="80: "_ICDDX_" "_ICDIEN,ICDSUM(80,"G")=$G(ICDSUM(80,"G"))+1
	.S ICD73=0 F  S ICD73=$O(^ICD9(ICDIEN,73,ICD73)) Q:'ICD73  K DA S DA=ICD73,DA(1)=ICDIEN,DIK="^ICD9("_DA(1)_",73," D ^DIK
	.S ICDDAIEN=$O(^ICD9(ICDIEN,3,"B",ICDEFF,"")) I 'ICDDAIEN D
	..K ICDFDA S ICDFDA("80.071","+1,"_ICDIEN_",",.01)=ICDEFF K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	..S ICDDAIEN=$O(^ICD9(ICDIEN,3,"B",ICDEFF,""))
	.I ICDDAIEN S ICDDRGS=$P(ICDX,U,3) I ICDDRGS'="" S ICDFR=+$P(ICDDRGS,"-",1),ICDTO=+$P(ICDDRGS,"-",2) S:ICDTO=0 ICDTO=ICDFR F ICDDRG=ICDFR:1:ICDTO D:$O(^ICD9(ICDIEN,3,ICDDAIEN,1,"B",ICDDRG,""))=""
	..I $O(^ICD("B","DRG"_ICDDRG,""))="" D BMES^XPDUTL(ICDDX_" Grouper Code: "_ICDDRG_" not in file #80.2") Q
	..K ICDFDA S ICDFDA("80.711","+1,"_ICDDAIEN_","_ICDIEN_",",.01)=ICDDRG K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.S ICDMDC=+$P(ICDX,U,2) I ICDMDC>0 I '$D(^ICM(ICDMDC,0)) D BMES^XPDUTL(ICDDX_" MDC Code: "_ICDDRG_" not in file #80.3") Q
	.S ICDDX9=$O(^ICDLD82("GEM-10-9",ICDDX,"")),ICDIEN9=0 I ICDDX9'="" S ICDIEN9=^ICDLD82("GEM-10-9",ICDDX,ICDDX9)
	.I ICDIEN9 D
	..;Next block copies MDC13, MDC24, MDC25 from ICD-9 record to ICD-10 record
	..F ICDF=1:1:3 S ICDMDCF="1."_(ICDF+3) K ICDFDA D  K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	...S ICDVAR=$P($G(^ICD9(ICDIEN9,1)),U,ICDF+3)
	...I ICDF=1 D
	....I $D(^ICDLD82("MDC13","DX",ICDDX)) S ICDVAR=13
	....I $D(^ICDLD82("MDC12","DX",ICDDX)) S ICDVAR=""
	...I ICDF=2,$D(^ICDLD82("MDC24","DX",ICDDX)) S ICDVAR=^ICDLD82("MDC24","DX",ICDDX)
	...I ICDF=3,$D(^ICDLD82("MDC25","DX",ICDDX)) S ICDVAR=$P(^ICDLD82("MDC25","DX",ICDDX),U,1)
	...S ICDFDA(80,ICDIEN_",",ICDMDCF)=ICDVAR
	.;Set Field #80,1.9 POA Exempt
	.K ICDFDA,ICDERR S ICDFDA(80,ICDIEN_",",1.9)=$S($D(^ICDLD82("APPJ",ICDDX)):1,1:0) D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.;Next block updates #80,72 - Effective Date multiple with MDC
	.S ICDDAIEN=$O(^ICD9(ICDIEN,4,"B",ICDEFF,"")) I 'ICDDAIEN D
	..K ICDFDA S ICDFDA("80.072","+1,"_ICDIEN_",",.01)=ICDEFF K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.S ICDDAIEN=$O(^ICD9(ICDIEN,4,"B",ICDEFF,"")) I ICDDAIEN D
	..K ICDFDA S ICDFDA("80.072",ICDDAIEN_","_ICDIEN_",",1)=ICDMDC K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.;Next block update new Field #80,0103.1 CC and #80,0103,2 PRIMARY
	.S ICD103=$O(^ICD9(ICDIEN,69,"B",ICDEFF,"")) I ICD103="" D
	..K ICDFDA,ICDERR S ICDFDA(80.0103,"+1,"_ICDIEN_",",.01)=ICDEFF D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	..S ICD103=$O(^ICD9(ICDIEN,69,"B",ICDEFF,""))
	.S ICDOWN=0 I $D(^ICDLD82("APPG","PDXOWNCC",ICDDX))!($D(^ICDLD82("APPH","PDXOWNMCC",ICDDX))) S ICDOWN=1
	.;GET ICDCC VALUE FROM ICD9 GLOBAL INSTEAD OF CMS WEBSITE
	.;I $D(^ICDLD82("APPH","MCCIFALIVE",ICDDX)) S ICDCC=3 K ICDFDA,ICDERR S ICDFDA(80.0103,ICD103_","_ICDIEN_",",1)=ICDCC D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.S ICDCC=$S($D(^ICDLD82("APPH","MCCIFALIVE",ICDDX)):3,$D(^ICDLD82("APPH","MCCEXPTAPPC",ICDDX)):2,$D(^ICDLD82("APPG","CCEXPTAPPC",ICDDX)):1,1:0)
	.K ICDFDA,ICDERR S ICDFDA(80.0103,ICD103_","_ICDIEN_",",1)=ICDCC D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.K ICDFDA,ICDERR S ICDFDA(80.0103,ICD103_","_ICDIEN_",",2)=ICDOWN D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.;Next block loads the ICD-9 Identifier field to put in the ICD-10 code 1.2 field
	.S ICDIDEN="" S:ICDIEN9 ICDIDEN=$P($G(^ICD9(ICDIEN9,1)),U,2)
	.S DA=ICDIEN,DIE="^ICD9(",IDENT="@",DR="1.2///^S X=IDENT" D ^DIE
	.K ICDFDA S ICDFDA(80,ICDIEN_",",1.2)=ICDIDEN K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.;Set new field #80,73 with Identifiers from #80,1.2
	.I ICDIDEN'="" F ICDLET=1:1:$L(ICDIDEN) D 8073(80,ICDDX,$E(ICDIDEN,ICDLET)) ;Update new 80,73 multiple with ICD-10 Identifier codes
	Q
	;
UP801	;
	;#80.1 Appendix E
	D BMES^XPDUTL("Starting #80.1 "_$$DTTIME)
	S ICDN="",U="^"
	F  S ICDN=$O(^ICDLD82(80.1,"A",ICDN)) Q:ICDN=""  S ICDREC=^ICDLD82(80.1,"A",ICDN),ICDDX=$P(ICDREC,U,1),ICDIEN=$O(^ICD0("BA",ICDDX_" ","")) Q:'ICDIEN  D
	.S ICD73=0 F  S ICD73=$O(^ICD0(ICDIEN,73,ICD73)) Q:'ICD73  K DA S DA=ICD73,DA(1)=ICDIEN,DIK="^ICD0("_DA(1)_",73," D ^DIK
	.S ICDNODE=0 F  S ICDNODE=$O(^ICD0(ICDIEN,2,ICDNODE)) Q:'ICDNODE  K DA S DA=ICDNODE,DA(1)=ICDIEN,DIK="^ICD0("_DA(1)_",2," D ^DIK
	S ICDN11=""
	F  S ICDN11=$O(^ICDLD82("APPE","OPEDIT",ICDN11)) Q:ICDN11=""  S ICDIEN=$O(^ICD0("BA",ICDN11_" ","")) Q:'ICDIEN  D
	.S ICDNODE1=0 F  S ICDNODE1=$O(^ICD0(ICDIEN,2,ICDNODE1)) Q:'ICDNODE1  K DA S DA=ICDNODE1,DA(1)=ICDIEN,DIK="^ICD0("_DA(1)_",2," D ^DIK
	.S ICD73=0 F  S ICD73=$O(^ICD0(ICDIEN,73,ICD73)) Q:'ICD73  K DA S DA=ICD73,DA(1)=ICDIEN,DIK="^ICD0("_DA(1)_",73," D ^DIK
	S ICDN=""
	F  S ICDN=$O(^ICDLD82(80.1,"A",ICDN)) Q:ICDN=""  S ICDREC=^ICDLD82(80.1,"A",ICDN),ICDDX=$P(ICDREC,U,1),ICDIEN=$O(^ICD0("BA",ICDDX_" ","")) D
	.I ICDIEN="" D BMES^XPDUTL("ICD Procedure Code: "_ICDDX_" not in file #80.1") S ICDSUM(80.1,"B")=$G(ICDSUM(80.1,"B"))+1 Q
	.I '$D(^ICD0(ICDIEN,0)) D BMES^XPDUTL("ICD Procedure Code: "_ICDDX_" bad x-ref IEN: "_ICDIEN) S ICDSUM(80.1,"B")=$G(ICDSUM(80.1,"B"))+1 Q
	.S ^TMP("ICDDRGLD",$J)="80.1: "_ICDDX_" "_ICDIEN,ICDSUM(80.1,"G")=$G(ICDSUM(80.1,"G"))+1
	.S ICDDAIEN=$O(^ICD0(ICDIEN,2,"B",ICDEFF,"")) I 'ICDDAIEN D
	..;Create Eff. Date entry
	..K ICDFDA S ICDFDA("80.171","+1,"_ICDIEN_",",.01)=ICDEFF K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	..S ICDDAIEN=$O(^ICD0(ICDIEN,2,"B",ICDEFF,""))
	.S ICDMIEN=0 I ICDDAIEN S ICDMDC=+$P(ICDREC,U,2),ICDMIEN=$O(^ICD0(ICDIEN,2,ICDDAIEN,1,"B",ICDMDC,"")) I 'ICDMIEN D
	..;Create MDC entry
	..K ICDFDA S ICDFDA("80.1711","+1,"_ICDDAIEN_","_ICDIEN_",",.01)=ICDMDC K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	..S ICDMIEN=$O(^ICD0(ICDIEN,2,ICDDAIEN,1,"B",ICDMDC,""))
	.I ICDMIEN D
	..S ICDY=$P(ICDREC,U,3),ICDFR=+$P(ICDY,"-",1),ICDTO=+$P(ICDY,"-",2) S:ICDTO=0 ICDTO=ICDFR F ICDDRG=ICDFR:1:ICDTO S ICDRGIEN=$O(^ICD0(ICDIEN,2,ICDDAIEN,1,ICDMIEN,1,"B",ICDDRG,"")) I 'ICDRGIEN D
	...;Create DRG entry
	...K ICDFDA S ICDFDA("80.17111","+1,"_ICDMIEN_","_ICDDAIEN_","_ICDIEN_",",.01)=ICDDRG K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	...S ICDRGIEN=$O(^ICD0(ICDIEN,2,ICDDAIEN,1,"B",ICDDRG,""))
	.;Next line checks the GEM file to find equivalent ICD-9-PCS code, and then loads the Identifier field to put in the ICD-10-PCS code
	.S ICDDX9=$O(^ICDLD82("GEM-10-9-PCS",ICDDX,"")),ICDIEN9=0 I ICDDX9'="" S ICDIEN9=^ICDLD82("GEM-10-9-PCS",ICDDX,ICDDX9)
	.S DA=ICDIEN,DIE="^ICD0(",IDENT="@",DR="1.5///^S X=IDENT" D ^DIE
	.I ICDIEN9 S ICDMDC24=$P($G(^ICD0(ICDIEN9,1)),U,5) D  K ICDFDA S ICDFDA(80.1,ICDIEN_",",1.5)=ICDMDC24 K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	..I $D(^ICDLD82("MDC24P","DX",ICDDX)) S ICDMDC24=^ICDLD82("MDC24P","DX",ICDDX)
	.S ICDIDEN="" S:ICDIEN9 ICDIDEN=$P($G(^ICD0(ICDIEN9,1)),U,2)
	.I $D(^ICDLD82("APPE","OR",ICDDX)) S:ICDIDEN'["O" ICDIDEN=ICDIDEN_"O"
	.I $D(^ICDLD82("APPF","NONEXTENSIVE",ICDDX)) S:ICDIDEN'["z" ICDIDEN=ICDIDEN_"z"
	.E  S:ICDIDEN'["x" ICDIDEN=ICDIDEN_"x"
	.I $D(^ICDLD82("APPF","PROSTATIC",ICDDX)) S:ICDIDEN'["y" ICDIDEN=ICDIDEN_"y"
	.S DA=ICDIEN,DIE="^ICD0(",IDENT="@",DR="1.2///^S X=IDENT" D ^DIE
	.K ICDFDA S ICDFDA(80.1,ICDIEN_",",1.2)=ICDIDEN K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	.I ICDIDEN'="" F ICDLET=1:1:$L(ICDIDEN) D 8073(80.1,ICDDX,$E(ICDIDEN,ICDLET)) ;Update new 80.1,73 multiple with ICD-10 Identifier codes
	Q
	;
UPID10	;Now Populate #80 #80.1 Multiple 73
	;
	D BMES^XPDUTL("Adding ICD-10 Identifiers to #80 and #80.1 Multiple 73 "_$$DTTIME)
	S ICDDESC="" F  S ICDDESC=$O(^ICDLD82("ID10",ICDDESC)) Q:ICDDESC=""  D
	.F ICDTY=1:1:4 I $D(^ICDLD82("ID10",ICDDESC,ICDTY)) S ICDFILE=$S(ICDTY=1!(ICDTY=2):82,1:82.1),ICDFILE2=$S(ICDTY=1!(ICDTY=2):"^ICDID",1:"^ICDIP") D
	..S ICDFILE3=$S(ICDTY=1!(ICDTY=2):80,1:80.1)
	..S ICDIEN=$O(@ICDFILE2@("C",ICDDESC,"")) I 'ICDIEN D
	...;Add this flag to File 82/82.1
	...K ICDFDA,ICDERR S ICDCODE=$O(@ICDFILE2@("B","*"),-1)+1,ICDFDA(ICDFILE,"+1,",.01)=ICDCODE,ICDFDA(ICDFILE,"+1,",1)=ICDDESC D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR
	...S ICDIEN=$O(@ICDFILE2@("C",ICDDESC,""))
	..S ICDID="" I ICDIEN S ICDID=$P(@ICDFILE2@(ICDIEN,0),U,1)
	..I ICDID="" Q
	..S ICDA="" F  S ICDA=$O(^ICDLD82("ID10",ICDDESC,ICDTY,ICDA)) Q:ICDA=""  D
	...S ICDB="" F  S ICDB=$O(^ICDLD82("ID10",ICDDESC,ICDTY,ICDA,ICDB)) Q:ICDB=""  D
	....S ICDC="" F  S ICDC=$O(^ICDLD82("ID10",ICDDESC,ICDTY,ICDA,ICDB,ICDC)) Q:ICDC=""  D
	.....I ICDTY=1!(ICDTY=3) D
	......S ICDDX=ICDC S:ICDTY=1 ICDDX=$E(ICDC,1,3)_"."_$E(ICDC,4,$L(ICDC))
	......D 8073(ICDFILE3,ICDDX,ICDID)
	;
	Q
	;
UP802	;
	;#80.2 New field #2 - CC/MCC flag
	D BMES^XPDUTL("Starting File #80.2 "_$$DTTIME)
	S ICDCC="" F  S ICDCC=$O(^ICDLD82(80.2,"CC/MCC",ICDCC)) Q:ICDCC=""  S ICDDRG="" F  S ICDDRG=$O(^ICDLD82(80.2,"CC/MCC",ICDCC,ICDDRG)) Q:ICDDRG=""  S ICDDRGN="DRG"_(+ICDDRG),ICDIEN=$O(^ICD("B",ICDDRGN,"")) D
	.I 'ICDIEN D BMES^XPDUTL("DRG code "_ICDDRGN_" not in file #80.2") Q
	.S ICDIEN2=$O(^ICD(ICDIEN,2,"B",ICDEFF,"")) I 'ICDIEN2 K ICDFDA S ICDFDA("80.271","+1,"_ICDIEN_",",.01)=ICDEFF K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR Q
	.S ICDIEN2=$O(^ICD(ICDIEN,2,"B",ICDEFF,"")) K ICDFDA S ICDFDA("80.271",ICDIEN2_","_ICDIEN_",",2)=ICDCC K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR Q
	.;Hardcoded rules ICD10TB0-9
	.S ICDY=+ICDDRG,ICDX="ICD10TB"_$S(ICDY<100:0,ICDY>99&(ICDY<202):1,ICDY>201&(ICDY<302):2,ICDY>301&(ICDY<400):3,ICDY>399&(ICDY<500):4,ICDY>499&(ICDY<602):5,ICDY>601&(ICDY<701):6,ICDY>700&(ICDY<802):7,ICDY>801&(ICDY<901):8,1:9)
	.K ICDFDA S ICDFDA("80.271",ICDIEN2_","_ICDIEN_",",1)=ICDX K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR Q
	Q
	;
UP805	;
	;Load #80.5 - ^ICDRS (Surgical Hierarchy)
	D BMES^XPDUTL("Starting #80.5... ")
	S ICDSTOP=0
	S ICDMDC="" F  S ICDMDC=$O(^ICDLD82("80.5",ICDMDC)) Q:ICDMDC=""  S ICDORD="" D
	.F  S ICDORD=$O(^ICDLD82(80.5,ICDMDC,ICDORD)) Q:ICDORD=""!(ICDSTOP)  S ICDDRG=^ICDLD82(80.5,ICDMDC,ICDORD),ICDDA=$O(^ICDRS("B",ICDEFF_".1"),-1) D
	..I 'ICDDA K ICDFDA S ICDFDA("80.5","+1,",.01)=ICDEFF K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") S ICDDA=$O(^ICDRS("B",ICDEFF_".1"),-1) I $D(ICDERR) D ERR S ICDSTOP=1 Q
	..S ICDIEN=$O(^ICDRS("B",ICDDA,""))
	..S ICDMIEN=$O(^ICDRS(ICDIEN,1,"B",ICDMDC,"")) I 'ICDMIEN D
	...K ICDFDA S ICDFDA("80.51","+1,"_ICDIEN_",",.01)=ICDMDC K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") S ICDMIEN=$O(^ICDRS(ICDIEN,1,"B",ICDMDC,"")) I $D(ICDERR) D ERR S ICDSTOP=1 Q
	..K ICDFDA S ICDFDA("80.511","+1,"_ICDMIEN_","_ICDIEN_",",.01)=ICDDRG,ICDFDA("80.511","+1,"_ICDMIEN_","_ICDIEN_",",1)=ICDORD
	..K ICDERR D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR S ICDSTOP=1 Q
	Q
	;
UP806	;#80.6 - ^ICDHAC (HAC)
	D BMES^XPDUTL("Starting #80.6 "_$$DTTIME)
	S ICDDX="" F  S ICDDX=$O(^ICDLD82("APPI",ICDDX)) Q:ICDDX=""  D
	.S ICDCODE=$E(ICDDX,1,3)_"."_$E(ICDDX,4,$L(ICDDX)),ICDDXIEN=$O(^ICD9("BA",ICDCODE_" ","")) I 'ICDDXIEN W !,"HAC: Code ",ICDCODE," not found in File #80" Q
	.S ICDHAC="" F  S ICDHAC=$O(^ICDLD82("APPI",ICDDX,ICDHAC)) Q:ICDHAC=""  D
	..S ICDX=^ICDLD82("APPI",ICDDX,ICDHAC),ICDPRIM=$S($P(ICDX,U,1)=1:1,1:0),ICDDESC=$P(ICDX,U,2)
	..S ICDIEN=$O(^ICDHAC("B",ICDHAC,"")) I 'ICDIEN D
	...K ICDFDA,ICDERR S ICDFDA(80.6,"+1,",.01)=ICDHAC,ICDFDA(80.6,"+1,",1)=ICDDESC
	...D UPDATE^DIE("S","ICDFDA","","ICDERR") I $D(ICDERR) D ERR
	...S ICDIEN=$O(^ICDHAC("B",ICDHAC,""))
	..I '$D(^ICDHAC("C",ICDDXIEN)) D
	...K ICDFDA,ICDERR S ICDFDA(80.62,"+1,"_ICDIEN_",",.01)=ICDDXIEN,ICDFDA(80.62,"+1,"_ICDIEN_",",1)=ICDPRIM
	...D UPDATE^DIE("S","ICDFDA","","ICDERR") I $D(ICDERR) D ERR
	Q
	;
8073(ICDFILE,ICDDX,ICDIDEN)	;
	; Input        ICDFILE = 80 or 80.1
	;              ICDDX = DX or PCS Code  Ex: A00.0 or 0TCS0ZZ
	;              ICDIDEN = Identifier  Ex: "A" or 44 or 245
	N ICDIEN,ICDF,ICDI,ICDX,ICDID,ICDIDIEN
	S ICDF=$S(ICDFILE=80:"^ICD9",1:"^ICD0"),ICDIEN=$O(@ICDF@("BA",ICDDX_" ","")) Q:ICDIEN=""
	S ICDF2=$S(ICDFILE=80:"80",1:"80.1")
	S ICDFT=$S(ICDFILE=80:"80.073",1:"80.173")
	S ICDFI=$S(ICDFILE=80:"^ICDID",1:"^ICDIP")
	S ICDIEN=$O(@ICDF@("BA",ICDDX_" ","")) I ICDIEN="" Q
	I $D(^ICDLD82("APPE","OPEDIT",ICDDX)) Q
	S ICDIDIEN=$O(@ICDFI@("B",ICDIDEN,"")) I ICDIDIEN'="" D
	.S ICD73IEN=$O(@ICDF@(ICDIEN,73,"B",ICDIDIEN,"")) I ICD73IEN="" D
	..K ICDFDA,ICDERR S ICDFDA(ICDFT,"+1,"_ICDIEN_",",.01)=ICDIDIEN D UPDATE^DIE("S","ICDFDA",,"ICDERR") I $D(ICDERR) D ERR Q
	Q
	;
ERR	;
	I $D(ICDERR("DIERR",1,"PARAM","FILE")) D BMES^XPDUTL("FileMan error - FILE: "_ICDERR("DIERR",1,"PARAM","FILE"))
	I $D(ICDERR("DIERR",1,"PARAM","IENS")) D BMES^XPDUTL("FileMan error - IENS: "_ICDERR("DIERR",1,"PARAM","IENS"))
	I $D(ICDERR("DIERR",1,"PARAM","TEXT")) D BMES^XPDUTL("FileMan error - TEXT: "_ICDERR("DIERR",1,"PARAM","TEXT"))
	Q
	;
DTTIME()	;
	S Y=$$NOW^XLFDT D DD^%DT
	Q Y
	;
	;ICD1882A