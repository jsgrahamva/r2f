EDPCTRL	;SLC/KCM - Controller for ED Tracking ;5/23/13 11:19am
	;;2.0;EMERGENCY DEPARTMENT;**6**;Feb 24, 2012;Build 200
	;
RPC(EDPXML,PARAMS,PARAMS2)	; Process request via RPC instead of CSP
	N X,REQ,EDPSITE,EDPUSER,EDPDBUG
	K EDPXML
	S EDPUSER=DUZ,EDPSITE=DUZ(2),EDPSTA=$$STA^XUAF4(DUZ(2))
	S X="" F  S X=$O(PARAMS(X)) Q:X=""  D
	. I $D(PARAMS(X))>9 M REQ(X)=PARAMS(X)
	. E  S REQ(X,1)=PARAMS(X)
	S EDPDBUG=$$DEBUG^EDPCDBG($G(PARAMS("swfID")))
	I EDPDBUG D PUTREQ^EDPCDBG(EDPDBUG,.PARAMS)
	;
COMMON	; Come here for both CSP and RPC Mode
	;
	N EDPFAIL,CMD
	S CMD=$G(REQ("command",1))
	;
	; switch on command
	;
	; ---------------------------------
	;
	; initUser
	; return <user />
	;        <view />...
	I CMD="initUser" D  G OUT
	. S AREA=$$VAL("area")
	. D SESS^EDPFAA,VIEWS^EDPFAA
	. D GETROLES^EDPBWS(EDPSITE,AREA)
	;
	; ---------------------------------
	;
	; matchPatients
	; return <ptlk />...<ptlk />
	I CMD="matchPatients" D  G OUT
	. D MATCH^EDPFPTL($$VAL("partial"))
	;
	; ---------------------------------
	;
	; getPatientChecks
	; return <checks />
	;        <similar />
	;        <warning> </warning>
	;        <patientRecordFlags><flag> <text> </text></flag>...</patientRecordFlags>
	I CMD="getPatientChecks" D  G OUT
	. D CHK^EDPFPTC($$VAL("area"),$$VAL("patient"),$$VAL("name"))
	;
	; ---------------------------------
	;
	; saveSecurityLog
	; return <save />
	I CMD="saveSecurityLog" D  G OUT
	. D LOG^EDPFPTC($$VAL("patient"))
	;
	; ---------------------------------
	; 
	; getLexiconMatches
	; return <items><item />...</items>
	I CMD="getLexiconMatches" D  G OUT
	. D ICD^EDPFLEX($$VAL("text"))
	; 
	; ---------------------------------
	; 
	; initLogArea
	; return <udp />
	;        <params disposition="" diagnosis="" delay="" delayMinutes="" />
	;        <logEntries><log />...</logEntries>
	I CMD="initLogArea" D  G OUT
	. I $L($$VAL("logEntry")) S EDPFAIL=$$UPD^EDPLOG($$VAL("logEntry")) Q:$G(EDPFAIL)
	. D PARAM^EDPQAR($$VAL("area"))
	. D GET^EDPQLP($$VAL("area"),-1)  ;-1 = force refresh
	;
	; ---------------------------------
	; 
	; checkLogin  -- OBSOLETE
	; return <user />
	I CMD="checkLogin" D SESS^EDPFAA G OUT
	;
	; ---------------------------------
	; 
	; refreshLogSelector
	; return <logEntries><log />...</logEntries>
	I CMD="refreshLogSelector" D  G OUT
	. D GET^EDPQLP($$VAL("area"),$$VAL("token"))
	;
	; ---------------------------------
	; 
	; switchLogEntry
	; return <udp />
	;        <logEntry>log fields...</logEntry>
	;        <choices>choice lists...</choices>
	I CMD="switchLogEntry" D  G OUT
	. I $L($$VAL("logEntry")) S EDPFAIL=$$UPD^EDPLOG($$VAL("logEntry")) Q:$G(EDPFAIL)
	. ;D GET^EDPQLE($S($$VAL("logID"):$$VAL("logID"),1:$$VAL("logEntry")),$$VAL("choiceTS"))
	. D GET^EDPQLE($$VAL("logID"),$$VAL("choiceTS"))
	;
	; ---------------------------------
	; 
	; saveLogEntry
	; return <upd />
	I CMD="saveLogEntry" D  G OUT
	. S EDPFAIL=$$UPD^EDPLOG($$VAL("logEntry"),"",$$VAL("restorePatient")) Q:$G(EDPFAIL)
	. ; get updated data after a save
	. ;D GET^EDPQLE($$VAL("logID"),$$VAL("choiceTS"))
	. N PAR,REC S PAR=$$VAL("logEntry") D NVPARSE^EDPX(.REC,PAR)
	. D GET^EDPQLE($$VAL^EDPLOG("id"),$$VAL("choiceTS"))
	;
	; ---------------------------------
	; 
	; addPatientToLog
	; return <upd />
	;        <add />
	;        <logEntry>log fields...</logEntry>
	;        <choices>choice lists...</choices>
	;        <logEntries><log />...</logEntries>
	I CMD="addPatientToLog" D  G OUT
	. S EDPFAIL=$$ADD^EDPLOGA($$VAL("addPatient"),$$VAL("area"),$$VAL("localTime"),$$VAL("choiceTS"))
	. Q:$G(EDPFAIL)
	. D GET^EDPQLP($$VAL("area"),-1)
	;
	; ---------------------------------
	;
	; deleteStubEntry
	; return <upd />
	I CMD="deleteStubEntry" D  G OUT
	. D DEL^EDPLOGA($$VAL("area"),$$VAL("logID"))
	;
	; ---------------------------------
	; 
	; removeLogEntry
	; return <upd />
	;        <logEntries><log />...</logEntries>
	I CMD="removeLogEntry" D  G OUT
	. D UPD^EDPLOG($$VAL("logEntry"),1) Q:$G(EDPFAIL)
	. D GET^EDPQLP($$VAL("area"),-1)
	;
	; ---------------------------------
	;
	; matchClosed
	; return <visit />...
	I CMD="matchClosed" D  G OUT
	. D CLOSED^EDPQLP($$VAL("area"),$$VAL("partial"))
	;
	; ---------------------------------
	;
	; loadConfiguration
	; return <color><map />...</color>...
	;        <columnList><col />...</columnList>
	;        <colorMapList><colorMap><map />...</colorMapList>
	;        <beds><bed />...</beds>
	;        <params />
	;        <defaultRoomList><item />...</defaultRoomList>
	;        <displayWhen><when />...</displayWhen>
	;        <statusList><status />...</statusList>
	I CMD="loadConfiguration" D  G OUT
	. D LOAD^EDPBCF($$VAL("area"))
	;
	; ---------------------------------
	;
	; loadBoardConfig
	; return <spec><row /><col />...</spec>
	I CMD="loadBoardConfig" D  G OUT
	. D LOADBRD^EDPBCF($$VAL("area"),$$VAL("boardID"))
	;
	; ---------------------------------
	;
	; saveConfigBoard
	; return <save />
	I CMD="saveConfigBoard" D  G OUT
	. D SAVEBRD^EDPBCF(.REQ) ; pass whole request for parsing
	;
	; ---------------------------------
	;
	; saveBedConfig
	; return <save />
	I CMD="saveBedConfig" D  G OUT
	. D SAVE^EDPBRM(.REQ,$$VAL("area")) ; pass whole request for parsing
	;
	; ---------------------------------
	;
	; saveColorConfig
	; return <save />
	I CMD="saveColorConfig" D  G OUT
	. D SAVE^EDPBCM(.REQ) ; pass whole request for parsing
	;
	; ---------------------------------
	;
	; loadSelectionConfig
	; return <selectionName><code />....</selectionName>...
	I CMD="loadSelectionConfig" D  G OUT
	. D LOAD^EDPBSL($$VAL("area"))
	;
	; ---------------------------------
	; 
	; loadStaffConfig
	; return providers, nurses, staff for area
	I CMD="loadStaffConfig" D  G OUT
	. D LOAD^EDPBST($$VAL("area"))
	;
	; ---------------------------------
	;
	; saveStaffConfig
	; return <save />
	I CMD="saveStaffConfig" D  G OUT
	. D SAVE^EDPBST(.REQ) ; pass whole request for parsing
	;
	; ---------------------------------
	;
	; matchPersons
	; return <per />...<per />
	I CMD="matchPersons" D  G OUT
	. D MATCH^EDPFPER($$VAL("partial"),$$VAL("personType"))
	;
	; ---------------------------------
	;
	; saveParamConfig
	; return <save />
	I CMD="saveParamConfig" D  G OUT
	. D SAVE^EDPBPM($$VAL("area"),$$VAL("param"))
	;
	; ---------------------------------
	;
	; saveSelectionConfig
	; return <save />
	I CMD="saveSelectionConfig" D  G OUT
	. D SAVE^EDPBSL($$VAL("area"),.REQ)
	;
	; ---------------------------------
	; 
	; getReport
	; return <logEntries><log />...</logEntries>
	;        <averages><all /><not /><adm /></averages>
	;        <providers><md />...</providers>
	I CMD="getReport" D  G OUT
	. D EN^EDPRPT($$VAL("start"),$$VAL("stop"),$$VAL("report"),$$VAL("id"),0,$$VAL("task"))
	;
	; ---------------------------------
	; 
	; getCSV
	; return TAB separated values for report
	I CMD="getCSV" D  G OUT
	. N EDPCSV   ; CSV mode uses EDPCSV instead of EDPXML
	. D EN^EDPRPT($$VAL("start"),$$VAL("stop"),$$VAL("report"),$$VAL("id"),1,$$VAL("task"))
	. M EDPXML=EDPCSV
	;
	; ---------------------------------
	;
	; getDetails
	I CMD="getDetails" D  G OUT
	. D EN^EDPDTL($$VAL("logEntryId"),$$VAL("attribute"))
	;
	; ---------------------------------
	;
	; getVitals
	I CMD="getVitals" D  G OUT
	. D GET^EDPVIT($$VAL("dfn"),$$VAL("start"),$$VAL("stop"))
	;
	; ---------------------------------
	;
	; saveVitals
	I CMD="saveVitals" D  G OUT
	. D PUT^EDPVIT($$VAL("dfn"),$$VAL("vital"))
	;
	; ---------------------------------
	;
	; savePhoneNumbers
	I CMD="savePhoneNumbers" D  G OUT
	. D PHONE^EDPUPD($$VAL("patient"),$$VAL("phone"),$$VAL("cell"),$$VAL("nokPhone"))
	;
	; ---------------------------------
	;
	; getLabOrderHistory
	I CMD="getLabOrderHistory" D  G OUT
	. N EDPREQ M EDPREQ=REQ
	. I '$D(EDPREQ("order")) D  ;find lab orders
	.. N LOG,I,N,X
	.. S LOG=$$VAL("id"),(I,N)=0 Q:LOG<1
	.. F  S I=$O(^EDP(230,LOG,8,I)) Q:I<1  S X=$G(^(I,0)) I X,$P(X,U,2)="L" S N=N+1,EDPREQ("order",N)=+X
	. D LAB^EDPHIST(.EDPXML,.EDPREQ)
	;
	; ---------------------------------
	;
	; getMedEfficacy
	; I CMD="getMedEfficacy" D  G OUT
	; . N EDPREQ M EDPREQ=REQ
	; . D MEDHIST^VPRXML(.EDPXML,.EDPREQ)
	;
	; ---------------------------------
	;
	; saveClinicalEvent
	I CMD="saveClinicalEvent" D  G OUT
	. N EDPREQ M EDPREQ=REQ
	. D EVENT^EDPUPD(.EDPREQ)
	;
	; ---------------------------------
	;
	; ackOrders
	I CMD="ackOrders" D  G OUT
	. N EDPREQ M EDPREQ=REQ
	. D ACK^EDPUPD(.EDPREQ)
	;
	; ---------------------------------
	;
	; getLabs = return lab results
	I CMD="getLabs" D  G OUT
	. D EN^EDPLAB(.EDPXML,.REQ)
	;
	; ---------------------------------
	;
	; getRoomBedSelections
	I CMD="getRoomBedSelections" D  G OUT
	. N AREA,LOG,X3,CURBED
	. S AREA=$$VAL("area"),LOG=$$VAL("logEntryId")
	. S X3=$G(^EDP(230,+LOG,3)),CURBED=+$P(X3,U,4)_U_$P(X3,U,9)
	. D BEDS^EDPQLE
	;
	; ---------------------------------
	;
	; getChart
	; I CMD="getChart" D  G OUT
	; . D ALL^VPRXML(.EDPXML,$$VAL("patient"))
	;
	; ---------------------------------
	;
	; loadWorksheet
	I CMD="loadWorksheet" D  G OUT
	. D LOAD^EDPWS(.REQ) ;; need to create CTXT (patient, visit, etc.)
	; --- OLD:
	I CMD="loadDefinition" D  G OUT
	. D LOAD^EDPWS(0)
	;
	; ---------------------------------
	;
	; loadWorksheetConfig
	I CMD="loadWorksheetConfig" D  G OUT
	. D LOADALL^EDPBWS($$VAL("area"),$$VAL("role"))
	;
	; ---------------------------------
	; loadWorksheetList
	I CMD="loadWorksheetList" D  G OUT
	. D LDWSLIST^EDPBWS(EDPSITE,$$VAL("area"),$$VAL("roleID"))
	;
	; ---------------------------------
	; getWorksheet
	I CMD="getWorksheet" D  G OUT
	. D GETWORKS^EDPBWS(EDPSITE,$$VAL("id"),.REQ,.EDPXML)
	;
	; ---------------------------------
	; getSectionList
	I CMD="getSectionList" D  G OUT
	. D GETSECTS^EDPBWS($$VAL("area"),.EDPXML,$$VAL("role"))
	;
	; ---------------------------------
	; getSection
	;I CMD="getSection" D  G OUT
	;. D GET1SEC^EDPBWS($$val("sectionID"))
	; ---------------------------------
	; getComponentList
	I CMD="getComponentList" D  G OUT
	. D GETCMPTS^EDPBWS($$VAL("area"),.EDPXML,$$VAL("componentID"),$$VAL("role"))
	; ---------------------------------
	; saveWorksheetConfig
	I CMD="saveWorksheetConfig" D  G OUT
	. ;D SAVEALL^EDPBWS(.REQ)
	. D SAVEWORK^EDPBWS(.PARAMS,.PARAMS2,EDPSITE,$$VAL("area"))
	; ---------------------------------
	; loadUserProfile
	I CMD="loadUserProfile" D  G OUT
	. D BOOT^EDPFAA($$VAL("appName"))
	;
	; ---------------------------------
	; 
	; getPatientPanel
	I CMD="getPatientPanel" D  G OUT
	. D GET^EDPQDBS($$VAL("area"),$$VAL("board"))
	. D GET^EDPQPP($$VAL("area"),$$VAL("board"),-1)
	. D LISTS^EDPQPP($$VAL("area"))
	;
	; ---------------------------------
	;
	; else
	D XML^EDPX("<error msg='"_$$MSG^EDPX(2300010)_CMD_"' />")
	; end switch
	; 
OUT	; output the XML
	I EDPDBUG D PUTXML^EDPCDBG(EDPDBUG,.EDPXML)
	I $L($G(EDPHTTP)) D        ; if in CSP mode
	. U EDPHTTP
	. W "<results>",!
	. N I S I=0 F  S I=$O(EDPXML(I)) Q:'I  W EDPXML(I),!
	. W "</results>",!
	K EDPHTTP
END	Q
	;
VAL(X)	; return value from request
	Q $G(REQ(X,1))
