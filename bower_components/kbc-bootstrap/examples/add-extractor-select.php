<?php include '_common.php' ?>

<?php echo html_head('Add Extractor');?>
<?php echo head(
	'<a href="">Extractors</a> <span class="kbc-icon-arrow-right"></span> <h1>New Extractor</h1>', // page title
	'' // optional code of button to the right of page title
);?>

	<div class="container-fluid">
		<div class="row">
			<?php echo sidebar(); ?>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main">
				<div class="container-fluid">
					<div class="row kbc-search-row">
						<span class="kbc-icon-search"></span>
						<input type="text" placeholder="Search" class="form-control">
					</div>
					<div class="row kbc-extractors-select">
						<div class="col-sm-4 ng-scope">
							<div class="panel">
								<div class="panel-body text-center">
									<img src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/cloudsearch64-1.png">
									<h2>AWS Cloudsearch</h2>
									<p>Search service for AWS Cloud</p>
									<a href="#/new-component-form/ex-cloudsearch" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div>
						<div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/cloudsearch64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/cloudsearch64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>AWS S3</h2>
									<p class="ng-binding">Cloud storage for the Internet</p>
									<a href="#/new-component-form/ex-s3" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div>
						<div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/adocean64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/adocean64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>AdOcean</h2>
									<p class="ng-binding">See the efficiency of your web banners</p>
									<a href="#/new-component-form/ex-adocean" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div>
					</div>
					<div class="row ng-scope kbc-extractors-select" ng-repeat="componentsPart in availableComponents">

						<!-- ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/constant-contact64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/constant-contact64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Constant Contact</h2>
									<p class="ng-binding">Small business marketing service</p>
									<a href="#/new-component-form/ex-constantcontact" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --><span ng-if="!hasIcon()" class="kb-default ng-scope">
<i class="fa fa-cloud-download" style="font-size: 59px; height: 64px; position: relative; top: 5px"></i>
</span><!-- end ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Currency</h2>
									<p class="ng-binding">Convert your money to different currencies</p>
									<a href="#/new-component-form/ex-currency" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --><span ng-if="!hasIcon()" class="kb-default ng-scope">
<i class="fa fa-cloud-download" style="font-size: 59px; height: 64px; position: relative; top: 5px"></i>
</span><!-- end ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Database Extractor</h2>
									<p class="ng-binding">Fetch data from MySQL or MSSQL</p>
									<a href="#/new-component-form/ex-db" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart -->

					</div>
					<div class="row ng-scope kbc-extractors-select" ng-repeat="componentsPart in availableComponents">

						<!-- ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/elasticsearch64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/elasticsearch64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Elasticsearch</h2>
									<p class="ng-binding">End-to-end search and analytics platform</p>
									<a href="#/new-component-form/ex-elasticsearch" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/facebook64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/facebook64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Facebook</h2>
									<p class="ng-binding">Get the data from your social network</p>
									<a href="#/new-component-form/ex-facebook" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart --><div class="col-sm-4 ng-scope" ng-repeat="component in componentsPart">
							<div class="panel panel-default kb-component-panel kb-pointer" ng-click="goToComponent(component)">
								<div class="panel-body text-center">
									<kb-sapi-component-icon component="component" size="64" class="ng-isolate-scope kb-sapi-component-icon"><!-- ngIf: hasIcon() --><span ng-if="hasIcon()" class="ng-scope">
<img ng-src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/facebook-ads64-1.png" width="" height="" src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/facebook-ads64-1.png">
</span><!-- end ngIf: hasIcon() -->
										<!-- ngIf: !hasIcon() --></kb-sapi-component-icon>
									<h2>Facebook Ads</h2>
									<p class="ng-binding">Advertise with Facebook</p>
									<a href="#/new-component-form/ex-facebook-ads" class="btn btn-success btn-lg">
										<span class="kbc-icon-plus"> Add
									</a>
								</div>
							</div>
						</div><!-- end ngRepeat: component in componentsPart -->

					</div>
				</div>
			</div>
		</div>
	</div>

<?php echo html_tail(); ?>