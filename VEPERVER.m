VEPERVER	;CJS/QRI ;11/5/07  15:40
	; WVEHR/VOE Version display, 1.0.0;;;;**WVEHR,LOCAL**;Build 3
	;
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
DISP	;
	N ANS,OS,ROOT,FILENAME,SAVEDUZ,DECRYPT,ERROR
	S SAVEDUZ=DUZ,DUZ=.5 K ^TMP($J) 
	S ^TMP($J,1,0)="                    WorldVistA EHR /VOE 1.0 uncertified" G NOTDONE ; Remove line when routine is completed
	S FILENAME="VEPERVER_"_$J_".txt"
	; depending on the OS, we get the directory and decrypt command
	I +^DD("OS")=18 D  ;for Cache' we need to know which OS it's running under
	. S OS=$S($ZV["VMS":"VMS",$ZV["Windows":"NT",$ZV["NT":"NT",$ZV["UNIX":"UNIX",1:"UNK")
	. I OS="NT" S ROOT="C:\TEMP\",DECRYPT="S X=$ZF(-1,""decrypt etc"")" ;What's the DOS command to decrypt?
	. I OS'="NT" S ERROR=1
	;
	I +^DD("OS")=17 D  ;for GT.M(VAX) ... Is this needed?
	. S ROOT=""
	. S ERROR=1 ;Since we don't have the code for this yet
	;
	I +^DD("OS")=19 D  ;for GT.M under UNIX
	. S ROOT="/tmp/"
	. S DECRYPT="ZSYstem ""echo Jix4uXDB | gpg --passphrase-fd 0 --output "_ROOT_FILENAME_" --decrypt "_ROOT_FILENAME_".asc"""
	;
	I $D(ERROR) G EXIT
	;
	D OPEN^%ZISH("OUTFILE",ROOT,FILENAME_".asc","W")
	I POP G EXIT
	U IO
	S LINE=0 F  S LINE=$O(^XTMP("VEPERVER",LINE,0)) Q:LINE'>0  S TEXT=^(LINE)  W TEXT,!
	D CLOSE^%ZISH("OUTFILE")
	;
	X @DCRYPT ; invoke the decryption appropriate to the OS
	; Now, read in the decrypted text
	S Y=$$FTG^%ZISH(ROOT,FILENAME,$NA(^TMP($J,1,0)),2) I 'Y W !,"Error copying to global" G EXIT
	;
NOTDONE	; and display the text
	W #!!?21,$C(27),"[33m",$C(27),"[31m"
	S LINE=0 F  S LINE=$O(^TMP($J,LINE)) Q:LINE'>0  W !,^TMP($J,LINE,0)
	W !!,$C(27),"[0m",?30,"Press a key to continue" R ANS#1
	G EXIT
	;
LOADPGP	; Load the PGP MESSAGE into ^XTMP
	S SAVEDUZ=DUZ,DUZ=.5 N ROOT,DIR,FILENAME K ^XTMP("VEPERVER")
	S DIR(0)="F^2:60",DIR("A")="Full path, up to but not including patch names" D ^DIR G:Y="^" EXIT S ROOT=Y
	S DIR(0)="F^2:60",DIR("A")="Enter the file name" D ^DIR G:Y="^" EXIT S FILENAME=Y
	S Y=$$FTG^%ZISH(ROOT,FILENAME,$NA(^XTMP("VEPERVER",1,0)),2) I 'Y W !,"Error copying to global" G EXIT
	S ^XTMP("VEPERVER",0)="3990101^"_DT_"^PGP MESSAGE for WorldVistA EHR certified" ; make it SACC compliant
EXIT	S DUZ=SAVEDUZ K ^TMP($J)
	Q
