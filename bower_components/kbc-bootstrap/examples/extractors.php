<?php include '_common.php' ?>

<?php echo html_head('Extractors');?>
<?php echo head(
	'<h1>Extractors</h1> <a href=""><span class="kbc-refresh kbc-icon-cw"></span></a>', // page title
	'<button type="button" class="btn btn-success kbc-btn-with-icon"><span class="kbc-icon-plus"></span> Add Extractor</button>' // optional code of button to the right of page title
);?>

	<div class="container-fluid">
		<div class="row">
			<?php echo sidebar(); ?>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main">
				<div class="container-fluid">


					<table class="table table-bordered kbc-table-full-width kbc-extractors-table">
						<tr>
							<td>
								<img src="https://cdn4.iconfinder.com/data/icons/aiga-symbol-signs/446/aiga_currency_exchange-32.png" /> Currency
							</td>
							<td>
								<ul>
									<li><a href="">ch-currency</a> <span class="kbc-icon-arrow-right"></span></li>
								</ul>
							</td>
						</tr>
						<tr>
							<td>
								<img src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/Google-Drive-icon-32-1.png" /> Google Drive
							</td>
							<td>
								<ul>
									<li><a href="">account-1</a> <span class="kbc-icon-arrow-right"></span></li>
									<li><a href="">account-2</a> <span class="kbc-icon-arrow-right"></span></li>
									<li><a href="">Ecodrive</a> <span class="kbc-icon-arrow-right"></span></li>
								</ul>
							</td>
						</tr>
						<tr>
							<td>
								<img src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/microsoft-dynamics32-1.png" /> MS Dynamics CRM
							</td>
							<td>
								<ul>
									<li><a href="">Centrum</a> <span class="kbc-icon-arrow-right"></span>
										<small>monitoring of complete revenue for the pebble app</small></li>
								</ul>
							</td>
						</tr>
						<tr>
							<td>
								<img src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/sklik32-1.png" /> Sklik
							</td>
							<td>
								<ul>
									<li><a href="">ch-ppc</a> <span class="kbc-icon-arrow-right"></span></li>
								</ul>
							</td>
						</tr>
					</table>


				</div>
			</div>
		</div>
	</div>

<?php echo html_tail(); ?>