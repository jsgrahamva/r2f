LRLABELF ;SLC/CJS/DALISC/DRH - PRINT COLLECTION LIST (CONT.) ; 3/28/89  19:39
 ;;5.2;LAB SERVICE;**121,161**;Sep 27, 1994
 ; Called by LRLABLDS,LRLABLD0
INIT ;
 U IO
 S (PAGE,LREND,CNT)=0,LRPRTDT=$$NOW^XLFDT
 I LRPICK=1,$E(IOST,1,2)="C-" W @IOF
EN ;
 S LRODT=""
 F  S LRODT=$O(^TMP($J,"LR",LRODT)) Q:LRODT=""!($G(LREND))  D 
 . S LRCT=""
 . F  S LRCT=$O(^TMP($J,"LR",LRODT,LRCT)) Q:LRCT=""!($G(LREND))  D
 . . S LRCLOC=""
 . . F  S LRCLOC=$O(^TMP($J,"LR",LRODT,LRCT,LRCLOC)) Q:LRCLOC=""!($G(LREND))  D
 . . . I LRPICK=1 D HEAD
 . . . S LRPNM=""
 . . . F  S LRPNM=$O(^TMP($J,"LR",LRODT,LRCT,LRCLOC,LRPNM)) Q:LRPNM=""!($G(LREND))  D PAT
 . I LRPICK=1 D
 . . S PAGE=0
 . . I $E(IOST,1,2)="C-" W !!
 . . E  W @IOF
 Q
 ;
HEAD ;
 Q:$G(LREND)
 I PAGE D
 . I $E(IOST,1,2)="C-" D EOP
 . W @IOF
 S PAGE=PAGE+1,LRHEAD=$$FMTE^XLFDT(LRODT)_"   "_"Future Collection List"
 W !,$$CJ^XLFSTR(LRHEAD,IOM)
 S LRPAGE="Page: "_PAGE
 W !,"Print Date@Time : ",$$FMTE^XLFDT(LRPRTDT),?60,LRPAGE
 W !!,$$CJ^XLFSTR(LRCLOC,IOM,"-")
 W !,$$CJ^XLFSTR("WARD LOC/REQ LOC ",IOM," ")
 Q
HDR ;
 D HEAD
PHDR W:$G(CHDR) !?20,"< CONTINUATION >"
 S LRNEW=PNM
 W !,PNM I $L($G(LRRB))>1 W ?32,LRRB
 W ?42,SSN,?57,"Order #: ",LRCE
 W:$L($G(^LR(+LRNODE0,.091))) !?4,"Pat Info: ",^(.091)
 S LRPCT=$$FMTE^XLFDT(LRCT,1) S:$P(LRPCT,"@",2) LRPCT=$P(LRPCT,"@",2)_"  "_$P(LRPCT,"@")
 W !?5,LRPCT,?25,"[ "_LRTYPE_" ]"
 N LRURG S NODE=LRNODE0,(S2,LRTVOL)=0
 D T^LRLABLD0
 S LRTOP=$P($G(^LAB(62,+$P(LRNODE0,U,3),0)),U,3) I $L(LRTOP) S S2=$P(^(0),U,5)
 W !?28,$S(S2="":" ",LRTVOL>S2:"Large ",1:"Small "),LRTOP," ",$S($G(LRTVOL):LRTVOL,1:1)," mL ",!
 Q
 ;
CHDR ;
 W !?10,"<CONTINUE NEXT PAGE # "_PAGE+1_" >"
 S CHDR=1 D PHDR S CHDR=0
 Q
 ;
PAT ;
 S LRSNN=""
 F  S LRSNN=$O(^TMP($J,"LR",LRODT,LRCT,LRCLOC,LRPNM,LRSNN)) Q:LRSNN=""!($G(LREND))  D
 . W:LRPICK=1 !
 . K LRNEW
 . D PRINT
 Q
