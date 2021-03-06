PSAVER6	;BIR/JMB-Verify Invoices - CONT'D ;10/3/97
	;;3.0;DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**1,3,21,42,53,57,61,64,76**; 10/24/97;Build 1
	;Background Job:
	;References to ^PSDRUG( are covered by IA #2095
	;This routine increments pharmacy location and master vault balances
	;in 58.8 after invoices have been verified.
	;
START	;|=> *42 add Post Verify variance report
	K ^TMP($J,"PSADD")
	K DIC,DA,DR,DIE  ;|=> *52 MOVE POST VERIFY E-MAIL LOGIC FROM START+17
	S PSAIEN=0  F  S PSAIEN=+$O(PSAVBKG(PSAIEN)) Q:'PSAIEN  D
	.Q:'$D(^PSD(58.811,PSAIEN,0))
	.S PSAORD=$P(^PSD(58.811,PSAIEN,0),"^"),PSAVEND=$P(^(0),"^",2),PSAIEN1=0
	.F  S PSAIEN1=+$O(PSAVBKG(PSAIEN,PSAIEN1)) Q:'PSAIEN1  D
	..Q:'$D(^PSD(58.811,PSAIEN,1,PSAIEN1,0))
	..D SCANDIF  ; *57 <=|
	S PSAIEN=0  F  S PSAIEN=+$O(PSAVBKG(PSAIEN)) Q:'PSAIEN  D
	.Q:'$D(^PSD(58.811,PSAIEN,0))
	.S PSAORD=$P(^PSD(58.811,PSAIEN,0),"^"),PSAVEND=$P(^(0),"^",2),PSAIEN1=0
	.F  S PSAIEN1=+$O(PSAVBKG(PSAIEN,PSAIEN1)) Q:'PSAIEN1  D
	..Q:'$D(^PSD(58.811,PSAIEN,1,PSAIEN1,0))
	..S PSAIN=^PSD(58.811,PSAIEN,1,PSAIEN1,0)
	..K DIC,DA,DR,DIE
	..I +$P(PSAIN,"^",13) K DA S DIE="^PSD(58.811,"_PSAIEN_",1,",DA(1)=PSAIEN,DA=PSAIEN1,DR="2////C" D ^DIE K DIE,DA,DR Q
	..S PSAINV=$P(PSAIN,"^"),PSAINVDT=$P(PSAIN,"^",2),PSALINE=0
	..F  S PSALINE=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE)) Q:'PSALINE  D
	...Q:'$D(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,0))
	...S PSADATA=^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,0) D GETDATA I 'PSASUP,'$D(PSA0QTY) D FILE ;PSA*3*42
	..K DIC,DA,DR,DIE
	..K DA S DIE="^PSD(58.811,"_PSAIEN_",1,",DA(1)=PSAIEN,DA=PSAIEN1,DR="2////C" D ^DIE K DIE,DA,DR
	;;*57 => START+17 THRU START+22 MOVED TO START+3 <=|
	; *42 <=|
EXIT	;Kills variables
	K %,DA,DD,DIC,DIE,DINUM,DLAYGO,DO,PSA,PSAA,PSABAL,PSACBAL,PSACNT,PSACNT,PSACOD,PSACOST,PSACS,PSADASH,PSADATA,PSADJ,PSADJD,PSADJO,PSADJP,PSADJQ
	K PSADRG,PSADT,PSADUOU,PSADUQTY,PSADUREC,PSAIEN,PSAIEN1,PSAIN,PSAINV,PSAINVDT,PSALEN,PSALINE,PSALOC,PSAMSG,PSANDC,PSANODE,PSANPDU,PSANPOU
	K PSAODASH,PSAONDC,PSAORD,PSAOU,PSAPDU,PSAPOU,PSAQTY,PSAREORD,PSASET,PSASTOCK,PSASUP,PSAT,PSATDRG,PSATEMP,PSAVBKG,PSAVDUZ,PSAVEND,PSAVSN,X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,Y
	K PSA0QTY
	Q
	;
