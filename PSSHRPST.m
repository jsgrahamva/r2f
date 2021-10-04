PSSHRPST	       ;WOIFO/STEVE GORDON - PRE - Post-Init to load pharmacy classes ;08/26/08
	       ;;1.0;PHARMACY DATA MANAGEMENT;**136,WVEHR,LOCAL**;9/30/97;Build 3;WorldVistA
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
	       QUIT
	       ;
EN	     ;  -- main entry point for pharmacy post-init
	       ;XML (PSSPRE_1_0.XML) must be in Kernel default directory
	       ;
	       ; -- delete all classes gov package
	       DO DELETE()
	       ;
	       ; --
	       ; 
	       NEW PSSTAT S PSSTAT=1
	       ;BEGIN LOCAL MOD WorldVistA 01/2014
	       ;WAS ; SET PSSTAT=$$IMPORT^XOBWLIB1($$GETDIR(),$$SUPPORT())
	       I $D(^rOBJ) SET PSSTAT=$$IMPORT^XOBWLIB1($$GETDIR(),$$SUPPORT())
	       ;END LOCAL MOD 
	       IF 'PSSTAT DO
	       . DO BMES^XPDUTL("Error occurred during the importing of pharmacy classes file:")
	       . DO MES^XPDUTL("  Directory: "_$$GETDIR())
	       . DO MES^XPDUTL("  File Name: "_$$SUPPORT())
	       . DO MES^XPDUTL("      Error: "_$PIECE(PSSTAT,"^",2))
	       . DO MES^XPDUTL(" o  Pharmacy class not imported.")
	       ELSE  DO
	       . DO MES^XPDUTL(" o  Pharmacy classes imported successfully.")
	       . DO MES^XPDUTL(" ")
	       . DO MAILMSG
	       ;
	       QUIT
	       ;
DELETE()	       ; -- delete classes for clean slate and remove previous releases
	       ;BEGIN LOCAL MOD WorldVistA/DJW 01/2014
	       ;insert test
	       I $D(^rOBJ) N VW S VW=$O(^rOBJ("xobw.")) Q:$E(VW,1,5)'="xobw." ;LOCAL
	       ;END LOCAL MOD
	       NEW PSSTAT
	       ; -- delete all classes in pharmacy package
	       DO BMES^XPDUTL(" o  Deleting gov classes:")
	       ;
	       ;BEGIN LOCAL MOD WorldVistA/DJW 01/2014
	       ;WAS ; SET PSSTAT=$SYSTEM.OBJ.DeletePackage("gov")
	       S PSSTAT=1 I $D(^rOBJ) SET PSSTAT=$SYSTEM.OBJ.DeletePackage("gov")
	       ;END LOCAL MOD
	       DO BMES^XPDUTL("       ...[gov] deletion "_$SELECT(PSSTAT:"finished successfully.",1:"failed."))
	       DO MES^XPDUTL("")
	       QUIT
	       ;
	       ;
SUPPORT()	      ;Returns the standard name of the XML file
	       ;
	       Q "PSSPRE_1_0.XML"
	       ;
GETDIR()	       ; -- get directory where install files are located--default is in Kernel parameters.
	       QUIT $$DEFDIR^%ZISH()
	       ;
MAILMSG	;
	       N XMDUZ,XMY,XMSUB,XMTEXT,XMZ,XMMG,DIFROM
	       S XMDUZ="PACKAGE PSS*1.0*136 INSTALL"
	       S XMTEXT="^TMP($J,""PSSHRPST"","
	       S XMY(+DUZ)=""
	       S XMY("G.PSS ORDER CHECKS")=""
	       S XMSUB="PSS*1.0*136 Installation Complete"
	       S ^TMP($J,"PSSHRPST",1)="Installation of Patch PSS*1.0*136 has been successfully completed!"
	       D ^XMD
	       Q
	       ;
