ECX150P1	;ALB/AG-ECX*3.0*150 Post-Init RTN ; 4/7/14 1:20pm
	;;3.0;DSS EXTRACTS;**150**;;Build 3
	;
	;Post-init routine inactivating codes in NATIONAL CLINIC (#728.441) file
	;
	Q
	;
INACT	;adding inactivation date to existing clinics
	N ECXCODE,ECXDATE,ECXIEN,DIE,DA,DR,ECXI,ECXREC
	D BMES^XPDUTL(">>>Inactivating entry in the NATIONAL CLINIC (728.441) file..")
	I $P(^DD(728.441,.01,0),"^",2)["I" D  Q
	.D BMES^XPDUTL(">>Unable to update File 728.441, it is locked")
	.D BMES^XPDUTL("Contact support for assistance")
	F ECXI=1:1 S ECXREC=$P($T(INCLIN+ECXI),";;",2) Q:ECXREC="QUIT"  D
	.S ECXCODE=$P(ECXREC,"^"),ECXDATE=$P(ECXREC,"^",2)
	.S ECXIEN=$$FIND1^DIC(728.441,"","X",ECXCODE,"","","ERR")
	.I 'ECXIEN D  Q
	..D BMES^XPDUTL(">>>....Unable to inactivate "_ECXCODE_" "_$P(ECXREC,U,2)_".")
	..D BMES^XPDUTL(">>>....Contact support for assistance")
	.S DIE="^ECX(728.441,",DA=ECXIEN,DR="3///^S X=ECXDATE"
	.D ^DIE
	.D BMES^XPDUTL(">>>....Code "_ECXCODE_" inactivated")
	Q
INCLIN	;contains the NATIONAL CLINIC entry inactivation date
	;;402A^3141001
	;;405A^3141001
	;;518A^3141001
	;;523A^3141001
	;;608A^3141001
	;;631A^3141001
	;;650A^3141001
	;;689K^3141001
	;;689J^3141001
	;;689I^3141001
	;;689H^3141001
	;;689G^3141001
	;;689F^3141001
	;;689E^3141001
	;;689D^3141001
	;;689C^3141001
	;;689B^3141001
	;;689A^3141001
	;;528A^3141001
	;;526A^3141001
	;;561A^3141001
	;;620A^3141001
	;;630A^3141001
	;;632A^3141001
	;;460A^3141001
	;;503A^3141001
	;;529A^3141001
	;;540A^3141001
	;;542A^3141001
	;;562A^3141001
	;;595A^3141001
	;;642A^3141001
	;;646A^3141001
	;;693A^3141001
	;;512A^3141001
	;;613A^3141001
	;;688A^3141001
	;;517A^3141001
	;;558A^3141001
	;;565A^3141001
	;;590A^3141001
	;;637A^3141001
	;;652A^3141001
	;;658A^3141001
	;;659A^3141001
	;;508A^3141001
	;;509A^3141001
	;;521A^3141001
	;;534A^3141001
	;;544A^3141001
	;;557A^3141001
	;;619A^3141001
	;;679A^3141001
	;;516A^3141001
	;;546A^3141001
	;;548A^3141001
	;;573A^3141001
	;;672A^3141001
	;;673A^3141001
	;;581A^3141001
	;;596A^3141001
	;;603A^3141001
	;;614A^3141001
	;;621A^3141001
	;;626A^3141001
	;;538A^3141001
	;;539A^3141001
	;;541A^3141001
	;;552A^3141001
	;;757A^3141001
	;;506A^3141001
	;;515A^3141001
	;;550A^3141001
	;;553A^3141001
	;;583A^3141001
	;;610A^3141001
	;;655A^3141001
	;;556A^3141001
	;;578A^3141001
	;;585A^3141001
	;;607A^3141001
	;;676A^3141001
	;;695A^3141001
	;;589A^3141001
	;;657A^3141001
	;;502A^3141001
	;;520A^3141001
	;;564A^3141001
	;;580A^3141001
	;;586A^3141001
	;;598A^3141001
	;;623A^3141001
	;;629A^3141001
	;;635A^3141001
	;;667A^3141001
	;;549A^3141001
	;;671A^3141001
	;;674A^3141001
	;;504A^3141001
	;;519A^3141001
	;;644A^3141001
	;;649A^3141001
	;;678A^3141001
	;;756A^3141001
	;;436A^3141001
	;;442A^3141001
	;;554A^3141001
	;;575A^3141001
	;;660A^3141001
	;;666A^3141001
	;;463A^3141001
	;;531A^3141001
	;;648A^3141001
	;;653A^3141001
	;;663A^3141001
	;;668A^3141001
	;;687A^3141001
	;;692A^3141001
	;;459A^3141001
	;;570A^3141001
	;;612A^3141001
	;;640A^3141001
	;;654A^3141001
	;;662A^3141001
	;;593A^3141001
	;;600A^3141001
	;;605A^3141001
	;;664A^3141001
	;;691A^3141001
	;;437A^3141001
	;;438A^3141001
	;;568A^3141001
	;;618A^3141001
	;;636A^3141001
	;;656A^3141001
	;;402B^3141001
	;;405B^3141001
	;;518B^3141001
	;;523B^3141001
	;;608B^3141001
	;;631B^3141001
	;;650B^3141001
	;;528B^3141001
	;;526B^3141001
	;;561B^3141001
	;;620B^3141001
	;;630B^3141001
	;;632B^3141001
	;;460B^3141001
	;;503B^3141001
	;;529B^3141001
	;;540B^3141001
	;;542B^3141001
	;;562B^3141001
	;;595B^3141001
	;;642B^3141001
	;;646B^3141001
	;;693B^3141001
	;;512B^3141001
	;;613B^3141001
	;;688B^3141001
	;;517B^3141001
	;;558B^3141001
	;;565B^3141001
	;;590B^3141001
	;;637B^3141001
	;;652B^3141001
	;;658B^3141001
	;;659B^3141001
	;;508B^3141001
	;;509B^3141001
	;;521B^3141001
	;;534B^3141001
	;;544B^3141001
	;;557B^3141001
	;;619B^3141001
	;;679B^3141001
	;;516B^3141001
	;;546B^3141001
	;;548B^3141001
	;;573B^3141001
	;;672B^3141001
	;;673B^3141001
	;;581B^3141001
	;;596B^3141001
	;;603B^3141001
	;;614B^3141001
	;;621B^3141001
	;;626B^3141001
	;;538B^3141001
	;;539B^3141001
	;;541B^3141001
	;;552B^3141001
	;;757B^3141001
	;;506B^3141001
	;;515B^3141001
	;;550B^3141001
	;;553B^3141001
	;;583B^3141001
	;;610B^3141001
	;;655B^3141001
	;;556B^3141001
	;;578B^3141001
	;;585B^3141001
	;;607B^3141001
	;;676B^3141001
	;;695B^3141001
	;;589B^3141001
	;;657B^3141001
	;;502B^3141001
	;;520B^3141001
	;;564B^3141001
	;;580B^3141001
	;;586B^3141001
	;;598B^3141001
	;;623B^3141001
	;;629B^3141001
	;;635B^3141001
	;;667B^3141001
	;;549B^3141001
	;;671B^3141001
	;;674B^3141001
	;;504B^3141001
	;;519B^3141001
	;;644B^3141001
	;;649B^3141001
	;;678B^3141001
	;;756B^3141001
	;;436B^3141001
	;;442B^3141001
	;;554B^3141001
	;;575B^3141001
	;;660B^3141001
	;;666B^3141001
	;;463B^3141001
	;;531B^3141001
	;;648B^3141001
	;;653B^3141001
	;;663B^3141001
	;;668B^3141001
	;;687B^3141001
	;;692B^3141001
	;;459B^3141001
	;;570B^3141001
	;;612B^3141001
	;;640B^3141001
	;;654B^3141001
	;;662B^3141001
	;;593B^3141001
	;;600B^3141001
	;;605B^3141001
	;;664B^3141001
	;;691B^3141001
	;;437B^3141001
	;;438B^3141001
	;;568B^3141001
	;;618B^3141001
	;;636B^3141001
	;;656B^3141001
	;;402C^3141001
	;;405C^3141001
	;;518C^3141001
	;;523C^3141001
	;;608C^3141001
	;;631C^3141001
	;;650C^3141001
	;;528C^3141001
	;;526C^3141001
	;;561C^3141001
	;;620C^3141001
	;;630C^3141001
	;;632C^3141001
	;;460C^3141001
	;;503C^3141001
	;;529C^3141001
	;;540C^3141001
	;;542C^3141001
	;;562C^3141001
	;;595C^3141001
	;;642C^3141001
	;;646C^3141001
	;;693C^3141001
	;;512C^3141001
	;;613C^3141001
	;;688C^3141001
	;;517C^3141001
	;;558C^3141001
	;;565C^3141001
	;;590C^3141001
	;;637C^3141001
	;;652C^3141001
	;;658C^3141001
	;;659C^3141001
	;;508C^3141001
	;;509C^3141001
	;;521C^3141001
	;;534C^3141001
	;;544C^3141001
	;;557C^3141001
	;;619C^3141001
	;;679C^3141001
	;;516C^3141001
	;;546C^3141001
	;;548C^3141001
	;;573C^3141001
	;;672C^3141001
	;;673C^3141001
	;;581C^3141001
	;;596C^3141001
	;;603C^3141001
	;;614C^3141001
	;;621C^3141001
	;;626C^3141001
	;;538C^3141001
	;;539C^3141001
	;;541C^3141001
	;;552C^3141001
	;;757C^3141001
	;;506C^3141001
	;;515C^3141001
	;;550C^3141001
	;;553C^3141001
	;;583C^3141001
	;;610C^3141001
	;;655C^3141001
	;;556C^3141001
	;;578C^3141001
	;;585C^3141001
	;;607C^3141001
	;;676C^3141001
	;;695C^3141001
	;;589C^3141001
	;;657C^3141001
	;;502C^3141001
	;;520C^3141001
	;;564C^3141001
	;;580C^3141001
	;;586C^3141001
	;;598C^3141001
	;;623C^3141001
	;;629C^3141001
	;;635C^3141001
	;;667C^3141001
	;;549C^3141001
	;;671C^3141001
	;;674C^3141001
	;;504C^3141001
	;;519C^3141001
	;;644C^3141001
	;;649C^3141001
	;;678C^3141001
	;;756C^3141001
	;;436C^3141001
	;;442C^3141001
	;;554C^3141001
	;;575C^3141001
	;;660C^3141001
	;;666C^3141001
	;;463C^3141001
	;;531C^3141001
	;;648C^3141001
	;;653C^3141001
	;;663C^3141001
	;;668C^3141001
	;;687C^3141001
	;;692C^3141001
	;;459C^3141001
	;;570C^3141001
	;;612C^3141001
	;;640C^3141001
	;;654C^3141001
	;;662C^3141001
	;;593C^3141001
	;;600C^3141001
	;;605C^3141001
	;;664C^3141001
	;;691C^3141001
	;;437C^3141001
	;;438C^3141001
	;;568C^3141001
	;;618C^3141001
	;;636C^3141001
	;;656C^3141001
	;;402D^3141001
	;;405D^3141001
	;;518D^3141001
	;;523D^3141001
	;;608D^3141001
	;;631D^3141001
	;;650D^3141001
	;;528D^3141001
	;;526D^3141001
	;;561D^3141001
	;;620D^3141001
	;;630D^3141001
	;;632D^3141001
	;;460D^3141001
	;;503D^3141001
	;;529D^3141001
	;;540D^3141001
	;;542D^3141001
	;;562D^3141001
	;;595D^3141001
	;;642D^3141001
	;;646D^3141001
	;;693D^3141001
	;;512D^3141001
	;;613D^3141001
	;;688D^3141001
	;;517D^3141001
	;;558D^3141001
	;;565D^3141001
	;;590D^3141001
	;;637D^3141001
	;;652D^3141001
	;;658D^3141001
	;;659D^3141001
	;;508D^3141001
	;;509D^3141001
	;;521D^3141001
	;;534D^3141001
	;;544D^3141001
	;;557D^3141001
	;;619D^3141001
	;;679D^3141001
	;;516D^3141001
	;;546D^3141001
	;;548D^3141001
	;;573D^3141001
	;;672D^3141001
	;;673D^3141001
	;;581D^3141001
	;;596D^3141001
	;;603D^3141001
	;;614D^3141001
	;;621D^3141001
	;;626D^3141001
	;;538D^3141001
	;;539D^3141001
	;;541D^3141001
	;;552D^3141001
	;;757D^3141001
	;;506D^3141001
	;;515D^3141001
	;;550D^3141001
	;;553D^3141001
	;;583D^3141001
	;;610D^3141001
	;;655D^3141001
	;;556D^3141001
	;;578D^3141001
	;;585D^3141001
	;;607D^3141001
	;;676D^3141001
	;;695D^3141001
	;;589D^3141001
	;;657D^3141001
	;;502D^3141001
	;;520D^3141001
	;;564D^3141001
	;;580D^3141001
	;;586D^3141001
	;;598D^3141001
	;;623D^3141001
	;;629D^3141001
	;;635D^3141001
	;;667D^3141001
	;;549D^3141001
	;;671D^3141001
	;;674D^3141001
	;;504D^3141001
	;;519D^3141001
	;;644D^3141001
	;;649D^3141001
	;;678D^3141001
	;;756D^3141001
	;;436D^3141001
	;;442D^3141001
	;;554D^3141001
	;;575D^3141001
	;;660D^3141001
	;;666D^3141001
	;;463D^3141001
	;;531D^3141001
	;;648D^3141001
	;;653D^3141001
	;;663D^3141001
	;;668D^3141001
	;;687D^3141001
	;;692D^3141001
	;;459D^3141001
	;;570D^3141001
	;;612D^3141001
	;;640D^3141001
	;;654D^3141001
	;;662D^3141001
	;;593D^3141001
	;;600D^3141001
	;;605D^3141001
	;;664D^3141001
	;;691D^3141001
	;;437D^3141001
	;;438D^3141001
	;;568D^3141001
	;;618D^3141001
	;;636D^3141001
	;;656D^3141001
	;;402E^3141001
	;;405E^3141001
	;;518E^3141001
	;;523E^3141001
	;;608E^3141001
	;;631E^3141001
	;;650E^3141001
	;;528E^3141001
	;;526E^3141001
	;;561E^3141001
	;;620E^3141001
	;;630E^3141001
	;;632E^3141001
	;;460E^3141001
	;;503E^3141001
	;;529E^3141001
	;;540E^3141001
	;;542E^3141001
	;;562E^3141001
	;;595E^3141001
	;;642E^3141001
	;;646E^3141001
	;;693E^3141001
	;;512E^3141001
	;;613E^3141001
	;;688E^3141001
	;;517E^3141001
	;;558E^3141001
	;;565E^3141001
	;;590E^3141001
	;;637E^3141001
	;;652E^3141001
	;;658E^3141001
	;;659E^3141001
	;;508E^3141001
	;;509E^3141001
	;;521E^3141001
	;;534E^3141001
	;;544E^3141001
	;;557E^3141001
	;;619E^3141001
	;;679E^3141001
	;;516E^3141001
	;;546E^3141001
	;;548E^3141001
	;;573E^3141001
	;;672E^3141001
	;;673E^3141001
	;;581E^3141001
	;;596E^3141001
	;;603E^3141001
	;;614E^3141001
	;;621E^3141001
	;;626E^3141001
	;;538E^3141001
	;;539E^3141001
	;;541E^3141001
	;;552E^3141001
	;;757E^3141001
	;;506E^3141001
	;;515E^3141001
	;;550E^3141001
	;;553E^3141001
	;;583E^3141001
	;;610E^3141001
	;;655E^3141001
	;;556E^3141001
	;;578E^3141001
	;;585E^3141001
	;;607E^3141001
	;;676E^3141001
	;;695E^3141001
	;;589E^3141001
	;;657E^3141001
	;;502E^3141001
	;;520E^3141001
	;;564E^3141001
	;;580E^3141001
	;;586E^3141001
	;;598E^3141001
	;;623E^3141001
	;;629E^3141001
	;;635E^3141001
	;;667E^3141001
	;;549E^3141001
	;;671E^3141001
	;;674E^3141001
	;;504E^3141001
	;;519E^3141001
	;;644E^3141001
	;;649E^3141001
	;;678E^3141001
	;;756E^3141001
	;;436E^3141001
	;;442E^3141001
	;;554E^3141001
	;;575E^3141001
	;;660E^3141001
	;;666E^3141001
	;;463E^3141001
	;;531E^3141001
	;;648E^3141001
	;;653E^3141001
	;;663E^3141001
	;;668E^3141001
	;;687E^3141001
	;;692E^3141001
	;;459E^3141001
	;;570E^3141001
	;;612E^3141001
	;;640E^3141001
	;;654E^3141001
	;;662E^3141001
	;;593E^3141001
	;;600E^3141001
	;;605E^3141001
	;;664E^3141001
	;;691E^3141001
	;;437E^3141001
	;;438E^3141001
	;;568E^3141001
	;;618E^3141001
	;;636E^3141001
	;;656E^3141001
	;;QUIT