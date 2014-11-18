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
                    <form class="form-horizontal" role="form">
                        <div class="row kbc-extractor-title">
                            <div class="pull-right">
                                <button type="button" class="btn btn-link kbc-btn-link-cancel">Cancel</button>
                                <button type="button" class="btn btn-success">Create</button>
                            </div>
                            <img src="https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/Google-Drive-icon-64-1.png" class="pull-left" />
                            <h2>Google Drive</h2>
                            <p>Extract spreadsheet data from Google Drive</p>
                        </div>
                        <div class="row">
                            <h3>Extractor Settings</h3>

                            <div class="form-group">
                                <div class="col-xs-4">
                                    <input type="text" class="form-control" id="inputUsername3" value="My Name">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-xs-4">
                                    <input type="text" class="form-control" id="inputAge" placeholder="Last name">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-xs-4">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox"> Agree
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

<?php echo html_tail(); ?>