VWCPTZAP	;WorldVistA/Port Clinton/SO- Remove CPT Copyrighted Data;11:31 AM  17 Oct 2009
	;;1.0;**WVEHR,LOCAL**;WorldVistA 30-June-08;;Build 8
	;
	;Modified from FOIA VISTA,
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
	QUIT  ;No execution from the top
	;
CPTZAP	;Remove copyrighted data
	N FHDR
	;
	S FHDR=$P(^ICPT(0),U,1,2) K ^ICPT S ^ICPT(0)=FHDR
	S FHDR=$P(^DIC(81.1,0),U,1,2) K ^DIC(81.1) S ^DIC(81.1,0)=FHDR,^(0,"GL")="^DIC(81.1,"
	S FHDR=$P(^DIC(81.3,0),U,1,2) K ^DIC(81.3) S ^DIC(81.3,0)=FHDR,^(0,"GL")="^DIC(81.3,"
	S %=$P(^DD(757.02,1,0),U,2) I %'="RF" W !,"File: 757.02, Field: 1 has changed" Q
	S $P(^DD(757.02,1,0),U,2)="F"
	S %=$P(^DD(757.02,2,0),U,2) I %'="RP757.03'" W !,"File: 757.02, Field: 2 has changed" Q
	S $P(^DD(757.02,2,0),U,2)="P757.03'"
	;
	D WAIT^DICD
	N DA,DIE,DR
	S DA=0,DIE=757.02,DR="1///@;2///@"
	F  S DA=$O(^LEX(757.02,DA)) Q:DA'>0  D
	. S %=$P($G(^LEX(757.02,DA,0)),U,3)
	. I %=3!(%=4) D ^DIE
	. QUIT
	S $P(^DD(757.02,1,0),U,2)="RF"
	S $P(^DD(757.02,2,0),U,2)="RP757.03'"
	;
	QUIT
