RMPFET85 ;DDC/KAW-CONTINUATION OF RMPFET84 [ 06/16/95   3:06 PM ]
 ;;2.0;REMOTE ORDER/ENTRY SYSTEM;;JUN 16, 1995
CERT ;;Set Custom Hearing Aid Order Certification
 ;; input: RMPFX,RMPFY,RMPFHAT,MD,BX
 ;;output: None
 S S0=$G(^RMPF(791810,RMPFX,101,RMPFY,0)),RMPFSTO=$P(S0,U,18)
 I RMPFSTO,$D(^RMPF(791810.2,RMPFSTO,0)) S RMPFSTO=$P(^(0),U,2)
 S IT=$P(S0,U,1) I IT,$D(^RMPF(791811,IT,0)) S IT=$P(^(0),U,1)
C1 G C12:BX=1
 W !!,"Certify line item ",MD," (",IT,")","? YES// " D READ
 G CERTE:$D(RMPFOUT)
C11 I $D(RMPFQUT) W !!,"Enter a <Y> or <RETURN> to certify the line item",!?5,"an <N> to exit." G C1
 S:Y="" Y="Y" S Y=$E(Y,1) I "YyNn"'[Y S RMPFQUT="" G C11
 G CERTE:"Nn"[Y
C12 I RMPFSTO="E"!(RMPFSTO="D") D CLEAR^RMPFET61 G CERTE:'$D(RMPFSTO)
 S X="NOW",%DT="T" D ^%DT S TD=Y
 S AP=$P(S0,U,20) I 'AP S LA="R" G C2
 S LA=$P(S0,U,19) I LA="" S LA="R" G C2
 S LA=$S(LA="O":"R",LA'["R":LA_"R",AP&(LA["R"):LA,1:"R")
C2 S DIE="^RMPF(791810,"_RMPFX_",101,",DA(1)=RMPFX,DA=RMPFY
 S DR=".05" D ^DIE I $P(^RMPF(791810,RMPFX,101,RMPFY,0),U,5)="" W !!,"*** SERIAL NUMBER REQUIRED FOR A CERTIFICATION ***" H 1 G CERTE
 S DR=".17////"_TD_";.19////"_LA_";.2////1"
 I $P($G(^RMPF(791810,RMPFX,101,RMPFY,90)),U,8) S DR=DR_";90.1////"_DUZ_";90.11////"_TD
 E  S DR=DR_";90.08////"_DUZ_";90.09////"_TD
 D ^DIE
 I DR'[90.1 G CERTE:'$P($G(^RMPF(791810,RMPFX,101,RMPFY,90)),U,8)
 E  G CERTE:'$P($G(^RMPF(791810,RMPFX,101,RMPFY,90)),U,10)
 I RMPFHAT="I" S DR=".18///ISSUE DATE PENDING" D ^DIE
 W !!,"*** Order " W:$P($G(^RMPF(791810,RMPFX,101,RMPFY,90)),U,10) "Re-" W "Certified ***" H 1
 W ! S DIE="^RMPF(791810,",DA=RMPFX,DR=10.01 D ^DIE
CERTE K S0,%DT,D0,DA,DI,DQ,DIC,IT,X,Y,DIE,DR,TD,AP,LA,RMPFBT,RMPFSTO Q
READ K RMPFOUT,RMPFQUT
 R Y:DTIME I '$T W $C(7) R Y:5 G READ:Y="." S:'$T Y=U
 I Y?1"^".E S (RMPFOUT,Y)="" Q
 S:Y?1"?".E (RMPFQUT,Y)=""
 Q
