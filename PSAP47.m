PSAP47 ;BHM/DB/PDW - CORRECT DATA IN XTMP("PSAPV" ;9/30/04
 ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**47**; 10/24/97
 Q:'$D(^XTMP("PSAPV"))
 S X=0 F  S X=$O(^XTMP("PSAPV",X)) Q:+X'>0  S Y=+X D
 . F  Q:'$D(^XTMP("PSAPNEW",Y))  S Y=Y+1
 . M ^XTMP("PSAPNEW",Y)=^XTMP("PSAPV",X) ;W !,X,?30," =>  ",Y
 S ^XTMP("PSAPNEW",0)=^XTMP("PSAPV",0)
 K ^XTMP("PSAPV")
 M ^XTMP("PSAPV")=^XTMP("PSAPNEW")
 K ^XTMP("PSAPNEW"),X,Y
 Q
