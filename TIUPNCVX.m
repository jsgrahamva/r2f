TIUPNCVX ;SF/JLI ;PNs ==> TIU cnv rtns ;5-7-97
 ;;1.0;TEXT INTEGRATION UTILITIES;;Jun 20, 1997
 ;
 ;set x-refs for conversion
ENTRY ;
 S DA=TIUIFN,TIU0=$G(^TIU(8925,TIUIFN,0)),TIU13=$G(^(13))
 S TIU12=$G(^(12)),TIU15=$G(^(15))
 S TIURDATE=9999999-TIU13
 S ^TIU(8925,"B",$P(TIU0,U),DA)=""
 I +TIU13 D
 . I +$P(TIU0,U,5) D
 . . S ^TIU(8925,"ALL","ANY",+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU0,U,2) S ^TIU(8925,"APT",+$P(TIU0,U,2),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU0,U,3) S ^TIU(8925,"AVSIT",+$P(TIU0,U,3),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU12,U,2) S ^TIU(8925,"AAU",+$P(TIU12,U,2),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU12,U,5) S ^TIU(8925,"ALOC",+$P(TIU12,U,5),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU12,U,8) S ^TIU(8925,"ASUP",+$P(TIU12,U,8),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$P(TIU13,U,2) S ^TIU(8925,"ATC",+$P(TIU13,U,2),+TIU0,+$P(TIU0,U,5),TIURDATE,DA)=""
 . . I +$O(^TIU(8925.9,"B",DA,0)) D APRBS^TIUDD(+TIU0,+$P(TIU0,U,5),TIURDATE,DA)
 . I +$P(TIU0,U,2) S ^TIU(8925,"APTCL",+$P(TIU0,U,2),+$$CLINDOC^TIULC1(+TIU0,DA),TIURDATE,DA)=""
 . I +$P(TIU0,U,2) S ^TIU(8925,"APTCL",+$P(TIU0,U,2),38,TIURDATE,DA)=""
 I $P($$DOCTYPE^TIULF(DA),U)="DOC",+$P(TIU0,U,2),+$P(TIU0,U,3) D
 . S ^TIU(8925,"AV",+$P(TIU0,U,2),+TIU0,+$P(TIU0,U,3),DA)=""
 . S ^TIU(8925,"AA",+$P(TIU0,U,2),+TIU0,(9999999-$P(+^AUPNVSIT(+$P(TIU0,U,3),0),".")),DA)=""
 . S ^TIU(8925,"AE",+$P(TIU0,U,2),(9999999-$P(+^AUPNVSIT(+$P(TIU0,U,3),0),".")),+TIU0,DA)=""
 ;
 I $P(TIU0,U,2)'="" D
 . S ^TIU(8925,"C",$P(TIU0,U,2),DA)=""
 . I +$$APTP^TIULX(DA),+TIU15 S ^TIU(8925,"APTP",+$P(TIU0,U,2),+TIU15,DA)=""
 . I +$P(TIU0,U,4),+TIU13,+$P(TIU0,U,5) S ^TIU(8925,"ADCPT",+$P(TIU0,U,2),+$P(TIU0,U,4),+$P(TIU0,U,5),TIURDATE,DA)=""
 ;
 I $P(TIU0,U,3)'="" D
 . S X=$P(TIU0,U,3)
 . D:$D(^AUPNVSIT(+$P(TIU0,U,3))) ADD^AUPNVSIT
 . S ^TIU(8925,"V",$P(TIU0,U,3),DA)=""
 . X ^DD(8925,.03,1,7,1) ; TRIGGER
 . S DA=TIUIFN
 I $P(TIU0,U,6)'="" S ^TIU(8925,"DAD",$P(TIU0,U,6),DA)=""
 I $P(TIU0,U,12)'="" S ^TIU(8925,"FIX",$P(TIU0,U,12),DA)=""
 I $P(TIU12,U)'="" S ^TIU(8925,"F",$P(TIU12,U),DA)=""
 I $P(TIU12,U,2)'="" D
 . S ^TIU(8925,"CA",$P(TIU12,U,2),DA)=""
 . I +$$AAUP^TIULX(DA),+TIU15 S ^TIU(8925,"AAUP",+$P(TIU12,U,2),+TIU15,DA)=""
 I $P(TIU12,U,5)'="",+$$ALOCP^TIULX(DA),+TIU15 S ^TIU(8925,"ALOCP",+$P(TIU12,U,5),+TIU15,DA)=""
 I $P(TIU12,U,8)'="" S ^TIU(8925,"CS",$P(TIU12,U,8),DA)=""
 I $P(TIU13,U)'="" S ^TIU(8925,"D",$P(TIU13,U),DA)=""
 I $P(TIU13,U,2)'="" S ^TIU(8925,"TC",$P(TIU13,U,2),DA)=""
 I $P(TIU13,U,4)'="" S ^TIU(8925,"E",$P(TIU13,U,4),DA)=""
 S X=$P($G(^TIU(8925,DA,150)),U)
 I X'="" S ^TIU(8925,"VID",$E(X,1,30),DA)=""
 I +TIU0'=81 D SACLPT^TIUDD0(.02,$P(TIU0,U,2))
 I $P(TIU15,U)'>0 D SACLAU^TIUDD0(1202,$P(TIU12,U,2)),SACLAU1^TIUDD0(1302,$P(TIU13,U,2))
 I '$P(TIU15,U,7),($P(TIU0,U,5)<7) D
 . I $P(TIU0,U,5)=6 D SACLEC^TIUDD0(1208,$P(TIU12,U,8)) I 1
 . E  I $P(TIU0,U,5)>4 D SACLEC^TIUDD0(1208,$P(TIU12,U,8))
 I +TIU0'=81,$P(TIU15,U,2)>0 D SACLSB^TIUDD0(1502,$P(TIU15,U,2))
 I $P(TIU0,U,7)'>0 S $P(^(0),U,7)=+$G(^TIU(8925,DA,13))
 I $P(TIU12,U,5)'>0 S VTYPE="E"
 E  S VLOC=+$P(TIU12,U,5),STOP=+$P(^SC(VLOC,0),U,7) D
 . I STOP>0 S STOP=$P(^DIC(40.7,STOP,0),U) S VTYPE=$S(STOP["TELE":"T",1:"A") I 1
 . E  D
 . . I $P(^SC(VLOC,0),U,3)="W" S VTYPE="H"
 . . E  S VTYPE="E"
 . S $P(^TIU(8925,DA,0),U,13)=VTYPE
 D SAPTLD^TIUDD0(.02,$P(TIU0,U,2))
 Q
