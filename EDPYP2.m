EDPYP2	;BP/TDP - Post-init for patch 2 ;3/1/12 10:45am
	;;2.0;EMERGENCY DEPARTMENT;;May 2, 2012;Build 103
	;
EN	;Entry point
	N EDPTMOUT,EDPNWTM,EDPCNTDN,EDPNWCNT,EDPVALUE,EDPINST,EDPPARAM,FDA,X,Y
	N EDPSYS S EDPSYS=0
	D BMES^XPDUTL("Post-install started.")
	S EDPTMOUT=+$O(^XTV(8989.51,"B","ORWOR TIMEOUT CHART",""))
	S EDPNWTM=+$O(^XTV(8989.51,"B","EDP APP TIMEOUT",""))
	S EDPCNTDN=+$O(^XTV(8989.51,"B","ORWOR TIMEOUT COUNTDOWN",""))
	S EDPNWCNT=+$O(^XTV(8989.51,"B","EDP APP COUNTDOWN",""))
	F X=EDPTMOUT,EDPCNTDN D
	. I X=EDPTMOUT S Y=EDPNWTM D
	.. D BMES^XPDUTL("     Copying ORWOR TIMEOUT CHART parameter values to EDP APP TIMEOUT.")
	. I X=EDPCNTDN S Y=EDPNWCNT D
	.. D MES^XPDUTL("     Copying ORWOR TIMEOUT COUNTDOWN parameter values to EDP APP COUNTDOWN.")
	. S EDPPARAM=""
	. F  S EDPPARAM=$O(^XTV(8989.5,"AC",X,EDPPARAM)) Q:EDPPARAM=""  D
	.. ;Do not set values for user if not EDIS Tracking Staff.
	.. I EDPPARAM["VA(200",'$D(^EDPB(231.7,"B",$P(EDPPARAM,";",1))) Q
	.. S EDPINST=0
	.. F  S EDPINST=$O(^XTV(8989.5,"AC",X,EDPPARAM,EDPINST)) Q:EDPINST=""  D
	... S EDPVALUE=+$G(^XTV(8989.5,"AC",X,EDPPARAM,EDPINST))
	... I EDPVALUE<1 Q  ;If parameter value less than 1 quit
	... I $D(^XTV(8989.5,"AC",Y,EDPPARAM,EDPINST)) Q  ;If entry already exist quit
	... I EDPPARAM["DIC(4.2",EDPVALUE<$S(X=EDPTMOUT:1200,1:120) S EDPVALUE=$S(X=EDPTMOUT:1200,1:120) ;Set system level parameters to EDIS default if less than default.
	... S FDA(8989.5,8989.5,"+1,",.01)=EDPPARAM
	... S FDA(8989.5,8989.5,"+1,",.02)=$S(X=EDPTMOUT:EDPNWTM,1:EDPNWCNT)
	... S FDA(8989.5,8989.5,"+1,",.03)=EDPINST
	... S FDA(8989.5,8989.5,"+1,",1)=EDPVALUE
	... D UPDATE^DIE("","FDA(8989.5)","")
	... Q
	;Set System level parameter values
	I $G(XPARSYS)'="" S EDPSYS=$G(XPARSYS)
	I $G(XPARSYS)="" S EDPSYS=$$FIND1^DIC(4.2,"","QX",$$KSP^XUPARAM("WHERE"))_";DIC(4.2,"
	I +$G(EDPSYS)>0,EDPSYS?1.N1";DIC(4.2," D
	. I '$D(^XTV(8989.5,"AC",EDPNWTM,EDPSYS,1)) D
	.. S FDA(8989.5,8989.5,"+1,",.01)=EDPSYS
	.. S FDA(8989.5,8989.5,"+1,",.02)=EDPNWTM
	.. S FDA(8989.5,8989.5,"+1,",.03)=1
	.. S FDA(8989.5,8989.5,"+1,",1)=1200
	.. D UPDATE^DIE("","FDA(8989.5)","")
	. I '$D(^XTV(8989.5,"AC",EDPNWCNT,EDPSYS,1)) D
	.. S FDA(8989.5,8989.5,"+1,",.01)=EDPSYS
	.. S FDA(8989.5,8989.5,"+1,",.02)=EDPNWCNT
	.. S FDA(8989.5,8989.5,"+1,",.03)=1
	.. S FDA(8989.5,8989.5,"+1,",1)=120
	.. D UPDATE^DIE("","FDA(8989.5)","")
	D BMES^XPDUTL("Post-install complete.")
	Q
