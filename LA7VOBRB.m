LA7VOBRB	;DALOI/JMC - LAB OBR segment builder (cont'd);5:08 AM  6 Nov 2015
	;;5.2;AUTOMATED LAB INSTRUMENTS;**68,74,85,WVEHR,LOCAL**;Sep 27, 1994;Build 1
	;
	; Currently not Modified from FOIA VISTA by WorldVistA
	;
	Q
	;
	;
OBR15	; Build OBR-15 sequence - specimen source
	;
	S LA764061=0,LA7Y=""
	S LA7COMP=0 ; specify subcomponent position - primary/alternate
	; SNOMED code flag (0-do not encode with SNOMED, 1-encode with SNOMED, 2-encode with SNOMED only; no HL70070)
	S LA7SNM=$G(LA7SNM)
	;
	; Get entry in #64.061 and SNOMED code for this Topography file #61 entry.
	I LA761>0 D
	. S LA761(0)=$G(^LAB(61,LA761,0)),LA764061=$P(LA761(0),"^",9)
	. S $P(LA7Y,$E(LA7ECH,4),9)=$$CHKDATA^LA7VHLU3($P(LA761(0),"^"),LA7FS_LA7ECH)
	;
	; If no specimen code then default to HL7 0070 entry "XXX"
	I LA761=0 D
	. N LA7SCR
	. S LA7SCR="I $P(^LAB(64.061,Y,0),U,5)=""0070"",$P(^LAB(64.061,Y,0),U,7)=""S"""
	. S LA764061=$$FIND1^DIC(64.061,,"X","XXX","D",LA7SCR,"LA7ERR")
	;
	I LA764061 D GETS^DIQ(64.061,LA764061_",",".01;2;5","","LA7Z","LA7ERR")
	;
	; Send SNOMED as primary code
	; If no SNOMED code and SNOMED only then allow HL7
	I LA761,LA7SNM D
	. ;check for override SNOMED CT ID
	. I $G(LA76248)]"",$D(^LAHM(62.48,LA76248,"SCT","AC",LA761_";LAB(61,")) D
	. . S $P(LA7ALT,"^",8)=$O(^LAHM(62.48,LA76248,"SCT","AC",LA761_";LAB(61,",0))
	. S LA7X=$$IEN2SCT^LA7VHLU6(61,LA761,DT,$P(LA7ALT,"^",8))
	. I LA7X="" S:LA7SNM=2 LA7SNM=1 Q
	. S $P(LA7X,"^",2)=$$CHKDATA^LA7VHLU3($P(LA7X,"^",2),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1,LA7COMP+3)=$TR($P(LA7X,"^",1,3),"^",$E(LA7ECH,4))
	. S $P(LA7Y,$E(LA7ECH,4),7)=$P(LA7X,"^",4)
	. S LA7COMP=LA7COMP+3
	;
	; Send non-standard local code as alternate unless SNOMED only flag and SNOMED code present.
	I $P(LA7ALT,"^")'=""!($P(LA7ALT,"^",2)'="") D
	. I LA7SNM=2,LA7COMP Q
	. S LA7X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^"),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
	. S LA7X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",2),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)=$P(LA7ALT,"^",3)
	. S LA7COMP=LA7COMP+3
	;
	; Send HL7 Table 0070 coding as alternate code
	I LA7SNM'=2,LA764061,LA7Z(64.061,LA764061_",",2)'="",LA7COMP<6 D
	. S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",2),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
	. S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="HL7"_LA7Z(64.061,LA764061_",",5)
	. S LA7COMP=LA7COMP+3
	;
	; If no code found then default to backups - try SNOMED I then file #61 as local code or HL7 XXX.
	I LA761,$P(LA761(0),"^",2)'="",LA7COMP<1 D
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)="T-"_$P(LA761(0),"^",2)
	. S LA7X=$$CHKDATA^LA7VHLU3($P(LA761(0),"^"),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="SNM"
	. S $P(LA7Y,$E(LA7ECH,4),7)="1974"
	. S LA7COMP=LA7COMP+3
	I LA761,LA7COMP<6 D
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA761
	. S LA7X=$$CHKDATA^LA7VHLU3($P(LA761(0),"^"),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="99VA61"
	. S $P(LA7Y,$E(LA7ECH,4),$S(LA7COMP<3:7,1:8))="5.2"
	. S LA7COMP=LA7COMP+3
	I LA761=0,LA7COMP<1,LA764061,LA7Z(64.061,LA764061_",",2)'="" D
	. S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",2),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
	. S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
	. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="HL7"_LA7Z(64.061,LA764061_",",5)
	. S LA7COMP=LA7COMP+3
	;
	; Reverse and send HL70070 as primary and SNOMED as alternate.
	; Maintain backward compatibility with VistA LEDI III
	I LA7SNM=1.1,$P(LA7Y,$E(LA7ECH,4),3)="SCT",$P(LA7Y,$E(LA7ECH,4),6)="HL70070" D
	. N LA7K
	. S LA7K=$P(LA7Y,$E(LA7ECH,4),1,3),LA7K(7)=$P(LA7Y,$E(LA7ECH,4),7)
	. S $P(LA7Y,$E(LA7ECH,4),1,3)=$P(LA7Y,$E(LA7ECH,4),4,6),$P(LA7Y,$E(LA7ECH,4),7)=$P(LA7Y,$E(LA7ECH,4),8)
	. S $P(LA7Y,$E(LA7ECH,4),4,6)=LA7K,$P(LA7Y,$E(LA7ECH,4),8)=LA7K(7)
	;
	; LA7ALT should contain "CONTROL" in 4th piece if from file #62.3
	I $P(LA7ALT,"^",4)'="" D
	. N LA7TXT
	. S LA7TXT=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",4),LA7FS_LA7ECH)
	. S $P(LA7Y,$E(LA7ECH,1),3)=LA7TXT
	;
	; Build collection sample in 4th component.
	S LA7COMP=0 ; specify subcomponent position - primary/alternate
	; Send collection sample SNOMED CT code for DoD.
	I LA762,LA7SNM D
	. N LA7K,LA7Z
	. ;check for override SNOMED CT ID
	. I $G(LA76248)]"",$D(^LAHM(62.48,LA76248,"SCT","AC",LA762_";LAB(62,")) D
	. . S $P(LA7ALT,"^",9)=$O(^LAHM(62.48,LA76248,"SCT","AC",LA762_";LAB(62,",0))
	. S LA7X=$$IEN2SCT^LA7VHLU6(62,LA762,DT,$P(LA7ALT,"^",9))
	. S $P(LA7X,"^",2)=$$CHKDATA^LA7VHLU3($P(LA7X,"^",2),LA7FS_LA7ECH)
	. S LA7K=$TR($P(LA7X,"^",1,3),"^",$E(LA7ECH,4))
	. S $P(LA7K,$E(LA7ECH,4),7)=$P(LA7X,"^",4)
	. S LA7Z=$$GET1^DIQ(62,LA762_",",.01,"","LA7ERR"),LA7Z=$$TRIM^XLFSTR(LA7Z,"LR"," ")
	. S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
	. S $P(LA7K,$E(LA7ECH,4),9)=LA7Z
	. S $P(LA7Y,$E(LA7ECH,1),4)=LA7K,LA7COMP=3
	;
	I $P(LA7ALT,"^",5)'=""!($P(LA7ALT,"^",6)'="") D
	. N I
	. S X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",5),LA7FS_LA7ECH)
	. S Y=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",6),LA7FS_LA7ECH)
	. S LA7X=$P(LA7Y,$E(LA7ECH,1),4)
	. F I=1,4 I $P(LA7X,$E(LA7ECH,4),I)="" S $P(LA7X,$E(LA7ECH,4),I)=X,$P(LA7X,$E(LA7ECH,4),I+1)=Y,$P(LA7X,$E(LA7ECH,4),I+2)=$P(LA7ALT,"^",7) Q
	. S $P(LA7Y,$E(LA7ECH,1),4)=LA7X,LA7COMP=LA7COMP+3
	;
	; Get entry in #62 for this collection sample entry.
	I LA762,LA7COMP<6 D
	. N I,LA7Z
	. S LA7Z=$$GET1^DIQ(62,LA762_",",.01,"","LA7ERR"),LA7Z=$$TRIM^XLFSTR(LA7Z,"LR"," ")
	. S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
	. S LA7X=$P(LA7Y,$E(LA7ECH,1),4)
	. F I=1,4 I $P(LA7X,$E(LA7ECH,4),I)="" S $P(LA7X,$E(LA7ECH,4),I)=LA762,$P(LA7X,$E(LA7ECH,4),I+1)=LA7Z,$P(LA7X,$E(LA7ECH,4),I+2)="99VA62" Q
	. S $P(LA7Y,$E(LA7ECH,1),4)=LA7X,LA7COMP=LA7COMP+3
	;
	; Send specimen shipping condition - collection method
	I $G(LA7CM) D
	. S X=$$GET1^DIQ(62.93,LA7CM_",",.01)
	. I X'="" S X=$$CHKDATA^LA7VHLU3(X,LA7FS_LA7ECH)
	. S Y=$$GET1^DIQ(62.93,LA7CM_",",.02)
	. I Y'="" S Y=$$CHKDATA^LA7VHLU3(Y,LA7FS_LA7ECH)
	. S LA7X=Y_$E(LA7ECH,4)_X_$E(LA7ECH,4)_"99VA62.93"
	. S $P(LA7Y,$E(LA7ECH,1),6)=LA7X
	Q
