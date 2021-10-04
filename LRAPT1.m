LRAPT1 ;AVAMC/REG/WTY - ANATOMIC PATH PRINT ;10/16/01
 ;;5.2;LAB SERVICE;**72,173,259**;Sep 27, 1994
 S LRSF515=+$G(LRSF515)  ;Indicates an SF515 is being generated
 I LRSF515 D:$Y>(IOSL-13) F^LRAPF,^LRAPF
 I 'LRSF515 D H S LR("F")=1
 Q:LR("Q")
 F S="SP","CY","EM" Q:LR("Q")  D
 .D H1 Q:LR("Q")
 .S LRI=0
 .F  S LRI=$O(^LR(LRDFN,S,LRI)) Q:'LRI!(LR("Q"))  D EN^LRAPPF1
 Q
 ;
H1 ;
 N LRTMP
 Q:'$O(^LR(LRDFN,S,0))
 I LRSF515 D:$Y>(IOSL-13) F^LRAPF,^LRAPF
 I 'LRSF515 D:$Y>(IOSL-14) H
 Q:LR("Q")
 S LRTMP=$S(S="SP":"SURGICAL PATHOLOGY",S="CY":"CYTOPATHOLOGY",1:"")
 S:LRTMP="" LRTMP=$S(S="EM":"ELECTRON MICROSCOPY",1:"")
 W !!,?30,LRTMP
 Q
 ;
H I $D(LR("F")),$E(IOST,1,2)["C-" D M^LRU Q:LR("Q")
 D F^LRU W !,"ANATOMIC PATHOLOGY"
 I $D(LR("W")) D
 .W !,$S($D(LRO(68)):LRO(68),1:LRAA(1))," QA from ",LRSTR
 .W " to ",LRLST
 W !,LR("%")
 W !,LRP,?32,"SSN:",SSN,?48,"DOB:",DOB
 Q
