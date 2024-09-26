// Prompt user for the parent directory and number of channels
parentDir = getDirectory("Choose the parent directory");
numChannels = getNumber("Enter the number of channels", 3);

// Get the list of subfolders
subfolders = getFileList(parentDir);
countSubfolders = 0;

// Count the number of subfolders
for (i = 0; i < subfolders.length; i++) {
    if (File.isDirectory(parentDir + subfolders[i])) {
        countSubfolders++;
    }
}

// Check if the number of subfolders matches the number of channels
if (countSubfolders != numChannels) {
    exit("The number of subfolders does not match the number of channels.");
}

// Start batch mode
setBatchMode(true);

// Loop through each file in the first channel folder
files = getFileList(parentDir + subfolders[0]);
for (i = 0; i < files.length; i++) {
    if (endsWith(files[i], ".tif")) {
        imageTitle = replace(files[i], "C1-", "");
        imagePaths = newArray(numChannels);
        imageTitles = newArray(numChannels);

        // Open each channel image
        for (j = 0; j < numChannels; j++) {
            imagePaths[j] = parentDir + subfolders[j] + "/" + "C" + (j+1) + "-" + imageTitle;
            open(imagePaths[j]);
            imageTitles[j] = getTitle();
        }

        // Merge the channels with specific color assignments
        run("Merge Channels...", "c1=[" + imageTitles[0] + "] c2=[" + imageTitles[1] + "] c3=[" + imageTitles[2] + "] create");

        // Convert to RGB
       // run("RGB Color");

        // Save the merged RGB image
        saveAs("Tiff", parentDir + "Merged-" + imageTitle);

        // Close all opened images
        close("*");
    }
}

// End batch mode
setBatchMode(false);
