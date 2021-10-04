IBTRPR1 ;ALB/AAS - CLAIMS TRACKING - PENDING WORK ACTIONS ; 9-AUG-93
 ;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
% G EN^IBTRPR
 ;
NX(IBTMPNM) ; -- Go to next template
 ; -- Input template name
 N I,J,IBXX,VALMY,IBTRN,IBTRV,IBTRC,DFN
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXX,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .I IBTMPNM["REVIEW EDITOR"!(IBTMPNM["COMMUNICATIONS EDITOR") D
 ..I $P(IBT,"^",2)=356.1 S IBTRV=$P(IBT,"^",3),IBTMPNM="IBT REVIEW EDITOR"
 ..I $P(IBT,"^",2)=356.2 S IBTRC=$P(IBT,"^",3),IBTMPNM="IBT COMMUNICATIONS EDITOR"
 .D EN^VALM(IBTMPNM)
 .K IBAMT,IBAPR,IBADG,IBDA,IBDGCR,IBDGCRU1,IBDV,IBETYP,IBETYPD,IBI,IBICD,IBLCNT,IBSEL,IBT,IBTEXT,IBTNOD,IBTSAV,VAUTD
 .K IBAPEAL,IBCDFN,IBCNT,IBDEN,IBDENIAL,IBDENIAL,IBPARNT,IBPEN,IBPENAL,IBTCOD,IBTRDD,IBTRSV,IBTYPE,VAINDT,VA
 .D KVAR^VADPT
 .Q
 I '$D(IBFASTXT) D BLD^IBTRPR
 S VALMBCK="R"
 Q
 ;
CD ; -- Change Date range
 S VALMB=IBTPBDT D RANGE^VALM11
 I $S('VALMBEG:1,IBTPBDT'=VALMBEG:0,1:IBTPEDT=VALMEND) W !!,"Date range was not changed." D PAUSE^VALM1 S VALMBCK="" G CDQ
 S IBTPBDT=VALMBEG,IBTPEDT=VALMEND
 D BLD^IBTRPR
 D HDR^IBTRPR S VALMBG=1
CDQ K VALMB,VALMBEG,VALMEND
 S VALMBCK="R"
 Q
 ;
QE ; -- Quick Edit Entry
 N I,J,IBXX,VALMY,IBTRN,IBTRV,IBTRC,DFN
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXX,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .I $P(IBT,"^",2)=356.1 S IBTRV=$P(IBT,"^",3) D QE1^IBTRV1 Q
 .I $P(IBT,"^",2)=356.2 S IBTRC=$P(IBT,"^",3) D QE1^IBTRC1 Q
 .D EN^VALM(IBTMPNM)
 .Q
 D BLD^IBTRPR
 S VALMBCK="R"
 Q
 D BLD^IBTRPR
 S VALMBCK="R"
 Q
 ;
VE ; -- View Edit entry
 N I,J,IBXX,VALMY,IBTRN,IBTRV,IBTRC,DFN
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXX,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .I $P(IBT,"^",2)=356.1 S IBTRV=$P(IBT,"^",3),IBTMPNM="IBT EXPAND/EDIT REVIEW"
 .I $P(IBT,"^",2)=356.2 S IBTRC=$P(IBT,"^",3),IBTMPNM="IBT EXPAND/EDIT COMMUNICATIONS"
 .D EN^VALM(IBTMPNM)
 .Q
 D BLD^IBTRPR
 S VALMBCK="R"
 Q
 ;
SC ; -- Status Change
 N VALMY,I,J,IBT,IBXXT,IBTEMP
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXXT=0 F  S IBXXT=$O(VALMY(IBXXT)) Q:'IBXXT  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXXT,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .S IBTEMP="[IBT STATUS CHANGE]"
 .I $P(IBT,"^",2)=356.1 S IBTRV=$P(IBT,"^",3) D EDIT^IBTRVD1(IBTEMP,1) Q
 .I $P(IBT,"^",2)=356.2 S IBTRC=$P(IBT,"^",3) D EDIT^IBTRCD1(IBTEMP,1) Q
 .Q
 D BLD^IBTRPR
 S VALMBCK="R"
 Q
 ;
RL ; -- Remove from list
 ;    Just delete Next review date
 N VALMY,I,J,IBT,IBXXT,IBTEMP
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXXT=0 F  S IBXXT=$O(VALMY(IBXXT)) Q:'IBXXT  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXXT,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .S IBTEMP="[IBT REMOVE NEXT REVIEW]"
 .W !!,"Removing Next Review Date from entry #",IBXXT
 .I $P(IBT,"^",2)=356.1 S IBTRV=$P(IBT,"^",3) D EDIT^IBTRVD1(IBTEMP,1) Q
 .I $P(IBT,"^",2)=356.2 S IBTRC=$P(IBT,"^",3) D EDIT^IBTRCD1(IBTEMP,1) Q
 .Q
 D BLD^IBTRPR
 S VALMBCK="R"
 Q
 ;
SHOWSC ; -- show sc conditions
 N I,J,IBXX,VALMY,IBTRN,IBTRV,IBTRC,DFN
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXX,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .D SHOWSC^IBTRC1
 .Q
 S VALMBCK="R"
 Q
 ;
PW ; -- Print worksheet
 N I,J,IBXX,VALMY,IBTRN,IBTRV,IBTRC,DFN
 D EN^VALM2($G(XQORNOD(0)))
 I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
 .S IBT=$G(^TMP("IBTRPRDX",$J,+$O(^TMP("IBTRPR",$J,"IDX",IBXX,0))))
 .S IBTRN=$P(IBT,"^",4),DFN=$P(^IBT(356,+IBTRN,0),"^",2)
 .D RW^IBTRC4
 .Q
 S VALMBCK="R"
 Q
