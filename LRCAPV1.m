LRCAPV1 ;SLC/FHS-DETERMINE CAP AND STUFF INTO LRO(68 PART 1 ;12/3/1997
 ;;5.2;LAB SERVICE;**42,119,153,221**;Sep 27, 1994
LOOK ;from LRVER3,LRVR3,LAMIAUT4,LRMIV1,LRMIV2
 Q:'$P(LRPARAM,U,14)!('$P($G(^LRO(68,+LRAA,0)),U,16))  I $D(XRTL) S XRTN="LRCAPV1" D T0^%ZOSV ; START RESPONSE TIME LOGGING
 Q:'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,0))#2
 S LRSSC=$G(^LRO(68,+LRAA,1,LRAD,1,LRAN,5,1,0)) Q:'$L(LRSSC)  L +^LRO(68,+LRAA,1,LRAD,1,LRAN,4)
 I $D(LRSB) S A1=0 F  S A1=$O(LRSB(A1)) Q:A1<1  S LRT=+$G(^TMP("LR",$J,"TMP",A1)),LRT("P")=$G(^TMP("LR",$J,"TMP",A1,"P")) I LRT D L60A
 N LRURGW
 K LRT S (LRTT,LRT)=0,LRURGW=9
 F  S LRTT=$O(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRTT)) Q:LRTT<.5  I $D(^(LRTT,0))#2,$E($P(^(0),U,6))'="*" S LRURGW=$S($P(^(0),U,2)<LRURGW:$P(^(0),U,2),1:LRURGW) D
 . I LRSS'="MI",'$P(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRTT,0),U,7) S LRTS(LRTT)=LRTT D RES S LRT=LRTT D L78 Q
 . S LRTS(LRTT)=LRTT D RES S LRT=LRTT D L78 Q
 D:LRSS="MI" ^LRCAPVM S LRADD=0 I $D(LRSB),$O(LRSB(0)) F LRT=0:0 S LRT=$O(LRCDEF(LRT)) Q:'LRT  D L60
 K A1,NODE,LRADD,LRSSC,LRTIME,NODE,ADDX,A,LRCODE,P,LRP,LRCNT,NODE0,X,LRPN L -^LRO(68,+LRAA,1,LRAD,1,LRAN,4)
 I $D(XRT0) S XRTN="LOOK^LRCAPV1" D T1^%ZOSV ; STOP RESPONSE TIME LOGGING 
 Q
RES K LRTIME Q:'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,0))#2
 Q:$E($P(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRTT,0),U,6))="*"
 I $G(LRSS)'="MI" Q:$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRTT,0))#2&('$P(^(0),U,5))  S LRTIME=$P(^(0),U,5)
 S LRT=LRTT S:'$D(LRTIME) LRTIME=$$NOW^XLFDT
 S:'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRTT,1,0))#2 ^(0)="^68.14P^" S NODE=^(0)
 I $D(^LAB(60,LRTT,0)),'$L($P(^(0),U,5)) S LRT=LRTT D L60,ETIO3
 ;D L78
OUT Q
L60A Q:$P(LRSB(A1),U)=""!($P(LRSB(A1),U)="canc")!($P(LRSB(A1),U)="pending")  D L60,ETIOY
 Q
L60 F A=0:0 S A=$O(^LAB(60,LRT,9,A)) Q:A<1  I $G(^(A,0)) S LRCODE=^(0),P=+$P(LRCODE,U,4),LRP=+LRCODE,LRCNT=$S($P(LRCODE,U,3):$P(LRCODE,U,3),1:1),LRCODE=$P(LRCODE,U,2),LRNOCODE=0 D:'$P(LRCODE,".",2)&(LRCDEF>0)&('P) SET^LRCAPV1A D STUF
 Q
L78 I $D(LRT),$D(LRCDEF)#2,$P($G(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),U,5) S X=^(0) I '$P(X,U,7) S $P(X,U,7)=1,$P(X,U,8)=LRCDEF,^(0)=X Q
 Q
STUF I $D(LRNOCODE) Q:LRNOCODE  I $G(LRSS)'="MI",$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),'$P(^(0),U,5) Q
 ;I $L($P($G(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),U,8)) Q
 I $G(LRSS)="MI",'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)) Q
STUFE ;
 Q:$E($P($G(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),U,6))="*"
 S LRNOCODE=0 I '$D(LRADD),$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0))#2,'$P(^(0),U,5) Q
 Q:'$D(LRADD)&($P($G(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),U,7))
 D SET^LRCAPV1S
STUFI ;from LRVER3A,LRWLST12
 Q:'$P(LRPARAM,U,14)!('$P($G(^LRO(68,+LRAA,0)),U,16))  S ^LRO(68,"AA",LRAA_"|"_LRAD_"|"_LRAN_"|"_LRT)=""
 Q
ETIO ;from LRMIBUG
 Q:'$P(LRPARAM,U,14)!('$P($G(^LRO(68,+LRAA,0)),U,16))  L +^LRO(68,+LRAA,1,LRAD,1,LRAN,4):1 I '$T W !!?10,"Someone else is editing this entry",$C(7),!! Q
DIY S LRT=LRTS,LRADD="" Q:'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,0))#2
 S:'$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,1,0))#2 ^(0)="^68.14PA^" S NODE0=^(0) S LRTIME=$$NOW^XLFDT,GLB="^LAB(61.2,+LRBG1,9,A)" D ETIOL,L78
 K LRADD L -^LRO(68,+LRAA,1,LRAD,1,LRAN,4)
 Q
ETIOY Q:'$P(LRPARAM,U,14)!('$P($G(^LRO(68,+LRAA,0)),U,16))  S:$G(LRTT) LRT=+LRTT Q:'$G(LRT)  I $D(LRT),$D(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,LRT,0)),'$P(^(0),U,5) Q
 Q:$E($P($G(^LRO(68,+LRAA,1,LRAD,1,LRAN,4,$G(LRT),0)),U,6))="*"
ETIO3 Q:'$G(LRT)  I $P($G(LRSSC),U,2) S LRSSCX=$O(^LAB(60,LRT,3,"B",$P(LRSSC,U,2),0)) I LRSSCX S GLB="^LAB(60,LRT,3,LRSSCX,9,A)" D ETIOL
 Q
ETIOL F A=0:0 S A=$O(@(GLB)) Q:A<.5  I $D(^(A,0)) S LRCODE=^(0),LRP=+LRCODE,LRCNT=$S(+$P(LRCODE,U,3):$P(LRCODE,U,3),1:1),LRCODE=$P(LRCODE,U,2) D STUFE
 Q
ENDIY ;Entry point for non microbiology accessions not using bacteria
 ;execute code. The calling point is the mumps x-ref on the .01 node
 ;each etiology selection field
1 ;
 Q:'$P($G(LRPARAM),U,14)!('$P($G(^LRO(68,+$G(LRAA),0)),U,16))
 Q:'$G(LRAA)!('$G(LRAN))!('$G(LRAD))!('$G(LRANOK))!('$G(DUZ(2)))!('$G(LRTS))
 L +^LRO(68,+LRAA,1,LRAD,1,LRAN,4)
 S LRBG1=X I '$L($G(^LAB(61.2,+$G(LRBG1),0))) L -^LRO(68,+LRAA,1,LRAD,1,LRAN,4) K LRBG1 Q
 N X,DIC,DIE,DA,D0,LRT,GLB,LRCODE,A,I,LRADD
 D DIY K LRBG1
 Q
