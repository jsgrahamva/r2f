ICPT640P	;KER - ICPT*6.0*40 Post-Install ;11/17/2007
	;;6.0;CPT/HCPCS;**40**;May 19, 1997;Build 1
	;
POST	;
	D AJ
	Q
AJ	      ; Modifier AH and AJ
	N ICPTACT,ICPTB,DA,DIK,ICPTE,ICPTEX,ICPTL,ICPTM,ICPTND,ICPTNX,ICPTR,ICPTT,ICPTXT S ICPTACT=3050101
	S ICPTM=$O(^DIC(81.3,"B","AJ",0)) Q:+ICPTM'>0
	S ICPTR=0 F  S ICPTR=$O(^DIC(81.3,ICPTM,10,ICPTR)) Q:+ICPTR'>0  D
	. N DA,DIK S DA(1)=ICPTM,DA=ICPTR,DIK="^DIC(81.3,"_DA(1)_",10,"
	. Q:$L($P($G(^DIC(81.3,ICPTM,10,ICPTR,0)),"^",4))  D ^DIK
	F ICPTL=1:1 D  Q:'$L(ICPTXT)
	. N ICPTB,DA,DIK,ICPTE,ICPTEX,ICPTND,ICPTNX,ICPTR,ICPTT S ICPTR=0,ICPTXT="" S ICPTEX="S ICPTXT=$T(RAN+"_ICPTL_")" X ICPTEX
	. S ICPTXT=$$TM(ICPTXT," ") Q:'$L(ICPTXT)  Q:'$L($TR(ICPTXT,";",""))  S ICPTXT=$P(ICPTXT,";",3,299)
	. S ICPTB=$P(ICPTXT,"^",1),ICPTE=$P(ICPTXT,"^",2) Q:$L(ICPTB)'=5  Q:$L(ICPTE)'=5  S ICPTND=ICPTB_"^"_ICPTE_"^"_ICPTACT
	. S ICPTT=0 F  S ICPTT=$O(^DIC(81.3,+ICPTM,10,"B",ICPTB,ICPTT)) Q:+ICPTT=0  D
	. . I $P($G(^DIC(81.3,+ICPTM,10,ICPTT,0)),"^",1,3)=ICPTND S ICPTR=ICPTT
	. Q:+ICPTR>0  S ICPTNX=$O(^DIC(81.3,+ICPTM,10," "),-1)+1
	. S ^DIC(81.3,+ICPTM,10,ICPTNX,0)=ICPTND,^DIC(81.3,+ICPTM,10,0)="^81.33DA^"_ICPTNX_"^"_ICPTNX
	. S DA(1)=+ICPTM,DA=ICPTNX,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK K DA
	K DA S DA=+ICPTM,DIK="^DIC(81.3," D IX1^DIK K DA
	Q
TM(X,Y)	; Trim Spaces
	S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" " F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
	F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
	F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,229)
	Q X
RAN	; Modifier AJ Code Ranges
	;;90801^90804
	;;90806^90808
	;;90810^90810
	;;90812^90812
	;;90814^90814
	;;90846^90853
	;;90857^90857
	;;96116^96120
	;;97532^97533
	;;96150^96151
	;; 
