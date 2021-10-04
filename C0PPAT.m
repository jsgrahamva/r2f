C0PPAT	  ; ERX/GPL - ERX PATIENT utilities; 8/26/09 ; 12/10/09 6:46pm
	;;1.0;C0P;;Apr 25, 2012;Build 103
	;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
	;General Public License See attached copy of the License.
	;
	;This program is free software; you can redistribute it and/or modify
	;it under the terms of the GNU General Public License as published by
	;the Free Software Foundation; either version 2 of the License, or
	;(at your option) any later version.
	;
	;This program is distributed in the hope that it will be useful,
	;but WITHOUT ANY WARRANTY; without even the implied warranty of
	;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	;GNU General Public License for more details.
	;
	;You should have received a copy of the GNU General Public License along
	;with this program; if not, write to the Free Software Foundation, Inc.,
	;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	;
	Q
	;
	; THIS ROUTINE IS CALLED AS PART OF ERX WEB SERVICES PROCESSING
	; TO POPULATE INFORMATION ABOUT THE PATIENT TO BE MAPPED INTO XML
	; AND SENT TO THE EPRESCRIBING PROVIDER TO DEFINE THE PATIENT ON THEIR
	; SYSTEM. ALL WEB SERVICE CALLS REGARDING A PATIENT WILL USE THIS ROUTINE
	; AND SEND A COMPLETE REPRESENTATION OF THE PATIENT.
	; GPL JUN 2010
	;
EN(RTNVAR,C0PDFN)	; INITIALIZE PATIENT VARIABLE ARRAY FOR PATIENT C0PDFN
	; RTNVAR IS PASSED BY NAME. VARIABLES ARE PREFIXED WITH "PATIENT-"
	; HERE IS A LIST OF THE VARIABLES THAT ARE POPULATED FOR THE PATIENT:
	;GPL("PATIENT-ACTORADDRESSCITY")="ALTON"
	;GPL("PATIENT-ACTORADDRESSLINE1")="1234 Somewhere Lane"
	;GPL("PATIENT-ACTORADDRESSLINE2")=""
	;GPL("PATIENT-ACTORADDRESSSOURCEID")="WS_PATIENT2"
	;GPL("PATIENT-ACTORADDRESSSTATE")="KANSAS"
	;GPL("PATIENT-ACTORADDRESSTYPE")="Home"
	;GPL("PATIENT-ACTORADDRESSZIPCODE")=67623
	;GPL("PATIENT-ACTORCELLTEL")=""
	;GPL("PATIENT-ACTORCELLTELTEXT")=""
	;GPL("PATIENT-ACTORDATEOFBIRTH")="1957-12-25"
	;GPL("PATIENT-ACTOREMAIL")=""
	;GPL("PATIENT-ACTORFAMILYNAME")="ZZ PATIENT"
	;GPL("PATIENT-ACTORGENDER")="MALE"
	;GPL("PATIENT-ACTORGIVENNAME")="TEST"
	;GPL("PATIENT-ACTORIEN")=2
	;GPL("PATIENT-ACTORMIDDLENAME")="TWO"
	;GPL("PATIENT-ACTOROBJECTID")="WS_PATIENT2"
	;GPL("PATIENT-ACTORRESTEL")="888-555-1212"
	;GPL("PATIENT-ACTORRESTELTEXT")="Residential Telephone"
	;GPL("PATIENT-ACTORSOURCEID")="ACTORSYSTEM_1"
	;GPL("PATIENT-ACTORSSN")="769122557P"
	;GPL("PATIENT-ACTORSSNSOURCEID")="WS_PATIENT2"
	;GPL("PATIENT-ACTORSSNTEXT")="SSN"
	;GPL("PATIENT-ACTORSUFFIXNAME")=""
	;GPL("PATIENT-ACTORWORKTEL")="888-121-1212"
	;GPL("PATIENT-ACTORWORKTELTEXT")="Work Telephone"
	;GPL("PATIENTID")="PATIENT2"
	N C0PTMP
	D PEXTRACT^C0CACTOR("C0PTMP",C0PDFN,"WS_PATIENT_"_C0PDFN)
	; todo: for state, use extended syntax
	N ZG
	S C0PTMP("PATIENTID")="PATIENT"_C0PDFN ; PATIENT ID BASED ON DFN
	S C0PTMP("IDTYPE")="" ; DON'T KNOW WHAT SHOULD GO HERE
	S C0PTMP("STARTHISTORY")="2004-01-01T00:00:00" ; DEFAULT... CHANGE THIS
	S C0PTMP("ENDHISTORY")="2010-01-01T00:00:00" ; DEFAULT... CHANGE THIS
	S C0PTMP("PRESCRIPTIONSTATUS")="C" ; DEFAULT... CHANGE THIS
	S C0PTMP("PRESCRIPTIONSUBSTATUS")="S" ; DEFAULT... CHANGE THIS
	S C0PTMP("ARCHIVESTATUS")="N" ; DEFAULT... CHANGE THIS
	S ZG=$$GET1^DIQ(2,C0PDFN,.115,"I") ;NEED ABBREVIATION
	S C0PTMP("ACTORADDRESSSTATE")=$$GET1^DIQ(5,ZG_",",1) ;STATE ABBREVIATION
	I C0PTMP("ACTORGENDER")="MALE" S C0PTMP("ACTORGENDER")="M"
	I C0PTMP("ACTORGENDER")="FEMALE" S C0PTMP("ACTORGENDER")="F"
	S C0PTMP("ACTORDATEOFBIRTH")=$TR(C0PTMP("ACTORDATEOFBIRTH"),"-") ;REMOVE DASHES FROM DOB
	S C0PTMP("ACTORSSN")=$TR(C0PTMP("ACTORSSN"),"P","") ;REMOVE P FROM TEST SSN
	N ZI
	S ZI=""
	F  S ZI=$O(C0PTMP(ZI)) Q:ZI=""  D  ; FOR EACH VARIABLE RETURNED
	. S @RTNVAR@("PATIENT-"_ZI)=C0PTMP(ZI) ; RETURN PREFIXED VARIABLE
	S @RTNVAR@("PATIENT-ACTORADDRESSCOUNTRY")="US" ;FIX THIS FOR INTERNATIONAL
	S @RTNVAR@("PATIENT-ACTORMEMO")="" ; DON'T KNOW WHAT TO PUT HERE GPL
	Q
	;