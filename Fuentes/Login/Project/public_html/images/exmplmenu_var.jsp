



//   INICIO-------------------------------------------------------



  
	var NoOffFirstLineMenus=2;    // Number of first level items
  
	var LowBgColor='#53709C';			// Background color when mouse is not over
	var LowSubBgColor='#6B9AC5';			// Background color when mouse is not over on subs
	var HighBgColor='#53709C';			// Background color when mouse is over
	var HighSubBgColor='#53709C';			// Background color when mouse is over on subs
	var FontLowColor='white';			// Font color when mouse is not over
	var FontSubLowColor='white';			// Font color subs when mouse is not over
	var FontHighColor='white';			// Font color when mouse is over
	var FontSubHighColor='white';			// Font color subs when mouse is over
	var BorderColor='53709C';			// Border color
	var BorderSubColor='53709C';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=1;			// Border between elements 1 or 0
	var FontFamily="Verdana"	// Font family menu items
	var FontSize=7;				// Font size menu items
	var FontBold=1;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='left';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=.2;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=.2;			// vertical overlap child/ parent
	var StartTop=88;				// Menu offset x coordinate
	var StartLeft=1;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=3;				// Left padding
	var TopPaddng=2;				// Top padding
	var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;			// delay before menu folds in
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='';				// span id for relative positioning
	var HideTop=0;				// Hide first level when loading new document 1 or 0
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
	var ShowArrow=1;				// Uses arrow gifs when 1
	var KeepHilite=1;				// Keep selected path highligthed
	var Arrws=['tri.gif',5,10,'tridown.gif',10,5,'trileft.gif',5,10];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"



      
        Menu1=new Array("Operaciones","#","",1,20,138);
//<BR>

      
      
        Menu2=new Array("Consultas","#","",1,20,138);
//<BR>

      

//[SP]<BR>

    
          Menu1_1=new Array("Solicitud de Vehículos","","",5,20,138);

        
    
    
    
    

//[SP]<BR>

    
          Menu1_1_1=new Array("Registrar Certificado","../Solicitud/registrarSolicitud.jsp?sFormaSolicitud=1","",0,20,138);

      
    
    
    
    

//[SP]<BR>

    
          Menu1_1_2=new Array("Incluir Certificado","../Solicitud/ingresaPoliza.jsp?sFormaSolicitud=2","",0,20,138);

      
    
    
    
    

//[SP]<BR>

    
          Menu1_1_3=new Array("Excluir Certificado","../Solicitud/ingresaPoliza.jsp?sFormaSolicitud=3","",0,20,138);

      
    
    
    
    

//[SP]<BR>

    
          Menu1_1_4=new Array("Modificar Certificado","../Solicitud/ingresaPoliza.jsp?sFormaSolicitud=4","",0,20,138);

      
    
    
    
    

//[SP]<BR>

    
          Menu1_1_5=new Array("Renovar Certificado","../Solicitud/ingresaPoliza.jsp?sFormaSolicitud=5","",0,20,138);

      
    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CV]<BR>

    
    
    
    

//[CO]<BR>

    
    
          Menu2_1=new Array("Solicitudes por estado","../Solicitud/consultaSolicitud.jsp","",0,20,138);

        
    
    
    

//   MODULO_ID, DESCRIPCION, URL, NIVEL, TIPO, ORDEN
//   FIN-------------------------------------------------------


