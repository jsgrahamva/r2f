PSDORN0 ;BIR/JPW,LTL-Nurse CS Order Request Entry (continued); 16 Feb 95
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
DIE ;create the order request
 S:$G(ORD)<2 PSDEM=1
 S:'$D(^PSD(58.8,NAOU,1,PSDR,3,0)) ^(0)="^58.800118A^^"
 S PSDA=$P(^PSD(58.8,NAOU,1,PSDR,3,0),"^",3)+1 I $D(^PSD(58.8,NAOU,1,PSDR,3,PSDA)) S $P(^PSD(58.8,NAOU,1,PSDR,3,0),"^",3)=$P(^PSD(58.8,NAOU,1,PSDR,3,0),"^",3)+1 G DIE
 K DA,DIC,DIE,DD,DR,DO S DIC(0)="L",(DIC,DIE)="^PSD(58.8,"_NAOU_",1,"_PSDR_",3,",DA(2)=NAOU,DA(1)=PSDR,(X,DINUM)=PSDA D FILE^DICN K DIC
 D NOW^%DTC S PSDT=+$E(%,1,12) W ?10,!!,"processing now..."
 I $G(PAT),$G(PSD(2)),$O(^PSD(58.81,PSD(2),2,0)),'$G(PSD(4)) S ^PSD(58.8,NAOU,1,PSDR,3,PSDA,1,0)=^PSD(58.81,PSD(2),2,0) D
 .F WORD=0:0 S WORD=$O(^PSD(58.81,PSD(2),2,WORD)) Q:'WORD  S ^PSD(58.8,NAOU,1,PSDR,3,PSDA,1,WORD,0)=^PSD(58.81,PSD(2),2,WORD,0)
 S DA=PSDA,DA(1)=PSDR,DA(2)=NAOU,DR="1////"_PSDT_";2////"_+PSDS_";3////"_PSDUZ_";10////1;5////"_PSDQTY_";24////"_$G(PSDEM)_";13//"_$G(PSDR(1)) D ^DIE K DIE,DR,WORD
 Q
