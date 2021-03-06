PRCOVUP	;WISC/DJM/AS-VENDOR UPDATE SERVER ROUTINE ; 17 Dec 2009  11:05 AM
V	;;5.1;IFCAP;**81,144**;Oct 20, 2000;Build 2
	;Per VHA Directive 10-93-142, this routine should not be modified.
	;;
IN	;THIS ROUTINE WILL BE CALLED FROM THE 'FMS' SERVER VIA FILE 423.5
	;ENTRY FOR THE VENDOR UPDATE TRANSACTION (VUP).
	;PRCDA IS THE INTERNAL ENTRY NUMBER FOR THE RECORD FROM FILE 423.6.
	N AAN,AAC,ALTADD,ENTRY1,II,LOOP,PRCMG,PRCXM,LINE,STATION,STCK,ENTRY,ENCK,VEN3,VEN7,MGP,NAME,DIE,DR,DA,MTI,FMSVC,ZIP,%X,%Y,ALTFLG,FMS,ACTIVE
	S LINE=$G(^PRCF(423.6,PRCDA,1,10000,0))
	S MGP=$O(^PRCF(423.5,"B",$P(LINE,U)_"-"_$P(LINE,U,5),0))
	S MGP=$G(^PRCF(423.5,MGP,0))
	S PRCMG=$P($G(^XMB(3.8,$P(MGP,U,2),0)),U)
	S LOOP=10000
	F  S LOOP=$O(^PRCF(423.6,PRCDA,1,LOOP)) Q:LOOP'>0  D FIND Q:LINE["{"  I $D(PRCXM) S PRCXM(4)=LINE D PERROR
	D KILL^PRCOSRV3(PRCDA)
	Q
	;
