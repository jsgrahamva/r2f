XTFC0 ;SF-ISC.SEA/JLI -  FLOW CHART GENERATOR FOR MUMPS ROUTINES ;9/21/93  09:44 ;
 ;;7.3;TOOLKIT;;Apr 25, 1995
LINE ; Analyze one line of routine ROU
 I '$D(XTEXT) S XTOFF="",XTFFLG=0 I XTIFLG>0 S XTCOND=0,XTIFLG=0 ; XTIFLG counts number of IFs on line
 S XTXB=X D SCHAR ; SET UP DUPLICATES IN XTXB AND X, SCHAR MARKS AREAS IN XTXB THAT ARE SURROUNDED BY QUOTES OR PARENTHESES SO THEY ARE RECOGNIZED AS SPECIAL
 I $E(XTXB,1)=" " S XTXB=$E(XTXB,2,999),X=$E(X,2,999)
 E  D LABEL
 S XTDPER=0 D PARSE ; XTDPER WILL COUNT NUMBER OF PERIODS AT BEGINNING OF LINE
 K XTXB,X,XTXB1,XTX1B,XTII,XTIK
 Q
 ;
PARSE ; Parse out commands
 I $E(XTXB,1)=" " S XTXB=$E(XTXB,2,$L(XTXB)),X=$E(X,2,$L(X)) G PARSE
 I $E(XTXB,1)="." S XTXB=$E(XTXB,2,$L(XTXB)),X=$E(X,2,$L(X)),XTDPER=XTDPER+1 G PARSE
 I $D(XTEXT(XTDPER+1)) D
 . S XTEXT(0)=X,XTEXTB(0)=XTXB,XTDPER=XTDPER+1
 . S X="ENAD "_XTEXT(XTDPER),XTXB="ENAD "_XTEXTB(XTDPER) K XTEXT(XTDPER),XTEXTB(XTDPER) S ZI=$G(ZI)+1,XZ(ZI)=X,XZB(ZI)=XTXB
 . D PARS1
 . S XTDPER=XTDPER-1,X=XTEXT(0),XTXB=XTEXTB(0) K XTEXT(0),XTEXTB(0)
 I XTDPER=0 S XTOFF="",XTFFLG=0 I XTIFLG>0 S XTCOND=0,XTIFLG=0
 I XTDPER>0 S XTOFF=XTOFF(XTDPER),XTFFLG=XTFFLG(XTDPER),XTCOND=XTCOND(XTDPER),XTIFLG=XTIFLG(XTDPER)
PARS1 ;
 Q:XTXB=""  I $E(XTXB,1)=" " S XTXB=$E(XTXB,2,$L(XTXB)),X=$E(X,2,$L(X)) G PARS1
 S C=$E(XTXB,1) I C=";" Q  ; Ignore comments
 S XTXO=$S($L($P(XTXB,":"))<$L($P(XTXB," ")):$P(XTXB,":"),1:$P(XTXB," "))
 F J=1:1 S XTCOM=$T(COMND+J) Q:XTCOM=""  S K=0 S M=$P(XTCOM,";;",3) S:XTXO=M K=1 S:K=0 M=$P(XTCOM,";;",2) S:XTXO=M K=1 I K=1 D PARS2 Q
 I XTCOM="",$E(XTXO)="Z" S XTCOM=$T(Z),M=XTXO D PARS2 Q
 I XTCOM="" W !,X S XTXB1=$P(XTXB," ",1),XTXB=$P(XTXB," ",2,999),X=$E(X,$L(XTXB1)+2,$L(X))
 G:X]"" PARS1
 K C,J,XTCOM,K,M,XTXB1
 Q
PARS2 ;
 S XTXB=$E(XTXB,$L(M)+1,999),X=$E(X,$L(M)+1,999),XTLOC=$P(XTCOM,";;",4),XTOCOND=0
 D:$E(XTXB,1)=":" OPCOND
 I $E(XTXB,1,2)="  "&($E(M)="D"!($E(M)="F")) S XTARG="&ARGLS"_(XTDPER+1)_" ",XTXB=XTARG_$E(XTXB,3,999),X=XTARG_$E(X,3,999)
 S:$E(XTXB,1)=" " XTXB=$E(XTXB,2,999),X=$E(X,2,999)
 D @XTLOC D:XTOCOND ENDCOND
 K XTLOC,XTOCOND
 Q
 ;
