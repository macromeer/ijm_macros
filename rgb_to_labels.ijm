// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);

// Ask the user to select the input directory
inputDir = getDirectory("Choose Input Directory");

// Create the output directory and subfolders in the same location as the input
outputDir = inputDir + "masks/";
File.makeDirectory(outputDir);
File.makeDirectory(outputDir + "0/");
File.makeDirectory(outputDir + "1/");
File.makeDirectory(outputDir + "2/");

// Get a list of files in the input directory
fileList = getFileList(inputDir);

// Loop through each file
for (i = 0; i < fileList.length; i++) {
	
	if (endsWith(fileList[i], ".tif")) {
    	// Open the current file
    	open(inputDir + fileList[i]);
    
    	// Split the channels
    	run("Split Channels");
    
    	// Save the channels in separate folders with the same name as the original file
    	selectWindow(fileList[i] + " (red)");
    	saveAs("Tiff", outputDir + "0/" + fileList[i]);
    	selectWindow(fileList[i] + " (green)");
    	saveAs("Tiff", outputDir + "1/" + fileList[i]);
    	selectWindow(fileList[i] + " (blue)");
    	saveAs("Tiff", outputDir + "2/" + fileList[i]);
    
    	// Close all open images
    	run("Close All");
	}
}
setBatchMode(false);
print("Batch processing complete!");
