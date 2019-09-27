<!doctype html>
<html lang="en">
<head>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
  <meta charset="utf-8">
  <title>fcclient</title>
  <base href="/">

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  
  <#if FlowableModule!false>
    <!-- admin stylesheets -->

	<link rel="apple-touch-icon" sizes="180x180" href="./flowable_admin/images/apple-touch-icon.png?v=Om5N75Y123">
	<link rel="icon" type="image/png" href="./flowable_admin/images/favicon-32x32.png?v=Om5N75Y123" sizes="32x32">
	<link rel="icon" type="image/png" href="./flowable_admin/images/favicon-16x16.png?v=Om5N75Y123" sizes="16x16">
	<link rel="manifest" href="./flowable_admin/manifest.json">
	<link rel="mask-icon" href="./flowable_admin/images/safari-pinned-tab.svg?v=Om5N75Y123" color="#506d75">
	<link rel="shortcut icon" href="./flowable_admin/favicon.ico?v=Om5N75Y123">
	
	<link href="./flowable_admin/styles/bootstrap.min.css" rel="stylesheet" >
	<link href="./flowable_admin/additional_components/angular-ui-select2/select2.css" rel="stylesheet" >
	<link href="./flowable_admin/additional_components/ng-grid/ng-grid-2.0.14.min.css" rel="stylesheet" >
	<link href="./flowable_admin/additional_components/ui-grid/ui-grid.min.css" rel="stylesheet" >
	<link href="./flowable_admin/bower_components/json-formatter/json-formatter.min.css" rel="stylesheet" >
	<link href="./flowable_admin/styles/style.css" rel="stylesheet" >
	
	<!-- end admin stylesheets -->
	
	
	<!-- Admin files -->
	<!-- build:js scripts/scripts.js -->
	<script src="./flowable_admin/bower_components/jquery/jquery.js"></script>
	<script src="./flowable_admin/additional_components/angular-ui-select2/select2.min.js"></script>
	<script src="./flowable_admin/bower_components/angular/angular.min.js"></script>
	<script src="./flowable_admin/bower_components/ng-file-upload/ng-file-upload-shim.js"></script>
	<script src="./flowable_admin/bower_components/ng-file-upload/ng-file-upload.min.js"></script>
	<script src="./flowable_admin/bower_components/momentjs/momentjs.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-route/angular-route.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-resource/angular-resource.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-cookies/angular-cookies.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-sanitize/angular-sanitize.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-translate/angular-translate.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-translate-storage-cookie/angular-translate-storage-cookie.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-ui-utils/ui-utils.min.js"></script>
	<script src="./flowable_admin/additional_components/ui-grid/ui-grid.min.js"></script>
	
	<script src="./flowable_admin/bower_components/modernizr/modernizr.js"></script>
	<script src="./flowable_admin/bower_components/angular-bootstrap/ui-bootstrap.min.js"></script>
	<script src="./flowable_admin/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js"></script>
	<script src="./flowable_admin/additional_components/angular-ui-select2/angular-ui-select2.js"></script>
	<script src="./flowable_admin/additional_components/ng-grid/ng-grid-2.0.14.min.js"></script>
	<!-- <script src="./flowable_admin/bower_components/sass-bootstrap/js/affix.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/alert.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/dropdown.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/tooltip.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/modal.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/transition.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/button.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/popover.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/carousel.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/scrollspy.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/collapse.js"></script>
	<script src="./flowable_admin/bower_components/sass-bootstrap/js/tab.js"></script> -->
	<script src="./flowable_admin/bower_components/json-formatter/json-formatter.min.js"></script>


	<script src="./flowable_admin/scripts/config.js"></script>
	<script src="./flowable_admin/scripts/utils.js"></script>
	<script src="./flowable_admin/scripts/app.js"></script>
	<script src="./flowable_admin/scripts/recursion-helper.js"></script>
	<script src="./flowable_admin/scripts/controllers.js"></script>
	<script src="./flowable_admin/scripts/deployments-controllers.js"></script>
	<script src="./flowable_admin/scripts/deployment-controllers.js"></script>
	<script src="./flowable_admin/scripts/process-definitions-controllers.js"></script>
	<script src="./flowable_admin/scripts/process-definition-controllers.js"></script>
	<script src="./flowable_admin/scripts/process-instances-controllers.js"></script>
	<script src="./flowable_admin/scripts/process-instance-controllers.js"></script>
	<script src="./flowable_admin/scripts/tasks-controllers.js"></script>
	<script src="./flowable_admin/scripts/task-controllers.js"></script>
	<script src="./flowable_admin/scripts/engine-controller.js"></script>
	<script src="./flowable_admin/scripts/jobs-controllers.js"></script>
	<script src="./flowable_admin/scripts/job-controllers.js"></script>
	<script src="./flowable_admin/scripts/event-subscriptions-controllers.js"></script>
	<script src="./flowable_admin/scripts/event-subscription-controllers.js"></script>
	<script src="./flowable_admin/scripts/users-controllers.js"></script>
	<script src="./flowable_admin/scripts/services.js"></script>
	<script src="./flowable_admin/scripts/directives.js"></script>
	<script src="./flowable_admin/scripts/constants.js"></script>
	<script src="./flowable_admin/scripts/cmmn-deployments-controllers.js"></script>
	<script src="./flowable_admin/scripts/cmmn-deployment-controllers.js"></script>
	<script src="./flowable_admin/scripts/case-definitions-controllers.js"></script>
	<script src="./flowable_admin/scripts/case-definition-controllers.js"></script>
	<script src="./flowable_admin/scripts/case-instances-controllers.js"></script>
	<script src="./flowable_admin/scripts/case-instance-controllers.js"></script>
	<script src="./flowable_admin/scripts/cmmn-tasks-controllers.js"></script>
	<script src="./flowable_admin/scripts/cmmn-task-controllers.js"></script>
	<script src="./flowable_admin/scripts/cmmn-jobs-controllers.js"></script>
	<script src="./flowable_admin/scripts/cmmn-job-controllers.js"></script>
	<script src="./flowable_admin/scripts/app-deployments-controllers.js"></script>
	<script src="./flowable_admin/scripts/app-deployment-controllers.js"></script>
	<script src="./flowable_admin/scripts/app-definitions-controllers.js"></script>
	<script src="./flowable_admin/scripts/app-definition-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-table-deployments-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-table-deployment-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-tables-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-table-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-table-executions-controllers.js"></script>
	<script src="./flowable_admin/scripts/decision-table-execution-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-deployments-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-deployment-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-definitions-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-definition-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-instances-controllers.js"></script>
	<script src="./flowable_admin/scripts/form-instance-controllers.js"></script>
	<script src="./flowable_admin/scripts/content-items-controllers.js"></script>
	<script src="./flowable_admin/scripts/content-item-controllers.js"></script>
<!-- endbuild -->
<!-- Admin files end -->
  
</#if>  
</head>
<body>
  <app-root></app-root>
</body>
</html>
