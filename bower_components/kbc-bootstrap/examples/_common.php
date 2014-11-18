<?php
function html_head($title)
{
	return <<<EOT
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!--meta name="viewport" content="width=device-width, initial-scale=1"-->
	<meta name="author" content="Keboola">
	<link rel="icon" href="../favicon.png">

	<title>$title</title>

	<!-- Custom styles for this template -->
	<link rel="stylesheet" href="../dist/css/kbc.css">
	<link href='http://fonts.googleapis.com/css?family=Roboto:300,400,500,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
</head>
EOT;
}
function head($pageHeader, $button=null)
{
	return <<<EOT
<body>
	<nav class="navbar navbar-fixed-top kbc-navbar" role="navigation">
		<div class="col-sm-3 col-md-2 kbc-logo">
			<a href="#"><span class="kbc-icon-keboola"></span> Connection</a>
		</div>
		<div class="col-sm-9 col-md-10 kbc-main-header">
			<div class="kbc-title">
				$pageHeader
			</div>
			<div class="kbc-title-button">
			{$button}
			</div>
		</div>
	</nav>
EOT;
}

function sidebar()
{
	return <<<EOT
<div class="col-sm-3 col-md-2 kbc-sidebar">
	<div class="kbc-project-select dropdown">
		<button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			KB Paymo
			<span class="kbc-icon-pickerDouble"></span>
		</button>
		<div class="dropdown-menu">
			<ul class="list-unstyled">
				<li class="dropdown-header kb-nav-search">
					<div>
						<input type="text" placeholder="Search your projects" class="form-control">
					</div>
				</li>
				<li class="divider"></li>
			</ul>
			<ul class="list-unstyled" role="menu" aria-labelledby="dLabel">
				<li><a href="">Project 1</a></li>
				<li><a href="">Project 2</a></li>
				<li><a href="">Project 3</a></li>
				<li><a href="">Project 4</a></li>
			</ul>
		</div>
	</div>
	<ul class="kbc-nav-sidebar nav nav-sidebar">
		<li><a href="#"><span class="kbc-icon-overview"></span> Overview</a></li>
		<li class="active"><a href="#"><span class="kbc-icon-extractors"></span> Extractors</a></li>
		<li><a href="#"><span class="kbc-icon-transformations"></span> Transformations</a></li>
		<li><a href="#"><span class="kbc-icon-writers"></span> Writers</a></li>
		<li><a href="#"><span class="kbc-icon-orchestration"></span> Orchestrations</a></li>
		<li><a href="#"><span class="kbc-icon-storage"></span> Storage</a></li>
	</ul>
	<div class="kbc-sidebar-footer">
		<div class="kbc-user">
			<img src="avatar.png" class="kbc-user-avatar"/>
			<div><strong>Petr Šimeček</strong></div>
			<div><span>Super Admin</span></div>
		</div>
		<div class="kbc-user-links">
			<ul class="nav">
				<li><a href=""><span class="kbc-icon-comment"></span> Support</a></li>
				<li><a href=""><span class="kbc-icon-user"></span> Users & Settings</a></li>
			</ul>
		</div>
	</div>
</div>
EOT;
}

function html_tail()
{
	return <<<EOT
	<!-- Bootstrap core JavaScript
	    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</body>
</html>
EOT;

}