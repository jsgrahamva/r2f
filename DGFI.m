DGFI ;ALB/JDS-MRL - FEMALE INPATIENT OUTPUTS ; 19 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 ;
 S DIC="^DPT(",L=0,BY="'.1,"
 S FR=",",TO="," I $D(^DG(43,1,"GL")) S:$P(^("GL"),U,2) BY=BY_".19,",FR=FR_",",TO=TO_","
 S BY=BY_"@SEX,.01",FR=FR_"E,",TO=TO_"F,",X=3,DGNO=0 D ^DGTEMP G Q:DGNO S FLDS=X
 D EN1^DIP
Q K BY,TO,FR,DIC,DIS,X,DGNO,DHD Q
EN K TD,DGF S %DT="AEPT",%DT("A")="Enter date of Stay: " D ^%DT G Q1:Y'>0 G EN:+Y>(DT+1) S DGT=+Y,DG2=DGT,L=0,DGT=$S(DGT[".":DGT,1:DGT_".2400"),DG2=DGT
EN1 S Y=DGT X ^DD("DD") S DHD="FEMALE INPATIENT FOR "_Y,L=0
 S DIS(1)="S DFN=D0 D ^DGINPW,SET^DGFI I DG1 S ^UTILITY($J,""DG"",D0)=DG1"
 S DIC="^DPT(",BY="@SEX",X=4,DGNO=0 D ^DGTEMP G Q:DGNO S FLDS=X,FR="F,",TO="FZ,"
 I '$D(TD),$D(^DG(43,1,"GL")) S:$P(^("GL"),U,2) BY=BY_",999;""DIVISION: """,FR=FR_"@,",TO=TO_","
 S BY=BY_",.01" D EN1^DIP
 Q:$D(DGF)  K DGT
Q1 K %DT,DFN,DG1,DG2,DGA1,DGX,FLDS,L,POP,^UTILITY($J,"DG") G Q
SET Q:'DG1  S $P(DG1,U,4)=+DG1,$P(DG1,U,1)=+^DGPM(DGA1,0),X=$P(DG1,U,2),$P(DG1,U,10)=$S(X]"":$P(^DG(405.4,+X,0),"^",1),1:"") I $P(DG1,U,3)]"","^1^2^3^13^25^26^43^44^45^"[("^"_$P(DG1,U,3)_"^") S DG1=""
