#! /usr/bin/perl -w

use locale;             # Ensure correct charset for eg 'uc()'
use DBI;                # Database connections
use strict;             # Enforce declarations
use strict;
use warnings;
use DateTime;
use Archive::Zip;

my $dt = DateTime->now->set_time_zone( 'America/Los_Angeles' );

# MYSQL CONFIG VARIABLES
my $hostname = "VM2";
my $database = "Rayzist";
my $user = "rgeis";
my $password = "frog418";

# PERL CONNECT()
#my $dbh = Mysql->connect($hostname, $database, $user, $password);
my $dsn = "DBI:mysql:database=$database;host=$hostname;" ;
my $dbh = DBI->connect($dsn, $user, $password) ;

 
# ...
my $phone_sql = 'SELECT Extension, MacAddress, phone_ext.Access, CONCAT_WS( " ", FirstName, LastName ) AS Description FROM phone_ext LEFT JOIN phone_dir on phone_dir.Dial = phone_ext.Extension';
my $phone_sth = $dbh->prepare($phone_sql);
$phone_sth->execute();
my $row_p;
while ($row_p = $phone_sth->fetchrow_hashref()) {
	my $ext = $row_p->{Extension};
	my $mac = $row_p->{MacAddress};
	my $acc = $row_p->{Access};
	my $des = $row_p->{Description};
	$mac =~ tr/://d;
	
	open (OUTPUTFILE, ">$mac-directory.xml") || die("Could not open/create the output file directory-000000000000.xml!\n");	
	print OUTPUTFILE "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
	print OUTPUTFILE "<!-- edited with XMLSPY v5 rel. 4 U (http://www.xmlspy.com) -->\n";	
	print OUTPUTFILE  "<?Saved @ --".$dt."-- ?>\n";
	print OUTPUTFILE "<!-- name: ".$des." -->\n";	
	print OUTPUTFILE "<!-- extension: ".$ext." -->\n";	
	print OUTPUTFILE  "<directory>\n";
	print OUTPUTFILE "<item_list>\n";
	
	my $dir_sth = $dbh->prepare('SET @sd1:=1;');
	$dir_sth->execute();
	$dir_sth = $dbh->prepare('SET @sd2:=108;;');
	$dir_sth->execute();
	my $dir_sql = '
		SELECT
			Description,
			Dial,
			bw,
			sd,
			Priority 
		FROM
			(
				(
				SELECT
					Description,
					Dial,
					bw,
					@sd1 := @sd1 + 1 AS sd,
					Priority 
				FROM
					(
					SELECT
					IF
						(
							( phone_quick.FirstName IS NULL OR phone_quick.FirstName = "" ) 
							AND ( phone_quick.LastName IS NULL OR phone_quick.LastName = "" ),
							CONCAT_WS( " ", phone_dir.FirstName, phone_dir.LastName ),
							CONCAT_WS( " ", phone_quick.FirstName, phone_quick.LastName ) 
						) AS Description,
						phone_quick.Dial,
						phone_quick.bw,
						phone_quick.Priority 
					FROM
						phone_quick
						LEFT JOIN phone_dir ON phone_dir.Dial = phone_quick.Dial 
					WHERE
						Extension = "'.$ext.'" 
					ORDER BY
						Priority,
						Description 
					) a 
				) UNION
				(
				SELECT
					Description,
					Dial,
					bw,
					@sd2 := @sd2 + 1 AS sd,
					Priority 
				FROM
					( SELECT
							CONCAT_WS( " ", FirstName, LastName ) AS Description,
							Dial,
							bw,
							Priority
						FROM
							phone_dir
						WHERE
							Access <= '.$acc.'
						ORDER BY
							Priority, Description
					) b 
				) 
			) c 
		ORDER BY
			Priority,
			Description
	';
	$dir_sth = $dbh->prepare($dir_sql);
	$dir_sth->execute();
	my $row_d;
	while ($row_d = $dir_sth->fetchrow_hashref()) {
		my $description = $row_d->{Description};
		my $dial = $row_d->{Dial};
		my $bw = $row_d->{bw};
		my $sd = $row_d->{sd};
		print OUTPUTFILE "<item>";
		if (length($dial) == 3) {print OUTPUTFILE "<fn>$dial</fn>";}
		print OUTPUTFILE "<ln>$description</ln>";
		print OUTPUTFILE "<ct>$dial</ct>";
		print OUTPUTFILE "<sd>$sd</sd>";
		#print OUTPUTFILE "<lb>$column5</lb>";
		#print OUTPUTFILE "<pt>$column6</pt>";
		print OUTPUTFILE "<rt>ringerdefault</rt>";
		#print OUTPUTFILE "<dc>$column8</dc>";
		if (length($dial) < 5) {print OUTPUTFILE "<ad>0</ad>";}
		if (length($dial) < 5) {print OUTPUTFILE "<ar>0</ar>";}
		print OUTPUTFILE "<bw>$bw</bw>";
		if (length($dial) < 5) {print OUTPUTFILE "<bb>0</bb>";}
		print OUTPUTFILE "</item>\n";
	}
	print OUTPUTFILE "</item_list>\n";
	print OUTPUTFILE "</directory>\n";	
	
	
	close (OUTPUTFILE);
}
 
$dbh->disconnect;


my $zip = Archive::Zip->new();

$zip->addTreeMatching( '.', '', '\.xml$' );
# and write them into a file
$zip->writeToFileNamed('Polycom Phone XML '.$dt->strftime("%F %H%M%S").'.zip');


exit;

#CREATE TABLE `phone_ext` (              
#  `Extension` int(4) unsigned NOT NULL, 
#  `MacAddress` varchar(17) NOT NULL,    
#  `Access` int(1) unsigned DEFAULT NULL,
#  `Type` varchar(20) DEFAULT NULL,      
#  PRIMARY KEY (`Extension`,`MacAddress`)
#) ENGINE=InnoDB DEFAULT CHARSET=utf8;   


#CREATE TABLE `phone_dir` (                                 
#  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,            
#  `FirstName` varchar(15) DEFAULT NULL,                    
#  `LastName` varchar(15) DEFAULT NULL,                     
#  `Dial` varchar(25) DEFAULT NULL,                         
#  `Priority` int(3) unsigned DEFAULT NULL,                 
#  `Access` int(1) unsigned DEFAULT NULL,                   
#  `bw` int(1) NOT NULL DEFAULT '0',                        
#  PRIMARY KEY (`id`)                                       
#) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;    


#CREATE TABLE `phone_quick` (
#  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
#  `Extension` int(4) unsigned DEFAULT NULL,
#  `FirstName` varchar(15) DEFAULT NULL,
#  `LastName` varchar(15) DEFAULT NULL,
#  `Dial` varchar(25) DEFAULT NULL,
#  `Priority` int(3) DEFAULT NULL,
#  `bw` int(1) DEFAULT '1',
#  PRIMARY KEY (`id`)
#) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8;

