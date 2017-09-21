use strict;
use Scripts;

my $engine;

print "\n\n--------MAKE DEFAULT CERTS--------\n";
print "----------------------------------\n\n";

print "sudo perl make_default_certs.pl:\n\n";
system("sudo perl make_default_certs.pl");

sleep(1);

print "\n\n--------START STUNNEL-------------\n";
print "----------------------------------\n\n";

if (scalar @ARGV && $ARGV[0] eq 'gost_capi') {
    $engine = 'gost_capi';
} 
elsif ($ARGV[0] eq 'gostengy') {
    $engine = 'gostengy'; 
}

print "sudo perl stunnel.pl local " . $engine ." :\n\n";
system("sudo perl stunnel.pl local " . $engine);

sleep(1);

print "\n\n--------START CLIENT--------------\n";
print "----------------------------------\n\n";

print "sudo perl stunnel_client.pl local > client_log &:\n\n";
system("sudo perl stunnel_client.pl local > client_log &");

sleep(1);

print "\n\n--------START SERVER--------------\n";
print "----------------------------------\n\n";

print "sudo perl stunnel_server.pl:\n\n";
system("sudo perl stunnel_server.pl");
exit 1 if ($? != 0);

sleep(3);

print "\n\n--------CLIENT LOG----------------\n";
print "----------------------------------\n\n";

print "cat client_log:\n\n";
system("cat client_log");

print "\n\n--------CLIENT STUNNEL LOG--------\n";
print "----------------------------------\n\n";

print "cat /var/opt/cprocsp/tmp/stunnel_cli.log:\n\n";
system("cat /var/opt/cprocsp/tmp/stunnel_cli.log");

print "\n\n--------SERVER STUNNEL LOG--------\n";
print "----------------------------------\n\n";

print "cat /var/opt/cprocsp/tmp/stunnel_serv.log:\n\n";
system("cat /var/opt/cprocsp/tmp/stunnel_serv.log");
