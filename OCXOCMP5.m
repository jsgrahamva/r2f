OCXOCMP5 ;SLC/RJS,CLA - ORDER CHECK CODE COMPILER (Optimize Order Check Sub-Routines) ;2/02/99  13:39
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
EN() ;
 ;
 Q:$G(OCXWARN) 1
 N OCXPC,OCXD0,OCXD1,OCXD2,OCXD3
 ;
 S OCXD0=0 F  S OCXD0=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0)) Q:'OCXD0  D
 .I '$G(OCXAUTO) W:($X>60) ! W "."
 .S OCXD1=0 F  S OCXD1=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0,OCXD1)) Q:'OCXD1  D
 ..S OCXLINE=$G(^TMP("OCXCMP",$J,"C CODE",OCXD0,OCXD1,0))
 ..Q:'$L(OCXLINE)  Q:'(OCXLINE["||LINE:")
 ..F OCXPC=2:1:$L(OCXLINE,"||LINE:") S OCXD2=+$P(OCXLINE,"||LINE:",OCXPC) D
 ...S:OCXD2 ^TMP("OCXCMP",$J,"CALLREF",OCXD2,OCXD0,OCXD1)=""
 ;
 S OCXD0=$G(^TMP("OCXCMP",$J,"LINE","B","SCAN")) I OCXD0 D
 .S OCXD1=0 F  S OCXD1=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0,OCXD1)) Q:'OCXD1  Q:(^(OCXD1,0)["D @OCXPGM")
 .S OCXD3=199999 F  S OCXD3=$O(^TMP("OCXCMP",$J,"LINE",OCXD3)) Q:(OCXD3>299999)  D
 ..S ^TMP("OCXCMP",$J,"CALLREF",OCXD3,OCXD0,OCXD1)=""
 ..I '$G(OCXAUTO) W:($X>60) ! W "."
 ;
 F  S OCXFLAG=0 D  Q:'OCXFLAG
 .S OCXD0=0 F  S OCXD0=$O(^TMP("OCXCMP",$J,"CALLREF",OCXD0)) Q:'OCXD0  D
 ..I '$G(OCXAUTO) W:($X>60) ! W "."
 ..N OCXNSUB,OCXLLAB,OCXCNT,OCXCHG,OCXCOD1,OCXCOD2
 ..N OCXD1,OCXD2,OCXCALL,OCXOP1,OCXOP2,OCXOP3,OCXREC1,OCXREC2
 ..S OCXCALL=" D ||LINE:"_OCXD0_"||"
 ..Q:$D(^TMP("OCXCMP",$J,"C CODE",OCXD0,13000))
 ..Q:$D(^TMP("OCXCMP",$J,"C CODE",OCXD0,16001))
 ..S OCXCOD1=$G(^TMP("OCXCMP",$J,"C CODE",OCXD0,16000,0)) Q:'$L(OCXCOD1)
 ..S OCXOP1=$G(^TMP("OCXCMP",$J,"C CODE",OCXD0,16000,"OPLIST"))
 ..S (OCXCNT,OCXCHG)=0
 ..S OCXD1=0 F  S OCXD1=$O(^TMP("OCXCMP",$J,"CALLREF",OCXD0,OCXD1)) Q:'OCXD1  D
 ...S OCXD2=0 F  S OCXD2=$O(^TMP("OCXCMP",$J,"CALLREF",OCXD0,OCXD1,OCXD2)) Q:'OCXD2  D
 ....S OCXCOD2=$G(^TMP("OCXCMP",$J,"C CODE",OCXD1,OCXD2,0)) Q:'(OCXCOD2[OCXCALL)
 ....S OCXOP2=$G(^TMP("OCXCMP",$J,"C CODE",OCXD1,OCXD2,"OPLIST"))
 ....S OCXOP3=$E(OCXOP2,1,$L(OCXOP2)-1)
 ....S OCXCNT=OCXCNT+1
 ....Q:(($L(OCXCOD1)+$L(OCXCOD2))>OCXCLL)
 ....Q:(OCXOP2["Y")
 ....I $L(OCXOP1),$L(OCXOP3),($E(OCXOP1,1)=$E(OCXOP3,$L(OCXOP3))),'($E(OCXOP1,1)="Z") D
 .....S OCXCOD2=$P(OCXCOD2,OCXCALL,1)_","_$P(OCXCOD1," ",3,999)_$P(OCXCOD2,OCXCALL,2,9999)
 .....S OCXOP2=OCXOP3_$E(OCXOP1,2,$L(OCXOP1))_$P(OCXOP2,"D",2,999)
 ....E  D
 .....S OCXCOD2=$P(OCXCOD2,OCXCALL,1)_OCXCOD1_$P(OCXCOD2,OCXCALL,2,9999)
 .....S OCXOP2=OCXOP3_OCXOP1_$P(OCXOP2,"D",2,999)
 ....S ^TMP("OCXCMP",$J,"C CODE",OCXD1,OCXD2,0)=OCXCOD2
 ....S ^TMP("OCXCMP",$J,"C CODE",OCXD1,OCXD2,"OPLIST")=OCXOP2
 ....K ^TMP("OCXCMP",$J,"CALLREF",OCXD0,OCXD1,OCXD2)
 ....F OCXPC=2:2:$L(OCXCOD2,"D ||LINE:") S OCXD3=+$P(OCXCOD2,"D ||LINE:",OCXPC) D
 .....S ^TMP("OCXCMP",$J,"CALLREF",OCXD3,OCXD1,OCXD2)=""
 ....S OCXCHG=OCXCHG+1,OCXFLAG=1
 ..I (OCXCNT=OCXCHG) D
 ...S OCXLLAB=$P(^TMP("OCXCMP",$J,"LINE",OCXD0),U,1)
 ...Q:'($E(OCXLLAB,1,3)="CHK")
 ...K ^TMP("OCXCMP",$J,"C CODE",OCXD0)
 ...K ^TMP("OCXCMP",$J,"CALLREF",OCXD0)
 ...K ^TMP("OCXCMP",$J,"LINE",OCXD0)
 ...K ^TMP("OCXCMP",$J,"LINE","B",OCXLLAB)
 ;
 Q OCXWARN
 ;
