<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Complain Portal</title>
</head>
<body>


<jsp:include page="header.html"></jsp:include>

<div class="px-4 py-5 my-5">
    <div class="col-lg-6 mx-auto">
    <h4 class="display-5 fw-bold text-body-emphasis">Complain Portal</h4>
      <div class="alert alert-danger" role="alert">
    Sorry, an error occured!
   </div>
      <jsp:include page="userform.html"></jsp:include>
    </div>
  </div>

</body>
</html>