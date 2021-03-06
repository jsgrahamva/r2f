LRTSTJAN	;SLC/RWF/DCN - JAM TESTS ONTO (OR OFF) ACCESSIONS PART2 ;02/28/12  19:53
	;;5.2;LAB SERVICE;**67,100,121,128,202,221,337,350**;Sep 27, 1994;Build 230
	;
DELOG	;This tag is no longer available - Routine LRTSTOUT replaces this call.
	W @IOF,!,$$CJ^XLFSTR(" The ability to DELETE an entire ORDER/ACCESSION ",IOM)
	W !,$$CJ^XLFSTR("has been REPLACED. The test(s) will now be marked",IOM)
	W !,$$CJ^XLFSTR("as Not Performed and a reason for 'NP' will be stored",IOM)
	W !,$$CJ^XLFSTR("with each test. Accession numbers can't be reused",IOM)
	W !,$$CJ^XLFSTR("after it has been assigned to a specimen.",IOM)
	;
EN	;
	D ^LRPARAM G:$G(LREND) END
	I '$D(LRLABKY) W !?5,"You are not authorized to change test status.",! G END
	K LRSCNXB
	;
EN1	;
	N LRTOTL,LRIFN
	S (LREND,LRNOP)=0 K LRNATURE
	D FIX^LRTSTOUT G END:$G(LREND) I $G(LRNOP) D END G EN1
	W ! K DIR S DIR(0)="Y",DIR("A")="  Change Entire accession to Not Performed",DIR("B")="NO" D ^DIR K DIR
	I $D(DIRUT) G EN1
	S LRTOTL=Y,LRIFN=0
	I LRTOTL>0 D
	.F  S LRIFN=$O(^LR(LRDFN,LRSS,LRIDT,LRIFN)) Q:LRIFN=""  S:$P($G(^LR(LRDFN,LRSS,LRIDT,LRIFN)),U)="pending" $P(^LR(LRDFN,LRSS,LRIDT,LRIFN),U)=""
	;I Y=0 D CHG^LRTSTOUT W !!! G EN1
	I LRTOTL=0 D CHG^LRTSTOUT W !!! G EN1
	D FX2^LRTSTOUT I $G(LREND) D END W @IOF G EN1
	D
	. N LROTA,LRTSTS
	. S LRTSTS=0,LRNOW=$$NOW^XLFDT F  S LRTSTS=+$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRTSTS)) Q:LRTSTS<1  I $D(^(LRTSTS,0))#2,'$P(^(0),U,5) D
	. . I $D(^LAB(60,LRTSTS,0)) S LRTNM=$P(^(0),U) D
	. . . D SET^LRTSTOUT
	. . . D LEDICHK^LRTSTOUT ; If LEDI test, add test to LROTA array - ccr_6164n
	. I $D(LROTA) D LEDISET^LRTSTOUT(.LROTA) ; ccr_6164n
	L -^LRO(68,LRAA,1,LRAD,1,LRAN)
	I $G(LRSS)'="" L -^LR(+$G(LRDFN),LRSS,+$G(LRIDT))
	W @IOF,!!,"All accessioned test(s) changed",!!
	D END G EN1
	Q
	;
	;
END	K LRWRD,LRWDT1,LRTREA,LRRB,LRPRAC,LREND,LRAA,LRAD,LRAN,LRACC,LRTEST,LRTSTN,LRNATURE,LRX,LRIDIV,LRSAMP,LRGCOM,LRCOM,LRTCOM,LRDFN,LRDPF,LRACD,LRACN,LRACN0,LRDOC,LRLL,LROD0,LROD1,LROD3,LRODT,LROOS,LROS,LROSD,LROT,LRROD,LRSN,LRTSTS,LRTT,LRWL1
	K LRF,LRI,LRJ,LRMSTATI
	K I,X,X1,X2,X3,X4,DA,DR,DIC,DFN,AGE,DOB,PNM,SSN,VAIN,VADM,VAERR,VA,VA200,SSN,SEX
	D END^LRTSTOUT
	Q
	;
	;
ULK	;Unlock ^LRO(68,
	I ($G(LRAA)&($G(LRAD))&($G(LRAN))) L -^LRO(68,LRAA,1,LRAD,1,LRAN)
	Q
	;
	;
NEWSTART	;Set new starting accession #
	N LRAA,LRAD,LRAN,LRIDIV,LRX,LRACC,LREND,LRNEW
	S LREND=0
	D ^LRWU4 Q:LRAD<1
	;
N1	G NEWSTART:'$D(^LRO(68,LRAA,1,LRAD,1,0))
	R !,"""Next"" accession number: ",LRNEW:DTIME
	G NEWSTART:LRNEW="^"!(LRNEW="")
	K:(LRNEW<1)!(LRNEW>999999)!(LRNEW'=+LRNEW) LRNEW S:$D(LRNEW) LRNEW=LRNEW-1
	I '$D(LRNEW) W !,"Must be whole number between 1 and 999999, accession remains unchanged." G N1
	S $P(^LRO(68,LRAA,1,LRAD,1,0),U,3)=LRNEW
	G NEWSTART
	;
	;;
US	;ck if units selected
	S A=0 F  S A=$O(^LR(LRDFN,1.8,A)) Q:A<1!($D(C))  S B=0 F  S B=$O(^LR(LRDFN,1.8,A,1,B)) Q:B<1!($D(C))  I $P(^(B,0),"^",2)=LRIDT S C=1 Q
	Q
	;
	;
OE	;
	I $G(LRGCOM)'="",$P($G(LRNATURE),"^",5)'="",$P(LRNATURE,"^",5)'["=>" S $P(LRNATURE,"^",5)=LRCM
	N I S:$G(LRTS) I(+LRTS)="" D NEW^LR7OB1(LRODT,LRSN,$S($G(LRMSTATI)=""!($G(LRMSTATI)=1):"OC",1:"SC"),$G(LRNATURE),.I,$G(LRMSTATI))
	Q
	;
	;
LRACC	S LREND=0 D ^LRWU4 S DA(2)=LRAA,DA(1)=LRAD
	Q
