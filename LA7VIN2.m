LA7VIN2	;DALOI/JMC - Process Incoming UI Msgs, continued ;01/27/15  21:29
	;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,74,250005,250068,WVEHR,LOCAL**;Sep 27, 1994;Build 6
	; Modified from FOIA VISTA,
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
	;
	;
	; WV/JMC 12 Sept 2010 - added code to PID section to check and extract various types of patient identifiers.
	;                       Supports SSN, ICN ,PI (patient identifer) and MR ( medical record number).
	;
	;
	;This routine is a continuation of LA7VIN1 and is only called from there.
	Q
	;
MSH	; Process MSH segment
	N LA7X
	;
	I $E(LA7SEG(0),1,3)'="MSH" D  Q
	. S (LA7ABORT,LA7ERR)=7
	. D CREATE^LA7LOG(LA7ERR)
	;
	; Encoding characters
	S LA7FS=$E(LA7SEG(0),4)
	S LA7CS=$E(LA7SEG(0),5)
	S LA7ECH=$E(LA7SEG(0),5,8)
	; No field or component separator
	I LA7FS=""!(LA7CS="") D
	. S (LA7ABORT,LA7ERR)=8
	. D CREATE^LA7LOG(LA7ERR)
	;
	; Sending application
	S LA7SAP=$$P^LA7VHLU(.LA7SEG,3,LA7FS)
	S LA7ID=LA7SAP_"-I-"
	;
	; Sending facility
	S LA7SFAC=$$P^LA7VHLU(.LA7SEG,4,LA7FS)
	;
	; Receiving application
	S LA7RAP=$$P^LA7VHLU(.LA7SEG,5,LA7FS)
	;
	; Receiving facility
	S LA7RFAC=$$P^LA7VHLU(.LA7SEG,6,LA7FS)
	;
	; Message date/time from first component
	S LA7MEDT=$$HL7TFM^XLFDT($P($$P^LA7VHLU(.LA7SEG,7,LA7FS),LA7CS),"L")
	;
	; Message type
	S LA7X=$$P^LA7VHLU(.LA7SEG,9,LA7FS)
	S LA7MTYP=$P(LA7X,LA7CS,1)
	;
	; Message Control ID
	S LA7MID=$$P^LA7VHLU(.LA7SEG,10,LA7FS)
	;
	; HL7 version
	S LA7X=$$P^LA7VHLU(.LA7SEG,12,LA7FS)
	S LA7HLV=$P(LA7X,LA7CS,1)
	Q
	;
	;
