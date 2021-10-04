RMPR125P	;HINES OI/SPS-PRE INSTALL ROUTINE FOR P125;6:32 AM  1 Jan 2012
	;;3.0;PROSTHETICS;**125,WVEHR,LOCAL**;Feb 09, 1996;Build 3;WorldVistA 30-June-08
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
	S DIK="^DD(660,",DA=49,DA(1)=660 D ^DIK
	;Begin WorldVistA change
	;K DA,DIK,
	K DA,DIK
	;End WorldVistA change
	Q
	;
	;END
