<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/Unite.css"
	media="screen" />
<link rel="stylesheet" type="text/css" href="Style/jquery-ui.css">
<link
	href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css"
	rel="stylesheet">
<script src="https://d3js.org/d3.v3.min.js"></script>
<script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="Edit_input.js"></script>

<script type="text/javascript">
	//OnLoad Page
	var dataset;
	d3.csv("CSVdata/theatise.csv", function(error, data) {
		if (error) {
			console.log(error);
		} else {
			dataset = data;
			var newsvg = d3.select('#Year_Theatise').append('svg').attr({
				'width' : 700,
				'height' : 700
			});

			newsvg.selectAll('rect').data(dataset).enter().append('rect').attr(
					{
						'fill' : '#007799',
						'width' : 0,
						'height' : 20,
						'x' : 20,
						'y' : function(d) {
							return (d.no - 1) * 22
						}
					}).transition().duration(1500).attr({
				'width' : function(d) {
					return d.papernumber * 30;
				}
			});

			var texts = newsvg.selectAll("text").data(dataset).enter();

			texts.append('text').text(function(d) {
				return 0;
			}).attr({
				'fill' : '#000',
				'x' : 20,
				'y' : function(d) {
					return d.no * 22 - 12;
				}
			}).transition().duration(1500).attr({
				'x' : function(d) {
					return (d.papernumber * 30) + 23;
				}
			}).tween('number', function(d) {
				var i = d3.interpolateRound(0, d.papernumber);
				return function(t) {
					this.textContent = i(t);
				};
			});

			texts.append('text').text(function(d) {
				return 0;
			}).attr({
				'fill' : '#000',
				'x' : 0,
				'y' : function(d) {
					return d.no * 22 - 12;
				}
			}).transition().tween('number', function(d) {
				var i = d3.interpolateRound(0, d.year);
				return function(t) {
					this.textContent = i(t);
				};
			});
		}
	});
</script>

<script>
	function Search() {
		keyword = document.getElementById("keyword");
		if (keyword.value == "") {
			alert("Please enter keyword");
		} else {
			$("#advanced_dialog form input").each(function() {
				$(this).val('');
			});
			$("#advanced_dialog form select").each(function() {
				$(this).val('- All Journal -');
			});
			document.dataab.ABR.value = keyword.value;
			document.dataab.submit()
			keyword.value = "";
		}
	}

	function Advanced_search() {
		$(".Adv_DIV").slideToggle("slow");
	}
</script>

</head>
<body class="Home_body">
	<div class="wrapper">
		<div id="Search_div">
			<input type="text" id="keyword" placeholder="eg.folding"
				style="border-radius: 6px; font-size: 16px" />
			<button style="border-radius: 6px; font-size: 22px"
				onclick="Search()">
				<i class="fa fa-search"></i>
			</button>
			<br> <br> <a onclick="Advanced_search()"
				style="font-size: 15px; text-decoration: underline;">Advanced</a>
			<form action="Result.jsp" method="POST" name="dataab" id="dataab">
			<div class="Adv_DIV" style="display: none;">
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
				</div>
				<input type='hidden' name='ABR' id='ABR' value=""> <input
					type='hidden' name='showop' id='showop' value="0,1,2,4,5,6">
				<input type='hidden' name='shownum' id='shownum' value="10">
				<input type='hidden' name='now_page' id='now_page' value='1'>
				<input type='hidden' name='ordsort' id='ordsort' value="">
				</form>
			</div>
		<div style="float: left; width: 40%">
			<h1>INTRODUCTION</h1>
			<p>
				<font size="4">Protein is considered to be in different
					stages during the folding process and the structure conformational
					change is from an unfolding state to a folded state (native state)
					of the lowest energy of configuration. During the state transition,
					there is a high-energy transient may occur, called “transition
					state”. The study of transition state can improve the understanding
					of protein folding interactions.</font>
			</p>
			<p>
				<font size="4">Φ-value analysis is one of the most commonly
					used method to probe the transition state structures in protein
					folding. The Φ-value is calculated by the difference in energy
					between the each states of the mutant protein and the wild-type
					protein during protein folding process. This method is mainly used
					to analyze the change of the transition state energy caused by the
					mutated residue, and to evaluate the effects of the mutated residue
					in the transition state structure.</font>
			</p>
			<p>
				<font size="4">Since the Φ-value analysis requires
					biochemical experiments to obtain data, it is time consuming and
					high cost. Therefore, collating experimental data from the
					literature becomes another way, but it takes a lot of time to read
					the literature to obtain.</font>
			</p>
			<p>
				<font size="4">So we collect the literature related to
					Φ-value in the past, integrate Φ-value experimental data and use
					these data to establish a database. This database provide
					researchers efficiently get the Φ-value data to fulfill
					requirements by searching. To resolve the difficulty of
					time-consuming and high-cost by the traditional Φ-value data
					acquisition method.</font>
			</p>
		</div>
		<div style="float: right; width: 50%">
			<p>
				<font size="4">The distribution of literature in each year：</font>
			</p>
			<div id="Year_Theatise"></div>
		</div>
	</div>
	<br>
	<br>
	<footer style="text-align: center; font-size: 20px">
		<a href="#">News</a>&nbsp;&nbsp; <a href="#">Reference</a>&nbsp;&nbsp;
		<a href="#">Contact</a> <br>
		<br>
	</footer>
</body>
</html>