<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.mysql.jdbc.Driver"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="Style/nouislider.css">
<link rel="stylesheet" type="text/css" href="Style/Unite.css"
	media="screen" />
<link
	href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css"
	rel="stylesheet">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/14.0.1/nouislider.min.js"></script>

<script src="Edit_input.js"></script>
<script src="Page_change.js"></script>

<script src="https://d3js.org/d3.v3.min.js"></script>
<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://code.jquery.com/ui/1.10.2/jquery-ui.min.js"></script>

<%
//Init
//DB
String driverName = "com.mysql.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/phivalue?serverTimezone=UTC";
String Account = "root";
String Password = "root";
//Item
String[] ob = {"DB ID", "Protein", "PDB ID", "Protein Sequence", "Mutant", "Phi Value Name", "Phi Value",
		"Phi Value SD", "Phi value remarks", "Temperature(K)", "Denaturant", "Environment", "pH", "Title", "Journal",
		"Author", "PubMed ID", "Year"};
String sortdataop[] = {"DB_ID", "protein_name", "PDB_ID", "Seq", "before", "phi_value_type", "phi_value", "SD",
		"phi_value_remarks", "temperature_K", "denaturant", "environment", "pH", "Title", "ShortDetails", "Description",
		"EntrezUID", "Year"};
String sortop[] = {"DB_ID", "protein_name", "PDB_ID", " ", "before", " ", "phi_value", "SD", " ", "temperature_K",
		"denaturant", " ", "pH", "Title", "ShortDetails", "Description", "EntrezUID", "Year"};
String Condition_Sql = "", SqlCommand = "";
//Condition
String Absreach = "", pdb_code = "", protein_name = "", MUTA1 = "", MUTA2 = "", PHIV1_s = "", PHIV2_s = "",
		TEMP1_s = "", TEMP2_s = "", DENA = "", Buffer = "", PH1_s = "", PH2_s = "", AUTHOR = "", YEAR1_s = "",
		YEAR2_s = "", Journal = "- All Journal -";
Double PHIV1 = -2.0, PHIV2 = -2.0, TEMP1 = -2.0, TEMP2 = -2.0, PH1 = -2.0, PH2 = -2.0;
Integer YEAR1 = 1992, YEAR2 = 2020;
//Show condition
String[] column = null, Sort = null;
int now_page = 1, total_page = 0, show_num = 10;
String queue = "", resi_sort = "", resi_column = "";
%>

<%
//Get Previously Data
if (request.getParameter("ABR") != null) {
	if (!request.getParameter("ABR").equals("")) {
		Absreach = request.getParameter("ABR");
		Absreach = new String(Absreach.getBytes("iso-8859-1"), "UTF-8");
	}
}
if (request.getParameter("showop") != null) {
	if (!request.getParameter("showop").equals("")) {
		resi_column = request.getParameter("showop");
		resi_column = new String(resi_column.getBytes("iso-8859-1"), "UTF-8");
		column = resi_column.split(",");
	}
	if (request.getParameter("shownum") != null)
		show_num = Integer.valueOf(request.getParameter("shownum"));
	if (request.getParameter("now_page") != null)
		now_page = Integer.valueOf(request.getParameter("now_page"));
	if (!request.getParameter("ordsort").equals("")) {
		resi_sort = request.getParameter("ordsort");
		resi_sort = new String(resi_sort.getBytes("iso-8859-1"), "UTF-8");
		Sort = resi_sort.split(",");
	}
}
if (request.getParameter("protein_name") != null) {
	if (!request.getParameter("protein_name").equals("")) {
		protein_name = request.getParameter("protein_name");
		protein_name = new String(protein_name.getBytes("iso-8859-1"), "UTF-8").trim();
	}
}

if (request.getParameter("MUTA1") != null) {
	if (!request.getParameter("MUTA1").equals("") && !request.getParameter("MUTA2").equals("")) {
		MUTA1 = request.getParameter("MUTA1");
		MUTA1 = new String(MUTA1.getBytes("iso-8859-1"), "UTF-8");
		MUTA2 = request.getParameter("MUTA2");
		MUTA2 = new String(MUTA2.getBytes("iso-8859-1"), "UTF-8");
	}
}