GETDATA	;Gets invoice data to help file the data
	S PSAVDUZ=$P(PSADATA,"^",9),PSASUP=0 K PSA0QTY  ;; <<RJS-3*76??
	S PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","D",0))
	I '$G(PSADJ) S PSADRG=$S(+$P(PSADATA,"^",2):+$P(PSADATA,"^",2),1:0) G CS
	I $G(PSADJ) D
	.S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0))
	.S PSADJD=$S($P(PSANODE,"^",6)'="":$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
	.I PSADJD'?1.N S PSASUP=1
	.S PSADRG=$S(PSADJ&('PSASUP):+PSADJD,PSADJ&(PSASUP):0,1:+$P(PSADATA,"^",2))
	.I +PSADJD,$L(PSADJD)=$L(+PSADJD),$P($G(^PSDRUG(+PSADJD,0)),"^")'="" S PSADRG=+PSADJD Q
	.I +PSADJD,$L(PSADJD)=$L(+PSADJD),$P($G(^PSDRUG(+PSADJD,0)),"^")="" S (PSADJ,PSADRG)=0 Q
CS	Q:PSASUP!('PSADRG)
	S PSACS=$S(+$P(PSADATA,"^",10):1,1:0)
	S PSADJQ=0,PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","Q",0))
	I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJQ=$S($P(PSANODE,"^",6)'="":+$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
	;
	;PSA*3*1  (DAVE B)
	S PSAQTY=$S(($G(PSADJQ)'=""&(+PSADJ)):PSADJQ,1:+$P(PSADATA,"^",3))
	S PSAOU=$S(+$P(PSADATA,"^",4):+$P(PSADATA,"^",4),1:"")
	;
	;DAVE B (PSA*3*3)
	;I +$P($P($G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,2)),"^",5),"~",2) S PSAOU=$P($P($G(^(2)),"^",5),"~",2)
	;
	S PSADJO=0,PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","O",0))
	I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJO=$S($P(PSANODE,"^",6)'="":$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
	S:$G(PSADJO) PSAOU=$G(PSADJO)
	S PSANDC=$P(PSADATA,"^",11) D PSANDC1^PSAHELP S PSADASH=PSANDCX K PSANDCX
	S PSADJP=0,PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","P",0))
	I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJP=$S(+$P(PSANODE,"^",6):+$P(PSANODE,"^",6),1:+$P(PSANODE,"^",2))
	S (PSAPOU,PSANPOU)=$S($G(PSADJP):PSADJP,1:+$P(PSADATA,"^",5)),PSALEN=$L($P(PSANPOU,".")),(PSAPOU,PSANPOU)=$J(PSANPOU,PSALEN,2)
	S PSAVSN=$P(PSADATA,"^",12)
	S PSALOC=$S(+PSACS:+$P(PSAIN,"^",12),1:+$P(PSAIN,"^",5))
TEMP	S PSATEMP=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,2))
	S PSADUOU=+$P(PSATEMP,"^"),PSAREORD=+$P(PSATEMP,"^",2),PSASUB=+$P(PSATEMP,"^",3),PSASTOCK=+$P(PSATEMP,"^",4)
	S PSADUOU=$S(+PSADUOU:+PSADUOU,+PSASUB&(+$P($G(^PSDRUG(PSADRG,1,PSASUB,0)),"^",7)):+$P($G(^PSDRUG(PSADRG,1,PSASUB,0)),"^",7),1:1)
	S PSADUREC=$S(PSADUOU:PSAQTY*PSADUOU,1:0)
	;
	;DAVE B (18NOV98)
	I PSADUREC=0,$D(PSAQTY),$P($G(^PSDRUG(PSADRG,660)),"^",5)'="" S PSADUREC=(PSAQTY*($P(^PSDRUG(PSADRG,660),"^",5)))
	Q:'+$P($G(^PSD(58.8,PSALOC,0)),"^",14)
	S PSAREORD=$S(+PSAREORD:+PSAREORD,+$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",5):+$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",5),1:0)
	S PSASTOCK=$S(+PSASTOCK:+PSASTOCK,+$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",3):+$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",3),1:0)
	K PSA0QTY I '$G(PSAQTY),'$G(PSADJQ) S PSA0QTY=1 Q  ;PSA*3*42 (0 QTY)
	Q
	;
FILE	;File data in 58.8
	I $D(PSADUREC),PSADUREC'>0 S PSADUREC=$S($D(PSADJQ):PSADJQ,$D(PSAQTY):PSAQTY,1:0)
	D NOW^%DTC S PSADT=+$E(%,1,14)
	I '$D(^PSD(58.8,PSALOC,1,PSADRG,0)) D
	.K DIC,DA,DR,DIE
	.S:'$D(^PSD(58.8,PSALOC,1,0)) DIC("P")=$P(^DD(58.8,10,0),"^",2)
	.S DA(1)=PSALOC,DIC="^PSD(58.8,"_DA(1)_",1,",(DA,DINUM,X)=PSADRG,DIC(0)="L",DLAYGO=58.8
	.F  L +^PSD(58.8,PSALOC,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
	.D FILE^DICN L -^PSD(58.8,PSALOC,0) K DIC,DA,DLAYGO
	.D MM ;*42 send mailmessage
	F  L +^PSD(58.8,PSALOC,1,PSADRG,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
	S PSABAL=+$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",4)
	;
	;DAVE B (PSA*3*3)
	I $P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",1)'=PSADRG S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",1)=PSADRG
	S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",4)=PSADUREC+PSABAL
	I +$P($G(^PSD(58.8,PSALOC,0)),"^",14) D
	.I PSASTOCK'=$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",3) S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",3)=PSASTOCK
	.I PSAREORD'=$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",5) S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",5)=PSAREORD
	S:'$D(^PSD(58.8,PSALOC,1,PSADRG,5,0)) DIC("P")=$P(^DD(58.8001,20,0),"^",2)
	I '$D(^PSD(58.8,PSALOC,1,PSADRG,5,$E(DT,1,5)*100,0)) D
	.K DIC,DA,DR,DIE
	.S DIC="^PSD(58.8,"_PSALOC_",1,"_PSADRG_",5,",DIC(0)="L",DIC("DR")="1////^S X=$G(PSABAL)"
	.S (X,DINUM)=$E(DT,1,5)*100,DA(2)=PSALOC,DA(1)=PSADRG,DLAYGO=58.8 D ^DIC K DIC("DR")
	.S X="T-1M" D ^%DT S (X,DINUM)=$E(Y,1,5)*100,DA=PSADRG D ^DIC K DIC,DLAYGO
	.K DIC,DA,DR,DIE
	.S DA=+Y,DA(2)=PSALOC,DA(1)=PSADRG,DIE="^PSD(58.8,"_DA(2)_",1,"_DA(1)_",5,",DR="3////^S X=$G(PSABAL)" D ^DIE K DIE
	K DIC,DA,DR,DIE
	S DA=$E(DT,1,5)*100
	S DA(2)=PSALOC,DA(1)=PSADRG,DIE="^PSD(58.8,"_DA(2)_",1,"_DA(1)_",5,",DA=$E(DT,1,5)*100,DR="3////^S X=($G(PSABAL)+$G(PSADUREC));5////^S X="_($P($G(^(0)),"^",3)+PSADUREC) D ^DIE K DIE
	L -^PSD(58.8,PSALOC,1,PSADRG,0)
	G TR^PSAVER7
MM	;
	;*42 Mail Message to holders of PSDMGR, PSAMGR key
	;*53 Consolidate messages
	N PSACS S PSACS=$S($$GET1^DIQ(50,PSADRG,63)["N":" Controlled Substance ",1:"")
	S ^TMP($J,"PSADD",$$GET1^DIQ(58.8,PSALOC,.01),$$GET1^DIQ(50,PSADRG,.01))=""
	Q
SCANDIF	;*42 inspect invoice for noted differences in OU,DUOU,PPDU,NDC
	;NEEDS PSAIEN, PSAIEN1
	K ^TMP($J,"PSADIF"),PSADIFLC
	S PSALINE=0 F  S PSALINE=$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE)) Q:PSALINE'>0  D CHECK^PSAPROC7 ;checks and stores differences in ^TMP($J,
	I $D(^TMP($J,"PSADD")) D ADDMM
	I $D(^TMP($J,"PSADIF")) D MESSAGE
	Q
MESSAGE	;differences found, notify user and send message to g.PSA NDC UPDATES.
	K DIR N IENS
	S PSAORD=$$GET1^DIQ(58.811,PSAIEN,.01),IENS=PSAIEN1_","_PSAIEN
	S PSAINV=$$GET1^DIQ(58.8112,IENS,.01)
	S XMSUB="POST Verify  Variance Report Ord: "_PSAORD_" Inv: "_PSAINV ;*52
	S ^TMP($J,"PSADIF",1,0)=XMSUB,^TMP($J,"PSADIF",2,0)=" "
	S XMTEXT="^TMP($J,""PSADIF"",",XMY("G.PSA NDC UPDATES")=""
	S XMDUZ="Price & NDC Updater"
	D ^XMD
	K PSADIFLC,^TMP($J,"PSADIF")
	Q
ADDMM	; SEND MESSAGE REGARDING DRUGS ADDED TO PHARMACY LOCATIONS
	K ^TMP($J,"PSADDMM")
	S XMSUB="New Drugs Added by Order: "_$G(PSAORD)_" Invoice: "_$G(PSAINV)
	S XMDUZ="Verified by: "_$$GET1^DIQ(200,DUZ,.01)
	S LC=0,X=XMSUB D MMLINE S X=XMDUZ D MMLINE
	S X="Please use DA and CS menus to populate the balances, stock and re-order levels." D MMLINE
	S PSALOC="" F  S PSALOC=$O(^TMP($J,"PSADD",PSALOC)) Q:PSALOC=""  D
	. S X=PSALOC D MMLINE
	. S PSADRG="" F  S PSADRG=$O(^TMP($J,"PSADD",PSALOC,PSADRG)) Q:PSADRG=""  S X="     "_PSADRG D MMLINE
	S XMTEXT="^TMP($J,""PSADDMM"","
	S XMY("G.PSA NDC UPDATES")=""
	D ^XMD
	K ^TMP($J,"PSADD"),^TMP($J,"PSADDMM"),LC
	Q
MMLINE	S LC=LC+1,^TMP($J,"PSADDMM",LC,0)=X W !,X Q
