PXRMMSG	;SLC/PKR - Routine for sending MailMan messages. ;04/14/2015
	;;2.0;CLINICAL REMINDERS;**17,18,53,47**;Feb 04, 2005;Build 291
	;
	;======================================================================
SEND(NODE,SUBJECT,TO,FROM)	;Send a MailMan message whose text is in
	;^TMP(NODE,$J,N,0). SUBJECT is the subject. TO is the optional
	;list of addresses, setup exactly like the MailMan XMY array.
	;If TO is not defined try to send to the  Clinical Reminders mail
	;group. If that is not defined send to the user. FROM is the
	;optional message from, if it is not defined then from will be
	;Clinical Reminders Support. This can be free text or a DUZ.
	N MGIEN,MGROUP,NL,REF,XMDUZ,XMSUB,XMY,XMZ
	;
	;If this is a test run write out the message.
	I $G(PXRMDEBG) D
	. S REF="^TMP(NODE,$J)"
	. D AWRITE^PXRMUTIL(REF)
	;
	;Make sure the subject does not exceed 64 characters.
	S XMSUB=$E(SUBJECT,1,64)
	;
	;If FROM is defined as DUZ make sure it is a valid user.
	S FROM=$G(FROM)
	I (FROM=DUZ),($$NEWS^XMXUTIL(FROM,1)=-1) S FROM="DUZ="_DUZ_", this is not a valid MailMan user."
	;
	;Make the default sender Clinical Reminders.
	S XMDUZ=$S(FROM="":"Clinical Reminders Support",1:FROM)
	;
RETRY	;Get the message number.
	D XMZ^XMA2
	I XMZ<1 G RETRY
	;
	;Load the message
	M ^XMB(3.9,XMZ,2)=^TMP(NODE,$J)
	K ^TMP(NODE,$J)
	S NL=$O(^XMB(3.9,XMZ,2,""),-1)
	S ^XMB(3.9,XMZ,2,0)="^3.92^"_+NL_U_+NL_U_DT
	;
	;Send message only to the TO list if it is defined.
	I $D(TO)=10 M XMY=TO D ENT1^XMD Q
	;Send the message to the site defined mail group or the user if
	;there is no mail group.
	S MGIEN=$G(^PXRM(800,1,"MGFE"))
	S MGROUP=$S(MGIEN'="":"G."_$$GET1^DIQ(3.8,MGIEN,.01),1:DUZ)
	S XMY(MGROUP)=""
	D ENT1^XMD
	Q
	;
	;==========================================
SENDIM(BUILD)	;Send install message for a build.
	N FROM,NODE,SYSTEM,SUBJECT,TO
	S NODE=BUILD
	K ^TMP(NODE,$J)
	;DBIA #1131 for ^XMB("NETNAME")
	S FROM=BUILD_" Install@"_^XMB("NETNAME")
	;DBIA #2541
	S SYSTEM=$$KSP^XUPARAM("WHERE")
	I $$PROD^XUPROD(1) S TO("G.CLINICAL REMINDERS SUPPORT@DOMAIN.EXT")=""
	E  D
	. N MGIEN,MGROUP
	. S MGIEN=$G(^PXRM(800,1,"MGFE"))
	. S MGROUP=$S(MGIEN'="":"G."_$$GET1^DIQ(3.8,MGIEN,.01),1:DUZ)
	. S TO(MGROUP)=""
	S SUBJECT="Install of "_BUILD
	S ^TMP(NODE,$J,1,0)="Build "_BUILD_" has been installed."
	S ^TMP(NODE,$J,2,0)="System is "_SYSTEM_"."
	D SEND^PXRMMSG(NODE,SUBJECT,.TO,FROM)
	Q
	;
