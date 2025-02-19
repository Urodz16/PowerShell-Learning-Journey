# Basic File Management Automation

# This PowerShell script organizes files in a given directory by moving them
# into subfolders based on their file type.

$path_of_files = $null

Write-Host "`n**Welcome to the Basic File Management Automation script**"
Write-Host "This script will organize whatever directory you choose by `n- Creating an Images folder that will include all .jpg, .jpeg, and .png files"
Write-Host "- Creating a Documents folder that will include all .pdf, .docx, and .txt files"
$path_of_files = Read-Host "`nWhat is the path of the folder you want to organize? (Example: C:\User\Desktop) "
Get-ChildItem -Path $path_of_files

$images_directory_path = "$path_of_files\Images"
$documents_directory_path = "$path_of_files\Documents"

$images_directory = Test-Path "$path_of_files\Images"
if ($images_directory -eq $true) {
    Write-Host "`nImages subdirectory exists."
} else {
    Write-Host "No Images subdirectory exists. `nProceeding to create one...`n`n"
    New-Item -Path $images_directory_path -ItemType Directory
    Write-Host "Images subdirectory successfully created at $path_of_files"
    }

$documents_directory = Test-Path "$path_of_files\Documents"
if ($documents_directory -eq $true) {
    Write-Host "`nDocuments subdirectory exists."
} else {
    Write-Host "No Documents subdirectory exists. `nProceeding to create one...`n`n"
    New-Item -Path $documents_directory_path -ItemType Directory
    Write-Host "Documents subdirectory successfully created at $path_of_files"
    }

Get-ChildItem -Path $path_of_files -Recurse -Include "*.jpg","*.jpeg","*.png" -File | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $images_directory_path -Force
}

Get-ChildItem -Path $path_of_files -Recurse -Include "*.pdf","*.docx","*.txt" -File | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $documents_directory_path -Force
}

$num_images = ( Get-ChildItem -Path $images_directory_path | Measure-Object).Count
$num_documents = ( Get-ChildItem -Path $documents_directory_path | Measure-Object).Count

Write-Host "`n$num_images images (.jpg, .jpeg, .png) were moved from $path_of_files to $images_directory_path."
Write-Host "$num_documents documents were moved from $path_of_files to $documents_directory_path."