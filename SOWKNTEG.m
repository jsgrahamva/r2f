SOWKNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;APR 27, 1993@13:24:55
 ;;3.0; Social Work ;;27 Apr 93
 ;;7.0;APR 27, 1993@13:24:55
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
SOWKAI ;;16305479
SOWKAR10 ;;14236043
SOWKARS ;;14521939
SOWKARS1 ;;18777021
SOWKARS2 ;;7449645
SOWKARS3 ;;16667309
SOWKARS4 ;;10817406
SOWKARS5 ;;15465749
SOWKARS6 ;;16633298
SOWKAWB ;;13339750
SOWKAWI ;;13217836
SOWKAWS ;;13951899
SOWKAWU ;;13765101
SOWKBH ;;12299984
SOWKCDR ;;7116274
SOWKCLCR ;;18567302
SOWKCLEA ;;10538327
SOWKCLIS ;;14247325
SOWKCLIW ;;16363946
SOWKCLOS ;;8092518
SOWKCLSP ;;16805620
SOWKCLSS ;;14979588
SOWKCLSW ;;17185283
SOWKCO ;;3898139
SOWKCONV ;;4436757
SOWKCOR ;;5609249
SOWKCP ;;15376647
SOWKCS ;;5761811
SOWKDB ;;15800513
SOWKDB1 ;;18335188
SOWKDB2 ;;14758265
SOWKDBE ;;11529639
SOWKDBEN ;;4819385
SOWKDBPA ;;15244363
SOWKDBPN ;;13688251
SOWKDBSR ;;6093680
SOWKDSC ;;9428821
SOWKHELP ;;451888
SOWKHINC ;;5240870
SOWKHIRH ;;9003381
SOWKHIRM ;;4296299
SOWKHR ;;18756024
SOWKHR1 ;;12359499
SOWKHRM ;;11699697
SOWKHRM1 ;;8787118
SOWKLC ;;11342110
SOWKLCD ;;7717468
SOWKLOC ;;1966030
SOWKND ;;14149382
SOWKNEW ;;17310955
SOWKOPEN ;;13991685
SOWKOPT ;;15130764
SOWKPAD ;;2712545
SOWKPAO ;;17447663
SOWKPAOD ;;12709807
SOWKPAOQ ;;7129575
SOWKPC ;;12576211
SOWKPLC ;;14761937
SOWKPNTF ;;8707402
SOWKPREI ;;3898958
SOWKPTC ;;9609396
SOWKQAM1 ;;10904679
SOWKQAM3 ;;10977624
SOWKQAM4 ;;17408693
SOWKQAM5 ;;12713872
SOWKQAMN ;;12542049
SOWKQAMR ;;15354672
SOWKQAR2 ;;13111829
SOWKQAR4 ;;10616112
SOWKQARI ;;13804667
SOWKRCH ;;14957542
SOWKRCH1 ;;5741075
SOWKRCS ;;8410142
SOWKRF ;;11343394
SOWKRFD ;;6784701
SOWKRKD ;;6058520
SOWKSITE ;;5418158
SOWKTC ;;11716158
SOWKTRAN ;;5223185
SOWKTY ;;1236574
