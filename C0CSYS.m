C0CSYS	;WV/C0C/SMH - Routine to Get EHR System Information;6JUL2008
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 3
	; Copyright 2008 George Lilly & Sam Habiel.  
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	W "Enter at appropriate points." Q
	;
	; Originally, I was going to use VEPERVER, but VEPERVER
	; actually kills ^TMP($J), outputs it to the screen in a user-friendly
	; manner (press any key to continue),
	; and is really a very half finished routine
	;
	; So for now, I am hard-coding the values.
	;
SYSNAME()	;Get EHR System Name; PUBLIC; Extrinsic
	Q:$G(DUZ("AG"))="I" "RPMS"
	Q "WorldVistA EHR/VOE"
	;
SYSVER()	;Get EHR System Version; PUBLIC; Extrinsic
	Q "1.0"
	;
PTST(DFN)	;TEST TO SEE IF PATIENT MERGED OR A TEST PATIENT
	 ; DFN = IEN of the Patient to be tested
	 ; 1 = Merged or Test Patient
	 ; 0 = Non-test Patient
	 ;
	 I DFN="" Q 0  ; BAD DFN PASSED
	 I $D(^DPT(DFN,-9)) Q 1  ;This patient has been merged
	 I $G(^DPT(DFN,0))="" Q 1  ;Missing zeroth node <---add
	 ;
	 I '$D(CCRTEST) S CCRTEST=1 ; DEFAULT IS THAT WE ARE TESTING
	 I CCRTEST Q 0  ; IF WE ARE TESTING, DON'T REJECT TEST PATIENTS
	 N DIERR,DATA
	 I $$TESTPAT^VADPT(DFN) Q 1 ; QUIT IF IT'S A VA TEST PATIENT
	 S DATA=+$$GET1^DIQ(2,DFN_",",.6,"I") ;Test Patient Indicator
	 ; 1 = Test Patient
	 ; 0 = Non-test Patient
	 I DATA Q DATA
	 S DATA=$$GET1^DIQ(2,DFN_",",.09,"I") ;SSN test
	 D CLEAN^DILF
	 I "Pp"[$E(DATA,$L(DATA),$L(DATA)) Q 0  ;Allow Pseudo SSN
	 I $E(DATA,1,3)="000" Q 1
	 I $E(DATA,1,3)="666" Q 1
	 Q 0
	 ;
