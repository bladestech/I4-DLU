@echo off
setlocal enabledelayedexpansion
title I4-DLU (IPv4 DNS Lookup Utility) v1.0
set "common_suffixes=.com .org .net .io .xyz .co .info .biz .us .uk .de .fr .cn .ru .jp"
set "full_suffixes=.ac .academy .accountant .actor .agency .ai .airforce .am .apartments .archi .army .art .asia .associates .at .attorney .auction .audio .baby .band .bar .bargains .be .beer .berlin .best .bet .bid .bike .bingo .bio .biz .black .blackfriday .blog .blue .boston .boutique .br.com .build .builders .business .buzz .buz .ca .cab .cafe .camera .camp .capital .cards .care .careers .casa .cash .casino .catering .cc .center .ceo .ch .charity .chat .cheap .christmas .church .city .claims .cleaning .click .clinic .clothing .cloud .club .cn.com .co .co.com .co.in .co.nz .co.uk .coach .codes .coffee .college .com .com.co .com.mx .com.tw .community .company .computer .condos .construction .consulting .contact .contractors .cooking .cool .coupons .courses .credit .creditcard .cricket .cruises .cymru .cz .dance .date .dating .de .de.com .deals .degree .delivery .democrat .dental .dentist .desi .design .diamonds .diet .digital .direct .directory .discount .doctor .dog .domains .download .earth .eco .education .email .energy .engineer .engineering .enterprises .equipment .estate .eu .eu.com .events .exchange .expert .exposed .express .fail .faith .family .fans .farm .fashion .film .finance .financial .fish .fishing .fit .fitness .flights .florist .flowers .fm .football .forsale .foundation .fun .fund .furniture .futbol .fyi .gallery .games .garden .gay .gift .gifts .gives .glass .global .gmbh .gold .golf .graphics .gratis .green .gripe .group .gs .guide .guitars .guru .haus .healthcare .help .hiphop .hn .hockey .holdings .holiday .horse .host .hosting .house .how .immo .in .industries .info .ink .institute .insure .international .investments .io .irish .it .jetzt .jewelry .jp .jpn.com .juegos .kaufen .kim .kitchen .kiwi .la .land .lawyer .lease .legal .lgbt .li .life .lighting .limited .limo .link .live .llc .loan .loans .lol .london .love .ltd .luxury .maison .management .market .marketing .mba .me .me.uk .media .memorial .men .menu .miami .mobi .moda .moe .money .monster .mortgage .mx .nagoya .navy .net .net.co .network .news .ngo .ninja .nl .nyc .okinawa .one .ong .online .org .org.in .org.uk .partners .parts .party .pet .ph .photo .photography .photos .physio .pics .pictures .pink .pizza .pl .place .plumbing .plus .poker .press .pro .productions .promo .properties .property .pub .qpon .quebec .racing .realty .recipes .red .rehab .reisen .rent .rentals .repair .report .republican .rest .restaurant .review .reviews .rip .rocks .rodeo .run .sa.com .sale .sarl .sc .school .schule .science .se.net .services .sexy .sg .shiksha .shoes .shop .shopping .show .singles .site .ski .soccer .social .software .solar .solutions .soy .space .srl .store .stream .studio .study .style .supplies .supply .support .surf .surgery .systems .tattoo .tax .taxi .team .tech .technology .tel .tennis .theater .tienda .tips .today .tokyo .tools .tours .town .toys .trade .training .tv .tw .uk .uk.com .university .uno .us .us.com .vacations .vc .vegas .ventures .vet .viajes .video .villas .vip .vision .vodka .vote .voting .voyage .watch .webcam .website .wedding .wiki .win .wine .work .works .world .ws .wtf .xyz .yoga .za.com .zone"
color 8F
:main
cls
echo                                           ====================================
echo                                             I4-DLU - IPv4 DNS Lookup Utility
echo                                                       Version: 1.0
echo                                              Copyright  (c) 2025 bladestech
echo                                            Made for the open source community
echo                                           ====================================
echo.
set "url="
set /p "url=Enter domain name or URL: "
if not defined url (
    echo Error: No input provided. Please try again.
    pause
    goto main
)
call :process_input "!url!"
goto :prompt
:prompt
echo.
echo -------------------------------
set "next="
set /p "next=Enter next domain/URL or X to clear: "
if /i "!next!"=="X" (
    cls
    goto main
)
if defined next (
    call :process_input "!next!"
)
goto prompt
:process_input
set "input=%~1"
set "input=!input:http://=!"
set "input=!input:https://=!"
set "common_found=0"
set "full_found=0"
echo !input! | findstr /r "\." >nul
if errorlevel 1 (
    echo.
    echo No domain suffix detected in '!input!'.
    set /p "choice=Would you like to test common suffixes? (Y/N): "
    if /i "!choice!" == "Y" (
        call :test_common "%input%"
        if !common_found! equ 0 (
            set /p "choice2=No IPs found with common suffixes. Try all suffixes? (Y/N): "
            if /i "!choice2!" == "Y" (
                call :test_full "%input%"
            )
        )
    ) else (
        echo Skipping common suffix testing.
        set /p "choice3=Would you like to try all possible suffixes instead? (Y/N): "
        if /i "!choice3!" == "Y" (
            call :test_full "%input%"
        ) else (
            echo No testing performed. Please enter a valid domain.
        )
    )
) else (
    call :resolve "%input%"
)
goto :eof
:resolve
set "current_url=%~1"
echo Resolving %current_url%...
set "ip_list="
for /f "delims=" %%a in ('powershell -command "try { (Resolve-DnsName -Name '%current_url%' -Type A -ErrorAction Stop).IPAddress } catch { 'Resolution Failed' }"') do (
    if "%%a" == "Resolution Failed" (
        set "ip_list=Error"
    ) else (
        set "ip_list=!ip_list!%%a "
    )
)
if defined ip_list (
    if "!ip_list!" == "Error" (
        echo Failed to resolve '%current_url%'.
    ) else if "!ip_list!" == "" (
        echo No IPv4 addresses found for '%current_url%'.
    ) else (
        echo IPv4 Addresses for '%current_url%':
        for %%i in (!ip_list!) do echo - %%i
    )
) else (
    echo No IPs found.
)
echo.
goto :eof
:test_common
set "base=%~1"
set "common_found=0"
set common_results[0]=
echo Testing common suffixes:
for %%s in (%common_suffixes%) do (
    set "test=!base!%%s"
    echo   Testing !test!...
    timeout /t 1 >nul
    call :resolve "!test!" >nul
    if not "!ip_list!" == "Error" (
        set /a common_found=!common_found!+1
        set "common_results[!common_found!]=!test! - !ip_list!"
    )
    set "ip_list="
)
if !common_found! gtr 0 (
    echo.
    echo Results for common suffixes:
    for /l %%i in (1,1,!common_found!) do (
        echo !common_results[%%i]!
    )
) else (
    echo No valid IPs found with common suffixes.
)
goto :eof
:test_full
set "base=%~1"
set "full_found=0"
set full_results[0]=
echo Would you like to enable acceleration? This may violate your ISP's terms or overload your network.
echo You are responsible for any consequences.
choice /C NE /M "Enable acceleration (N/Enable)? "
if errorlevel 2 (
    call :test_full_accelerated "%base%"
) else (
    call :test_full_normal "%base%"
)
echo Full suffix results:
if !full_found! gtr 0 (
    for /l %%i in (1,1,!full_found!) do (
        echo !full_results[%%i]!
    )
) else (
    echo No valid IPs found with all suffixes.
)
echo.
goto :eof
:test_full_normal
set "base=%~1"
set "full_found=0"
set full_results[0]=
for %%s in (%full_suffixes%) do (
    set "test=!base!%%s"
    echo   Testing !test!...
    call :resolve "!test!" >nul
    if not "!ip_list!" == "Error" (
        set /a full_found=!full_found!+1
        set "full_results[!full_found!]=!test! - !ip_list!"
    )
    set "ip_list="
)
goto :eof
:test_full_accelerated
set "base=%~1"
set "full_found=0"
set full_results[0]=
for %%s in (%full_suffixes%) do (
    set "test=!base!%%s"
    echo   Testing !test!...
    call :resolve "!test!" >nul
    if not "!ip_list!" == "Error" (
        set /a full_found=!full_found!+1
        set "full_results[!full_found!]=!test! - !ip_list!"
    )
    set "ip_list="
)
goto :eof