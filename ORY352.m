ORY352	;SLC/RFR - PRE/POST INSTALL FOR PATCH OR*3.0*352 ;02/09/2012 13:07
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**352**;Dec 17, 1997;Build 18
	Q
PRE	;PRE-INSTALL SECTION
	;DELETE THE EXISTING DD FOR FILE 100.05 (KIDS WILL INSTALL A NEW DD)
	N DIU
	D BMES^XPDUTL("Deleting the data dictionary for file ORDER CHECK INSTANCES (#100.05)...")
	S DIU="^ORD(100.05,",DIU(0)=""
	D EN^DIU2
	D BMES^XPDUTL("Successfully deleted the data dictionary.")
	Q
QUEUE	;QUEUE THE POST-INSTALL SECTION
	N ORMSG,XPDIDTOT
	N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSK
	S XPDIDTOT=1
	D UPDATE^XPDID(0)
	D BMES^XPDUTL("Queueing the post-install task...")
	S ZTRTN="POST^ORY352",ZTDESC="OR*3.0*352 POST INSTALL"
	S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT,0,0,0,10)
	S ZTIO=""
	D ^%ZTLOAD
	I +$G(ZTSK)=0 D
	.S ORMSG(1)=" ",ORMSG(2)="Unable to queue the post-install."
	.D MES^XPDUTL(.ORMSG)
	E  D BMES^XPDUTL("Successfully queued post-install; task #"_ZTSK)
	D UPDATE^XPDID(1)
	Q
POST	;POST-INSTALL SECTION
	N ORLIMIT,ORIEN,ORIDX,ORLINE,ORBODY
	N XMMG,XMDUZ,XMY,XMSUB,XMTEXT,XMZ,XMERR,XPDIDTOT,DIFROM,XMK
	;REMOVE DATA STORED IN NODE ^ORD(100.05,D0,16) WHILE PRESERVING DESCENDANTS
	S ORIEN=0 F  S ORIEN=$O(^ORD(100.05,ORIEN)) Q:+$G(ORIEN)=0  D
	.Q:$D(^ORD(100.05,ORIEN,16))<11
	.K ^TMP($J,"ORMONO")
	.M ^TMP($J,"ORMONO")=^ORD(100.05,ORIEN,16)
	.K ^ORD(100.05,ORIEN,16)
	.S ORIDX=0,ORLINE=1 F  S ORIDX=$O(^TMP($J,"ORMONO",ORIDX)) Q:+$G(ORIDX)=0  D
	..S ^ORD(100.05,ORIEN,16,ORLINE,0)=^TMP($J,"ORMONO",ORIDX,0),ORLINE=ORLINE+1
	.S ORLINE=$O(^ORD(100.05,ORIEN,16,"?"),-1)
	.S ^ORD(100.05,ORIEN,16,0)=U_U_ORLINE_U_ORLINE_U_$P(^TMP($J,"ORMONO",0),U,5)_U
	K ^TMP($J,"ORMONO")
	;SEND COMPLETION EMAIL
	S ORBODY(1)="Post-installation successfully completed."
	S ORBODY(2)=""
	S ORBODY(3)="Please delete the post-install routine ORY352 using the"
	S ORBODY(4)="Kernel Toolkit option Delete Routines [XTRDEL] as follows:"
	S ORBODY(5)="ROUTINE DELETE"
	S ORBODY(6)=""
	S ORBODY(7)="All Routines? No => No"
	S ORBODY(8)=""
	S ORBODY(9)="Routine: ORY352"
	S ORBODY(10)="Routine: "
	S ORBODY(11)="1 routine"
	S ORBODY(12)=""
	S ORBODY(13)="1 routines to DELETE, OK: NO// YES"
	S ORBODY(14)="ORY352"
	S ORBODY(15)="Done."
	S XMY(DUZ)=""
	S XMSUB="PATCH OR*3.0*352 POST-INSTALLATION REPORT"
	S XMTEXT="ORBODY("
	D ^XMD
	I $D(XMMG)=0 D
	.S XMK=$$BSKT^XMAD2("IN",+DUZ)
	.D:+XMK>0 MAKENEW^XMXUTIL(DUZ,+XMK,XMZ,1)
	Q