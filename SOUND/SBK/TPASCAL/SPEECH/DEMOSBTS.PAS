program demosbts;

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6,crt;


{ ------------------------------------------------------------------------ }

{ main function }
var
    key : char;

begin

    { check the existence of SBTALKER driver }
    if Boolean(sbts_init)  then begin

       writeln('SBTALKER installed.');
       sbts_say('SB-talker installed.');
       writeln('Press any key to continue ...');
       writeln;
       key := ReadKey;

       { change the volumn }
       sbts_settings(0,0,9,5,5);
       writeln('I can speak louder.');
       sbts_say('I can speak louder.');
       writeln('Press any key to continue ...');
       writeln;
       key := ReadKey;

       { change the pitch }
       sbts_settings(0,0,9,9,5);
       writeln('I can change my pitch.');
       sbts_say('I can change my pitch.');
       writeln('Press any key to continue ...');
       writeln;
       key := ReadKey;

       { change the speed }
       sbts_settings(0,0,9,9,9);
       writeln('I can speak very fast.');
       sbts_say('I can speak very fast.');
    end

    else
       writeln('SBTALKER is not installed.');

end.
