LR350	;DALOI/JMC - LR*5.2*350 KIDS ROUTINE ;Nov 26, 2008
	;;5.2;LAB SERVICE;**350**;Sep 27, 1994;Build 230
	;
	; File 19/10156
	; File ^XUSEC/10076
	;
EN	;
	; Does not delete transport global.
	N STR,LRERR,LRLST,LRXUSEC,POS
	S XPDNOQUE=1 ;no queuing
	S POS=$G(IOM,80) S:POS<1 POS=80
	K ^TMP("LR350",$J)
	;
	I '$G(XPDENV) D
	. S STR="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
	. D ALERT(STR)
	. D BMES("Sending transport global loaded alert to mail group G.LMI")
	;
	I $G(XPDENV) D
	. D BMES("Sending install started alert to mail group G.LMI")
	. S STR="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
	. D ALERT(STR)
	;
	; Perform environment checks
	S LRERR=0
	I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D
	. D BMES("Terminal Device is not defined.")
	. S LRERR=2
	;
	I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D
	. D BMES("Please login to set local DUZ variables.")
	. S LRERR=2
	;
	I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D
	. D BMES("You are not a valid user on this system.")
	. S LRERR=2
	;
	; Check that installer has XUPROG and ZTMQ security keys
	S LRLST(1)="XUPROG",LRLST(2)="ZTMQ"
	D OWNSKEY^XUSRB(.LRXUSEC,.LRLST)
	F LRLST=1,2 I LRXUSEC(LRLST)'=1 D
	. W $C(7)
	. D BMES("You do not own the "_LRLST(LRLST)_" security key.")
	. S LRERR=2
	;
	; If installing, run system config
	I 'LRERR,$G(XPDENV) D
	. D ENV2
	. I $D(XPDABORT) S LRERR=1 Q
	. D BMES("N O T E:  If you abort this installation")
	. D MES("D RESTORE^LR350 from this console.")
	;
	I $G(XPDENV)=1 S XPDDIQ("XPZ1","B")="YES"
	;
	; Prevent queuing of install since need locks on globals.
	I $G(XPDENV)=1 S XPDNOQUE=1
	;
	I LRERR!$D(XPDABORT)!$D(XPDQUIT) D
	. S LRERR=1,XPDABORT=2
	. W !,$C(7),! D BMES("* * * Environment check FAILED * * *")
	;
	I 'LRERR W ! D BMES("--- Environment is okay ---")
	Q
	;
	;
ALERT(MSG,RECIPS)	;
	N DA,DIK,XQA,XQAMSG
	S XQAMSG=$G(MSG)
	I $$GOTLOCAL^XMXAPIG("LMI") S XQA("G.LMI")=""
	E  S XQA(DUZ)=""
	I $D(RECIPS) M XQA=RECIPS
	D SETUP^XQALERT
	Q
	;
	;
BMES(STR)	;
	; Write string
	D BMES^XPDUTL($$TRIM^XLFSTR($$CJ^XLFSTR(STR,$G(IOM,80)),"R"," "))
	Q
	;
	;
MES(STR,CJ,LM)	;
	; Displays a string using MES^XPDUTL
	;  Inputs
	;  STR: String to display
	;   CJ: Center text?  1=yes 0=1 <dflt=1>
	;   LM: Left Margin (padding)
	N X
	S STR=$G(STR)
	S CJ=$G(CJ,1)
	S LM=$G(LM)
	I LM<0 S LM=0
	I CJ S STR=$$TRIM^XLFSTR($$CJ^XLFSTR(STR,$G(IOM,80)),"R"," ")
	I 'CJ I LM S X="" S $P(X," ",LM)=" " S STR=X_STR
	D MES^XPDUTL(STR)
	Q
	;
	;
