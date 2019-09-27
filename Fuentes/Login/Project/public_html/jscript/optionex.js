var NS4 = (document.layers)?true:false;
var IE4 = (document.all)?true:false;
	
function _struct(child,childcaption,parent){
this.child = child;
this.childcaption = childcaption;
this.parent	= parent;
}
function _addobject(child,childcaption,parent){
var obj = new _struct();
obj.child = child;
obj.childcaption = childcaption;
obj.parent = parent;
return(obj);
}
function insertEntry(child,childcaption,parent){
	if(child.length > 0 ){		
		for(var i=0;i<this.length;i++)
			if(this.items[i].child == child)
				return;			
		this.items[this.length++] = _addobject(child,childcaption,parent);		
	}
}
function OptionCollection(){
this.length=0;
this.items = new Object();
this.Add=insertEntry
}

function clearSelect(oSelect){
var iCount=0;
if(!oSelect) return;
iCount = oSelect.options.length;
for(var i=0;i<iCount;i++){
	if(IE4)
		oSelect.options.remove(0);
	else if(NS4)
		oSelect.options[0]=null;
}
}
function addOptions(oSelect,olist,parent){
	var elOption;
	var idxSelect=0;	

	//check arguments.
	if((!olist) || (!oSelect))return;		
	if(parent.length <=	0) 	return;
					
	//now looop through all the list items only entering relevant options.
	clearSelect(oSelect);	
	
	//add a blank list
	elBlankOption = new Option();
	elBlankOption.text = "";
	if(NS4) oSelect.options[0] = elBlankOption
	else if(IE4) oSelect.options.add(elBlankOption,0)
	
	elBlankOption.value = "";
	for(var i=0;i<olist.length;i++){		
		//only the child entries of the parent				
		if(olist.items[i].parent == parent){									
			elOption = new Option();
			//now IE and NS have a different way to handle object creation.
			if(NS4){						
				elOption.value = olist.items[i].child
				elOption.text = olist.items[i].childcaption
				oSelect.options[idxSelect] = elOption				
			}else if(IE4){				
				elOption.value = olist.items[i].child
				elOption.text = olist.items[i].childcaption
				oSelect.options.add(elOption,idxSelect)					
			}						
			idxSelect++;
			delete(elOption);
		}			
	}	
}

function clearOptions(szSelect,szForm){
if(szSelect.length <= 0 || szForm.length <=0)
	alert("error:clearOption must pass arguments");	
if(IE4)
clearSelect(document.all.item(szSelect));
else if(NS4)
clearSelect(eval('document.' + szForm + '.' + szSelect));
}

function listAllOptions(szSelect,szForm,olist){
	var elOption;
	var idxSelect=0;
	var oSelect = new Object();
			
	//check arguments.
	if(!olist)return;			
	
	if(IE4)
		 oSelect = document.all.item(szSelect);
	else if(NS4)
		oSelect = eval('document.' + szForm + '.' + szSelect);
	
	if(!oSelect)return;			
						
	//now looop through all the list items entering all
	clearSelect(oSelect);
	for(var i=0;i<olist.length;i++){							
		elOption = new Option();
		//now IE and NS have a different way to handle object creation.
		if(NS4){						
			elOption.value = olist.items[i].child
			elOption.text = olist.items[i].childcaption
			oSelect.options[idxSelect] = elOption				
		}else if(IE4){				
			elOption.value = olist.items[i].child
			elOption.text = olist.items[i].childcaption
			oSelect.options.add(elOption,idxSelect)					
		}						
		idxSelect++;
		delete(elOption);					
	}	
}

function UpdateSelect(szSelect,szForm,szParent,olist){
if(IE4)
addOptions(document.all.item(szSelect),olist,szParent);
else if(NS4)
addOptions(eval('document.' + szForm + '.' + szSelect),olist,szParent);
}