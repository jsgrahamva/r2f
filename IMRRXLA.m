IMRRXLA ;HCIOFO/NCA/FT-List Data on Outpatient Pharmacy Utilization (Cont.) ;7/28/97  13:01
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 S IMR1C="" F IMR0C=0:0 S IMR1C=$O(^TMP($J,IMR1C)) Q:IMR1C=""  D A1
 Q
 ;
A1 ;
 S ^TMP($J,IMR1C,"RX")=0,^("RX","F")=0,IMRCMAX=0,IMRNMAX=0 F IMRDFN=0:0 S IMRDFN=$O(^TMP($J,IMR1C,"PAT",IMRDFN)) Q:IMRDFN'>0  D A2
 S I="" F IMRI=0:0 S I=$O(^TMP($J,IMR1C,"RX",0,I)) Q:I=""  S X=^(I),X1=^(I,"N"),N=I,C=^("C"),Q=^("Q"),^TMP($J,IMR1C,"A",(999999-X1),N)=X_U_X1_U_Q_U_C D A3
 Q
 ;
A2 ;
 Q:$O(^TMP($J,IMR1C,"PAT",IMRDFN,""))=""  S ^("RX")=^TMP($J,IMR1C,"RX")+1,^("PA",IMRDFN)=0
 S K=0,J="",IMRCTOT=0
 F IMRJ=0:0 S J=$O(^TMP($J,IMR1C,"PAT",IMRDFN,J)) Q:J=""  S K=K+1,X=^(J),C=^(J,"C"),Q=^("Q"),^("F")=^TMP($J,IMR1C,"RX","F")+X D A201
 S X=^TMP($J,IMR1C,"PA",IMRDFN) K ^(IMRDFN) S C=+$P(X,U,3),^TMP($J,IMR1C,"RF",(999999-X),IMRDFN)=IMRDFN_U_X S:C>0 ^TMP($J,IMR1C,"RC",(999999-C),IMRDFN)=IMRDFN_U_X
 Q:IMRCTOT'>0  S IMRCTOT=IMRCTOT\100*100,C1=IMRCTOT_"-"_(IMRCTOT+99),J=999999-K
 S ^(J)=($S($D(^TMP($J,IMR1C,"RX","N",J)):+^(J),1:0)+1)_U_K,^(C1)=$S($D(^TMP($J,IMR1C,"RX","CST",(9999999-IMRCTOT),C1)):^(C1),1:0)+1 I IMRCTOT>IMRCMAX K ^(IMRCMAX,"NAM") S IMRNMAX=0,IMRCMAX=IMRCTOT
 I IMRCMAX=IMRCTOT S DFN=IMRDFN D NS^IMRCALL K DFN S IMRNMAX=IMRNMAX+1,^TMP($J,IMR1C,"RX","CST",(9999999-IMRCTOT),C1,"NAM",IMRNMAX)=IMRNAM_U_IMRSSN
 Q
A201 ;
 S ^(J)=$S($D(^TMP($J,IMR1C,"RX",0,J)):^(J),1:0)+1,^("N")=$S($D(^(J,"N")):^("N"),1:0)+X,^(X)=$S($D(^(X)):^(X),1:0)+1 D A21
 Q
 ;
A21 S ^("C")=$S($D(^TMP($J,IMR1C,"RX",0,J,"C")):^("C"),1:0)+C,^("Q")=$S($D(^("Q")):^("Q"),1:0)+Q,IMRCTOT=IMRCTOT+C
 S ^(IMRDFN)=(^TMP($J,IMR1C,"PA",IMRDFN)+X)_U_K_U_IMRCTOT
 Q
 ;
A3 S ^TMP($J,IMR1C,"C",(9999999-C),N)=X_U_X1_U_C_U_Q
 S M=0 F K=0:0 S K=$O(^TMP($J,IMR1C,"RX",0,I,K)) Q:K'>0  S M=K_U_^(K)
 S ^TMP($J,IMR1C,"A",(999999-X1),N,"MAX")=M,^("C")=C
 Q
