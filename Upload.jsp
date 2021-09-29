<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/Unite.css" media="screen" />

<style type="text/css">

.Inform
{
    height: 500px;
    width: 100%;
    margin-top:8%;
}

</style>

<script>

function CheckFile() {

	var msg = "";
	var email = document.getElementById("UserEmail").value;
	var emailRule = new RegExp(/^\S+@\S+\.\S{2,}$/);

	var isIE = /msie/i.test(navigator.userAgent) && !window.opera;
	var fileSize = 0;

	var ResiName = document.getElementById("chooseFile").value;
	var isPDF = ResiName.substring(ResiName.lastIndexOf(".") + 1)
			.toLowerCase();

	if (email == "") {
		msg += "Please enter your emaill address."
	} else if (!emailRule.test(email)) {
		msg += "The email format you wrote is incorrect. Please rewrite."
	} else if (ResiName == "") {
		msg += "Please select a PDF file."
	} else if (isPDF != "pdf") {
		msg += "File format is incorrect. Please select a PDF file.";
	} else {
		if (isIE && !document.uploadform.file1.files) {
			var filePath = document.getElementById("FilePath").value;
			var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
			var file = fileSystem.GetFile(filePath);
			fileSize = file.Size;
		} else {
			fileSize = document.getElementById("chooseFile").files[0].size;
		}

		var size = fileSize / 1024;

		if (size > 2000) {
			msg += "File cannot be larger than 2M.";
			document.getElementById("FilePath").value = "";
		} else {
			msg += "Success!";
			document.File_Info.submit();
			Clear();
		}
	}

	alert(msg);
}

function Clear() {
	document.getElementById("UserEmail").value = "";
	document.getElementById("FilePath").value = "";
}

</script>
</head>
<body class="Home_body">
	<div class="wrapper">
	
	<div class="Inform">
	<div style="float: left; width: 40%; padding-top: 50px; padding-left: 10px">
	<form action="Upload_deel.jsp" id="File_Info" name="File_Info" method="POST" enctype="multipart/form-data">
	<font size="4">Email : </font>
	<input type="text" id="UserEmail" name="UserEmail" style="width: 80%" /> <br />
	<br />
	<font size="4">File : </font>
	<input type="text" id="FilePath" name="FilePath" readonly style="width: 74%" />

	<!-- FILE Choose -->
	<input type=file id="chooseFile" name="chooseFile" size="20" style="display: none;" onchange="FilePath.value=this.value.substr(this.value.lastIndexOf('\\')+1);">
	<input type="button" value="choose" onclick="chooseFile.click();">
	</form>
	<br /><br />
	<input type="button" value="Submit" id="submit" class="Little_btn" onclick="CheckFile()" style="padding:2px;">
	<input type="button" value="Clear" id="clear" class="Little_btn" onclick="Clear()"  style="padding:2px;">

	</div>


	<div style="float: right; width: 50%; padding-top: 50px">
		<h1>Upload process¡G</h1>
		<p>
			<font size="4">1. Please enter your email address</font>
		</p>
		<p>
			<font size="4">2. Please upload a PDF file, the file size is
				0-2MB</font>
		</p>
		<p>
			<font size="4">3. After the upload is complete, an email
				notification will be sent according to the email address you
				entered.</font>
		</p>
	</div>
	</div>
	
	</div>
	<footer style="text-align: center; font-size: 20px">
		<br><br><br><br>
		<a href="#">News</a>&nbsp;&nbsp; <a href="#">Reference</a>&nbsp;&nbsp;
		<a href="#">Contact</a> <br>
		<br>
	</footer>
</body>
</html>