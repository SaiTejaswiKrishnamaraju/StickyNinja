path %PATH%;C:\Program Files (x86)\GnuWin32\bin
openssl genrsa -out -passout pass:YOURPASSWORD mykey.key 2048
openssl req -new -key mykey.key ^
-out CERTIFICATESIGNINGREQUESTFILENAME.certSigningRequest ^
-subj “/emailAddress=YOUREMAIL@example.com, CN=YOUR NAME, C=US”
pause