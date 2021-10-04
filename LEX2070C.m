LEX2070C ;ISL/KER - LEX*2.0*70 Pre/Post Install ;06/09/2010
 ;;2.0;LEXICON UTILITY;**70**;Sep 23, 1996;Build 2
 ;               
 ; Global Variables
 ;    ^DIC(81.3,          ICR   4492
 ;               
 ; External References
 ;    ^DIK                ICR  10013
 ;               
DR(X) ; Delete Range Multiple
 N DA,DIK,LEX1,LEX2,LEX3,LEXIEN,LEXRIEN S LEXIEN=+($G(X)) Q:+LEXIEN'>0  Q:'$D(^DIC(81.3,+LEXIEN,10))
 ; Fileman Delete
 S LEXRIEN=0 F  S LEXRIEN=$O(^DIC(81.3,+LEXIEN,10,LEXRIEN)) Q:+LEXRIEN'>0  D
 . Q:'$D(^DIC(81.3,+LEXIEN,10,+LEXRIEN,0))  N DA,DIK S DA(1)=LEXIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK
 ; Hard Delete (remove erroneous nodes)
 K ^DIC(81.3,LEXIEN,10,"B"),^DIC(81.3,LEXIEN,"M"),^DIC(81.3,+LEXIEN,10) S ^DIC(81.3,+LEXIEN,10,0)="^81.32A^^"
 S LEX1="" F  S LEX1=$O(^DIC(81.3,"M",LEX1)) Q:'$L(LEX1)  S LEX2="" F  S LEX2=$O(^DIC(81.3,"M",LEX1,LEX2)) Q:'$L(LEX2)  D
 . S LEX3="" F  S LEX3=$O(^DIC(81.3,"M",LEX1,LEX2,LEX3)) Q:'$L(LEX3)  D
 . . K:$G(^DIC(81.3,"M",LEX1,LEX2,LEX3))>0&(+LEXIEN=+LEX3) ^DIC(81.3,"M",LEX1,LEX2,LEX3)
 Q
LR ;; Left/Right
 ;;LR;;65091;;66986;;01/01/1999;;01/01/2005
 ;;LR;;67005;;67255;;01/01/1999;;01/01/2005
 ;;LR;;67311;;67350;;01/01/1999;;01/01/2005
 ;;LR;;67400;;67570;;01/01/1999;;01/01/2005
 ;;LR;;67700;;67800;;01/01/1999;;01/01/2005
 ;;LR;;67810;;67975;;01/01/1999;;01/01/2005
 ;;LR;;67810;;69205;;01/01/2005
 ;;LR;;68020;;68362;;01/01/1999;;01/01/2005
 ;;LR;;68400;;68850;;01/01/1999;;01/01/2005
 ;;LR;;69000;;69205;;01/01/1999;;01/01/2005
 ;;LR;;69220;;69320;;01/01/1999;;01/01/2005
 ;;LR;;69220;;69970;;01/01/2005
 ;;LR;;69400;;69632;;01/01/1999;;01/01/2005
 ;;LR;;69635;;69745;;01/01/1999;;01/01/2005
 ;;LR;;69801;;69930;;01/01/1999;;01/01/2005
 ;;LR;;69950;;69970;;01/01/1999;;01/01/2005
 ;;LR;;70030;;70030;;01/01/1999
 ;;LR;;70120;;70130;;01/01/2005
 ;;LR;;70170;;70170;;01/01/1999;;01/01/2005
 ;;LR;;70170;;70190;;01/01/2005
 ;;LR;;70332;;70332;;01/01/1999;;01/01/2005
 ;;LR;;70332;;70336;;01/01/2005
 ;;LR;;71100;;71100;;01/01/2005
 ;;LR;;73000;;73040;;01/01/1999
 ;;LR;;73060;;73225;;01/01/1999
 ;;LR;;73500;;73510;;01/01/2005
 ;;LR;;73525;;73530;;01/01/1999
 ;;LR;;73542;;73564;;01/01/2000
 ;;LR;;73580;;73725;;01/01/1999
 ;;LR;;74425;;74425;;01/01/1999
 ;;LR;;74470;;74480;;01/01/1999
 ;;LR;;74742;;74742;;01/01/1999
 ;;LR;;75658;;75658;;01/01/1999
 ;;LR;;75685;;75705;;01/01/1999
 ;;LR;;75860;;75860;;01/01/1999
 ;;LR;;75880;;75880;;01/01/1999
 ;;LR;;75966;;75966;;01/01/1999
 ;;LR;;76006;;76006;;01/01/2005
 ;;LR;;76086;;76088;;01/01/1999;;01/01/2005
 ;;LR;;76086;;76090;;01/01/2005
 ;;LR;;76095;;76096;;01/01/1999
 ;;LR;;76510;;76529;;01/01/2005
 ;;LR;;76511;;76513;;01/01/1999;;01/01/2004
 ;;LR;;76511;;76529;;01/01/2004;;01/01/2005
 ;;LR;;76519;;76529;;01/01/2003;;01/01/2004
 ;;LR;;76529;;76529;;01/01/1999;;01/01/2003
 ;;LR;;76645;;76645;;01/01/2005
 ;;LR;;76880;;76880;;01/01/1999
 ;;LR;;76938;;76938;;01/01/1999;;01/01/2003
 ;;LR;;76948;;76948;;01/01/1999
 ;;LR;;77055;;77055;;01/01/2007
 ;;LR;;92070;;92070;;01/01/1999;;01/01/2005
 ;;LR;;92070;;92083;;01/01/2005
 ;;LR;;92120;;92226;;01/01/1999;;01/01/2001
 ;;LR;;92120;;92140;;01/01/2001
 ;;LR;;92120;;92135;;01/01/2002;;01/01/2005
 ;;LR;;92120;;92250;;01/01/2005
 ;;LR;;92140;;92140;;01/01/2002;;01/01/2003
 ;;LR;;92140;;92226;;01/01/2003;;01/01/2005
 ;;LR;;92225;;92226;;01/01/2001;;01/01/2003
 ;;LR;;92235;;92240;;01/01/1999;;01/01/2002
 ;;LR;;92235;;92250;;01/01/2002;;01/01/2003
 ;;LR;;92235;;92240;;01/01/2003;;01/01/2005
 ;;LR;;92265;;92275;;01/01/2005
 ;;LR;;92270;;92275;;01/01/1999;;01/01/2005
 ;;LR;;92285;;92287;;01/01/1999
 ;;LR;;92313;;92313;;01/01/1999
 ;;LR;;92317;;92326;;01/01/1999;;01/01/2005
 ;;LR;;92317;;92335;;01/01/2005
 ;;LR;;92393;;92393;;01/01/2005
 ;;LR;;92601;;92606;;01/01/2003
 ;;LR;;95934;;95936;;01/01/1999
 ;;LR;;A4262;;A4263;;01/01/1999;;01/01/2005
 ;;LR;;A4465;;A4465;;01/01/1999;;01/01/2005
 ;;LR;;A4490;;A4510;;01/01/1999;;01/01/2005
 ;;LR;;A4565;;A4570;;01/01/1999;;01/01/2005
 ;;LR;;A4580;;A4580;;01/01/2004;;01/01/2005
 ;;LR;;A5500;;A5508;;01/01/2000
 ;;LR;;A5500;;A5511;;01/01/2002;;01/01/2003
 ;;LR;;A5500;;A5501;;01/01/2003;;01/01/2005
 ;;LR;;A5503;;A5511;;01/01/2003;;01/01/2005
 ;;LR;;A6410;;A6412;;01/01/2003;;01/01/2005
 ;;LR;;C1079;;C1079;;01/01/2004;;01/01/2005
 ;;LR;;C1088;;C1088;;01/01/2004;;01/01/2005
 ;;LR;;C1091;;C1092;;01/01/2004;;01/01/2005
 ;;LR;;C1122;;C1122;;01/01/2004;;01/01/2005
 ;;LR;;C1178;;C1178;;01/01/2004;;01/01/2005
 ;;LR;;C1200;;C1201;;01/01/2004;;01/01/2005
 ;;LR;;C1300;;C1300;;01/01/2004;;01/01/2005
 ;;LR;;C1305;;C1305;;01/01/2004;;01/01/2005
 ;;LR;;C1765;;C1765;;01/01/2004;;01/01/2005
 ;;LR;;C1775;;C1775;;01/01/2004;;01/01/2005
 ;;LR;;C1783;;C1783;;01/01/2004;;01/01/2005
 ;;LR;;C1814;;C1814;;01/01/2004;;01/01/2005
 ;;LR;;C1884;;C1884;;01/01/2004;;01/01/2005
 ;;LR;;C1888;;C1888;;01/01/2004;;01/01/2005
 ;;LR;;C1900;;C1900;;01/01/2004;;01/01/2005
 ;;LR;;C2614;;C2614;;01/01/2004;;01/01/2005
 ;;LR;;C2618;;C2618;;01/01/2004;;01/01/2005
 ;;LR;;C2632;;C2632;;01/01/2004;;01/01/2005
 ;;LR;;C8900;;C9000;;01/01/2004;;01/01/2005
 ;;LR;;C9003;;C9003;;01/01/2004;;01/01/2005
 ;;LR;;C9007;;C9009;;01/01/2004;;01/01/2005
 ;;LR;;C9013;;C9013;;01/01/2004;;01/01/2005
 ;;LR;;C9102;;C9103;;01/01/2004;;01/01/2005
 ;;LR;;C9105;;C9105;;01/01/2004;;01/01/2005
 ;;LR;;C9109;;C9109;;01/01/2004;;01/01/2005
 ;;LR;;C9112;;C9113;;01/01/2004;;01/01/2005
 ;;LR;;C9121;;C9203;;01/01/2004;;01/01/2005
 ;;LR;;C9701;;C9701;;01/01/2004;;01/01/2005
 ;;LR;;C9703;;C9703;;01/01/2004;;01/01/2005
 ;;LR;;C9711;;D0480;;01/01/2004;;01/01/2005
 ;;LR;;D0502;;D1550;;01/01/2004;;01/01/2005
 ;;LR;;D2140;;D2335;;01/01/2004;;01/01/2005
 ;;LR;;D2390;;D4211;;01/01/2004;;01/01/2005
 ;;LR;;D4240;;D6253;;01/01/2004;;01/01/2005
 ;;LR;;D6545;;D6999;;01/01/2004;;01/01/2005
 ;;LR;;D7111;;D7111;;01/01/2004;;01/01/2005
 ;;LR;;D7140;;D7415;;01/01/2004;;01/01/2005
 ;;LR;;D7440;;D7473;;01/01/2004;;01/01/2005
 ;;LR;;D7485;;D9974;;01/01/2004;;01/01/2005
 ;;LR;;E0175;;E0175;;01/01/1999;;01/01/2005
 ;;LR;;E0191;;E0191;;01/01/1999;;01/01/2005
 ;;LR;;E0655;;E0669;;01/01/1999;;01/01/2003
 ;;LR;;E0655;;E0673;;01/01/2003;;01/01/2005
 ;;LR;;E0671;;E0673;;01/01/1999;;01/01/2003
 ;;LR;;E0951;;E0952;;01/01/1999;;01/01/2005
 ;;LR;;E0990;;E0990;;01/01/1999;;01/01/2005
 ;;LR;;E0994;;E0995;;01/01/1999;;01/01/2005
 ;;LR;;E1800;;E1830;;01/01/1999
 ;;LR;;E1800;;E1840;;01/01/2002;;01/01/2005
 ;;LR;;G0185;;G0187;;01/01/2002;;01/01/2003
 ;;LR;;G0186;;G0186;;01/01/2003
 ;;LR;;G0259;;G0260;;01/01/2003
 ;;LR;;G0279;;G0280;;01/01/2003
 ;;LR;;G0289;;G0289;;01/01/2005
 ;;LR;;G0296;;G0296;;01/01/2005
 ;;LR;;H0001;;H2001;;01/01/2004;;01/01/2005
 ;;LR;;J1452;;J1452;;01/01/2001;;01/01/2005
 ;;LR;;K0015;;K0019;;01/01/1999;;01/01/2005
 ;;LR;;K0034;;K0049;;01/01/1999;;01/01/2003
 ;;LR;;K0035;;K0049;;01/01/2003;;01/01/2004
 ;;LR;;K0037;;K0047;;01/01/2004;;01/01/2005
 ;;LR;;K0051;;K0053;;01/01/1999;;01/01/2005
 ;;LR;;K0059;;K0063;;01/01/1999;;01/01/2004
 ;;LR;;K0059;;K0061;;01/01/2004;;01/01/2005
 ;;LR;;K0065;;K0078;;01/01/1999;;01/01/2005
 ;;LR;;K0081;;K0081;;01/01/1999;;01/01/2005
 ;;LR;;K0090;;K0097;;01/01/1999;;01/01/2005
 ;;LR;;K0106;;K0106;;01/01/1999;;01/01/2005
 ;;LR;;K0400;;K0401;;01/01/1999;;01/01/2001
 ;;LR;;K0442;;K0442;;01/01/1999;;01/01/2003
 ;;LR;;K0445;;K0445;;01/01/1999;;01/01/2003
 ;;LR;;K0556;;K0559;;01/01/2003;;01/01/2004
 ;;LR;;K0606;;K0609;;01/01/2005
 ;;LR;;L1685;;L1686;;01/01/1999;;01/01/2005
 ;;LR;;L1700;;L2188;;01/01/1999;;01/01/2003
 ;;LR;;L1700;;L1834;;01/01/2003;;01/01/2005
 ;;LR;;L1831;;L1831;;01/01/2005
 ;;LR;;L1840;;L1900;;01/01/2003;;01/01/2005
 ;;;;;;;;;;
