<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
    <%@ page import="java.util.*,java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>

<%@ page import="org.apache.commons.mail.DefaultAuthenticator" %>
<%@ page import="org.apache.commons.mail.Email" %>
<%@ page import="org.apache.commons.mail.EmailException" %>
<%@ page import="org.apache.commons.mail.HtmlEmail" %>
<%!
    int MaxSize = 1024 * 1024 * 2;
	boolean writeToFile = true;
	String allowedFileTypes = ".pdf";
	String UserEmail=""; 
%>

<%
Date today= new Date();
String DirName="";
SimpleDateFormat formt = new SimpleDateFormat("yyyyMMdd_HHmmss");
DirName = formt.format(today);

//創建目錄
boolean success = (new File(application.getRealPath("/Upload_Pdf/")+DirName)).mkdir();
String SavePath = application.getRealPath("/Upload_Pdf/")+DirName;
File ResiDir = new File(SavePath);

boolean isMultipart = ServletFileUpload.isMultipartContent(request);
DiskFileItemFactory factory = new DiskFileItemFactory(MaxSize, ResiDir);

ServletFileUpload upload = new ServletFileUpload(factory);
upload.setSizeMax(MaxSize);
ProgressListener progressListener = new ProgressListener() {
	private long megaBytes = -1;
	public void update(long pBytesRead, long pContentLength, int pItems) {
		long mBytes = pBytesRead / 1000000;
		if (megaBytes == mBytes) {
			return;
		}
		megaBytes = mBytes;
	}
};
upload.setProgressListener(progressListener);

List items = null;
try{
	items = upload.parseRequest(request); 
} catch (FileUploadException ex){
}

try{
	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
		if (item.isFormField()) {	
			String field = item.getFieldName();
			String value = item.getString("UTF-8");
			if(field.equals("UserEmail"))
				UserEmail=value;
		} else {					
			String fieldName = item.getFieldName();
			String fileName = item.getName();
			String extension = FilenameUtils.getExtension(fileName);
			if (allowedFileTypes.indexOf(extension.toLowerCase()) != -1) {
				String contentType = item.getContentType();
				boolean isInMemory = item.isInMemory();
				long sizeInBytes = item.getSize();
				if (fileName != null && !"".equals(fileName)) {
					if (writeToFile) {
						//儲存上傳檔案
						fileName = FilenameUtils.getName(fileName);
						File uploadedFile = new File(SavePath,	fileName);						
						item.write(uploadedFile);
						
						//儲存提供者資訊
						File strFile = new File(application.getRealPath("/Upload_Pdf/")+"send.txt");
						boolean fileCreated = strFile.createNewFile();
						Writer fw = new BufferedWriter(new FileWriter(strFile,true));
						fw.write("Data:"+today+"\r\n");
						fw.write("Send From:"+UserEmail+"\r\n");
						fw.write("File Name:"+fileName+"\r\n\r\n");
						fw.flush();
						fw.close();
						
						String subject="Gmail SMTP SSL";
						String message = "<html><head><title>Phi value</title></head><body>Successfully sent Phi value PDF.<br/>Thank you for your feedback.</body></html>"; 
						Email email = new HtmlEmail(); 
						String authuser = "109325107@gms.tcu.edu.tw"; 
						String authpwd = "lun870511";
						email.setHostName("smtp.gmail.com");
						email.setSmtpPort(465); 
						email.setAuthenticator(new DefaultAuthenticator(authuser, authpwd));
						email.setDebug(true);
						email.setSSL(true);
						email.setSslSmtpPort("465");
						email.setCharset("UTF-8");
						email.setSubject(subject);
						try {
							email.setFrom(authuser);
							email.setMsg(message); 
							email.addTo(UserEmail);
							email.send();
							response.sendRedirect("Upload.jsp");
						} 
						catch (EmailException e) 
						{
							e.printStackTrace();
						}
					}
				}
			}
		}
	}
} catch (FileUploadBase.SizeLimitExceededException ex1) {

}
%>