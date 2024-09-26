// This macro splits multi-frame images into single-frame images.
// The resulting single-frame images are stored in a subfolder named 'single_frames'.
// It checks if the input images are in TIFF format and uses the Bio-Formats Importer plugin to open them.
// It also assumes that there are no other TIFF files in the input directory, besides the ones containing the multi-frame images to be split.

// Set batch mode to true to speed up the macro by disabling the display of images during processing.
setBatchMode(true);

// Define input and output directories. 
inputDir = getDirectory("Select input directory");
File.setDefaultDir(inputDir); // this is needed when the macro file is located elsewhere
outputDir = inputDir + File.separator + "single_frames" + File.separator;
File.makeDirectory(outputDir);

// Get a list of all files in the input directory
list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
   if (endsWith(list[i], ".tif")) {
      filePath = inputDir + list[i];
      run("Bio-Formats Importer", "open=[" + filePath + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
      
      // Get some info about the image
      getDimensions(width, height, channels, slices, frames);
      
      if (frames > 1) {
         // Split the image into individual frames
         for (f = 1; f <= frames; f++) {
            Stack.setFrame(f);
            run("Duplicate...", "duplicate frames=" + f);
            frameName = File.nameWithoutExtension + "_frame" + IJ.pad(f, 3) + ".tif";
            saveAs("Tiff", outputDir + frameName);
            close();
         }
      } else {
         // If there's only one frame, just save it as is
         frameName = File.nameWithoutExtension + "_frame001.tif";
         saveAs("Tiff", outputDir + frameName);
      }
      
      // Close the original image to free up memory (even in batch mode).
      close("*"); 
   }
}

setBatchMode(false);
