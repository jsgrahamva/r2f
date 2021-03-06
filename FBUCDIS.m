FBUCDIS	;AISC/TET - DISPLAY UNAUTHORIZED CLAIM(583) ;4/18/2014
	;;3.5;FEE BASIS;**32,151**;JAN 30, 1995;Build 14
	;;Per VA Directive 6402, this routine should not be modified.
EN	D HOME^%ZIS N FBCRT,FBHIST,FBOUT,FBPG,FBX S FBOUT=0,FBCRT=$S($E(IOST,1,2)="C-":1,1:0),FBPG=0
	W !! D IEN^FBUCUTL3 G:'FBIEN END ;select claim
	; ask if list for just mill-bill (1725) or just non-mill bill claims
	S FB1725R=$$ASKMB^FBUCUTL9 I FB1725R="" G END
	D DISP7^FBUCUTL5(FBIX,FBIEN,0,FB1725R) ;set array of claims
	D DISPX^FBUCUTL1(0) ;display claims
	S FBAR=$G(^TMP("FBAR",$J,"FBAR")) I 'FBAR G END ;W !!,"No data on file." G EN
	S FBOUT=0,DIR("??")="^D DISPX^FBUCUTL1(0)",DIR(0)="N^1:"_+FBAR_":0",DIR("A")="Select the claim which you would like to display" D ^DIR K DIR S:$D(DIRUT) FBOUT=1 G END:+$G(FBOUT),EN:'+Y
	S FBDA=+$G(^TMP("FBAR",$J,+Y))
	;
	; conditionally ask if historical audit data should be shown
	S FBHIST=$O(^FB583(FBDA,"LOG2",0))
	I 'FBHIST D  G:$G(FBOUT) END
	. W !!,"Note: Historical audit data not available for this claim."
	. D CR
	I FBHIST D  G:$G(FBOUT) END
	. S DIR(0)="Y",DIR("A")="Show historical audit data",DIR("B")="NO"
	. D ^DIR K DIR S:$D(DIRUT) FBOUT=1 Q:$G(FBOUT)  S FBHIST=Y
	;
DIS	;display claim
	D PAGE
	S DA=FBDA,DR="0:LOG",DIQ(0)="C",DIC="^FB583(" D EN^DIQ K DIQ
	K FBAR,^TMP("FBAR",$J)
	;
HIST	; display historical audit data if requested
	I FBHIST D
	. I IOSL<($Y+20) D PAGE Q:FBOUT
	. S FBX="< HISTORICAL AUDIT DATA (since patch FB*3.5*151) >"
	. W !!?(IOM-$L(FBX)/2),FBX,!
	. S DIC="^FB583(",DA=FBDA,DR="LOG2" D EN^DIQ
	G:FBOUT END
	;
PEND	;display incomplete items if information pending
	I $$PEND^FBUCUTL(FBDA) D
	. I IOSL<($Y+10) D PAGE Q:FBOUT
	. S FBX="< PENDING INFORMATION >" W !!?(IOM-$L(FBX)/2),FBX,!
	. D DISP8^FBUCUTL5(FBDA),DISPX^FBUCUTL1(0) K FBAR,^TMP("FBAR",$J)
	G:FBOUT END
	;
PAY	;check if any payments
	I $$PAY^FBUCUTL(FBDA,"FB583(") D
	. I IOSL<($Y+5) D PAGE Q:FBOUT
	. S FBX="< PAYMENTS ON FILE >" W !!?(IOM-$L(FBX)/2),FBX,!
	G:FBOUT END
	;
LINK	;check for associates
	I $$LINK^FBUCLNK1(FBDA,FBIX,1) D
	. I IOSL<($Y+10) D PAGE Q:FBOUT
	. S FBX="< ASSOCIATED CLAIMS >" W !!?(IOM-$L(FBX)/2),FBX,!
	. D DISPX^FBUCUTL1(0)
	G:FBOUT END
	;