if (request.getParameter("PHIV1") != null) {
	if (!request.getParameter("PHIV1").equals("") && !request.getParameter("PHIV2").equals("")) {
		PHIV1_s = request.getParameter("PHIV1");
		PHIV1_s = new String(PHIV1_s.getBytes("iso-8859-1"), "UTF-8");
		PHIV2_s = request.getParameter("PHIV2");
		PHIV2_s = new String(PHIV2_s.getBytes("iso-8859-1"), "UTF-8");
		PHIV1 = Double.valueOf(PHIV1_s).doubleValue();
		PHIV2 = Double.valueOf(PHIV2_s).doubleValue();
	}
}
if (request.getParameter("pdb_code") != null) {
	if (!request.getParameter("pdb_code").equals("")) {
		pdb_code = request.getParameter("pdb_code");
		pdb_code = new String(pdb_code.getBytes("iso-8859-1"), "UTF-8");
	}
	if (!request.getParameter("TEMP1").equals("") && !request.getParameter("TEMP2").equals("")) {
		TEMP1_s = request.getParameter("TEMP1");
		TEMP1_s = new String(TEMP1_s.getBytes("iso-8859-1"), "UTF-8");
		TEMP2_s = request.getParameter("TEMP2");
		TEMP2_s = new String(TEMP2_s.getBytes("iso-8859-1"), "UTF-8");
		TEMP1 = Double.valueOf(TEMP1_s).doubleValue();
		TEMP2 = Double.valueOf(TEMP2_s).doubleValue();
	}
	if (!request.getParameter("DENA").equals("")) {
		DENA = request.getParameter("DENA");
		DENA = new String(DENA.getBytes("iso-8859-1"), "UTF-8");
	}
	if (!request.getParameter("Buffer").equals("")) {
		Buffer = request.getParameter("Buffer");
		Buffer = new String(Buffer.getBytes("iso-8859-1"), "UTF-8");
	}
	if (!request.getParameter("PH1").equals("") && !request.getParameter("PH2").equals("")) {
		PH1_s = request.getParameter("PH1");
		PH1_s = new String(PH1_s.getBytes("iso-8859-1"), "UTF-8");
		PH2_s = request.getParameter("PH2");
		PH2_s = new String(PH2_s.getBytes("iso-8859-1"), "UTF-8");
		PH1 = Double.valueOf(PH1_s).doubleValue();
		PH2 = Double.valueOf(PH2_s).doubleValue();
	}
	if (!request.getParameter("AUTHOR").equals("")) {
		AUTHOR = request.getParameter("AUTHOR");
		AUTHOR = new String(AUTHOR.getBytes("iso-8859-1"), "UTF-8");
	}
	if (!request.getParameter("YEAR1").equals("") && !request.getParameter("YEAR2").equals("")) {
		YEAR1_s = request.getParameter("YEAR1");
		YEAR1_s = new String(YEAR1_s.getBytes("iso-8859-1"), "UTF-8");
		YEAR2_s = request.getParameter("YEAR2");
		YEAR2_s = new String(YEAR2_s.getBytes("iso-8859-1"), "UTF-8");
		YEAR1 = Integer.valueOf(YEAR1_s).intValue();
		YEAR2 = Integer.valueOf(YEAR2_s).intValue();
		if (YEAR1 < 1992)
	YEAR1 = 1992;
		else if (YEAR1 > 2020)
	YEAR1 = 2019;
		YEAR2 = Integer.valueOf(YEAR2_s).intValue();
		if (YEAR2 < 1992)
	YEAR2 = 1993;
		else if (YEAR2 > 2020)
	YEAR2 = 2020;
		if (YEAR1 > YEAR2) {
	int temp;
	temp = YEAR1;
	YEAR2 = YEAR1;
	YEAR1 = temp;
		}
	}
	if (request.getParameter("Journal") != null) {
		Journal = request.getParameter("Journal");
		Journal = new String(Journal.getBytes("iso-8859-1"), "UTF-8");
	}
}
%>

<%
//SQL COMMAND
if (!Absreach.equals("")) {
	String[] Abdata = null;
	Abdata = Absreach.split(" |-|\t|\n|_");
	if (Abdata != null) {
		if (Abdata.length >= 1) {
	Condition_Sql += " WHERE ((mutant1.Abstract REGEXP '" + Abdata[0]
			+ "[ -]') OR (mutant1.Abstract REGEXP '[ -]" + Abdata[0] + "'))";
	for (int i = 1; i < Abdata.length; i++) {
		Condition_Sql += "OR ((mutant1.Abstract REGEXP '" + Abdata[i]
				+ "[ -]') OR (mutant1.Abstract REGEXP '[ -]" + Abdata[i] + "'))";
	}
		}
	}
}
if (!pdb_code.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND mutant1.PDB_ID LIKE '%" + pdb_code + "%'";
	else
		Condition_Sql += " WHERE mutant1.PDB_ID LIKE '%" + pdb_code + "%'";
}
if (!protein_name.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND mutant1.protein_name LIKE '%" + protein_name + "%'";
	else
		Condition_Sql += " WHERE mutant1.protein_name LIKE '%" + protein_name + "%'";
}
if (!MUTA1.equals("") && !MUTA2.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND (mutant1.before LIKE '%" + MUTA1 + "%' AND mutant1.after LIKE '%" + MUTA2 + "%')";
	else
		Condition_Sql += " WHERE (mutant1.before LIKE '%" + MUTA1 + "%' AND mutant1.after LIKE '%" + MUTA2 + "%')";
}
if (PHIV1 != -2.0 && PHIV2 != -2.0) {
	String phiv_sql = "";

	if (PHIV1 == -3.0) {
		phiv_sql = "(mutant1.phi_value <=" + PHIV2 + ")";
		PHIV1 = -2.0;
	} else if (PHIV2 == -3.0) {
		phiv_sql = "(mutant1.phi_value >=" + PHIV1 + ")";
		PHIV2 = -2.0;
	} else
		phiv_sql = " (mutant1.phi_value >=" + PHIV1 + " AND mutant1.phi_value<=" + PHIV2 + ")";
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND " + phiv_sql;
	else
		Condition_Sql += " WHERE " + phiv_sql;
}
if (TEMP1 != -2.0 && TEMP2 != -2.0) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND (mutant1.temperature_K >=" + TEMP1 + " AND mutant1.temperature_K<=" + TEMP2 + ")";
	else
		Condition_Sql += " WHERE (mutant1.temperature_K >=" + TEMP1 + " AND mutant1.temperature_K<=" + TEMP2 + ")";
}
if (!DENA.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND mutant1.denaturant LIKE '%" + DENA + "%'";
	else
		Condition_Sql += " WHERE mutant1.denaturant LIKE '%" + DENA + "%'";
}
if (!Buffer.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND mutant1.environment LIKE '%" + Buffer + "%'";
	else
		Condition_Sql += " WHERE mutant1.environment LIKE '%" + Buffer + "%'";
}
if (PH1 != -2.0 && PH2 != -2.0) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND (mutant1.pH >=" + PH1 + " AND mutant1.pH<=" + PH2 + ")";
	else
		Condition_Sql += " WHERE (mutant1.pH >=" + PH1 + " AND mutant1.pH<=" + PH2 + ")";
}
if (!AUTHOR.equals("")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND mutant1.Description LIKE '%" + AUTHOR + "%'";
	else
		Condition_Sql += " WHERE mutant1.Description LIKE '%" + AUTHOR + "%'";
}
if (YEAR1 != 1992 || YEAR2 != 2020) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND (mutant1.Year >=" + YEAR1 + " AND mutant1.Year<=" + YEAR2 + ")";
	else
		Condition_Sql += " WHERE (mutant1.Year >=" + YEAR1 + " AND mutant1.Year<=" + YEAR2 + ")";
}
if (!Journal.equals("- All Journal -")) {
	if (!Condition_Sql.equals(""))
		Condition_Sql += " AND (mutant1.ShortDetails = '" + Journal + "')";
	else
		Condition_Sql += " WHERE (mutant1.ShortDetails = '" + Journal + "')";
}
if (Sort != null) {
	switch (Integer.parseInt(Sort[1])) {
		case 0 :
	queue = "";
	break;
		case 1 :
	queue = " ORDER BY mutant1." + Sort[0] + " ASC";
	break;
		case 2 :
	queue = " ORDER BY mutant1." + Sort[0] + " DESC";
	break;
	}
}
if (!Condition_Sql.equals("")) {
	SqlCommand = "SELECT * FROM mutant1" + Condition_Sql + queue;
} else {
	SqlCommand = "SELECT * FROM mutant1" + queue;
}
%>

