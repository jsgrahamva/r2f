SRSBLOK ;B'HAM ISC/MAM - SERVICE BLOCKS ; 25 NOV 1991  10:45 AM
 ;;3.0; Surgery ;;24 Jun 93
 S X1=SRSDATE,X2=2830103 D ^%DTC S SRDAY=$P("MO^TU^WE^TH^FR^SA^SU","^",X#7+1),X3=X#2+8 S X1=SRSDATE,X2=$E(SRSDATE,1,5)_"01" D ^%DTC S SRDY=X\7+1
 S SRTIME=0 F I=0:0 S SRTIME=$O(^SRS("R",SRDAY,SROR,SRTIME)) Q:SRTIME=""  S NUMB="" F I=0:0 S NUMB=$O(^SRS("R",SRDAY,SROR,SRTIME,NUMB)) Q:NUMB=""  S SRXREF=^(NUMB),SRSDAY=$P(SRXREF,"^",2) S SRNUMB=$E(SRSDAY,3),FLAG=0 D CHNG
 Q
CHNG ; change graph
 I SRSDAY[SRDAY,SRDY=4,SRNUMB=5 S X1=SRSDATE,X2=7,X5=$E(SRSDATE,4,5) D C^%DTC I $E(X,4,5)'=X5 S FLAG=1
 I 'FLAG,SRSDAY[SRDAY,(SRNUMB=0!(SRNUMB=SRDY))!(SRNUMB=X3) S FLAG=1
 I 'FLAG Q
 S SRST=$P(SRXREF,"^",3),SRET=$P(SRXREF,"^",4),SERV=$P(SRXREF,"^",5),P=""
 S SRX1=11+((SRST\1)*5)+(SRST-(SRST\1)*100\15),SRX2=11+((SRET\1)*5)+(SRET-(SRET\1)*100\15)
 F X=SRX1:1:SRX2-1 S P=P_$S('(X#5):"|",$E(SERV,X#5)'="":$E(SERV,X#5),1:".")
 S X1=^SRS(SROR,"S",SRSDATE,1),^(1)=$E(X1,1,SRX1)_P_$E(X1,SRX2+1,200),^SRS(SROR,"SS",SRSDATE,1)=^(1),^SRS(SROR,"S",SRSDATE,0)=SRSDATE,^SRS(SROR,"SS",SRSDATE,0)=SRSDATE Q
 Q