GETLOCK(ZZZZTARG,ZZZZSECS,ZZZZSHOW)	;
	; Acquire a Lock on the specified resource.
	; Note: "ZZZ*" variable names used to avoid possible variable
	;  name clashes with @TARG -- "^GBL(1,X)" N X then @TARG would
	;  change the intended resource for lock since X would be different.
	; Inputs
	;   TARG : The Resource to Lock (ie "^GBL(1)")
	;   SECS : Total # of seconds to wait for the lock
	;        :  (Minimum value is 5 seconds)
	;        : Negative value means one solid wait (no breaks)
	;   SHOW : >0:show progress, 0:dont show progress
	;        :    1:dots  2:countdown  3: timeleft+dots
	; Output
	;         1 if lock obtained, 0 if not.
	;         If SHOW>0 API outputs progress info
	;
	N ZZZZZZZI,ZZZZLOCK,ZZZTRIES,ZZZZZZTO
	S ZZZZLOCK=0
	S ZZZZTARG=$G(ZZZZTARG)
	S ZZZZSECS=+$G(ZZZZSECS)
	S ZZZZSHOW=+$G(ZZZZSHOW)
	S ZZZZZZTO=$G(DILOCKTM,5) ;timeout
	S:ZZZZZZTO<5 ZZZZZZTO=5
	I ZZZZSECS'<0 I ZZZZSECS<5 S ZZZZSECS=5
	S ZZZTRIES=ZZZZSECS/ZZZZZZTO
	S:ZZZTRIES["." ZZZTRIES=$P(ZZZTRIES,".",1)+1
	;
	I ZZZZSECS>0 F ZZZZZZZI=1:1:ZZZTRIES L +(@ZZZZTARG):ZZZZZZTO S:$T ZZZZLOCK=1 Q:ZZZZLOCK  D  ;
	. I ZZZTRIES>1 I ZZZZSHOW D  ;
	. . I ZZZZSHOW=3 W:ZZZZZZZI=1 " ",ZZZTRIES-1*ZZZZZZTO W "."
	. . I ZZZZSHOW=2 W " ",(ZZZTRIES-ZZZZZZZI)*ZZZZZZTO
	. . I ZZZZSHOW=1 W "."
	;
	I ZZZZSECS<0 D  ;
	. S ZZZZSECS=-ZZZZSECS
	. S:ZZZZSECS<ZZZZZZTO ZZZZSECS=ZZZZZZTO
	. L +(@ZZZZTARG):ZZZZSECS
	. S:$T ZZZZLOCK=1
	;
	Q ZZZZLOCK
	;
	;
LOCKEM()	;
	; Lock install globals
	; Returns 1 on success  or  0|Global it couldnt lock
	N LRLCK,LRLCK2,LRLCK3,X,STATUS
	S STATUS=0
	S LRLCK="^LAHM(62.48,""Z"")"
	S LRLCK2="^LAHM(62.49,""HL7 PROCESS"")"
	; S LRLCK3="^LAH(""Z"")"
	S X=$$GETLOCK(LRLCK,20,1)
	I 'X S STATUS="0|"_LRLCK
	I X D  ;
	. S X=$$GETLOCK(LRLCK2,20,1)
	. I 'X S STATUS="0|"_LRLCK2 L -@LRLCK Q
	. ; S X=$$GETLOCK(LRLCK3,20,1)
	. ; I 'X S STATUS="0|"_LRLCK3 L -@LRLCK2 L -@LRLCK Q
	. S STATUS=1
	Q STATUS
	;
	;
RESTORE	;
	N X,LRADL,STR,OKAY
	D BMES("*  *  *  Releasing system  *  *  *")
	; Release locks
	S X=$G(IOM,80)\2-25
	;S STR="Released lock on ^LAH(""Z"")"
	;D MES(STR,"",X)
	;L -^LAH("Z")
	;
	S STR="Released lock on ^LAHM(62.49,""HL7 PROCESS"")"
	D MES(STR,"",X)
	L -^LAHM(62.49,"HL7 PROCESS")
	;
	S STR="Released lock on ^LAHM(62.48,""Z"")"
	D MES(STR,"",X)
	L -^LAHM(62.48,"Z")
	;
	; reset options
	D BMES(" ")
	D OPTRE("LA7 ADL START/STOP")
	D OPTRE("LA DOWN")
	D OPTRE("LA7 ADL SEND")
	D OPTRE("LRMENU")
	;
	; Restart auto download process status if stopped by install
	S LRADL=$G(^TMP("LR350",$J,"ADL"))
	I LRADL=1 D  ;
	. D ZTSK^LA7ADL
	. D SETSTOP^LA7ADL1(1,DUZ)
	. D BMES("Restarting Lab Universal Interface Auto Download Job")
	. K ^TMP("LR350",$J,"ADL")
	. H 3
	;
	; If ADL not started, notify user to restart
	S X=$P($G(^LA("ADL","STOP")),"^")
	I X'=0 D BMES("Be sure to restart the Lab Universal Interface Auto Download Job")
	;
	I $G(^TMP("LR350",$J,"POC"))=1 D BMES("Restart your POC COTS' VistA link.")
	;
	K ^TMP("LR350",$J)
	Q
	;
	;
OPTOOO(LROPT,MODE)	;
	; File 19/10156
	; Mark Option out of order or clear (OPTDE^XPDUTL doesn't work in ENV)
	N R19,STATUS,LROOO
	S LROPT=$G(LROPT),MODE=$G(MODE),(LROOO,STATUS)=""
	;
	S R19=$$LKOPT^XPDMENU(LROPT)
	I 'R19 S STATUS="0^1^Option not found"
	E  S LROOO=$$GET1^DIQ(19,R19_",",2,"","","LRMSG")
	;
	I R19,'MODE D
	. I LROOO="" S LROOO="OOO VIA LR*5.2*350"
	. E  S STATUS="0^2^Already OOO"
	;
	I R19,MODE D
	. I LROOO="OOO VIA LR*5.2*350" S LROOO=""
	. E  S STATUS="0^3^OOO before patch installation"
	;
	I STATUS="" D
	. D OUT^XPDMENU(LROPT,LROOO)
	. S STATUS=1
	;
	Q STATUS
	;
	;
OPTDE(OPT,STOP)	;
	N X,X2,Y,STATUS
	S STATUS=0,X2=$G(IOM,80)/2-15
	D MES("Disabling Option ["_OPT_"]",0,X2)
	S X=$$OPTOOO(OPT,0)
	I 'X D
	. I $P(X,"^",2)=2 D MES("["_OPT_"] already disabled.") Q
	. D MES("Could not disable Option ["_OPT_"]",0,X2-5)
	. S (STATUS,STOP)=1
	Q STATUS
	;
	;
OPTRE(OPT)	;
	; Re-enable options
	N X,Y
	S OPT=$G(OPT)
	D MES("Enabling Option ["_OPT_"]",1,0)
	S X=0
	S X=$$OPTOOO(OPT,1)
	I 'X D  ;
	. S Y=$P(X,"^",2)
	. I Y>1 D MES("["_OPT_"] left disabled - "_$P(X,"^",3),1,0)
	. W $C(7)
	. D MES("Re-enable ["_OPT_"] manually.",1,0)
	Q
	;
	;
ENV2	;
	N X,Y,I,STOP,ABORT,LR6248
	S ^TMP("LR350",$J,1)=0
	S ^TMP("LR350",$J,"POC")=0
	S ABORT=0
	S STOP=0
	S X="LA7POC"
	F  S X=$O(^LAHM(62.48,"B",X)) Q:X=""  Q:X'?1"LA7POC"1.E  S LR6248=$O(^LAHM(62.48,"B",X,0)) I LR6248 D  Q:STOP  ;
	. S Y=^LAHM(62.48,LR6248,0)
	. Q:$P(Y,U,3)'=1
	. S STOP=1
	. S ^TMP("LR350",$J,"POC")=1
	;
	I STOP D  S STOP=0
	. W $C(7)
	. D BMES(" ")
	. D BMES("IMPORTANT: Shutdown your POC COTS system's VistA link.")
	. S Y=$$PROMPT("Continue",.ABORT)
	. I 'Y S ABORT=1
	;
	I ABORT D  Q  ;
	. D BMES("** Aborted **")
	. D RESTORE^LR350
	. S XPDABORT=2
	;
	; disable options
	S STOP=0
	S X=$$OPTDE("LRMENU",.STOP)
	S X=$$OPTDE("LA7 ADL SEND",.STOP)
	S X=$$OPTDE("LA DOWN",.STOP)
	S X=$$OPTDE("LA7 ADL START/STOP",.STOP)
	;
	I STOP D  ;
	. W $C(7)
	. D BMES("One or more Options weren't disabled.")
	. S Y=$$PROMPT("Continue",.ABORT)
	. I 'Y S ABORT=1
	;
	I ABORT D  Q  ;
	. D BMES("Install aborted.")
	. D RESTORE^LR350
	. S XPDABORT=2
	;
	; Check and shutdown Auto Download job.
	S X=$G(^LA("ADL","STOP"))
	I $P(X,"^")=0 D  ;
	. D BMES("Shutting down Lab Universal Interface Auto Download Job")
	. D SETSTOP^LA7ADL1(2,DUZ)
	. S ^TMP("LR350",$J,"ADL")=1
	. F I=1:1:10 W "." H 1
	;
	; Find existing running HL7 tasks and tell them to shutdown
	D BMES("Shutting down currently running Lab HL7 processes")
	D STOPTASK
	;
	; get locks
	S ABORT=0
	S STOP=0
	F  D  Q:STOP  Q:ABORT  ;
	. S Y=0
	. D BMES("Acquiring locks ...")
	. S X=$$LOCKEM^LR350()
	. I X S STOP=1 Q
	. D BMES("Couldn't lock "_$P(X,"|",2))
	. S Y=$$PROMPT("Try again",.ABORT)
	. Q:ABORT
	. I 'Y S ABORT=1 Q
	. I Y=2 S STOP=1 ;ignore
	;
	I ABORT D  Q  ;
	. D RESTORE^LR350
	. D BMES("** Aborted **")
	. S XPDABORT=2
	;
	D BMES("Locks"_$S(Y=2:" NOT",1:"")_" acquired.")
	;
	; Indicates all system setup steps are done, LA74 checks this node as well
	S ^TMP("LR350",$J,1)=1
	Q
	;
	;
PROMPT(STR,ABORT)	;
	N DIR,Y,X,I,DTOUT,DUOUT,DIRUT,DIROUT
	S DIR(0)="SAO^Y:YES;N:NO;I:IGNORE"
	S X=$P(STR,":")_" (Yes/No/Ignore): "
	S I=$G(IOM,80)-$L(X)-8/2,Y="",$P(Y," ",I)=" " ; pseudo center text
	S DIR("A")=Y_X,DIR("B")="YES"
	D ^DIR
	S Y=$S(Y="Y":1,Y="I":2,Y="":1,1:0)
	I Y="" S Y=1
	I 'Y S ABORT=1
	I $D(DIRUT) S ABORT=1
	Q Y
	;
	;
PROMPT2(STR,ABORT)	;
	N DIR,DTOUT,DUOUT,DIRUT,DIROUT,I,X,Y
	S DIR(0)="YO"
	S I=$G(IOM,80)-$L(STR)-8/2,Y="",$P(Y," ",I)=" " ;pseudo center text
	S DIR("A")=Y_X,DIR("B")="YES"
	D ^DIR
	I Y="" S Y=1
	I 'Y S ABORT=1
	I $D(DIRUT) S ABORT=1
	Q +Y
	;
	;
STOPTASK	;  Find existing running Lab HL7 tasks and tell them to shutdown
	;
	N LRRTN,LRTASK,LRX,ZTNAME,ZTSK
	S ZTNAME="LR*5.2*350/LA*5.2*74 install"
	F LRRTN="EN^LA7VIN","EN^LRVRPOC","EN^LA7UIIN" D
	. K LRTASK,ZTSK
	. D RTN^%ZTLOAD(LRRTN,"LRTASK")
	. I '$D(LRTASK) Q
	. S LRTASK=0
	. F  S LRTASK=$O(LRTASK(LRTASK)) Q:'LRTASK  D
	. . K ZTSK
	. . S ZTSK=LRTASK D STAT^%ZTLOAD
	. . I ZTSK(1)>0,ZTSK(1)<3 S LRX=$$ASKSTOP^%ZTLOAD(LRTASK)
	Q
