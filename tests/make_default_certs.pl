
use strict;
use Scripts;

my $DataPath = '/var/opt/cprocsp/tmp/';

sub DisableInstallCertWindow($);

#-----------------------------------------------------------------------------
{

    my $cryptcp = '/opt/cprocsp/bin/amd64/cryptcp';
    my $csptest = '/opt/cprocsp/bin/amd64/csptest';
    
    #RunCmd("DelCert", $cryptcp . ' -delcert -m -yes -dn CN= -nochain');
    RunCmd("DelCert", $cryptcp . ' -delcert -umy -yes');
    RunCmd("DelCert", $csptest . ' -notime -noerrorwait -keyset -silent -deletekeyset -pattern "" -verifyco -provtype 81');
    RunCmd("DelCert", $csptest . ' -notime -noerrorwait -keyset -silent -deletekeyset -pattern "" -verifyco -provtype 75');

    #delete ssl certs and keys
    RunCmd('DelCertRSA', 'rm ' . $DataPath . 'srvRSA.cer') if (-e $DataPath . 'srvRSA.cer');
    RunCmd('DelCertRSA', 'rm ' . $DataPath . 'clnRSA.cer') if (-e $DataPath . 'clnRSA.cer');
    RunCmd('DelKeyRSA', 'rm ' . $DataPath . 'srvRSA.key') if (-e $DataPath . 'srvRSA.key');
    RunCmd('DelKeyRSA', 'rm ' . $DataPath . 'clnRSA.key') if (-e $DataPath . 'clnRSA.key');

    RunCmd('DelCertPem', 'rm ' . $DataPath . 'cln.pem') if (-e $DataPath . 'cln.pem');
    RunCmd('DelCertPem', 'rm ' . $DataPath . 'srv.pem') if (-e $DataPath . 'srv.pem');

    #make RSA certs
    RunCmd('MakeCertAndKeyRSA', 'openssl req -x509 -newkey rsa:2048 -keyout ' . $DataPath . 'srvRSA.key -nodes -out ' . $DataPath . 'srvRSA.cer -subj \'/CN=srvRSA/C=RU\' ');
    RunCmd('MakeCertAndKeyRSA', 'openssl rsa -in ' . $DataPath . 'srvRSA.key -out ' . $DataPath . 'srvRSA.key');

    RunCmd('MakeCertAndKeyRSA', 'openssl req -x509 -newkey rsa:2048 -keyout ' . $DataPath . 'clnRSA.key -nodes -out ' . $DataPath . 'clnRSA.cer -subj \'/CN=clnRSA/C=RU\' ');
    RunCmd('MakeCertAndKeyRSA', 'openssl rsa -in ' . $DataPath . 'clnRSA.key -out ' . $DataPath . 'clnRSA.key');
    
    #make GOST certs
    #new certs
    RunCmd('MakeCertGOST', "/opt/cprocsp/bin/amd64/cryptcp -creatcert -provtype 81 -silent -rdn \'CN=srv2012\' -cont \'\\\\.\\HDIMAGE\\srv2012key\' -certusage 1.3.6.1.5.5.7.3.1 -ku -du -ex -ca http://cryptopro.ru/certsrv -enable-install-root");
    RunCmd('MakeCertGOST', "/opt/cprocsp/bin/amd64/cryptcp -creatcert -provtype 81 -silent -rdn \'E=cln512ecryptopro.ru, CN=cln2012\' -cont \'\\\\.\\HDIMAGE\\cln2012key\' -certusage 1.3.6.1.5.5.7.3.2 -ku -du -both -ca http://cryptopro.ru/certsrv -enable-install-root");
 
    #old certs (могут быть ошибки из-за упоминания о старых сертификатах)
    RunCmd('MakeCertGOST', "/opt/cprocsp/bin/amd64/cryptcp -creatcert -provtype 75 -silent -rdn \'CN=srv2001\' -cont \'\\\\.\\HDIMAGE\\srv2001key\' -certusage 1.3.6.1.5.5.7.3.1 -ku -du -ex -ca http://cryptopro.ru/certsrv -keysize 512 -hashalg 1.2.643.2.2.9 -enable-install-root");
    RunCmd('MakeCertGOST', "/opt/cprocsp/bin/amd64/cryptcp -creatcert -provtype 75 -silent -rdn \'E=cln512ecryptopro.ru, CN=cln2001\' -cont \'\\\\.\\HDIMAGE\\cln2001key\' -certusage 1.3.6.1.5.5.7.3.2 -ku -du -both -ca http://cryptopro.ru/certsrv -keysize 512 -hashalg 1.2.643.2.2.9 -enable-install-root");
    
    #export certs
    RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -dest ".$DataPath."srv2012.cer -dn CN=srv2012");
    RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -dest ".$DataPath."cln2012.cer -dn CN=cln2012");
    RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -dest ".$DataPath."srv2001.cer -dn CN=srv2001");
    RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -dest ".$DataPath."cln2001.cer -dn CN=cln2001");
    RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -store mroot -dest ".$DataPath."cpro-ca.cer -dn CN='CRYPTO-PRO Test Center 2'");
    #RunCmd('Safe cert in '.$DataPath, "/opt/cprocsp/bin/amd64/certmgr -export -cert -store mroot -dest ".$DataPath."ca.cer -dn CN=test-ca");


    RunCmd('Make cert PEM format in '.$DataPath, "openssl x509 -inform DER -in " . $DataPath . "cln2012.cer -out " . $DataPath . "cln2012.pem");
    RunCmd('Make cert PEM format in '.$DataPath, "openssl x509 -inform DER -in " . $DataPath . "srv2012.cer -out " . $DataPath . "srv2012.pem");
    RunCmd('Make cert PEM format in '.$DataPath, "openssl x509 -inform DER -in " . $DataPath . "cln2001.cer -out " . $DataPath . "cln2001.pem");
    RunCmd('Make cert PEM format in '.$DataPath, "openssl x509 -inform DER -in " . $DataPath . "srv2001.cer -out " . $DataPath . "srv2001.pem");
    RunCmd('Make cert PEM format in '.$DataPath, "openssl x509 -inform DER -in " . $DataPath . "cpro-ca.cer -out " . $DataPath . "cpro-ca.pem");
}


__END__