ORC	; Process ORC segment
	N LA7X,LA7Y
	;
	; Order control
	S LA7OTYPE=$$P^LA7VHLU(.LA7SEG,2,LA7FS)
	;
	; Place order number
	S LA7PON=$$P^LA7VHLU(.LA7SEG,3,LA7FS)
	;
	; Setup shipping manifest variable
	S LA7Y=0
	S LA7X=$P($$P^LA7VHLU(.LA7SEG,5,LA7FS),LA7CS)
	I LA7X'="" S LA7Y=$O(^LAHM(62.8,"B",LA7X,0))
	I LA7Y S LA7628=LA7Y
	S LA7SM=LA7Y_"^"_LA7X
	;
	; Setup shipping configuration variable
	I $P(LA7SM,"^") S LA7629=+$P($G(^LAHM(62.8,$P(LA7SM,"^"),0)),"^",2)
	E  S LA7629=0
	;
	; Set new order/shipping manifest received alert/identifiers
	I LA7MTYP="ORM",$P(LA7SM,"^",2)'="" D
	. S ^TMP("LA7-ORM",$J,LA76248,LA76249,$P(LA7SM,"^",2))=""
	. D SETID^LA7VHLU1(LA76249,LA7ID,$P(LA7SM,"^",2),1)
	. D SETID^LA7VHLU1(LA76249,"",$P(LA7SM,"^",2),0)
	;
	; Order quantity/timing (duration, units, urgency)
	S LA7ODUR=$P($$P^LA7VHLU(.LA7SEG,8,LA7FS),LA7CS,3)
	S LA7ODURU=$P($$P^LA7VHLU(.LA7SEG,8,LA7FS),LA7CS,4)
	S LA7OUR=$P($$P^LA7VHLU(.LA7SEG,8,LA7FS),LA7CS,6)
	;
	; Date/time of transaction
	S LA7ORDT=$$HL7TFM^XLFDT($P($$P^LA7VHLU(.LA7SEG,10,LA7FS),LA7CS),"L")
	;
	; Placer's entered by (id^duz^last name, first name, mi [id])
	S LA7X=$$P^LA7VHLU(.LA7SEG,11,LA7FS)
	S LA7PEB=$$XCNTFM^LA7VHLU9(LA7X,LA7ECH)
	I LA7PEB="^0^" S LA7PEB=""
	;
	; Placer's verified by (id^duz^last name, first name, mi [id])
	S LA7X=$$P^LA7VHLU(.LA7SEG,12,LA7FS)
	S LA7PVB=$$XCNTFM^LA7VHLU9(LA7X,LA7ECH)
	I LA7PVB="^0^" S LA7PVB=""
	;
	; Placer's ordering provider (id^duz^last name, first name, mi [id])
	S LA7X=$$P^LA7VHLU(.LA7SEG,13,LA7FS)
	S LA7POP=$$XCNTFM^LA7VHLU9(LA7X,LA7ECH)
	I LA7POP="^0^" S LA7POP=""
	;
	; Enterer's ordering location
	S LA7X=$$P^LA7VHLU(.LA7SEG,14,LA7FS)
	S LA7Y=$$PLTFM^LA7VHLU4(LA7X,LA7FS,LA7ECH)
	S LA7EOL=$P(LA7Y,"^",1,3)
	I LA7EOL="^0^" S LA7EOL=""
	;
	; Order control code reason
	S LA7OCR=$$P^LA7VHLU(.LA7SEG,17,LA7FS)
	;
	;
	; If ORM order message, determine specimen collecting site from ORC
	; segment, if none use MSH sending facility value
	S LA7CSITE=""
	I LA7MTYP="ORM" D
	. S LA7X=$P($$P^LA7VHLU(.LA7SEG,18,LA7FS),LA7CS)
	. S LA7CSITE=$$FINDSITE^LA7VHLU2(LA7X,2,1)
	. I LA7CSITE'>0 S LA7CSITE=$$FINDSITE^LA7VHLU2(LA7SFAC,2,0)
	;
	Q
	;
	;
NTE	; Process NTE segment
	;
	D NTE^LA7VIN2A
	Q
	;
	;
