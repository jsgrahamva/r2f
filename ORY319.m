ORY319	;SLC/SLCOIFO-Pre and Post-init for patch OR*3*319 ;5:34 AM  17 Feb 2012
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**319,WVEHR,LOCAL**;Dec 17, 1997;Build 3;WorldVistA 30-June-08
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
POST	; post-init process
	N CPRSOPT,RPCIEN S CPRSOPT=$$CPRSOPT,RPCIEN=$$RPCIEN("ORVW FACLIST")
	I '+$D(CPRSOPT) D  Q
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "CPRS option not found",!
	.D MES^XPDUTL("CPRS option not found")
	.;End  WorldVistA change
	.D NOTCOMP
	I '+$D(RPCIEN) D  Q
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "RPC not found",!
	.D MES^XPDUTL("RPC not found")
	.;End  WorldVistA change
	.D NOTCOMP
	;
	I +$$RPCNOPT(CPRSOPT,RPCIEN) D  Q
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "RPC already in option",!
	.D MES^XPDUTL("RPC already in option")
	.;End  WorldVistA change
	.D COMPLETE
	;Begin WorldVistA change ;NO HOME 1.0
	;W "Inserting RPC in option",!
	D MES^XPDUTL("Inserting RPC in option")
	;End  WorldVistA change
	I '$$INSERT(CPRSOPT,RPCIEN) D  Q
	.D NOTCOMP
	D COMPLETE
	Q
RPCNOPT(OPTIEN,RPCIEN)	;
	Q $O(^DIC(19,OPTIEN,"RPC","B",RPCIEN,0))
	;
INSERT(OPTIEN,RPCIEN)	;
	N REC,ERR
	S REC(19.05,"+1,"_OPTIEN_",",.01)=RPCIEN
	D UPDATE^DIE("","REC","","ERR")
	I +$D(ERR) D  Q 0
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "=== ERROR ===",!
	.;ZW ERR
	.D MES^XPDUTL("=== ERROR ===")
	.D MES^XPDUTL(.ERR)
	.;End  WorldVistA change
	Q 1
	;
CPRSOPT()	;Finds the IEN of the "OR CPRS GUI CHART" option
	N OPTNAME S OPTNAME="OR CPRS GUI CHART"
	;Begin WorldVistA change ;NO HOME 1.0
	;W "Looking for '"_OPTNAME_"'..."
	D MES^XPDUTL("Looking for '"_OPTNAME_"'...")
	;End  WorldVistA change
	N INDEX,ERR S INDEX=$$FIND1^DIC(19,"","X",OPTNAME,"B","","ERR")
	I +$D(ERR) D  Q 0
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "ERROR TRYING TO FIND OPTION",!
	.;ZW ERR
	.D MES^XPDUTL("ERROR TRYING TO FIND OPTION")
	.D MES^XPDUTL(.ERR)
	;W "Found option",!
	D MES^XPDUTL("Found option")
	;End  WorldVistA change
	Q INDEX
	;
RPCIEN(RPCNAME)	; Returns the ICN of the given RPC name
	;Begin WorldVistA change ;NO HOME 1.0
	;W "Looking for RPC '"_RPCNAME_"'..."
	D MES^XPDUTL("Looking for RPC '"_RPCNAME_"'...")
	;End  WorldVistA change
	N INDEX,ERR S INDEX=$$FIND1^DIC(8994,"","X",RPCNAME,"B","","ERR")
	I +$D(ERR) D  Q 0
	.;Begin WorldVistA change ;NO HOME 1.0
	.;W "ERROR TRYING TO FIND RPC '"_RPCNAME_"'",!
	.;ZW ERR
	.D MES^XPDUTL("ERROR TRYING TO FIND RPC '"_RPCNAME_"'")
	.D MES^XPDUTL(.ERR)
	;W "Found RPC",!
	D MES^XPDUTL("Found RPC")
	;End  WorldVistA change
	Q INDEX
	;
NOTCOMP	; Not Completed Message
	;Begin WorldVistA change ;NO HOME 1.0
	;W "Post-install NOT COMPLETED!"
	D MES^XPDUTL("Post-install NOT COMPLETED!")
	;End  WorldVistA change
	Q
	;
COMPLETE	; Completed Message
	;Begin WorldVistA change ;NO HOME 1.0
	;W "Post-install COMPLETED normally"
	D MES^XPDUTL("Post-install COMPLETED normally")
	;End  WorldVistA change
	Q
	;
