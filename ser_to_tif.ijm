// Macro to read the resolution of images and save it as a CSV file
dir = getDirectory("Choose a directory that contains images");
list = getFileList(dir);
setBatchMode(true);
result = "File, Unit, Pixel Width, Pixel Height\n"; // Header for the CSV file
for (i = 0; i < list.length; i++) {
    if(endsWith(list[i], ".ser")) {
        run("TIA Reader", ".ser-reader...="+dir + list[i]);
        title = getTitle();
        getPixelSize(unit, pixelWidth, pixelHeight);
        result += title + "," + unit + "," + pixelWidth + "," + pixelHeight + "\n"; // Append image details to the result
        saveAs("Tiff", dir + File.nameWithoutExtension + ".tif");
        close();
    }
}
File.saveString(result, dir + "image_resolution.csv");
setBatchMode(false);
