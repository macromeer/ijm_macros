// This macro merges single-frame images into multi-frame images.
// It assumes the input images are 8-bit XYZ stacks named with the pattern "originalname_frameXXX.tif".
// The resulting multi-frame images are stored in a subfolder named 'merged_frames'.

// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);

// Define input and output directories.
inputDir = getDirectory("Select input directory containing single frames");
outputDir = inputDir + File.separator + "merged_frames" + File.separator;
File.makeDirectory(outputDir);

// Get a list of all files in the input directory
list = getFileList(inputDir);

// Sort the list to ensure frames are in order
Array.sort(list);

// Initialize variables
previousBaseName = "";
frameCount = 0;
firstFrame = "";

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) {
        // Extract the base name (original name without frame number)
        baseName = substring(list[i], 0, lastIndexOf(list[i], "_frame"));
        
        if (baseName != previousBaseName && previousBaseName != "") {
            // We've reached a new set of frames, so merge the previous set
            mergeFrames(previousBaseName, frameCount, firstFrame);
            frameCount = 0;
        }
        
        if (frameCount == 0) {
            firstFrame = list[i];
        }
        
        frameCount++;
        previousBaseName = baseName;
    }
}

// Merge the last set of frames
if (frameCount > 0) {
    mergeFrames(previousBaseName, frameCount, firstFrame);
}

setBatchMode(false);

function mergeFrames(baseName, frameCount, firstFrame) {
    // Open the first frame to get dimensions
    filePath = inputDir + firstFrame;
    if (!File.exists(filePath)) {
        print("Error: File not found - " + filePath);
        return;
    }
    open(filePath);
    if (nImages == 0) {
        print("Error: Failed to open image - " + filePath);
        return;
    }
    getDimensions(width, height, channels, slices, frames);
    close();
    
    // Create a new stack with the correct number of frames
    newImage(baseName + "_merged", "8-bit", width, height, channels, slices, frameCount);
    
    // Add each frame to the new stack
    for (f = 1; f <= frameCount; f++) {
        frameName = baseName + "_frame" + IJ.pad(f, 3) + ".tif";
        filePath = inputDir + frameName;
        if (!File.exists(filePath)) {
            print("Error: File not found - " + filePath);
            continue;
        }
        open(filePath);
        if (nImages == 0) {
            print("Error: Failed to open image - " + filePath);
            continue;
        }
        run("Copy");
        close();
        
        selectImage(baseName + "_merged");
        Stack.setFrame(f);
        run("Paste");
    }
    
    // Save the merged stack
    saveAs("Tiff", outputDir + baseName + "_merged.tif");
    close();
}
