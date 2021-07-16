function checkAll(){
	var hasCheck = 0;
	var ck =  document.getElementsByName("show_column");
	for(var i=0;i<ck.length;i++){
		if(ck[i].checked==true){
			hasCheck += 1;
		}
	}
	return hasCheck;
}

function changeShowOP()
{
	document.total_inform.showop.value="";
	var ck =  document.getElementsByName("show_column");
	if (checkAll()==0){
		alert("Please check at least one attribute data!");
	}
	else{
		for(var i=0;i<ck.length;i++){
			if(ck[i].checked==true){
				document.total_inform.showop.value+=i+","
			}
		}
	}
	document.total_inform.submit(); 
}

function changePageNum(page_num)
{
	document.total_inform.shownum.value=page_num;		
	changeShowOP(); 
}

function changeYear(Year1,Year2)
{
	document.total_inform.YEAR1.value=Year1;
	document.total_inform.YEAR2.value=Year2;
	changeShowOP(); 
}


function changeShowPage(page_no)
{
	document.total_inform.now_page.value=page_no;
	changeShowOP(); 
}

function changeProteinName(protein_na)
{
	document.total_inform.protein_name.value=protein_na;
	document.total_inform.now_page.value=1;
	changeShowOP(); 
}

function changeJournalName(journal_na)
{
	document.total_inform.Journal.value=journal_na;
	document.total_inform.now_page.value=1;
	changeShowOP(); 
}


function changeSort(column,method)
{
	if(method==1)
		document.total_inform.ordsort.value=column+",2";
	else
		document.total_inform.ordsort.value=column+",1";
	
	changeShowOP(); 
}