<script>
function Cancel_Condition(Item)
{
	if(Item=="Absreach")
		document.total_inform.ABR.value = "";
	else if(Item=="pdb_code")
		document.total_inform.pdb_code.value = "";
	else if(Item=="protein_name")
		document.total_inform.protein_name.value = "";
	else if(Item=="MUTA")
		{
		document.total_inform.MUTA1.value = "";
		document.total_inform.MUTA2.value = "";
		}
		
	else if(Item=="PHIV")
		{
		document.total_inform.PHIV1.value = "";
		document.total_inform.PHIV2.value = "";
		}
	else if(Item=="TEMP")
	{
	document.total_inform.TEMP1.value = "";
	document.total_inform.TEMP2.value = "";
	}
	else if(Item=="DENA")
		document.total_inform.DENA.value = "";
	else if(Item=="Buffer")
		document.total_inform.Buffer.value = "";
	else if(Item=="PH")
	{
	document.total_inform.PH1.value = "";
	document.total_inform.PH2.value = "";
	}
	else if(Item=="AUTHOR")
		document.total_inform.AUTHOR.value = "";
	
	document.total_inform.now_page.value=1;
	changeShowOP(); 
}
</script>

<script>
function Structure_View(PDBID)
{		
	var iframe_=document.getElementById("JMOL_Show");
	iframe_.width=document.body.clientWidth*0.265;
	iframe_.src="Adv_Inform.jsp?"+PDBID;

	$("#Div_Structure").dialog("open");
}

$(function() {
	$("#Column").click(function() {
		$("#dialog-Column").dialog("open");
		
	});
	$("#dialog-Column").dialog({
		modal : true,
		autoOpen : false,
		resizable : false,
		draggable : false,
		minHeight : 320,
		minWidth : 250,
		open : function(event, ui) {
			var display =$("#Adv_DIV").css("display");
			if($("#Adv_DIV").is(":hidden"))
			{
			$(this).parent().css({
				"top" : 300,
				"left":document.body.clientWidth*0.58
			});
			}
			else
			{
				$(this).parent().css({
					"top" : 510,
					"left":document.body.clientWidth*0.58
				});
			}
		},
		buttons : {
			"Ok" : function() {
				changeShowOP();
				$(this).dialog('close');
			},
			"Cancel" : function() {
				$(this).dialog('close');
				return false;
			}
		}
	});

	$("#Div_Structure").dialog({
		modal : true,
		autoOpen : false,
		resizable : false,
		draggable : false,
		minHeight : 400,
		minWidth : 	document.body.clientWidth*0.28,
		open : function(event, ui) {
			$(this).parent().css({
				"top" :275,
				"left" : 10
			});
		}
	});
});
</script>

<script>
function init_value()
{
	document.total_inform.now_page.value=1;
	var resi1,resi2;
	
	document.Advanced.pdb_code.value="<%=pdb_code%>";
	document.Advanced.protein_name.value="<%=protein_name%>";
	document.Advanced.MUTA1.value="<%=MUTA1%>";
	document.Advanced.MUTA2.value="<%=MUTA2%>";
	
	resi1="<%=PHIV1%>";
	resi2="<%=PHIV2%>";
	if(resi1==-2.0 || resi2==-2.0)
	{
		document.Advanced.PHIV1.value="";
		document.Advanced.PHIV2.value="";
	}
	else
	{
		document.Advanced.PHIV1.value=resi1;
		document.Advanced.PHIV2.value=resi2;
	}
	
	resi1="<%=TEMP1%>";
	resi2="<%=TEMP2%>";
	if(resi1==-2.0 || resi2==-2.0)
	{
		document.Advanced.TEMP1.value="";
		document.Advanced.TEMP2.value="";
	}
	else
	{
		document.Advanced.TEMP1.value=resi1;
		document.Advanced.TEMP2.value=resi2;
	}
	
	document.Advanced.DENA.value="<%=DENA%>";
	document.Advanced.Buffer.value="<%=Buffer%>";
	resi1="<%=PH1%>";
	resi2="<%=PH2%>";
	if(resi1==-2.0 || resi2==-2.0)
	{
		document.Advanced.PH1.value="";
		document.Advanced.PH2.value="";
	}
	else
	{
		document.Advanced.PH1.value=resi1;
		document.Advanced.PH2.value=resi2;
	}
	
	document.Advanced.YEAR1.value="<%=YEAR1%>";
	document.Advanced.YEAR2.value="<%=YEAR2%>";
	
	var ck =  document.Advanced.Journal;
	resi1="<%=Journal%>";
	for(var i=0;i<ck.length;i++)
	{
		if(ck[i].value==resi1)
		{
				ck[i].selected ="selected";
				break;
		}		
	}
}
</script>