PID	; Process PID segment
	N LA7I,LA7X,LA7Y,X,Y
	;
	; Begin WorldVistA Change JMC
	; Was ;S (DFN,LA7DOB,LA7ICN,LA7PRACE,LA7PNM,LA7PTID2,LA7PTID3,LA7PTID4,LA7SEX,LA7SSN,LRDFN,LRTDFN)="" ;WV
	S (DFN,LA7DOB,LA7ICN,LA7MRN,LA7PI,LA7PRACE,LA7PNM,LA7PTID2,LA7PTID3,LA7PTID4,LA7SEX,LA7SSN,LRDFN,LRTDFN)="" ;WV
	; End WorldVistA Change
	;
	; PID Set ID
	S LA7SPID=$$P^LA7VHLU(.LA7SEG,2,LA7FS)
	;
	; Extract patient identifiers
	S LA7PTID2=$$P^LA7VHLU(.LA7SEG,3,LA7FS)
	S LA7PTID3=$$P^LA7VHLU(.LA7SEG,4,LA7FS)
	S LA7PTID4=$$P^LA7VHLU(.LA7SEG,5,LA7FS)
	; Resolve ICN if identifier is from MPI
	; Assume SSN is identifier if "SS" or blank
	F LA7I=1:1:$L(LA7PTID3,$E(LA7ECH,2)) D
	. N LA7J,LA7X,LA7ID
	. S X=$P(LA7PTID3,$E(LA7ECH,2),LA7I) Q:'$L(X)
	. S LA7PTID3(LA7I)=X,LA7ID=$P(LA7PTID3(LA7I),$E(LA7ECH),5)
	. ; Begin WorldVistA Change JMC
	. ; Was ;I LA7ID'="","NI^PI"[LA7ID D  Q  ;WV
	. I LA7ID?1(1"NI",1"PI") D  Q  ; WV
	. . ; End WorldVistA Change
	. . S Y=$P(LA7PTID3(LA7I),$E(LA7ECH))
	. . I Y?10N1"V"6N S LA7Y=Y
	. . E  S LA7Y=Y_"V"_$P(LA7PTID3(LA7I),$E(LA7ECH),2)
	. . S LA7X=$$CHKICN^LA7VHLU2(LA7Y)
	. . ; Begin WorldVistA Change JMC
	. . ; Was;I LA7X>0 S DFN=$P(LA7X,"^"),LA7ICN=$P(LA7X,"^",2) ;WV
	. . I LA7X>0 S DFN=$P(LA7X,"^"),LA7ICN=$P(LA7X,"^",2) Q  ;WV
	. . S LA7X=$$GETDFN^LA7VHLU2(LA7PI,3) ;WV
	. . I LA7X>0 S DFN=$P(LA7X,"^") ;WV
	       . . ; End WorldVistA Change
	. I LA7ID="SS"!(LA7ID="") D  Q
	. . F LA7J=1:1:3 S LA7X(LA7J)=$P(LA7PTID3(LA7I),$E(LA7ECH),LA7J)
	. . I LA7X(1)'?9N.1A Q
	. . I LA7X(3)="M11",LA7X(2)'=$P($$M11^HLFNC(LA7X(1),LA7ECH),$E(LA7ECH),2) Q
	. . S LA7SSN=LA7X(1),DFN=$O(^DPT("SSN",LA7SSN,0))
	. ;Begin WorldVistA Change JMC
	. I LA7ID="MR" S LA7MRN=$P(LA7PTID3(I),$E(LA7ECH)) ;WV
	; End WorldVistA Change 
	;
	; Check PID-2 (alternate patient id) if PID-3 did not yield SSN/ICN
	F LA7I=1:1:$L(LA7PTID2,$E(LA7ECH,2)) D
	. N LA7J,LA7X,LA7ID
	. S X=$P(LA7PTID2,$E(LA7ECH,2),LA7I) Q:'$L(X)
	. S LA7PTID2(LA7I)=X,LA7ID=$P(LA7PTID2(LA7I),$E(LA7ECH),5)
	. ;Begin WorldVistA Change JMC
	. ;Was;I LA7ICN="",LA7ID'="","NI^PI"[LA7ID D  Q  ;WV
	. I LA7PI="",LA7ID?1(1"NI",1"PI") D  Q  ;WV
	. . ;S Y=$P(LA7PTID2(LA7I),$E(LA7ECH)) ;WV
	. . S (LA7PI,Y)=$P(LA7PTID2(I),$E(LA7ECH)),LA7Y="" ;WV
	. . I LA7ID'="NI" Q  ;WV
	. . ;End WorldVistA Change
	. . I Y?10N1"V"6N S LA7Y=Y
	. . ;Begin WorldVistA Change JMC
	. . ;Was ;E  S LA7Y=Y_"V"_$P(LA7PTID2(LA7I),$E(LA7ECH),2) ;WV
	. . I Y?9.10N,$P(LA7PTID3(I),$E(LA7ECH),2) S LA7Y=Y_"V"_$P(LA7PTID2(I),$E(LA7ECH),2) ;WV
	. . ;End WorldVistA Change
	. . S LA7X=$$CHKICN^LA7VHLU2(LA7Y)
	. . I LA7X>0 S DFN=$P(LA7X,"^"),LA7ICN=$P(LA7X,"^",2)
	. I LA7SSN="",LA7ID="SS"!(LA7ID="") D  Q
	. . F LA7J=1:1:3 S LA7X(LA7J)=$P(LA7PTID2(LA7I),$E(LA7ECH),LA7J)
	. . I LA7X(1)'?9N.1A Q
	. . I LA7X(3)="M11",LA7X(2)'=$P($$M11^HLFNC(LA7X(1),LA7ECH),$E(LA7ECH),2) Q
	. . S LA7SSN=LA7X(1),DFN=$O(^DPT("SSN",LA7SSN,0))
	. . ; Begin WorldVistA Change JMC
	. I LA7ID="MR" S LA7MRN=$P(LA7PTID2(I),$E(LA7ECH)) ;WV
	; End WorldVistA Change
	;
	; Extract patient name
	S LA7X=$$P^LA7VHLU(.LA7SEG,6,LA7FS)
	I LA7X'="" D
	. S LA7PNM=$$FMNAME^HLFNC(LA7X,LA7ECH)
	. D SETID^LA7VHLU1(LA76249,LA7ID,LA7PNM,0)
	. D SETID^LA7VHLU1(LA76249,"",LA7PNM,0)
	;
	; Extract date of birth
	; Check for degree of precision in 2nd component to provide backward compatibility with HL7 <v2.3
	S LA7X=$$P^LA7VHLU(.LA7SEG,8,LA7FS)
	I LA7X D
	. S LA7Y=$P(LA7X,LA7CS,2),LA7X=$P(LA7X,LA7CS,1)
	. I (LA7Y=""!(LA7Y="D")),$E(LA7X,9,12)="0000" S LA7X=$E(LA7X,1,8)
	. S LA7DOB=$$HL7TFM^XLFDT(LA7X)
	. I LA7DOB<1 S LA7DOB=""
	. I LA7Y="L" S LA7DOB=$E(LA7DOB,1,5)_"00"
	. I LA7Y="Y" S LA7DOB=$E(LA7DOB,1,3)_"0000"
	;
	; Extract patient's sex
	S LA7SEX=$$P^LA7VHLU(.LA7SEG,9,LA7FS)
	;
	; Extract patient's race
	S LA7X=$$P^LA7VHLU(.LA7SEG,11,LA7FS)
	I $P(LA7X,LA7CS)'="" D
	. I $P(LA7X,LA7CS,3)="0005" S $P(LA7X,LA7CS,3)="HL70005"
	. S LA7PRACE=$P(LA7X,LA7CS)_":"_$P(LA7X,LA7CS,2)_$S($P(LA7X,LA7CS,3)'="":":"_$P(LA7X,LA7CS,3),1:"")
	;
	; Extract patient's SSN and determine DFN
	; If SSN determined previously from PID-3 then compare SSN's
	; If DFN determined previously from ICN then check DFN based on SSN.
	S LA7X=$P($$P^LA7VHLU(.LA7SEG,20,LA7FS),LA7CS)
	S LA7X=$TR(LA7X,"-","") ; remove "-" if any
	I LA7X?9N.1A D
	. I LA7SSN'="",LA7X'=LA7SSN Q
	. S LA7SSN=LA7X
	. I DFN,DFN'=$O(^DPT("SSN",LA7SSN,0)) Q
	. S DFN=$O(^DPT("SSN",LA7SSN,0))
	I LA7SSN'="" D
	. I LA7INTYP>19,LA7INTYP<30 D SETID^LA7VHLU1(LA76249,LA7ID,LA7SSN,1) Q
	. D SETID^LA7VHLU1(LA76249,LA7ID,LA7SSN,0)
	I DFN S LRDFN=$P($G(^DPT(DFN,"LR")),"^")
	;
	Q
	;
	;
PV1	; Process PV1 segment
	;
	; PV1 Set ID
	S LA7SPV1=$$P^LA7VHLU(.LA7SEG,2,LA7FS)
	;
	; Extract ordering location
	S LA7LOC=$P($$P^LA7VHLU(.LA7SEG,4,LA7FS),LA7CS)
	Q
