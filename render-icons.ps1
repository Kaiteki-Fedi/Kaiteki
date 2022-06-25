# Check for inkscape
If (-Not (Get-Command "inkscape" -ErrorAction SilentlyContinue)) {
    Throw "Couldn't find inkscape"
}

Write-Output "Exporting web favicon"
inkscape --export-filename "src/kaiteki/web/favicon.png" --export-type="png" "assets/icons/windows/kaiteki-small.svg" >$null

Write-Output "Exporting web PWA icons"
inkscape --export-filename "src/kaiteki/web/icons/Icon-192.png" --export-type="png" -w 192 -h 192 "assets/icons/windows/kaiteki-small.svg" >$null
inkscape --export-filename "src/kaiteki/web/icons/Icon-512.png" --export-type="png" -w 512 -h 512 "assets/icons/windows/kaiteki-small.svg" >$null

Write-Output "Exporting macOS icons"
Foreach ($size in 16,32,64,128,256,512,1024) {
    inkscape --export-filename "src/kaiteki/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_$size.png" --export-type="png" -w $size -h $size "assets/icons/windows/kaiteki-small.svg" >$null
}

Write-Output ""
Write-Output "Please note that Android icons cannot be rendered over a script. Use Android Studio to generate Android icons."