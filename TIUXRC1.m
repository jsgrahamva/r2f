TIUXRC1 ; COMPILED XREF FOR FILE #8925 ; 03/03/12
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^TIU(8925,DA,0))
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I $L($P(^TIU(8925,+DA,0),U)),(+$P(^(0),U,3)>0) K ^TIU(8925,"AA",+X,+^TIU(8925,+DA,0),(9999999-$P(+^AUPNVSIT($P(^TIU(8925,+DA,0),U,3),0),".")),+DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"APT",+X,+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I $L($P(^TIU(8925,+DA,0),U)),(+$P(^(0),U,3)>0) K ^TIU(8925,"AE",+X,(9999999-$P(+^AUPNVSIT($P(^TIU(8925,+DA,0),U,3),0),".")),+^TIU(8925,+DA,0),+DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" K ^TIU(8925,"C",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^(0)),U,3) K ^TIU(8925,"AV",+X,+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,3),+DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,15)),U) K ^TIU(8925,"APTP",+X,+$P($G(^TIU(8925,+DA,15)),U),+DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,4),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ADCPT",+X,+$P(^TIU(8925,+DA,0),U,4),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"APTCL",+X,+$$CLINDOC^TIULC1(+$P(^TIU(8925,+DA,0),U),+DA),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"APTCL",+X,38,(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" D KACLPT^TIUDD01(.02,X)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" D KACLAU^TIUDD01(.02,X),KACLAU1^TIUDD01(.02,X)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" D KACLEC^TIUDD01(.02,X)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" D KACLSB^TIUDD01(.02,X)
 S X=$P($G(DIKZ(0)),U,2)
 I X'="" D KAPTLD^TIUDD01(.02,X)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" I $L($P(^TIU(8925,+DA,0),U)),(+$P(^(0),U,2)>0) K ^TIU(8925,"AA",$P(^(0),U,2),+$P(^(0),U),(9999999-$P(+$G(^AUPNVSIT(X,0)),".")),DA)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" I $L($P(^TIU(8925,+DA,0),U)),(+$P(^(0),U,2)>0) K ^TIU(8925,"AE",+$P(^TIU(8925,+DA,0),U,2),(9999999-$P(+$G(^AUPNVSIT(+X,0)),".")),+^TIU(8925,+DA,0),+DA)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^(0)),U,2) K ^TIU(8925,"AV",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U),+X,+DA)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" D:$D(^AUPNVSIT(+X)) SUB^AUPNVSIT
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AVSIT",+X,+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" K ^TIU(8925,"V",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^TIU(8925,D0,150)):^(150),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" X ^DD(8925,.03,1,7,2.4)
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" D KAPTLD^TIUDD01(.03,X)
 S DIKZ(0)=$G(^TIU(8925,DA,0))
 S X=$P($G(DIKZ(0)),U,4)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ADCPT",+$P(^TIU(8925,+DA,0),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,8),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+$P(^TIU(8925,+DA,12),U,8),+$P(^TIU(8925,+DA,0),U),+X,(9999999-+$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,2),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"AAU",+$P(^TIU(8925,+DA,12),U,2),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"APT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U,2),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"ATC",+$P($G(^TIU(8925,+DA,13)),U,2),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,2),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"ATS",+$P($G(^TIU(8925,+DA,14)),U,2),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"ALL","ANY",+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),$L($P($G(^TIU(8925,+DA,17)),U)),+$P($G(^TIU(8925,+DA,13)),U) D ASUBK^TIUDD($P($G(^TIU(8925,+DA,17)),U),+$G(^TIU(8925,+DA,0)),+X,(9999999-+$G(^TIU(8925,+DA,13))),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,4),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"ASVC",+$P($G(^TIU(8925,+DA,14)),U,4),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,5),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U) K ^TIU(8925,"ALOC",+$P($G(^TIU(8925,+DA,12)),U,5),+$P($G(^TIU(8925,+DA,0)),U),+X,(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$O(^TIU(8925.9,"B",+DA,0)) D APRBK^TIUDD(+$G(^TIU(8925,+DA,0)),+X,(9999999-+$G(^TIU(8925,+DA,13))),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,3),+$P($G(^TIU(8925,+DA,13)),U) K ^TIU(8925,"AVSIT",+$P(^TIU(8925,+DA,0),U,3),+$P(^TIU(8925,+DA,0),U),+X,(9999999-$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,4) K ^TIU(8925,"ADCPT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U,4),+X,(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" D KACLPT^TIUDD01(.05,X)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" D KACLEC^TIUDD01(.05,X)
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" D KACLAU^TIUDD01(.05,X),KACLAU1^TIUDD01(.05,X)
 S X=$P($G(DIKZ(0)),U,6)
 I X'="" K ^TIU(8925,"DAD",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,7)
 I X'="" D KAPTLD^TIUDD01(.07,X)
 S X=$P($G(DIKZ(0)),U,12)
 I X'="" K ^TIU(8925,"FIX",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,13)
 I X'="" D KAPTLD^TIUDD01(.13,X)
 S DIKZ(12)=$G(^TIU(8925,DA,12))
 S X=$P($G(DIKZ(12)),U,1)
 I X'="" K ^TIU(8925,"F",$E(X,1,30),DA)
 S X=$P($G(DIKZ(12)),U,2)
 I X'="" K ^TIU(8925,"CA",$E(X,1,30),DA)
 S X=$P($G(DIKZ(12)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AAU",+X,+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),+DA)
 S X=$P($G(DIKZ(12)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,15)),U) K ^TIU(8925,"AAUP",+X,+$P($G(^TIU(8925,+DA,15)),U),+DA)
 S X=$P($G(DIKZ(12)),U,2)
 I X'="" D KACLAU^TIUDD01(1202,X)
 S X=$P($G(DIKZ(12)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALOC",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(12)),U,5)
 I X'="" I +$P($G(^TIU(8925,+DA,15)),U) K ^TIU(8925,"ALOCP",+X,+$P($G(^TIU(8925,+DA,15)),U),+DA)
 S X=$P($G(DIKZ(12)),U,7)
 I X'="" D:$D(^AUPNVSIT(+X)) SUB^AUPNVSIT
 S X=$P($G(DIKZ(12)),U,8)
 I X'="" K ^TIU(8925,"CS",$E(X,1,30),DA)
 S X=$P($G(DIKZ(12)),U,8)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+X,+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(12)),U,8)
 I X'="" D KACLEC^TIUDD01(1208,X)
 S X=$P($G(DIKZ(12)),U,11)
 I X'="" D KAPTLD^TIUDD01(1211,X)
 S DIKZ(13)=$G(^TIU(8925,DA,13))
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AAU",+$P(^TIU(8925,+DA,12),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,8),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+$P(^TIU(8925,+DA,12),U,8),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"APT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATS",+$P(^TIU(8925,+DA,14),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATC",+$P(^TIU(8925,+DA,13),U,2),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALL","ANY",+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),$L($P($G(^TIU(8925,+DA,17)),U)) D ASUBK^TIUDD($P($G(^TIU(8925,+DA,17)),U),+$G(^TIU(8925,+DA,0)),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-+X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,14)),U,4),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASVC",+$P(^TIU(8925,+DA,14),U,4),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),+$O(^TIU(8925.9,"B",+DA,0)) D APRBK^TIUDD(+$G(^TIU(8925,+DA,0)),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-+X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,3),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AVSIT",+$P(^TIU(8925,+DA,0),U,3),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,4),+$P($G(^TIU(8925,+DA,0)),U,2),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ADCPT",+$P(^TIU(8925,+DA,0),U,2),+$P(^TIU(8925,+DA,0),U,4),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" K ^TIU(8925,"D",$E(X,1,30),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTCL",+$P(^TIU(8925,+DA,0),U,2),+$$CLINDOC^TIULC1(+$P(^TIU(8925,+DA,0),U),+DA),(9999999-X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U),+$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTCL",+$P(^TIU(8925,+DA,0),U,2),38,(9999999-X),DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,12)),U,5),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ALOC",+$P(^TIU(8925,+DA,12),U,5),+$P(^TIU(8925,+DA,0),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-X),+DA)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" D KACLPT^TIUDD01(1301,X)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" D KACLAU^TIUDD01(1301,X),KACLAU1^TIUDD01(1301,X)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" D KACLEC^TIUDD01(1301,X)
 S X=$P($G(DIKZ(13)),U,1)
 I X'="" D KACLSB^TIUDD01(1301,X)
 S X=$P($G(DIKZ(13)),U,2)
 I X'="" K ^TIU(8925,"TC",$E(X,1,30),DA)
 S X=$P($G(DIKZ(13)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATC",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(13)),U,2)
 I X'="" D KACLAU1^TIUDD01(1302,X)
 S X=$P($G(DIKZ(13)),U,4)
 I X'="" K ^TIU(8925,"E",$E(X,1,30),DA)
 S DIKZ(14)=$G(^TIU(8925,DA,14))
 S X=$P($G(DIKZ(14)),U,2)
 I X'="" K ^TIU(8925,"TS",$E(X,1,30),DA)
 S X=$P($G(DIKZ(14)),U,2)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ATS",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(14)),U,4)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASVC",+X,+$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(14)),U,4)
 I X'="" K ^TIU(8925,"SVC",$E(X,1,30),DA)
 S X=$P($G(DIKZ(14)),U,5)
 I X'="" K ^TIU(8925,"G",$E(X,1,30),DA)
 S DIKZ(15)=$G(^TIU(8925,DA,15))
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,5) K ^TIU(8925,"ALOCP",+$P($G(^TIU(8925,+DA,12)),U,5),+X,+DA)
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U,2) K ^TIU(8925,"APTP",+$P($G(^TIU(8925,+DA,0)),U,2),+X,+DA)
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,2) K ^TIU(8925,"AAUP",+$P($G(^TIU(8925,+DA,12)),U,2),+X,+DA)
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" D KACLPT^TIUDD01(1501,X)
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" D KACLEC^TIUDD01(1501,X)
 S X=$P($G(DIKZ(15)),U,1)
 I X'="" D SACLAU^TIUDD0(1501,X),SACLAU1^TIUDD0(1501,X)
 S X=$P($G(DIKZ(15)),U,2)
 I X'="" D KACLSB^TIUDD01(1502,X)
 S X=$P($G(DIKZ(15)),U,7)
 I X'="" D SACLEC^TIUDD0(1507,X)
 S X=$P($G(DIKZ(15)),U,7)
 I X'="" D KACLPT^TIUDD01(1507,X)
 S DIKZ(17)=$G(^TIU(8925,DA,17))
 S X=$P($G(DIKZ(17)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,0)),U),+$P($G(^TIU(8925,+DA,0)),U,5),+$P($G(^TIU(8925,+DA,13)),U) D ASUBK^TIUDD($G(X),+$G(^TIU(8925,+DA,0)),+$P(^TIU(8925,+DA,0),U,5),(9999999-+$G(^TIU(8925,+DA,13))),DA)
 S DIKZ(21)=$G(^TIU(8925,DA,21))
 S X=$P($G(DIKZ(21)),U,1)
 I X'="" K ^TIU(8925,"GDAD",$E(X,1,30),DA)
 S DIKZ(150)=$G(^TIU(8925,DA,150))
 S X=$P($G(DIKZ(150)),U,1)
 I X'="" K ^TIU(8925,"VID",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" K ^TIU(8925,"B",$E(X,1,30),DA)
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" I +$P(^TIU(8925,+DA,0),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"APT",+$P(^TIU(8925,+DA,0),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P(^TIU(8925,+DA,13),U)),DA)
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,2),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"AAU",+$P($G(^TIU(8925,+DA,12)),U,2),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" I +$P($G(^TIU(8925,+DA,12)),U,8),+$P($G(^TIU(8925,+DA,13)),U),+$P($G(^TIU(8925,+DA,0)),U,5) K ^TIU(8925,"ASUP",+$P($G(^TIU(8925,+DA,12)),U,8),+X,+$P(^TIU(8925,+DA,0),U,5),(9999999-$P($G(^TIU(8925,+DA,13)),U)),DA)
 S X=$P($G(DIKZ(0)),U,1)
END G ^TIUXRC2
