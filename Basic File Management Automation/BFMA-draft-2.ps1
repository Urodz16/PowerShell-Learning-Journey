# Basic File Management Automation

# This PowerShell script organizes files in a given directory by moving them
# into subfolders based on their file type.

# Create the path_of_file variable
$path_of_files = $null

function Show-DirectoryTree {
    param (
        [string]$path,
        [int]$indentation = 0
    )
    $indent = " " * $indentation
    $items = Get-ChildItem -Path $path

    foreach ($item in $items) {
        Write-Host "$indent$item"
        if ($item.PSIsContainer) {
            Show-DirectoryTree -path $item.FullName -indentation ($indentation + 4)
            Write-Host ""
        }
    }
}

# Welcome to the User and explains what script does
Write-Host "`n**Welcome to the Basic File Management Automation script**"
Write-Host "This script will organize whatever directory you choose by `n- Creating an Images folder that will include all .jpg, .jpeg, and .png files"
Write-Host "- Creating a Documents folder that will include all .pdf, .docx, and .txt files"

# Asks for directory that will be organized
$path_of_files = Read-Host "`nWhat is the path of the folder you want to organize? (Example: C:\User\Desktop) "
# Verifies input / ends script if input is invalid
if (-not (Test-Path $path_of_files)) {
    Write-Host "Error: The specified directory does not exist. Exiting script."
    exit
}

# Displays all files in the given path
Get-ChildItem -Path $path_of_files -File -ErrorAction SilentlyContinue

# Creates variables for new folder paths
$images_directory_path = Join-Path $path_of_files "Images"
$documents_directory_path = Join-Path $path_of_files "Documents"

# Test for image folder
$images_directory = Test-Path $images_directory_path
if ($images_directory -eq $true) {
    Write-Host "`nImages subdirectory already exists."
    Write-Host "Moving files to $images_directory_path now."
} else {
    Write-Host "No Images subdirectory exists. `nProceeding to create one...`n"
    New-Item -Path $images_directory_path -ItemType Directory
    Write-Host "Images subdirectory successfully created at $path_of_files"
    Write-Host "Moving files to $images_directory_path now."
    }

# Test for documents folder
$documents_directory = Test-Path $documents_directory_path
if ($documents_directory -eq $true) {
    Write-Host "`nDocuments subdirectory already exists."
    Write-Host "Moving files to $documents_directory_path now."
} else {
    Write-Host "No Documents subdirectory exists. `nProceeding to create one...`n"
    New-Item -Path $documents_directory_path -ItemType Directory
    Write-Host "Documents subdirectory successfully created at $path_of_files"
    Write-Host "Moving files to $documents_directory_path now."
    }

# Counts existing files in destination folders before moving
$initial_num_images = (Get-ChildItem -Path $images_directory_path -File | Measure-Object).Count
$initial_num_documents = (Get-ChildItem -Path $documents_directory_path -File | Measure-Object).Count

# Gets all files that end in Image type and moves to Image folder
Get-ChildItem -Path $path_of_files -Recurse -Include "*.jpg","*.jpeg","*.png" -File | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $images_directory_path -Force
}

# Gets all files that end in Document type and moves to Documents folder
Get-ChildItem -Path $path_of_files -Recurse -Include "*.pdf","*.docx","*.txt" -File | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $documents_directory_path -Force
}

# Counts after moving files
$final_num_images = ( Get-ChildItem -Path $images_directory_path | Measure-Object).Count
$final_num_documents = ( Get-ChildItem -Path $documents_directory_path | Measure-Object).Count

# Calculates number of files moved
$num_images_moved = $final_num_images - $initial_num_images
$num_documents_moved = $final_num_documents - $initial_num_documents

Write-Host "`nSummary:"
Write-Host "`n$num_images_moved images (.jpg, .jpeg, .png) were moved from $path_of_files to $images_directory_path."
Write-Host "$num_documents_moved documents were moved from $path_of_files to $documents_directory_path."

# Display directory tree (Need to invoke via cmd.exe)
Write-Host "`nUpdated Folder Structure:"
Show-DirectoryTree -path $path_of_files