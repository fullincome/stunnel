use strict;
use Scripts;

my $DataPath = '/var/opt/cprocsp/tmp/';

sub DisableInstallCertWindow($);

#-----------------------------------------------------------------------------
{
    #make dsrf
    RunCmd('MakeDSRF', "/opt/cprocsp/sbin/amd64/cpconfig -hardware rndm -add cpsd -name 'cpsd rng' -level 2 ");
    RunCmd('MakeDSRF', "/opt/cprocsp/sbin/amd64/cpconfig -hardware rndm -configure cpsd -add string /db1/kis_1 /var/opt/cprocsp/dsrf/db1/kis_1");
    RunCmd('MakeDSRF', "/opt/cprocsp/sbin/amd64/cpconfig -hardware rndm -configure cpsd -add string /db2/kis_1 /var/opt/cprocsp/dsrf/db2/kis_1");
    RunCmd('MakeDSRF', "cp ./mydsrf /var/opt/cprocsp/dsrf/db1/kis_1");
    RunCmd('MakeDSRF', "cp ./mydsrf /var/opt/cprocsp/dsrf/db2/kis_1");
}
