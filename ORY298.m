ORY298	;SLCOIFO - Pre/Post-init for patch OR*3*298
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**298**;Dec 17, 1997;Build 14
PRE	; Pre-init
	D CLEAN
	Q
POST	; Post-init
	Q
CLEAN	;Clean up reports for install
	I $P($G(^ORD(101.24,1102,0)),"^",1)="ORRPW DOD" D
	. S ORVIT=1,DA=1102,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1102,0)="ORRPW DOD",^ORD(101.24,"B","ORRPW DOD",1102)=""
	I $P($G(^ORD(101.24,1143,0)),"^",1)="ORRPW DOD HISTORIES" D
	. S ORVIT=1,DA=1143,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1143,0)="ORRPW DOD HISTORIES",^ORD(101.24,"B","ORRPW DOD HISTORIES",1143)=""
	I $P($G(^ORD(101.24,1144,0)),"^",1)="ORRPW DOD FAMILY HISTORY" D
	. S ORVIT=1,DA=1144,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1144,0)="ORRPW DOD FAMILY HISTORY",^ORD(101.24,"B","ORRPW DOD FAMILY HISTORY",1144)=""
	I $P($G(^ORD(101.24,1145,0)),"^",1)="ORRPW DOD SOCIAL HISTORY" D
	. S ORVIT=1,DA=1145,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1145,0)="ORRPW DOD SOCIAL HISTORY",^ORD(101.24,"B","ORRPW DOD SOCIAL HISTORY",1145)=""
	I $P($G(^ORD(101.24,1146,0)),"^",1)="ORRPW DOD OTHER PAST MED HX" D
	. S ORVIT=1,DA=1146,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1146,0)="ORRPW DOD OTHER PAST MED HX",^ORD(101.24,"B","ORRPW DOD OTHER PAST MED HX",1146)=""
	I $P($G(^ORD(101.24,1147,0)),"^",1)="ORRPW DOD QUESTIONNAIRES" D
	. S ORVIT=1,DA=1147,DIK="^ORD(101.24," D ^DIK
	. S ^ORD(101.24,1147,0)="ORRPW DOD QUESTIONNAIRES",^ORD(101.24,"B","ORRPW DOD QUESTIONNAIRES",1147)=""