OPCOND ;
 S XTXB1=$P(XTXB," ",1),XTXB=$E(XTXB,$L(XTXB1)+1,999),XTX1=$E(X,2,$L(XTXB1)),X=$E(X,$L(XTXB1)+1,$L(X)),XTENTR=XTENTR+1,XTCOND=XTCOND+1,XTOCOND=1,^TMP($J,XTLEV,"FC",XTENTR,"DECIS")=XTOFF_"< "_XTX1_" >",XTOFF=XTOFF_"...."
 Q
 ;
ENDCOND ;
 S XTCOND=XTCOND-1,XTOCOND=0,XTOFF=$E(XTOFF,1,$L(XTOFF)-4)
 Q
 ;
LABEL ;
 S XTX1B=$P(XTXB," ",1),XTXB=$P(XTXB," ",2,999),XTX1=$E(X,1,$L(XTX1B)),X=$E(X,$L(XTX1B)+2,$L(X)) S XTX2="" I XTX1["(" S XTX2="("_$P(XTX1,"(",2,99),XTX1=$P(XTX1,"(")
 S XTENTR=XTENTR+1,^TMP($J,XTLEV,"FC",XTENTR,"LABEL")=XTX1_"^"_XTROU_XTX2_" ====================> "
 Q
 ;
SCHAR ;
 F XTII=1:1:$L(XTXB) I $E(XTXB,XTII)="""" D  ; PROCESS QUOTE
 . S XTXB=$E(XTXB,1,XTII-1)_"."_$E(XTXB,XTII+1,$L(XTXB))
 . F XTIK=XTII+1:1:$L(XTXB) S XTXB=$E(XTXB,1,XTIK-1)_"."_$E(XTXB,XTIK+1,$L(XTXB)) I $E(X,XTIK)="""" Q:$E(X,XTIK+1)'=""""  S XTIK=XTIK+1,XTXB=$E(XTXB,1,XTIK-1)_"."_$E(XTXB,XTIK+1,$L(XTXB))
 F XTII=1:1:$L(XTXB) I $E(XTXB,XTII)="(" D  K XTPAR ; PROCESS PARENS
 . S XTPAR=1,XTXB=$E(XTXB,1,XTII-1)_"."_$E(XTXB,XTII+1,$L(XTXB))
 . F XTIK=XTII+1:1:$L(XTXB) Q:XTPAR=0  S C=$E(XTXB,XTIK),XTPAR=XTPAR+$S(C="(":1,C=")":-1,1:0),XTXB=$E(XTXB,1,XTIK-1)_"."_$E(XTXB,XTIK+1,$L(XTXB))
 Q
 ;
CLEAR ; Used to clear possible arrays before next routine.
 K XTDPER,XTOFF,XTCOND,XTEXT,XTEXTB,XTIFLG,XTFFLG,ZI,XZ,XZB
 Q
 ;
COMND ;
B ;;B;;BREAK;;BREAK^XTFC1
C ;;C;;CLOSE;;CLOSE^XTFC1
D ;;D;;DO;;DO^XTFC1
E1 ;;ENAD;;ENAD;;ENAD^XTFC1
E ;;E;;ELSE;;ELSE^XTFC1
ESTART ;;ESTA;;ESTART;;ESTART^XTFC1
ESTOP ;;ESTO;;ESTOP;;ESTOP^XTFC1
ETRIG ;;ETR;;ETRIGGER;;ETRIG^XTFC1
F ;;F;;FOR;;FOR^XTFC1
G ;;G;;GOTO;;GO^XTFC1
H1 ;;H;;HALT;;HALT^XTFC1
H2 ;;H;;HANG;;HALT^XTFC1
I ;;I;;IF;;IF^XTFC1
J ;;J;;JOB;;JOB^XTFC1
K ;;K;;KILL;;KILL^XTFC1
L ;;L;;LOCK;;LOCK^XTFC1
M ;;M;;MERGE;;MERGE^XTFC1
N ;;N;;NEW;;NEW^XTFC1
O ;;O;;OPEN;;OPEN^XTFC1
Q ;;Q;;QUIT;;QUIT^XTFC1
R ;;R;;READ;;READ^XTFC1
S ;;S;;SET;;SET^XTFC1
U ;;U;;USE;;USE^XTFC1
V ;;V;;VIEW;;VIEW^XTFC1
W ;;W;;WRITE;;WRITE^XTFC1
X ;;X;;XECUTE;;XECUT^XTFC1
Z ;;Z;;Z;;ZCMND^XTFC1
