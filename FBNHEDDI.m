FBNHEDDI ;AISC/GRR-EDIT DISCHARGE FOR NURSING HOME ;29AUG88
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
RD1 D GETVET^FBAAUTL1 G:DFN']"" Q
RD2 S DIC("S")="I $P(^(0),U,3)=""D""&($P(^(0),U,2)=DFN)",DIC="^FBAACNH(",DIE=DIC,DIC(0)="AEQMZ",DLAYGO=162.3,DIC("A")="Select Discharge Date/Time: " D ^DIC K DIC,DLAYGO G RD1:X="^"!(X=""),RD2:Y<0 S DA=+Y,FBAADT=$P(Y,U,2)
 S FBDIST=$P(^FBAACNH(DA,0),U,8)
 S FBJ=9999999.999999-FBAADT F  S FBJ=$O(^FBAACNH("AF",DFN,FBJ)) Q:'FBJ  S FBK=$O(^FBAACNH("AF",DFN,FBJ,0)) I $P($G(^FBAACNH(FBK,0)),"^",5)=$P(^FBAACNH(DA,0),"^",5) D  Q
 .I $P(^FBAACNH(FBK,0),"^",7)=3 S FBASIH=1
 S DIR(0)=$S($G(FBASIH):"S^4:ASIH;5:DEATH WHILE ASIH",1:"S^1:REGULAR;2:DEATH;3:TRANSFER TO OTHER CNH;6:REGULAR - PRIVATE PAY"),DIR("A")="Discharge Type: ",DIR("B")=FBDIST D ^DIR K DIR Q:$D(DIRUT)  S FBZ=+Y
 S DR="7////^S X=FBZ" D ^DIE G RD1
Q K DIC,DIE,DR,DA,DFN,FBTYPE,FTP,Y,X,FBPROG,FBASIH,FBK,FBJ,FBAADT,FBDIST,FBZ
 Q
