PXRMUTL	;EHR/DAOU/JLG - Utility Functions ;11/5/06  20:28
	;;2.0;CLINICAL REMINDERS;**7,WVEHR,LOCAL**;Feb 04, 2005;Build 3
	;
	; Copyright 2015 WorldVistA.
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
	;'Modified' MAS Patient Look-up Check Cross-References June 1987
	;
FNAME(DFN)	;Patient First name
	N FULNAME,FIRSTN
	S FULNAME=$$NAME^TIULO(DFN)
	S FIRSTN=$P($P(FULNAME,",",2)," ",1)
	I FIRSTN="" S FIRSTN="UNKNOWN"
	Q FIRSTN
	;
BMI(DFN)	;Patient body mass index
	N PTWT,PTHT,BMI
	S PTWT=$$WEIGHT^TIULO(DFN)
	S PTHT=$$HEIGHT^TIULO(DFN)
	I PTWT,PTHT D
	.S BMI=703*(PTWT/(PTHT**2))+.5\1
	E  S BMI="UNK"
	Q BMI
	;
PATID(DFN)	;Patient id (either SSN or HRN)
	;At this stage it returns SSN if it exits.  Will probably need to
	;be modified to return HRN even if SSN exists.
	N PATID
	S PATID=$$SSN^TIULO(DFN)
	I PATID["SSN" D
	.S PATID=$$HRN^AUPNPAT3(DFN,DUZ(2))
	.I PATID,$L(PATID)<7 S PATID="HRN-"_PATID Q
	.S PATID="UNKNOWN"
	Q PATID
