<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/sql" prefix="sql" %>


<sql:query var="userRS" dataSource="jdbc/CascadeDS">
	select fce.assetType, fce.cachepath , site.name from cxml_foldercontent fce, cxml_aclentry acl, cxml_site site where acl.userPermissionsLevel = 2 and acl.userName = ? and fce.permissionsId = acl.permissionsId and site.id = fce.siteId group by fce.cachepath order by site.name, fce.cachepath

	<sql:param value="${param.username}" />
</sql:query>

<sql:query var="groupRS" dataSource="jdbc/CascadeDS">
	select groupName from cxml_group_membership where username = ?

	<sql:param value="${param.username}" />
</sql:query>

<html>
	<head>
		<title>User Permissions Lookup Results</title>
		<link rel="stylesheet" type="text/css" href="report.css" />
	</head>
	<body>
		<div>
			<h1>User Permissions Lookup: Results</h1>
			<p>
				This report shows what the user has <em>write</em> permissions for.
				The user might have the permissions assigned directly their user account,
				or the permission could be attached to a group that the user is a member of.
			</p>
			<p>Looking up permissions for user: <strong><c:out value="${param.username}" /></strong></p>
			<p><a href="index.jsp">New lookup</a></p>
		</div>

		<!-- ************************************************************************ -->

		<h2>Write permissions assigned directly to user</h2>
		<div>
			<c:choose>
			
				<c:when test="${userRS.rowCount < 1}">
					<p>No write permissions assigned directly to this user</p>
				</c:when>
				<c:otherwise>
					<table>
						<thead>
							<tr>
								<th>Site</th>
								<th>Path</th>
								<th>Type</th>
							</tr>
						</thead>
						<tbody>
							
							<c:forEach var="row" items="${userRS.rows}">
								<tr>								
									<td><c:out value="${row.name}" /></td>
									<td><c:out value="${row.cachePath}" /></td>
									<td><c:out value="${row.assetType}" /></td>						
								</tr>
							</c:forEach>
							
						</tbody>
					</table>
					
				</c:otherwise>
			
			</c:choose>
		</div>
		
		<h2>Write permissions assigned to groups user belongs to</h2>
		<c:choose>

			<c:when test="${groupRS.rowCount < 1}">
				<div>
					<p>User is not a member of any groups</p>
				</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="group" items="${groupRS.rows}">
					<sql:query var="rs" dataSource="jdbc/CascadeDS">						
						select fce.assetType, fce.cachepath , site.name from cxml_foldercontent fce, cxml_aclentry acl, cxml_site site where acl.groupPermissionsLevel = 2 and acl.groupName = ? and fce.permissionsId = acl.permissionsId and site.id = fce.siteId group by fce.cachepath order by site.name, fce.cachepath

						<sql:param value="${group.groupName}" />
					</sql:query>
					<div>
						<h3>Group name: <c:out value="${group.groupName}" /></h3>
						<c:choose>
							<c:when test="${rs.rowCount < 1}">
								<p>No write permissions granted to this group</p>
							</c:when>
							<c:otherwise>
								<table>
									<thead>
										<tr>
											<th>Site</th>
											<th>Path</th>
											<th>Type</th>
										</tr>
									</thead>
									<tbody>
										
										<c:forEach var="row" items="${rs.rows}">
											<tr>								
												<td><c:out value="${row.name}" /></td>
												<td><c:out value="${row.cachePath}" /></td>
												<td><c:out value="${row.assetType}" /></td>
											</tr>
										</c:forEach>
										
									</tbody>
								</table>
							</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</body>
</html>