FIND	S LINE=$G(^PRCF(423.6,PRCDA,1,LOOP,0))
	Q:LINE["{"
	S STATION=$P(LINE,U,4)
	I STATION="" S PRCXM(1)=$P($T(ERROR+4),";;",2) Q
	S STCK=$O(^PRC(411,"B",STATION,0))
	I STCK'>0 S PRCXM(1)=$P($T(ERROR+1),";;",2) Q
	K ACTIVE
	S ENTRY=$P(LINE,U,5)
	I ENTRY>0 S ACTIVE=1 D ENCK
	S (ENTRY1,ALTFLG)=0
	S FMS=$P(LINE,U,6)
	I FMS="" S PRCXM(3)=$P($T(ERROR+3),";;",2) Q
	S AAC=$P(LINE,U,7)
	F  S ENTRY1=$O(^PRC(440,"D",FMS,ENTRY1)) Q:ENTRY1'>0  D  Q:$D(PRCXM)  I ALTFLG=1 S ENTRY=ENTRY1 D ENCK I $D(PRCXM) S PRCXM(4)=LINE D PERROR
	.S VEN3=$G(^PRC(440,ENTRY1,3))
	.I VEN3="" S PRCXM(2)=$P($T(ERROR+2),";;",2),PRCXM(4)=LINE D PERROR Q
	.S ALTADD=$P(VEN3,U,5) I ALTADD=AAC S ALTFLG=1
	.Q
	Q
	;
ENCK	S ALTFLG=0
	S ENCK=$G(^PRC(440,ENTRY,0))
	I ENCK="" S PRCXM(2)=$P($T(ERROR+2),";;",2) Q
	K ^PRC(440.3,ENTRY)
	S %Y="^PRC(440.3,ENTRY,"
	S %X="^PRC(440,ENTRY,"
	D %XY^%RCR
	S VEN3=$G(^PRC(440,ENTRY,3))
	I $P(LINE,U,7)]"" S $P(VEN3,U,5)=$P(LINE,U,7)
	I $P(LINE,U,14)]"" S $P(VEN3,U,9)=$P(LINE,U,14)
	S $P(VEN3,U,12)="C"
	I $P(LINE,U,15)]"" S $P(VEN3,U,11)=$P(LINE,U,15)
	I $P(LINE,U,16)]"" S $P(VEN3,U,14)=$P(LINE,U,16)
	I $P(LINE,U,17)]"" S $P(VEN3,U,13)=$P(LINE,U,17)
	I $P(LINE,U,19)]"" S $P(VEN3,U,15)=$P(LINE,U,19)
	I $P(LINE,U,20)]"" S $P(VEN3,U,10)=$P(LINE,U,20)
	;set fms vendor name (field is uneditable)
	S NAME=$P(LINE,U,8)
	I NAME]"" D
	.F II=1:1 S AAN=$E(NAME,II) Q:AAN?1AN  S NAME=$E(NAME,2,99)
	.S $P(VEN3,U,7)=NAME
	.Q
	S VEN7=$G(^PRC(440,ENTRY,7))
	I $P(LINE,U,9)]"" S $P(VEN7,U,3)=$P(LINE,U,9)
	I $P(LINE,U,10)]"" S $P(VEN7,U,4)=$P(LINE,U,10)
	I $P(LINE,U,11)]"" S $P(VEN7,U,7)=$P(LINE,U,11)
	S ZIP=$P(LINE,U,13) I ZIP]"" D
	.S $P(VEN7,U,9)=$S($L(ZIP)=9:$E(ZIP,1,5)_"-"_$E(ZIP,6,9),1:ZIP)
	.Q
	I $P(LINE,U,12)]"" S $P(VEN7,U,8)=$O(^DIC(5,"C",$P(LINE,U,12),0))
	S ^PRC(440,ENTRY,3)=VEN3
	S ^PRC(440,ENTRY,7)=VEN7
	S DIE="^PRC(440,"
	S DA=ENTRY
	S FMSVC=$P(LINE,U,6)
	S DR="34////^S X=FMSVC"
	S NAME=$P(ENCK,U)
	S MTI="" I $P(LINE,U,19)]"" S MTI=$P(LINE,U,19)
	I MTI="D" S NAME="**"_NAME,DR=DR_";.01////^S X=NAME;31.5////^S X=1;15////@"
	I $G(ACTIVE),"ACF"[MTI,$E(NAME,1,2)="**" S NAME=$E(NAME,3,99),DR=DR_";.01////^S X=NAME;31.5////@;15////@"
	D ^DIE
	D BUL^PRCOVUP4
	;   SEND VENDOR UPDATE INFORMATION TO DYNAMED  **81**
	D:$$GET^XPAR("SYS","PRCV COTS INVENTORY",1)=1 ONECHK^PRCVNDR(ENTRY)
	K ^PRC(440.3,ENTRY),ACTIVE
	Q
	;
ERROR	;HERE IS THE LIST OF ERROR MESSAGES
	;;The STATION number from FMS cannot be found at this location.
	;;The VENDOR file entry returned from FMS cannot be found.
	;;This FMS transaction has no FMS VENDOR CODE.
	;;The Station number is missing.  Possible corrupt record.
	;;There is no mailgroup listed for CTL-VUP in file 423.5.
	;
PERROR	; Process Errors for VUP type records
	N PRCEND,XMB,XMCHAN,XMDUN,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
	S PRCEND=""
	I $D(PRCMG) S:PRCMG'["G." PRCMG="G."_PRCMG
	S XMDUZ="IFCAP FMS MESSAGE SERVER",XMCHAN=1
	I '$D(PRCMG) S PRCXM(2)=$P($T(ERROR+5),";;",2),XMY(.5)=""
	D EMFORM S XMDUN="IFCAP SERVER ERROR"
	S XMSUB="Vendor Update Transaction (VUP)"
	S XMTEXT="PRCXM(",XMY(PRCMG)=""
	D ^XMD
	K PRCXM
	Q
	;
EMFORM	; Error message formatter
	I $D(PRCDA),$D(^PRCF(423.6,PRCDA,1,10000,0)) N I,J D
	.N THDR,TDATE,Y S THDR=^PRCF(423.6,PRCDA,1,10000,0)
	.S Y=$P(THDR,U,10),Y=($E(Y,1,4)-1700)_$E(Y,5,8) D DD^%DT S TDATE=Y
	.F I=1:1 S J=$O(PRCXM(I)) Q:J=""
	.S I=I+1,PRCXM(I)=" ",I=I+1,PRCXM(I)="  System ID: "_$P(THDR,U,2),I=I+1
	.S PRCXM(I)=" ",I=I+1,PRCXM(I)="  Receiving Station #: "_$P(THDR,U,4)_"                "_"Transaction Code : "_$P(THDR,U,5),I=I+1
	.S PRCXM(I)=" ",I=I+1,PRCXM(I)="  Transaction Date : "_TDATE_"         "_"Transaction Time : "_$E($P(THDR,U,11),1,2)_":"_$E($P(THDR,U,11),3,4)_":"_$E($P(THDR,U,11),5,6),I=I+1
	.S PRCXM(I)=" ",I=I+1,PRCXM(I)="  Interface Version #: "_$P(THDR,U,14),I=I+1
	.Q
	Q