<script>
function Re_search()
{
	keyword = document.getElementById("keyword");
	if (keyword.value == "") {
		alert("Please enter keyword");
	} else {
		$("#advanced form input").each(function() {
			$(this).val('');
		});
		$("#advanced form select").each(function() {
			$(this).val('- All Journal -');
		});
		$("#Persious_inform form input").each(function() {
			$(this).val('');
		});		
		document.total_inform.ABR.value = keyword.value;
		document.total_inform.showop.value = "0,1,2,4,5,6";
		document.total_inform.shownum.value = "10";
		document.total_inform.now_page.value = "1";
		document.total_inform.Journal.value = "- All Journal -";
		document.total_inform.submit()
		keyword.value="";
	}
}

function Advanced_search() {
	$(".Adv_DIV").slideToggle("slow");
}

function Adv_search()
{
	Adv_tran();
	document.total_inform.submit()
}

</script>

<script>
function load_condition()
{
	document.total_inform.ABR.value="<%=Absreach%>";
	document.total_inform.showop.value="<%=resi_column%>";
	document.total_inform.shownum.value="<%=show_num%>";
	document.total_inform.now_page.value="<%=now_page%>";
	document.total_inform.ordsort.value="<%=resi_sort%>";
	document.total_inform.pdb_code.value="<%=pdb_code%>";
	document.total_inform.protein_name.value="<%=protein_name%>";	
	document.total_inform.MUTA1.value="<%=MUTA1%>";
	document.total_inform.MUTA2.value="<%=MUTA2%>";
	document.total_inform.PHIV1.value="<%=PHIV1%>";
	document.total_inform.PHIV2.value="<%=PHIV2%>";
	document.total_inform.TEMP1.value="<%=TEMP1%>";
	document.total_inform.TEMP2.value="<%=TEMP2%>";
	document.total_inform.DENA.value="<%=DENA%>";
	document.total_inform.Buffer.value="<%=Buffer%>";
	document.total_inform.PH1.value="<%=PH1%>";
	document.total_inform.PH2.value="<%=PH2%>";
	document.total_inform.AUTHOR.value="<%=AUTHOR%>";
	document.total_inform.YEAR1.value="<%=YEAR1%>";
	document.total_inform.YEAR2.value="<%=YEAR2%>";
	document.total_inform.Journal.value="<%=Journal%>";

	var Slider = document.getElementById('TimeSlider');
	var obj = document.getElementById("From_Year");
	obj.value = document.total_inform.YEAR1.value;
	Slider.noUiSlider.set([ obj.value, null ]);
	obj = document.getElementById("To_Year");
	obj.value = document.total_inform.YEAR2.value;
	Slider.noUiSlider.set([ null, obj.value ]);
	
	init_value();
	}

	function Adv_tran() {
		document.total_inform.pdb_code.value = document.Advanced.pdb_code.value;
		document.total_inform.protein_name.value = document.Advanced.protein_name.value;
		document.total_inform.MUTA1.value = document.Advanced.MUTA1.value;
		document.total_inform.MUTA2.value = document.Advanced.MUTA2.value;
		document.total_inform.PHIV1.value = document.Advanced.PHIV1.value;
		document.total_inform.PHIV2.value = document.Advanced.PHIV2.value;
		document.total_inform.TEMP1.value = document.Advanced.TEMP1.value;
		document.total_inform.TEMP2.value = document.Advanced.TEMP2.value;
		document.total_inform.DENA.value = document.Advanced.DENA.value;
		document.total_inform.Buffer.value = document.Advanced.Buffer.value;
		document.total_inform.PH1.value = document.Advanced.PH1.value;
		document.total_inform.PH2.value = document.Advanced.PH2.value;
		document.total_inform.AUTHOR.value = document.Advanced.AUTHOR.value;
		document.total_inform.YEAR1.value = document.Advanced.YEAR1.value;
		document.total_inform.YEAR2.value = document.Advanced.YEAR2.value;
		document.total_inform.Journal.value = document.Advanced.Journal.value;
	}
</script>

