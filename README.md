# Welcome to pdfHarvester

Do you quest for data sealed within the frozen images of pdf files? Then you seek the the dark magic of pdfHavester. 

New Youtube Tutorial: http://www.youtube.com/watch?v=TaY_WaD7yPI

## The jist of why this package was made

The two most popular existing approaches for transcription of tables is optical character regocintion (OCR) and data entry or loosly, "crowdsourcing". 

Both of the current open source options for these approches have flaws in them that the other can help solve.  OCR is in my opinion, is very confused when trying to recognize table structure, espically when there can be subheadings (which I call double headers).  The best data entry method that I found available (www.crowdcrafting.org) did not have a method to add the processes that I believed would be time efficient for this purpose. I conceide that R might not have been the happiest way to write this whole thing.  This is what I had available to make what I wanted. :)

Quality Control/Qaulity Assurance of converted data is or it should be a big concern.  That is why the project management side of this project provides a few tools to track the progess of the project and the success of different users to make aggreed upon transcriptions.

## Summary of usage

pdfHavester is a framework for using R and other open source tools to capture data within images or pdf documents with images in them.  What's the process of how it works?

1. A project directory is created only containing only pdf files.

2. The files are converted to a high quality and low quality level of image.  One for high resolution computerized transcription and the other for the user to parse table structure graphically.
	
3. Each image is opened and a user must click the top left and bottom right of each table.  Right click to move to the next page. 
	
4. The images are displayed to a user to idenitfy for each table for each page; pixel range and disctinction for rows and columns, and title.
	
5. The images are then broken into individual cell images broken down into table folders. 

6. The transcription process of the project can now be initialized.  All cells are now transcription tasks.

7. Tesseract will provide the initial transcription of the files with optical character reconition.

7. The user wills transcribe a sampling of all the transciption tasks until they each have transcribed each cell in the project.  Their time of transcription, username, and cell value are recorded in a file in the project directory "alltranscriptions.csv".  The number of tasks to do before saving to "alltranscriptions.csv" is a parameter to set before the project or in the function or it will default to five. 

8. The project will regularly check for aggreement of cell values and remove these cells from the project to sample transcriptions from. 

9. When there are no more cells that have been agreed upon, the project can no be exported in a file formats to your desire.  These formats are 

    *A .Rdata file 
    
    *A json file
    
## Installation

1. Install Imagemagick and Tesesract. 
2. Install R packages: png, plyr, stringr, RJSONIO, devtools, and xlsx (not used yet in this version). 
3. Install using devtools and load it in. 
```
library(devtools)
install_github("pdfHarvester", "hansthompson")
library(pdfHarvester)
```

4. thats it. 

## Sample script

```
directory <- "C:/Users/Public/CAFRfiles/hackathon"

convert(directory, "-density 300", "-sharpen 0x1.0", "convert1")

Parse_Tables(directory)

Parse_Cells(directory)

Initialize_Transcription(directory)

Tesseract(directory)

Transcribe(directory)

Update_Project(directory)  ## Repeat regularly to move tasks to done. 

Publish(directory) ## When all files meet the thresholds for accepting values, 
## Publish will export the data into an R object or json formated text file in 
## the project directory. 
```

## Thank You For Reading

It is my small dream that this R package/hack/thing/framework will spawn better iterations of this idea but most importantly, open up new and old datasets that have been inaccessable because matters of time, energy, and quality assurance.

I hope this is freely used but if you want to implement a high-thourghput system for trasncribing pdf tables, please contact me if you want to bring in some consultation to speed up your implementation. 

Hans Thompson
hans.thompson1@gmail.com

## Criticism

I am not an adept coder.  There are some ways I am familiar with that could speed up, simplify, or standardize the way I have written this.  Please suggest issues in github if you want a response from me, improve the code, and want to publicly shame me at the same. Go github. 

Like I mentioned above, OCR and existing options exist for table conversion.  This project is special for controling the level of quality for each transcription task.  Its a way of testing your assumptions of data quality. 
