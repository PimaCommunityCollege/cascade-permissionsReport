<html>
	<head>
		<title>User Permissions Lookup</title>
		<link rel="stylesheet" type="text/css" href="report.css" />
	</head>
	<body>
		<h1>User Permissions Lookup</h1>
		<p>Enter a username to see what permissions that person has assigned.</p>
		<form action="doLookup.jsp" method="POST">
			<label>
				Username: <input type="text" name="username" />
			</label>
			<br />
			<input type="submit" />
		</form>
	</body>
</html>