</head>
<body onload="load_condition()">
	<div id="Persious_inform">
		<form id="total_inform" name="total_inform" action="Result.jsp"
			method="POST">
			<input type='hidden' name='ABR' id='ABR' value=""> <input
				type='hidden' name='showop' id='showop' value=""> <input
				type='hidden' name='shownum' id='shownum' value="10"> <input
				type='hidden' name='now_page' id='now_page' value='1'> <input
				type='hidden' name='ordsort' id='ordsort' value=""> <input
				type="hidden" id="pdb_code" name="pdb_code"> <input
				type="hidden" id="protein_name" name="protein_name"> <input
				type="hidden" id="MUTA1" name="MUTA1"> <input type="hidden"
				id="MUTA2" name="MUTA2"> <input type="hidden" id="PHIV1"
				name="PHIV1"> <input type="hidden" id="PHIV2" name="PHIV2">
			<input type="hidden" id="TEMP1" name="TEMP1"> <input
				type="hidden" id="TEMP2" name="TEMP2"> <input type="hidden"
				id="DENA" name="DENA"> <input type="hidden" id="Buffer"
				name="Buffer"> <input type="hidden" id="PH1" name="PH1">
			<input type="hidden" id="PH2" name="PH2"> <input
				type="hidden" id="AUTHOR" name="AUTHOR"> <input
				type="hidden" id="YEAR1" name="YEAR1"> <input type="hidden"
				id="YEAR2" name="YEAR2"> <input type="hidden" id="Journal"
				name="Journal" value="">
		</form>
	</div>
	<div id="Search_div">
		<input type="text" id="keyword" placeholder="eg.folding"
			style="border-radius: 6px; font-size: 16px" />
		<button style="border-radius: 6px; font-size: 16px"
			onclick="Re_search()">ReSearch</button>
		<br>
		<br> <a onclick="Advanced_search()"
			style="font-size: 15px; text-decoration: underline;">Advanced</a>
		<div class="Adv_DIV" style="display: none;" id="Adv_DIV">
		<form id="Advanced" name="Advanced">
		    <table>
     <tr>
      <td colspan="3"><b>About Protein</b></td>
      <td colspan="3"><b>About Mutation Point</b></td>
      <td colspan="3"><b>About literature</b></td>
      <td colspan="3"><b>About Environment</b></td>
     </tr>
     <tr>
      <td><b>Protein</b></td>
      <td><input type="text" id="protein_name" name="protein_name"
       size=30 onkeyup="Edit_ProValue(this)"
       placeholder="eg.DNA-binding protein 7a"></td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Mutation</b></td>
      <td><input type="text" id="MUTA1" name="MUTA1" size=3
       onkeyup="Edit_MutValue(this)" maxlength="1" placeholder="eg.A">
       to <input type="text" id="MUTA2" name="MUTA2" size=3
       onkeyup="Edit_MutValue(this)" maxlength="1" placeholder="eg.T">
       (only amino acid)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Author</b></td>
      <td><input type="text" id="AUTHOR" name="AUTHOR" size=15
       onkeyup="Edit_ProValue(this)" /></td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Temperature</b></td>
      <td><input type="text" id="TEMP1" name="TEMP1" size=5
       onkeyup="Edit_digital(this)"> to <input type="text"
       id="TEMP2" name="TEMP2" size=5 onkeyup="Edit_digital(this)">
       (only digital)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
     </tr>
     <tr>
      <td><b>PDB Code</b></td>
      <td><input type="text" id="pdb_code" name="pdb_code" size=5
       onkeyup="Edit_ProValue(this)" placeholder="eg.1PIN">
       (only digital or letter)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Φ value</b></td>
      <td><input type="text" id="PHIV1" name="PHIV1" size=3
       onkeyup="Edit_digital(this)"> to <input type="text"
       id="PHIV2" name="PHIV2" size=3 onkeyup="Edit_digital(this)">
       (only digital)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Year</b></td>
      <td><input type="text" id="YEAR1" name="YEAR1" size=5
       onkeyup="Edit_digital(this)"> to <input type="text"
       id="YEAR2" name="YEAR2" size=5 onkeyup="Edit_digital(this)">
       (only digital)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Denaturant</b></td>
      <td><input type="text" id="DENA" name="DENA" size=15
       onkeyup="Edit_ProValue(this)" /></td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
     </tr>
     <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td><b>Journal</b></td>
      <td height="25"><select name="Journal" id="Journal">
        <option value="- All Journal -">- All Journal -</option>
        <option value="Biochemistry">Biochemistry</option>
        <option value="Biophys Chem">Biophys Chem</option>
        <option value="FEBS Lett">FEBS Lett</option>
        <option value="J Am Chem Soc">J Am Chem Soc</option>
        <option value="J Mol Biol">J Mol Biol</option>
        <option value="Langmuir">Langmuir</option>
        <option value="Nat Struct Biol">Nat Struct Biol</option>
        <option value="Phys Chem Chem Phys">Phys Chem Chem Phys</option>
        <option value="Proc Natl Acad Sci U S A">Proc Natl Acad
         Sci U S A</option>
        <option value="Proteins">Proteins</option>
        <option value="Protein Eng Des Sel">Protein Eng Des Sel</option>
        <option value="Protein Sci">Protein Sci</option>
        <option value="Structure">Structure</option>
      </select></td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td><b>Buffer</b></td>
      <td><input type="text" id="Buffer" name="Buffer" size=15
       onkeyup="Edit_ProValue(this)" /></td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
     </tr>
     <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td><b>PH</b></td>
      <td><input type="text" id="PH1" name="PH1" size=5
       onkeyup="Edit_digital(this)"> to <input type="text"
       id="PH2" name="PH2" size=5 onkeyup="Edit_digital(this)">
       (only digital)</td>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
     </tr>
    </table>
    </form>
    		<button style="border-radius: 6px; font-size: 22px" onclick="Adv_search()">
			<i class="fa fa-search"></i>
		</button>
	</div>
	</div>
	<div class="Scrrenline_DIV">
	<div id="TimeDiv">
			<hr>
			<p>
				<font size="4">Year:</font>
			</p>
			<div id="TimeSlider"
				class="noUi-target noUi-ltr noUi-horizontal noUi-txt-dir-ltr"
				style="width: 95%;"></div>
			<br /> <br />
			<center>
				<input type="number" id="From_Year" style="width: 55px;" max="2019"
					min="1992" value="1992"> ~ <input type="number"
					id="To_Year" style="width: 55px;" max="2020" min="1993"
					value="2020">
			</center>
			<script>
		     var input_ = document.getElementById("From_Year");
		      input_.onkeydown = function(e) {
		        let _code =  e.keyCode 
		        if ((_code < 48 || _code > 57) && _code != 8){
		          e.preventDefault();
		        }
		      }
		      input_ = document.getElementById("To_Year");
		      input_.onkeydown = function(e) {
		        let _code =  e.keyCode 
		        if ( (_code < 48 || _code > 57) && _code != 8){
		          e.preventDefault();
		        }
		      }
			</script>
			<script>
				var Slider = document.getElementById('TimeSlider');
				
				var StarYear=document.getElementById("From_Year").value;
				var EndYear=document.getElementById("To_Year").value;
				
				noUiSlider.create(Slider, {
					start : [ StarYear, EndYear ],
					connect : true,
					range : {
						'min' : 1992,
						'max' : 2020
					},
					  pips: {
						    mode: 'positions',
						    values: [1992, 1993, 1995,1996,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020],
						    density: 10,
						    stepped: true
						  }
				});
			</script>
			<script>	
			var From_Year = document.getElementById("From_Year");
			var To_Year = document.getElementById("To_Year");
			Slider.noUiSlider.on('update', function(values, handle) {
			    var value = parseInt(values[handle]);
			    if (handle) {
			    	To_Year.value = value;
			    	
			    } else {
			    	From_Year.value = value;
			    }
				});
			
			Slider.noUiSlider.on('end', function(values, handle) {
				changeYear(document.getElementById("From_Year").value,document.getElementById("To_Year").value);
				});
			From_Year.addEventListener('change', function () {
				Slider.noUiSlider.set([this.value, null]);
				changeYear(document.getElementById("From_Year").value,document.getElementById("To_Year").value);
			});
			
			To_Year.addEventListener('change', function () {
				Slider.noUiSlider.set([null, this.value]);
				changeYear(document.getElementById("From_Year").value,document.getElementById("To_Year").value);
			});
			</script>

		</div>
		
		<%
		Connection connDB = null;
		try {
			boolean key = false;
			Class.forName(driverName).newInstance();
			connDB = DriverManager.getConnection(DB_URL, Account, Password);
			Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet result = null, number = null;
			result = cmd.executeQuery("SELECT DISTINCT mutant1.protein_name FROM mutant1" + Condition_Sql + queue);
			while (result.next()) {
				if (key == false) {
			key = true;
		%>
		<hr>
		<font size="4">Protein:</font><a class="Cancel_condition"
			href="javascript:changeProteinName('')">X</a>
		<%
		}
		Statement resi = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		if (Condition_Sql == "") {
		number = resi.executeQuery(
				"SELECT COUNT(*) FROM mutant1" + " WHERE (mutant1.protein_name = '" + result.getString("protein_name") + "')");
		} else {
		number = resi.executeQuery("SELECT COUNT(*) FROM mutant1" + Condition_Sql + " AND (mutant1.protein_name = '"
				+ result.getString("protein_name") + "')");
		}
		if (number.next()) {
		String PName = result.getString("protein_name");
		%><li><a href="javascript:changeProteinName('<%=PName%>')"><%=result.getString("protein_name")%>
				(<%=number.getString(1)%>)</a></li>
		<%
		}
		number.close();
		resi.close();
		}
		key = false;
		result = cmd.executeQuery("SELECT DISTINCT mutant1.ShortDetails FROM mutant1" + Condition_Sql + queue);
		while (result.next()) {
		if (key == false) {
		key = true;
		%>
		<p>
		<hr>
		<font size="4">Journal:</font><a class="Cancel_condition"
			href="javascript:changeJournalName('- All Journal -')">X</a>
		<%
		}
		Statement resi = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		if (Condition_Sql == "") {
		number = resi.executeQuery(
				"SELECT COUNT(*) FROM mutant1" + " WHERE (mutant1.ShortDetails = '" + result.getString("ShortDetails") + "')");
		} else {
		number = resi.executeQuery("SELECT COUNT(*) FROM mutant1" + Condition_Sql + " AND (mutant1.ShortDetails = '"
				+ result.getString("ShortDetails") + "')");
		}
		if (number.next()) {
		String JName = result.getString("ShortDetails");
		%>
		<li><a href="javascript:changeJournalName('<%=JName%>')"><%=result.getString("ShortDetails")%>
				(<%=number.getString(1)%>)</a></li>
		<%
		}
		number.close();
		resi.close();
		}
		result.close();
		cmd.close();
		connDB.close();
		} catch (ClassNotFoundException e) {
		out.println("Driver loading failed! <br/>");
		} catch (SQLException sqle) {
		out.println("DB linking failed! <br/>");
		}
		%>	
		</div>
			<div class="Result_DIV" id="Result_Table">
		<div id="Div_Structure" style="display: none" title="Structure">
			<iFrame src="" width="430" height="400" id="JMOL_Show"></iFrame>
		</div>
		<%
		connDB = null;
		try {
			Class.forName(driverName).newInstance();
			connDB = DriverManager.getConnection(DB_URL, Account, Password);
			Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet result;
			result = cmd.executeQuery(SqlCommand);
			int total = 0;
			if (result.next()) {
				result.last();
				total_page = result.getRow();
				total = total_page;
				if (total_page % show_num > 0)
			total_page = (total_page / show_num) + 1;
				else
			total_page = total_page / show_num;
			}
			if (total > 0) {
				out.println("<p> <font size='4'>Result:</font></p>");

				int counter = 1;
				if (Absreach != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"Absreach\")'>(X)【Absreach：" + Absreach + "】</a>　");
			counter++;
				}
				if (pdb_code != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"pdb_code\")'>(X)【pdb_code：" + pdb_code + "】</a>　");
			counter++;
				}
				if (protein_name != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"protein_name\")'>(X)【protein_name：" + protein_name
					+ "】</a>　");
			counter++;
				}
				if (MUTA1 != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"MUTA\")'>(X)【MUTA1：" + MUTA1 + " ; MUTA2 : " + MUTA2
					+ "】</a>　");
			counter++;
				}
				if (counter % 5 == 0)
			out.println("<br><br>");
				if (PHIV1 != -2.0 && PHIV2 != -2.0) {
			out.println("<a herf='#' onclick='Cancel_Condition(\"PHIV\")'>(X)【 Φ value1：" + PHIV1 + " ;  Φ value2 : "
					+ PHIV2 + "】</a>　");
			counter++;
				} else if (PHIV1 != -2.0 && PHIV2 !=-0.2) {
			out.println("<a herf='#' onclick='Cancel_Condition(\"PHIV\")'>(X)【 Φ value：" + PHIV1 + "】</a>　");
			counter++;
				} else if (PHIV2 != -2.0 && PHIV1 !=-0.2){
			out.println("<a herf='#' onclick='Cancel_Condition(\"PHIV\")'>(X)【 Φ value：" + PHIV2 + "】</a>　");
			counter++;
				}
				if (counter % 5 == 0)
			out.println("<br><br>");
				if (TEMP1 != -2.0) {
			out.println("<a herf='#' onclick='Cancel_Condition(\"TEMP\")'>(X)【TEMP1：" + TEMP1 + " ; TEMP2 : " + TEMP2
					+ "】</a>　");
			counter++;
				}
				if (counter % 5 == 0) {
			out.println("<br><br>");
			counter = 1;
				}
				if (DENA != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"DENA\")'>(X)【DENA：" + DENA + "】</a>　");
			counter++;
				}
				if (counter % 5 == 0) {
			out.println("<br><br>");
			counter = 1;
				}
				if (Buffer != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"Buffer\")'>(X)【Buffer：" + Buffer + "】</a>　");
			counter++;
				}
				if (counter % 5 == 0) {
			out.println("<br><br>");
			counter = 1;
				}
				if (PH1 != -2.0) {
			out.println("<a herf='#' onclick='Cancel_Condition(\"PH\")'>(X)【PH1：" + PH1 + " ; PH2 : " + PH2 + "】</a>　");
			counter++;
				}
				if (counter % 5 == 0) {
			out.println("<br><br>");
			counter = 1;
				}
				if (AUTHOR != "") {
			out.println("<a herf='#' onclick='Cancel_Condition(\"AUTHOR\")'>(X)【AUTHOR：" + AUTHOR + "】</a>　");
				}

				out.println("<br><br>");

				result.absolute((now_page - 1) * show_num);
				out.println("<a href='javascript:changeShowPage(1);'>First page</a>&nbsp;&nbsp;&nbsp");
				if (now_page != 1)
			out.println(
					"<a href='javascript:changeShowPage(" + (now_page - 1) + ");'>Previous page</a>&nbsp;&nbsp;&nbsp");
				out.println(now_page + "/" + total_page);
				out.println("(Total:" + total + ")&nbsp;&nbsp;&nbsp");
				if (total_page != now_page)
			out.println("<a href='javascript:changeShowPage(" + (now_page + 1) + ");'>Next page</a>&nbsp;&nbsp;&nbsp");
				out.println("<a href='javascript:changeShowPage(" + total_page + ");'>Last page</a>&nbsp;&nbsp;&nbsp");
		%>
		Number: <select name='Pagenum'
			onChange="javascript:changePageNum(this.options[this.selectedIndex].value);">
			<%
			int show_option[] = {5, 10, 15};
			for (int i = 0; i < show_option.length; i++)
				if (show_option[i] == show_num)
					out.println("<option value='" + show_option[i] + "' selected='selected'>" + show_option[i] + "</option>");
				else
					out.println("<option value='" + show_option[i] + "' >" + show_option[i] + "</option>");
			%>
		</select> <input type="button" value="Column" id="Column" class="Little_btn">
		<div id="dialog-Column" title="Column" style="display: none">
			<%
			int count = 0;
			for (int i = 0; i < ob.length; i++) {
				if (count < column.length) {
					if (Integer.parseInt(column[count]) == i) {
				out.println("<input type='checkbox' name='show_column' id='show_column' value='" + column[count]
						+ "' checked>" + ob[i] + "<br/>");
				count++;
					} else
				out.println(
						"<input type='checkbox' name='show_column' id='show_column' value='" + i + "'>" + ob[i] + "<br/>");
				} else
					out.println("<input type='checkbox' name='show_column' id='show_column' value='" + i + "'>" + ob[i] + "<br/>");
			}
			%>
		</div>
		<img src="Image/excel.png" width="3%" height="3%"
			title="Download as excel file"
			onclick="document.Download_excel.submit();">
		<div style="display: none">
			<form action='Download.jsp' method='POST' name="Download_excel">
				<input type='hidden' name='Sql' id='Sql' value="<%=SqlCommand%>">
			</form>
		</div>
		<table class="table_show">
			<tr style="background-color: #C2C2C2" class="tr_show">
				<td class='td_show' align='center'>Structure</td>
				<%
				for (int i = 0; i < column.length; i++) {
					int Show_col = Integer.parseInt(column[i]);
					switch (Show_col) {
						case 0 :
					out.println("<td class='td_show' align='center'>DB ID");
					break;
						case 1 :
					out.println("<td class='td_show' align='center'>Protein");
					break;
						case 2 :
					out.println("<td class='td_show' align='center'>PDB");
					break;
						case 3 :
					out.println("<td class='td_show' align='center'>Protein Sequence");
					break;
						case 4 :
					out.println("<td class='td_show' align='center' colspan='3'>Mutant");
					break;
						case 5 :
					out.println("<td class='td_show' align='center'>Φ Value Name");
					break;
						case 6 :
					out.println("<td class='td_show' align='center'>Φ Value");
					break;
						case 7 :
					out.println("<td class='td_show' align='center'>Phi Value SD");
					break;
						case 8 :
					out.println("<td class='td_show' align='center'>Phi Value Remarks");
					break;
						case 9 :
					out.println("<td class='td_show' align='center'>Temperature(K)");
					break;
						case 10 :
					out.println("<td class='td_show' align='center'>Denaturant");
					break;
						case 11 :
					out.println("<td class='td_show' align='center'>Environment");
					break;
						case 12 :
					out.println("<td class='td_show' align='center'>PH");
					break;
						case 13 :
					out.println("<td class='td_show' align='center'>Literature Title");
					break;
						case 14 :
					out.println("<td class='td_show' align='center'>Journal");
					break;
						case 15 :
					out.println("<td class='td_show' align='center'>Author");
					break;
						case 16 :
					out.println("<td class='td_show' align='center'>PubMed ID");
					break;
						case 17 :
					out.println("<td class='td_show' align='center'>Year");
					break;
					}
					if (Sort != null) {
						if (sortdataop[Show_col].equals(Sort[0]) && !sortop[Show_col].equals(" ")) {
				%>
				<img src='Image/sort-<%=Sort[1]%>.png' title="<%=ob[Show_col]%>"
					onClick="javascript:changeSort('<%=Sort[0]%>','<%=Integer.parseInt(Sort[1])%>');"
					width='10' height='20'>
				</td>
				<%
				} else {
				if (!sortop[Show_col].equals(" ")) {
				%>
				<img src="Image/sort-0.png" title="<%=ob[Show_col]%>"
					onClick="javascript:changeSort('<%=sortdataop[Show_col]%>',0);"
					width='10' height='20'>
				</td>
				<%
				} else {
				out.println("</td>");
				}
				}
				} else if (!sortop[Show_col].equals("")) {
				%>
				<img src="Image/sort-0.png" title="<%=ob[Show_col]%>"
					onClick="javascript:changeSort('<%=sortdataop[Show_col]%>',0);"
					width='10' height='20'>
				</td>
				<%
				} else {
				out.println("</td>");
				}
				}
				out.println("</tr>");
				int line = 0;
				while (result.next()) {
				if (line % 2 == 0)
				out.println("<tr class='tr_show'>");
				else
				out.println("<tr class='tr_show' style='background-color:#F0F0F0'>");

				String resi = result.getString("PDB_ID");
				out.println("<td class='td_show' align='center'><a herf='#' onclick='Structure_View(\"" + resi + "_"
						+ result.getInt("location") + "\")'>Select</a></td>");
				for (int i = 0; i < column.length; i++) {
				switch (Integer.parseInt(column[i])) {
					case 0 :
						out.println("<td class='td_show' align='center'>" + result.getString("DB_ID") + "</td>");
						break;
					case 1 :
						out.println("<td class='td_show' align='center'>" + result.getString("protein_name") + "</td>");
						break;
					case 2 :
						out.println("<td class='td_show' align='center'><a href='https://www.rcsb.org/structure/"
						+ result.getString("PDB_ID") + "' target='_blank'>" + result.getString("PDB_ID") + "</td>");
						break;
					case 3 :
						out.println("<td class='td_show'>" + result.getString("Seq") + "</td>");
						break;
					case 4 :
						out.println("<td class='td_show' align='center'>" + result.getString("before") + "</td>");
						out.println("<td class='td_show' align='center'>" + result.getString("after") + "</td>");
						out.println("<td class='td_show' align='center'>" + result.getInt("location") + "</td>");
						break;
					case 5 :
						out.println("<td class='td_show' align='center'>" + result.getString("phi_value_type") + "</td>");
						break;
					case 6 :
						out.println("<td class='td_show' align='center'>" + result.getString("phi_value") + "</td>");
						break;
					case 7 :
						out.println("<td class='td_show' align='center'>" + result.getString("SD") + "</td>");
						break;
					case 8 :
						out.println("<td class='td_show' align='center'>" + result.getString("phi_value_remarks") + "</td>");
						break;
					case 9 :
						out.println("<td class='td_show' align='center'>" + result.getString("temperature_K") + "</td>");
						break;
					case 10 :
						out.println("<td class='td_show' align='center'>" + result.getString("denaturant") + "</td>");
						break;
					case 11 :
						out.println("<td class='td_show' align='center'>" + result.getString("environment") + " </td>");
						break;
					case 12 :
						out.println("<td class='td_show' align='center'>" + result.getString("pH") + "</td>");
						break;
					case 13 :
						out.println("<td class='td_show' align='center'>" + result.getString("Title") + "</td>");
						break;
					case 14 :
						out.println("<td class='td_show' align='center'>" + result.getString("ShortDetails") + "</td>");
						break;
					case 15 :
						out.println("<td class='td_show' align='center'>" + result.getString("Description") + "</td>");
						break;
					case 16 :
						out.println("<td class='td_show' align='center'><a href='https://www.ncbi.nlm.nih.gov/pubmed/"
						+ result.getString("EntrezUID") + "' target='_blank'>" + result.getString("EntrezUID") + "</td>");
						break;
					case 17 :
						out.println("<td class='td_show' align='center'>" + result.getInt("Year") + "</td>");
						break;
				}
				}
				out.println("</tr>");
				line++;
				if (line == show_num)
				break;
				}
				%>
			
		</table>
		<%
		} else {
		%>
		<script>
				document.getElementById('TimeDiv').innerHTML="";
		</script>
		<%
		out.println("<p><font size='6' color='#AE0000'>No results were found. </font></p>");
		}
		} catch (ClassNotFoundException e) {
		out.println("Driver loading failed! <br/>");
		} catch (SQLException sqle) {
		out.println("DB linking failed! <br/>");
		}
		%>
	</div>
</body>
</html>