RMPRET	;Hines-OI/HNC - ITEM SERVER ;01/14/2005
	;;3.0;PROSTHETICS;**103,172**;Feb 09, 1996;Build 2
	;
	;DBIA # 10072 - for routine REMSBMSG^XMA1C
	;
	;Patch RMPR*3.0*172 For description change to insure prior 
	;                   description entirely removed before updating
	;                   with new description lines.
	;
EN	;Entry Point
	;HCPCS SERVER
	;
	;K ^TMP($J)
	X XMREC D
	.;check
	.S RMPRWHO3=XMRG
	.X XMREC S RMPRWHO1=XMRG
	.X XMREC S RMPRWHO2=XMRG
	.S RMPRWHO=$$DEC^RMPR4LI(RMPRWHO3,RMPRWHO1,RMPRWHO2)
	.S RMPRCHK=0
	.F  S RMPRCHK=$O(^RMPR(669.9,RMPRCHK)) Q:RMPRCHK>0
	.I RMPRWHO'=$P(^RMPR(669.9,RMPRCHK,"INV"),U,4) D NOGO Q
	D NOW^%DTC S RMPRWHN=%
	S CNT=6,RMPRDLM=","_"""I"""
	S (RMPRIEN,RMPRFLD,RMPRVL,RMPRIEN2)=""
	F  X XMREC Q:XMRG=""  D
	.;S RMPRMSG(CNT+10000)=$P(XMRG,RMPRDLM,1)_$P(XMRG,RMPRDLM,2)
	.S RMPRIEN=$P(XMRG,U,1)
	.S RMPRFLD=$P(XMRG,U,2)
	.S RMPRVL=$P(XMRG,U,3)
	.S RMPRIEN2=$P(XMRG,U,4)
	.I RMPRFLD=.01 S RMPRMSG(CNT)="HCPCS: "_RMPRVL
	.;S ^TMP($J,RMPRIEN,RMPRFLD)=RMPRVL
	.;check to see if new and add
	.I '$D(^RMPR(661.1,RMPRIEN)) D
	. .S $P(^RMPR(661.1,RMPRIEN,0),U,1)=RMPRVL
	. .S DIK="^RMPR(661.1,"
	. .S DA=RMPRIEN D IX1^DIK
	.S UPD(661.1,RMPRIEN_",",1.1)=RMPRWHN
	.S UPD(661.1,RMPRIEN_",",1.2)=XMFROM
	.I RMPRFLD="661.18" D
	. .;START DESCRIPTION
	. .I RMPRIEN2=1 D  K DIK,DA,DA(1)      ;RMPR*3.0*172 Clear current description in file before new description lines entered
	. . .F I=1:1:20 I $D(^RMPR(661.1,RMPRIEN,2,I,0)) S DA=I,DA(1)=RMPRIEN,DIK="^RMPR(661.1,"_DA(1)_",2," D ^DIK
	. . .K DIK,DA,DA(1),I,^RMPR(661.1,RMPRIEN,2,"B")
	. .S ^RMPR(661.1,RMPRIEN,2,RMPRIEN2,0)=RMPRVL
	. .S CNTIEN=0,CNTIEN1=0
	. .F  S CNTIEN=$O(^RMPR(661.1,RMPRIEN,2,CNTIEN)) Q:CNTIEN'>0  D
	. . .S CNTIEN1=CNTIEN1+1
	. .S ^RMPR(661.1,RMPRIEN,2,0)="^661.18^"_CNTIEN1_U_CNTIEN1
	. .S DIK="^RMPR(661.1,"
	. .S DA=RMPRIEN D IX1^DIK
	. .S RMPRFLD=""
	.I RMPRFLD="" Q
	.I RMPRFLD'=.01 S UPD(661.1,RMPRIEN_",",RMPRFLD)=RMPRVL
	.S CNT=CNT+1
	D FILE^DIE("","UPD","ERROR")
	I $D(ERROR("DIERR")) S RMPRMSG(1.1)="******* ERROR ENCOUNTERED*******"
	S XMDUZ=.5
	S XMY("G.RMPR SERVER")=""
	S XMY("VHACOPSASPIPReport@domain.ext")=""
	S XMSUB="PSAS HCPCS Item Server Update "_$P($$SITE^VASITE,U,2)
	S RMPRMSG(1)="The National PSAS Item Server has been activated today by Prosthetics HQ."
	S RMPRMSG(2)="Please print your HCPCS Mapping File."
	S RMPRMSG(3)=""
	S RMPRMSG(4)="This was activated by "_$P(XMFROM,"@",1)
	S RMPRMSG(5)=""
	S XMTEXT="RMPRMSG("
	D ^XMD
	G EXIT
	Q
NOGO	;message not valid
	S XMDUZ=.5
	S XMY("G.RMPR SERVER")=""
	S XMY("VHACOPSASPIPReport@domain.ext")=""
	S XMSUB="**ERROR** Not Authorized HCPCS Item Server Update From "_$P($$SITE^VASITE,U,2)
	S RMPRMSG(1)="The National PSAS Item Server was unsuccessful today."
	S RMPRMSG(2)="****ERROR**** Not Authorized!"
	S RMPRMSG(3)=""
	S RMPRMSG(4)="This was activated by "_XMFROM
	S XMTEXT="RMPRMSG("
	D ^XMD
	;
EXIT	;common exit point
	S XMSER="S."_XQSOP,XMZ=XQMSG D REMSBMSG^XMA1C
	K %,CNT,DA,DIK,ERROR,RMPRDL,RMPRFLD,RMPRIEN2,RMPRMSG,RMPRVL,RMPRWHN
	K UPD,XMDUZ,XMFROM,XMREC,XMRG,XMSUB,XMTEXT,XMY,RMPRIEN,RMPRDLM,CNTIEN,CNTIEN1
	K RMPRWHO,RMPRWHO1,RMPRWHO2,RMPRWHO3,XMSER,RMPRCHK,XMZ,XQMSG,XQSOP
	;END