END	;kill and quit
	K DA,DR,DFN,DIC,DIRUT,DTOUT,DUOUT,FB,FBAAOUT,FBDA,FBDX,FBI,FBIEN,FBIN,FBIX,FBLISTC,FBVEN,FBVID,J,K,Q,S,VA,VADM,X,Y,ZZ,FBPROC,L,VAERR,FBINODE,FBNODE,FBPRGNAM,FBPROG,FB1725R D KILL^FBPAY
	K FBARY,^TMP("FBARY",$J),^TMP("FBAR",$J) Q
PAGE	;write new page
	D:FBCRT&(FBPG>0) CR Q:FBOUT
HDR	W:FBCRT!(FBPG>0) @IOF S FBPG=FBPG+1
	;W !,FBHDR,!?70,"Page: ",FBPG,!,$S(FBIX="AVMS":"Veteran",1:"Vendor"),?34,"Fee Program",?53,"Status",?75,"Code",!,FBDASH
	Q
CR	;ask end of page prompt
	;OUTPUT: FBOUT is set if time out or up arrow out
	W ! S DIR(0)="E" D ^DIR S:$D(DTOUT)!($D(DUOUT)) FBOUT=1
	Q
	S FBDA=FBDA_";FB583(",FBLISTC=1,FBOUT=0,FBAAOUT="",Q="",$P(Q,"-",80)="-",FB("PD")=0
	F FBI=0:0 S FBI=$O(^FBAAI("E",FBDA,FBI)) Q:FBI'>0!(FBAAOUT)  S FBNODE=$G(^FBAAI(FBI,0)) I FBNODE]"" S FB("PD")=FB("PD")+$P(FBNODE,U,9) D VET^FBCHDI S FB("DFN")=DFN D EN^FBCHDI Q:$G(FBOUT)
	D END G EN
HED	W !?25,"ASSOCIATED INVOICES",!,?24,$E(Q,1,21),!
	Q
OPT	I $O(^FBAAC("AM",FBDA,0)) F II=0:0 S II=$O(^FBAAC("AM",FBDA,FB("DFN"),II)) Q:'II  F JJ=0:0 S JJ=$O(^FBAAC("AM",FBDA,FB("DFN"),II,JJ)) Q:'JJ  F KK=0:0 S KK=$O(^FBAAC("AM",FBDA,FB("DFN"),II,JJ,KK)) Q:'KK  D GETPD
	K II,JJ,KK Q
GETPD	I $D(^FBAAC(FB("DFN"),1,II,1,JJ,1,KK,0)) S FB("PD")=FB("PD")+$P(^(0),"^",3) Q
	;
RETURN	;return address display/edit
	N FBCT,FBCRT,FBDIS,FBED,FBI,FBOUT,FBPG,FBSADD,FBX D HOME^%ZIS S FBOUT=0,FBCRT=$S($E(IOST,1,2)="C-":1,1:0),FBPG=0 G:'FBCRT END
	;display return address
RETDIS	D STATADD^FBUCUTL2 ;get station address
	D PAGE
	S (FBCT,FBI)=0 F  S FBI=$O(FBSADD(FBI)) Q:'FBI  S FBX=FBSADD(FBI) W !?(IOM-$L(FBX)/2),FBX S FBCT=FBCT+1
	;edit return address
	W !!! S DIR("A")="Do you wish to edit",DIR("B")="No",DIR(0)="Y" D ^DIR K DIR G END:$D(DIRUT) S FBED=+Y,FBDIS=0
	G:'FBED END
	S DIE="^FBAA(161.4,",DA=1,DR="35.6;1;2;16;3;4;5" D LOCK^FBUCUTL(DIE,DA) I FBLOCK D ^DIE L -^FBAA(161.4,DA)
	K DA,DIE,DR,FBLOCK
	W !! S DIR("A")="Do you wish to display return address",DIR("B")="Yes",DIR(0)="Y" D ^DIR K DIR G END:$D(DIRUT) S FBDIS=+Y,FBED=0
	G END:'FBDIS G END:FBOUT K FBSADD G RETDIS
