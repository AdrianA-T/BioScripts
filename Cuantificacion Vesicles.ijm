Nom="DIG";
Num=3;
Imin=106;
Imax=255;
Rx=422;
Ry=134;
Amin=10;
Amax=200;

canal=2;


guardar=getDirectory("Elige un directorio para guardar las imagenes");
run("Set Measurements...", "area standard area_fraction display redirect=None decimal=3");
VA="size="+Amin+"-"+Amax+" pixel summarize";
//results_merge1="";

//run("ROI Manager...");

for (i=1; i<=Num; i++) {
	
	rename(Nom+"Disco"+i);
	getDimensions(width, height, channels, slices, frames);
	
	if (channels>1) {
	   	
		Stack.setPosition(canal, 1, 1);
	} 
	else {
		Stack.setPosition(1, 1, 1);
	}
	//run("Specify...");
	makeRectangle(286, 620, Rx, Ry);
	title1 = "Estudio del número de vesículas en una región";
	msg1 = "Una vez selecionada una region pusa t para guardarla, cuando tengas guardadas la región a estudiar haz clic en \"OK\".";
	waitForUser(title1, msg1);
	roiManager("Add");

	nombre= getTitle();
	
	selectWindow(nombre);
	getDimensions(width, height, channels, slices, frames);
	
	if (channels>1) {
		run("Split Channels");
		selectWindow("C"+canal+"-"+nombre);
	}
	else {
		selectWindow(nombre);
	}
	
	setAutoThreshold("Default dark");
	setThreshold(Imin, Imax);	
	setOption("BlackBackground", true);
	run("Convert to Mask");

	roiManager("select", 0);
	roiManager("Rename", "R1");
	run("Analyze Particles...", VA);
	
	//		String.copyResults; 
	//        resultati1=String.paste;
	//        c = nombre+",Plano:  "+resultati1;
	//        results_merge1=results_merge1+c;
	//        selectWindow("Summary");
	//		run("Close");
	//        print(results_merge1);
	
	roiManager("Delete");
	roiManager("Delete");

	selectWindow("Summary");
	saveAs("Results", guardar+Nom+".xls");
	
	if (channels>1) {
		run("Split Channels");
		selectWindow("C"+canal+"-"+nombre);
	} 
	else {
		selectWindow(nombre);
	}
	close();
			
	
	if (i<Num) {
		title1 = "Estudio de intensidades por áreas";
		msg1 = "Carga un nuevo disco en Fiji y haz clic en \"OK\".";
		waitForUser(title1, msg1);
	} 

}
selectWindow("Summary");
saveAs("Results", guardar+Nom+".xls");
//close("Summary");





