ORY218	;SLC/JLC-Update PKI user flag for DEA ;01/16/2013  06:25
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**218**;Dec 17, 1997;Build 87
	Q
PRE	;Pre-install
	;IF THE FILE ALREADY EXITS, DELETE THE DATA DICTIONARY
	I $D(^DIC(100.7))>0 D
	.N FILE
	.D FILE^DID(100.7,,"NAME","FILE")
	.D BMES^XPDUTL("Deleting existing "_$G(FILE("NAME"))_" data dictionary while preserving data...")
	.N DIU
	.S DIU="^ORD(100.7,",DIU(0)="T"
	.D EN^DIU2
	.D MES^XPDUTL("DONE")
	Q
POST	;Post-install
	N FDA,IENS,IEN,ERROR,Y,EXIT,SITE
	D BMES^XPDUTL("Cleaning up menus...")
	;IA #10156
	S IEN=$$FIND1^DIC(19,,"X","ORW PARAM GUI")
	I +$G(IEN)=0 D  Q
	.D MES^XPDUTL("ERROR: Could not find the ORW PARAM GUI option in the OPTION file (#19).")
	N RETURN,ADD
	S ADD=1
	;IA #10156
	D GETS^DIQ(19,IEN_",","10*",,"RETURN","ERROR")
	I $D(ERROR) D ERROR(.ERROR)  Q
	I $D(RETURN) D
	.N IDX
	.S IDX=0 F  S IDX=$O(RETURN(19.01,IDX)) Q:+$G(IDX)=0  D
	..S:RETURN(19.01,IDX,.01)="OR EPCS MENU" ADD=0
	I ADD=1 D
	.D MES^XPDUTL("   Adding OR EPCS MENU to ORW PARAM GUI")
	.S ERROR=$$ADD^XPDMENU("ORW PARAM GUI","OR EPCS MENU","DEA")
	.D:ERROR=1 MES^XPDUTL("DONE")
	.D:ERROR=0 MES^XPDUTL("OR EPCS MENU option was not added to the option ORW PARAM GUI")
	K ERROR,IEN
	I ADD=0 D MES^XPDUTL("DONE")
	S EXIT="1^DONE - SITE SUCCESSFULLY CONFIGURED",SITE=$P($$SITE^VASITE(),U,2)
	D BMES^XPDUTL("Configuring site "_SITE_" for ePCS...")
	I $O(^ORD(100.7,0)) S EXIT="1^DONE - SITE ALREADY CONFIGURED"
	I '$O(^ORD(100.7,0)) D
	.S IENS="+1,",FDA(100.7,IENS,.01)=SITE,FDA(100.7,IENS,.02)="YES"
	.D UPDATE^DIE("E","FDA","IEN","ERROR") K FDA
	.I $D(ERROR) D ERROR(.ERROR)  Q
	.I $G(IEN(1))="" D  Q
	..D MES^XPDUTL("ERROR: FileMan did not return the new entry's internal entry number.")
	..D MES^XPDUTL("Site not successfully configured.")
	.S IENS="+2,"_IEN(1)_",",Y=0
	.F  S Y=$O(^XUSEC("ORES",Y)) Q:'Y!('+EXIT)  D
	..I '$$ACTIVE^XUSER(Y)!($$DEA^XUSER(,Y)="") Q
	..N DATA
	..D GETS^DIQ(200,Y_",","53.1;53.4","I","DATA","ERROR")
	..I $D(ERROR) D ERROR(.ERROR) S EXIT="0^Site not successfully configured." Q
	..I '+DATA(200,Y_",",53.1,"I") Q
	..N DATE
	..S DATE=+DATA(200,Y_",",53.4,"I")
	..I DATE>0,(DATE<=DT) Q
	..S FDA(100.71,IENS,.01)=Y D UPDATE^DIE("","FDA",,"ERROR")
	..I $D(ERROR) D ERROR(.ERROR) S EXIT="0^Site not successfully configured."
	..K FDA
	D MES^XPDUTL($P(EXIT,U,2))
	Q
ERROR(MESSAGE)	;HANDLE AN ERROR MESSAGE FROM FILEMAN
	N IDX
	S IDX=0 F  S IDX=$O(MESSAGE("DIERR",IDX)) Q:'IDX  D
	.D MES^XPDUTL("FILEMAN ERROR #"_MESSAGE("DIERR",IDX)_":")
	.D MES^XPDUTL(MESSAGE("DIERR",IDX,"TEXT",1))
	Q
