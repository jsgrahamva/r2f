LRUWLF	;DALOI/STAFF - FILE #68 UTILITY ;12/03/09  18:16
	;;5.2;LAB SERVICE;**72,350**;Sep 27, 1994;Build 230
	;
	;
EN	;
	;
	S:'$D(LRCS) LRCS=""
	;
STF	;
	S:'$D(LRSIT) LRSIT=LRU S:'$D(LRSVC) LRSVC=""
	;
	;S ^LRO(68,LRAA,1,LRAD,1,LRAN,0)=LRDFN_"^"_+LRDPF_"^"_LRRC_"^^^^"_LRLLOC_"^"_LRMD(1)_"^"_LRSVC_"^"_DUZ_"^"_LRCAPLOC
	;S ^(3)=LRSD_"^^"_LRRC_"^^"_LRI_"^"_LRC(5)
	;S ^(.2)=LRABV_" "_LRWHN_" "_LRAN
	;S ^(.4)=DUZ(2)
	;K LRSD
	;S ^LRO(68,LRAA,1,"AC",DUZ(2),LRAD,LRAN)=""
	;S ^LRO(68,LRAA,1,LRAD,1,"E",LRRC,LRAN)=""
	;
	S LRACC=LRABV_" "_LRWHN_" "_LRAN
	;
	; File information in file #68 for this accession
	N LRFDA,LR6802,LRDIE
	S LR6802=LRAN_","_LRAD_","_LRAA_","
	S LRFDA(1,68.02,LR6802,.01)=LRDFN
	S LRFDA(1,68.02,LR6802,1)=+LRDPF
	S LRFDA(1,68.02,LR6802,2)=LRAD
	S LRFDA(1,68.02,LR6802,6)=LRLLOC
	;
	; No ordering provider/location on controls
	I LRDPF'=62.3 D
	. S LRFDA(1,68.02,LR6802,6.5)=LRMD(1)
	. ;S LRFDA(1,68.02,LR6802,94)=LROLLOC
	;
	; Only store treating specialty on file #2 patients
	; If no treating specialty then use specialty from file #44 location
	I LRDPF=2 D
	. N LRTREA
	. S LRTREA=$P($G(^DPT(DFN,.103)),U)
	. I 'LRTREA S LRTREA=$P($G(^SC(+LRLLOC,0)),U,20)
	. I LRTREA S LRFDA(1,68.02,LR6802,6.6)=LRTREA
	;
	S LRFDA(1,68.02,LR6802,6.7)=DUZ
	S LRFDA(1,68.02,LR6802,9)=LRSD
	S LRFDA(1,68.02,LR6802,12)=LRRC
	S LRFDA(1,68.02,LR6802,13.5)=LRI
	I LRC(5)'="" S LRFDA(1,68.02,LR6802,13.6)=LRC(5)
	S LRFDA(1,68.02,LR6802,15)=LRACC
	S LRFDA(1,68.02,LR6802,26)=DUZ(2)
	S LRFDA(1,68.02,LR6802,92)=LRCAPLOC
	D FILE^DIE("","LRFDA(1)","LRDIE(1)")
	I $D(LRDIE(1)) D MAILALRT^LRWLST12("STF~LRUWLF")
	;
	; Create and store UID on accession.
	S LRUID=$$LRUID^LRX(LRAA,LRAD,LRAN)
	;
	I LRSS="CY" D
	. S ^LRO(69.2,LRAA,1,LRAN,0)=LRDFN_"^"_LRI_"^"_LRH(0)
	. L +^LRO(69.2,LRAA,1):DILOCKTM
	. S X=^LRO(69.2,LRAA,1,0),^(0)=$P(X,"^",1,2)_"^"_LRAN_"^"_($P(X,"^",4)+1)
	. L -^LRO(69.2,LRAA,1)
	Q
	;
	;
EN1	; add more tests ;used by LRUTAD
	S:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)) ^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)="^68.04PA^^"
	W !
	;
TST	;
	K LRTEST
	S DIC=60,DIC("A")="   Add Test/Procedure: ",DIC(0)="AEMOQZ",DIC("S")="I $P(^(0),U,4)=LRAA(2),$A($P(^(0),U,3))<78"
	D ^DIC K DIC
	I Y<1 S LRSIT="" Q
	;
	S (LRTEST,Y)=+Y,LRTNAM=$P(Y,U,2)
	S N=0
	F  S N=$O(^LAB(60,LRTEST,1,N)) Q:'N  S LRTEST(1)=$S($D(^LAB(60,LRTEST,1,N,0)):+^LAB(60,LRTEST,1,N,0),1:"") Q:LRTEST(1)=LRSIT
	I LRSS="CH",N<1 W $C(7),!!,"CANNOT ORDER ",LRTNAM," FOR ",$P(^LAB(61,LRSIT,0),U) G TST
	D SUM
	K LRRP
	G TST
	;
	;
SUM	;
	;
	S N=0
	F X=0:1 S N=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,N)) Q:'N  S:Y=N LRRP=1
	Q:$D(LRRP)
	S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,Y,0)=LRTEST_"^^"
	I $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0),"^",4)<1 S ^(0)="^68.04PA^"_Y_"^"_1 Q
	S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)="^68.04PA^"_Y_"^"_($P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0),"^",4)+1)
	;
	Q
