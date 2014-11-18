<?php include '_common.php' ?>

<?php echo html_head('CSS');?>

<?php echo head(
	'<h1>Templates</h1>' // page title
);?>

    <div class="container-fluid">
        <div class="row">
	        <div class="col-sm-3 col-md-2 kbc-sidebar">
		        <ul class="kbc-nav-sidebar nav nav-sidebar">
			        <li><a href="#templates">Templates</a></li>
			        <li><a href="#typography">Typography</a></li>
			        <li><a href="#colors">Colors</a></li>
			        <li><a href="#tables">Tables</a></li>
			        <li><a href="#forms">Forms</a></li>
		        </ul>
	        </div>
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main">
                <div class="container-fluid">
	                <div class="row">
		                <h2 id="templates">Templates</h2>
		                <ul>
		                    <li><a href="extractors.php">List of Configured Extractors</a></li>
		                    <li><a href="add-extractor-select.php">Add Extractor - Select</a></li>
			                <li><a href="add-extractor.php">Add Extractor - Settings</a></li>
	                    </ul>
	                </div>
	                <div class="row">
		                <h2 id="typography">Typography</h2>
		                <div class="well">
			                <h1>H1 heading <small>Secondary text</small></h1>
			                <hr>
			                <h2>H2 heading <small>Secondary text</small></h2>
			                <hr>
			                <h3>H3 heading <small>Secondary text</small></h3>
			                <hr>
			                <h4>H4 heading <small>Secondary text</small></h4>
			                <hr>
			                <h5>H5 heading <small>Secondary text</small></h5>
			                <hr>
		                    <h6>H6 heading <small>Secondary text</small></h6>
			                <p class="lead"><strong>Paragraph .lead</strong> Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus.</p>
			                <p><strong>Paragraph</strong>: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam bibendum elit eget erat. Vivamus porttitor turpis ac leo. Sed ac dolor sit amet purus malesuada congue. Fusce consectetuer risus a nunc. Pellentesque sapien. Integer rutrum, orci vestibulum ullamcorper ultricies, lacus quam ultricies odio, vitae placerat pede sem sit amet enim. Cras elementum. Ut tempus purus at lorem. </p>
		                </div>
	                </div>
	                <div class="row">
		                <h2 id="colors">Colors</h2>
		                <div class="well">
			                <p class="text-muted">Fusce dapibus, tellus ac cursus commodo, tortor mauris nibh.</p>
			                <p class="text-primary">Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
			                <p class="text-success">Duis mollis, est non commodo luctus, nisi erat porttitor ligula.</p>
			                <p class="text-info">Maecenas sed diam eget risus varius blandit sit amet non magna.</p>
			                <p class="text-warning">Etiam porta sem malesuada magna mollis euismod.</p>
			                <p class="text-danger">Donec ullamcorper nulla non metus auctor fringilla.</p>
		                </div>
		                <div class="well">
			                <p class="bg-primary">Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
			                <p class="bg-success">Duis mollis, est non commodo luctus, nisi erat porttitor ligula.</p>
			                <p class="bg-info">Maecenas sed diam eget risus varius blandit sit amet non magna.</p>
			                <p class="bg-warning">Etiam porta sem malesuada magna mollis euismod.</p>
			                <p class="bg-danger">Donec ullamcorper nulla non metus auctor fringilla.</p>
		                </div>
	                </div>
	                <div class="row">
		                <h2 id="buttons">Buttons</h2>
		                <h3>Button styles</h3>
		                <p>
			                <button type="button" class="btn btn-default">Default</button>
			                <button type="button" class="btn btn-primary">Primary</button>
			                <button type="button" class="btn btn-success">Success</button>
			                <button type="button" class="btn btn-info">Info</button>
			                <button type="button" class="btn btn-warning">Warning</button>
			                <button type="button" class="btn btn-danger">Danger</button>
			                <button type="button" class="btn btn-link">Link</button>
		                </p>
		                <h3>Button sizes</h3>
	                    <p>
			                <button type="button" class="btn btn-primary btn-lg">Large button</button>
		                    <button type="button" class="btn btn-primary">Default button</button>
			                <button type="button" class="btn btn-primary btn-sm">Small button</button>
			                <button type="button" class="btn btn-primary btn-xs">Extra small button</button>
		                </p>
		                <h3>Buttons with KBC icon</h3>
		                <p>
			                <button type="button" class="btn btn-success btn-lg kbc-btn-icon"><span class="kbc-icon-plus"></span> Large button</button>
			                <button type="button" class="btn btn-success kbc-btn-icon"><span class="kbc-icon-plus"></span> Default button</button>
			                <button type="button" class="btn btn-success btn-sm kbc-btn-icon"><span class="kbc-icon-plus"></span> Small button</button>
			                <button type="button" class="btn btn-success btn-xs kbc-btn-icon"><span class="kbc-icon-plus"></span> Extra small button</button>
		                </p>
		                <h3>Buttons with Font Awesome</h3>
		                <p>
			                <button type="button" class="btn kbc-btn-icon"><span class="fa fa-angellist"></span> Button</button>
			                <button type="button" class="btn kbc-btn-icon"><span class="fa fa-area-chart"></span> Button</button>
			                <button type="button" class="btn kbc-btn-icon"><span class="fa fa-binoculars"></span> Button</button>
			                <button type="button" class="btn kbc-btn-icon"><span class="fa fa-futbol-o"></span> Button</button>
			                <button type="button" class="btn kbc-btn-icon"><span class="fa fa-plug"></span> Button</button>
		                </p>
		                <h3>Block level buttons</h3>
		                <div class="well" style="max-width: 400px; margin: 0 0 10px;">
			                <button type="button" class="btn btn-primary btn-block">Block level button</button>
			                <button type="button" class="btn btn-default btn-block">Block level button</button>
		                </div>
		                <h3>States</h3>
		                <p>
			                <button type="button" class="btn btn-default">Button</button>
			                <button type="button" class="btn btn-default active">Active button</button>
			                <button type="button" class="btn btn-default" disabled="disabled">Disabled button</button>
		                </p>
		                <p>
			                <button type="button" class="btn btn-primary">Primary button</button>
			                <button type="button" class="btn btn-primary active">Active primary button</button>
			                <button type="button" class="btn btn-primary" disabled="disabled">Disabled primary button</button>
		                </p>
		                <h3>Links</h3>
		                <p>
			                <a href="#" class="btn btn-default" role="button">Link</a>
			                <a href="#" class="btn btn-default active" role="button">Active link</a>
			                <a href="#" class="btn btn-default disabled" role="button">Disabled link</a>
		                </p>
		                <p>
			                <a href="#" class="btn btn-primary" role="button">Primary link</a>
			                <a href="#" class="btn btn-primary active" role="button">Active primary link</a>
			                <a href="#" class="btn btn-primary disabled" role="button">Disabled primary link</a>
		                </p>
		                <h3>Inputs</h3>
		                <p>
			                <input class="btn btn-default" type="button" value="Input">
			                <input class="btn btn-default" type="submit" value="Submit">
		                </p>
	                </div>
	                <div class="row">
		                <h2 id="tables">Tables</h2>
		                <table class="table table-striped">
			                <caption>Table with striped rows</caption>
			                <thead>
			                <tr>
				                <th>#</th>
				                <th>First Name</th>
				                <th>Last Name</th>
				                <th>Username</th>
			                </tr>
			                </thead>
			                <tbody>
			                <tr>
				                <td>1</td>
				                <td>Mark</td>
				                <td>Otto</td>
				                <td>@mdo</td>
			                </tr>
			                <tr>
				                <td>2</td>
				                <td>Jacob</td>
				                <td>Thornton</td>
				                <td>@fat</td>
			                </tr>
			                <tr>
				                <td>3</td>
				                <td>Larry</td>
				                <td>the Bird</td>
				                <td>@twitter</td>
			                </tr>
			                </tbody>
		                </table>

		                <table class="table table-bordered table-hover">
			                <caption>Table with borders and row hovers</caption>
			                <thead>
			                <tr>
				                <th>#</th>
				                <th>First Name</th>
				                <th>Last Name</th>
				                <th>Username</th>
			                </tr>
			                </thead>
			                <tbody>
			                <tr>
				                <td>1</td>
				                <td>Mark</td>
				                <td>Otto</td>
				                <td>@mdo</td>
			                </tr>
			                <tr>
				                <td>2</td>
				                <td>Jacob</td>
				                <td>Thornton</td>
				                <td>@fat</td>
			                </tr>
			                <tr>
				                <td>3</td>
				                <td>Larry</td>
				                <td>the Bird</td>
				                <td>@twitter</td>
			                </tr>
			                </tbody>
		                </table>

		                <table class="table">
			                <thead>
			                <tr>
				                <th>#</th>
				                <th>Column heading</th>
				                <th>Column heading</th>
				                <th>Column heading</th>
			                </tr>
			                </thead>
			                <tbody>
			                <tr class="active">
				                <td>1</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr>
				                <td>2</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr class="success">
				                <td>3</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr>
				                <td>4</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr class="info">
				                <td>5</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr>
				                <td>6</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr class="warning">
				                <td>7</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr>
				                <td>8</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                <tr class="danger">
				                <td>9</td>
				                <td>Column content</td>
				                <td>Column content</td>
				                <td>Column content</td>
			                </tr>
			                </tbody>
		                </table>
	                </div>
	                <div class="row">
		                <h2 id="forms">Forms</h2>
		                <div class="well">
			                <form role="form">
				                <div class="form-group">
					                <label for="exampleInputEmail1">Email address</label>
					                <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
				                </div>
				                <div class="form-group">
					                <label for="exampleInputPassword1">Password</label>
					                <input type="password" class="form-control" id="exampleInputPassword1" placeholder="Password">
				                </div>
				                <div class="form-group">
					                <label for="exampleInputFile">File input</label>
					                <input type="file" id="exampleInputFile">
					                <p class="help-block">Example block-level help text here.</p>
				                </div>
				                <div class="checkbox">
					                <label>
						                <input type="checkbox"> Check me out
					                </label>
				                </div>
				                <button type="submit" class="btn btn-success">Submit</button>
			                </form>
		                </div>

		                <h3>Inline form</h3>
		                <div class="well">
			                <form class="form-inline" role="form">
				                <div class="form-group">
					                <label class="sr-only" for="exampleInputEmail2">Email address</label>
					                <input type="email" class="form-control" id="exampleInputEmail2" placeholder="Enter email">
				                </div>
				                <div class="form-group">
					                <div class="input-group">
						                <div class="input-group-addon">@</div>
						                <input class="form-control" type="email" placeholder="Enter email">
					                </div>
				                </div>
				                <div class="form-group">
					                <label class="sr-only" for="exampleInputPassword2">Password</label>
					                <input type="password" class="form-control" id="exampleInputPassword2" placeholder="Password">
				                </div>
				                <div class="checkbox">
					                <label>
						                <input type="checkbox"> Remember me
					                </label>
				                </div>
				                <button type="submit" class="btn btn-default">Sign in</button>
			                </form>
		                </div>

		                <h3>Horizontal form</h3>
		                <div class="well">
			                <form class="form-horizontal" role="form">
				                <div class="form-group">
					                <label for="inputUsername3" class="col-sm-2 control-label">First name</label>
					                <div class="col-sm-10">
						                <input type="text" class="form-control" id="inputUsername3" value="My Name">
					                </div>
				                </div>
				                <div class="form-group">
					                <label for="inputAge" class="col-sm-2 control-label">Last name</label>
					                <div class="col-sm-10">
						                <input type="text" class="form-control" id="inputAge" placeholder="Last name">
					                </div>
				                </div>
				                <div class="form-group">
					                <div class="col-sm-offset-2 col-sm-10">
						                <div class="checkbox">
							                <label>
								                <input type="checkbox"> Agree
							                </label>
						                </div>
					                </div>
				                </div>
				                <div class="form-group">
					                <div class="col-sm-offset-2 col-sm-10">
						                <button type="submit" class="btn btn-default">Signup</button>
					                </div>
				                </div>
			                </form>
		                </div>

		                <h3>Validations</h3>
		                <div class="well">
			                <form role="form">
				                <div class="form-group has-success">
					                <label class="control-label" for="inputSuccess1">Input with success</label>
					                <input type="text" class="form-control" id="inputSuccess1">
				                </div>
				                <div class="form-group has-warning">
					                <label class="control-label" for="inputWarning1">Input with warning</label>
					                <input type="text" class="form-control" id="inputWarning1">
				                </div>
				                <div class="form-group has-error">
					                <label class="control-label" for="inputError1">Input with error</label>
					                <input type="text" class="form-control" id="inputError1">
				                </div>
				                <div class="has-success">
					                <div class="checkbox">
						                <label>
							                <input type="checkbox" id="checkboxSuccess" value="option1">
							                Checkbox with success
						                </label>
					                </div>
				                </div>
				                <div class="has-warning">
					                <div class="checkbox">
						                <label>
							                <input type="checkbox" id="checkboxWarning" value="option1">
							                Checkbox with warning
						                </label>
					                </div>
				                </div>
				                <div class="has-error">
					                <div class="checkbox">
						                <label>
							                <input type="checkbox" id="checkboxError" value="option1">
							                Checkbox with error
						                </label>
					                </div>
				                </div>
			                </form>
		                </div>
	                </div>
                </div>
            </div>
        </div>
    </div>

<?php echo html_tail(); ?>