PRINT ;
 S LRSN=+$P(LRSNN,"*",2)
 Q:'$D(^LRO(69,LRODT,1,LRSN,0))#2  S LRNODE0=^(0),LRCE=$G(^(.1)) Q:'LRCE
 I LRPICK=2 D SETUP^LRLABLD0 Q  ; Print labels
 S LRDFN=+LRNODE0 K LRDPF
 D PT^LRX Q:$G(LREND)!(+LRDPF'=2)
 Q:$G(LREND)
 S LRTYPE="",LRPORD=1,LRTOP=$P($G(^LAB(62,+$P(LRNODE0,U,3),0)),U)
 S LRORD=$G(^LRO(69,LRODT,1,LRSN,.1))
 I $L($P(LRNODE0,U,4)) S LRTYPE=$G(LRCOLTY($P(LRNODE0,U,4))) ; Collection type
 I LRTYPE="" S LRTYPE="Unknown"
 I $Y>(IOSL-4) D HDR
 S LRSP=0 I '$D(LRNEW) D PHDR S LRNEW=LRPNM
 I LRNEW'=LRPNM D PHDR
 F TAB=5:35 S LRSP=$O(^LRO(69,LRODT,1,LRSN,2,LRSP)) Q:LRSP<1  D
 . N LRURGA
 . Q:'$D(^LRO(69,LRODT,1,LRSN,2,LRSP,0))
 . S LRTEST=^LRO(69,LRODT,1,LRSN,2,LRSP,0),LRURGN=$P(LRTEST,U,2) S:'LRURGN LRURGN=9
 . I $P(LRTEST,"^",11) Q  ; Test cancelled
 . S LRURGA=$$URGA^LRLABLD(+LRURGN)
 . S LRTEST=$P($G(^LAB(60,+$P(LRTEST,U),0)),U)
 . I TAB>45 S TAB=5 W ! I $Y>(IOSL-4) D HDR
 . W ?TAB,$S(LRURGN<3:"** ",1:"")," (",$P(LRURGA,"^"),") ",LRTEST
 Q
DEV ;
 K %ZIS S %ZIS="" D ^%ZIS Q:POP
 U IO D INIT W !! W:$E(IOST,1,2)'="C-" @IOF
 D ^%ZISC
 Q
 ;
EOP ; End-of-page
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="E"
 D ^DIR
 I $D(DIRUT) S LREND=1
 Q
 ;
END ;
 ; Called by LRLABLD0, LRLABLDS
 I $G(LRPICK)=1 W:$E(IOST,1,2)'="C-" @IOF
 I $D(ZTQUEUED) S ZTREQ="@"
 E  D ^%ZISC
 D KVA^VADPT
 K ^TMP($J)
 K A,DIR,DUOUT,DTOUT,DIRUT
 K LRBARID,LRCOLTY,LREND,LRHEAD,LRNODE0,LRORD,LRPCT,LRUID
 K LRPERH,LRPERT,LRSP,LRTEST,LRTYPE,LRURGN,TAB
 K LRWRD,LRLOCF1,LRLOCF,LRCHLOC,LRDPF,J,S,C,%ZIS,%DT,DIC,DFN,I,L9,LRACC,LRCE,LRCLTY,LRDAT
 K LRPRAC,CNT,LRCLOC,LRCT,LRNEWL,LRORDN,LRPICK,LRPNM,LRSING,LRSNN,LRTREA
 K PAGE,D0,D1,LRPRTDT
 K LRDFN,LRINFW,LRLABEL,LRLLOC,LRODT,LRCT0,LRPREF,LRRB,LRSN,LRSSP
 K LRTJ,LRTJDATA,LRTOP,LRTS,LRTV,LRTVOL,LRURG,LRURGA,LRURG0,LN,LRSTOP,LRTIC
 K LRDTC,LRTXT,LRVOL,LRXL,N,NODE,S1,S2,T,Y,Y1,Y2
 K ZTSAVE,ZTIO,ZTRTN,ZTDESC
 K AGE,DOB,PNM,SEX,SSN,POP,E,VA,LRY1,VAERR,X
 Q
